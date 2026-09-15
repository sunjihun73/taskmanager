package kr.co.dbinc.task.dto.project;

import lombok.*;

import java.util.List;

public class GetProjectDTO
{
  @Getter
  @Setter
  @ToString
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetProjectRequest
  {
    private String domainId;
    private String companyCd;
    private String email;
    private String projectNm;
    private String projectStateCd;
    private String projectId;
    private String projectStartDt;
    private String projectEndDt;
    private String delYn;
    private int draw;
    private int start;
    private int length;
  }

  @Getter
  @Setter
  public static class GetProjectResponse
  {
    private String domainId;
    private String companyCd;
    private String projectId;
    private String projectNm;
    private String projectDesc;
    private String projectStateCd;
    private String projectStateNm;
    private String projectCategoryCd;
    private String projectCategoryNm;
    private String projectStartDt;
    private String projectEndDt;
    private String projectOwnerMemberId;
    private String projectOwnerMemberNm;
    private String delYn;
    private String updateUsr;
    private String updateDt;
    private String createUsr;
    private String createDt;

    private List<ProjectEmpDTO> shareEmpList;
  }
}
