package com.sharp.booking_service.client;

import com.sharp.booking_service.dto.ApiResponse;
import com.sharp.booking_service.dto.FlightDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "flight-service", url = "${services.flight.url}")
public interface FlightClient {

  @GetMapping("/api/flights/{id}")
  ApiResponse<FlightDto> getFlight(@PathVariable("id") Long id);
}
