package com.sharp.booking_service.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.sharp.booking_service.dto.PassengerDto;
import com.sharp.booking_service.models.Passenger;
import com.sharp.booking_service.service.IPassengerService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/passengers")
@RequiredArgsConstructor
public class PassengerController {

  private final IPassengerService passengerService;

  @PostMapping
  public ResponseEntity<Passenger> createPassenger(@RequestBody Passenger passenger) {
    log.info("POST /api/v1/passengers - Creating passenger: {} {}", passenger.getFirstName(), passenger.getLastName());
    try {
      Passenger created = passengerService.createPassenger(passenger);
      return ResponseEntity.status(HttpStatus.CREATED).body(created);
    } catch (IllegalArgumentException e) {
      log.error("Error creating passenger: {}", e.getMessage());
      return ResponseEntity.badRequest().build();
    }
  }

  @GetMapping("/{id}")
  public ResponseEntity<Passenger> getPassengerById(@PathVariable Long id) {
    log.info("GET /api/v1/passengers/{} - Fetching passenger", id);
    try {
      Passenger passenger = passengerService.getPassengerById(id);
      return ResponseEntity.ok(passenger);
    } catch (IllegalArgumentException e) {
      log.error("Passenger not found: {}", e.getMessage());
      return ResponseEntity.notFound().build();
    }
  }

  @GetMapping("/booking/{bookingId}")
  public ResponseEntity<List<Passenger>> getPassengersByBooking(@PathVariable Long bookingId) {
    log.info("GET /api/v1/passengers/booking/{} - Fetching passengers by booking", bookingId);
    return ResponseEntity.ok(passengerService.getPassengersByBookingId(bookingId));
  }

  @GetMapping("/count/booking/{bookingId}")
  public ResponseEntity<Long> countPassengersByBooking(@PathVariable Long bookingId) {
    log.info("GET /api/v1/passengers/count/booking/{} - Counting passengers by booking", bookingId);
    return ResponseEntity.ok(passengerService.countByBookingId(bookingId));
  }

  @GetMapping("/search/doc/{docNumber}")
  public ResponseEntity<List<Passenger>> getPassengersByDocNumber(@PathVariable String docNumber) {
    log.info("GET /api/v1/passengers/search/doc/{} - Searching passengers by document", docNumber);
    return ResponseEntity.ok(passengerService.getPassengersByDocNumber(docNumber));
  }

  @PutMapping("/{id}")
  public ResponseEntity<Passenger> updatePassenger(@PathVariable Long id, @RequestBody Passenger passenger) {
    log.info("PUT /api/v1/passengers/{} - Updating passenger", id);
    try {
      Passenger updated = passengerService.updatePassenger(id, passenger);
      return ResponseEntity.ok(updated);
    } catch (IllegalArgumentException e) {
      log.error("Error updating passenger: {}", e.getMessage());
      return ResponseEntity.notFound().build();
    }
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deletePassenger(@PathVariable Long id) {
    log.info("DELETE /api/v1/passengers/{} - Deleting passenger", id);
    boolean deleted = passengerService.deletePassenger(id);
    return deleted
        ? ResponseEntity.noContent().build()
        : ResponseEntity.notFound().build();
  }
}
