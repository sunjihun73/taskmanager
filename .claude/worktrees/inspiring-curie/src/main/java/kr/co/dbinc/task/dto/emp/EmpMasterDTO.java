package kr.co.dbinc.task.dto.emp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serial;
import java.io.Serializable;

@Getter
@Setter
@ToString
public class EmpMasterDTO implements Serializable
{
  @Serial
  private static final long serialVersionUID = -6970159830442218601L;

  private String domainId;
  private String companyCd;
  private String email;
  private String empNm;
  private String empEngNm;
  private String empNo;
  private String posCd;
  private String posNm;
  private String deptCd;
  private String deptNm;
  private String deptEngNm;
  private String empStatusCd;
  private String empStatusNm;
  private String enterDt;
  private String quitDt;
  private String hiddenYn;
  private String jobTelNo;
  private String mobileTelNo;
  private String manualMngYn;
  private String companyNm;
  private String companyEngNm;
  
  private String updateUsr;
  private String updateDt;
  private String createUsr;
  private String createDt;
}
