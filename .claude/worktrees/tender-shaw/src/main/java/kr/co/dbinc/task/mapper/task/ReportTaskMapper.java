package kr.co.dbinc.task.mapper.task;

import kr.co.dbinc.task.dto.reporttask.InsertReportTaskDTO;
import kr.co.dbinc.task.dto.reporttask.SelectReportTaskDTO;
import kr.co.dbinc.task.dto.task.GetTaskEmpListResponse;
import kr.co.dbinc.task.dto.task.InsertTaskEmpRequest;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface ReportTaskMapper
{
  SelectReportTaskDTO selectReportTaskMaster (Map<String, Object> paramsMap);
  int selectReportTaskMastersCnt (Map<String, Object> paramsMap);
  List<SelectReportTaskDTO> selectReportTaskMasters (Map<String, Object> paramsMap);
  List<GetTaskEmpListResponse> getReportTaskEmpList(Map<String, Object> paramsMap);

  int selectSendReportTaskMastersCnt (Map<String, Object> paramsMap);
  List<SelectReportTaskDTO> selectSendReportTaskMasters (Map<String, Object> paramsMap);

  int selectRecvReportTaskMastersCnt (Map<String, Object> paramsMap);
  List<SelectReportTaskDTO> selectRecvReportTaskMasters (Map<String, Object> paramsMap);

  int insertReportTaskMaster(InsertReportTaskDTO insRptTaskDTO);
  int insertReportTaskEmp(InsertTaskEmpRequest insTaskEmpRequest);
  int updateReportTaskMaster(InsertReportTaskDTO insRptTaskDTO);
  int updateReportTaskEmp(InsertReportTaskDTO insRptTaskDTO);
  int updateReportTaskState(InsertReportTaskDTO insRptTaskDTO);
  int deleteReportTaskMaster(InsertReportTaskDTO insRptTaskDTO);
  int deleteReportTaskEmp(InsertReportTaskDTO insRptTaskDTO);

  SelectReportTaskDTO selectReportTaskState (Map<String, Object> paramsMap);
}
