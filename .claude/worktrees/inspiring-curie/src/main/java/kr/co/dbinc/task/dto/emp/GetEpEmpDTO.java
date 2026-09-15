package kr.co.dbinc.task.dto.emp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class GetEpEmpDTO
{
  private String domainName;
  private String company;
  private String email;
  private String empNo;
  private String name;
  private String engName;
  private String positionCode;
  private String dutyPosition;
  private String rankPosition;
  private String deptCode;
  private String stateStatusCode;
  private String jobTelNo;
  private String mobileTelNo;
  private String entryDate;
  private String quitDate;
  private String manualMngYn;
  private String hiddenYn;
  private String delYn;
}
