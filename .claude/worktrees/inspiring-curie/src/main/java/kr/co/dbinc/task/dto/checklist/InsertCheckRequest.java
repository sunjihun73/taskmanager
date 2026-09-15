package kr.co.dbinc.task.dto.checklist;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class InsertCheckRequest {
  private String domainId;
  private String companyCd;
  private String taskId;
  private String checkNm;
  private String checkYn;
  private String checkOrd;
  private String createUsr;
}
