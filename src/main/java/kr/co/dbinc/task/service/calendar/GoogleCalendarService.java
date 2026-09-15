package kr.co.dbinc.task.service.calendar;

import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpRequestInitializer;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.CalendarScopes;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventAttendee;
import com.google.api.services.calendar.model.EventDateTime;
import com.google.api.services.calendar.model.EventReminder;
import com.google.auth.http.HttpCredentialsAdapter;
import com.google.auth.oauth2.GoogleCredentials;
import kr.co.dbinc.task.dto.task.InsertTaskEmpRequest;
import kr.co.dbinc.task.dto.task.InsertTaskRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.ResourceUtils;

import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Slf4j
@Component
public class GoogleCalendarService implements CalendarApiService
{
  private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();

  @Value("${keyFileName}")
  String keyFileName;

  @Value("${googleServiceId}")
  String googleServiceId;

  /**
   * Google Calendar에 이벤트를 추가하고 이벤트 ID를 반환한다.
   * @param request
   * @return calendarEventId
   * @throws IOException
   * @throws GeneralSecurityException
   */
  @Override
  public String insertCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException
  {
    log.debug("■ GoogleCalendarService.insertCalendarEvent");
    Calendar service = this.getCalendarService(googleServiceId);
    Event event = createGoogleCalendarEvent(request);

    // 구글 캘린더 이벤트 생성
    event = service.events().insert(googleServiceId, event).execute();
    log.debug("Event created: {}", event.getHtmlLink());
    return event.getId();
  }

  /**
   * @apiNote Google Calendar 수정
   * @param 'InsertTaskRequest'
   */
  @Override
  public void updateCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException
  {
    log.debug("■ GoogleCalendarService.updateCalendarEvent");
    Calendar service = this.getCalendarService(googleServiceId);

    //이벤트 실행
    String eventId = request.getCalendarEventId();
    Event newEvent = createGoogleCalendarEvent(request);
    service.events().update(googleServiceId, eventId, newEvent).execute();
    log.debug("Event update: {}", eventId);
  }

  /**
   * @apiNote Google Calendar 삭제
   * @param 'InsertTaskRequest'
   */
  @Override
  public void deleteCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException
  {
    log.debug("■ GoogleCalendarService.deleteCalendarEvent");
    Calendar service = this.getCalendarService(googleServiceId);

    //이벤트 실행
    String eventId = request.getCalendarEventId();
    service.events().delete(googleServiceId, eventId).execute();
    log.debug("Event deleted: {}", eventId);
  }

  /**
   * 구글 캘린더 서비스 객체를 생성하여 반환한다. 이 서비스 객체는 특정 사용자의 권한을 위임받아 동작한다.
   * @param delegatedUserEmail 권한을 위임받은 사용자의 이메일 주소
   * @return Google Calendar Service 객체
   * @throws IOException 인증 실패 시
   * @throws GeneralSecurityException 보안 설정 실패 시
   */
  private Calendar getCalendarService(String delegatedUserEmail) throws IOException, GeneralSecurityException
  {
    HttpTransport httpTransport = GoogleNetHttpTransport.newTrustedTransport();
    GoogleCredentials credentials = getDelegatedCredentials(delegatedUserEmail);
    HttpRequestInitializer requestInitializer = new HttpCredentialsAdapter(credentials);

    // Builder 패턴으로 서비스 객체 생성
    return new Calendar.Builder(httpTransport, JSON_FACTORY, requestInitializer)
        .setApplicationName("taskManager")
        .build();
  }

