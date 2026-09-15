package kr.co.dbinc.task.mapper.project;

import kr.co.dbinc.task.dto.project.DeleteProjectRequestDTO;
import kr.co.dbinc.task.dto.project.ProjectEmpDTO;
import kr.co.dbinc.task.dto.project.ModifyProjectRequestDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface ProjectMapper
{
  kr.co.dbinc.task.dto.project.GetProjectDTO.GetProjectResponse getProject(kr.co.dbinc.task.dto.project.GetProjectDTO.GetProjectRequest request);

  int getProjectsCnt(kr.co.dbinc.task.dto.project.GetProjectDTO.GetProjectRequest request);
  List<kr.co.dbinc.task.dto.project.GetProjectDTO.GetProjectResponse> getProjects(kr.co.dbinc.task.dto.project.GetProjectDTO.GetProjectRequest request);

  int insertProjectMaster(ModifyProjectRequestDTO request);
  int updateProjectMaster(ModifyProjectRequestDTO request);
  int deleteProjectMaster(DeleteProjectRequestDTO request);

  int insertProjectEmp(ProjectEmpDTO projectEmp);
  List<ProjectEmpDTO> getProjectEmps(Map<String, Object> paramsMap);
  List<ProjectEmpDTO> getAllProjectEmps(Map<String, Object> paramsMap);
  int deleteProjectEmp(Map<String, Object> paramsMap);

  int getProjectEmpsCnt4Modal(ProjectEmpDTO projectEmpDTO);
  List<ProjectEmpDTO> getProjectEmps4Modal(ProjectEmpDTO  projectEmpDTO);
}
