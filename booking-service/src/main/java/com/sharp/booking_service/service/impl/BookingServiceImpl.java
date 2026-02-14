package com.sharp.booking_service.service.impl;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sharp.booking_service.dto.PassengerDto;
import com.sharp.booking_service.models.Booking;
import com.sharp.booking_service.models.BookingStatus;
import com.sharp.booking_service.models.Passenger;
import com.sharp.booking_service.repository.IBookingRepository;
import com.sharp.booking_service.repository.IPassengerRepository;
import com.sharp.booking_service.service.IBookingService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class BookingServiceImpl implements IBookingService {

  private final IBookingRepository bookingRepository;
  private final IPassengerRepository passengerRepository;
  private static final String CHARACTERS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  private static final int PNR_LENGTH = 6;
  private static final SecureRandom random = new SecureRandom();

  @Override
  public Booking createBooking(Booking booking) {
    log.info("Creating booking for flight instance: {}", booking.getFlightInstanceId());

    String pnr = generatePNR();
    while (bookingRepository.existsByPnr(pnr)) {
      pnr = generatePNR();
    }
    booking.setPnr(pnr);

    if (booking.getPassengerCount() == null || booking.getPassengerCount() <= 0) {
      throw new IllegalArgumentException("Passenger count must be greater than 0");
    }

    return bookingRepository.save(booking);
  }

  @Override
  public Booking createBookingWithPassengers(Booking booking, List<PassengerDto> passengerDtos) {
    log.info("Creating booking with {} passengers for flight instance: {}",
        passengerDtos.size(), booking.getFlightInstanceId());

    if (passengerDtos.isEmpty()) {
      throw new IllegalArgumentException("At least one passenger is required");
    }

    if (passengerDtos.size() != booking.getPassengerCount()) {
      throw new IllegalArgumentException("Passenger count does not match the number of passengers provided");
    }

    booking.setPassengers(new ArrayList<>());
    Booking savedBooking = createBooking(booking);

    for (PassengerDto dto : passengerDtos) {
      Passenger passenger = Passenger.builder()
          .firstName(dto.getFirstName())
          .lastName(dto.getLastName())
          .docType(dto.getDocType())
          .docNumber(dto.getDocNumber())
          .booking(savedBooking)
          .build();
      savedBooking.addPassenger(passenger);
      passengerRepository.save(passenger);
    }

    return bookingRepository.save(savedBooking);
  }

  @Override
  @Transactional(readOnly = true)
  public Optional<Booking> getBookingById(Long id) {
    log.info("Fetching booking by id: {}", id);
    return bookingRepository.findById(id);
  }

  @Override
  @Transactional(readOnly = true)
  public Optional<Booking> getBookingByPnr(String pnr) {
    log.info("Fetching booking by PNR: {}", pnr);
    return bookingRepository.findByPnrWithPassengers(pnr);
  }

  @Override
  @Transactional(readOnly = true)
  public List<Booking> getAllBookings() {
    log.info("Fetching all bookings");
    return bookingRepository.findAll();
  }

  @Override
  @Transactional(readOnly = true)
  public List<Booking> getBookingsByFlightInstanceId(Long flightInstanceId) {
    log.info("Fetching bookings by flight instance id: {}", flightInstanceId);
    return bookingRepository.findByFlightInstanceIdWithPassengers(flightInstanceId);
  }

  @Override
  @Transactional(readOnly = true)
  public List<Booking> getBookingsByUserId(Long userId) {
    log.info("Fetching bookings by user id: {}", userId);
    return bookingRepository.findByCreatedByUserIdWithPassengers(userId);
  }

  @Override
  @Transactional(readOnly = true)
  public List<Booking> getBookingsByStatus(BookingStatus status) {
    log.info("Fetching bookings by status: {}", status);
    return bookingRepository.findByStatus(status);
  }

  @Override
  @Transactional(readOnly = true)
  public List<Booking> getExpiredHeldBookings() {
    log.info("Fetching expired held bookings");
    return bookingRepository.findExpiredHeldBookings(BookingStatus.HELD, LocalDateTime.now());
  }

  @Override
  @Transactional(readOnly = true)
  public List<Booking> getExpiringBookings(LocalDateTime start, LocalDateTime end) {
    log.info("Fetching bookings expiring between {} and {}", start, end);
    return bookingRepository.findExpiringSoon(start, end);
  }

  @Override
  public Booking confirmBooking(String pnr) {
    log.info("Confirming booking with PNR: {}", pnr);
    Booking booking = bookingRepository.findByPnr(pnr)
        .orElseThrow(() -> new IllegalArgumentException("Booking not found with PNR: " + pnr));

    if (booking.getStatus() == BookingStatus.CONFIRMED) {
      throw new IllegalArgumentException("Booking is already confirmed");
    }

    if (booking.getStatus() == BookingStatus.CANCELLED) {
      throw new IllegalArgumentException("Cannot confirm a cancelled booking");
    }

    if (booking.getStatus() == BookingStatus.EXPIRED) {
      throw new IllegalArgumentException("Cannot confirm an expired booking");
    }

    booking.setStatus(BookingStatus.CONFIRMED);
    booking.setHoldExpiresAt(null);

    return bookingRepository.save(booking);
  }

  @Override
  public Booking cancelBooking(String pnr) {
    log.info("Cancelling booking with PNR: {}", pnr);
    Booking booking = bookingRepository.findByPnr(pnr)
        .orElseThrow(() -> new IllegalArgumentException("Booking not found with PNR: " + pnr));

    if (booking.getStatus() == BookingStatus.CANCELLED) {
      throw new IllegalArgumentException("Booking is already cancelled");
    }

    booking.setStatus(BookingStatus.CANCELLED);
    booking.setHoldExpiresAt(null);

    return bookingRepository.save(booking);
  }

  @Override
  public Booking updateBooking(Long id, Booking booking) {
    log.info("Updating booking with id: {}", id);
    Booking existingBooking = bookingRepository.findById(id)
        .orElseThrow(() -> new IllegalArgumentException("Booking not found with id: " + id));

    if (booking.getFlightInstanceId() != null) {
      existingBooking.setFlightInstanceId(booking.getFlightInstanceId());
    }

    if (booking.getPassengerCount() != null) {
      existingBooking.setPassengerCount(booking.getPassengerCount());
    }

    if (booking.getCreatedByUserId() != null) {
      existingBooking.setCreatedByUserId(booking.getCreatedByUserId());
    }

    if (booking.getStatus() != null) {
      existingBooking.setStatus(booking.getStatus());
    }

    if (booking.getHoldExpiresAt() != null) {
      existingBooking.setHoldExpiresAt(booking.getHoldExpiresAt());
    }

    return bookingRepository.save(existingBooking);
  }

  @Override
  public boolean deleteBooking(Long id) {
    log.info("Deleting booking with id: {}", id);
    if (!bookingRepository.existsById(id)) {
      return false;
    }
    bookingRepository.deleteById(id);
    return true;
  }

  @Override
  @Transactional(readOnly = true)
  public boolean existsByPnr(String pnr) {
    return bookingRepository.existsByPnr(pnr);
  }

  @Override
  @Transactional(readOnly = true)
  public long countByFlightInstanceIdAndStatusIn(Long flightInstanceId, List<BookingStatus> statuses) {
    return bookingRepository.countByFlightInstanceIdAndStatusIn(flightInstanceId, statuses);
  }

  @Override
  public String generatePNR() {
    StringBuilder pnr = new StringBuilder(PNR_LENGTH);
    for (int i = 0; i < PNR_LENGTH; i++) {
      pnr.append(CHARACTERS.charAt(random.nextInt(CHARACTERS.length())));
    }
    return pnr.toString();
  }

  @Override
  public PassengerDto createPassengerDto(String firstName, String lastName, String docType, String docNumber) {
    return PassengerDto.builder()
        .firstName(firstName)
        .lastName(lastName)
        .docType(docType)
        .docNumber(docNumber)
        .build();
  }
}
