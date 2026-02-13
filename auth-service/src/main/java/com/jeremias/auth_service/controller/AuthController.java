package com.jeremias.auth_service.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.*;

import com.jeremias.auth_service.dto.LoginRequest;
import com.jeremias.auth_service.dto.LoginResponse;
import com.jeremias.auth_service.model.User;
import com.jeremias.auth_service.service.JwtService;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired private JwtService jwtService;
    @Autowired private AuthenticationManager authenticationManager;

     @Autowired private UserDetailsService userDetailsService;

    @PostMapping("/login")
    public LoginResponse login(@RequestBody LoginRequest request) {

        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        UserDetails ud = userDetailsService.loadUserByUsername(request.getUsername());
        User user = (User) ud;

        String token = jwtService.generateToken(
            user.getId(),
            user.getUsername(),
            List.of(user.getRole())
        );

        return new LoginResponse(token);
    }
}
