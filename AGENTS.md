# AGENTS.md — Task Manager (kr.co.dbinc.task)

## Project Overview

Spring Boot 3.4.2 task management application. Java 17, Gradle 8.12.1, MyBatis + MySQL, JSP views, WAR deployment.
Multi-tenant SaaS — all data scoped by `domainId` + `companyCd`. Session-based auth via `SessionInfoVO`.

## Build / Run / Test Commands

```bash
# Build (skip tests)
gradlew.bat build -x test        # Windows
./gradlew build -x test           # Linux/Mac

# Run locally (uses application-local.yml)
gradlew.bat bootRun

# Run all tests
gradlew.bat test

# Run a single test class
gradlew.bat test --tests "kr.co.dbinc.task.TaskApplicationTests"

# Run a single test method
gradlew.bat test --tests "kr.co.dbinc.task.TaskApplicationTests.contextLoads"

# Build WAR / Clean build
gradlew.bat bootWar
gradlew.bat clean build
```

Testing: JUnit 5 + Spring Boot Test. Sources in `src/test/java/`.

## Architecture & Package Structure

Layered MVC: **Controller → Service → Mapper (MyBatis) → MySQL**

```
src/main/java/kr/co/dbinc/task/
  aop/              # LoggerAspect — intercepts all *Controller methods
  config/           # WebMvc, WebClient, Mailgun, XSS, RestTemplate configs
  controller/
    auth/           # SSO login/logout (AuthController) + status API (AuthRestController)
    error/          # CustomErrorController (404, 401, 500, session errors)
    file/           # FileRestController (upload/download, Azure + disk)
    user/
      label/        # Label CRUD (Controller + RestController)
      project/      # Project CRUD (Controller + RestController)
      task/         # Task CRUD, Comments, Report Tasks, Employee lookup
    admin/
      task/         # Admin task management
      emp/          # Admin user/auth management
      dept/         # Admin department management
      sync/         # EP data sync (HR integration)
  dto/              # DTOs, VOs (RestResultVO, SessionInfoVO, ResultVO)
  exception/        # ErrorCode enum, CommonException, AuthException, GlobalExceptionHandler
  interceptor/      # AuthInterceptor (session validation, NOT Spring Security)
  mapper/           # MyBatis mapper interfaces (@Mapper + @Repository)
  service/          # Business logic (concrete classes; AuthService + CalendarApiService are interfaces)
  util/             # C (constants), Util, encryption, Azure, Mailgun helpers

src/main/resources/
  mapper/{domain}/*.xml   # MyBatis SQL (task/, admin/, auth/, file/, project/, label/)
  application.yml         # Base config (port 8080, JSP prefix, MyBatis settings)
  application-local.yml / application-prod.yml
```

## Code Style & Conventions

### Formatting
- **Allman brace style** — opening brace on its own line
- **2-space indentation** (not 4, not tabs)
- Jakarta packages (`jakarta.servlet`, `jakarta.validation`) — NOT javax

```java
public class Foo
{
  public void bar()
  {
    if (condition)
    {
      // ...
    }
  }
}
```

### Imports
- Wildcard imports acceptable: `kr.co.dbinc.task.dto.task.*`
- Order: jakarta → project (kr.co.dbinc) → lombok → org.springframework → java

### Lombok (mandatory everywhere)
- `@Getter @Setter` on DTOs — never write manual getters/setters
- `@RequiredArgsConstructor` on services/controllers — DI via `private final` fields
- `@Slf4j` for logging — use `log.debug()`, `log.error()`
- `@Builder @NoArgsConstructor(force = true) @AllArgsConstructor` on request DTOs
- `@ToString` on VOs

### Naming Conventions
- **Controllers**: `User{Domain}Controller` (view), `User{Domain}RestController` (REST), `Admin{Domain}*`
- **Services**: `User{Domain}Service`, `Admin{Domain}Service` — concrete classes (not interfaces)
  - Exceptions: `AuthService` (interface → AuthServiceImpl), `CalendarApiService` (interface)
- **Mappers**: `{Domain}Mapper` interface with `@Repository @Mapper`
- **DTOs**: Nested static class pattern preferred:
  - `GetTaskDTO.GetTaskRequest` / `GetTaskDTO.GetTaskResponse`
  - Standalone: `InsertTaskRequest`, `DeleteTaskRequest`, `SetTaskStateRequest`
