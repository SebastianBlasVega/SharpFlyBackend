package com.sharp.booking_service.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sharp.booking_service.models.Passenger;

@Repository
public interface IPassengerRepository extends JpaRepository<Passenger, Long> {
	  List<Passenger> findByBookingBookingId(Long bookingId);
	  long countByBookingBookingId(Long bookingId);
	  List<Passenger> findByDocNumber(String docNumber);
	  List<Passenger> findByBookingBookingIdAndDocNumber(Long bookingId, String docNumber);
	}
