package kr.co.dbinc.task.mapper.task;

import kr.co.dbinc.task.dto.dept.GetDeptDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface DeptMapper
{
  List<GetDeptDTO.GetDeptResponse> getDepts(GetDeptDTO.GetDeptRequest request);
}
