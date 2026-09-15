package kr.co.dbinc.task.service.auth;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.*;
import kr.co.dbinc.task.dto.company.CompanyMasterDTO;
import kr.co.dbinc.task.dto.emp.EmpAuthorityDTO;
import kr.co.dbinc.task.dto.emp.EmpMasterDTO;
import kr.co.dbinc.task.mapper.auth.AuthMapper;
import kr.co.dbinc.task.util.C;
import kr.co.dbinc.task.util.DecryptUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class AuthServiceTestImpl implements AuthService
{
  @Value("${system.url}")
  String mSystemUrl;

  @Value("${default.start.continue.url}")
  String mDefaultContinueUrl;

  private final AuthMapper authMapper;
  private final RestTemplate restTemplate;

  public ResultVO ssoLogin(String epToken, String userId) throws Exception
  {
    log.debug("■ AuthService.ssoLogin");
    ResultVO resultVO = new ResultVO();
    SessionInfoVO sessionInfoVO = new SessionInfoVO();
    JSONObject joTokenRsltData = null;
    JSONObject joDecryptRsltData = null;
    Map<String, Object> paramsMap = new HashMap<>();
    StringBuffer epTokenUrl = new StringBuffer();
    String epSsoApiGwUrl = "";
    String epSystemId = "";
    String oauthType = "";
    String defaultContinueUrl = mSystemUrl + mDefaultContinueUrl.substring(1);

    paramsMap.put("userId", userId);
    paramsMap.put("useYn", "Y");
    CompanyMasterDTO cmDTO = authMapper.selectCompanyMaster(paramsMap);

    // 최초 넘겨온 이메일 인자를 이용해 회사 정보 조회
    // 아래 3가지 정보 조회
    // 1. 회사정보에서 TOKEN 체크 하는 EP API URL
    // 2. EP_SSO_API_GW_URL
    // 3. EP_SYSTEM_ID
    if (cmDTO == null)
    {
      resultVO.setResultCode(C.FAIL);
      resultVO.setResultMsg("SSO 로그인 실패 : 사용자 회사 혹은 사용자가 존재하지 않습니다.");
      resultVO.setDataOne(null);
      return resultVO;
    }

    epSsoApiGwUrl = cmDTO.getEpSsoApiGwUrl();
    epSystemId = cmDTO.getEpSystemId();
    oauthType = cmDTO.getOauthType();

    // EP API 체크 URL을 조회했으면, EP로부터 토큰 유효성 체크를 위해 EP API 호출  ********************
    epTokenUrl.append(cmDTO.getEpSsoTokenCheckApiUrl());
    epTokenUrl.append("?TOKEN=");
    epTokenUrl.append(epToken);
    epTokenUrl.append("&USER_ID=");
    epTokenUrl.append(userId);

    URL url = new URL(epTokenUrl.toString());
    HttpURLConnection conn = (HttpURLConnection)url.openConnection();
    conn.setRequestMethod("GET");
    conn.setRequestProperty("Content-Type", "application/json");
    conn.setDoOutput(true); // 출력 가능 상태로 변경
    conn.connect();

    // 데이터  읽어오기
    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8")); // 한글 깨짐 방지
    StringBuilder sb = new StringBuilder();
    String line = "";
    while((line = br.readLine()) != null)
    {
      sb.append(line);
    }
    conn.disconnect();

    // EP API 호출 결과 EP로부터 받은 결과 값을 JSON 형태로 변환한 값
    joTokenRsltData = (JSONObject) new JSONParser().parse(sb.toString());
    // EP로부터 토큰 유효성 체크를 위해 EP API 호출  끝 ****************************************

    // EP 토큰 체크 결과 값이 제대로 넘어오지 않은 경우
    if (joTokenRsltData == null || !joTokenRsltData.containsKey("RESULT"))
    {
      resultVO.setResultCode(C.FAIL);
      resultVO.setResultMsg("SSO 로그인 실패 : EP Token 유효성 체크 절차를 통과하지 못했습니다.");
      resultVO.setDataOne(null);
      return resultVO;
    }

    // EP 토큰 체크 결과가 성공이 아닌 경우
    if (!C.uSUCCESS.equals(joTokenRsltData.get("RESULT")))
    {
      resultVO.setResultCode(C.FAIL);
      resultVO.setResultMsg("SSO 로그인 실패 : EP Token 유효성 체크 절차를 통과하지 못했습니다.");
      resultVO.setDataOne(null);
      return resultVO;
    }

    // EP 토큰 체크 결과가 성공인 경우 결과 JSON의 DATA 항목을 복호화 한다.
    joDecryptRsltData = DecryptUtil.decrypt(epToken, joTokenRsltData.get("DATA").toString());

    //    log.debug("==========================================");
    //    log.debug("joDecryptRsltData : " + joDecryptRsltData.toString());
    //    log.debug("==========================================");

    if (joDecryptRsltData == null)
    {
      resultVO.setResultCode(C.FAIL);
      resultVO.setResultMsg("SSO 로그인 실패 : EP Token 유효성 체크 결과 복호화에 실패하였습니다.");
      resultVO.setDataOne(null);
      return resultVO;
    }

    // EP 토큰 유효성 통과후 복호화에 성공하면,
    // 로그인 후 이동할 페이지에 해당하는 returnValue 값을 찾는다.
    // returnValue 값이 없으면 defaultContinueUrl 을 돌려준다.
    if (joDecryptRsltData.containsKey("returnValue"))
      if (joDecryptRsltData.get("returnValue") != null && !"".equals(joDecryptRsltData.get("returnValue")))
        resultVO.setContinueUrl(URLDecoder.decode(joDecryptRsltData.get("returnValue").toString(), "UTF-8"));
      else
        resultVO.setContinueUrl(defaultContinueUrl);
    else
      resultVO.setContinueUrl(defaultContinueUrl);

    // 복호화한 데이터에서 email과 companyCd를 가지고 emp_master 에서 사용자 정보를 조회한다.
    paramsMap.put("email", joDecryptRsltData.get("EMAIL"));
    paramsMap.put("companyCd", joDecryptRsltData.get("COMPANY_CD"));
    EmpMasterDTO emDTO = authMapper.selectEmpMaster(paramsMap);

    if (emDTO == null)
    {
      resultVO.setResultCode(C.FAIL);
      resultVO.setResultMsg("SSO 로그인 실패 : 사용자가 존재하지 않습니다.");
      resultVO.setDataOne(null);
      return resultVO;
    }

    // 사용자가 존재하면 권한 리스트를 조회한다.
    List<EmpAuthorityDTO> empAuthorities = authMapper.selectEmpAuthorityList(paramsMap);
    if (empAuthorities == null || empAuthorities.size() < 1)
    {
      resultVO.setResultCode(C.FAIL);
      resultVO.setResultMsg("SSO 로그인 실패 : 사용자의 권한이 존재하지 않습니다.");
      resultVO.setDataOne(null);
      return resultVO;
    }

    sessionInfoVO.setDomainId(emDTO.getDomainId());
    sessionInfoVO.setCompanyCd(emDTO.getCompanyCd());
    sessionInfoVO.setEmail(emDTO.getEmail());
    sessionInfoVO.setEmpNm(emDTO.getEmpNm());
    sessionInfoVO.setEmpEngNm(emDTO.getEmpEngNm());
    sessionInfoVO.setEmpNo(emDTO.getEmpNo());
    sessionInfoVO.setDeptCd(emDTO.getDeptCd());
    sessionInfoVO.setDeptNm(emDTO.getDeptNm());
    sessionInfoVO.setDeptEngNm(emDTO.getDeptEngNm());
    sessionInfoVO.setCompanyNm(emDTO.getCompanyNm());
    sessionInfoVO.setCompanyEngNm(emDTO.getCompanyEngNm());
    sessionInfoVO.setEpSsoApiGwUrl(epSsoApiGwUrl);
    sessionInfoVO.setOauthType(oauthType);
    sessionInfoVO.setEpSystemId(epSystemId);
    sessionInfoVO.setEmpAuthorities(empAuthorities);

    resultVO.setResultCode(C.SUCCESS);
    resultVO.setResultMsg("SSO 로그인 성공");
    resultVO.setDataOne(sessionInfoVO);

    return resultVO;
  }

  public void ssoLogout(HttpServletRequest req) throws Exception
  {
    log.debug("■ AuthService.ssoLogout");
    HttpSession session = req.getSession(false);
    if (session != null) session.invalidate();
  }
}
