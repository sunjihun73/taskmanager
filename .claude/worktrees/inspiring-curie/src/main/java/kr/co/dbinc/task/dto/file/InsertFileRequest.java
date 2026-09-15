package kr.co.dbinc.task.dto.file;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class InsertFileRequest {
  private String domainId;
  private String companyCd;
  private String taskId;
  private String projectId;
  private String fileNm;
  private String fileDispNm;
  private String createUsr;
  private String updateUsr;
}
