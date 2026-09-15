package kr.co.dbinc.task.mapper.admin;

import kr.co.dbinc.task.dto.company.GetCompanyDTO;
import kr.co.dbinc.task.dto.sync.EpSyncDTO;
import kr.co.dbinc.task.dto.sync.GetSyncLogDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface AdminCompanyMapper
{
  List<EpSyncDTO.EpSyncRequest> getCompanyList();
  EpSyncDTO.EpSyncRequest getEpSyncApi(EpSyncDTO.EpSyncRequest request);
  String getTempDomainId(GetSyncLogDTO.GetSyncLogRequest request);
  List<GetCompanyDTO.GetCompanyResponse> getCompanies(GetCompanyDTO.GetCompanyRequest request);
}
