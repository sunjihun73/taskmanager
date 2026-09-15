package kr.co.dbinc.task.service.user.project;

import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.file.GetFileListResponse;
import kr.co.dbinc.task.dto.project.DeleteProjectRequestDTO;
import kr.co.dbinc.task.dto.project.GetProjectDTO;
import kr.co.dbinc.task.dto.project.ProjectEmpDTO;
import kr.co.dbinc.task.dto.project.ModifyProjectRequestDTO;
import kr.co.dbinc.task.exception.AuthException;
import kr.co.dbinc.task.exception.ErrorCode;
import kr.co.dbinc.task.mapper.file.FileMapper;
import kr.co.dbinc.task.mapper.project.ProjectMapper;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class UserProjectService
{
  private final ProjectMapper projectMapper;
  private final FileMapper fileMapper;

  /** 프로젝트 한건 조회 */
  public RestResultVO getProject(GetProjectDTO.GetProjectRequest request) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    GetProjectDTO.GetProjectResponse response = projectMapper.getProject(request);

    if(response == null) throw new AuthException(ErrorCode.NOT_EXIST_PROJECT); //존재하지 않는 프로젝트에 접근한 경우 에러

    // 참여자 목록 조회
    Map<String,Object> paramsMap = new HashMap<>();
    paramsMap.put("domainId", request.getDomainId());
    paramsMap.put("projectId", request.getProjectId());
    paramsMap.put("projectEmpCd", C.SHARE_TYPE_SHARE);
    List<ProjectEmpDTO> shareEmpList = projectMapper.getProjectEmps(paramsMap);
    response.setShareEmpList(shareEmpList);

    // 로그인 한 사용자가 해당 프로젝트의 소유자도 아니고 참여자도 아니면 에러
    if(!response.getProjectOwnerMemberId().equals(request.getEmail()) && shareEmpList.stream().noneMatch(emp -> emp.getEmail().equals(request.getEmail())))
      throw new AuthException(ErrorCode.UNAUTHORIZED_ACCESS);

    rrVO.setDataOne(response);
    return rrVO;
  }

  /** 내 프로젝트 목록 조회 */
  public RestResultVO getMyProjects(GetProjectDTO.GetProjectRequest request) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    int recordsCnt = projectMapper.getProjectsCnt(request);
    List<GetProjectDTO.GetProjectResponse> response = projectMapper.getProjects(request);
    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }

  /** 프로젝트 한건 추가  */
  @Transactional
  public RestResultVO insertProjectMaster(ModifyProjectRequestDTO request) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    projectMapper.insertProjectMaster(request); // PROJECT_MASTER 테이블 한건 추가
    this.insertProjectEmp(request); // PROJECT_EMP 테이블 데이터 추가 (여러건 될 수 있음)
    return rrVO;
  }

  /** 프로젝트 한건 수정  */
  @Transactional
  public RestResultVO updateProjectMaster(ModifyProjectRequestDTO request) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    projectMapper.updateProjectMaster(request); // PROJECT_MASTER 테이블 한건 수정
    this.insertProjectEmp(request); // PROJECT_EMP 테이블 데이터 추가 (여러건 될 수 있음)
    return rrVO;
  }

  /** 프로젝트 한건 삭제 (DEL_YN Y로 업데이트)  */
  @Transactional
  public RestResultVO deleteProjectMaster(DeleteProjectRequestDTO request) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    projectMapper.deleteProjectMaster(request); // PROJECT_MASTER 테이블 한건 수정
    return rrVO;
  }

  // PROJECT_EMP 테이블에 소유자 및 참여자를 추가
  public void insertProjectEmp(ModifyProjectRequestDTO request)
  {
    // 1. 기존 프로젝트 소유자 / 참여자 목록 조회 (메일 전송용)
    Map<String, Object> paramsMap = new HashMap<>();
    paramsMap.put("domainId", request.getDomainId());
    paramsMap.put("projectId", request.getProjectId());
    List<ProjectEmpDTO> existingEmps = projectMapper.getAllProjectEmps(paramsMap);

    // 2. 기존 데이터 삭제 (소유자 및 참여자 모두 삭제)
    projectMapper.deleteProjectEmp(paramsMap);

    // 3. 새로운 참여자 목록 구성
    List<ProjectEmpDTO> newEmpList = new java.util.ArrayList<>();
    
    ProjectEmpDTO projectEmp = new ProjectEmpDTO();
    projectEmp.setDomainId(request.getDomainId());
    projectEmp.setCompanyCd(request.getCompanyCd());
    projectEmp.setProjectId(request.getProjectId());
    projectEmp.setCreateUsr(request.getCreateUsr());
    projectEmp.setUpdateUsr(request.getUpdateUsr());

    // 소유자 추가
    projectEmp.setEmail(request.getProjectOwnerMemberId());
    projectEmp.setProjectEmpCd(C.SHARE_TYPE_OWNER); // 소유
    projectMapper.insertProjectEmp(projectEmp);
    
    ProjectEmpDTO ownerDto = new ProjectEmpDTO();
    ownerDto.setEmail(request.getProjectOwnerMemberId());
    ownerDto.setProjectEmpCd(C.SHARE_TYPE_OWNER);
    newEmpList.add(ownerDto);

    // 참여자 추가
    if(request.getShareEmpList() != null)
    {
      for(ProjectEmpDTO emp : request.getShareEmpList())
      {
        projectEmp.setEmail(emp.getEmail());
        projectEmp.setCompanyCd(emp.getCompanyCd());
        projectEmp.setProjectEmpCd(emp.getProjectEmpCd());
        projectMapper.insertProjectEmp(projectEmp);
        
        ProjectEmpDTO shareDto = new ProjectEmpDTO();
        shareDto.setEmail(emp.getEmail());
        shareDto.setProjectEmpCd(emp.getProjectEmpCd());
        newEmpList.add(shareDto);
      }
    }

    // 4. 신규 추가된 참여자에게 메일 전송
    sendEmailToNewProjectMembers(existingEmps, newEmpList, request);
  }

  /**
   * 신규 추가된 프로젝트 참여자에게 메일을 전송하는 함수 (Mock)
   * 추후 실제 메일 전송 기능 구현 예정
   * 
   * @param existingEmps 기존 프로젝트 참여자 목록
   * @param newEmpList 새로운 프로젝트 참여자 목록
   * @param request 프로젝트 정보
   */
  private void sendEmailToNewProjectMembers(List<ProjectEmpDTO> existingEmps, List<ProjectEmpDTO> newEmpList, ModifyProjectRequestDTO request)
  {
    // 기존 참여자의 이메일 목록
    List<String> existingEmails = existingEmps.stream()
        .map(ProjectEmpDTO::getEmail)
        .collect(java.util.stream.Collectors.toList());

    // 신규 추가된 참여자 찾기
    List<ProjectEmpDTO> newMembers = newEmpList.stream()
        .filter(emp -> !existingEmails.contains(emp.getEmail()))
        .collect(java.util.stream.Collectors.toList());

    // 신규 참여자가 있을 경우
    if(!newMembers.isEmpty())
    {
      log.info("=== 프로젝트 신규 참여자 메일 전송 (Mock) ===");
      log.info("프로젝트 ID: {}", request.getProjectId());
      log.info("프로젝트명: {}", request.getProjectNm());
      log.info("신규 참여자 수: {}", newMembers.size());
      
      for(ProjectEmpDTO newMember : newMembers)
      {
        log.info("  - 신규 참여자: {} (역할: {})", 
            newMember.getEmail(), 
            newMember.getProjectEmpCd().equals(C.SHARE_TYPE_OWNER) ? "소유자" : "참여자");
        
        // TODO: 실제 메일 전송 로직 구현
        // mailService.sendProjectInvitationEmail(newMember.getEmail(), request.getProjectNm(), request.getProjectId());
      }
      log.info("========================================");
    }
  }


  /** 프로젝트기준 프로젝트 참여자 조회 (PROJECT_EMP 테이블 목록 조회) */
  public RestResultVO getProjectsEmps(ProjectEmpDTO reqProjectEmpDTO) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    int recordsCnt = projectMapper.getProjectEmpsCnt4Modal(reqProjectEmpDTO);
    List<ProjectEmpDTO> projectEmps = projectMapper.getProjectEmps4Modal(reqProjectEmpDTO);
    rrVO.setDraw(reqProjectEmpDTO.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(projectEmps);
    return rrVO;
  }

  /** 프로젝트 기준으로 프로젝트에 속한 첨부파일 목록 조회 */
  public RestResultVO getFilesByProjects(Map<String, Object> paramsMap) throws Exception
  {
    RestResultVO rrVO = new RestResultVO();
    int recordsCnt = fileMapper.getFileListByProjectCnt(paramsMap);
    List<GetFileListResponse> response = fileMapper.getFileListByProject(paramsMap);
    rrVO.setDraw(Integer.parseInt(paramsMap.get("draw").toString()));
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }
}
