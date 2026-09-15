package kr.co.dbinc.task.dto.checklist;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class GetChecklistResponse {
  private String domainId;
  private String companyCd;
  private String taskId;
  private String checkId;
  private String checkNm;
  private String checkYn;
}
