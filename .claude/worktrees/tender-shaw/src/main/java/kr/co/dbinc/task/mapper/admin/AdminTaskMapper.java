package kr.co.dbinc.task.mapper.admin;

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
public interface AdminTaskMapper
{
  List<GetTaskDTO.GetTaskResponse> getTasksForAdmin(GetTaskListRequest request);
  int getTasksForAdminCnt(GetTaskListRequest request);
  List<GetTaskDTO.GetTaskResponse> getTasksOnlyChildForAdmin(GetTaskDTO.GetTaskResponse request);
}
