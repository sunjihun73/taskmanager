package kr.co.dbinc.task.service.user.task;

import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import jakarta.validation.Valid;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.checklist.InsertCheckRequest;
import kr.co.dbinc.task.dto.comment.ChangeCommentRequest;
import kr.co.dbinc.task.dto.comment.GetCommentResponse;
import kr.co.dbinc.task.dto.emp.GetEmpDTO;
import kr.co.dbinc.task.dto.file.InsertFileRequest;
import kr.co.dbinc.task.dto.label.GetTaskLabelResponse;
import kr.co.dbinc.task.dto.label.InsertTaskLabelRequest;
import kr.co.dbinc.task.dto.task.*;
import kr.co.dbinc.task.exception.AuthException;
import kr.co.dbinc.task.exception.CommonException;
import kr.co.dbinc.task.exception.ErrorCode;
import kr.co.dbinc.task.mapper.file.FileMapper;
import kr.co.dbinc.task.mapper.task.*;
import kr.co.dbinc.task.service.calendar.CalendarApiService;
import kr.co.dbinc.task.service.calendar.CalendarServiceFactory;
import kr.co.dbinc.task.util.AzureStorageUtil;
import kr.co.dbinc.task.util.MailgunUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class UserTaskService
{
  private final EmpMapper empMapper;
  private final TaskMapper taskMapper;
  private final TaskLabelMapper taskLabelMapper;
  private final ChecklistMapper checklistMapper;
  private final FileMapper fileMapper;
  private final CommentMapper commentMapper;
  private final MailgunUtil mailgunUtil;
  private final CalendarServiceFactory calendarServiceFactory;
  private final AzureStorageUtil azureStorageUtil;

  private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();

  @Value("${storageContainerName}")
  String strgContainerName;

  public List<GetTaskDTO.GetTaskResponse> getTaskDashboard(@Valid GetTaskDTO.GetTaskRequest request)
  {
    request.setLength(5);
    if(StringUtils.hasText(request.getTaskState())) return taskMapper.getTaskDashboard(request);

    List<GetTaskDTO.GetTaskResponse> taskList = new ArrayList<>();
    request.setTaskState("CM001CD001"); taskList.addAll(taskMapper.getTaskDashboard(request));
    request.setTaskState("CM001CD002"); taskList.addAll(taskMapper.getTaskDashboard(request));
    request.setTaskState("CM001CD003"); taskList.addAll(taskMapper.getTaskDashboard(request));
    request.setTaskState("CM001CD004"); taskList.addAll(taskMapper.getTaskDashboard(request));
    return taskList;
  }

  /**
   * Project 기준으로 Task 목록 조회
   * 단 에픽(CM007CD001)과 태스크 (CM007CD002) 만을 조회하며
   * PARENT_TASK_ID가 없는 경우만 조회한다. (최상위 노드만)
   * 하위 업무는 최대 3단계까지 계층적으로 조회한다.
   * */
  public RestResultVO getTasksByProject(GetTaskListRequest request) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    int recordsCnt = taskMapper.getTasksByProjectCnt(request);
    List<GetTaskDTO.GetTaskResponse> response = taskMapper.getTasksByProject(request);

    for(GetTaskDTO.GetTaskResponse res : response)
    {
      res.setEmail(request.getEmail());

      //태스크별 라벨목록 조회해 HashMap에서 라벨ID에 해당하는 라벨명 가져와 Set
//      setTaskLabelNm(res);

      //태스크 참여자 조회
      //res.setTaskEmpList(taskMapper.getTaskEmpListForTasks(res));

      //하위업무 조회 (최대 3단계까지)
      loadChildrenRecursively(res, request.getEmail(), 1, 3);
    }

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);

    return rrVO;
  }

  /**
   * Project 기준으로 Task 목록 조회
   * 하위업무를 포함하여 계층구조를 모두 조회하고
   * 이를 계층적으로 표현한다.
   * */
  public RestResultVO getTasksTreeByProject(GetTaskListRequest request) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    List<GetTaskDTO.GetTaskResponse> response = taskMapper.getTasksTreeByProject(request);
    int recordsCnt = (response != null && !response.isEmpty()) ? response.get(0).getTotalCount() : 0;

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);

    return rrVO;
  }

  /**
   * 재귀적으로 하위 업무를 조회하는 메서드
   * @param parent 부모 태스크
   * @param email 사용자 이메일 : 현재는 의미 없는 조건으로 보임
   * @param currentDepth 현재 깊이
   * @param maxDepth 최대 깊이
   */
  private void loadChildrenRecursively(GetTaskDTO.GetTaskResponse parent, String email, int currentDepth, int maxDepth)
  {
    if (currentDepth > maxDepth) return;

    GetChildTaskRequest request = new GetChildTaskRequest();
    request.setTaskId(parent.getTaskId());
    request.setDomainId(parent.getDomainId());
    request.setCompanyCd(parent.getCompanyCd());

    //하위업무 조회
    List<GetTaskDTO.GetTaskResponse> children = taskMapper.getChildTasks(request);

    if(!children.isEmpty())
    {
      parent.setChildren(children);

      //하위업무의 재귀 호출
      for(GetTaskDTO.GetTaskResponse child : children)
      {
        child.setEmail(email);

        // 다음 단계의 하위 업무 조회
        loadChildrenRecursively(child, email, currentDepth + 1, maxDepth);
      }
    }
  }

  /** My Task 목록 조회 (테이블) */
  public RestResultVO getMyTasks(GetTaskListRequest request) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();

    int recordsCnt = taskMapper.getMyTasksCnt(request);
    List<GetTaskDTO.GetTaskResponse> response = taskMapper.getMyTasks(request);

    for(GetTaskDTO.GetTaskResponse res : response)
    {
      res.setEmail(request.getEmail());

      //하위업무 조회 (최대 3단계까지)
      loadChildrenRecursively(res, request.getEmail(), 1, 3);
    }

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);

    return rrVO;
  }

  public List<GetTaskCalendarDTO.GetTaskCalendarResponse> getTaskCalendar(GetTaskCalendarDTO.GetTaskCalendarRequest request)
  {
    return taskMapper.getTaskCalendar(request);
  }

  /**
   * @apiNote 태스크별 라벨 목록을 조회해 HashMap에서 라벨ID에 해당하는 라벨명 가져와 Set 해줌
   * @param taskReponse
   * @return taskReponse
   */
  public GetTaskDTO.GetTaskResponse setTaskLabelNm(GetTaskDTO.GetTaskResponse taskReponse)
  {
    List<GetTaskLabelResponse> childTaskLabels = taskLabelMapper.getTaskLabels(taskReponse);
    taskReponse.setLabel(childTaskLabels);
    return taskReponse;
  }

  /** Task 등록 및 구글 캘린더 일정 등록 */
  @Transactional
  public void insertTask(InsertTaskRequest request) throws Exception
  {
    //시작일, 종료일 둘 다 존재한다면 GoogleCalendar에 Event 추가
//    if(StringUtils.hasText(request.getTaskStartDt()) && StringUtils.hasText(request.getTaskEndDt()))
//    {
//      if(Integer.parseInt(request.getTaskStartDt()) > Integer.parseInt(request.getTaskEndDt())) throw new CommonException(ErrorCode.TASK_DATE_ERROR); //시작일<종료일 체크
//      try
//      {
//        CalendarApiService calendarService = calendarServiceFactory.getCalendarService(request.getOauthType());
//        String calendarEventId = calendarService.insertCalendarEvent(request);
//        request.setCalendarEventId(calendarEventId);
//      }
//      catch (Exception e)
//      {
//        e.printStackTrace();
//        log.error("Google Calendar Event 추가 중 오류 발생", e);
//        throw new CommonException(ErrorCode.GOOGLE_CALENDAR_ADD_FAIL);
//      }
//    }
    // 소유자 정보 조회 하여 TASK의 domainId, companyCd 가 결정됨.
    GetEmpDTO.GetEmpRequest taskOwnerEmpReq = new GetEmpDTO.GetEmpRequest();
    taskOwnerEmpReq.setDomainId(request.getDomainId());
    taskOwnerEmpReq.setEmail(request.getTaskOwnerMemberId());
    GetEmpDTO.GetEmpResponse empRes = empMapper.getEmp(taskOwnerEmpReq);
    request.setDomainId(empRes.getDomainId());
    request.setCompanyCd(empRes.getCompanyCd());

    taskMapper.insertTaskMaster(request);
    if(request.getCheckList() != null) insertCheckList(request);
    if(request.getFileList() != null) insertFileList(request);

    if(request.getEmpList() != null) mailgunUtil.sendTaskAddMail(request);
  }

  /** Task 한건 수정 및 구글 캘린더 일정 수정 */
  @Transactional
  public RestResultVO updateTask(InsertTaskRequest request) throws IOException, GeneralSecurityException, ParseException
  {
    RestResultVO rrVO = new RestResultVO();
    //request.setCalendarEventId(taskMapper.getCalendarEvent(request).getCalendarEventId()); //기존 캘린더 Event ID 조회

    //시작일, 종료일 둘 다 존재한다면 GoogleCalendar에 Event 수정
//    if(StringUtils.hasText(request.getTaskStartDt()) && StringUtils.hasText(request.getTaskEndDt()))
//    {
//      if(Integer.parseInt(request.getTaskStartDt()) > Integer.parseInt(request.getTaskEndDt()))
//        throw new CommonException(ErrorCode.TASK_DATE_ERROR); //시작일<종료일 체크
//
//      try
//      {
//        //기존 캘린더 이벤트가 존재했다면 update
//        if(StringUtils.hasText(request.getCalendarEventId()))
//        {
//          CalendarApiService calendarService = calendarServiceFactory.getCalendarService(request.getOauthType());
//          calendarService.updateCalendarEvent(request);
//        }
//        //없었다면 insert
//        else
//        {
//          CalendarApiService calendarService = calendarServiceFactory.getCalendarService(request.getOauthType());
//          String calendarEventId = calendarService.insertCalendarEvent(request);
//          request.setCalendarEventId(calendarEventId);
//        }
//      }
//      catch (Exception e)
//      {
//        e.printStackTrace();
//        log.error("Google Calendar Event 추가 / 수정 중 오류 발생", e);
//        throw new CommonException(ErrorCode.GOOGLE_CALENDAR_EDIT_FAIL);
//      }
//    }
//    //시작일, 종료일 둘 중 하나라도 X
//    else
//    {
//      //기존 캘린더 이벤트 존재했다면 delete
//      if(StringUtils.hasText(request.getCalendarEventId()))
//      {
//        CalendarApiService calendarService = calendarServiceFactory.getCalendarService(request.getOauthType());
//        calendarService.deleteCalendarEvent(request);
//        request.setCalendarEventId("");
//      }
//    }

    // TASK_MASTER 데이터 수정 (UPDATE)
    taskMapper.updateTaskMaster(request);

    //삭제 -> 다시 추가
    DeleteTaskRequest deleteRequest = new DeleteTaskRequest();
    deleteRequest.setDomainId(request.getDomainId());
    deleteRequest.setCompanyCd(request.getCompanyCd());
    deleteRequest.setTaskId(request.getTaskId());
    deleteRequest.setEmail(request.getCreateUsr());

    checklistMapper.deleteChecklist(deleteRequest);
    fileMapper.deleteFileList(deleteRequest);

    if(request.getCheckList() != null) insertCheckList(request);
    if(request.getFileList() != null) insertFileList(request);

    if(request.getEmpAddList() != null)
    {
      request.setEmpList(request.getEmpAddList());
      mailgunUtil.sendTaskAddMail(request);
    }

    return rrVO;
  }

  @Transactional
  public void deleteTask(DeleteTaskRequest request) throws IOException, GeneralSecurityException, ParseException
  {
    InsertTaskRequest eventRequest = new InsertTaskRequest();
    eventRequest.setTaskId(request.getTaskId());
    eventRequest.setDomainId(request.getDomainId());
    eventRequest = taskMapper.getCalendarEvent(eventRequest); //기존 캘린더 Event 조회

    if(StringUtils.hasText(eventRequest.getCalendarEventId()))
    {
      eventRequest.setDomainId(request.getDomainId());
      eventRequest.setCompanyCd(request.getCompanyCd());
      CalendarApiService calendarService = calendarServiceFactory.getCalendarService(request.getOauthType());
      calendarService.deleteCalendarEvent(eventRequest);
    }

    taskMapper.deleteTaskMaster(request); //DEL_YN을 Y로 update
  }

  // TASK 한건 상세 조회
  public RestResultVO getTaskDetail(GetTaskDetailDTO.GetTaskDetailRequest request) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    GetTaskDetailDTO.GetTaskDetailResponse response =  taskMapper.getTaskDetail(request);

    if(response == null) throw new AuthException(ErrorCode.NOT_EXIST_TASK); //존재하지 않는 태스크에 접근한 경우 에러

