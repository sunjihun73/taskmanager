package kr.co.dbinc.task.service.calendar;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Header;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import kr.co.dbinc.task.dto.task.InsertTaskEmpRequest;
import kr.co.dbinc.task.dto.task.InsertTaskRequest;
import kr.co.dbinc.task.exception.CommonException;
import kr.co.dbinc.task.exception.ErrorCode;
import kr.co.dbinc.task.mapper.task.TaskMapper;
import kr.co.dbinc.task.service.calendar.dto.NaverIfConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.time.LocalDate;
import java.util.*;

@Component
@Slf4j
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class NaverCalendarService implements CalendarApiService
{
  private final TaskMapper taskMapper;
  private final RestTemplate restTemplate;
  private final String authUrl = "https://auth.worksmobile.com/oauth2/v2.0/token";

  @Override
  public String insertCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException
  {
    NaverIfConfig naverIfConfig = taskMapper.getNaverIfConfig(request)
        .orElseThrow(() -> new CommonException(ErrorCode.BAD_REQUEST));
    String accessToken = getAccessToken(naverIfConfig);
    String naverworksMemberId = getMemberId(accessToken, request.getTaskOwnerMemberId());

    return makeNaverCalendarEvent(accessToken, naverworksMemberId, request);
  }

  @Transactional
  @Override
  public void updateCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException
  {
    NaverIfConfig naverIfConfig = taskMapper.getNaverIfConfig(request).orElseThrow(() -> new CommonException(ErrorCode.BAD_REQUEST));
    String accessToken = getAccessToken(naverIfConfig);
    String naverworksMemberId = getMemberId(accessToken, request.getTaskOwnerMemberId());
    boolean isExist = checkCalendarEvent(accessToken, naverworksMemberId, request.getCalendarEventId());

    if(isExist)
    {
      updateNaverCalendarEvent(accessToken, naverworksMemberId, request);
    }
    else
    {
      makeNaverCalendarEvent(accessToken, naverworksMemberId, request);
    }
  }

  @Transactional
  @Override
  public void deleteCalendarEvent(InsertTaskRequest request) throws IOException, GeneralSecurityException
  {
    NaverIfConfig naverIfConfig = taskMapper.getNaverIfConfig(request).orElseThrow(() -> new CommonException(ErrorCode.BAD_REQUEST));
    String accessToken = getAccessToken(naverIfConfig);
    String naverworksMemberId = getMemberId(accessToken, request.getTaskOwnerMemberId());
    boolean isExist = checkCalendarEvent(accessToken, naverworksMemberId, request.getCalendarEventId());
    if(isExist) deleteNaverCalendarEvent(accessToken, naverworksMemberId, request);
  }

  private String getAccessToken(NaverIfConfig naverIfConfig)
  {
    String clientId = naverIfConfig.getClientId();
    String clientSecret = naverIfConfig.getClientSecret();
    String serviceAccount = naverIfConfig.getServiceAccount();
    String privateKeyStr = naverIfConfig.getPrivateKey();
    String accessToken;

    try
    {
      byte[] pkcs8EncodedBytes = Base64.getDecoder().decode(privateKeyStr);
      PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(pkcs8EncodedBytes);
      KeyFactory keyFactory = KeyFactory.getInstance("RSA");
      PrivateKey privateKey = keyFactory.generatePrivate(keySpec);

      Calendar calendar = Calendar.getInstance();
      calendar.setTime(new Date());
      calendar.add(Calendar.HOUR, 1);
      Date oneHourLater = calendar.getTime();
      Claims claims = Jwts.claims().setIssuer(clientId).setSubject(serviceAccount).setIssuedAt(new Date()).setExpiration(oneHourLater);

      String jwtt = Jwts.builder()
          .setHeaderParam("alg", "RS256")
          .setHeaderParam(Header.TYPE, Header.JWT_TYPE)
          .setClaims(claims)
          .signWith(privateKey, SignatureAlgorithm.RS256)
          .compact();

      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
      headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

      MultiValueMap<String, String> requestMap = new LinkedMultiValueMap<>();
      requestMap.add("assertion", jwtt);
      requestMap.add("grant_type", "urn:ietf:params:oauth:grant-type:jwt-bearer");
      requestMap.add("client_id", clientId);
      requestMap.add("client_secret", clientSecret);
      requestMap.add("scope", "calendar user.read directory.read");
      HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(requestMap, headers);
      ResponseEntity<Map> response = restTemplate.exchange(authUrl, HttpMethod.POST, request, Map.class);
      accessToken = (String) response.getBody().get("access_token");
      return accessToken;
    }
    catch (NoSuchAlgorithmException | InvalidKeySpecException e)
    {
      throw new CommonException(ErrorCode.INVALID_DATA);
    }
  }

  private String getMemberId(String accessToken, String email)
  {
    String calendarEventUrl = "https://www.worksapis.com/v1.0/users/" + email;
    HttpHeaders headers = new HttpHeaders();
    headers.setBearerAuth(accessToken);
    HttpEntity<?> entity = new HttpEntity<>(headers);
    ResponseEntity<Map> forEntity = restTemplate.exchange(calendarEventUrl, HttpMethod.GET, entity, Map.class);
    return (String) forEntity.getBody().get("userId");
  }

  private String makeNaverCalendarEvent(String accessToken, String naverworksMemberId, InsertTaskRequest request)
  {
    String calendarEventUrl = "https://www.worksapis.com/v1.0/users/"+naverworksMemberId+"/calendar/events";
    JSONObject event = makeEvent(request);

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    headers.setBearerAuth(accessToken);

    HttpEntity<String> requestEntity = new HttpEntity<>(event.toString(), headers);
    ResponseEntity<Map> responseEntity = restTemplate.exchange(calendarEventUrl, HttpMethod.POST, requestEntity, Map.class);
    log.debug("responseEntity::{}", responseEntity.getBody());
    List<Map<String,Object>> eventComponents = (List<Map<String, Object>>) responseEntity.getBody().get("eventComponents");
    return (String)eventComponents.get(0).get("eventId");
  }

  private void updateNaverCalendarEvent(String accessToken, String naverworksMemberId, InsertTaskRequest request) {
    String calendarEventUrl = "https://www.worksapis.com/v1.0/users/"+naverworksMemberId+"/calendar/events/"+request.getCalendarEventId();
    JSONObject event = makeEvent(request);

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    headers.setBearerAuth(accessToken);

    HttpEntity<String> requestEntity = new HttpEntity<>(event.toString(), headers);
    ResponseEntity<Map> responseEntity = restTemplate.exchange(calendarEventUrl, HttpMethod.PUT, requestEntity, Map.class);
    log.debug("responseEntity::{}", responseEntity.getBody());
  }

  private void deleteNaverCalendarEvent(String accessToken, String naverworksMemberId, InsertTaskRequest request) {
    String calendarEventUrl = "https://www.worksapis.com/v1.0/users/"+naverworksMemberId+"/calendar/events/"+request.getCalendarEventId();
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    headers.setBearerAuth(accessToken);

    HttpEntity<String> requestEntity = new HttpEntity<>(headers);
    ResponseEntity<Map> responseEntity = restTemplate.exchange(calendarEventUrl, HttpMethod.DELETE, requestEntity, Map.class);
    log.debug("responseEntity::{}", responseEntity.getBody());
  }

  private boolean checkCalendarEvent(String accessToken, String naverworksMemberId, String eventId) {
    boolean isExist = true;
    String calendarEventUrl = "https://www.worksapis.com/v1.0/users/"+naverworksMemberId+"/calendar/events/"+eventId;

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    headers.setBearerAuth(accessToken);
    HttpEntity<String> requestEntity = new HttpEntity<>(headers);

    try
    {
      ResponseEntity<Map> responseEntity = restTemplate.exchange(calendarEventUrl, HttpMethod.GET, requestEntity, Map.class);
      log.debug("checkResponseEntity::{}", responseEntity.getBody());
    }
    catch (HttpClientErrorException e)
    {
      isExist = false;
    }
    return isExist;
  }

  private JSONObject makeEvent(InsertTaskRequest request)
  {
    String timezone = "Asia/Seoul";

    JSONObject objParam = new JSONObject();
    JSONArray eventComponents = new JSONArray();

    JSONObject organizerObj = new JSONObject();
    organizerObj.put("email", request.getTaskOwnerMemberId());
    organizerObj.put("displayName", request.getEmpNm());

    JSONObject startObj = new JSONObject();
    String startDt = request.getTaskStartDt();
    startDt = startDt.substring(0,4) + "-" + startDt.substring(4,6) + "-" + startDt.substring(6,8);
    startObj.put("date", startDt);
    startObj.put("timeZone", timezone);

    //종료일 지정(+1일 해줘야함)
    JSONObject endObj = new JSONObject();
    String endDt = request.getTaskEndDt();
    int endYear = Integer.parseInt(endDt.substring(0,4));
    int endMonth = Integer.parseInt(endDt.substring(4,6));
    int endDay = Integer.parseInt(endDt.substring(6,8));
    LocalDate endDate = LocalDate.of(endYear, endMonth, endDay).plusDays(1);
    endObj.put("date", endDate.toString());
    endObj.put("timeZone", timezone);

    JSONArray attendeesArr = new JSONArray();
    JSONObject ownerObj = new JSONObject();
    ownerObj.put("email", request.getTaskOwnerMemberId());
    ownerObj.put("displayName", request.getEmpNm());
    attendeesArr.add(ownerObj);

    //참석자 추가
    if(request.getEmpList() != null)
    {
      for(InsertTaskEmpRequest emp :request.getEmpList())
      {
        JSONObject attendeeObj = new JSONObject();
        attendeeObj.put("email", emp.getEmail());
        attendeesArr.add(attendeeObj);
      }
    }

    JSONArray remindersArr = new JSONArray();
    JSONObject reminderObj = new JSONObject();
    reminderObj.put("method", "DISPLAY");
    reminderObj.put("trigger", "-PT15H30M");//전날 8:30
    remindersArr.add(reminderObj);

    JSONObject eventObj = new JSONObject();
    eventObj.put("summary", request.getTaskNm());
    eventObj.put("description", request.getTaskDetail());
    eventObj.put("organizer", organizerObj);
    eventObj.put("start", startObj);
    eventObj.put("end", endObj);
    eventObj.put("visibility", "PRIVATE");
    eventObj.put("attendees", attendeesArr);
    eventObj.put("reminders", remindersArr);

    if(request.getCalendarEventId() != null && !request.getCalendarEventId().isEmpty())
    {
      eventObj.put("eventId", request.getCalendarEventId());
    }

    eventComponents.add(eventObj);
    objParam.put("eventComponents",eventComponents);

    return objParam;
  }
}
