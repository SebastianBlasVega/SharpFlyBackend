	package com.sharp.booking_service.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sharp.booking_service.models.Passenger;
import com.sharp.booking_service.repository.IPassengerRepository;
import com.sharp.booking_service.service.IPassengerService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class PassengerServiceImpl implements IPassengerService {

  private final IPassengerRepository passengerRepository;

  @Override
  public Passenger createPassenger(Passenger passenger) {
    log.info("Creating passenger: {} {}", passenger.getFirstName(), passenger.getLastName());

    if (passenger.getBooking() == null) {
      throw new IllegalArgumentException("Passenger must be associated with a booking");
    }

    return passengerRepository.save(passenger);
  }

  @Override
  @Transactional(readOnly = true)
  public Passenger getPassengerById(Long id) {
    log.info("Fetching passenger by id: {}", id);
    return passengerRepository.findById(id)
        .orElseThrow(() -> new IllegalArgumentException("Passenger not found with id: " + id));
  }

  @Override
  @Transactional(readOnly = true)
  public List<Passenger> getPassengersByBookingId(Long bookingId) {
    log.info("Fetching passengers by booking id: {}", bookingId);
    return passengerRepository.findByBookingBookingId(bookingId);
  }

  @Override
  @Transactional(readOnly = true)
  public long countByBookingId(Long bookingId) {
    log.info("Counting passengers by booking id: {}", bookingId);
    return passengerRepository.countByBookingBookingId(bookingId);
  }

  @Override
  @Transactional(readOnly = true)
  public List<Passenger> getPassengersByDocNumber(String docNumber) {
    log.info("Fetching passengers by document number: {}", docNumber);
    return passengerRepository.findByDocNumber(docNumber);
  }

  @Override
  public Passenger updatePassenger(Long id, Passenger passenger) {
    log.info("Updating passenger with id: {}", id);
    Passenger existingPassenger = passengerRepository.findById(id)
        .orElseThrow(() -> new IllegalArgumentException("Passenger not found with id: " + id));

    if (passenger.getFirstName() != null) {
      existingPassenger.setFirstName(passenger.getFirstName());
    }

    if (passenger.getLastName() != null) {
      existingPassenger.setLastName(passenger.getLastName());
    }

    if (passenger.getDocType() != null) {
      existingPassenger.setDocType(passenger.getDocType());
    }

    if (passenger.getDocNumber() != null) {
      existingPassenger.setDocNumber(passenger.getDocNumber());
    }

    return passengerRepository.save(existingPassenger);
  }

  @Override
  public boolean deletePassenger(Long id) {
    log.info("Deleting passenger with id: {}", id);
    if (!passengerRepository.existsById(id)) {
      return false;
    }
    passengerRepository.deleteById(id);
    return true;
  }
}
