package kr.co.dbinc.task.controller.admin.emp;

import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/admin/emps")
public class AdminEmpController
{
  @GetMapping(value = "/usermngform")
  public ModelAndView usermngform(HttpSession session)
  {
    log.debug("■ AdminEmpController.usermngform");
    ModelAndView mav = new ModelAndView("/admin/emp/userMngForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    return mav;
  }

  @RequestMapping(value = "/userdetailform")
  public ModelAndView userdetailform(@RequestParam String email, HttpSession session)
  {
    log.debug("■ AdminEmpController.userdetailform");
    ModelAndView mav = new ModelAndView("/admin/emp/userDetailForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("email", email);
    return mav;
  }

  @GetMapping(value = "/authmngform")
  public ModelAndView authmngform(HttpSession session)
  {
    log.debug("■ AdminEmpController.authmngform");
    ModelAndView mav = new ModelAndView("/admin/emp/authMngForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    return mav;
  }
}
