package kr.co.dbinc.task.mapper.admin;

import kr.co.dbinc.task.dto.emp.DeleteManagerDTO;
import kr.co.dbinc.task.dto.emp.GetEmpDTO;
import kr.co.dbinc.task.dto.emp.InsertManagerDTO;
import kr.co.dbinc.task.dto.emp.UpdateEmpDTO;
import kr.co.dbinc.task.dto.sync.EpSyncDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface AdminEmpMapper
{
  List<GetEmpDTO.GetEmpResponse> getEmpList(GetEmpDTO.GetEmpRequest request);
  int getEmpListCnt(GetEmpDTO.GetEmpRequest request);
  GetEmpDTO.GetEmpResponse getEmpDetail(GetEmpDTO.GetEmpRequest request);
  void updateEmpDetail(UpdateEmpDTO request);
  List<GetEmpDTO.GetEmpResponse> getManagers(GetEmpDTO.GetEmpRequest request);
  int getManagersCnt(GetEmpDTO.GetEmpRequest request);
  List<GetEmpDTO.GetEmpResponse> getUsers(GetEmpDTO.GetEmpRequest request);
  int getUsersCnt(GetEmpDTO.GetEmpRequest request);
  void insertManager(InsertManagerDTO request);
  void deleteManager(DeleteManagerDTO request);
  void deleteEmp(EpSyncDTO.EpSyncRequest request);
  void deleteEmpAuth(EpSyncDTO.EpSyncRequest request);
  void insertEmpFromSync(EpSyncDTO.EpSyncRequest request);
  void insertEmpAuthFromSync(EpSyncDTO.EpSyncRequest request);
}
