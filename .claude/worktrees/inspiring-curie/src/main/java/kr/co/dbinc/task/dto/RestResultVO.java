package kr.co.dbinc.task.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@ToString
public class RestResultVO implements Serializable
{
  private static final long serialVersionUID = -3537354848856072482L;
  private String resultMsg;
  private String resultCode;
  private Object dataOne;
  private List<?> data;
  private int draw;
  private int recordsTotal;
  private int recordsFiltered;
  private int queryResult;
}
