package kr.co.dbinc.task.service.user.label;

import kr.co.dbinc.task.dto.RestResultVO;
import kr.co.dbinc.task.dto.label.DeleteLabelRequest;
import kr.co.dbinc.task.dto.label.GetLabelDTO;
import kr.co.dbinc.task.dto.label.InsertLabelRequest;
import kr.co.dbinc.task.dto.label.UpdateLabelRequest;
import kr.co.dbinc.task.mapper.label.LabelMapper;
import kr.co.dbinc.task.mapper.task.TaskLabelMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.awt.*;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class UserLabelService
{
  private final LabelMapper labelMapper;
  private final TaskLabelMapper taskLabelMapper;

  public RestResultVO getPagedLabels(GetLabelDTO.GetLabelRequest request)
  {
    RestResultVO rrVO = new RestResultVO();
    List<GetLabelDTO.GetLabelResponse> response = labelMapper.getLabels(request);
    int recordsCnt = labelMapper.getLabelsCnt(request);

    rrVO.setDraw(request.getDraw());
    rrVO.setRecordsTotal(recordsCnt);
    rrVO.setRecordsFiltered(recordsCnt);
    rrVO.setData(response);
    return rrVO;
  }

  public RestResultVO getLabels(GetLabelDTO.GetLabelRequest request)
  {
    RestResultVO rrVO = new RestResultVO();
    List<GetLabelDTO.GetLabelResponse> response = labelMapper.getLabels(request);
    rrVO.setData(response);
    return rrVO;
  }

  @Transactional
  public String insertLabel(InsertLabelRequest request)
  {
    labelMapper.insertLabelMaster(request);
    return request.getLabelId();
  }

  @Transactional
  public void updateLabel(UpdateLabelRequest request)
  {
    labelMapper.updateLabelMaster(request);
  }

  @Transactional
  public void deleteLabel(DeleteLabelRequest request) throws Exception
  {
    labelMapper.deleteLabelMaster(request);
    taskLabelMapper.deleteLabel(request);
  }
}
