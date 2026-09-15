package kr.co.dbinc.task.controller.admin.task;

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
@RequestMapping(value = "/admin/tasks")
public class AdminTaskController
{
  @GetMapping(value = "/taskmngform")
  public ModelAndView taskmngform(HttpSession session)
  {
    log.debug("■ AdminTaskController.taskmngform");
    ModelAndView mav = new ModelAndView("/admin/task/taskMngForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    return mav;
  }

  @RequestMapping(value = "/taskdetailform")
  public ModelAndView taskdetailform(@RequestParam String taskId, HttpSession session)
  {
    log.debug("■ AdminTaskController.taskdetailform");
    ModelAndView mav = new ModelAndView("/admin/task/taskDetailForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("taskId", taskId);
    mav.addObject("email", sessionInfoVO.getEmail());
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    return mav;
  }
}
