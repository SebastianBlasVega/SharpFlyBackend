package com.jeremias.api_gateway.config;

import java.util.Base64;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.NimbusReactiveJwtDecoder;
import org.springframework.security.oauth2.jwt.ReactiveJwtDecoder;

@Configuration
public class JwtDecoderConfig {

  @Bean
  public ReactiveJwtDecoder reactiveJwtDecoder(
      @Value("${security.jwt.secret}") String secretB64
  ) {
    byte[] keyBytes = Base64.getDecoder().decode(secretB64);
    SecretKey key = new SecretKeySpec(keyBytes, "HmacSHA256");

    return NimbusReactiveJwtDecoder
        .withSecretKey(key)
        .macAlgorithm(MacAlgorithm.HS256)
        .build();
  }
}
