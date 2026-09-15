package kr.co.dbinc.task.dto.task;

import jakarta.validation.constraints.NotBlank;
import kr.co.dbinc.task.dto.checklist.GetChecklistResponse;
import kr.co.dbinc.task.dto.file.GetFileListResponse;
import kr.co.dbinc.task.dto.label.GetTaskLabelResponse;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

public class GetTaskDetailDTO {
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetTaskDetailRequest {
    private String domainId;
    private String companyCd;
    private String taskId;
    private String email;
    private String empNm;
  }
  
  @Getter @Setter
  public static class GetTaskDetailResponse {
    private String domainId;
    private String companyCd;
    private String taskId;
    private String taskNm;
    private String taskDetail;
    private String taskStateCd;
    private String taskStartDt;
    private String taskEndDt;
    private String taskOwnerMemberId;
    private String taskOwnerMemberNm;
    private String reportMemberId;
    private String reportMemberNm;
    private String taskImportanceCd;
    private String taskProgress;
    private String empNm;
    private String parentTaskId;
    private String parentTaskNm;
    private String taskTypeCd;
    private String taskTypeNm;
    private String projectId;
    private List<GetTaskEmpListResponse> taskEmpList;
    private List<GetTaskLabelResponse> taskLabels;
    private List<GetChecklistResponse> checklist;
    private List<GetFileListResponse> fileList;
    private int childCnt;
    private String updateUsr;
    private String updateDt;
  }

}
