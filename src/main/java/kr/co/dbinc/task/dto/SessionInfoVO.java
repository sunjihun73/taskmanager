package kr.co.dbinc.task.dto;

import kr.co.dbinc.task.dto.emp.EmpAuthorityDTO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

@ToString
@Getter
@Setter
public class SessionInfoVO implements Serializable
{
  @Serial
  private static final long serialVersionUID = -5784760321557883612L;

  private String domainId;
  private String companyCd;
  private String email;
  private String empNm;
  private String empEngNm;
  private String oauthType;
  private String empNo;
  private String deptCd;
  private String deptNm;
  private String deptEngNm;
  private String companyNm;
  private String companyEngNm;
  private String epSsoApiGwUrl;
  private String epSystemId;
  private List<EmpAuthorityDTO> empAuthorities;
}
