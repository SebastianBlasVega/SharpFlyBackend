package com.sharp.booking_service.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import com.sharp.booking_service.dto.PassengerDto;
import com.sharp.booking_service.models.Booking;
import com.sharp.booking_service.models.BookingStatus;

public interface IBookingService {

  Booking createBooking(Booking booking);

  Booking createBookingWithPassengers(Booking booking, List<PassengerDto> passengers);

  Optional<Booking> getBookingById(Long id);

  Optional<Booking> getBookingByPnr(String pnr);

  List<Booking> getAllBookings();

  List<Booking> getBookingsByFlightInstanceId(Long flightInstanceId);

  List<Booking> getBookingsByUserId(Long userId);

  List<Booking> getBookingsByStatus(BookingStatus status);

  List<Booking> getExpiredHeldBookings();

  List<Booking> getExpiringBookings(LocalDateTime start, LocalDateTime end);

  Booking confirmBooking(String pnr);

  Booking cancelBooking(String pnr);

  Booking updateBooking(Long id, Booking booking);

  boolean deleteBooking(Long id);

  boolean existsByPnr(String pnr);

  long countByFlightInstanceIdAndStatusIn(Long flightInstanceId, List<BookingStatus> statuses);

  String generatePNR();

  PassengerDto createPassengerDto(String firstName, String lastName, String docType, String docNumber);
}
