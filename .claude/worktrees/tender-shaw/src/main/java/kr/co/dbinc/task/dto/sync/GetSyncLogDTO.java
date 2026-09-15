package kr.co.dbinc.task.dto.sync;

import lombok.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class GetSyncLogDTO
{
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetSyncLogRequest {
    private String tempDomainId;
    private String domainId;
    private String companyCd;
    private String syncDiv;
    private String autoDiv;
    private int draw;
    private int start;
    private int length;
  }
  
  @Getter @Setter
  public static class GetSyncLogResponse {
    private String seq;
    private String syncDiv;
    private String autoDiv;
    private String syncDate;
    private String companyNm;
    private String empSyncResult;
    private String deptSyncResult;
    private String codeSyncResult;
  }
}
