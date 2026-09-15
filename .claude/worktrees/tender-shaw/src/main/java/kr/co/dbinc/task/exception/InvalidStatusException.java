package kr.co.dbinc.task.exception;

public class InvalidStatusException extends Exception
{
  private static final long serialVersionUID = 476037464029105827L;
  public InvalidStatusException() {}
  public InvalidStatusException(String msg) {super (msg);}
}
