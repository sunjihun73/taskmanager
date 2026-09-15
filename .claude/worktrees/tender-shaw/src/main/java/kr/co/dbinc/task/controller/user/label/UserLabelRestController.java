package kr.co.dbinc.task.controller.user.label;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.label.DeleteLabelRequest;
import kr.co.dbinc.task.dto.label.GetLabelDTO;
import kr.co.dbinc.task.dto.label.InsertLabelRequest;
import kr.co.dbinc.task.dto.label.UpdateLabelRequest;
import kr.co.dbinc.task.service.user.label.UserLabelService;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/rest/user")
public class UserLabelRestController
{
  private final UserLabelService userLabelService;

  // 라벨 목록 조회 (페이지처리)
  @RequestMapping(value = "/labels/me", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getPagedLabels(@Valid GetLabelDTO.GetLabelRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO) session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    RestResultVO rrVO = userLabelService.getPagedLabels(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // 라벨 목록 조회 (페이지처리 안함)
  @RequestMapping(value = "/labels/all", method = {RequestMethod.GET, RequestMethod.POST})
  public ResponseEntity<RestResultVO> getLabels(@Valid GetLabelDTO.GetLabelRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    RestResultVO rrVO = userLabelService.getLabels(request);
    rrVO.setResultCode(C.SUCCESS);
    return ResponseEntity.ok(rrVO);
  }

  // 라벨 등록
  @PostMapping(value = "/labels")
  public ResponseEntity<String> insertLabel(InsertLabelRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    String labelId = userLabelService.insertLabel(request);
    return ResponseEntity.ok(labelId);
  }

  // 라벨 수정
  @PatchMapping(value = "/labels/{labelId}")
  public ResponseEntity<Void> updateLabel(@PathVariable(name="labelId") String labelId, UpdateLabelRequest request, HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setLabelId(labelId);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    userLabelService.updateLabel(request);
    return ResponseEntity.ok().build();
  }

  // 라벨 삭제
  @DeleteMapping(value = "/labels/{labelId}")
  public ResponseEntity<Void> deleteLabel(@PathVariable(name="labelId") String labelId, DeleteLabelRequest request, HttpSession session) throws Exception
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    request.setLabelId(labelId);
    request.setDomainId(sessionInfoVO.getDomainId());
    request.setCompanyCd(sessionInfoVO.getCompanyCd());
    request.setEmail(sessionInfoVO.getEmail());

    userLabelService.deleteLabel(request);
    return ResponseEntity.ok().build();
  }
}
