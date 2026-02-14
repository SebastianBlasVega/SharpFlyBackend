package com.sharp.booking_service.controllers;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.sharp.booking_service.dto.BookingRequestDto;
import com.sharp.booking_service.dto.BookingResponseDto;
import com.sharp.booking_service.dto.PassengerDto;
import com.sharp.booking_service.models.Booking;
import com.sharp.booking_service.models.BookingStatus;
import com.sharp.booking_service.service.IBookingService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/bookings")
@RequiredArgsConstructor
public class BookingController {

  private final IBookingService bookingService;

  @PostMapping
  public ResponseEntity<BookingResponseDto> createBooking(@RequestBody BookingRequestDto request) {
    log.info("POST /api/v1/bookings - Creating booking for flight: {}", request.getFlightInstanceId());

    Booking booking = Booking.builder()
        .flightInstanceId(request.getFlightInstanceId())
        .passengerCount(request.getPassengerCount())
        .createdByUserId(request.getCreatedByUserId())
        .holdExpiresAt(request.getHoldExpiresAt())
        .build();

    Booking created;
    if (request.getPassengers() != null && !request.getPassengers().isEmpty()) {
      created = bookingService.createBookingWithPassengers(booking, request.getPassengers());
    } else {
      created = bookingService.createBooking(booking);
    }

    return ResponseEntity.status(HttpStatus.CREATED).body(toResponseDto(created));
  }

  @PostMapping("/quick")
  public ResponseEntity<BookingResponseDto> createQuickBooking(
      @RequestParam Long flightInstanceId,
      @RequestParam Integer passengerCount,
      @RequestParam(required = false) Long userId,
      @RequestParam(defaultValue = "30") Integer holdMinutes) {
    log.info("POST /api/v1/bookings/quick - Quick booking for flight: {}", flightInstanceId);

    LocalDateTime holdExpiry = LocalDateTime.now().plusMinutes(holdMinutes);

    Booking booking = Booking.builder()
        .flightInstanceId(flightInstanceId)
        .passengerCount(passengerCount)
        .createdByUserId(userId)
        .holdExpiresAt(holdExpiry)
        .build();

    Booking created = bookingService.createBooking(booking);
    return ResponseEntity.status(HttpStatus.CREATED).body(toResponseDto(created));
  }

  @GetMapping("/{id}")
  public ResponseEntity<BookingResponseDto> getBookingById(@PathVariable Long id) {
    log.info("GET /api/v1/bookings/{} - Fetching booking", id);
    return bookingService.getBookingById(id)
        .map(booking -> ResponseEntity.ok(toResponseDto(booking)))
        .orElse(ResponseEntity.notFound().build());
  }

  @GetMapping("/pnr/{pnr}")
  public ResponseEntity<BookingResponseDto> getBookingByPnr(@PathVariable String pnr) {
    log.info("GET /api/v1/bookings/pnr/{} - Fetching booking by PNR", pnr);
    return bookingService.getBookingByPnr(pnr)
        .map(booking -> ResponseEntity.ok(toResponseDto(booking)))
        .orElse(ResponseEntity.notFound().build());
  }

  @GetMapping
  public ResponseEntity<List<BookingResponseDto>> getAllBookings() {
    log.info("GET /api/v1/bookings - Fetching all bookings");
    List<BookingResponseDto> bookings = bookingService.getAllBookings().stream()
        .map(this::toResponseDto)
        .collect(Collectors.toList());
    return ResponseEntity.ok(bookings);
  }

  @GetMapping("/flight/{flightInstanceId}")
  public ResponseEntity<List<BookingResponseDto>> getBookingsByFlight(@PathVariable Long flightInstanceId) {
    log.info("GET /api/v1/bookings/flight/{} - Fetching bookings by flight", flightInstanceId);
    List<BookingResponseDto> bookings = bookingService.getBookingsByFlightInstanceId(flightInstanceId).stream()
        .map(this::toResponseDto)
        .collect(Collectors.toList());
    return ResponseEntity.ok(bookings);
  }

  @GetMapping("/user/{userId}")
  public ResponseEntity<List<BookingResponseDto>> getBookingsByUser(@PathVariable Long userId) {
    log.info("GET /api/v1/bookings/user/{} - Fetching bookings by user", userId);
    List<BookingResponseDto> bookings = bookingService.getBookingsByUserId(userId).stream()
        .map(this::toResponseDto)
        .collect(Collectors.toList());
    return ResponseEntity.ok(bookings);
  }

  @GetMapping("/status/{status}")
  public ResponseEntity<List<BookingResponseDto>> getBookingsByStatus(@PathVariable BookingStatus status) {
    log.info("GET /api/v1/bookings/status/{} - Fetching bookings by status", status);
    List<BookingResponseDto> bookings = bookingService.getBookingsByStatus(status).stream()
        .map(this::toResponseDto)
        .collect(Collectors.toList());
    return ResponseEntity.ok(bookings);
  }

