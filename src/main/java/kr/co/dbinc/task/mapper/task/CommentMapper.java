package kr.co.dbinc.task.mapper.task;

import kr.co.dbinc.task.dto.comment.ChangeCommentRequest;
import kr.co.dbinc.task.dto.comment.GetCommentResponse;
import kr.co.dbinc.task.dto.task.DeleteTaskRequest;
import kr.co.dbinc.task.dto.task.GetTaskDetailDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface CommentMapper
{
  List<GetCommentResponse> getCommentList(GetTaskDetailDTO.GetTaskDetailRequest request);
  int insertCommentMaster(ChangeCommentRequest request);
  int updateCommentMaster(ChangeCommentRequest request);
  int deleteCommentMaster(ChangeCommentRequest request);
  int deleteCommentList(DeleteTaskRequest request);
}
