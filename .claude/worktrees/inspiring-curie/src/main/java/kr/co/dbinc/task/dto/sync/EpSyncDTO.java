package kr.co.dbinc.task.dto.sync;

import kr.co.dbinc.task.dto.code.GetEpCodeDTO;
import kr.co.dbinc.task.dto.dept.GetEpDeptDTO;
import kr.co.dbinc.task.dto.emp.GetEpEmpDTO;
import lombok.*;

import java.util.List;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class EpSyncDTO
{

  @ToString
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class EpSyncRequest {
    private String domainId;
    private String companyCd;
    private String epEmpSyncApiUrl;
    private String epDeptSyncApiUrl;
    private String epCodeSyncApiUrl;
    private String tempDomainId;
    private String apiAuthKey;
    private String syncCode;
  }

  @ToString
  @Getter @Setter
  public static class EpSyncResponse {
    private String resultCode;
    private List<GetEpEmpDTO> empList;
    private List<GetEpDeptDTO> deptList;
    private List<GetEpCodeDTO> codeList;
    private String domainId;
    private String companyCd;
    private String tempDomainId;
  }
}
