package kr.co.dbinc.task.dto.label;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class UpdateLabelRequest {
  private String domainId;
  private String companyCd;
  private String email;
  @NotBlank(message = "라벨ID가 존재하지 않습니다.")
  private String labelId;
  private String labelNm;
}
