package kr.co.dbinc.task.exception;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;

@Getter
@Builder
@RequiredArgsConstructor
public class ErrorResponse
{
  private final String code;
  private final String message;

  public static ResponseEntity<ErrorResponse> toResponseEntity(ErrorCode errorCode) {
    return ResponseEntity.status(errorCode.getHttpStatus())
        .body(ErrorResponse.builder().code(errorCode.name()).message(errorCode.getMessage()).build());
  }

}
