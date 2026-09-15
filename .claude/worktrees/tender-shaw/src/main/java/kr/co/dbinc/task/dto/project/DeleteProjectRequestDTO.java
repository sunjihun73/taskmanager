package kr.co.dbinc.task.dto.project;

import lombok.*;

import java.util.List;

@Getter @Setter
@Builder
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class DeleteProjectRequestDTO
{
  private String domainId;
  private String companyCd;
  private String projectId;
  private String delYn;
  private String updateUsr;
  private String updateDt;
}
