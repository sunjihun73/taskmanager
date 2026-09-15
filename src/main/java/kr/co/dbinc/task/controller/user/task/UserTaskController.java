package kr.co.dbinc.task.controller.user.task;

import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.code.CodeDTO;
import kr.co.dbinc.task.service.admin.code.AdminCodeService;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/user")
public class UserTaskController
{
  private final AdminCodeService adminCodeService;

  @GetMapping(value = "/dashboards/dashboardform")
  public ModelAndView dashboard(HttpSession session)
  {
    ModelAndView mav = new ModelAndView("/user/dashboard/dashboardForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @RequestMapping(value = "/tasks/taskaddform", method = { RequestMethod.GET, RequestMethod.POST })
  public ModelAndView insertTask(@RequestParam String projectId, HttpSession session) throws Exception
  {
    ModelAndView mav = new ModelAndView("/user/task/taskAddForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO) session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();
    List<CodeDTO> taskStateCdList = new ArrayList<>();
    List<CodeDTO> taskTypeCdList = new ArrayList<>();
    List<CodeDTO> taskImportanceCdList = new ArrayList<>();
    RestResultVO rrVO = new RestResultVO();

    // 태스크 중요도 코드
    paramsMap.put("codeDiv", "CM002");
    rrVO = adminCodeService.getCodeDetailList4SelBox(paramsMap, session);
    taskImportanceCdList = (List<CodeDTO>)rrVO.getData();

    // 태스크 상태 코드
    paramsMap.put("codeDiv", "CM001");
    rrVO = adminCodeService.getCodeDetailList4SelBox(paramsMap, session);
    taskStateCdList = (List<CodeDTO>)rrVO.getData();

    // 태스크 유형 코드
    paramsMap.put("codeDiv", "CM007");
    rrVO = adminCodeService.getCodeDetailList4SelBox(paramsMap, session);
    taskTypeCdList = (List<CodeDTO>)rrVO.getData();

    mav.addObject("TASK_IMPORTANCE_CD_LIST", taskImportanceCdList);
    mav.addObject("TASK_STATE_CD_LIST", taskStateCdList);
    mav.addObject("TASK_TYPE_CD_LIST", taskTypeCdList);
    mav.addObject("PROJECT_ID", projectId);
    mav.addObject("email", sessionInfoVO.getEmail());
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("deptCd", sessionInfoVO.getDeptCd());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @RequestMapping(value = "/tasks/taskdetailform")
  public ModelAndView taskDetail(@RequestParam String projectId, @RequestParam String taskId, HttpSession session) throws Exception
  {
    ModelAndView mav = new ModelAndView("/user/task/taskDetailForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();
    List<CodeDTO> taskStateCdList = new ArrayList<>();
    List<CodeDTO> taskImportanceCdList = new ArrayList<>();
    RestResultVO rrVO = new RestResultVO();

    // 태스크 상태 코드
    paramsMap.put("codeDiv", "CM001");
    rrVO = adminCodeService.getCodeDetailList4SelBox(paramsMap, session);
    taskStateCdList = (List<CodeDTO>)rrVO.getData();

    // 태스크 중요도 코드
    paramsMap.put("codeDiv", "CM002");
    rrVO = adminCodeService.getCodeDetailList4SelBox(paramsMap, session);
    taskImportanceCdList = (List<CodeDTO>)rrVO.getData();

    mav.addObject("PROJECT_ID", projectId);
    mav.addObject("TASK_STATE_CD_LIST", taskStateCdList);
    mav.addObject("TASK_IMPORTANCE_CD_LIST", taskImportanceCdList);
    mav.addObject("taskId", taskId);
    mav.addObject("email", sessionInfoVO.getEmail());
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("deptCd", sessionInfoVO.getDeptCd());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @GetMapping(value = "/tasks/tasksform")
  public ModelAndView taskList(HttpSession session)
  {
    ModelAndView mav = new ModelAndView("/user/task/tasksForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @GetMapping(value = "/tasks/calendarform")
  public ModelAndView calendar(HttpSession session)
  {
    ModelAndView mav = new ModelAndView("/user/task/calendarForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  @GetMapping(value = "/tasks/statisticsform")
  public ModelAndView statistics(HttpSession session)
  {
    ModelAndView mav = new ModelAndView("/user/task/statisticsForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }
}
