package kr.co.dbinc.task.controller.admin.task;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.task.DeleteTaskRequest;
import kr.co.dbinc.task.dto.task.GetTaskDetailDTO;
import kr.co.dbinc.task.dto.task.GetTaskListRequest;
import kr.co.dbinc.task.service.admin.task.AdminTaskService;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/rest/admin")
public class AdminTaskRestController
{
  private final AdminTaskService adminTaskService;

  // 업무 목록 조회 (ADMIN)
  @RequestMapping(value="/tasklist", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getTasksForAdmin(@Valid GetTaskListRequest request, HttpSession session)  throws Exception
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());

    RestResultVO rrVO = adminTaskService.getTasksForAdminWithChild(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // 업무 상세 조회
  @GetMapping(value = "/tasks/{taskId}")
  public ResponseEntity<GetTaskDetailDTO.GetTaskDetailResponse> getTaskDetailForAdmin(@PathVariable(name="taskId") String taskId, HttpSession session)  throws Exception
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    GetTaskDetailDTO.GetTaskDetailRequest request = new GetTaskDetailDTO.GetTaskDetailRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setTaskId(taskId);

    GetTaskDetailDTO.GetTaskDetailResponse response = adminTaskService.getTaskDetailForAdmin(request);
    return ResponseEntity.ok(response);
  }

  // 업무 삭제
  @DeleteMapping(value = "/tasks/{taskId}")
  public ResponseEntity<Void> deleteTaskForAdmin(@PathVariable(name="taskId") String taskId, HttpSession session)  throws Exception
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    DeleteTaskRequest request = new DeleteTaskRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setTaskId(taskId);
    request.setUpdateUsr(sessionInfoVO.getEmail());
    request.setOauthType(sessionInfoVO.getOauthType());

    adminTaskService.deleteTask(request);
    return ResponseEntity.ok().build();
  }
}
