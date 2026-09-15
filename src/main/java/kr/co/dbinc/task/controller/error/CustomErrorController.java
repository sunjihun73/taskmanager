package kr.co.dbinc.task.controller.error;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@Controller
public class CustomErrorController implements ErrorController
{
  @GetMapping("/error")
  public String handleError(HttpServletRequest request, @RequestParam(required = false) String message)
  {
    Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
    log.debug("■ CustomErrorController Received MESSAGE: " + message);
    log.debug("■ CustomErrorController Received Status: " + status);

    if (status != null)
    {
      int statusCode = Integer.valueOf(status.toString());

      if (statusCode == HttpStatus.NOT_FOUND.value())
      {
        return "/error/error404";
      }
      else if (statusCode == HttpStatus.UNAUTHORIZED.value())
      {
        return "/error/error401";
      }
      else if (statusCode == HttpStatus.INTERNAL_SERVER_ERROR.value())
      {
        return "/error/error500";
      }
      else
      {
        return "/error/error";
      }
    }

    return "/error/error";
  }

  @GetMapping("/errorMsgForm")
  public ModelAndView handleErrorWMsg(HttpServletRequest request, @RequestParam(required = false) String message)
  {
    ModelAndView mav = new ModelAndView();
    mav.addObject("message", message);
    mav.setViewName("/error/error500");
    return mav;
  }

  @GetMapping("/sessionErrorForm")
  public ModelAndView handleSessionError(HttpServletRequest request, @RequestParam(required = false) String errorCode, @RequestParam(required = false) String errorMsg)
  {
    log.debug("■ handleSessionError Received errorCode: " + errorCode);
    log.debug("■ handleSessionError Received errorMsg: " + errorMsg);
    ModelAndView mav = new ModelAndView();
    mav.addObject("error_code", errorCode);
    mav.addObject("error_msg", errorMsg);
    mav.setViewName("/error/sessionerror");
    return mav;
  }

  @GetMapping("/authErrorForm")
  public ModelAndView handleAuthError(HttpServletRequest request)
  {
    ModelAndView mav = new ModelAndView();
    mav.setViewName("/error/autherror");
    return mav;
  }

  @GetMapping("/notExistTaskErrorForm")
  public String handleNotExistTaskError(HttpServletRequest request)
  {
    return "/error/notexisterror";
  }
}
