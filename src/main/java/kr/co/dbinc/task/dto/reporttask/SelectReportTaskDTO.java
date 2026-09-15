package kr.co.dbinc.task.dto.reporttask;

import kr.co.dbinc.task.dto.file.GetFileListResponse;
import kr.co.dbinc.task.dto.task.GetTaskEmpListResponse;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter 
@Setter
public class SelectReportTaskDTO
{
  private String domainId;
  private String companyCd;
  private String taskId;
  private String taskTitle;
  private String taskDetail;
  private String taskStateCd;
  private String taskStateNm;
  private String taskDt;
  private String taskOwnerCompanyCd;
  private String taskOwnerMemberId;
  private String taskReceiverCompanyCd;
  private String taskReceiverMemberId;
  private String taskReviewContent;
  private String taskReviewDt;
  private String delYn;
  private String taskEmpCd;
  private String taskEmpNm;
  private String taskEmpReviewDt;
  private String updateUsr;
  private String updateDt;
  private String createUsr;
  private String createDt;
  private String taskReceiverMemberNm;
  private String taskReceiverMemberEngNm;
  private String taskOwnerMemberNm;
  private String taskOwnerMemberEngNm;
  
  private List<GetTaskEmpListResponse> taskEmpList;
  private List<GetFileListResponse> fileList;
}
