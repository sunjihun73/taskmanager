package kr.co.dbinc.task.service.calendar;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class CalendarServiceFactory
{
  private final GoogleCalendarService googleCalendarService;
  private final NaverCalendarService naverCalendarService;
  private final TempCalendarService tempCalendarService;

  public CalendarApiService getCalendarService(String oauthType)
  {
    if ("Google".toUpperCase().equals(oauthType.toUpperCase()))
    {
      return googleCalendarService;
    }
    else if ("Naver".equals(oauthType))
    {
      return naverCalendarService;
    }
    else
    {
      return tempCalendarService;
    }
  }
}
