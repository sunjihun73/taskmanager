package kr.co.dbinc.task.util;

import lombok.experimental.UtilityClass;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;
import java.util.UUID;

@UtilityClass
public class Util
{
  public static String getGuid()
  {
    return UUID.randomUUID().toString();
  }
  
  public static String getUniqueKey(String Prefix)
  {
    return Prefix + "_" + UUID.randomUUID().toString();
  }
  
  public static String getExtension(String originName) 
  {
    int lastIndexOf = originName.lastIndexOf(".");
    
    if (lastIndexOf == -1) 
    {
        return "";
    }
    
    return originName.substring(lastIndexOf);
  }

  public static void disableSslVerification() throws Exception
  {
    TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager()
    {
      public void checkClientTrusted(X509Certificate[] certs, String authType) {}

      public void checkServerTrusted(X509Certificate[] certs, String authType) {}

      public X509Certificate[] getAcceptedIssuers()
      {
        return new X509Certificate[0];
      }
    } };
    SSLContext sc = SSLContext.getInstance("TLS");
    sc.init(null, trustAllCerts, new java.security.SecureRandom());
    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
    HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);
  }
}
