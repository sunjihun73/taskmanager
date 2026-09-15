package kr.co.dbinc.task.dto.code;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class GetEpCodeDTO
{
  @JsonProperty("DOMAIN_NAME")
  private String domainName;
  @JsonProperty("COMPANY")
  private String company;
  @JsonProperty("CODE_DIV")
  private String codeDiv;
  @JsonProperty("CODE")
  private String code;
  @JsonProperty("CODE_NAME")
  private String codeName;
  @JsonProperty("SORT_ORD")
  private String sortOrd;
  @JsonProperty("CODE_DIV_NAME")
  private String codeDivName;
  @JsonProperty("USE_YN")
  private String useYn;
  @JsonProperty("DIV_YN")
  private String divYn;
  @JsonProperty("LANGUAGE")
  private String language;
}
