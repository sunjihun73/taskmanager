package kr.co.dbinc.task.service.admin.code;

import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.dto.code.CodeDTO;
import kr.co.dbinc.task.mapper.admin.AdminCodeMapper;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AdminCodeService
{
  private final AdminCodeMapper adminCodeMapper;

  // Select Box 생성을 위한 코드 리스트 조회
  public RestResultVO getCodeDetailList4SelBox(Map<String, Object> paramsMap, HttpSession session) throws Exception
  {
    log.debug("■ CodeService.getCodeDetailList4SelBox");
    RestResultVO rrVO = new RestResultVO();
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    paramsMap.put("domainId", sessionInfoVO.getDomainId());
    paramsMap.put("companyCd", sessionInfoVO.getCompanyCd());
    paramsMap.put("useYn", C.YES);
    List<CodeDTO> codeList = adminCodeMapper.getCodeDetailList4SelBox(paramsMap);
    rrVO.setData(codeList);
    return rrVO;
  }
}
