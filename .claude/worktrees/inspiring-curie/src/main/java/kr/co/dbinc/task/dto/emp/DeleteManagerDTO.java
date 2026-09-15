package kr.co.dbinc.task.dto.emp;

import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


import java.util.List;

@Getter @Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class DeleteManagerDTO
{
  private String domainId;
  private String companyCd;
  private String email;
  @NotEmpty
  private List<String> managers;
  private String createUsr;
}