- **VOs**: `RestResultVO` (REST wrapper), `SessionInfoVO`, `ResultVO`
- **Constants**: All in `C.java` — `C.SUCCESS`, `C.FAIL`, `C.SESSION_INFO`
- **Fields**: camelCase matching DB columns after underscore-to-camelCase mapping

### REST API Patterns
- User endpoints: `/rest/user/**`, Admin: `/rest/admin/**`, Auth: `/api/**`, File: `/rest/files/**`
- Response wrapper: `RestResultVO` with `resultCode`, `resultMsg`, `data` (List), `dataOne` (Object)
- Pagination (DataTables): `draw`, `recordsTotal`, `recordsFiltered` on RestResultVO
- Success: `rrVO.setResultCode(C.SUCCESS); return ResponseEntity.ok(rrVO);`
- Create: `return ResponseEntity.status(HttpStatus.CREATED).build();`
- Some endpoints return `ResponseEntity<List<T>>` directly (no wrapper)
- Session extraction pattern in every endpoint:
  ```java
  SessionInfoVO si = (SessionInfoVO) session.getAttribute(C.SESSION_INFO);
  request.setDomainId(si.getDomainId());
  request.setCompanyCd(si.getCompanyCd());
  request.setEmail(si.getEmail());
  ```

### Error Handling
- Define errors in `ErrorCode` enum (HttpStatus + Korean message)
- Throw `CommonException(ErrorCode.XXX)` for business errors
- Throw `AuthException(ErrorCode.XXX)` for auth/access errors
- Throw `SyncDataException(ErrorCode.XXX)` for sync errors
- `GlobalExceptionHandler` (@RestControllerAdvice) catches CommonException, AuthException, BindException → returns `ErrorResponse`
- Controller-level try/catch is a **fallback** pattern — sets `C.FAIL` on RestResultVO, does NOT rethrow

### Logging
- Method entry: `log.debug("■ ClassName.methodName");`
- Errors: `log.error("■ ExceptionType -> details", e);`
- AOP: `LoggerAspect` auto-logs all `*Controller` method calls — don't duplicate entry logging

### Validation
- Jakarta Bean Validation: `@NotBlank`, `@NotEmpty`, `@Size`, `@Max`, `@Min`
- Korean messages: `@NotBlank(message = "태스크명이 존재하지 않습니다.")`
- Apply `@Valid` on controller method parameters

### Transaction Management
- **Read-write services**: `@Transactional` at class level (UserTaskService, FileService)
- **Read-heavy services**: `@Transactional(readOnly=true)` at class level, `@Transactional` on write methods (AdminCodeService, AdminSyncService)
- Write methods that need explicit transactions add method-level `@Transactional`

### MyBatis / Database
- XML in `src/main/resources/mapper/{domain}/` — namespace = fully qualified mapper interface
- **Nested DTO types use `$` notation**: `parameterType="kr.co.dbinc.task.dto.task.GetTaskDTO$GetTaskRequest"`
- Top-level DTOs use aliases via `type-aliases-package: kr.co.dbinc.task.dto` (e.g., `parameterType="InsertTaskRequest"`)
- Underscore-to-camelCase auto-mapping enabled
- Multi-tenancy: **always** include `DOMAIN_ID` (and usually `COMPANY_CD`) in WHERE clauses
- Soft delete: `AND (T.DEL_YN = 'N' OR T.DEL_YN IS NULL)`
- Code values: `CM{NNN}CD{NNN}` pattern (e.g., `CM001CD001` = task state "대기")

## Key Gotchas

1. **No Spring Security** — auth handled by `AuthInterceptor` + `HttpSession`. Interceptor checks session validity, ROLE_USER authority. AJAX requests detected via custom `AJAX` header (not X-Requested-With).
2. **Interceptor excludes**: `/auth/**`, `/error/**`, `/errorMsgForm/**`, `/sessionErrorForm/**`, static resources (`/css/**`, `/js/**`, `/img/**`, `/fonts/**`)
3. **WAR packaging** — app extends `ServletInitializer` for external Tomcat deployment
4. **Profiles** — `application-local.yml` has DB credentials; never commit secrets
5. **JSP views** alongside REST — controllers come in pairs (view + rest)
6. **Google Calendar integration** is largely commented out but infrastructure remains
7. **SyncDataException** is thrown in AdminSyncService but has no handler in GlobalExceptionHandler — propagates as 500
8. **Legacy exceptions** `CustomAuthException` and `InvalidStatusException` exist but are unused
