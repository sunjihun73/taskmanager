package kr.co.dbinc.task.dto.comment;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter @Setter
public class ChangeCommentRequest {
  private String domainId;
  private String companyCd;
  private String taskId;
  private String commentId;
  private String commentContent;
  private String commentReceiverId;
  private String email;
  private String empNm;
  private String taskOwnerMemberId;
  private String epSsoApiGwUrl;
  private String epSystemId;
  private List<CommentEmpRequest> toEmpList;
}
