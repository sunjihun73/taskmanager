package kr.co.dbinc.task.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SyncDataException extends RuntimeException
{
  private final ErrorCode errorCode;
}
