package com.sharp.booking_service.dto;

import lombok.*;
import java.time.Instant;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class ApiResponse<T> {
  private boolean success;
  private String message;
  private String code;      // opcional: "OK", "VALIDATION_ERROR", etc.
  private T data;
  private Instant timestamp;

  public static <T> ApiResponse<T> ok(T data) {
    return ApiResponse.<T>builder()
        .success(true)
        .message("success")
        .code("OK")
        .data(data)
        .timestamp(Instant.now())
        .build();
  }

  public static <T> ApiResponse<T> fail(String message, String code) {
    return ApiResponse.<T>builder()
        .success(false)
        .message(message)
        .code(code)
        .data(null)
        .timestamp(Instant.now())
        .build();
  }
}
