package kr.co.dbinc.task.dto.emp;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


public class GetEmpDTO {
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetEmpRequest {
    private String domainId;
    private String companyCd;
    private String email;
    private String deptCd;
    private String empNm;
    @NotNull
    private int draw;
    @NotNull
    private int start;
    @NotNull
    private int length;
  }
  
  @Getter @Setter
  public static class GetEmpResponse {
    private String domainId;
    private String companyCd;
    private String companyNm;
    private String email;
    private String empNm;
    private String empNo;
    private String posNm;
    private String deptNm;
    private String authorityName;
    private String enterDt;
    private String quitDt;
    private String jobTelNo;
    private String mobileTelNo;
    private String manualMngYn;
    private String hiddenYn;
  }
}
