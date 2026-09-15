package kr.co.dbinc.task.util;

import com.mailgun.api.v3.MailgunMessagesApi;
import com.mailgun.model.message.Message;
import com.mailgun.model.message.MessageResponse;
import kr.co.dbinc.task.dto.comment.ChangeCommentRequest;
import kr.co.dbinc.task.dto.comment.CommentEmpRequest;
import kr.co.dbinc.task.dto.emp.GetEmpDTO;
import kr.co.dbinc.task.dto.reporttask.SelectReportTaskDTO;
import kr.co.dbinc.task.dto.company.GetCompanyDTO;
import kr.co.dbinc.task.dto.task.GetTaskDetailDTO;
import kr.co.dbinc.task.dto.task.InsertTaskEmpRequest;
import kr.co.dbinc.task.dto.task.InsertTaskRequest;
import kr.co.dbinc.task.mapper.task.CompanyMapper;
import kr.co.dbinc.task.mapper.task.EmpMapper;
import kr.co.dbinc.task.mapper.task.ReportTaskMapper;
import kr.co.dbinc.task.mapper.task.TaskMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.*;

@Slf4j
@Component
@RequiredArgsConstructor
public class MailgunUtil
{
  private final EmpMapper empMapper;
  private final TaskMapper taskMapper;
  private final CompanyMapper companyMapper;
  private final ReportTaskMapper reportTaskMapper;
  private final MailgunMessagesApi mailgunMessagesApi;

  @Value("${mailgun.apikey}")
  String mMailgunApiKey;

  @Value("${mailgun.sender}")
  String mMailgunSender;

  @Value("${mailgun.domain}")
  String mMailgunDomain;

  @Value("${mailgun.mailTemplate}")
  String mMailgunMailTemplate;

  @Value("${system.url}")
  String mSystemUrl;

  // 태스크 등록시 참여자에게 알림 메일 전송
  public void sendTaskAddMail(InsertTaskRequest request)
  {
    log.debug("■ MailgunUtil : sendTaskAddMail");
    String mailTemplateStr = "";
    StringBuffer mailSubject = new StringBuffer();
    StringBuffer mailTitle = new StringBuffer();
    StringBuffer mailSubTitle = new StringBuffer();
    StringBuffer mailMsg = new StringBuffer();
    StringBuffer mailBtnLink = new StringBuffer();
    StringBuffer returnValue = new StringBuffer();

    try
    {
      // TASK_OWNER_MEMBER_ID 를 이용해 현재 태스크의 소유자 정보를 조회한다.
      GetEmpDTO.GetEmpRequest reqEmp = new GetEmpDTO.GetEmpRequest();
      reqEmp.setDomainId(request.getDomainId());
      reqEmp.setEmail(request.getTaskOwnerMemberId());
      GetEmpDTO.GetEmpResponse ownerEmp = empMapper.getEmp(reqEmp);

      mailSubject.append("[태스크 등록] 태스크가 등록되었습니다.");
      mailTitle.append("[태스크 등록]");
      mailSubTitle.append("[태스크명] ");
      mailSubTitle.append(request.getTaskNm());
      mailMsg.append("[소유자] ");
      mailMsg.append(request.getEmpNm());

      returnValue.append("/page/taskmng/taskdetailform?taskId=");
      returnValue.append(request.getTaskId());

      mailTemplateStr = getMailTemplate();
      mailTemplateStr = mailTemplateStr.replace("{_TITLE_}", mailTitle.toString());
      mailTemplateStr = mailTemplateStr.replace("{_SUB_TITLE_}", mailSubTitle.toString());
      mailTemplateStr = mailTemplateStr.replace("{_MESSAGE_}", mailMsg.toString());

      //회사별 메일 링크를 생성하기위한 정보 조회
      List<GetCompanyDTO.GetCompanyResponse> companies = companyMapper.getCompaniesForMail(request.getDomainId());
      Map<String, GetCompanyDTO.GetCompanyResponse> companyMap = new HashMap<>();
      for (GetCompanyDTO.GetCompanyResponse company : companies)
      {
        companyMap.put(company.getCompanyCd(), company);
      }

      for (InsertTaskEmpRequest emp : request.getEmpList())
      {
        GetCompanyDTO.GetCompanyResponse response = companyMap.get(emp.getCompanyCd());
        mailBtnLink.append(response.getEpSsoApiGwUrl());
        mailBtnLink.append("?");
        mailBtnLink.append("systemId=");
        mailBtnLink.append(response.getEpSystemId());
        mailBtnLink.append("&returnValue=");
        mailBtnLink.append(URLEncoder.encode(returnValue.toString(), "UTF-8"));
        log.debug("◆ Mail Link Str : " + mailBtnLink.toString());

        mailTemplateStr = mailTemplateStr.replace("{_TARGET_URL_}", mailBtnLink.toString());

        sendMail(emp.getEmail(), mailSubject.toString(), mailTemplateStr);
      }

    } catch (Exception e)
    {
      e.printStackTrace();
    }
  }

