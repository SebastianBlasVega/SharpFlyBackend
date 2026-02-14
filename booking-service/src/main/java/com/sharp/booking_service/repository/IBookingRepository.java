package com.sharp.booking_service.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sharp.booking_service.models.Booking;
import com.sharp.booking_service.models.BookingStatus;

@Repository
public interface IBookingRepository extends JpaRepository<Booking, Long> {

  Optional<Booking> findByPnr(String pnr);

  @Query("SELECT b FROM Booking b JOIN FETCH b.passengers WHERE b.pnr = :pnr")
  Optional<Booking> findByPnrWithPassengers(@Param("pnr") String pnr);

  List<Booking> findByFlightInstanceId(Long flightInstanceId);

  @Query("SELECT b FROM Booking b JOIN FETCH b.passengers WHERE b.flightInstanceId = :flightId")
  List<Booking> findByFlightInstanceIdWithPassengers(@Param("flightId") Long flightInstanceId);

  List<Booking> findByCreatedByUserId(Long userId);

  @Query("SELECT b FROM Booking b JOIN FETCH b.passengers WHERE b.createdByUserId = :userId")
  List<Booking> findByCreatedByUserIdWithPassengers(@Param("userId") Long userId);

  List<Booking> findByStatus(BookingStatus status);

  @Query("SELECT b FROM Booking b WHERE b.status = :status AND b.holdExpiresAt < :now")
  List<Booking> findExpiredHeldBookings(@Param("status") BookingStatus status, @Param("now") LocalDateTime now);

  @Query("SELECT b FROM Booking b WHERE b.holdExpiresAt BETWEEN :start AND :end")
  List<Booking> findExpiringSoon(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

  boolean existsByPnr(String pnr);

  @Query("SELECT COUNT(b) FROM Booking b WHERE b.flightInstanceId = :flightId AND b.status IN :statuses")
  long countByFlightInstanceIdAndStatusIn(@Param("flightId") Long flightInstanceId, @Param("statuses") List<BookingStatus> statuses);
}
