package kr.co.dbinc.task.controller.user.project;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.project.DeleteProjectRequestDTO;
import kr.co.dbinc.task.dto.project.GetProjectDTO;
import kr.co.dbinc.task.dto.project.ModifyProjectRequestDTO;
import kr.co.dbinc.task.dto.project.ProjectEmpDTO;
import kr.co.dbinc.task.dto.task.GetTaskListRequest;
import kr.co.dbinc.task.service.user.project.UserProjectService;
import kr.co.dbinc.task.util.C;
import kr.co.dbinc.task.util.Util;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/rest/user")
public class UserProjectRestController
{
  private final UserProjectService userProjectService;

  /** 프로젝트 한건 조회 : PROJECT_MASTER 한건 조회  */
  @RequestMapping (value = "/projects/{projectId}", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getProject(@PathVariable String projectId, HttpSession session)  throws Exception
  {
    log.debug("■ UserProjectRestController.getProject");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    GetProjectDTO.GetProjectRequest request = new  GetProjectDTO.GetProjectRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setProjectId(projectId);
    request.setDelYn(C.NO);
    request.setEmail(sessionInfoVO.getEmail());

    try
    {
      rrVO = userProjectService.getProject(request);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
    }
    catch (Exception e)
    {
      e.printStackTrace();
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
    }
    return ResponseEntity.ok(rrVO);
  }

  /** 내 프로젝트 목록 조회 : PROJECT_MASTER 목록 조회  */
  @RequestMapping (value = "/projects/me", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getMyProjects(@Valid GetProjectDTO.GetProjectRequest request, HttpSession session)  throws Exception
  {
    log.debug("■ UserProjectRestController.getMyProjects");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());
    request.setDelYn(C.NO);

    try
    {
      rrVO = userProjectService.getMyProjects(request);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
    }
    catch (Exception e)
    {
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
    }
    return ResponseEntity.ok(rrVO);
  }

  /** Project 한건 등록 */
  @PostMapping(value = "/projects")
  public ResponseEntity<RestResultVO> insertProjectMaster(@Valid ModifyProjectRequestDTO request, HttpSession session)  throws Exception
  {
    log.debug("■ UserProjectRestController.insertProjectMaster");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setProjectId(Util.getGuid());
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCreateUsr(sessionInfoVO.getEmail());
    request.setUpdateUsr(sessionInfoVO.getEmail());
    request.setDelYn(C.NO);

    try
    {
      rrVO = userProjectService.insertProjectMaster(request);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
    }
    catch (Exception e)
    {
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
    }

    return new ResponseEntity<>(rrVO, HttpStatus.CREATED);
  }

  /** Project 한건 저장 */
  @PutMapping(value = "/projects/{projectId}")
  public ResponseEntity<RestResultVO> updateProjectMaster(@PathVariable(value = "projectId") String projectId,
      @Valid ModifyProjectRequestDTO request, HttpSession session)  throws Exception
  {
    log.debug("■ UserProjectRestController.updateProjectMaster");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setProjectId(projectId);
    request.setCreateUsr(sessionInfoVO.getEmail());
    request.setUpdateUsr(sessionInfoVO.getEmail());

    try
    {
      rrVO = userProjectService.updateProjectMaster(request);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
    }
    catch (Exception e)
    {
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
    }

    return new ResponseEntity<>(rrVO, HttpStatus.OK);
  }

  /** 프로젝트기준 프로젝트 참여자 조회 (PROJECT_EMP 테이블 목록 조회)  */
  @RequestMapping (value = "/projects/emps/{projectId}", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getProjectsEmps(@PathVariable(value = "projectId") String projectId, ProjectEmpDTO reqProjectEmpDTO, HttpSession session)  throws Exception
  {
    log.debug("■ UserProjectRestController.getProjectsEmps");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    reqProjectEmpDTO.setProjectId(projectId);

    try
    {
      rrVO = userProjectService.getProjectsEmps(reqProjectEmpDTO);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
    }
    catch (Exception e)
    {
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
    }
    return ResponseEntity.ok(rrVO);
  }

  /** Project 한건 삭제 */
  @PatchMapping(value = "/projects/{projectId}")
  public ResponseEntity<RestResultVO> deleteProjectMaster(@PathVariable String projectId, @Valid DeleteProjectRequestDTO request, HttpSession session)  throws Exception
  {
    log.debug("■ UserProjectRestController.deleteProjectMaster");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    request.setProjectId(projectId);
    request.setDelYn(C.YES);
    request.setUpdateUsr(sessionInfoVO.getEmail());

    try
    {
      rrVO = userProjectService.deleteProjectMaster(request);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
    }
    catch (Exception e)
    {
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
    }

    return new ResponseEntity<>(rrVO, HttpStatus.CREATED);
  }

  /** 프로젝트 기준으로 프로젝트에 속한 첨부파일 목록 조회  */
  @RequestMapping (value = "/projects/files/{projectId}", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getFilesByProjects(
      @PathVariable(value = "projectId") String projectId,
      @Valid GetTaskListRequest request,
      HttpSession session)  throws Exception
  {
    log.debug("■ UserProjectRestController.getFilesByProjects");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();

    paramsMap.put("projectId", projectId);
    paramsMap.put("taskNm", request.getTaskNm());
    paramsMap.put("domainId", sessionInfoVO.getDomainId());
    paramsMap.put("companyCd", sessionInfoVO.getCompanyCd());
    paramsMap.put("draw", request.getDraw());
    paramsMap.put("start", request.getStart());
    paramsMap.put("length", request.getLength());

    try
    {
      rrVO = userProjectService.getFilesByProjects(paramsMap);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
    }
    catch (Exception e)
    {
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
    }
    return ResponseEntity.ok(rrVO);
  }
}
