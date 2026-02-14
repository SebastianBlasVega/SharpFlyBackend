package com.sharp.booking_service.controllers;

import org.springframework.data.crossstore.ChangeSetPersister.NotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.sharp.booking_service.dto.ApiResponse;

@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(NotFoundException.class)
  public ResponseEntity<ApiResponse<Object>> notFound(NotFoundException ex) {
    return ResponseEntity.status(404).body(ApiResponse.fail(ex.getMessage(), "NOT_FOUND"));
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<ApiResponse<Object>> validation(MethodArgumentNotValidException ex) {
    String msg = ex.getBindingResult().getFieldErrors().stream()
        .map(e -> e.getField() + ": " + e.getDefaultMessage())
        .findFirst()
        .orElse("Validation error");
    return ResponseEntity.badRequest().body(ApiResponse.fail(msg, "VALIDATION_ERROR"));
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<ApiResponse<Object>> generic(Exception ex) {
    return ResponseEntity.status(500).body(ApiResponse.fail("Internal server error", "INTERNAL_ERROR"));
  }
}