  @GetMapping("/expired")
  public ResponseEntity<List<BookingResponseDto>> getExpiredBookings() {
    log.info("GET /api/v1/bookings/expired - Fetching expired held bookings");
    List<BookingResponseDto> bookings = bookingService.getExpiredHeldBookings().stream()
        .map(this::toResponseDto)
        .collect(Collectors.toList());
    return ResponseEntity.ok(bookings);
  }

  @GetMapping("/expiring")
  public ResponseEntity<List<BookingResponseDto>> getExpiringBookings(
      @RequestParam(defaultValue = "30") Integer minutes) {
    log.info("GET /api/v1/bookings/expiring - Fetching bookings expiring in {} minutes", minutes);
    LocalDateTime start = LocalDateTime.now();
    LocalDateTime end = start.plusMinutes(minutes);
    List<BookingResponseDto> bookings = bookingService.getExpiringBookings(start, end).stream()
        .map(this::toResponseDto)
        .collect(Collectors.toList());
    return ResponseEntity.ok(bookings);
  }

  @PostMapping("/{pnr}/confirm")
  public ResponseEntity<BookingResponseDto> confirmBooking(@PathVariable String pnr) {
    log.info("POST /api/v1/bookings/{}/confirm - Confirming booking", pnr);
    try {
      Booking confirmed = bookingService.confirmBooking(pnr);
      return ResponseEntity.ok(toResponseDto(confirmed));
    } catch (IllegalArgumentException e) {
      log.error("Error confirming booking: {}", e.getMessage());
      return ResponseEntity.badRequest().build();
    }
  }

  @PostMapping("/{pnr}/cancel")
  public ResponseEntity<BookingResponseDto> cancelBooking(@PathVariable String pnr) {
    log.info("POST /api/v1/bookings/{}/cancel - Cancelling booking", pnr);
    try {
      Booking cancelled = bookingService.cancelBooking(pnr);
      return ResponseEntity.ok(toResponseDto(cancelled));
    } catch (IllegalArgumentException e) {
      log.error("Error cancelling booking: {}", e.getMessage());
      return ResponseEntity.badRequest().build();
    }
  }

  @PutMapping("/{id}")
  public ResponseEntity<BookingResponseDto> updateBooking(
      @PathVariable Long id,
      @RequestBody BookingRequestDto request) {
    log.info("PUT /api/v1/bookings/{} - Updating booking", id);
    try {
      Booking booking = Booking.builder()
          .flightInstanceId(request.getFlightInstanceId())
          .passengerCount(request.getPassengerCount())
          .createdByUserId(request.getCreatedByUserId())
          .holdExpiresAt(request.getHoldExpiresAt())
          .build();
      Booking updated = bookingService.updateBooking(id, booking);
      return ResponseEntity.ok(toResponseDto(updated));
    } catch (IllegalArgumentException e) {
      log.error("Error updating booking: {}", e.getMessage());
      return ResponseEntity.notFound().build();
    }
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deleteBooking(@PathVariable Long id) {
    log.info("DELETE /api/v1/bookings/{} - Deleting booking", id);
    boolean deleted = bookingService.deleteBooking(id);
    return deleted
        ? ResponseEntity.noContent().build()
        : ResponseEntity.notFound().build();
  }

  @GetMapping("/exists/pnr/{pnr}")
  public ResponseEntity<Boolean> existsByPnr(@PathVariable String pnr) {
    log.info("GET /api/v1/bookings/exists/pnr/{} - Checking existence", pnr);
    return ResponseEntity.ok(bookingService.existsByPnr(pnr));
  }

  @GetMapping("/count/flight/{flightInstanceId}")
  public ResponseEntity<Long> countConfirmedBookings(@PathVariable Long flightInstanceId) {
    log.info("GET /api/v1/bookings/count/flight/{} - Counting confirmed bookings", flightInstanceId);
    long count = bookingService.countByFlightInstanceIdAndStatusIn(
        flightInstanceId,
        List.of(BookingStatus.CONFIRMED, BookingStatus.HELD)
    );
    return ResponseEntity.ok(count);
  }

  private BookingResponseDto toResponseDto(Booking booking) {
    List<PassengerDto> passengerDtos = booking.getPassengers().stream()
        .map(p -> bookingService.createPassengerDto(
            p.getFirstName(),
            p.getLastName(),
            p.getDocType(),
            p.getDocNumber()))
        .collect(Collectors.toList());

    return BookingResponseDto.builder()
        .bookingId(booking.getBookingId())
        .pnr(booking.getPnr())
        .flightInstanceId(booking.getFlightInstanceId())
        .status(booking.getStatus())
        .holdExpiresAt(booking.getHoldExpiresAt())
        .passengerCount(booking.getPassengerCount())
        .createdByUserId(booking.getCreatedByUserId())
        .createdAt(booking.getCreatedAt())
        .passengers(passengerDtos)
        .build();
  }
}
