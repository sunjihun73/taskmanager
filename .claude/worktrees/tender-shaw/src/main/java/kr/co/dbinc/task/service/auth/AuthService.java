package kr.co.dbinc.task.service.auth;

import jakarta.servlet.http.HttpServletRequest;
import kr.co.dbinc.task.dto.ResultVO;

public interface AuthService
{
  ResultVO ssoLogin(String epToken, String userId) throws Exception;
  void ssoLogout(HttpServletRequest req) throws Exception;
}
