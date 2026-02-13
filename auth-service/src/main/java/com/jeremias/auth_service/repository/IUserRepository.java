package com.jeremias.auth_service.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.jeremias.auth_service.model.User;

public interface IUserRepository extends JpaRepository<User, Long>{
	Optional<User> findByUsername(String username);
}
