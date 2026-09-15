package kr.co.dbinc.task.service.calendar;

import kr.co.dbinc.task.dto.task.InsertTaskRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.security.GeneralSecurityException;

@Component
@Slf4j
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TempCalendarService implements CalendarApiService
{
  @Override
  public String insertCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException {return null;}

  @Override
  public void updateCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException {}

  @Override
  public void deleteCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException {}
}
