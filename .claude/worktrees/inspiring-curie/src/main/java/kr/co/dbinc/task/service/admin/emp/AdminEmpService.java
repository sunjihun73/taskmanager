package kr.co.dbinc.task.service.admin.emp;

import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.emp.DeleteManagerDTO;
import kr.co.dbinc.task.dto.emp.GetEmpDTO;
import kr.co.dbinc.task.dto.emp.InsertManagerDTO;
import kr.co.dbinc.task.dto.emp.UpdateEmpDTO;
import kr.co.dbinc.task.mapper.admin.AdminEmpMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AdminEmpService
{
  private final AdminEmpMapper adminEmpMapper;

  /** EMP_MASTER 목록 조회 */
  public RestResultVO getEmpList(GetEmpDTO.GetEmpRequest request)
  {
    RestResultVO rrVO = new RestResultVO();
    int recordsCnt = adminEmpMapper.getEmpListCnt(request);
    List<GetEmpDTO.GetEmpResponse> response = adminEmpMapper.getEmpList(request);

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }

  /** EMP_MASTER 상세 조회 */
  public GetEmpDTO.GetEmpResponse getEmpDetail(GetEmpDTO.GetEmpRequest request)
  {
    return adminEmpMapper.getEmpDetail(request);
  }

  /** EMP_MASTER 상세 수정 */
  @Transactional
  public void updateEmpDetail(UpdateEmpDTO request)
  {
    adminEmpMapper.updateEmpDetail(request);
  }

  /** EMP_MASTER 목록 조회 : 관리자만 조회 */
  public RestResultVO getManagers(GetEmpDTO.GetEmpRequest request)
  {
    RestResultVO rrVO = new RestResultVO();
    int recordsCnt = adminEmpMapper.getManagersCnt(request);
    List<GetEmpDTO.GetEmpResponse> response = adminEmpMapper.getManagers(request);

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }

  /** EMP_MASTER 목록 조회 : 일반 사용자 권한을 가진 사용자들을 조회, 관리자도 포함될 수 있음. */
  public RestResultVO getUsers(GetEmpDTO.GetEmpRequest request)
  {
    RestResultVO rrVO = new RestResultVO();
    int recordsCnt = adminEmpMapper.getUsersCnt(request);
    List<GetEmpDTO.GetEmpResponse> response = adminEmpMapper.getUsers(request);

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }

  /** EMP_AUTHORITY 관리자 권한 부여 */
  @Transactional
  public void insertManager(InsertManagerDTO request)
  {
    for(String email : request.getManagers())
    {
      request.setEmail(email);
      adminEmpMapper.insertManager(request);
    }
  }

  /** EMP_AUTHORITY 관리자 권한 삭제 */
  @Transactional
  public void deleteManager(DeleteManagerDTO request)
  {
    for(String email : request.getManagers())
    {
      request.setEmail(email);
      adminEmpMapper.deleteManager(request);
    }
  }
}
