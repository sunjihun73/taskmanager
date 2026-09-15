package kr.co.dbinc.task.dto.dept;

import jakarta.validation.constraints.NotBlank;
import lombok.*;



@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class GetDeptDetailDTO
{
  
  @Getter @Setter
  @NoArgsConstructor(force = true)
  @AllArgsConstructor
  public static class GetDeptDetailRequest {
    private String domainId;
    private String companyCd;
    @NotBlank(message = "부서코드가 존재하지 않습니다.")
    private String deptCd;
    private String parentDeptCd;
  }
  
  @Getter @Setter
  public static class GetDeptDetailResponse {
    private String deptCd;
    private String deptNm;
    private String parentDeptCd;
    private String parentDeptNm;
    private String deptOrd;
    private String deptUseYn;
  }
}
