package kr.co.dbinc.task.dto.task;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

public class GetTaskCalendarDTO {
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetTaskCalendarRequest {
    private String domainId;
    private String companyCd;
    private String email;
    private String taskState;
    private String childTaskAddYn;
    private String taskEmpCd;
    private String labelId;
  }
  
  @Getter @Setter
  public static class GetTaskCalendarResponse {
    private String taskId;
    private String title;
    private String start;
    private String end;
    private String taskStateCd;
    private String taskState;
  }
}
