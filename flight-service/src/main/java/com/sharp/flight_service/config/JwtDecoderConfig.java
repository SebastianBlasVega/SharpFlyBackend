package com.sharp.flight_service.config;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoder;

@Configuration
public class JwtDecoderConfig {

  @Bean
  public JwtDecoder jwtDecoder(@Value("${security.jwt.secret}") String secretB64) {
    byte[] keyBytes = Base64.getDecoder().decode(secretB64);
    SecretKey key = new SecretKeySpec(keyBytes, "HmacSHA256");

    return NimbusJwtDecoder.withSecretKey(key)
      .macAlgorithm(MacAlgorithm.HS256)
      .build();
  }
}
