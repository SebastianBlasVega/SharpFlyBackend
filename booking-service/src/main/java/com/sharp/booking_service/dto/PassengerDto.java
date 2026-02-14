package com.sharp.booking_service.dto;

import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class PassengerDto {
  private String firstName;
  private String lastName;
  private String docType;
  private String docNumber;
}
