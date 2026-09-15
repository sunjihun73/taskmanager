package kr.co.dbinc.task.controller.admin.sync;

import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.sync.EpSyncDTO;
import kr.co.dbinc.task.dto.sync.GetSyncLogDTO;
import kr.co.dbinc.task.mapper.admin.*;
import kr.co.dbinc.task.service.admin.sync.AdminSyncService;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/rest/admin")
public class AdminSyncRestController
{
  private final AdminSyncService adminSyncService;

  // EP 전체 데이터 -> sync 연동(Batch)
  @PostMapping(value = "/sync/ep")
  public ResponseEntity<Void> syncEpData()
  {
    adminSyncService.syncEpData();
    return ResponseEntity.ok().build();
  }

  // sync->DB 연동(Batch)
  @PostMapping(value = "/sync/db")
  public ResponseEntity<Void> insertSyncEpData()
  {
    adminSyncService.insertSyncEpData();
    return ResponseEntity.ok().build();
  }

  // EP 데이터와 sync 연동
  @PostMapping(value = "/sync/data")
  public ResponseEntity<Void> syncAll(EpSyncDTO.EpSyncRequest request, HttpSession session)
  {
    log.debug("■ AdminSyncRestController.syncAll.request: {}", request.toString());
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    adminSyncService.syncDataManual(request);
    return ResponseEntity.ok().build();
  }

  // EP 전체 데이터와 sync 연동
  @PostMapping(value = "/sync/all")
  public ResponseEntity<Void> syncAll( HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    EpSyncDTO.EpSyncRequest request = new EpSyncDTO.EpSyncRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    adminSyncService.syncData(request, "ALL");
    return ResponseEntity.ok().build();
  }

  // EP 사용자 데이터와 sync 연동
  @PostMapping(value = "/sync/emp")
  public ResponseEntity<Void> syncEmp(HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    EpSyncDTO.EpSyncRequest request = new EpSyncDTO.EpSyncRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    adminSyncService.syncData(request, "EMP");
    return ResponseEntity.ok().build();
  }

  // EP 부서 데이터와 sync 연동
  @PostMapping(value = "/sync/dept")
  public ResponseEntity<Void> syncDept(HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    EpSyncDTO.EpSyncRequest request = new EpSyncDTO.EpSyncRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    adminSyncService.syncData(request, "DEPT");
    return ResponseEntity.ok().build();
  }

  // EP 코드 데이터와 sync 연동
  @PostMapping(value = "/sync/code")
  public ResponseEntity<Void> syncCode(HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    EpSyncDTO.EpSyncRequest request = new EpSyncDTO.EpSyncRequest();
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    //    apiService.syncData(request, "CODE");
    return ResponseEntity.ok().build();
  }

  // EP 데이터 연동 History 조회
  @GetMapping(value = "/sync/logs")
  public ResponseEntity<RestResultVO> getSyncLogs(GetSyncLogDTO.GetSyncLogRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    //request.setCompanyCd(sessionInfoVO.getCompanyCd());

    RestResultVO rrVO = adminSyncService.getSyncLogs(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

}
