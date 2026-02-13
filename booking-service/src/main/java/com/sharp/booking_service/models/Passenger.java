package com.sharp.booking_service.models;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "passenger")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Passenger {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "passenger_id")
  private Long passengerId;

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "booking_id", nullable = false)
  private Booking booking;

  @Column(name = "first_name", nullable = false, length = 80)
  private String firstName;

  @Column(name = "last_name", nullable = false, length = 80)
  private String lastName;

  @Column(name = "doc_type", nullable = false, length = 20)
  private String docType;

  @Column(name = "doc_number", nullable = false, length = 30)
  private String docNumber;

  @Column(name = "created_at", nullable = false, updatable = false)
  private LocalDateTime createdAt;

  public void setBooking(Booking booking) {
	  this.booking = booking;
	}

  @PrePersist
  void prePersist() {
    this.createdAt = LocalDateTime.now();
  }


}
