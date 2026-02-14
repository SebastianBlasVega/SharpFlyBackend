package com.sharp.booking_service.service;

import java.util.List;

import com.sharp.booking_service.models.Passenger;

public interface IPassengerService {

  Passenger createPassenger(Passenger passenger);

  Passenger getPassengerById(Long id);

  List<Passenger> getPassengersByBookingId(Long bookingId);

  long countByBookingId(Long bookingId);

  List<Passenger> getPassengersByDocNumber(String docNumber);

  Passenger updatePassenger(Long id, Passenger passenger);

  boolean deletePassenger(Long id);
}
