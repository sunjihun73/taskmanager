package kr.co.dbinc.task.service.admin.sync;

import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.sync.EpSyncDTO;
import kr.co.dbinc.task.dto.sync.GetSyncLogDTO;
import kr.co.dbinc.task.dto.sync.SetSyncLogDTO;
import kr.co.dbinc.task.exception.ErrorCode;
import kr.co.dbinc.task.exception.SyncDataException;
import kr.co.dbinc.task.mapper.admin.*;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AdminSyncService
{
  private final AdminCodeMapper adminCodeMapper;
  private final AdminDeptMapper adminDeptMapper;
  private final AdminEmpMapper adminEmpMapper;
  private final AdminCompanyMapper adminCompanyMapper;
  private final AdminSyncDataMapper adminSyncDataMapper;

  /** EP 전체 데이터 -> sync 연동(Batch) */
  @Transactional
  public void syncEpData()
  {
    SetSyncLogDTO logReq = new SetSyncLogDTO();
    logReq.setSyncDiv("TOSYNC");
    logReq.setAutoDiv("Y");
    try
    {
      List<EpSyncDTO.EpSyncRequest> companyList = adminCompanyMapper.getCompanyList();
      for(EpSyncDTO.EpSyncRequest company : companyList)
      {
        logReq.setDomainId(company.getDomainId());
        logReq.setCompanyCd(company.getCompanyCd());
        logReq.setTempDomainId(company.getTempDomainId());
        //SYNC_LOG 테이블에 LOG 남기기위해 F로 초기화(Null 방지)
        logReq.setEmpSyncResult("F");
        logReq.setDeptSyncResult("F");
        logReq.setCodeSyncResult("F");

        getEpEmpList(company);
        logReq.setEmpSyncResult("S");
        getEpDeptList(company);
        logReq.setDeptSyncResult("S");
        getEpCodeList(company);
        logReq.setCodeSyncResult("S");

        adminSyncDataMapper.insertSyncLog(logReq);
      }
    }
    catch (SyncDataException e)
    {
      adminSyncDataMapper.insertSyncLog(logReq); // SYNC_LOG_[DOMAIN] 테이블에 동기화 성공/실패 여부 INSERT
      throw new SyncDataException(ErrorCode.SYNC_DATA_FAILED);
    }
  }

  /** sync->DB 연동(Batch), TEMP테이블에서 실 테이블로 데이터 이동 */
  @Transactional
  public void insertSyncEpData()
  {
    SetSyncLogDTO logReq = new SetSyncLogDTO();
    logReq.setSyncDiv("TODB");
    logReq.setAutoDiv("Y");

    try
    {
      List<EpSyncDTO.EpSyncRequest> companyList = adminCompanyMapper.getCompanyList();
      for(EpSyncDTO.EpSyncRequest company : companyList)
      {
        logReq.setDomainId(company.getDomainId());
        logReq.setCompanyCd(company.getCompanyCd());
        logReq.setTempDomainId(company.getTempDomainId());

        logReq.setEmpSyncResult("F");
        logReq.setDeptSyncResult("F");
        logReq.setCodeSyncResult("F");

        int cnt = adminSyncDataMapper.getNewSyncLog(company);
        if(cnt < 1) continue; //최근 TOSYNC 로그의 EMP, DEPT, CODE RESULT가 전부 성공이 아니면 PASS

        adminEmpMapper.deleteEmp(company);
        adminEmpMapper.insertEmpFromSync(company);
        adminEmpMapper.deleteEmpAuth(company);
        adminEmpMapper.insertEmpAuthFromSync(company);
        logReq.setEmpSyncResult("S");

        adminDeptMapper.deleteDept(company);
        adminDeptMapper.insertDeptFromSync(company);
        logReq.setDeptSyncResult("S");

        adminCodeMapper.updateCodeFromSync(company);
        logReq.setCodeSyncResult("S");

        adminSyncDataMapper.insertSyncLog(logReq);
      }
    }
    catch (SyncDataException e) 
    {
      adminSyncDataMapper.insertSyncLog(logReq);
      throw new SyncDataException(ErrorCode.SYNC_DATA_FAILED);
    }
  }

  /** EP 데이터와 sync 연동 */
  @Transactional
  public void syncDataManual(EpSyncDTO.EpSyncRequest request) 
  {
    SetSyncLogDTO logReq = new SetSyncLogDTO();
    logReq.setSyncDiv("TOSYNC");
    logReq.setAutoDiv("N");
    String code = request.getSyncCode();

    try 
    {
      request = adminCompanyMapper.getEpSyncApi(request);
      logReq.setDomainId(request.getDomainId());
      logReq.setCompanyCd(request.getCompanyCd());
      logReq.setTempDomainId(request.getTempDomainId());
      //SYNC_LOG 테이블에 LOG 남기기위해 F로 초기화(Null 방지)
      logReq.setEmpSyncResult("F");
      logReq.setDeptSyncResult("F");
      logReq.setCodeSyncResult("F");

      //EMP Data 동기화
      if("emp".equals(code) || "all".equals(code)) 
      {
        getEpEmpList(request);
        logReq.setEmpSyncResult("S");
      }

      //DEPT Data 동기화
      if("dept".equals(code) || "all".equals(code)) 
      {
        getEpDeptList(request);
        logReq.setDeptSyncResult("S");
      }

      //CODE Data 동기화
      if("code".equals(code) || "all".equals(code)) 
      {
        getEpCodeList(request);
        logReq.setCodeSyncResult("S");
      }

      if("F".equals(logReq.getEmpSyncResult())) logReq.setEmpSyncResult("P");
      if("F".equals(logReq.getDeptSyncResult())) logReq.setDeptSyncResult("P");
      if("F".equals(logReq.getCodeSyncResult())) logReq.setCodeSyncResult("P");

      adminSyncDataMapper.insertSyncLog(logReq);
    }
    catch (SyncDataException e) 
    {
      adminSyncDataMapper.insertSyncLog(logReq); // SYNC_LOG_[DOMAIN] 테이블에 동기화 성공/실패 여부 INSERT
      throw new SyncDataException(ErrorCode.SYNC_DATA_FAILED);
    }

    insertSyncEpDataManual(request, logReq, code);
  }

  public void insertSyncEpDataManual(EpSyncDTO.EpSyncRequest request, SetSyncLogDTO logReq, String code) {
    logReq.setSyncDiv("TODB");
    try {
      logReq.setEmpSyncResult("F");
      logReq.setDeptSyncResult("F");
      logReq.setCodeSyncResult("F");

      if("emp".equals(code) || "all".equals(code))
      {
        adminEmpMapper.deleteEmp(request);
        adminEmpMapper.insertEmpFromSync(request);
        adminEmpMapper.deleteEmpAuth(request);
        adminEmpMapper.insertEmpAuthFromSync(request);
        logReq.setEmpSyncResult("S");
      }

      if("dept".equals(code) || "all".equals(code))
      {
        adminDeptMapper.deleteDept(request);
        adminDeptMapper.insertDeptFromSync(request);
        logReq.setDeptSyncResult("S");
      }

      if("code".equals(code) || "all".equals(code))
      {
        adminCodeMapper.updateCodeFromSync(request);
        logReq.setCodeSyncResult("S");
      }

      if("F".equals(logReq.getEmpSyncResult())) logReq.setEmpSyncResult("P");
      if("F".equals(logReq.getDeptSyncResult())) logReq.setDeptSyncResult("P");
      if("F".equals(logReq.getCodeSyncResult())) logReq.setCodeSyncResult("P");

      adminSyncDataMapper.insertSyncLog(logReq);
    }
    catch (SyncDataException e)
    {
      adminSyncDataMapper.insertSyncLog(logReq); // SYNC_LOG_[DOMAIN] 테이블에 동기화 성공/실패 여부 INSERT
      throw new SyncDataException(ErrorCode.SYNC_DATA_FAILED);
    }

  }

  /** EP 부서 데이터와 sync 연동 : DEPT */
  /** EP 사용자 데이터와 sync 연동 : EMP */
  @Transactional
  public void syncData(EpSyncDTO.EpSyncRequest request, String code)
  {
    SetSyncLogDTO logReq = new SetSyncLogDTO();
    try
    {
      request = adminCompanyMapper.getEpSyncApi(request);
      logReq.setDomainId(request.getDomainId());
      logReq.setCompanyCd(request.getCompanyCd());
      logReq.setTempDomainId(request.getTempDomainId());
      //SYNC_LOG 테이블에 LOG 남기기위해 F로 초기화(Null 방지)
      logReq.setEmpSyncResult("F");
      logReq.setDeptSyncResult("F");

      //EMP Data 동기화
      if(!"DEPT".equals(code))
      {
        getEpEmpList(request);
        logReq.setEmpSyncResult("S");
      }
      else logReq.setEmpSyncResult("P");

      //Dept Data 동기화
      if(!"EMP".equals(code))
      {
        getEpDeptList(request);
        logReq.setDeptSyncResult("S");
      }
      else logReq.setDeptSyncResult("P");

    }
    finally
    {
      adminSyncDataMapper.insertSyncLog(logReq); // SYNC_LOG_[DOMAIN] 테이블에 동기화 성공/실패 여부 INSERT
    }
  }

  public void getEpEmpList(EpSyncDTO.EpSyncRequest request)
  {
    StringBuffer epTokenUrl = new StringBuffer();
    epTokenUrl.append(request.getEpEmpSyncApiUrl());
    epTokenUrl.append("domainName=");
    epTokenUrl.append(request.getDomainId());
    epTokenUrl.append("&company=");
    epTokenUrl.append(request.getCompanyCd());
    epTokenUrl.append("&authKey=");
    epTokenUrl.append(request.getApiAuthKey());

    RestTemplate restTemplate = new RestTemplate();
    EpSyncDTO.EpSyncResponse response = restTemplate.getForObject(epTokenUrl.toString(), EpSyncDTO.EpSyncResponse.class);
    if(response == null || !C.SUCCESS.equals(response.getResultCode()))
    {
      throw new SyncDataException(ErrorCode.SYNC_DATA_FAILED);
    }
    response.setDomainId(request.getDomainId());
    response.setCompanyCd(request.getCompanyCd());
    response.setTempDomainId(request.getTempDomainId());

    adminSyncDataMapper.deleteSyncEmpMaster(response);
    adminSyncDataMapper.insertSyncEmpMaster(response);
  }

  public void getEpDeptList(EpSyncDTO.EpSyncRequest request)
  {
    StringBuffer epTokenUrl = new StringBuffer();
    epTokenUrl.append(request.getEpDeptSyncApiUrl());
    epTokenUrl.append("domainName=");
    epTokenUrl.append(request.getDomainId());
    epTokenUrl.append("&company=");
    epTokenUrl.append(request.getCompanyCd());
    epTokenUrl.append("&authKey=");
    epTokenUrl.append(request.getApiAuthKey());

    RestTemplate restTemplate = new RestTemplate();
    EpSyncDTO.EpSyncResponse response = restTemplate.getForObject(epTokenUrl.toString(), EpSyncDTO.EpSyncResponse.class);
    if(response == null || !C.SUCCESS.equals(response.getResultCode()))
    {
      throw new SyncDataException(ErrorCode.SYNC_DATA_FAILED);
    }
    response.setDomainId(request.getDomainId());
    response.setCompanyCd(request.getCompanyCd());
    response.setTempDomainId(request.getTempDomainId());

    adminSyncDataMapper.deleteSyncDeptMaster(response);
    adminSyncDataMapper.insertSyncDeptMaster(response);
  }

  public void getEpCodeList(EpSyncDTO.EpSyncRequest request)
  {
    StringBuffer epTokenUrl = new StringBuffer();
    epTokenUrl.append(request.getEpCodeSyncApiUrl());
    epTokenUrl.append("domainName=");
    epTokenUrl.append(request.getDomainId());
    epTokenUrl.append("&company=");
    epTokenUrl.append(request.getCompanyCd());
    epTokenUrl.append("&authKey=");
    epTokenUrl.append(request.getApiAuthKey());
    epTokenUrl.append("&language=ko_KR");
    RestTemplate restTemplate = new RestTemplate();
    EpSyncDTO.EpSyncResponse response = restTemplate.getForObject(epTokenUrl.toString(), EpSyncDTO.EpSyncResponse.class);
    if(response == null || !C.SUCCESS.equals(response.getResultCode()))
    {
      throw new SyncDataException(ErrorCode.SYNC_DATA_FAILED);
    }
    response.setDomainId(request.getDomainId());
    response.setCompanyCd(request.getCompanyCd());
    response.setTempDomainId(request.getTempDomainId());

    adminSyncDataMapper.deleteSyncCodeDetail(response);
    adminSyncDataMapper.insertSyncCodeDetail(response);
  }

  /** EP 데이터 연동 History 조회 */
  public RestResultVO getSyncLogs(GetSyncLogDTO.GetSyncLogRequest request)
  {
    request.setTempDomainId(adminCompanyMapper.getTempDomainId(request));
    List<GetSyncLogDTO.GetSyncLogResponse> response = adminSyncDataMapper.getSyncLogs(request);
    int recordsCnt = adminSyncDataMapper.getSyncLogsCnt(request);

    RestResultVO rrVO = new RestResultVO();
    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }
}
