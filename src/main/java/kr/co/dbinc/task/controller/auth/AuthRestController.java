package kr.co.dbinc.task.controller.auth;

import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.SessionInfoVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value="/api")
public class AuthRestController
{
  //private final AuthService authService;
  
  @Value("${spring.profiles.active}")
  String mSpringProfilesActive;
  
  @GetMapping("/getDeployStatusInfo")
  public String getDeployStatusInfo()
  {
    return mSpringProfilesActive;
  }
  
  @GetMapping("/getSessionInfo")
  public String getSessionInfo(HttpSession session)
  {
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute("sessionInfoVO");
    System.out.println("email : " + sessionInfoVO.getEmail());
    return sessionInfoVO.toString();
  }
  
//  @GetMapping(value = "/getRedisStringValue")
//  public void getRedisStringValue(String key)
//  {
//    authService.getRedisStringValue(key);
//  }
//
//  @PostMapping(value = "/setRedisStringValue")
//  public void getRedisStringValue(String key, String value)
//  {
//    authService.setRedisStringValue(key, value);
//  }
}
