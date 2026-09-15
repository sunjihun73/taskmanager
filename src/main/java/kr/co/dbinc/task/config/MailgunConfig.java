package kr.co.dbinc.task.config;

import com.mailgun.api.v3.MailgunMessagesApi;
import com.mailgun.client.MailgunClient;
import feign.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MailgunConfig
{
  @Value("${mailgun.apikey}")
  String mMailgunApiKey;

  @Bean
  public MailgunMessagesApi mailgunMessagesApi()
  {
    return MailgunClient.config(mMailgunApiKey)
        .logLevel(Logger.Level.BASIC)
        .createAsyncApi(MailgunMessagesApi.class);
  }
}
