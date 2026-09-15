package kr.co.dbinc.task.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.emp.EmpAuthorityDTO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.util.C;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component
public class AuthInterceptor implements HandlerInterceptor
{
  @Value("${system.url}")
  String mSystemUrl;

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception
  {
    log.info("■ AuthInterceptor.preHandle");
    StringBuffer errReturnUrl = new StringBuffer();
    HttpSession session = null;
    SessionInfoVO sessionInfoVO = null;
    List<EmpAuthorityDTO> empAuthorities = new ArrayList<>();
    boolean roleCheck = false;
    String errorCode = "";

    errReturnUrl.append(mSystemUrl);
    errReturnUrl.append("sessionErrorForm");

    if (!(handler instanceof HandlerMethod))
    {
      return true;
    }

    // 세션이 있는지 체크
    session = request.getSession();

    if (session == null)
    {
      log.info("◆ Session Null");
      errorCode = C.SE_NO_SESSION;

      if (isAjaxRequest(request))
      {// AJAX 호출이면
        log.info("◆ Call Ajax Session Error");
        response.sendError(401);
        return false;
      }
      else
      {// 일반 JSP 호출이면 
        log.info("◆ Call Jsp Session Error");
        errReturnUrl.append("?errorCode=");
        errReturnUrl.append(errorCode);
        response.sendRedirect(errReturnUrl.toString());
        return false;
      }
    }

    // 세션이 존재하면 유효한 유저인지 확인
    sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    if (sessionInfoVO == null)
    {
      log.info("◆ sessionInfoVO Null");
      errorCode = C.SE_NO_SESSIONINFO_OBJ;

      if (isAjaxRequest(request))
      {// AJAX 호출이면
        log.info("◆ Call Ajax Session Error");
        response.sendError(401);
        return false;
      }
      else
      {// 일반 JSP 호출이면 
        log.info("◆ Call Jsp Session Error");
        errReturnUrl.append("?errorCode=");
        errReturnUrl.append(errorCode);
        response.sendRedirect(errReturnUrl.toString());
        return false;
      }
    }
    else
    {
      if (sessionInfoVO.getEmail() == null || "".equals(sessionInfoVO.getEmail()))
      {
        log.info("◆ Email Null or 공백");
        errorCode = C.SE_NO_EMP_EMAIL;

        if (isAjaxRequest(request))
        {// AJAX 호출이면
          log.info("◆ Call Ajax Session Error");
          response.sendError(401);
          return false;
        }
        else
        {// 일반 JSP 호출이면 
          log.info("◆ Call Jsp Session Error");
          errReturnUrl.append("?errorCode=");
          errReturnUrl.append(errorCode);
          response.sendRedirect(errReturnUrl.toString());
          return false;
        }
      }
    }

    // 유효한 유저이면 ROLE_USER 권한이 있는지 확인한다. 
    empAuthorities = sessionInfoVO.getEmpAuthorities();
    if (empAuthorities == null || empAuthorities.size() <= 0)
    {
      log.info("◆ 권한 없음");
      errorCode = C.SE_NO_EMP_AUTH_LIST;

      if (isAjaxRequest(request))
      {// AJAX 호출이면
        log.info("◆ Call Ajax Session Error");
        response.sendError(401);
        return false;
      }
      else
      {// 일반 JSP 호출이면 
        log.info("◆ Call Jsp Session Error");
        errReturnUrl.append("?errorCode=");
        errReturnUrl.append(errorCode);
        response.sendRedirect(errReturnUrl.toString());
        return false;
      }
    }

    // ROLE 리스트가 NULL이 아니면 ROLE_USER 를 가지고 있는지 체크한다. 
    for (EmpAuthorityDTO empAuth : empAuthorities)
    {
      if (C.ROLE_USER.equals(empAuth.getAuthorityName()))
      {
        roleCheck = true;
        break;
      }
    }

    if (!roleCheck)
    {
      log.info("◆ ROLE_USER 권한 없음");
      errorCode = C.SE_NO_ROLE_USER_AUTH;

      if (isAjaxRequest(request))
      {// AJAX 호출이면
        log.info("◆ Call Ajax Session Error");
        response.sendError(401);
        return false;
      }
      else
      {// 일반 JSP 호출이면 
        log.info("◆ Call Jsp Session Error");
        errReturnUrl.append("?errorCode=");
        errReturnUrl.append(errorCode);
        response.sendRedirect(errReturnUrl.toString());
        return false;
      }
    }

    log.info("◆ Session Check Success");
    return true;
  }

  @Override
  public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception
  {}

  @Override
  public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception
  {}

  private boolean isAjaxRequest(HttpServletRequest req)
  {
    String header = req.getHeader("AJAX");
    if (C.TRUE.equals(header))  return true;
    else                        return false;
  }
}
