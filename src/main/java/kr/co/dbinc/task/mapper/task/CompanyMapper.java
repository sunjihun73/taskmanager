package kr.co.dbinc.task.mapper.task;

import kr.co.dbinc.task.dto.company.GetCompanyDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface CompanyMapper
{
  List<GetCompanyDTO.GetCompanyResponse> getCompanies(String domainId);
  List<GetCompanyDTO.GetCompanyResponse> getCompaniesForMail(String domainId);
  GetCompanyDTO.GetCompanyResponse getCompanyForMail(String domainId, String companyCd);
}
