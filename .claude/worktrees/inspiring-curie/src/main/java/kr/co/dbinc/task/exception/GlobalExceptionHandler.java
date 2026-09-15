package kr.co.dbinc.task.exception;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(value = { CommonException.class })
  protected ResponseEntity<ErrorResponse> handleCommonException(CommonException e) {
    log.error("■ CommonException -> code:{}, message:{}", e.getErrorCode(), e.getErrorCode().getMessage());
    return ErrorResponse.toResponseEntity(e.getErrorCode());
  }
  
  @ExceptionHandler(value = { BindException.class })
  public ResponseEntity<ErrorResponse> bindException(BindException e, HttpServletRequest request) {
    log.error("■ BindException -> url:{}, trace:{}",request.getRequestURI(), e.getStackTrace());
    return ErrorResponse.toResponseEntity(ErrorCode.INVALID_INPUT_VALUE);
  }
  
  @ExceptionHandler(value = { AuthException.class })
  protected ResponseEntity<ErrorResponse> handleAuthException(AuthException e) {
    log.error("■ AuthException -> code:{}, message:{}", e.getErrorCode(), e.getErrorCode().getMessage());
    return ErrorResponse.toResponseEntity(e.getErrorCode());
  }

  @ExceptionHandler(value = { MaxUploadSizeExceededException.class })
  protected ResponseEntity<ErrorResponse> handleMaxUploadSizeExceededException(MaxUploadSizeExceededException e) {
    log.error("■ MaxUploadSizeExceededException -> {}", e.getMessage());
    return ErrorResponse.toResponseEntity(ErrorCode.FILE_VOL_ERROR);
  }
  
}
