package kr.co.dbinc.task.mapper.task;

import kr.co.dbinc.task.dto.checklist.GetChecklistResponse;
import kr.co.dbinc.task.dto.checklist.InsertCheckRequest;
import kr.co.dbinc.task.dto.task.DeleteTaskRequest;
import kr.co.dbinc.task.dto.task.GetTaskDetailDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface ChecklistMapper
{
  int insertChecklistMaster(InsertCheckRequest request);
  List<GetChecklistResponse> getChecklist(GetTaskDetailDTO.GetTaskDetailRequest request);
  int deleteChecklist(DeleteTaskRequest request);
}
