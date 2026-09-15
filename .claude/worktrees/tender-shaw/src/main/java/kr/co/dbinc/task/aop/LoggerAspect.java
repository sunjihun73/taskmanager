package kr.co.dbinc.task.aop;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.util.C;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Aspect
@Component
public class LoggerAspect
{
  @Pointcut("execution(* kr.co.dbinc.task.controller..*Controller.*(..))")
  public void loggerPointCut() {}

  @Around("loggerPointCut()")
  public Object methodLogger(ProceedingJoinPoint proceedingJoinPoint) throws Throwable
  {
    SessionInfoVO sessionInfoVO = null;
    HttpSession session = null;
    StringBuffer requestUser = new StringBuffer();

    try
    {
      Object result = proceedingJoinPoint.proceed();
      HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();

      session = request.getSession();

      if (session != null)
      {
        sessionInfoVO = (SessionInfoVO) session.getAttribute(C.SESSION_INFO);
        if (sessionInfoVO != null)
        {
          requestUser.delete(0, requestUser.length());
          requestUser.append(sessionInfoVO.getEmail());
        }
      }

      String controllerName = proceedingJoinPoint.getSignature().getDeclaringType().getSimpleName();
      String methodName = proceedingJoinPoint.getSignature().getName();
      Map<String, Object> params = new HashMap<>();

      try
      {
        params.put("request_user", requestUser.toString());
        params.put("controller", controllerName);
        params.put("method", methodName);
        params.put("params", getParams(request));
        params.put("log_time", new Date());
        params.put("request_uri", request.getRequestURI());
        params.put("http_method", request.getMethod());
      } catch (Exception e)
      {
        log.error("LoggerAspect error", e);
      }

      log.debug("==========================================================================");
      log.debug("■ TaskAOP : params : {}", formatParams(params));
      log.debug("==========================================================================");
      return result;

    } catch (Throwable throwable)
    {
      throw throwable;
    }
  }

  /**
   * Map의 모든 파라미터를 콤마(,) 기준으로 줄바꿈하여 문자열로 반환한다.
   * @param params 맵 데이터
   * @return 포맷된 문자열
   */
  private String formatParams(Map<String, Object> params)
  {
    StringBuilder formattedString = new StringBuilder();
    formattedString.append("{\n");

    int i = 0;
    for (Map.Entry<String, Object> entry : params.entrySet())
    {
      if (i > 0)
      {
        formattedString.append(",\n");
      }
      formattedString.append("    \"").append(entry.getKey()).append("\" = ");

      // params 맵 안의 params 맵을 처리하여 들여쓰기를 추가한다.
      if (entry.getValue() instanceof Map)
      {
        formattedString.append("{\n");
        Map<String, Object> innerMap = (Map<String, Object>) entry.getValue();
        int j = 0;
        for (Map.Entry<String, Object> innerEntry : innerMap.entrySet())
        {
          if (j > 0)
          {
            formattedString.append(",\n");
          }
          formattedString.append("        \"").append(innerEntry.getKey()).append("\" : \"").append(innerEntry.getValue())
              .append("\"");
          j++;
        }
        formattedString.append("\n    }");
      } else
      {
        formattedString.append("\"").append(entry.getValue()).append("\"");
      }
      i++;
    }

    formattedString.append("\n}");
    return formattedString.toString();
  }

  /**
   * request 에 담긴 정보를 Map 형태로 반환한다.
   * @param request HTTP 요청 객체
   * @return 파라미터가 담긴 Map
   */
  private Map<String, Object> getParams(HttpServletRequest request)
  {
    Map<String, Object> params = new HashMap<>();
    Enumeration<String> paramNames = request.getParameterNames();
    while (paramNames.hasMoreElements())
    {
      String param = paramNames.nextElement();
      params.put(param, request.getParameter(param));
    }
    return params;
  }
}