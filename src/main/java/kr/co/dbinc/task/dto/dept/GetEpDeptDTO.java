package kr.co.dbinc.task.dto.dept;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class GetEpDeptDTO
{
  private String domainName;
  private String company;
  private String deptCode;
  private String startDate;
  private String endDate;
  private String parentDeptCode;
  private String deptName;
  private String deptOrd;
  private String visibleYn;
  private String path;
  private String useYn;
  private String delYn;
}
