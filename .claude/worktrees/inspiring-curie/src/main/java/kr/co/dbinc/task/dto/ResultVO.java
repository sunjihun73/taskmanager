package kr.co.dbinc.task.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serial;
import java.io.Serializable;

@ToString
@Getter
@Setter
public class ResultVO implements Serializable
{
  @Serial
  private static final long serialVersionUID = -6365817925495566291L;

  private String resultMsg;
  private String resultCode;
  private Object continueUrl;
  private Object dataOne;
}
