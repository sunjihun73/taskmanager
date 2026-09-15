package kr.co.dbinc.task.dto.emp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serial;
import java.io.Serializable;

@Getter
@Setter
@ToString
public class EmpAuthorityDTO implements Serializable
{
  @Serial
  private static final long serialVersionUID = 3827753650601210409L;

  private String domainId;
  private String companyCd;
  private String email;
  private String authorityName;
  private String updateUsr;
  private String updateDt;
  private String createUsr;
  private String createDt;
}
