package kr.co.dbinc.task.mapper.label;

import kr.co.dbinc.task.dto.label.DeleteLabelRequest;
import kr.co.dbinc.task.dto.label.GetLabelDTO;
import kr.co.dbinc.task.dto.label.InsertLabelRequest;
import kr.co.dbinc.task.dto.label.UpdateLabelRequest;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface LabelMapper
{
  List<GetLabelDTO.GetLabelResponse> getLabels(GetLabelDTO.GetLabelRequest request);
  int getLabelsCnt(GetLabelDTO.GetLabelRequest request);
  int insertLabelMaster(InsertLabelRequest request);
  int updateLabelMaster(UpdateLabelRequest request);
  int deleteLabelMaster(DeleteLabelRequest request);
}
