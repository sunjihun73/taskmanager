package kr.co.dbinc.task.exception;

public class CustomAuthException extends Exception
{
  private static final long serialVersionUID = 6365187035977597515L;

  public CustomAuthException(String message)
  {
    super(message);
  }
}
