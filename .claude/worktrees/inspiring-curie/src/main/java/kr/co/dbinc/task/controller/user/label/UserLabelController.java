package kr.co.dbinc.task.controller.user.label;

import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/user")
public class UserLabelController
{
  @GetMapping(value = "/labels/labelsform")
  public ModelAndView dashboard(HttpSession session)
  {
    ModelAndView mav = new ModelAndView("/user/label/labelsform");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }
}
