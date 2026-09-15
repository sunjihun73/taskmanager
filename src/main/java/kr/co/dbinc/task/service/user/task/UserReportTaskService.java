package kr.co.dbinc.task.service.user.task;

import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.file.InsertFileRequest;
import kr.co.dbinc.task.dto.reporttask.InsertReportTaskDTO;
import kr.co.dbinc.task.dto.reporttask.SelectReportTaskDTO;
import kr.co.dbinc.task.dto.task.DeleteTaskRequest;
import kr.co.dbinc.task.dto.task.GetTaskEmpListResponse;
import kr.co.dbinc.task.dto.task.InsertTaskEmpRequest;
import kr.co.dbinc.task.exception.InvalidStatusException;
import kr.co.dbinc.task.mapper.file.FileMapper;
import kr.co.dbinc.task.mapper.task.ReportTaskMapper;
import kr.co.dbinc.task.util.C;
import kr.co.dbinc.task.util.MailgunUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class UserReportTaskService
{
  private final ReportTaskMapper reportTaskMapper;
  private final FileMapper fileMapper;
  private final MailgunUtil mailgunUtil;

  /** 일일업무보고 한건 상세 조회, 삭제되지 않은 건만 조회 가능 */
  public RestResultVO selectReportTaskMaster(Map<String, Object> paramsMap)
  {
    log.debug("■ ReportTaskService.selectReportTaskMaster");
    RestResultVO rrVO = new RestResultVO();
    SelectReportTaskDTO selRptTaskDTO = reportTaskMapper.selectReportTaskMaster(paramsMap);
    selRptTaskDTO.setTaskEmpList(reportTaskMapper.getReportTaskEmpList(paramsMap));
    selRptTaskDTO.setFileList(fileMapper.getFileList2(paramsMap));
    rrVO.setDataOne(selRptTaskDTO);
    return rrVO;
  }

  public RestResultVO selectReportTaskMasters(Map<String, Object> paramsMap)
  {
    log.debug("■ ReportTaskService.selectReportTaskMasters");
    RestResultVO rrVO = new RestResultVO();
    int recordsTotal = reportTaskMapper.selectReportTaskMastersCnt(paramsMap);
    List<SelectReportTaskDTO> reportTaskDTOList = reportTaskMapper.selectReportTaskMasters(paramsMap);

    for(SelectReportTaskDTO reportTask : reportTaskDTOList)
    {
      paramsMap.put("taskId", reportTask.getTaskId());
      reportTask.setTaskEmpList(reportTaskMapper.getReportTaskEmpList(paramsMap));
    }

    rrVO.setDraw(Integer.parseInt(paramsMap.get("draw").toString()));
    rrVO.setRecordsTotal(recordsTotal);
    rrVO.setRecordsFiltered(recordsTotal);
    rrVO.setData(reportTaskDTOList);

    return rrVO;
  }

  public RestResultVO selectSendReportTaskMasters(Map<String, Object> paramsMap)
  {
    log.debug("■ ReportTaskService.selectSendReportTaskMasters");
    RestResultVO rrVO = new RestResultVO();
    int recordsTotal = reportTaskMapper.selectSendReportTaskMastersCnt(paramsMap);
    List<SelectReportTaskDTO> reportTaskDTOList = reportTaskMapper.selectSendReportTaskMasters(paramsMap);

    for(SelectReportTaskDTO reportTask : reportTaskDTOList)
    {
      paramsMap.put("taskId", reportTask.getTaskId());
      reportTask.setTaskEmpList(reportTaskMapper.getReportTaskEmpList(paramsMap));
    }

    rrVO.setDraw(Integer.parseInt(paramsMap.get("draw").toString()));
    rrVO.setRecordsTotal(recordsTotal);
    rrVO.setRecordsFiltered(recordsTotal);
    rrVO.setData(reportTaskDTOList);

    return rrVO;
  }

  public RestResultVO selectRecvReportTaskMasters(Map<String, Object> paramsMap)
  {
    log.debug("■ ReportTaskService.selectRecvReportTaskMasters");
    RestResultVO rrVO = new RestResultVO();
    int recordsTotal = reportTaskMapper.selectRecvReportTaskMastersCnt(paramsMap);
    List<SelectReportTaskDTO> reportTaskDTOList = reportTaskMapper.selectRecvReportTaskMasters(paramsMap);
    for(SelectReportTaskDTO reportTask : reportTaskDTOList) {
      paramsMap.put("taskId", reportTask.getTaskId());
      reportTask.setTaskEmpList(reportTaskMapper.getReportTaskEmpList(paramsMap));
    }

    rrVO.setDraw(Integer.parseInt(paramsMap.get("draw").toString()));
    rrVO.setRecordsTotal(recordsTotal);
    rrVO.setRecordsFiltered(recordsTotal);
    rrVO.setData(reportTaskDTOList);

    return rrVO;
  }

  @Transactional
  public RestResultVO insertReportTask(InsertReportTaskDTO insRptTaskDTO) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    int r1 = reportTaskMapper.insertReportTaskMaster(insRptTaskDTO);
    insertReportTaskEmp(insRptTaskDTO);
    if(insRptTaskDTO.getFileList() != null) insertFileList(insRptTaskDTO);

    if (r1 > 0)
    {
      rrVO.setResultMsg(C.SUCCESS);
      rrVO.setResultCode(C.SUCCESS);
    }
    else
    {
      throw new Exception();
    }

    rrVO.setDataOne(insRptTaskDTO);
    rrVO.setQueryResult(r1);
    return rrVO;
  }

  @Transactional
  public RestResultVO insertReportTaskNotTemp(InsertReportTaskDTO insRptTaskDTO) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    int r1 = reportTaskMapper.insertReportTaskMaster(insRptTaskDTO);
    insertReportTaskEmp(insRptTaskDTO);
    if(insRptTaskDTO.getFileList() != null) insertFileList(insRptTaskDTO);

    if (r1 > 0)
    {
      rrVO.setResultMsg(C.SUCCESS);
      rrVO.setResultCode(C.SUCCESS);
    }
    else
    {
      throw new Exception();
    }

    // DB 처리가 정상종료 되었으면 보고 대상자에게 메일 발송
    mailgunUtil.sendRtSendMail(insRptTaskDTO.getTaskId(), insRptTaskDTO.getDomainId(), insRptTaskDTO.getCompanyCd(), insRptTaskDTO.getTaskReceiverCompanyCd(), insRptTaskDTO.getEmpList());

    rrVO.setDataOne(insRptTaskDTO);
    rrVO.setQueryResult(r1);
    return rrVO;
  }

  // 일일업무보고 임시저장건 업데이트 
  @Transactional
  public RestResultVO updateTempReportTask(InsertReportTaskDTO insRptTaskDTO) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();

    // 일일업무보고 작성자 임시저장은 TASK_STATE_CD = CM005CD001 일때만 가능하다.  
    ableUpdateTempReportTask(insRptTaskDTO.getTaskId());

    // 일일 업무보고 태스크 업데이트 
    int r1 = reportTaskMapper.updateReportTaskMaster(insRptTaskDTO);

    //보고대상 삭제 후 다시 추가
    reportTaskMapper.deleteReportTaskEmp(insRptTaskDTO);
    insertReportTaskEmp(insRptTaskDTO);

    // 파일 삭제 후 다시 추가 
    DeleteTaskRequest deleteRequest = new DeleteTaskRequest();
    deleteRequest.setDomainId(insRptTaskDTO.getDomainId());
    deleteRequest.setCompanyCd(insRptTaskDTO.getCompanyCd());
    deleteRequest.setTaskId(insRptTaskDTO.getTaskId());
    fileMapper.deleteFileList(deleteRequest);

    if(insRptTaskDTO.getFileList() != null) insertFileList(insRptTaskDTO);

    if (r1 > 0)
    {
      rrVO.setResultMsg(C.SUCCESS);
      rrVO.setResultCode(C.SUCCESS);
    }
    else
    {
      throw new Exception();
    }

    rrVO.setDataOne(insRptTaskDTO);
    rrVO.setQueryResult(r1);
    return rrVO;
  }

  /**
   * @apiNote 일일업무보고의 보고자와 보고 대상을 REPORT_TASK_EMP 테이블에 INSERT 해줌.
   * @param 'InsertTaskRequest'
   */
  public void insertReportTaskEmp(InsertReportTaskDTO request) {
    List<InsertTaskEmpRequest> empList = request.getEmpList();

    InsertTaskEmpRequest taskEmpRequest = new InsertTaskEmpRequest();
    taskEmpRequest.setDomainId(request.getDomainId());
    taskEmpRequest.setCompanyCd(request.getCompanyCd());
    taskEmpRequest.setTaskId(request.getTaskId());
    taskEmpRequest.setCreateUsr(request.getCreateUsr());

    if(request.getEmpList() != null)
    {
      for(InsertTaskEmpRequest emp : empList)
      {
        taskEmpRequest.setEmail(emp.getEmail());
        taskEmpRequest.setTaskEmpCd(emp.getTaskEmpCd());
        taskEmpRequest.setCompanyCd(emp.getCompanyCd());
        reportTaskMapper.insertReportTaskEmp(taskEmpRequest);
      }
    }
  }

  // 임시저장 일일업무보고 태스크를 보고함. 
  @Transactional
  public RestResultVO sendReportTask(InsertReportTaskDTO insRptTaskDTO) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();

    // 일일업무보고 작성자 보고는 TASK_STATE_CD = CM005CD001 일때만 가능하다.  
    ableSendReportTask(insRptTaskDTO.getTaskId());

    // 일일 업무보고 태스크 업데이트 
    int r1 = reportTaskMapper.updateReportTaskMaster(insRptTaskDTO);
    reportTaskMapper.updateReportTaskState(insRptTaskDTO);

    //보고대상 삭제 후 다시 추가
    reportTaskMapper.deleteReportTaskEmp(insRptTaskDTO);
    insertReportTaskEmp(insRptTaskDTO);

    // 파일 삭제 후 다시 추가 
    DeleteTaskRequest deleteRequest = new DeleteTaskRequest();
    deleteRequest.setDomainId(insRptTaskDTO.getDomainId());
    deleteRequest.setCompanyCd(insRptTaskDTO.getCompanyCd());
    deleteRequest.setTaskId(insRptTaskDTO.getTaskId());
    fileMapper.deleteFileList(deleteRequest);

    if(insRptTaskDTO.getFileList() != null) insertFileList(insRptTaskDTO);

    if (r1 > 0)
    {
      rrVO.setResultMsg(C.SUCCESS);
      rrVO.setResultCode(C.SUCCESS);
    }
    else
    {
      throw new Exception();
    }

    // DB 처리가 정상종료 되었으면 보고 대상자에게 메일 발송
    mailgunUtil.sendRtSendMail(insRptTaskDTO.getTaskId(), insRptTaskDTO.getDomainId(), insRptTaskDTO.getCompanyCd(), insRptTaskDTO.getTaskReceiverCompanyCd(), insRptTaskDTO.getEmpList());

    rrVO.setDataOne(insRptTaskDTO);
    rrVO.setQueryResult(r1);
    return rrVO;
  }

  public void insertFileList(InsertReportTaskDTO insRptTaskDTO)
  {
    List<InsertFileRequest> fileList = insRptTaskDTO.getFileList();
    InsertFileRequest fileRequest = new InsertFileRequest();
    fileRequest.setDomainId(insRptTaskDTO.getDomainId());
    fileRequest.setCompanyCd(insRptTaskDTO.getCompanyCd());
    fileRequest.setTaskId(insRptTaskDTO.getTaskId());
    fileRequest.setCreateUsr(insRptTaskDTO.getCreateUsr());
    fileRequest.setUpdateUsr(insRptTaskDTO.getUpdateUsr());

    for(int i = 0; i < fileList.size(); i++)
    {
      fileRequest.setFileNm(fileList.get(i).getFileNm());
      fileRequest.setFileDispNm(fileList.get(i).getFileDispNm());
      fileMapper.insertFileMaster(fileRequest);
    }
  }

  @Transactional
  public RestResultVO deleteTempReportTask(InsertReportTaskDTO insRptTaskDTO) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();

    // 일일업무보고 작성자 삭제는 TASK_STATE_CD = CM005CD001 일때만 가능하다.  
    ableDeleteTempReportTask(insRptTaskDTO.getTaskId());

    // 일일 업무보고 태스크 삭제 : DEL_YN = 'Y' 로 업데이트 
    int r1 = reportTaskMapper.deleteReportTaskMaster(insRptTaskDTO);

    if (r1 > 0)
    {
      rrVO.setResultMsg(C.SUCCESS);
      rrVO.setResultCode(C.SUCCESS);
    }
    else
    {
      throw new Exception();
    }

    rrVO.setDataOne(insRptTaskDTO);
    rrVO.setQueryResult(r1);
    return rrVO;
  }

  // 일일업무보고 수신건 업데이트 
  @Transactional
  public RestResultVO updateRecvReportTask(InsertReportTaskDTO insRptTaskDTO) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();

    // 일일업무보고 수신건 수정은 TASK_STATE_CD = CM005CD002 일때만 가능하다.  
    ableUpdateRecvReportTask(insRptTaskDTO.getTaskId());

    // 일일 업무보고 태스크 업데이트 
    int r1 = reportTaskMapper.updateReportTaskMaster(insRptTaskDTO);

    // 파일 삭제 후 다시 추가 
    DeleteTaskRequest deleteRequest = new DeleteTaskRequest();
    deleteRequest.setDomainId(insRptTaskDTO.getDomainId());
    deleteRequest.setCompanyCd(insRptTaskDTO.getCompanyCd());
    deleteRequest.setTaskId(insRptTaskDTO.getTaskId());
    fileMapper.deleteFileList(deleteRequest);

    if(insRptTaskDTO.getFileList() != null) insertFileList(insRptTaskDTO);

    if (r1 > 0)
    {
      rrVO.setResultMsg(C.SUCCESS);
      rrVO.setResultCode(C.SUCCESS);
    }
    else
    {
      throw new Exception();
    }

    rrVO.setDataOne(insRptTaskDTO);
    rrVO.setQueryResult(r1);
    return rrVO;
  }

  // 수신된 일일 업무보고 태스크 확인함.
  @Transactional
  public RestResultVO confirmRecvReportTask(InsertReportTaskDTO insRptTaskDTO) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();

    // 일일업무보고 수신자 확인은 TASK_STATE_CD = CM005CD002 일때만 가능하다.  
    ableConfirmRecvReportTask(insRptTaskDTO.getTaskId());

    // 일일 업무보고 태스크 업데이트 
    int r1 = reportTaskMapper.updateReportTaskMaster(insRptTaskDTO);
    reportTaskMapper.updateReportTaskEmp(insRptTaskDTO); // CONFIRM_YN Update

    // 모든 보고대상의 CONFIRM_YN이 "Y"일 때만 확인으로 상태 변경
    Map<String, Object> paramsMap = new HashMap<>();
    paramsMap.put("taskId", insRptTaskDTO.getTaskId());
    List<GetTaskEmpListResponse> reportTaskEmps = reportTaskMapper.getReportTaskEmpList(paramsMap);
    boolean confirmChk = true;
    for(GetTaskEmpListResponse reportTaskEmp : reportTaskEmps) {
      if(reportTaskEmp.getTaskEmpCd().isEmpty() || C.RT_STATE_CD_SEND.equals(reportTaskEmp.getTaskEmpCd())) confirmChk = false;
    }
    if(confirmChk) reportTaskMapper.updateReportTaskState(insRptTaskDTO);

    // 파일 삭제 후 다시 추가 
    DeleteTaskRequest deleteRequest = new DeleteTaskRequest();
    deleteRequest.setDomainId(insRptTaskDTO.getDomainId());
    deleteRequest.setCompanyCd(insRptTaskDTO.getCompanyCd());
    deleteRequest.setTaskId(insRptTaskDTO.getTaskId());
    fileMapper.deleteFileList(deleteRequest);

    if(insRptTaskDTO.getFileList() != null) insertFileList(insRptTaskDTO);

    if (r1 > 0)
    {
      rrVO.setResultMsg(C.SUCCESS);
      rrVO.setResultCode(C.SUCCESS);
    }
    else
    {
      throw new Exception();
    }

    // DB 처리가 정상종료 되었으면 작성자에게 리턴 메일(모든 보고대상이 확인했을 때만) 
    if(confirmChk) mailgunUtil.sendRtConfirmMail(insRptTaskDTO.getTaskId(), insRptTaskDTO.getDomainId(), insRptTaskDTO.getCompanyCd());

    rrVO.setDataOne(insRptTaskDTO);
    rrVO.setQueryResult(r1);
    return rrVO;
  }

  /**
   * @author sunjeehun
   * @apiNote 일일업무보고 작성자 임시저장이  가능한 상태인지 체크한다. (상태가 CM005CD001 일때만 작성자 임시저장이 가능하다.) 
   *          불가능하면  InvalidStatusException 을 발생시킨다. 
   * @param taskId
   * @throws InvalidStatusException
   */
  private void ableUpdateTempReportTask(String taskId) throws InvalidStatusException
  {
    checkReqStatus(taskId, C.RT_STATE_CD_TEMP);
  }

  /**
   * @author sunjeehun
   * @apiNote 일일업무보고 작성자 삭제가  가능한 상태인지 체크한다. (상태가 CM005CD001 일때만 작성자 삭제가 가능하다.) 
   *          불가능하면  InvalidStatusException 을 발생시킨다. 
   * @param taskId
   * @throws InvalidStatusException
   */
  private void ableDeleteTempReportTask(String taskId) throws InvalidStatusException
  {
    checkReqStatus(taskId, C.RT_STATE_CD_TEMP);
  }

  /**
   * @author sunjeehun
   * @apiNote 일일업무보고 작성자 보고가  가능한 상태인지 체크한다. (상태가 CM005CD001 일때만 작성자 보고가 가능하다.) 
   *          불가능하면  InvalidStatusException 을 발생시킨다. 
   * @param taskId
   * @throws InvalidStatusException
   */
  private void ableSendReportTask(String taskId) throws InvalidStatusException
  {
    checkReqStatus(taskId, C.RT_STATE_CD_TEMP);
  }

  /**
   * @author sunjeehun
   * @apiNote 일일업무보고 수신건 수정이 가능한 상태인지 체크한다. (상태가 CM005CD002 일때만 수신건 수정이 가능하다.) 
   *          불가능하면  InvalidStatusException 을 발생시킨다. 
   * @param taskId
   * @throws InvalidStatusException
   */
  private void ableUpdateRecvReportTask(String taskId) throws InvalidStatusException
  {
    checkReqStatus(taskId, C.RT_STATE_CD_SEND);
  }

  /**
   * @author sunjeehun
   * @apiNote 일일업무보고 수신자 확인이  가능한 상태인지 체크한다. (상태가 CM005CD002 일때만 수신자 확인이 가능하다.) 
   *          불가능하면  InvalidStatusException 을 발생시킨다. 
   * @param taskId
   * @throws InvalidStatusException
   */
  private void ableConfirmRecvReportTask(String taskId) throws InvalidStatusException
  {
    checkReqStatus(taskId, C.RT_STATE_CD_SEND);
  }

  /**
   * @author sunjeehun
   * @apiNote 현재의 상태를 체크하여 targetStatus가 아니면 InvalidStatusException 을 발생시킨다. 
   * @param taskId
   * @param targetStatus
   * @throws InvalidStatusException
   */
  private void checkReqStatus(String taskId, String targetStatus) throws InvalidStatusException
  {
    Map<String, Object> paramsMap = new HashMap<>();
    paramsMap.put("taskId", taskId);
    paramsMap.put("delYn", C.NO);
    SelectReportTaskDTO selectReportTaskDTO = reportTaskMapper.selectReportTaskState(paramsMap);

    try
    {
      if (selectReportTaskDTO == null)
        throw new InvalidStatusException(C.FAIL_INVALID_STATUS);
      else if (targetStatus.equals(selectReportTaskDTO.getTaskStateCd()))
        return;
      else
        throw new InvalidStatusException(C.FAIL_INVALID_STATUS);
    }
    catch (Exception e)
    {
      throw new InvalidStatusException(C.FAIL_INVALID_STATUS);
    }
  }
}
