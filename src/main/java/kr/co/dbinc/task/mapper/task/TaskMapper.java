package kr.co.dbinc.task.mapper.task;

import kr.co.dbinc.task.dto.comment.ChangeCommentRequest;
import kr.co.dbinc.task.dto.comment.CommentEmpRequest;
import kr.co.dbinc.task.dto.task.*;
import kr.co.dbinc.task.service.calendar.dto.NaverIfConfig;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@Mapper
public interface TaskMapper
{
  List<GetTaskDTO.GetTaskResponse> getTaskDashboard(GetTaskDTO.GetTaskRequest request);

  int getTasksByProjectCnt(GetTaskListRequest request);
  List<GetTaskDTO.GetTaskResponse> getTasksByProject(GetTaskListRequest request);
  List<GetTaskDTO.GetTaskResponse> getTasksTreeByProject(GetTaskListRequest request);

  int getMyTasksCnt(GetTaskListRequest request);
  List<GetTaskDTO.GetTaskResponse> getMyTasks(GetTaskListRequest request);

  List<GetTaskDTO.GetTaskResponse> getTasks(GetTaskListRequest request);
  int getTasksCnt(GetTaskListRequest request);
  List<GetTaskDTO.GetTaskResponse> getTasksOnlyChild(GetTaskDTO.GetTaskResponse request);
  List<GetTaskEmpListResponse> getTaskEmpListForTasks(GetTaskDTO.GetTaskResponse request);
  List<GetTaskCalendarDTO.GetTaskCalendarResponse> getTaskCalendar(GetTaskCalendarDTO.GetTaskCalendarRequest request);
  int updateTaskState(SetTaskStateRequest request);
  int updateTaskProgress(SetTaskProgressRequest request);
  int insertTaskMaster(InsertTaskRequest request);
  int insertTaskEmp(InsertTaskEmpRequest request);
  List<GetTaskDTO.GetTaskResponse> getParentTasks(GetTaskDTO.GetTaskRequest request);
  int getParentTasksCnt(GetTaskDTO.GetTaskRequest request);
  GetTaskDetailDTO.GetTaskDetailResponse getTaskDetail(GetTaskDetailDTO.GetTaskDetailRequest request);
  List<GetTaskEmpListResponse> getTaskEmpList(GetTaskDetailDTO.GetTaskDetailRequest request);
  List<CommentEmpRequest> getTaskEmpEmailList(ChangeCommentRequest request);
  int getChildCnt(GetTaskDetailDTO.GetTaskDetailRequest request);
  List<GetTaskDTO.GetTaskResponse> getChildTasks(GetChildTaskRequest request);
  int deleteTaskMaster(DeleteTaskRequest request);
  int deleteTaskEmp(DeleteTaskRequest request);
  int updateTaskMaster(InsertTaskRequest request);
  List<GetTaskDTO.GetTaskResponse> getTasksForAdmin(GetTaskListRequest request);
  int getTasksForAdminCnt(GetTaskListRequest request);
  List<GetTaskDTO.GetTaskResponse> getTasksOnlyChildForAdmin(GetTaskDTO.GetTaskResponse request);
  InsertTaskRequest getCalendarEvent(InsertTaskRequest request);
  List<GetTaskCntForStatsDTO.GetTaskCntForStatsResponse> getTaskCntByTaskState(
      GetTaskCntForStatsDTO.GetTaskCntForStatsRequest request);
  List<GetTaskCntForStatsDTO.GetTaskCntForStatsResponse> getTaskCntByEmpAndState(
      GetTaskCntForStatsDTO.GetTaskCntForStatsRequest request);

  Optional<NaverIfConfig> getNaverIfConfig(InsertTaskRequest request);
} 
