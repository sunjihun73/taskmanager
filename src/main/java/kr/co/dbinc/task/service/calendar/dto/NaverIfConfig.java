package kr.co.dbinc.task.service.calendar.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NaverIfConfig
{
  private String domainName;
  private String company;
  private String serviceAccount;
  private String clientId;
  private String clientSecret;
  private String privateKey;
  private String useYn;
}
