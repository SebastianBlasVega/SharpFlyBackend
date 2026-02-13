package com.sharp.flight_service.model;
import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
  name = "flight_instance",
  uniqueConstraints = @UniqueConstraint(name = "uq_fi_template_departure", columnNames = {"flight_template_id", "departure_at"})
)
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class FlightInstance {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "flight_instance_id")
  private Long flightInstanceId;

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "flight_template_id", nullable = false)
  private FlightTemplate flightTemplate;

  @Column(name = "departure_at", nullable = false)
  private LocalDateTime departureAt;

  @Column(name = "arrival_at", nullable = false)
  private LocalDateTime arrivalAt;

  @Enumerated(EnumType.STRING)
  @Column(name = "status", nullable = false, length = 20)
  @Builder.Default
  private FlightStatus status = FlightStatus.SCHEDULED;

  @Column(name = "capacity", nullable = false)
  private Integer capacity; // “congelada” por vuelo

  @Column(name = "created_at", nullable = false, updatable = false)
  private LocalDateTime createdAt;

  @PrePersist
  void prePersist() {
    this.createdAt = LocalDateTime.now();
    if (this.status == null) this.status = FlightStatus.SCHEDULED;
  }
}