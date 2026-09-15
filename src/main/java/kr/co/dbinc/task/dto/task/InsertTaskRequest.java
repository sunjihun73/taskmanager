package kr.co.dbinc.task.dto.task;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import kr.co.dbinc.task.dto.checklist.InsertCheckRequest;
import kr.co.dbinc.task.dto.file.InsertFileRequest;
import kr.co.dbinc.task.dto.label.InsertTaskLabelRequest;
import lombok.*;

import java.util.List;

@Getter @Setter
@Builder
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class InsertTaskRequest {
  private String domainId;
  private String companyCd;
  private String createUsr;
  private String updateUsr;
  private String updateDt;
  private String empNm;
  private String taskId;
  @NotBlank(message = "태스크명이 존재하지 않습니다.")
  private String taskNm;
  private String taskDetail;
  @NotBlank(message = "태스크상태가 존재하지 않습니다.")
  private String taskStateCd;
  private String taskStartDt;
  private String taskEndDt;
  private String taskOwnerMemberId;
  private String reportMemberId;
  private String taskImportanceCd;
  @Max(value=100, message = "진행도는 100보다 클 수 없습니다.")
  @Min(value=0, message = "진행도는 0보다 작을 수 없습니다.")
  private String taskProgress;
  private String parentTaskId;
  @Size(max=1)
  private String childTaskAddYn;
  private String taskTypeCd;
  private String projectId;
  private List<InsertTaskEmpRequest> empList;
  private List<InsertTaskEmpRequest> empAddList;
  private List<InsertTaskLabelRequest> taskLabels;
  @Size(max=20, message = "체크리스트는 20개를 초과할 수 없습니다.")
  private List<InsertCheckRequest> checkList;
  private List<InsertFileRequest> fileList;

  private String oauthType;
  private String epSsoApiGwUrl;
  private String epSystemId;
  private String calendarEventId;
}
