package com.sharp.booking_service.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.sharp.booking_service.models.BookingStatus;

import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class BookingResponseDto {
  private Long bookingId;
  private String pnr;
  private Long flightInstanceId;
  private BookingStatus status;
  private LocalDateTime holdExpiresAt;
  private Integer passengerCount;
  private Long createdByUserId;
  private LocalDateTime createdAt;
  private List<PassengerDto> passengers;
}
