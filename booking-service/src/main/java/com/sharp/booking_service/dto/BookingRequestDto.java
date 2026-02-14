package com.sharp.booking_service.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class BookingRequestDto {
  private Long flightInstanceId;
  private Integer passengerCount;
  private Long createdByUserId;
  private LocalDateTime holdExpiresAt;
  private List<PassengerDto> passengers;
}
