package com.sharp.booking_service.config;

import feign.RequestInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Configuration
public class FeignForwardAuthConfig {

  @Bean
  public RequestInterceptor forwardAuthorizationHeader() {
    return template -> {
      var attrs = RequestContextHolder.getRequestAttributes();
      if (attrs instanceof ServletRequestAttributes sra) {
        String auth = sra.getRequest().getHeader("Authorization");
        if (auth != null && !auth.isBlank()) {
          template.header("Authorization", auth);
        }
      }
    };
  }
}
