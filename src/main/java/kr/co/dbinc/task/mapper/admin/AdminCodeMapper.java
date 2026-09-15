package kr.co.dbinc.task.mapper.admin;

import kr.co.dbinc.task.dto.code.CodeDTO;
import kr.co.dbinc.task.dto.sync.EpSyncDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface AdminCodeMapper
{
  void deleteCode(EpSyncDTO.EpSyncRequest request);
  void updateCodeFromSync(EpSyncDTO.EpSyncRequest request);

  List<CodeDTO> getCodeDetailList4SelBox(Map<String, Object> paramsMap);
}
