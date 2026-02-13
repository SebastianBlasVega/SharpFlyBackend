package com.sharp.flight_service.model;
import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "flight_template")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class FlightTemplate {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "flight_template_id")
  private Long flightTemplateId;

  @Column(name = "flight_number", nullable = false, unique = true, length = 10)
  private String flightNumber; // LA123

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "route_id", nullable = false)
  private Route route;

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "aircraft_id", nullable = false)
  private Aircraft aircraft;

  @Column(name = "default_duration_minutes", nullable = false)
  private Integer defaultDurationMinutes;

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