//    List<GetTaskEmpListResponse> empList = taskMapper.getTaskEmpList(request);
//    response.setTaskEmpList(empList);

//    // 로그인 한 사용자가 해당 태스크의 소유자도 아니고 참여자도 아니면 에러
//    if(!response.getTaskOwnerMemberId().equals(request.getEmail())
//        && empList.stream().noneMatch(emp -> emp.getEmail().equals(request.getEmail()))) {
//      throw new AuthException(ErrorCode.UNAUTHORIZED_ACCESS);
//    }

//    //태스크별 라벨목록 조회해 HashMap에서 라벨ID에 해당하는 라벨명 가져와 Set
//    List<GetTaskLabelResponse> res = taskLabelMapper.getTaskLabels(request);
//    response.setTaskLabels(res);
    response.setChecklist(checklistMapper.getChecklist(request));
    response.setChildCnt(taskMapper.getChildCnt(request));
    response.setFileList(fileMapper.getFileList(request));
    rrVO.setDataOne(response);
    return rrVO;
  }

  @Transactional
  public void updateTaskState(SetTaskStateRequest requestDTO)
  {
    int update = taskMapper.updateTaskState(requestDTO);
    if(update < 1) throw new CommonException(ErrorCode.BAD_REQUEST);
  }

  @Transactional
  public void updateTaskProgress(SetTaskProgressRequest requestDTO)
  {
    int update = taskMapper.updateTaskProgress(requestDTO);
    if(update < 1) throw new CommonException(ErrorCode.BAD_REQUEST);
  }

  /**
   * @apiNote 태스크의 소유자 및 참여자를 TASK_EMP 테이블에 INSERT 해줌.
   * @param 'InsertTaskRequest'
   */
  public void insertTaskEmp(InsertTaskRequest request)
  {
    List<InsertTaskEmpRequest> empList = request.getEmpList();

    InsertTaskEmpRequest taskEmpRequest = new InsertTaskEmpRequest();
    taskEmpRequest.setDomainId(request.getDomainId());
    taskEmpRequest.setCompanyCd(request.getCompanyCd());
    taskEmpRequest.setTaskId(request.getTaskId());
    taskEmpRequest.setCreateUsr(request.getCreateUsr());

    //소유자 추가
    taskEmpRequest.setEmail(request.getTaskOwnerMemberId());
    taskEmpRequest.setTaskEmpCd("CM004CD001");
    taskMapper.insertTaskEmp(taskEmpRequest);

    if(request.getEmpList() != null)
    {
      for(InsertTaskEmpRequest emp : empList)
      {
        taskEmpRequest.setEmail(emp.getEmail());
        taskEmpRequest.setCompanyCd(emp.getCompanyCd());
        taskEmpRequest.setTaskEmpCd(emp.getTaskEmpCd());
        taskMapper.insertTaskEmp(taskEmpRequest);
      }
    }
  }

  /**
   * @apiNote 태스크의 라벨을 TASK_LABEL 테이블에 INSERT 해줌.
   * @param 'InsertTaskRequest'
   */
  public void insertTaskLabels(InsertTaskRequest request)
  {
    List<InsertTaskLabelRequest> taskLabels = request.getTaskLabels();
    InsertTaskLabelRequest labelRequest = new InsertTaskLabelRequest();
    labelRequest.setDomainId(request.getDomainId());
    labelRequest.setCompanyCd(request.getCompanyCd());
    labelRequest.setEmail(request.getCreateUsr());
    labelRequest.setTaskId(request.getTaskId());
    for(InsertTaskLabelRequest taskLabel : taskLabels)
    {
      labelRequest.setLabelId(taskLabel.getLabelId());
      taskLabelMapper.insertTaskLabel(labelRequest);
    }
  }

  /**
   * @apiNote 태스크의 체크리스트를 CHECLIST_MASTER 테이블에 INSERT 해줌.
   * @param 'InsertTaskRequest'
   */
  public void insertCheckList(InsertTaskRequest request)
  {
    List<InsertCheckRequest> checkList = request.getCheckList();
    InsertCheckRequest checkRequest = new InsertCheckRequest();
    checkRequest.setDomainId(request.getDomainId());
    checkRequest.setCompanyCd(request.getCompanyCd());
    checkRequest.setTaskId(request.getTaskId());
    checkRequest.setCreateUsr(request.getCreateUsr());

    for(InsertCheckRequest check : checkList)
    {
      checkRequest.setCheckNm(check.getCheckNm());
      checkRequest.setCheckYn(check.getCheckYn());
      checkRequest.setCheckOrd(check.getCheckOrd());
      checklistMapper.insertChecklistMaster(checkRequest);
    }
  }

  /**
   * @apiNote 태스크의 파일 목록을 FILE_MASTER 테이블에 INSERT 해줌.
   * @param 'InsertTaskRequest'
   */
  public void insertFileList(InsertTaskRequest request)
  {
    List<InsertFileRequest> fileList = request.getFileList();
    InsertFileRequest fileRequest = new InsertFileRequest();
    fileRequest.setDomainId(request.getDomainId());
    fileRequest.setCompanyCd(request.getCompanyCd());
    fileRequest.setProjectId(request.getProjectId());
    fileRequest.setTaskId(request.getTaskId());
    fileRequest.setCreateUsr(request.getCreateUsr());

    for(InsertFileRequest file : fileList)
    {
      fileRequest.setFileNm(file.getFileNm());
      fileRequest.setFileDispNm(file.getFileDispNm());
      fileMapper.insertFileMaster(fileRequest);
    }
  }

  // TASK의 상위업무로 가능한 EPIC 목록 조회
  public RestResultVO getTasksParents(@Valid GetTaskDTO.GetTaskRequest request)
  {
    RestResultVO rrVO = new RestResultVO();
    int recordsCnt = taskMapper.getParentTasksCnt(request);
    List<GetTaskDTO.GetTaskResponse> response = taskMapper.getParentTasks(request);

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }

  public List<GetTaskDTO.GetTaskResponse> getChildTasks(@Valid GetChildTaskRequest request)
  {
    return taskMapper.getChildTasks(request);
  }

  public List<GetCommentResponse> getCommentList(GetTaskDetailDTO.GetTaskDetailRequest request)
  {
    return commentMapper.getCommentList(request);
  }

  @Transactional
  /** 태스크에 댓글 등록, 특정인에게 댓글을 달수 있음 */
  public void insertComment(ChangeCommentRequest request)
  {
    if(request.getToEmpList() == null || request.getToEmpList().isEmpty()) //댓글수신대상이 없으면 공유자 전체 SET (공유자 = 태스크가 속한 프로젝트 참여자)
      request.setToEmpList(taskMapper.getTaskEmpEmailList(request));
    else
      request.setCommentReceiverId(request.getToEmpList().get(0).getEmail()); //댓글수신대상이 존재하면 SET

    commentMapper.insertCommentMaster(request);
    if(request.getToEmpList().size() > 0) mailgunUtil.sendCommentAddMail(request);
  }

  @Transactional
  public void updateComment(ChangeCommentRequest request)
  {
    commentMapper.updateCommentMaster(request);
  }

  @Transactional
  public void deleteComment(ChangeCommentRequest request)
  {
    commentMapper.deleteCommentMaster(request);
  }

  public List<GetTaskCntForStatsDTO.GetTaskCntForStatsResponse> getTaskCntByTaskState(GetTaskCntForStatsDTO.GetTaskCntForStatsRequest request)
  {
    return taskMapper.getTaskCntByTaskState(request);
  }

  public List<GetTaskCntForStatsDTO.GetTaskCntForStatsResponse> getTaskCntByEmpAndState(GetTaskCntForStatsDTO.GetTaskCntForStatsRequest request)
  {
    return taskMapper.getTaskCntByEmpAndState(request);
  }

