package kr.co.dbinc.task.controller.auth;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.ResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.exception.CustomAuthException;
import kr.co.dbinc.task.service.auth.AuthService;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/auth")
public class AuthController
{
  private final AuthService authServiceImpl;
//  private final AuthService authServiceTestImpl;

  @RequestMapping(value="/sso/login", method={RequestMethod.GET, RequestMethod.POST})
  public String ssoLogin(
      @RequestParam(required=false, defaultValue="") String TOKEN, 
      @RequestParam(required=false, defaultValue="") String USER_ID,
      HttpServletRequest req
  ) throws Exception
  {
    log.debug("■ AuthController.ssoLogin");
    log.debug("◆ TOKEN : " + TOKEN);
    log.debug("◆ USER_ID : " + USER_ID);
    
    HttpSession session = req.getSession();
    StringBuffer returnUrl = new StringBuffer(); 
    ResultVO resultVO = new ResultVO();
    
    try
    {
      if ("".equals(TOKEN))
      {
        resultVO.setResultCode(C.FAIL);
        resultVO.setResultMsg("SSO 로그인 실패 : EP SSO 토큰이 전달되지 않았습니다.");
        throw new Exception();
      }
      else if ("".equals(USER_ID))
      {
        resultVO.setResultCode(C.FAIL);
        resultVO.setResultMsg("SSO 로그인 실패 : 사용자 USER_ID(이메일)가 전달되지 않았습니다.");
        throw new Exception();
      }
      else 
      {
        resultVO = authServiceImpl.ssoLogin(TOKEN, USER_ID);
//        resultVO = authServiceTestImpl.ssoLogin(TOKEN, USER_ID);

        if (C.SUCCESS.equals(resultVO.getResultCode()))
        {
          SessionInfoVO sessionInfoVO = (SessionInfoVO)resultVO.getDataOne();
          session.setAttribute(C.SESSION_INFO, sessionInfoVO);
          returnUrl.append("redirect:");
          returnUrl.append(resultVO.getContinueUrl());

          log.debug("◆ Result Code : " + resultVO.getResultCode());
          log.debug("◆ Result Msg : " + resultVO.getResultMsg());
          log.debug("◆ returnUrl : " + returnUrl.toString());
          log.debug("◆ sessionInfoVO : " + sessionInfoVO.toString());
          log.debug("◆ Role List : " + sessionInfoVO.getEmpAuthorities().toString());
        }
        else
        {
          session.setAttribute(C.SESSION_INFO, null);
          throw new Exception();
        }                
      }
    } 
    catch (Exception e)
    {
      e.printStackTrace();
      session.setAttribute(C.SESSION_INFO, null);
      log.debug("◆ Result Code : " + resultVO.getResultCode());
      log.debug("◆ Result Msg : " + resultVO.getResultMsg());
      throw new CustomAuthException(resultVO.getResultMsg());
    }
    
    return returnUrl.toString();
  }
  
  @RequestMapping(value="/sso/logout", method={RequestMethod.GET, RequestMethod.POST})
  public ModelAndView ssoLogout(HttpServletRequest req) throws Exception
  {
    log.debug("■ AuthController.ssoLogout");
    ModelAndView mav = new ModelAndView("/user/auth/logoutForm");
    authServiceImpl.ssoLogout(req);
//    authServiceTestImpl.ssoLogout(req);
    return mav;
  }
}