  //태스크에 댓글 등록시 소유자에게 알림 메일 전송
  public void sendCommentAddMail(ChangeCommentRequest request)
  {
    log.debug("■ MailgunUtil : sendTaskAddMail");
    String mailTemplateStr = "";
    StringBuffer mailSubject = new StringBuffer();
    StringBuffer mailTitle = new StringBuffer();
    StringBuffer mailSubTitle = new StringBuffer();
    StringBuffer mailMsg = new StringBuffer();
    StringBuffer mailBtnLink = new StringBuffer();
    StringBuffer returnValue = new StringBuffer();

    GetTaskDetailDTO.GetTaskDetailRequest taskReq = new GetTaskDetailDTO.GetTaskDetailRequest();
    taskReq.setDomainId(request.getDomainId());
    taskReq.setCompanyCd(request.getCompanyCd());
    taskReq.setTaskId(request.getTaskId());
    GetTaskDetailDTO.GetTaskDetailResponse taskRes = taskMapper.getTaskDetail(taskReq);

    try
    {
      mailSubject.append("[댓글 등록] '" + taskRes.getTaskNm() + "' 태스크에 댓글이 등록되었습니다.");
      mailTitle.append("[댓글 등록]");
      mailSubTitle.append("[댓글 내용] ");
      mailSubTitle.append(request.getCommentContent());
      mailMsg.append("[작성자] ");
      mailMsg.append(request.getEmpNm());

      returnValue.append("/page/taskmng/taskdetailform?taskId=");
      returnValue.append(request.getTaskId());

      mailTemplateStr = getMailTemplate();
      mailTemplateStr = mailTemplateStr.replace("{_TITLE_}", mailTitle.toString());
      mailTemplateStr = mailTemplateStr.replace("{_SUB_TITLE_}", mailSubTitle.toString());
      mailTemplateStr = mailTemplateStr.replace("{_MESSAGE_}", mailMsg.toString());

      //회사별 메일 링크를 생성하기위한 정보 조회
      List<GetCompanyDTO.GetCompanyResponse> companies = companyMapper.getCompaniesForMail(request.getDomainId());
      Map<String, GetCompanyDTO.GetCompanyResponse> companyMap = new HashMap<>();
      for (GetCompanyDTO.GetCompanyResponse company : companies)
      {
        companyMap.put(company.getCompanyCd(), company);
      }

      for (CommentEmpRequest emp : request.getToEmpList())
      {
        GetCompanyDTO.GetCompanyResponse response = companyMap.get(emp.getCompanyCd());
        mailBtnLink.append(response.getEpSsoApiGwUrl());
        mailBtnLink.append("?");
        mailBtnLink.append("systemId=");
        mailBtnLink.append(response.getEpSystemId());
        mailBtnLink.append("&returnValue=");
        mailBtnLink.append(URLEncoder.encode(returnValue.toString(), "UTF-8"));
        log.debug("◆ Mail Link Str : " + mailBtnLink.toString());

        mailTemplateStr = mailTemplateStr.replace("{_TARGET_URL_}", mailBtnLink.toString());

        sendMail(emp.getEmail(), mailSubject.toString(), mailTemplateStr);
      }

    } catch (Exception e)
    {
      e.printStackTrace();
    }
  }

