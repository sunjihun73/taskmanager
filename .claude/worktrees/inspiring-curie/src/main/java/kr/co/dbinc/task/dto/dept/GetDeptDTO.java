package kr.co.dbinc.task.dto.dept;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

public class GetDeptDTO {
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetDeptRequest {
    private String domainId;
    private String companyCd;
  }
  
  @Getter @Setter
  public static class GetDeptResponse {
    private String deptCd;
    private String deptNm;
    private String parentDeptCd;
    
  }
}
