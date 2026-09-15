package kr.co.dbinc.task.dto.label;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

public class GetLabelDTO {
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetLabelRequest {
    private String domainId;
    private String companyCd;
    private String email;
    private String labelNm;
    private int draw;
    private int start;
    private int length;
  }
  
  @Getter @Setter
  public static class GetLabelResponse {
    private String domainId;
    private String companyCd;
    private String labelId;
    private String labelNm;
    private String updateUsr;
    private String updateDt;
    private String createUsr;
    private String createDt;
  }
}
