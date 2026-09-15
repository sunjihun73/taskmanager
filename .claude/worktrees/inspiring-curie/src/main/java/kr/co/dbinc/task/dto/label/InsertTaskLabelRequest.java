package kr.co.dbinc.task.dto.label;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class InsertTaskLabelRequest {
  private String domainId;
  private String companyCd;
  private String taskId;
  private String labelId;
  private String email;
  private String createUsr;
}
