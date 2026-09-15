package kr.co.dbinc.task.service.admin.task;

import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.task.*;
import kr.co.dbinc.task.exception.AuthException;
import kr.co.dbinc.task.exception.ErrorCode;
import kr.co.dbinc.task.mapper.admin.AdminTaskMapper;
import kr.co.dbinc.task.mapper.file.FileMapper;
import kr.co.dbinc.task.mapper.task.ChecklistMapper;
import kr.co.dbinc.task.mapper.task.TaskMapper;
import kr.co.dbinc.task.service.calendar.CalendarApiService;
import kr.co.dbinc.task.service.calendar.CalendarServiceFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AdminTaskService
{
  private final AdminTaskMapper adminTaskMapper;
  private final TaskMapper taskMapper;
  private final ChecklistMapper checklistMapper;
  private final FileMapper fileMapper;
  private final CalendarServiceFactory calendarServiceFactory;

  public RestResultVO getTasksForAdminWithChild(GetTaskListRequest request)
  {
    RestResultVO rrVO = new RestResultVO();
    request.setChildTaskAddYn("Y");
    List<GetTaskDTO.GetTaskResponse> response = adminTaskMapper.getTasksForAdmin(request);
    int recordsCnt = adminTaskMapper.getTasksForAdminCnt(request);

    for(GetTaskDTO.GetTaskResponse res : response)
    {
      //태스크 참여자 조회
      res.setTaskEmpList(taskMapper.getTaskEmpListForTasks(res));

      //하위업무 조회
      List<GetTaskDTO.GetTaskResponse> children = adminTaskMapper.getTasksOnlyChildForAdmin(res);
      if(!children.isEmpty())
      {
        res.setChildren(children);
      }
    }

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);

    return rrVO;
  }

  public GetTaskDetailDTO.GetTaskDetailResponse getTaskDetailForAdmin(GetTaskDetailDTO.GetTaskDetailRequest request)
  {
    GetTaskDetailDTO.GetTaskDetailResponse response =  taskMapper.getTaskDetail(request);
    if(response == null) throw new AuthException(ErrorCode.NOT_EXIST_TASK);
    response.setTaskEmpList(taskMapper.getTaskEmpList(request));

    response.setChecklist(checklistMapper.getChecklist(request));
    response.setChildCnt(taskMapper.getChildCnt(request));
    response.setFileList(fileMapper.getFileList(request));
    return response;
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
}
