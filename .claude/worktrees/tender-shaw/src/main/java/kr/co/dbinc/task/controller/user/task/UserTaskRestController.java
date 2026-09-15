package kr.co.dbinc.task.controller.user.task;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.comment.ChangeCommentRequest;
import kr.co.dbinc.task.dto.comment.GetCommentResponse;
import kr.co.dbinc.task.dto.task.*;
import kr.co.dbinc.task.service.user.task.UserTaskService;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/rest/user")
public class UserTaskRestController
{
  private final UserTaskService userTaskService;

  /** 대시보드 데이터 목록 조회 */
  @GetMapping(value = "/tasks/dashboards/me")
  public ResponseEntity<List<GetTaskDTO.GetTaskResponse>> getTaskDashboard(GetTaskDTO.GetTaskRequest request, HttpSession session)
  {
    log.debug("■ UserTaskRestController.getTaskDashboard");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    List<GetTaskDTO.GetTaskResponse> response = userTaskService.getTaskDashboard(request);
    return ResponseEntity.ok(response);
  }

  /** Project 기준으로 Task 목록 조회 */
  @RequestMapping (value = "/tasks/projects/{projectId}", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getTasksByProject(@PathVariable String projectId, @Valid GetTaskListRequest request, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.getTasksByProject");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setProjectId(projectId);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    try
    {
      rrVO = userTaskService.getTasksByProject(request);
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

  /** Project 기준으로 Task 트리 구조 목록 조회 */
  @RequestMapping (value = "/tasks/tree/projects/{projectId}", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getTasksTreeByProject(@PathVariable String projectId, @Valid GetTaskListRequest request, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.getTasksTreeByProject");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setProjectId(projectId);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    try
    {
      rrVO = userTaskService.getTasksTreeByProject(request);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
    }
    catch (Exception e)
    {
      log.error("getTasksTreeByProject error : {}", e.getMessage());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
    }
    return ResponseEntity.ok(rrVO);
  }

  /** Task 목록 조회 (테이블) */
  @RequestMapping (value = "/tasks/me", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getMyTasks(@Valid GetTaskListRequest request, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.getMyTasks");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    RestResultVO rrVO = userTaskService.getTasksWithChild(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // Task 목록 조회 (캘린더)
  @GetMapping(value = "/tasks/calendar")
  public ResponseEntity<List<GetTaskCalendarDTO.GetTaskCalendarResponse>> getTaskCalendar(@Valid GetTaskCalendarDTO.GetTaskCalendarRequest request, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.getTaskCalendar");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    List<GetTaskCalendarDTO.GetTaskCalendarResponse> response = userTaskService.getTaskCalendar(request);
    return ResponseEntity.ok(response);
  }

  /** Task 등록 */
  @PostMapping(value = "/tasks")
  public ResponseEntity<Void> insertTask(@Valid InsertTaskRequest request, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.insertTask");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setEpSsoApiGwUrl(sessionInfoVO.getEpSsoApiGwUrl());
    request.setEpSystemId(sessionInfoVO.getEpSystemId());
    request.setCreateUsr(sessionInfoVO.getEmail());
    request.setUpdateUsr(sessionInfoVO.getEmail());
    request.setEmpNm(sessionInfoVO.getEmpNm());
    request.setOauthType(sessionInfoVO.getOauthType());

    userTaskService.insertTask(request);
    return ResponseEntity.status(HttpStatus.CREATED).build();
  }

  /** SubTask 등록 */
  @PostMapping(value = "/subtasks")
  public ResponseEntity<Void> insertSubTask(@Valid InsertTaskRequest request, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.insertSubTask");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEpSsoApiGwUrl(sessionInfoVO.getEpSsoApiGwUrl());
    request.setEpSystemId(sessionInfoVO.getEpSystemId());
    request.setUpdateUsr(sessionInfoVO.getEmail());
    request.setCreateUsr(sessionInfoVO.getEmail());
    request.setEmpNm(sessionInfoVO.getEmpNm());
    request.setOauthType(sessionInfoVO.getOauthType());

    userTaskService.insertTask(request);
    return ResponseEntity.status(HttpStatus.CREATED).build();
  }

  // TASK 상세 조회
  @GetMapping(value = "/tasks/{taskId}")
  public ResponseEntity<RestResultVO> getTaskDetail(@PathVariable(name="taskId") String taskId, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.getTaskDetail");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    GetTaskDetailDTO.GetTaskDetailRequest request = new GetTaskDetailDTO.GetTaskDetailRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());
    request.setTaskId(taskId);

    try
    {
      rrVO = userTaskService.getTaskDetail(request);
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

  // Task 수정(저장)
  @PutMapping(value = "/tasks/{taskId}")
  public ResponseEntity<RestResultVO> updateTask(
      @PathVariable(name="taskId") String taskId,
      InsertTaskRequest request,
      HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.updateTask");
    RestResultVO rrVO = new  RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setTaskId(taskId);
    request.setEpSsoApiGwUrl(sessionInfoVO.getEpSsoApiGwUrl());
    request.setEpSystemId(sessionInfoVO.getEpSystemId());
    request.setCreateUsr(sessionInfoVO.getEmail());
    request.setUpdateUsr(sessionInfoVO.getEmail());
    request.setOauthType(sessionInfoVO.getOauthType());

    try
    {
      rrVO = userTaskService.updateTask(request);
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

  // Task 삭제
  @DeleteMapping(value = "/tasks/{taskId}")
  public ResponseEntity<Void> deleteTask(@PathVariable(name="taskId") String taskId, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.deleteTask");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    DeleteTaskRequest request = new DeleteTaskRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setTaskId(taskId);
    request.setUpdateUsr(sessionInfoVO.getEmail());
    request.setOauthType(sessionInfoVO.getOauthType());

    userTaskService.deleteTask(request);
    return ResponseEntity.ok().build();
  }

  // TASK 상태 수정
  @PatchMapping(value = "/tasks/{taskId}/editstate")
  public ResponseEntity<Void> updateTaskState(@PathVariable(name="taskId") String taskId, @Valid SetTaskStateRequest requestDTO, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.updateTaskState");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    requestDTO.setTaskId(taskId);
    requestDTO.setDomainId(sessionInfoVO.getDomainId());
    requestDTO.setUpdateUsr(sessionInfoVO.getEmail());

    userTaskService.updateTaskState(requestDTO);
    return ResponseEntity.status(HttpStatus.CREATED).build();
  }

  // TASK 진행도 수정
  @PatchMapping(value = "/tasks/{taskId}/progress")
  public ResponseEntity<Void> updateTaskProgress(@PathVariable(name="taskId") String taskId, @Valid SetTaskProgressRequest requestDTO, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.updateTaskProgress");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    requestDTO.setTaskId(taskId);
    requestDTO.setDomainId(sessionInfoVO.getDomainId());
    requestDTO.setUpdateUsr(sessionInfoVO.getEmail());

    userTaskService.updateTaskProgress(requestDTO);
    return ResponseEntity.status(HttpStatus.CREATED).build();
  }

  // SUBTASK의 상위업무로 가능한 일반 TASK목록 조회
  @RequestMapping(value = "/tasks/subtasks/parents", method = { RequestMethod.GET, RequestMethod.POST })
  public ResponseEntity<RestResultVO> getSubTasksParentTasks(GetTaskDTO.GetTaskRequest request, HttpSession session) throws Exception
  {
    log.debug("■ UserTaskRestController.getSubTasksParentTasks");
    SessionInfoVO sessionInfoVO = (SessionInfoVO) session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());
    request.setTaskTypeCd(C.TASK_TYPE_CD_TASK);

    RestResultVO rrVO = userTaskService.getTasksParents(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // TASK 의 상위업무로 가능한 EPIC 목록 조회
  @RequestMapping(value = "/tasks/parents", method = { RequestMethod.GET, RequestMethod.POST })
  public ResponseEntity<RestResultVO> getTasksParentTasks(GetTaskDTO.GetTaskRequest request, HttpSession session) throws Exception
  {
    log.debug("■ UserTaskRestController.getTasksParentTasks");
    SessionInfoVO sessionInfoVO = (SessionInfoVO) session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());
    request.setTaskTypeCd(C.TASK_TYPE_CD_EPIC);

    RestResultVO rrVO = userTaskService.getTasksParents(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // 하위업무 조회
  @GetMapping(value = "/tasks/{taskId}/childs")
  public ResponseEntity<List<GetTaskDTO.GetTaskResponse>> getChildTasks(@PathVariable(name="taskId") String taskId, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.getChildTasks");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    GetChildTaskRequest request = new GetChildTaskRequest();
    request.setTaskId(taskId);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());

    List<GetTaskDTO.GetTaskResponse> response = userTaskService.getChildTasks(request);
    return ResponseEntity.ok(response);
  }

  // 댓글 목록 조회
  @GetMapping(value = "/tasks/{taskId}/comments")
  public ResponseEntity<List<GetCommentResponse>> getCommentList(
      @PathVariable(name="taskId") String taskId,
      HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.getCommentList");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    GetTaskDetailDTO.GetTaskDetailRequest request = new GetTaskDetailDTO.GetTaskDetailRequest();
    request.setTaskId(taskId);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());

    List<GetCommentResponse> response = userTaskService.getCommentList(request);
    return ResponseEntity.ok(response);
  }

  // 댓글 등록
  @PostMapping(value = "/tasks/{taskId}/comments")
  public ResponseEntity<Void> insertComment(
      @PathVariable String taskId,
      @Valid ChangeCommentRequest request,
      HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.insertComment");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setTaskId(taskId);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEpSsoApiGwUrl(sessionInfoVO.getEpSsoApiGwUrl());
    request.setEpSystemId(sessionInfoVO.getEpSystemId());
    request.setEmail(sessionInfoVO.getEmail());
    request.setEmpNm(sessionInfoVO.getEmpNm());

    userTaskService.insertComment(request);
    return ResponseEntity.status(HttpStatus.CREATED).build();
  }

  // 댓글 수정
  @PutMapping(value = "/tasks/{taskId}/comments/{commentId}")
  public ResponseEntity<Void> updateComment(
      @PathVariable(name="commentId") String commentId,
      @PathVariable(name="taskId") String taskId,
      @Valid ChangeCommentRequest request, HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.updateComment");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setTaskId(taskId);
    request.setCommentId(commentId);

    userTaskService.updateComment(request);
    return ResponseEntity.status(HttpStatus.OK).build();
  }

  // 댓글 삭제
  @DeleteMapping(value = "/tasks/{taskId}/comments/{commentId}")
  public ResponseEntity<Void> deleteComment(
      @PathVariable(name="commentId") String commentId,
      @PathVariable(name="taskId") String taskId,
      HttpSession session)  throws Exception
  {
    log.debug("■ UserTaskRestController.deleteComment");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    @Valid
    ChangeCommentRequest request = new ChangeCommentRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setTaskId(taskId);
    request.setCommentId(commentId);

    userTaskService.deleteComment(request);
    return ResponseEntity.status(HttpStatus.OK).build();
  }

  // Task 상태별 건수 조회
  @GetMapping(value = "/tasks/taskcnt")
  public ResponseEntity<List<GetTaskCntForStatsDTO.GetTaskCntForStatsResponse>> getTaskCntByTaskState(@Valid GetTaskCntForStatsDTO.GetTaskCntForStatsRequest request, HttpSession session)  throws Exception
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    List<GetTaskCntForStatsDTO.GetTaskCntForStatsResponse> response = userTaskService.getTaskCntByTaskState(request);
    return ResponseEntity.ok(response);
  }

  // 태스크 참여 역할, 상태별 갯수 조회
  @GetMapping(value = "/tasks/taskcnt/emp")
  public ResponseEntity<List<GetTaskCntForStatsDTO.GetTaskCntForStatsResponse>> getTaskCntByEmpAndState(@Valid GetTaskCntForStatsDTO.GetTaskCntForStatsRequest request, HttpSession session)  throws Exception
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    List<GetTaskCntForStatsDTO.GetTaskCntForStatsResponse> response = userTaskService.getTaskCntByEmpAndState(request);
    return ResponseEntity.ok(response);
  }
}
