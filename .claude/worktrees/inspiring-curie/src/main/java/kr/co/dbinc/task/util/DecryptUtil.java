package kr.co.dbinc.task.util;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public final class DecryptUtil
{
  public static JSONObject decrypt(String epToken, String rsltData)
  {
    JSONObject joTokenRsltData = null;
    
    try
    {
      byte[] byteToken1 = epToken.substring(0, 16).getBytes();  // IVEC [16]
      byte[] byteToken2 = epToken.substring(16, 32).getBytes(); // RK [16]
      
      // seed key
      CEncryptOne ceo = new CEncryptOne(byteToken1, byteToken2);
      
      // 복호화
      String decResultObj = ceo.seedDecode(rsltData);
      
      joTokenRsltData = (JSONObject) new JSONParser().parse(decResultObj);
    } 
    catch (Exception e)
    {
      joTokenRsltData = null;
    }
    
    return joTokenRsltData;
  }
}
