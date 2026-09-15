package kr.co.dbinc.task.mapper.admin;

import kr.co.dbinc.task.dto.sync.EpSyncDTO;
import kr.co.dbinc.task.dto.sync.GetSyncLogDTO;
import kr.co.dbinc.task.dto.sync.SetSyncLogDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface AdminSyncDataMapper
{
  int deleteSyncEmpMaster(EpSyncDTO.EpSyncResponse request);
  int insertSyncEmpMaster(EpSyncDTO.EpSyncResponse request);
  int deleteSyncDeptMaster(EpSyncDTO.EpSyncResponse request);
  int insertSyncDeptMaster(EpSyncDTO.EpSyncResponse request);
  int deleteSyncCodeDetail(EpSyncDTO.EpSyncResponse request);
  int insertSyncCodeDetail(EpSyncDTO.EpSyncResponse request);
  void insertSyncLog(SetSyncLogDTO request);
  int getSyncLogsCnt(GetSyncLogDTO.GetSyncLogRequest request);
  List<GetSyncLogDTO.GetSyncLogResponse> getSyncLogs(GetSyncLogDTO.GetSyncLogRequest request);
  int getNewSyncLog(EpSyncDTO.EpSyncRequest request);
}
