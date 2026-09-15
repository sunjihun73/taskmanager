package kr.co.dbinc.task.controller.admin.dept;

import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.company.GetCompanyDTO;
import kr.co.dbinc.task.dto.dept.GetDeptDTO;
import kr.co.dbinc.task.dto.dept.GetDeptDetailDTO;
import kr.co.dbinc.task.service.admin.dept.AdminDeptService;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/rest/admin")
public class AdminDeptRestController
{
  private final AdminDeptService adminDeptService;

  // 회사별 회사목록 조회 (USE_YN='N' 포함)
  @GetMapping(value = "/companies")
  public ResponseEntity<List<GetCompanyDTO.GetCompanyResponse>> getCompanies(GetCompanyDTO.GetCompanyRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    request.setDomainId(sessionInfoVO.getDomainId());
    List<GetCompanyDTO.GetCompanyResponse> response = adminDeptService.getCompanies(request);
    return ResponseEntity.ok(response);
  }

  // 부서 전체 목록 조회(사용여부:N 포함)
  @GetMapping(value = "/depts/all")
  public ResponseEntity<List<GetDeptDTO.GetDeptResponse>> getDeptsAll(GetDeptDTO.GetDeptRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    request.setDomainId(sessionInfoVO.getDomainId());
//    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    List<GetDeptDTO.GetDeptResponse> response = adminDeptService.getDeptsAll(request);
    return ResponseEntity.ok(response);
  }

  // 부서상세조회
  @GetMapping(value = "/depts/{deptCd}")
  public ResponseEntity<GetDeptDetailDTO.GetDeptDetailResponse> getDeptDetail(@PathVariable(name="deptCd") String deptCd, GetDeptDetailDTO.GetDeptDetailRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    request.setDomainId(sessionInfoVO.getDomainId());
    //request.setCompanyCd(sessionInfoVO.getCompanyCd());
    GetDeptDetailDTO.GetDeptDetailResponse response = adminDeptService.getDeptDetail(request);
    return ResponseEntity.ok(response);
  }
}
