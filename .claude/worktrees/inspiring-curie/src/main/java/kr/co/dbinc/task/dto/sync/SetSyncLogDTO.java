package kr.co.dbinc.task.dto.sync;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class SetSyncLogDTO
{
  private String seq;
  private String syncDiv;
  private String autoDiv;
  private String domainId;
  private String companyCd;
  private String tempDomainId;
  private String empSyncResult;
  private String deptSyncResult;
  private String codeSyncResult;
}
