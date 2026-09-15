package kr.co.dbinc.task.mapper.task;

import kr.co.dbinc.task.dto.label.DeleteLabelRequest;
import kr.co.dbinc.task.dto.label.GetTaskLabelResponse;
import kr.co.dbinc.task.dto.label.InsertTaskLabelRequest;
import kr.co.dbinc.task.dto.task.DeleteTaskRequest;
import kr.co.dbinc.task.dto.task.GetTaskDTO;
import kr.co.dbinc.task.dto.task.GetTaskDetailDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface TaskLabelMapper
{
  List<GetTaskLabelResponse> getTaskLabels(GetTaskDTO.GetTaskResponse request);
  List<GetTaskLabelResponse> getTaskLabels(GetTaskDetailDTO.GetTaskDetailRequest request);
  int insertTaskLabel(InsertTaskLabelRequest request);
  int deleteTaskLabel(DeleteTaskRequest request);
  int deleteTaskLabelAll(DeleteTaskRequest request);
  int deleteLabel(DeleteLabelRequest request);
}
