package kr.co.dbinc.task.dto.comment;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class GetCommentResponse {
  private String domainId;
  private String companyCd;
  private String taskId;
  private String commentId;
  private String commentContent;
  private String commentReceiverId;
  private String commentReceiverNm;
  private String createUsr;
  private String empNm;
  private String createDt;
  private String updateDt;
}
