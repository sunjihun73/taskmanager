package kr.co.dbinc.task.dto.reporttask;

import kr.co.dbinc.task.dto.file.InsertFileRequest;
import kr.co.dbinc.task.dto.task.InsertTaskEmpRequest;
import lombok.*;

import java.util.List;

@Getter 
@Setter
@Builder
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class InsertReportTaskDTO
{
  private String domainId;
  private String companyCd;
  private String taskId;
  private String taskTitle;
  private String taskDetail;
  private String taskStateCd;
  private String taskDt;
  private String taskOwnerMemberId;
  private String taskReceiverMemberId;
  private String taskReceiverCompanyCd;
  private String taskReviewContent;
  private String taskReviewDt;
  private String delYn;
  private String epSsoApiGwUrl;
  private String epSystemId;
  private String updateUsr;
  private String updateDt;
  private String createUsr;
  private String createDt;
  private String reportTaskCfmYn;
  private List<InsertTaskEmpRequest> empList;
  private List<InsertFileRequest> fileList;
}
