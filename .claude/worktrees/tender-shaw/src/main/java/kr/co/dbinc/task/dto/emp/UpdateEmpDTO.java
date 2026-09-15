package kr.co.dbinc.task.dto.emp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class UpdateEmpDTO
{
  private String domainId;
  private String companyCd;
  private String email;
  private String updateUsr;
  private String manualMngYn;
  private String hiddenYn;
}
