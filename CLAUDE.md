# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

## Architecture

Layered MVC: **Controller → Service → Mapper (MyBatis) → MySQL**

- **No Spring Security** — auth handled by `AuthInterceptor` + `HttpSession`. AJAX requests detected via custom `AJAX` header (not X-Requested-With).
- **JSP + REST hybrid** — controllers come in pairs: `User{Domain}Controller` (view) + `User{Domain}RestController` (REST API).
- **WAR packaging** — extends `ServletInitializer` for external Tomcat deployment.
- User endpoints: `/rest/user/**`, Admin: `/rest/admin/**`, Auth: `/api/**`, File: `/rest/files/**`
- Interceptor excludes: `/auth/**`, `/error/**`, static resources (`/css/**`, `/js/**`, `/img/**`, `/fonts/**`)
- `LoggerAspect` (AOP) auto-logs all `*Controller` method calls.

### Package Layout

```
src/main/java/kr/co/dbinc/task/
  aop/              # LoggerAspect
  config/           # WebMvc, WebClient, Mailgun, XSS, RestTemplate configs
  controller/
    auth/           # SSO login/logout + status API
    error/          # CustomErrorController (404, 401, 500, session errors)
    file/           # FileRestController (upload/download, Azure + disk)
    user/           # label/, project/, task/ — view + rest controller pairs
    admin/          # task/, emp/, dept/, sync/
  dto/              # DTOs, VOs (RestResultVO, SessionInfoVO, ResultVO)
  exception/        # ErrorCode enum, CommonException, AuthException, GlobalExceptionHandler
  interceptor/      # AuthInterceptor
  mapper/           # MyBatis mapper interfaces (@Mapper + @Repository)
  service/          # Business logic (concrete classes; AuthService + CalendarApiService are interfaces)
  util/             # C (constants), Util, encryption, Azure, Mailgun helpers

src/main/resources/
  mapper/{domain}/*.xml   # MyBatis SQL (task/, admin/, auth/, file/, project/, label/)
  application.yml         # Base config (port 8080, JSP prefix, MyBatis settings)
  application-local.yml / application-prod.yml
```

## Code Style

- **Allman brace style** — opening brace on its own line, **2-space indentation** (not 4, not tabs)
- Jakarta packages (`jakarta.servlet`, `jakarta.validation`) — NOT javax
- **Lombok mandatory**: `@Getter @Setter` on DTOs, `@RequiredArgsConstructor` on services/controllers, `@Slf4j` for logging
- Constants live in `C.java` — `C.SUCCESS`, `C.FAIL`, `C.SESSION_INFO`

### Naming Conventions

- **Controllers**: `User{Domain}Controller` (view) / `User{Domain}RestController` (REST), `Admin{Domain}*`
- **Services**: `User{Domain}Service`, `Admin{Domain}Service` — concrete classes, not interfaces (except `AuthService` and `CalendarApiService`)
- **Mappers**: `{Domain}Mapper` with `@Repository @Mapper`
- **DTOs**: Nested static class pattern preferred: `GetTaskDTO.GetTaskRequest` / `GetTaskDTO.GetTaskResponse`; standalone for simple cases: `InsertTaskRequest`, `DeleteTaskRequest`

### REST API Patterns

- Response wrapper: `RestResultVO` with `resultCode`, `resultMsg`, `data` (List), `dataOne` (Object)
- DataTables pagination: `draw`, `recordsTotal`, `recordsFiltered` on RestResultVO
- Session extraction in every endpoint:
  ```java
  SessionInfoVO si = (SessionInfoVO) session.getAttribute(C.SESSION_INFO);
  request.setDomainId(si.getDomainId());
  request.setCompanyCd(si.getCompanyCd());
  request.setEmail(si.getEmail());
  ```

### Error Handling

- Define errors in `ErrorCode` enum (HttpStatus + Korean message)
- Throw `CommonException(ErrorCode.XXX)` for business errors, `AuthException` for auth errors
- `GlobalExceptionHandler` (@RestControllerAdvice) catches these and returns `ErrorResponse`
- Controller-level try/catch is a **fallback** pattern — sets `C.FAIL` on RestResultVO, does NOT rethrow
- Validation: Jakarta Bean Validation with Korean messages: `@NotBlank(message = "태스크명이 존재하지 않습니다.")`

### MyBatis / Database

- XML in `src/main/resources/mapper/{domain}/` — namespace = fully qualified mapper interface
- **Nested DTO types use `$` notation**: `parameterType="kr.co.dbinc.task.dto.task.GetTaskDTO$GetTaskRequest"`
- Top-level DTOs use aliases via `type-aliases-package: kr.co.dbinc.task.dto` (e.g., `parameterType="InsertTaskRequest"`)
- Underscore-to-camelCase auto-mapping enabled
- Multi-tenancy: **always** include `DOMAIN_ID` (and usually `COMPANY_CD`) in WHERE clauses
- Soft delete: `AND (T.DEL_YN = 'N' OR T.DEL_YN IS NULL)`
- Code values: `CM{NNN}CD{NNN}` pattern (e.g., `CM001CD001` = task state "대기")

### Transaction Management

- Read-write services: `@Transactional` at class level (e.g., UserTaskService, FileService)
- Read-heavy services: `@Transactional(readOnly=true)` at class level, `@Transactional` on individual write methods

### Logging

- Method entry: `log.debug("■ ClassName.methodName");`
- Errors: `log.error("■ ExceptionType -> details", e);`
- Do NOT duplicate entry logging in controllers — `LoggerAspect` already covers it

## Key Gotchas

1. **SyncDataException** has no handler in `GlobalExceptionHandler` — propagates as 500
2. **Legacy exceptions** `CustomAuthException` and `InvalidStatusException` exist but are unused
3. **Google Calendar integration** is largely commented out but infrastructure remains
4. **Profiles**: `application-local.yml` / `application-prod.yml` contain DB credentials — never commit secrets
