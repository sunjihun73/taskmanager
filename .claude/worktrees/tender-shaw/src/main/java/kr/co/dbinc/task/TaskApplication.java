package kr.co.dbinc.task;

import jakarta.annotation.PostConstruct;
import kr.co.dbinc.task.util.Util;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@EnableAsync
@SpringBootApplication
public class TaskApplication
{
	public static void main(String[] args)
  {
		SpringApplication.run(TaskApplication.class, args);
	}

  @PostConstruct
  public void init() throws Exception
  {
    Util.disableSslVerification();
  }
}
