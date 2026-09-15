package kr.co.dbinc.task.dto.project;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.util.List;

@Getter @Setter
@Builder
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class ModifyProjectRequestDTO
{
  private String domainId;
  private String companyCd;
  private String projectId;

  @NotBlank(message = "프로젝트명이 존재하지 않습니다.")
  private String projectNm;

  private String projectDesc;
  private String projectStateCd;
  private String projectCategoryCd;
  private String projectStartDt;
  private String projectEndDt;
  private String projectOwnerMemberId;
  private String delYn;
  private String updateUsr;
  private String updateDt;
  private String createUsr;
  private String createDt;

  private List<ProjectEmpDTO> shareEmpList;
}
