package kr.co.dbinc.task.dto.label;

import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class InsertLabelRequest
{
  private String domainId;
  private String companyCd;
  private String email;
  private String labelId;
  @NotEmpty(message = "라벨명이 존재하지 않습니다.")
  private String labelNm;
}
