package kr.co.dbinc.task.mapper.auth;

import kr.co.dbinc.task.dto.company.CompanyMasterDTO;
import kr.co.dbinc.task.dto.emp.EmpAuthorityDTO;
import kr.co.dbinc.task.dto.emp.EmpMasterDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface AuthMapper 
{
  CompanyMasterDTO selectCompanyMaster(Map<String, Object> paramsMap);
  EmpMasterDTO selectEmpMaster(Map<String, Object> paramsMap);
  List<EmpAuthorityDTO> selectEmpAuthorityList(Map<String, Object> paramsMap);
}
