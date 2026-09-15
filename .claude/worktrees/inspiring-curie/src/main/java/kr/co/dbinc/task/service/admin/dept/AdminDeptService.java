package kr.co.dbinc.task.service.admin.dept;

import kr.co.dbinc.task.dto.company.GetCompanyDTO;
import kr.co.dbinc.task.dto.dept.GetDeptDTO;
import kr.co.dbinc.task.dto.dept.GetDeptDetailDTO;
import kr.co.dbinc.task.mapper.admin.AdminCompanyMapper;
import kr.co.dbinc.task.mapper.admin.AdminDeptMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AdminDeptService
{
  private final AdminCompanyMapper adminCompanyMapper;
  private final AdminDeptMapper adminDeptMapper;

  /** 회사별 회사목록 조회 (USE_YN='N' 포함), domainId 기준으로 조회 */
  public List<GetCompanyDTO.GetCompanyResponse> getCompanies(GetCompanyDTO.GetCompanyRequest request)
  {
    return adminCompanyMapper.getCompanies(request);
  }

  /** 부서 전체 목록 조회(사용여부:N 포함) */
  public List<GetDeptDTO.GetDeptResponse> getDeptsAll(GetDeptDTO.GetDeptRequest request)
  {
    return adminDeptMapper.getDeptsAll(request);
  }

  /** 부서상세조회 */
  public GetDeptDetailDTO.GetDeptDetailResponse getDeptDetail(GetDeptDetailDTO.GetDeptDetailRequest request)
  {
    request.setParentDeptCd(adminDeptMapper.getParentDeptCd(request));
    return adminDeptMapper.getDeptDetail(request);
  }
}
