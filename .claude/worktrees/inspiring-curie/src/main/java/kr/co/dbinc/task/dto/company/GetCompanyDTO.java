package kr.co.dbinc.task.dto.company;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

public class GetCompanyDTO {
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetCompanyRequest {
    private String domainId;
  }
  
  @Getter @Setter
  public static class GetCompanyResponse {
    private String companyCd;
    private String companyNm;
    private String epSsoApiGwUrl;
    private String epSystemId;
  }
}
