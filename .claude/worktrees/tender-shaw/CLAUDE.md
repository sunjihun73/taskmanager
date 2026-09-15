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
- Interceptor excludes: `/auth/**`, `/error/**`, static resources

## Code Style

- **Allman brace style** — opening brace on its own line, **2-space indentation**
- Jakarta packages (`jakarta.servlet`, `jakarta.validation`) — NOT javax
- **Lombok mandatory**: `@Getter @Setter` on DTOs, `@RequiredArgsConstructor` on services/controllers, `@Slf4j` for logging
- Constants live in `C.java` — `C.SUCCESS`, `C.FAIL`, `C.SESSION_INFO`

### Naming Conventions

- **Controllers**: `User{Domain}Controller` / `User{Domain}RestController`, `Admin{Domain}*`
- **Services**: `User{Domain}Service`, `Admin{Domain}Service` — concrete classes (not interfaces, except `AuthService` and `CalendarApiService`)
- **Mappers**: `{Domain}Mapper` with `@Repository @Mapper`
- **DTOs**: Nested static class pattern: `GetTaskDTO.GetTaskRequest` / `GetTaskDTO.GetTaskResponse`

### REST API Patterns

- Response wrapper: `RestResultVO` with `resultCode`, `resultMsg`, `data` (List), `dataOne` (Object)
- DataTables pagination: `draw`, `recordsTotal`, `recordsFiltered` on RestResultVO
- Session extraction in every endpoint:
  ```java
  SessionInfoVO si = (SessionInfoVO) session.getAttribute(C.SESSION_INFO);
  request.setDomainId(si.getDomainId());
  request.setCompanyCd(si.getCompanyCd());
  ```

### Error Handling

- Define errors in `ErrorCode` enum (HttpStatus + Korean message)
- Throw `CommonException(ErrorCode.XXX)` for business errors, `AuthException` for auth errors
- `GlobalExceptionHandler` catches these and returns `ErrorResponse`
- Validation: Jakarta Bean Validation with Korean messages: `@NotBlank(message = "태스크명이 존재하지 않습니다.")`

### MyBatis / Database

- XML in `src/main/resources/mapper/{domain}/`
- **Nested DTO types use `$` notation**: `parameterType="kr.co.dbinc.task.dto.task.GetTaskDTO$GetTaskRequest"`
- Top-level DTOs use aliases (e.g., `parameterType="InsertTaskRequest"`)
- Multi-tenancy: **always** include `DOMAIN_ID` (and usually `COMPANY_CD`) in WHERE clauses
- Soft delete: `AND (T.DEL_YN = 'N' OR T.DEL_YN IS NULL)`
- Code values: `CM{NNN}CD{NNN}` pattern (e.g., `CM001CD001`)

### Transaction Management

- Read-write services: `@Transactional` at class level
- Read-heavy services: `@Transactional(readOnly=true)` at class, `@Transactional` on write methods

### Logging

- Method entry: `log.debug("■ ClassName.methodName");`
- `LoggerAspect` auto-logs all `*Controller` method calls — don't duplicate entry logging in controllers

## Key Gotchas

1. **SyncDataException** has no handler in `GlobalExceptionHandler` — propagates as 500
2. **Legacy exceptions** `CustomAuthException` and `InvalidStatusException` exist but are unused
3. **Google Calendar integration** is largely commented out but infrastructure remains
4. **Profiles**: `application-local.yml` / `application-prod.yml` contain DB credentials — never commit secrets
