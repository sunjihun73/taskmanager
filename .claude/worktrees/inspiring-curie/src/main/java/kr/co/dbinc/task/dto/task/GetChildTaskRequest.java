package kr.co.dbinc.task.dto.task;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class GetChildTaskRequest {
  private String domainId;
  private String companyCd;
  @NotBlank(message = "태스크ID가 존재하지 않습니다.")
  private String taskId;
}