-- =====================================================
-- SHARPFLY BACKEND - DATABASE INITIALIZATION
-- =====================================================
-- Este script crea todas las bases de datos y usuarios necesarios
-- para el desarrollo local de SharpFly Backend
-- =====================================================

-- Crear bases de datos
CREATE DATABASE IF NOT EXISTS auth_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS flight_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS booking_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- =====================================================
-- AUTH SERVICE - USERS
-- =====================================================
USE auth_db;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL DEFAULT 'USER'
);

-- Insertar usuarios de prueba
-- Contraseña para todos: password123
-- Hash BCrypt para "password123": $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
INSERT INTO user (username, password, role) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ADMIN'),
('user', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'USER'),
('juan.perez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'USER'),
('maria.gomez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'USER')
ON DUPLICATE KEY UPDATE username=username;

-- Verificar usuarios creados
SELECT 'Usuarios en auth_db:' AS info;
SELECT id, username, role FROM user;

-- =====================================================
-- VERIFICACIÓN
-- =====================================================
-- Verificar bases de datos creadas
SELECT 'Bases de datos creadas:' AS info;
SHOW DATABASES;

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
SELECT 'Inicialización completada exitosamente!' AS message;
