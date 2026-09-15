package kr.co.dbinc.task.dto.company;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serial;
import java.io.Serializable;

@Getter
@Setter
@ToString
public class CompanyMasterDTO implements Serializable
{
  @Serial
  private static final long serialVersionUID = 6208129127341681484L;

  private String domainId;
  private String companyCd;
  private String companyNm;
  private String companyEngNm;
  private String oauthType;
  private String languageCd;
  private String useYn;
  private String epSsoTokenCheckApiUrl;
  private String epSsoApiGwUrl;
  private String epSystemId;
  private String autoEpSyncYn;
  private String epEmpSyncApiUrl;
  private String epDeptSyncApiUrl;
  private String epEmpDeptXrefSyncApiUrl;
  private String tempDomainId;
  private String apiAuthKey;
  private String updateUsr;
  private String updateDt;
  private String createUsr;
  private String createDt;
}