  /** 일일업무보고 보고시 보고 대상자에게 알림 메일 전송 */
  public void sendRtSendMail(String taskId, String domainId, String companyCd, String receiverCompanyCd, List<InsertTaskEmpRequest> empList)
  {
    log.debug("■ MailgunUtil : sendRtSendMail");
    String mailTemplateStr = "";
    StringBuffer mailSubject = new StringBuffer();
    StringBuffer mailTitle = new StringBuffer();
    StringBuffer mailSubTitle = new StringBuffer();
    StringBuffer mailMsg = new StringBuffer();
    StringBuffer mailBtnLink = new StringBuffer();
    StringBuffer returnValue = new StringBuffer();
    Map<String, Object> paramsMap = new HashMap<>();

    paramsMap.put("taskId", taskId);
    paramsMap.put("domainId", domainId);
    paramsMap.put("companyCd", companyCd);
    paramsMap.put("delYn", C.NO);
    SelectReportTaskDTO selectReportTaskDTO = reportTaskMapper.selectReportTaskMaster(paramsMap);

    try
    {
      mailSubject.append("[일일업무보고 도착] 일일업무보고 태스크 건이 도착하였습니다.");
      mailTitle.append("[일일업무보고 도착]");
      mailSubTitle.append("[태스크명] ");
      mailSubTitle.append(selectReportTaskDTO.getTaskTitle());
      mailMsg.append("[작성자] ");
      mailMsg.append(selectReportTaskDTO.getTaskOwnerMemberNm());

      mailTemplateStr = getMailTemplate();
      mailTemplateStr = mailTemplateStr.replace("{_TITLE_}",      mailTitle.toString());
      mailTemplateStr = mailTemplateStr.replace("{_SUB_TITLE_}",  mailSubTitle.toString());
      mailTemplateStr = mailTemplateStr.replace("{_MESSAGE_}",    mailMsg.toString());

      //메일 링크를 생성하기위한 회사 정보 조회
      //      GetCompanyResponse company = companyMapper.getCompanyForMail(domainId, receiverCompanyCd);
      List<GetCompanyDTO.GetCompanyResponse> companies = companyMapper.getCompaniesForMail(domainId);
      Map<String, GetCompanyDTO.GetCompanyResponse> companyMap = new HashMap<>();
      for(GetCompanyDTO.GetCompanyResponse company : companies) {
        companyMap.put(company.getCompanyCd(), company);
      }

      for(InsertTaskEmpRequest emp : empList)
      {
        GetCompanyDTO.GetCompanyResponse response = companyMap.get(emp.getCompanyCd());
        mailBtnLink.append(response.getEpSsoApiGwUrl());
        mailBtnLink.append("?");
        mailBtnLink.append("systemId=");
        mailBtnLink.append(response.getEpSystemId());
        mailBtnLink.append("&returnValue=");
        returnValue.append(mSystemUrl);
        returnValue.append("user/reporttasks/recvreporttaskupdateform?pTaskId=");
        returnValue.append(selectReportTaskDTO.getTaskId());
        mailBtnLink.append(URLEncoder.encode(returnValue.toString(), "UTF-8"));
//        mailBtnLink.append(returnValue.toString());
        log.debug("◆ Mail Link Str : " + mailBtnLink.toString());

        mailTemplateStr = mailTemplateStr.replace("{_TARGET_URL_}", mailBtnLink.toString());

        log.debug("==============================================");
        log.debug(mailTemplateStr);
        log.debug("==============================================");
        sendMail(emp.getEmail(), mailSubject.toString(), mailTemplateStr);
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
  }

  /** 일일업무보고 수신건 확인시 작성자에게 리턴 메일 */
  public void sendRtConfirmMail(String taskId, String domainId, String companyCd)
  {
    log.debug("■ MailgunUtil : sendRtConfirmMail");
    String mailTemplateStr = "";
    StringBuffer mailSubject = new StringBuffer();
    StringBuffer mailTitle = new StringBuffer();
    StringBuffer mailSubTitle = new StringBuffer();
    StringBuffer mailMsg = new StringBuffer();
    StringBuffer mailBtnLink = new StringBuffer();
    StringBuffer returnValue = new StringBuffer();
    Map<String, Object> paramsMap = new HashMap<>();

    paramsMap.put("taskId", taskId);
    paramsMap.put("domainId", domainId);
    paramsMap.put("companyCd", companyCd);
    paramsMap.put("delYn", C.NO);
    SelectReportTaskDTO selectReportTaskDTO = reportTaskMapper.selectReportTaskMaster(paramsMap);

    try
    {
      mailSubject.append("[일일업무보고 확인도착] 일일업무보고 태스크 건이 확인되었습니다.");
      mailTitle.append("[일일업무보고 확인도착]");
      mailSubTitle.append("[태스크명] ");
      mailSubTitle.append(selectReportTaskDTO.getTaskTitle());
      mailMsg.append("[확인자] ");
      mailMsg.append(selectReportTaskDTO.getTaskReceiverMemberNm());

      //메일 링크를 생성하기위한 회사 정보 조회
      GetCompanyDTO.GetCompanyResponse company = companyMapper.getCompanyForMail(domainId, selectReportTaskDTO.getCompanyCd());

      mailBtnLink.append(company.getEpSsoApiGwUrl());
      mailBtnLink.append("?");
      mailBtnLink.append("systemId=");
      mailBtnLink.append(company.getEpSystemId());
      mailBtnLink.append("&returnValue=");

      returnValue.append(mSystemUrl);
      returnValue.append("user/reporttasks/reporttaskviewform?pTaskId=");
      returnValue.append(selectReportTaskDTO.getTaskId());
      mailBtnLink.append(URLEncoder.encode(returnValue.toString(), "UTF-8"));
//      mailBtnLink.append(returnValue.toString());

      mailTemplateStr = getMailTemplate();
      mailTemplateStr = mailTemplateStr.replace("{_TITLE_}",      mailTitle.toString());
      mailTemplateStr = mailTemplateStr.replace("{_SUB_TITLE_}",  mailSubTitle.toString());
      mailTemplateStr = mailTemplateStr.replace("{_MESSAGE_}",    mailMsg.toString());
      mailTemplateStr = mailTemplateStr.replace("{_TARGET_URL_}", mailBtnLink.toString());

      sendMail(selectReportTaskDTO.getTaskOwnerMemberId(), mailSubject.toString(), mailTemplateStr);
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
  }

  // 메일 전송
  @Async
  protected void sendMail(String to, String subject, String mailStr)
  {
    try
    {
      Message message = Message.builder()
          .from(mMailgunSender)
          .to(to)
          .subject(subject)
          .html(mailStr)
          .build();

      MessageResponse mr = mailgunMessagesApi.sendMessage(mMailgunDomain, message);
      log.debug("◆ sendMail Send Result :: " + mr.getMessage());
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
  }

//  // 메일 전송
//  @Async
//  protected void sendMails(ArrayList<String> tos, String subject, String mailStr)
//  {
//    MailgunMessagesApi mailgunMessagesApi = MailgunClient.config(mMailgunApiKey).createAsyncApi(MailgunMessagesApi.class);
//
//    try
//    {
//      Message message = Message.builder().from(mMailgunSender).to(tos).subject(subject).html(mailStr).build();
//
//      MessageResponse mr = mailgunMessagesApi.sendMessage(mMailgunDomain, message);
//      log.debug("◆ sendMails Send Result :: " + mr.getMessage());
//    } catch (Exception e)
//    {
//      e.printStackTrace();
//    }
//  }

  private String getMailTemplate()
  {
    StringBuffer tmp = new StringBuffer();

    try
    {
      tmp.append(IOUtils.toString(getClass().getResourceAsStream("/templates/" + mMailgunMailTemplate), "UTF-8"));
    }
    catch (IOException ioe)
    {
      log.error(Arrays.toString(ioe.getStackTrace()));
    }
    catch (Exception e)
    {
      log.error(Arrays.toString(e.getStackTrace()));
    }

    return tmp.toString();
  }
}
