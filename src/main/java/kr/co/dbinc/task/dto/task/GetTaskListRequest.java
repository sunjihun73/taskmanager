package kr.co.dbinc.task.dto.task;

import lombok.*;

@Getter @Setter
@ToString
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class GetTaskListRequest {
  private String domainId;
  private String companyCd;
  private String email;
  private String empNm;
  private String taskEmpNm;
  private String taskState;
  private String projectNm;
  private String taskNm;
  private String childTaskAddYn;
  private String taskStartDt;
  private String taskEndDt;
  private String taskEmpCd;
  private String labelId;
  private String projectId;
  private int draw;
  private int start;
  private int length;
}