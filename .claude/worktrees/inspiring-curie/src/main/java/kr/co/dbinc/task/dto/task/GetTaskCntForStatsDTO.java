package kr.co.dbinc.task.dto.task;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
public class GetTaskCntForStatsDTO {
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetTaskCntForStatsRequest {
    private String domainId;
    private String companyCd;
    private String email;
    private String taskStartDt;
    private String taskEndDt;
  }
  
  @Getter @Setter
  public static class GetTaskCntForStatsResponse {
    private String taskEmpCd;
    private String taskStateCd;
    private int count;
  }
}
