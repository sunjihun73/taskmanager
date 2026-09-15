package kr.co.dbinc.task.service.user.task;

import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.company.GetCompanyDTO;
import kr.co.dbinc.task.dto.dept.GetDeptDTO;
import kr.co.dbinc.task.dto.emp.GetEmpDTO;
import kr.co.dbinc.task.mapper.task.CompanyMapper;
import kr.co.dbinc.task.mapper.task.DeptMapper;
import kr.co.dbinc.task.mapper.task.EmpMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class UserEmpService
{
  private final EmpMapper empMapper;
  private final DeptMapper deptMapper;
  private final CompanyMapper companyMapper;

  public RestResultVO getEmpList(GetEmpDTO.GetEmpRequest request)
  {
    RestResultVO rrVO = new RestResultVO();
    List<GetEmpDTO.GetEmpResponse> response = empMapper.getEmpList(request);
    int recordsCnt = empMapper.getEmpListCnt(request);

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }

  /** 직원 전체 목록 조회(소유자 포함) */
  public RestResultVO getEmpAllList(GetEmpDTO.GetEmpRequest request)
  {
    RestResultVO rrVO = new RestResultVO();
    int recordsCnt = empMapper.getEmpAllListCnt(request);
    List<GetEmpDTO.GetEmpResponse> response = empMapper.getEmpAllList(request);

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }

  public List<GetCompanyDTO.GetCompanyResponse> getCompanies(String domainId)
  {
    return companyMapper.getCompanies(domainId);
  }

  public List<GetDeptDTO.GetDeptResponse> getDepts(GetDeptDTO.GetDeptRequest request)
  {
    return deptMapper.getDepts(request);
  }

  public GetEmpDTO.GetEmpResponse getLeader(GetEmpDTO.GetEmpRequest request)
  {
    GetEmpDTO.GetEmpResponse response =  empMapper.getLeader(request);
    if(response.getEmail().equals(request.getEmail())) return new GetEmpDTO.GetEmpResponse(); //팀 리더와 로그인한 사용자가 같으면 보고대상 빈값으로 return
    return response;
  }
}
