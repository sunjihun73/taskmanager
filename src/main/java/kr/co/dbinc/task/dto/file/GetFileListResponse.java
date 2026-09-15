package kr.co.dbinc.task.dto.file;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class GetFileListResponse {
  private String domainId;
  private String companyCd;
  private String fileId;
  private String taskId;
  private String taskNm;
  private String taskTypeCd;
  private String taskTypeNm;
  private String projectId;
  private String fileNm;
  private String fileDispNm;
  private String updateUsr;
  private String updateDt;
  private String createUsr;
  private String createDt;
}
