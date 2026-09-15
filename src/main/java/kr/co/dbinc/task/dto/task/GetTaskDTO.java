package kr.co.dbinc.task.dto.task;

import jakarta.validation.constraints.NotEmpty;
import kr.co.dbinc.task.dto.label.GetTaskLabelResponse;
import lombok.*;

import java.util.List;

public class GetTaskDTO
{
  @Getter
  @Setter
  @ToString
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetTaskRequest
  {
    @NotEmpty(message = "domainId는 필수입니다.")
    private String domainId;
    @NotEmpty(message = "companyCd는 필수입니다.")
    private String companyCd;
    private String email;
    private String taskId;
    private String taskEmpCd;
    private String childTaskAddYn;
    private String taskState;
    private String taskNm;
    private String taskTypeCd;
    private String projectId;
    private int draw;
    private int start;
    private int length;
  }
  
  @Getter @Setter
  public static class GetTaskResponse
  {
    private String domainId;
    private String companyCd;
    private String taskId;
    private String taskNm;
    private String taskDetail;
    private String taskStateCd;
    private String taskState;
    private String taskStartDt;
    private String taskEndDt;
    private String taskOwnerMemberId;
    private String taskOwnerMemberNm;
    private String childTaskAddYn;
    private String taskImportance;
    private String taskProgress;
    private String empNm;
    private String empCompanyNm;
    private String taskEmpCd;
    private String taskEmp;
    private String parentTaskId;
    private String parentTaskNm;
    private String email;
    private String childYn;
    private String taskTypeCd;
    private String taskTypeNm;
    private String projectId;
    private String projectNm;
    private String level;
    private int totalCount;
    private List<GetTaskLabelResponse> label;
    private List<GetTaskResponse> children;
    private List<GetTaskEmpListResponse> taskEmpList;
  }
}
