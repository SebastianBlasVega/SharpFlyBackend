package com.sharp.booking_service.models;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "booking")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Booking {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "booking_id")
	private Long bookingId;

	@Column(name = "pnr", nullable = false, unique = true, length = 6)
	private String pnr; // AB12CD

	// OJO: esto es ID externo (flight-service). No FK.
	@Column(name = "flight_instance_id", nullable = false)
	private Long flightInstanceId;

	@Enumerated(EnumType.STRING)
	@Column(name = "status", nullable = false, length = 20)
	@Builder.Default
	private BookingStatus status = BookingStatus.HELD;

	@Column(name = "hold_expires_at")
	private LocalDateTime holdExpiresAt;

	@Column(name = "passenger_count", nullable = false)
	private Integer passengerCount;

	// opcional: id del usuario del auth-service (id externo, no FK)
	@Column(name = "created_by_user_id")
	private Long createdByUserId;

	@Column(name = "created_at", nullable = false, updatable = false)
	private LocalDateTime createdAt;

	@OneToMany(mappedBy = "booking", cascade = CascadeType.ALL, orphanRemoval = true)
	@Builder.Default
	private List<Passenger> passengers = new ArrayList<>();

	@PrePersist
	void prePersist() {
		this.createdAt = LocalDateTime.now();
		if (this.status == null)
			this.status = BookingStatus.HELD;
	}

	// helpers
//helpers
	public void addPassenger(Passenger p) {
		passengers.add(p);
		p.setBooking(this);
	}

	public void removePassenger(Passenger p) {
		passengers.remove(p);
		p.setBooking(null);
	}

}
