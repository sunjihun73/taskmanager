package kr.co.dbinc.task.mapper.file;

import kr.co.dbinc.task.dto.file.GetFileListResponse;
import kr.co.dbinc.task.dto.file.InsertFileRequest;
import kr.co.dbinc.task.dto.task.DeleteTaskRequest;
import kr.co.dbinc.task.dto.task.GetTaskDetailDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface FileMapper
{
  int insertFileMaster(InsertFileRequest request);
  List<GetFileListResponse>getFileList(GetTaskDetailDTO.GetTaskDetailRequest request);
  List<GetFileListResponse>getFileList2(Map<String, Object> paramsMap);
  int deleteFileList(DeleteTaskRequest request);
  int getFileListByProjectCnt(Map<String, Object> paramsMap);
  List<GetFileListResponse> getFileListByProject(Map<String, Object> paramsMap);
}
