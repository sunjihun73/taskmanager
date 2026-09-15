package kr.co.dbinc.task.dto.label;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class GetTaskLabelResponse {
  private String taskId;
  private String labelId;
  private String labelNm;
}
