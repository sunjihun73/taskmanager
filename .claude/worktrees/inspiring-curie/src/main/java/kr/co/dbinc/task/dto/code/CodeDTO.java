package kr.co.dbinc.task.dto.code;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@ToString
@Getter
@Setter
public class CodeDTO implements Serializable
{
  private static final long serialVersionUID = -1769825946006235659L;
  private int rowNum;
  private String domainId;
  private String companyCd;
  private String codeDiv;
  private String code;
  private String codeNm;
  private String codeEngNm;
  private String useYn;
  private String sortOrd;
  private String updateUsr;
  private String updateDt;
  private String createUsr;
  private String createDt;
}
