package kr.co.dbinc.task.mapper.task;

import kr.co.dbinc.task.dto.emp.GetEmpDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface EmpMapper
{
  List<GetEmpDTO.GetEmpResponse> getEmpList(GetEmpDTO.GetEmpRequest request);
  int getEmpListCnt(GetEmpDTO.GetEmpRequest request);
  List<GetEmpDTO.GetEmpResponse> getEmpAllList(GetEmpDTO.GetEmpRequest request);
  int getEmpAllListCnt(GetEmpDTO.GetEmpRequest request);
  GetEmpDTO.GetEmpResponse getLeader(GetEmpDTO.GetEmpRequest request);
  GetEmpDTO.GetEmpResponse getEmp(GetEmpDTO.GetEmpRequest request);
}
