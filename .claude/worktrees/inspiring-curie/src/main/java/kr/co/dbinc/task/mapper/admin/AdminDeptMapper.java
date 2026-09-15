package kr.co.dbinc.task.mapper.admin;

import kr.co.dbinc.task.dto.dept.GetDeptDTO;
import kr.co.dbinc.task.dto.dept.GetDeptDetailDTO;
import kr.co.dbinc.task.dto.sync.EpSyncDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface AdminDeptMapper
{
  List<GetDeptDTO.GetDeptResponse> getDeptsAll(GetDeptDTO.GetDeptRequest request);
  String getParentDeptCd(GetDeptDetailDTO.GetDeptDetailRequest request);
  GetDeptDetailDTO.GetDeptDetailResponse getDeptDetail(GetDeptDetailDTO.GetDeptDetailRequest request);
  void deleteDept(EpSyncDTO.EpSyncRequest request);
  void insertDeptFromSync(EpSyncDTO.EpSyncRequest request);
}