  /**
   * 구글 서비스 계정으로 GoogleCredentials 객체를 생성하고 특정 사용자에게 권한을 위임한다.
   * @param delegatedUserEmail 권한을 위임받을 사용자의 이메일 주소
   * @return GoogleCredentials 객체
   * @throws IOException 파일 읽기 실패 시
   */
  private GoogleCredentials getDelegatedCredentials(String delegatedUserEmail) throws IOException
  {
    log.debug("■ userTaskService.getDelegatedCredentials - delegatedUserEmail: {}", delegatedUserEmail);

    try
    {
      // Classpath에서 서비스 계정 JSON 파일을 읽어 스트림으로 가져온다.
      InputStream keyFileStream = ResourceUtils.getURL("classpath:" + keyFileName).openStream();

      // GoogleCredentials.fromStream()으로 자격 증명을 생성하고
      // createDelegated() 메서드를 호출하여 위임받을 사용자를 지정한다.
      // 그리고 필요한 스코프(접근 권한)를 설정한다.
      return GoogleCredentials.fromStream(keyFileStream)
          .createDelegated(delegatedUserEmail)
          .createScoped(Collections.singleton(CalendarScopes.CALENDAR));
    }
    catch(Exception e)
    {
      e.printStackTrace();
      return null;
    }
  }

  /**
   * InsertTaskRequest 객체를 기반으로 구글 캘린더 이벤트 객체를 생성한다.
   * @param request 일정 생성에 필요한 정보를 담은 요청 객체
   * @return 구글 캘린더 Event 객체
   */
  private Event createGoogleCalendarEvent(InsertTaskRequest request)
  {
    // 1. 이벤트 기본 정보(제목, 설명)를 설정한다.
    Event event = new Event()
        .setSummary(request.getTaskNm())
        .setDescription(request.getTaskDetail());

    // 2. 시작일과 종료일을 설정한다.
    setEventDateTimes(event, request.getTaskStartDt(), request.getTaskEndDt());

    // 3. 참석자 목록을 설정한다.
    setEventAttendees(event, request.getTaskOwnerMemberId(), request.getEmpList());

    // 4. 반복 및 알림 정보를 설정한다.
    setEventRecurrenceAndReminders(event);

    return event;
  }

  /**
   * 이벤트의 시작일과 종료일을 설정한다.
   * @param event 설정할 Event 객체
   * @param startDateStr 시작일 문자열 (yyyyMMdd)
   * @param endDateStr 종료일 문자열 (yyyyMMdd)
   */
  private void setEventDateTimes(Event event, String startDateStr, String endDateStr)
  {
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");

    // 시작일 지정
    LocalDate startDate = LocalDate.parse(startDateStr, formatter);
    EventDateTime start = new EventDateTime()
        .setDate(new DateTime(startDate.toString()))
        .setTimeZone("Asia/Seoul");
    event.setStart(start);

    // 종료일 지정 (+1일 해줘야 구글 캘린더에서 '종일' 이벤트로 올바르게 표시된다)
    LocalDate endDate = LocalDate.parse(endDateStr, formatter).plusDays(1);
    EventDateTime end = new EventDateTime()
        .setDate(new DateTime(endDate.toString()))
        .setTimeZone("Asia/Seoul");
    event.setEnd(end);
  }

  /**
   * 이벤트의 참석자 목록을 설정한다.
   * @param event 설정할 Event 객체
   * @param ownerEmail 소유자 이메일
   * @param empList 참석자 목록
   */
  private void setEventAttendees(Event event, String ownerEmail, List<InsertTaskEmpRequest> empList)
  {
    List<EventAttendee> attendees = new ArrayList<>();
    attendees.add(new EventAttendee().setEmail(ownerEmail));

    if (empList != null)
    {
      for (InsertTaskEmpRequest emp : empList)
      {
        attendees.add(new EventAttendee().setEmail(emp.getEmail()));
      }
    }
    event.setAttendees(attendees);
  }

  /**
   * 이벤트의 반복 설정과 알림 설정을 추가한다.
   * @param event 설정할 Event 객체
   */
  private void setEventRecurrenceAndReminders(Event event)
  {
    // 일일 반복 설정 (하루짜리 이벤트이므로 COUNT=1로 지정)
    String[] recurrence = new String[]{"RRULE:FREQ=DAILY;COUNT=1"};
    event.setRecurrence(Arrays.asList(recurrence));

    // 알림 설정 (전날 8시 30분 팝업 알림)
    EventReminder[] reminderOverrides = new EventReminder[]{
        new EventReminder().setMethod("popup").setMinutes(15 * 60 + 30)
    };
    Event.Reminders reminders = new Event.Reminders()
        .setUseDefault(false)
        .setOverrides(Arrays.asList(reminderOverrides));
    event.setReminders(reminders);
  }
}
