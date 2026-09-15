package kr.co.dbinc.task.dto.project;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ProjectEmpDTO
{
  private String domainId;
  private String companyCd;
  private String companyNm;
  private String email;
  private String empNm;
  private String posNm;
  private String deptNm;
  private String projectId;
  private String projectEmpCd;
  private String projectEmpNm;
  private String createUsr;
  private String createDt;
  private String updateUsr;
  private String updateDt;
  private int draw;
  private int start;
  private int length;
}
