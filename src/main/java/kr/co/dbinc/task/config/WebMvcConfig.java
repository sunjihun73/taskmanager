package kr.co.dbinc.task.config;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer
{
  @Value("${default.start.continue.url}")
  String defaultContinueUrl;

  private final HandlerInterceptor authInterceptor;

  // INDEX 페이지 지정
  @Override
  public void addViewControllers(ViewControllerRegistry registry)
  {
    registry.addRedirectViewController("/", defaultContinueUrl);
    registry.setOrder(Ordered.HIGHEST_PRECEDENCE);
  }

  @Override
  public void addInterceptors(InterceptorRegistry registry)
  {
    registry.addInterceptor(authInterceptor).addPathPatterns("/**")
        .excludePathPatterns("/auth/**")
        .excludePathPatterns("/error/**")
        .excludePathPatterns("/errorMsgForm/**")
        .excludePathPatterns("/sessionErrorForm/**")
        .excludePathPatterns("/css/**")
        .excludePathPatterns("/fonts/**")
        .excludePathPatterns("/img/**")
        .excludePathPatterns("/js/**")
        .excludePathPatterns("/");
  }
}
