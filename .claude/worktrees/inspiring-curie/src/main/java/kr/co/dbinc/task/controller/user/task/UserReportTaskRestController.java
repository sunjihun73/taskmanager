package kr.co.dbinc.task.controller.user.task;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.reporttask.InsertReportTaskDTO;
import kr.co.dbinc.task.exception.InvalidStatusException;
import kr.co.dbinc.task.service.user.task.UserReportTaskService;
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
public class UserReportTaskRestController
{
  private final UserReportTaskService userReportTaskService;

  /** 일일업무보고 한건 상세 조회, 삭제되지 않은 건만 조회 가능 */
  @GetMapping(value = "/reporttasks/{taskId}")
  public ResponseEntity<RestResultVO> selectReportTaskMaster(
      @PathVariable(name="taskId") String taskId,
      @RequestParam(required=false, defaultValue="") String email,
      HttpServletRequest request
  ) throws Exception
  {
    log.debug("■ UserReportTaskRestController.selectReportTaskMaster");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();

    paramsMap.put("taskId", taskId);
    paramsMap.put("domainId", sessionInfoVO.getDomainId());
    paramsMap.put("companyCd", sessionInfoVO.getCompanyCd());
    paramsMap.put("email", email);
    paramsMap.put("delYn", C.NO);

    try
    {
      if ("".equals(taskId))
        throw new Exception();
      else
      {
        rrVO = userReportTaskService.selectReportTaskMaster(paramsMap);
        rrVO.setResultCode(C.SUCCESS);
        rrVO.setResultMsg(C.SUCCESS);
        return new ResponseEntity<>(rrVO, HttpStatus.OK);
      }
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  /** 일일업무보고 한건 상세 조회, 삭제되지 않은 건만 조회 가능 */
  @GetMapping(value = "/reporttasks/{taskId}/temp")
  public ResponseEntity<RestResultVO> selectReportTaskMasterForTemp(
      @PathVariable(name="taskId") String taskId,
      HttpServletRequest request
  ) throws Exception
  {
    log.debug("■ UserReportTaskRestController.selectReportTaskMasterForTemp");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();

    paramsMap.put("taskId", taskId);
    paramsMap.put("domainId", sessionInfoVO.getDomainId());
    paramsMap.put("companyCd", sessionInfoVO.getCompanyCd());
    paramsMap.put("delYn", C.NO);

    try
    {
      if ("".equals(taskId))
        throw new Exception();
      else
      {
        rrVO = userReportTaskService.selectReportTaskMaster(paramsMap);
        rrVO.setResultCode(C.SUCCESS);
        rrVO.setResultMsg(C.SUCCESS);
        return new ResponseEntity<>(rrVO, HttpStatus.OK);
      }
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 나의 일일 업무보고 임시저장 목록 조회(테이블)
  @RequestMapping(value = "/reporttasks/temp/me", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> selectTempReportTaskMasters(
      @RequestParam(required=false, defaultValue="") String taskTitle,
      @RequestParam(required=false, defaultValue="") String fromDt,
      @RequestParam(required=false, defaultValue="") String toDt,
      @RequestParam(required=false, defaultValue="1") String draw,
      @RequestParam(required=false, defaultValue="1") String start,
      @RequestParam(required=false, defaultValue="5") String length,
      HttpServletRequest request
  ) throws Exception
  {
    log.debug("■ UserReportTaskRestController.selectTempReportTaskMasters");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();

    paramsMap.put("taskOwnerMemberId", sessionInfoVO.getEmail());
    paramsMap.put("domainId", sessionInfoVO.getDomainId());
    paramsMap.put("companyCd", sessionInfoVO.getCompanyCd());
    paramsMap.put("taskStateCd", C.RT_STATE_CD_TEMP);
    paramsMap.put("taskTitle", taskTitle);
    paramsMap.put("fromDt", fromDt);
    paramsMap.put("toDt", toDt);
    paramsMap.put("delYn", C.NO); // 삭제되지 않은 건만 조회 한다.
    paramsMap.put("draw", draw);
    paramsMap.put("start", start);
    paramsMap.put("length", length);

    try
    {
      rrVO = userReportTaskService.selectReportTaskMasters(paramsMap);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 나의 일일 업무보고 발신 목록 조회(테이블)
  @RequestMapping(value = "/reporttasks/send/me", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> selectSendReportTaskMasters(
      @RequestParam(required=false, defaultValue="") String taskTitle,
      @RequestParam(required=false, defaultValue="") String taskStateCd,
      @RequestParam(required=false, defaultValue="") String fromDt,
      @RequestParam(required=false, defaultValue="") String toDt,
      @RequestParam(required=false, defaultValue="1") String draw,
      @RequestParam(required=false, defaultValue="1") String start,
      @RequestParam(required=false, defaultValue="5") String length,
      HttpServletRequest request
  ) throws Exception
  {
    log.debug("■ UserReportTaskRestController.selectSendReportTaskMasters");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();

    paramsMap.put("taskOwnerMemberId", sessionInfoVO.getEmail());
    paramsMap.put("domainId", sessionInfoVO.getDomainId());
    paramsMap.put("companyCd", sessionInfoVO.getCompanyCd());
    paramsMap.put("taskTitle", taskTitle);
    paramsMap.put("taskStateCd", taskStateCd);
    paramsMap.put("fromDt", fromDt);
    paramsMap.put("toDt", toDt);
    paramsMap.put("delYn", C.NO); // 삭제되지 않은 건만 조회 한다.
    paramsMap.put("draw", draw);
    paramsMap.put("start", start);
    paramsMap.put("length", length);

    try
    {
      rrVO = userReportTaskService.selectSendReportTaskMasters(paramsMap);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 나의 일일 업무보고 수신 목록 조회(테이블)
  @RequestMapping(value = "reporttasks/recv/me", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> selectRecvReportTaskMasters(
      @RequestParam(required=false, defaultValue="") String taskTitle,
      @RequestParam(required=false, defaultValue="") String taskStateCd,
      @RequestParam(required=false, defaultValue="") String taskOnwerMemberNm,
      @RequestParam(required=false, defaultValue="") String fromDt,
      @RequestParam(required=false, defaultValue="") String toDt,
      @RequestParam(required=false, defaultValue="1") String draw,
      @RequestParam(required=false, defaultValue="1") String start,
      @RequestParam(required=false, defaultValue="5") String length,
      HttpServletRequest request
  ) throws Exception
  {
    log.debug("■ UserReportTaskRestController.selectRecvReportTaskMasters");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    Map<String, Object> paramsMap = new HashMap<>();

    paramsMap.put("taskReceiverMemberId", sessionInfoVO.getEmail());
    paramsMap.put("domainId", sessionInfoVO.getDomainId());
    paramsMap.put("companyCd", sessionInfoVO.getCompanyCd());
    paramsMap.put("taskTitle", taskTitle);
    paramsMap.put("taskStateCd", taskStateCd);
    paramsMap.put("taskOnwerMemberNm", taskOnwerMemberNm);
    paramsMap.put("fromDt", fromDt);
    paramsMap.put("toDt", toDt);
    paramsMap.put("delYn", C.NO); // 삭제되지 않은 건만 조회 한다.
    paramsMap.put("draw", draw);
    paramsMap.put("start", start);
    paramsMap.put("length", length);

    try
    {
      rrVO = userReportTaskService.selectRecvReportTaskMasters(paramsMap);
      rrVO.setResultCode(C.SUCCESS);
      rrVO.setResultMsg(C.SUCCESS);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 일일업무보고 임시저장(새로생성)
  @PostMapping(value = "/reporttasks/temp")
  public ResponseEntity<RestResultVO> insertTempReportTask(InsertReportTaskDTO insRptTaskDTO, HttpServletRequest request)  throws Exception
  {
    log.debug("■ UserReportTaskRestController.insertTempReportTask");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    insRptTaskDTO.setTaskId(Util.getUniqueKey(C.REPORT_TASK_ID_PREFIX));
    insRptTaskDTO.setDomainId(sessionInfoVO.getDomainId());
    insRptTaskDTO.setCompanyCd(sessionInfoVO.getCompanyCd());
    insRptTaskDTO.setTaskOwnerMemberId(sessionInfoVO.getEmail());
    insRptTaskDTO.setCreateUsr(sessionInfoVO.getEmail());
    insRptTaskDTO.setUpdateUsr(sessionInfoVO.getEmail());
    insRptTaskDTO.setTaskStateCd(C.RT_STATE_CD_TEMP);
    insRptTaskDTO.setDelYn(C.NO);

    try
    {
      rrVO = userReportTaskService.insertReportTask(insRptTaskDTO);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 일일업무보고 임시저장(일일 업무보고 한건 수정), TASK_STATE_CD는 수정하지 않는다.
  @PutMapping(value = "/reporttasks/temp/{taskId}")
  public ResponseEntity<RestResultVO> updateTempReportTask(
      @PathVariable(name="taskId") String taskId,
      InsertReportTaskDTO insRptTaskDTO,
      HttpServletRequest request
  )  throws Exception
  {
    log.debug("■ UserReportTaskRestController.updateTempReportTask");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    insRptTaskDTO.setTaskId(taskId);
    insRptTaskDTO.setDomainId(sessionInfoVO.getDomainId());
    insRptTaskDTO.setCompanyCd(sessionInfoVO.getCompanyCd());
    insRptTaskDTO.setUpdateUsr(sessionInfoVO.getEmail());

    try
    {
      rrVO = userReportTaskService.updateTempReportTask(insRptTaskDTO);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (InvalidStatusException ise)
    {
      log.debug(ise.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL_INVALID_STATUS);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 일일업무보고 보고(일일 업무보고 한건 보고), TASK_STATE_CD가 변경된다.
  @PutMapping(value = "/reporttasks/send/{taskId}")
  public ResponseEntity<RestResultVO> sendReportTask(
      @PathVariable(name="taskId") String taskId,
      InsertReportTaskDTO insRptTaskDTO,
      HttpServletRequest request
  ) throws Exception
  {
    log.debug("■ UserReportTaskRestController.sendReportTask");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    insRptTaskDTO.setTaskId(taskId);
    insRptTaskDTO.setDomainId(sessionInfoVO.getDomainId());
    insRptTaskDTO.setCompanyCd(sessionInfoVO.getCompanyCd());
    insRptTaskDTO.setUpdateUsr(sessionInfoVO.getEmail());
    insRptTaskDTO.setTaskStateCd(C.RT_STATE_CD_SEND);

    try
    {
      rrVO = userReportTaskService.sendReportTask(insRptTaskDTO);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (InvalidStatusException ise)
    {
      log.debug(ise.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL_INVALID_STATUS);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 일일업무보고 보고(임시저장하지 않고 바로 보고), TASK_STATE_CD가 변경된다.
  @PostMapping(value = "/reporttasks/send")
  public ResponseEntity<RestResultVO> sendReportTaskNotTemp(
      InsertReportTaskDTO insRptTaskDTO,
      HttpServletRequest request
  ) throws Exception
  {
    log.debug("■ UserReportTaskRestController.sendReportTaskNotTemp");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    insRptTaskDTO.setTaskId(Util.getUniqueKey(C.REPORT_TASK_ID_PREFIX));
    insRptTaskDTO.setDomainId(sessionInfoVO.getDomainId());
    insRptTaskDTO.setCompanyCd(sessionInfoVO.getCompanyCd());
    insRptTaskDTO.setTaskOwnerMemberId(sessionInfoVO.getEmail());
    insRptTaskDTO.setCreateUsr(sessionInfoVO.getEmail());
    insRptTaskDTO.setUpdateUsr(sessionInfoVO.getEmail());
    insRptTaskDTO.setTaskStateCd(C.RT_STATE_CD_SEND);
    insRptTaskDTO.setDelYn(C.NO);

    try
    {
      rrVO = userReportTaskService.insertReportTaskNotTemp(insRptTaskDTO);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (InvalidStatusException ise)
    {
      log.debug(ise.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL_INVALID_STATUS);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 일일업무보고 임시저장 한건 삭제(일일 업무보고 한건 삭제)
  @DeleteMapping(value = "/reporttasks/temp/{taskId}")
  public ResponseEntity<RestResultVO> deleteTempReportTask(@PathVariable(name="taskId") String taskId, HttpServletRequest request)  throws Exception
  {
    log.debug("■ UserReportTaskRestController.deleteTempReportTask");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    InsertReportTaskDTO insRptTaskDTO = new InsertReportTaskDTO();
    insRptTaskDTO.setTaskId(taskId);
    insRptTaskDTO.setUpdateUsr(sessionInfoVO.getEmail());

    try
    {
      rrVO = userReportTaskService.deleteTempReportTask(insRptTaskDTO);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (InvalidStatusException ise)
    {
      log.debug(ise.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL_INVALID_STATUS);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 일일업무보고 수신건 임시저장(일일 업무보고 수신건 한건 수정), TASK_STATE_CD는 수정하지 않는다.
  @PutMapping(value = "/reporttasks/recv/temp/{taskId}")
  public ResponseEntity<RestResultVO> updateRecvTempReportTask(
      @PathVariable(name="taskId") String taskId,
      InsertReportTaskDTO insRptTaskDTO,
      HttpServletRequest request
  )  throws Exception
  {
    log.debug("■ UserReportTaskRestController.updateRecvTempReportTask");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    insRptTaskDTO.setTaskId(taskId);
    insRptTaskDTO.setDomainId(sessionInfoVO.getDomainId());
    insRptTaskDTO.setCompanyCd(sessionInfoVO.getCompanyCd());
    insRptTaskDTO.setUpdateUsr(sessionInfoVO.getEmail());

    try
    {
      rrVO = userReportTaskService.updateRecvReportTask(insRptTaskDTO);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (InvalidStatusException ise)
    {
      log.debug(ise.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL_INVALID_STATUS);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }

  // 일일업무보고 수신건 확인(일일 업무보고 한건 확인), TASK_STATE_CD가 변경된다.
  @PutMapping(value = "/reporttasks/recv/confirm/{taskId}")
  public ResponseEntity<RestResultVO> confirmRecvReportTask(
      @PathVariable(name="taskId") String taskId,
      InsertReportTaskDTO insRptTaskDTO,
      HttpServletRequest request
  ) throws Exception
  {
    log.debug("■ UserReportTaskRestController.confirmRecvReportTask");
    RestResultVO rrVO = new RestResultVO();
    HttpSession session = request.getSession();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    insRptTaskDTO.setTaskId(taskId);
    insRptTaskDTO.setDomainId(sessionInfoVO.getDomainId());
    insRptTaskDTO.setCompanyCd(sessionInfoVO.getCompanyCd());
    insRptTaskDTO.setUpdateUsr(sessionInfoVO.getEmail());
    insRptTaskDTO.setTaskStateCd(C.RT_STATE_CD_CFM);
    insRptTaskDTO.setReportTaskCfmYn(C.YES);

    try
    {
      rrVO = userReportTaskService.confirmRecvReportTask(insRptTaskDTO);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (InvalidStatusException ise)
    {
      log.debug(ise.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL_INVALID_STATUS);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
    catch (Exception e)
    {
      log.debug(e.toString());
      rrVO.setResultCode(C.FAIL);
      rrVO.setResultMsg(C.FAIL);
      return new ResponseEntity<>(rrVO, HttpStatus.OK);
    }
  }
}
