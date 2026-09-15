package kr.co.dbinc.task.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {
  INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "Internal server error"),
  INVALID_INPUT_VALUE(HttpStatus.BAD_REQUEST, "입력 값이 유효하지 않습니다."),
  INVALID_DATA(HttpStatus.BAD_REQUEST, "옳바르지 않은 데이터입니다."),
  UNAUTHORIZED_ACCESS(HttpStatus.UNAUTHORIZED, "해당 태스크에 접근 권한이 존재하지 않습니다."),
  NOT_EXIST_TASK(HttpStatus.NOT_FOUND, "존재하지 않는 태스크입니다."),
  NOT_EXIST_PROJECT(HttpStatus.NOT_FOUND, "존재하지 않는 프로젝트입니다."),
  BAD_REQUEST(HttpStatus.BAD_REQUEST, "잘못된 요청입니다."),
  TASK_DATE_ERROR(HttpStatus.BAD_REQUEST, "시작일이 종료일보다 이전이어야 합니다."),
  FILE_NAME_ERROR(HttpStatus.BAD_REQUEST, "파일명이 100자 이상인 파일이 존재합니다."),
  FILE_VOL_ERROR(HttpStatus.BAD_REQUEST, "최대 파일 용량인 20MB를 초과한 파일이 존재합니다."),
  FILE_TYPE_ERROR(HttpStatus.BAD_REQUEST, "첨부가 불가능한 파일이 존재합니다."),
  GOOGLE_CALENDAR_ADD_FAIL(HttpStatus.BAD_REQUEST, "구글 캘린더 이벤트 추가시 오류가 발생했습니다."),
  GOOGLE_CALENDAR_EDIT_FAIL(HttpStatus.BAD_REQUEST, "구글 캘린더 이벤트 추가/수정시 오류가 발생했습니다."),
  SYNC_DATA_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "인사 데이터 연동 호출에 실패했습니다."),
  ;

  private final HttpStatus httpStatus;
  private final String message;
}
