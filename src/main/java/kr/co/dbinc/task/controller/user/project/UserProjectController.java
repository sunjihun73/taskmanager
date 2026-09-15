package kr.co.dbinc.task.controller.user.project;

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
public class UserProjectController
{
  private final AdminCodeService adminCodeService;

  /** 프로젝트 추가 화면 */
  @GetMapping(value = "/projects/projectaddform")
  public ModelAndView projectAddForm(HttpSession session) throws Exception
  {
    log.debug("■ UserProjectController.projectAddForm.");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();
    List<CodeDTO> projectStateCdList = new ArrayList<>();
    RestResultVO rrVO = new RestResultVO();

    // 프로젝트 상태 코드
    paramsMap.put("codeDiv", "CM008");
    rrVO = adminCodeService.getCodeDetailList4SelBox(paramsMap, session);
    projectStateCdList = (List<CodeDTO>)rrVO.getData();

    ModelAndView mav = new ModelAndView("/user/project/projectAddForm");

    mav.addObject("PROJECT_STATE_CD_LIST", projectStateCdList);
    mav.addObject("DOMAIN_ID", sessionInfoVO.getDomainId());
    mav.addObject("COMPANY_CD", sessionInfoVO.getCompanyCd());
    mav.addObject("EMAIL", sessionInfoVO.getEmail());
    mav.addObject("DEPT_CD", sessionInfoVO.getDeptCd());
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  /** 프로젝트 목록 화면 */
  @GetMapping(value = "/projects/projectsform")
  public ModelAndView projectListForm(HttpSession session) throws Exception
  {
    log.debug("■ UserProjectController.projectListForm.");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();
    List<CodeDTO> projectStateCdList = new ArrayList<>();
    RestResultVO rrVO = new RestResultVO();

    // 프로젝트 상태 코드
    paramsMap.put("codeDiv", "CM008");
    rrVO = adminCodeService.getCodeDetailList4SelBox(paramsMap, session);
    projectStateCdList = (List<CodeDTO>)rrVO.getData();

    ModelAndView mav = new ModelAndView("/user/project/projectsForm");

    mav.addObject("PROJECT_STATE_CD_LIST", projectStateCdList);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }

  /** 프로젝트상세 (프로젝트 상세, 태스크 목록 등을 조회하는 화면) 화면 */
  @RequestMapping(value = "/projects/projectdetailform", method = { RequestMethod.POST, RequestMethod.GET })
  public ModelAndView projectDetailForm(@RequestParam String projectId, HttpSession session) throws Exception
  {
    log.debug("■ UserProjectController.projectDetailForm.");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();
    List<CodeDTO> projectStateCdList = new ArrayList<>();
    List<CodeDTO> taskStateCdList = new ArrayList<>();
    RestResultVO rrVO = new RestResultVO();

    // 프로젝트 상태 코드
    paramsMap.put("codeDiv", "CM008");
    rrVO = adminCodeService.getCodeDetailList4SelBox(paramsMap, session);
    projectStateCdList = (List<CodeDTO>)rrVO.getData();

    // 태스크 상태 코드
    paramsMap.put("codeDiv", "CM001");
    rrVO = adminCodeService.getCodeDetailList4SelBox(paramsMap, session);
    taskStateCdList = (List<CodeDTO>)rrVO.getData();

    ModelAndView mav = new ModelAndView("/user/project/projectDetailForm");

    mav.addObject("LOGIN_EMAIL", sessionInfoVO.getEmail());
    mav.addObject("PROJECT_ID", projectId);
    mav.addObject("PROJECT_STATE_CD_LIST", projectStateCdList);
    mav.addObject("TASK_STATE_CD_LIST", taskStateCdList);
    mav.addObject("DEPT_CD", sessionInfoVO.getDeptCd());
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    mav.addObject("empAuthorities", sessionInfoVO.getEmpAuthorities());
    return mav;
  }
}
