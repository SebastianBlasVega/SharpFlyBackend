package com.sharp.flight_service.model;
import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "aircraft")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Aircraft {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "aircraft_id")
  private Long aircraftId;

  @Column(name = "code", nullable = false, unique = true, length = 20)
  private String code; // A320-1

  @Column(name = "model", nullable = false, length = 80)
  private String model; // Airbus A320

  @Column(name = "seat_capacity", nullable = false)
  private Integer seatCapacity;

  @Column(name = "is_active", nullable = false)
  @Builder.Default
  private Boolean isActive = true;

  @Column(name = "created_at", nullable = false, updatable = false)
  private LocalDateTime createdAt;

  @PrePersist
  void prePersist() {
    this.createdAt = LocalDateTime.now();
    if (this.isActive == null) this.isActive = true;
  }
}