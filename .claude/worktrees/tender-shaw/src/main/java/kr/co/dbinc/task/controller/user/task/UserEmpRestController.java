package kr.co.dbinc.task.controller.user.task;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.company.GetCompanyDTO;
import kr.co.dbinc.task.dto.dept.GetDeptDTO;
import kr.co.dbinc.task.dto.emp.GetEmpDTO;
import kr.co.dbinc.task.service.user.task.UserEmpService;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/rest/user")
public class UserEmpRestController
{
  private final UserEmpService userEmpService;

  // 태스크 참여자 추가 목록 조회(소유자 제외)
  @GetMapping(value = "/employees")
  public ResponseEntity<RestResultVO> getEmpList(@Valid GetEmpDTO.GetEmpRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    //업무등록은 로그인 사용자(session)기준 조회/업무 상세는 소유자기준 조회이므로 분리
    if(request.getEmail() == null || request.getEmail().isEmpty()) request.setEmail(sessionInfoVO.getEmail());

    RestResultVO rrVO = userEmpService.getEmpList(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // 직원 전체 목록 조회(소유자 포함)
  @GetMapping(value = "/employees/all")
  public ResponseEntity<RestResultVO> getEmpAllList(@Valid GetEmpDTO.GetEmpRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());

    RestResultVO rrVO = userEmpService.getEmpAllList(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // 법인별 회사 목록 조회
  @GetMapping(value = "/companies")
  public ResponseEntity<List<GetCompanyDTO.GetCompanyResponse>> getCompanies(HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    List<GetCompanyDTO.GetCompanyResponse> response = userEmpService.getCompanies(sessionInfoVO.getDomainId());
    return ResponseEntity.ok(response);
  }

  // 사용중인 부서 목록 조회
  @GetMapping(value = "/depts")
  public ResponseEntity<List<GetDeptDTO.GetDeptResponse>> getDepts(GetDeptDTO.GetDeptRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);

    request.setDomainId(sessionInfoVO.getDomainId());
    List<GetDeptDTO.GetDeptResponse> response = userEmpService.getDepts(request);
    return ResponseEntity.ok(response);
  }

  // 부서의 리더 조회
  @GetMapping(value = "/leader")
  public ResponseEntity<GetEmpDTO.GetEmpResponse> getLeader(GetEmpDTO.GetEmpRequest request, HttpSession session) {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    GetEmpDTO.GetEmpResponse response = userEmpService.getLeader(request);
    return ResponseEntity.ok(response);
  }
}
