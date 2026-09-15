package kr.co.dbinc.task.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class CommonException extends RuntimeException {
  private final ErrorCode errorCode;
}
