package kr.co.dbinc.task.controller.admin.emp;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.emp.DeleteManagerDTO;
import kr.co.dbinc.task.dto.emp.GetEmpDTO;
import kr.co.dbinc.task.dto.emp.InsertManagerDTO;
import kr.co.dbinc.task.dto.emp.UpdateEmpDTO;
import kr.co.dbinc.task.service.admin.emp.AdminEmpService;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/rest/admin")
public class AdminEmpRestController
{
  private final AdminEmpService adminEmpService;

  // 사용자 목록 조회(숨김여부:N 포함")
  @RequestMapping(value = "/employees", method = { RequestMethod.GET, RequestMethod.POST })
  public ResponseEntity<RestResultVO> getEmpList(@Valid GetEmpDTO.GetEmpRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO) session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    //request.setCompanyCd(sessionInfoVO.getCompanyCd());

    RestResultVO rrVO = adminEmpService.getEmpList(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // 사용자 상세 조회
  @GetMapping(value = "/employees/{email}")
  public ResponseEntity<GetEmpDTO.GetEmpResponse> getEmpDetail(@PathVariable(name="email") String email,  GetEmpDTO.GetEmpRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    return ResponseEntity.ok(adminEmpService.getEmpDetail(request));
  }

  // 사용자 정보 수정
  @PutMapping(value = "/employees/{email}")
  public ResponseEntity<Void> updateEmpDetail(@PathVariable(name="email") String email,  UpdateEmpDTO request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setUpdateUsr(sessionInfoVO.getEmail());
    adminEmpService.updateEmpDetail(request);
    return ResponseEntity.status(HttpStatus.OK).build();
  }

  // 관리자 목록 조회
  @RequestMapping(value = "/managers/all", method = { RequestMethod.GET, RequestMethod.POST })
  public ResponseEntity<RestResultVO> getManagers(@Valid GetEmpDTO.GetEmpRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    //request.setCompanyCd(sessionInfoVO.getCompanyCd());

    RestResultVO rrVO = adminEmpService.getManagers(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // 관리자가 아닌 사용자 목록 조회
  @GetMapping(value = "/users")
  public ResponseEntity<RestResultVO> getUsers(@Valid GetEmpDTO.GetEmpRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    //request.setCompanyCd(sessionInfoVO.getCompanyCd());

    RestResultVO rrVO = adminEmpService.getUsers(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // 관리자 할당
  @PostMapping(value = "/managers")
  public ResponseEntity<Void> insertManager(@Valid InsertManagerDTO request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    //request.setCompanyCd(sessionInfoVO.getCompanyCd());

    request.setCreateUsr(sessionInfoVO.getEmail());
    adminEmpService.insertManager(request);
    return ResponseEntity.status(HttpStatus.CREATED).build();
  }

  // 관리자 할당 취소
  @DeleteMapping(value = "/managers")
  public ResponseEntity<Void> deleteManager(@Valid DeleteManagerDTO request, HttpSession session)
  {
    log.debug("■ AdminEmpRestController.deleteManager");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    //request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setCreateUsr(sessionInfoVO.getEmail());

    adminEmpService.deleteManager(request);
    return ResponseEntity.ok().build();
  }
}
