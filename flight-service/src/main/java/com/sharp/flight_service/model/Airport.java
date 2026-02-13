package com.sharp.flight_service.model;
import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "airport")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Airport {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "airport_id")
  private Long airportId;

  @Column(name = "iata", nullable = false, unique = true, length = 3)
  private String iata; // LIM, SCL...

  @Column(name = "name", nullable = false, length = 120)
  private String name;

  @Column(name = "city", nullable = false, length = 80)
  private String city;

  @Column(name = "country", nullable = false, length = 80)
  private String country;

  @Column(name = "timezone", nullable = false, length = 60)
  private String timezone; // America/Lima

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