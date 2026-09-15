package kr.co.dbinc.task.service.calendar;

import kr.co.dbinc.task.dto.task.InsertTaskRequest;

import java.io.IOException;
import java.security.GeneralSecurityException;

public interface CalendarApiService
{
  String insertCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException;
  void updateCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException;
  void deleteCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException;
}