//  @Deprecated
//  public List<SaveFileResponse> uploadFile(List<MultipartFile> file) throws Exception
//  {
//    List<SaveFileResponse> response = new ArrayList<>();
//
//    for(int i = 0; i < file.size(); i++)
//    {
//      String fileDispName = file.get(i).getOriginalFilename();
//      String fileName = Util.getGuid() + Util.getExtension(fileDispName);
//      String directory = "D:/home/uploadFiles";
//      String filePath = Paths.get(directory, fileName).toString();
//
//      try (BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(new File(filePath))))
//      {
//        SaveFileResponse res = new SaveFileResponse();
//        res.setFileNm(fileName);
//        res.setFileDispNm(fileDispName);
//        response.add(res);
//        // 파일 서버에 쓰기
//        stream.write(file.get(i).getBytes());
//      }
//      catch (Exception e)
//      {
//        e.printStackTrace();
//        throw new Exception();
//      }
//    }
//
//    return response;
//  }

//  public List<SaveFileResponse> uploadFileToAzure(List<MultipartFile> file) throws Exception
//  {
//    List<SaveFileResponse> response = new ArrayList<>();
//
//    for(int i = 0; i < file.size(); i++)
//    {
//      fileValidation(file.get(i));
//
//      String fileDispName = file.get(i).getOriginalFilename();
//      String fileName = Util.getGuid() + Util.getExtension(fileDispName);
//
//      SaveFileResponse res = new SaveFileResponse();
//      res.setFileNm(fileName);
//      res.setFileDispNm(fileDispName);
//      response.add(res);
//
//      // Azure 파일 서버에 쓰기
//      CloudBlobClient blobClient = azureStorageUtil.getBlobClientReference();
//      CloudBlobContainer container = blobClient.getContainerReference(strgContainerName);
//      CloudBlockBlob blob = container.getBlockBlobReference(fileName);
//      blob.upload(file.get(i).getInputStream(), file.get(i).getSize());
//    }
//
//    return response;
//  }

//  public void fileValidation(MultipartFile file)
//  {
//    String[] fileTypes =  {"bmp" , "hwp", "jpg", "pdf", "png", "xls", "zip", "pptx", "xlsx", "jpeg", "doc", "gif", "csv", "tif", "txt", "docx"};
//    String fileName = file.getOriginalFilename();
//    String fileType = fileName.substring(fileName.lastIndexOf(".")+1, fileName.length()).toLowerCase();
//
//    if (fileName.length() > 100) { //파일명 길이 제한
//      throw new CommonException(ErrorCode.FILE_NAME_ERROR);
//    } else if (file.getSize() > (20 * 1024 * 1024)) { //파일 크기 제한
//      throw new CommonException(ErrorCode.FILE_VOL_ERROR);
//    } else if (fileName.lastIndexOf(".") == -1) { //파일 확장자 체크
//      throw new CommonException(ErrorCode.FILE_TYPE_ERROR);
//    } else if (!Arrays.asList(fileTypes).contains(fileType)) { //파일 타입 체크
//      throw new CommonException(ErrorCode.FILE_TYPE_ERROR);
//    }
//  }


}
