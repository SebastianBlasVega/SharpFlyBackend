package com.sharp.booking_service.dto;

import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class FlightDto {
  private Long flightId;
  private String code;
  private String origin;
  private String destination;
  private Double price;
}
