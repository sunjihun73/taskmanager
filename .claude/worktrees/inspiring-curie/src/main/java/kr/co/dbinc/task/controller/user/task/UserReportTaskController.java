package kr.co.dbinc.task.controller.user.task;

import jakarta.servlet.http.HttpServletRequest;
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
@RequestMapping(value = "/user")
public class UserReportTaskController
{
  @GetMapping(value = "/reporttasks/reporttaskaddform")
  public ModelAndView reportTaskAddForm(HttpServletRequest request)
  {
    ModelAndView mav = new ModelAndView("/user/reporttask/reportTaskAddForm");
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptCd", sessionInfoVO.getDeptCd());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @RequestMapping(value="/reporttasks/reporttaskupdateform")
  public ModelAndView reportTaskUpdateForm(@RequestParam String pTaskId, HttpServletRequest request)
  {
    ModelAndView mav = new ModelAndView("/user/reporttask/reportTaskUpdateForm");
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptCd", sessionInfoVO.getDeptCd());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("taskId", pTaskId);
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @RequestMapping(value="/reporttasks/reporttaskviewform")
  public ModelAndView reportTaskViewForm(@RequestParam String pTaskId, HttpServletRequest request)
  {
    ModelAndView mav = new ModelAndView("/user/reporttask/reportTaskViewForm");
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("taskId", pTaskId);
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @GetMapping(value = "/reporttasks/tempreporttasksform")
  public ModelAndView tempReportTasksForm(HttpServletRequest request)
  {
    ModelAndView mav = new ModelAndView("/user/reporttask/tempReportTasksForm");
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @GetMapping(value = "/reporttasks/sendreporttasksform")
  public ModelAndView sendReportTasksForm(HttpServletRequest request)
  {
    ModelAndView mav = new ModelAndView("/user/reporttask/sendReportTasksForm");
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @GetMapping(value = "/reporttasks/recvreporttasksform")
  public ModelAndView recvReportTasksForm(HttpServletRequest request)
  {
    ModelAndView mav = new ModelAndView("/user/reporttask/recvReportTasksForm");
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @RequestMapping(value="/reporttasks/recvreporttaskupdateform")
  public ModelAndView recvReportTaskUpdateForm(@RequestParam String pTaskId, HttpServletRequest request)
  {
    ModelAndView mav = new ModelAndView("/user/reporttask/recvReportTaskUpdateForm");
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("taskId", pTaskId);
    mav.addObject("email", sessionInfoVO.getEmail());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }
}
