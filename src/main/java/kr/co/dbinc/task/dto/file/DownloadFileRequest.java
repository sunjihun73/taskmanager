package kr.co.dbinc.task.dto.file;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class DownloadFileRequest {
  @NotBlank
  private String fileNm;
  @NotBlank
  private String fileDispNm;
}