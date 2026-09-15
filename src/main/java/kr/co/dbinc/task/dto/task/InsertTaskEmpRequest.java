package kr.co.dbinc.task.dto.task;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class InsertTaskEmpRequest {
  private String domainId;
  private String companyCd;
  private String taskId;
  private String email;
  private String taskEmpCd;
  private String createUsr;
}
