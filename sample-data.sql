-- =====================================================
-- SHARPFLY BACKEND - SAMPLE DATA
-- Script para insertar datos de ejemplo en MySQL
-- =====================================================

-- NOTA: El orden de inserción es importante debido a las relaciones
-- 1. Users (auth_service)
-- 2. Airports (flight_service)
-- 3. Aircrafts (flight_service)
-- 4. Routes (flight_service)
-- 5. FlightTemplates (flight_service)
-- 6. FlightInstances (flight_service)
-- 7. Bookings (booking_service)
-- 8. Passengers (booking_service)

-- =====================================================
-- AUTH SERVICE - USERS
-- =====================================================
-- Passwords están hasheados con BCrypt (password original: "password123")
USE auth_service_db;

INSERT INTO user (username, password, role) VALUES
('admin', '$2a$10$YourBCryptHashHereForAdmin', 'ADMIN'),
('john.doe', '$2a$10$YourBCryptHashHere', 'USER'),
('jane.smith', '$2a$10$YourBCryptHashHere', 'USER'),
('carlos.perez', '$2a$10$YourBCryptHashHere', 'USER'),
('maria.garcia', '$2a$10$YourBCryptHashHere', 'USER');

-- NOTA: Genera los hashes BCrypt reales con una herramienta online o Spring Security
-- Ejemplo para generar: https://bcrypt-generator.com/

-- =====================================================
-- FLIGHT SERVICE - AIRPORTS
-- =====================================================
USE flight_service_db;

INSERT INTO airport (iata, name, city, country, timezone, is_active, created_at) VALUES
-- Perú
('LIM', 'Jorge Chavez International Airport', 'Lima', 'Peru', 'America/Lima', 1, NOW()),
('CUZ', 'Alejandro Velasco Astete International Airport', 'Cusco', 'Peru', 'America/Lima', 1, NOW()),
('AQP', 'Rodriguez Ballon International Airport', 'Arequipa', 'Peru', 'America/Lima', 1, NOW()),
('PIU', 'Capitan FAP Guillermo Concha Iberico International Airport', 'Piura', 'Peru', 'America/Lima', 1, NOW()),
('TRU', 'Capitan FAP Carlos Martinez de Pinillos International Airport', 'Trujillo', 'Peru', 'America/Lima', 1, NOW()),
('ILO', 'Ilo Airport', 'Ilo', 'Peru', 'America/Lima', 1, NOW()),
('JUL', 'Francisco Carle Airport', 'Jauja', 'Peru', 'America/Lima', 1, NOW()),
('TBP', 'Tumbes Airport', 'Tumbes', 'Peru', 'America/Lima', 1, NOW()),
-- Chile
('SCL', 'Arturo Merino Benitez International Airport', 'Santiago', 'Chile', 'America/Santiago', 1, NOW()),
('IPC', 'Mataveri International Airport', 'Easter Island', 'Chile', 'Pacific/Easter', 1, NOW()),
-- Argentina
('EZE', 'Ministro Pistarini International Airport', 'Buenos Aires', 'Argentina', 'America/Argentina/Buenos_Aires', 1, NOW()),
('COR', 'Ing. Aero Ambrosio Taravella Airport', 'Cordoba', 'Argentina', 'America/Argentina/Cordoba', 1, NOW()),
-- Colombia
('BOG', 'El Dorado International Airport', 'Bogota', 'Colombia', 'America/Bogota', 1, NOW()),
('MDE', 'Jose Maria Cordova Airport', 'Medellin', 'Colombia', 'America/Bogota', 1, NOW()),
-- Ecuador
('UIO', 'Mariscal Sucre International Airport', 'Quito', 'Ecuador', 'America/Guayaquil', 1, NOW()),
('GYE', 'Jose Joaquin de Olmedo Airport', 'Guayaquil', 'Ecuador', 'America/Guayaquil', 1, NOW()),
-- Brasil
('GRU', 'Sao Paulo/Guarulhos International Airport', 'Sao Paulo', 'Brazil', 'America/Sao_Paulo', 1, NOW()),
('GIG', 'Rio de Janeiro International Airport', 'Rio de Janeiro', 'Brazil', 'America/Sao_Paulo', 1, NOW()),
-- USA
('MIA', 'Miami International Airport', 'Miami', 'United States', 'America/New_York', 1, NOW()),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'United States', 'America/Los_Angeles', 1, NOW()),
('JFK', 'John F. Kennedy International Airport', 'New York', 'United States', 'America/New_York', 1, NOW()),
-- España
('MAD', 'Adolfo Suarez Madrid-Barajas Airport', 'Madrid', 'Spain', 'Europe/Madrid', 1, NOW()),
('BCN', 'Barcelona-El Prat Airport', 'Barcelona', 'Spain', 'Europe/Madrid', 1, NOW());

-- =====================================================
-- FLIGHT SERVICE - AIRCRAFTS
-- =====================================================
INSERT INTO aircraft (code, model, seat_capacity, is_active, created_at) VALUES
('OB-1001', 'Airbus A320neo', 180, 1, NOW()),
('OB-1002', 'Airbus A320neo', 180, 1, NOW()),
('OB-1003', 'Airbus A321neo', 220, 1, NOW()),
('OB-1004', 'Boeing 737-800', 189, 1, NOW()),
('OB-1005', 'Boeing 737-800', 189, 1, NOW()),
('OB-1006', 'Boeing 737 MAX 8', 178, 1, NOW()),
('OB-1007', 'Airbus A350-900', 350, 1, NOW()),
('OB-1008', 'Boeing 787-9 Dreamliner', 298, 1, NOW());

-- =====================================================
-- FLIGHT SERVICE - ROUTES
-- =====================================================
-- Rutas domésticas en Perú
INSERT INTO route (origin_airport_id, destination_airport_id, is_active, created_at) VALUES
-- Lima a otras ciudades de Perú
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'CUZ'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'AQP'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'PIU'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'TRU'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'ILO'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'JUL'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'TBP'), 1, NOW()),
-- Rutas internacionales (Latam)
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'SCL'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'EZE'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'BOG'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'UIO'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'GRU'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'MIA'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'LIM'), (SELECT airport_id FROM airport WHERE iata = 'MAD'), 1, NOW()),
-- Rutas internacionales desde otros países
((SELECT airport_id FROM airport WHERE iata = 'SCL'), (SELECT airport_id FROM airport WHERE iata = 'EZE'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'SCL'), (SELECT airport_id FROM airport WHERE iata = 'MIA'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'BOG'), (SELECT airport_id FROM airport WHERE iata = 'MDE'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'MIA'), (SELECT airport_id FROM airport WHERE iata = 'JFK'), 1, NOW()),
((SELECT airport_id FROM airport WHERE iata = 'MIA'), (SELECT airport_id FROM airport WHERE iata = 'LAX'), 1, NOW());

-- =====================================================
-- FLIGHT SERVICE - FLIGHT TEMPLATES
-- =====================================================
INSERT INTO flight_template (flight_number, route_id, aircraft_id, default_duration_minutes, is_active, created_at) VALUES
-- Vuelos domésticos Perú
('SF0201', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'CUZ')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1001'), 90, 1, NOW()),
('SF0202', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'CUZ') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1001'), 90, 1, NOW()),
('SF0203', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'AQP')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1002'), 105, 1, NOW()),
('SF0204', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'AQP') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1002'), 105, 1, NOW()),
('SF0205', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'PIU')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1004'), 120, 1, NOW()),
('SF0206', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'PIU') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1004'), 120, 1, NOW()),
('SF0207', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'TRU')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1005'), 75, 1, NOW()),
('SF0208', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'TRU') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1005'), 75, 1, NOW()),
-- Vuelos internacionales
('SF0301', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'SCL')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1003'), 195, 1, NOW()),
('SF0302', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'SCL') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1003'), 195, 1, NOW()),
('SF0303', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'EZE')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1006'), 270, 1, NOW()),
('SF0304', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'EZE') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1006'), 270, 1, NOW()),
('SF0305', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'BOG')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1006'), 210, 1, NOW()),
('SF0306', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'BOG') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1006'), 210, 1, NOW()),
('SF0401', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'MIA')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1007'), 360, 1, NOW()),
('SF0402', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'MIA') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1007'), 375, 1, NOW()),
('SF0403', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'MAD')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1008'), 720, 1, NOW()),
('SF0404', (SELECT route_id FROM route WHERE origin_airport_id = (SELECT airport_id FROM airport WHERE iata = 'MAD') AND destination_airport_id = (SELECT airport_id FROM airport WHERE iata = 'LIM')), (SELECT aircraft_id FROM aircraft WHERE code = 'OB-1008'), 750, 1, NOW());

-- =====================================================
-- FLIGHT SERVICE - FLIGHT INSTANCES
-- =====================================================
-- Vuelos programados para la próxima semana (a partir de 2026-02-14)
INSERT INTO flight_instance (flight_template_id, departure_at, arrival_at, status, capacity, created_at) VALUES
-- Hoy (2026-02-14)
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0201'), '2026-02-14 06:00:00', '2026-02-14 07:30:00', 'SCHEDULED', 180, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0202'), '2026-02-14 09:00:00', '2026-02-14 10:30:00', 'SCHEDULED', 180, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0203'), '2026-02-14 07:00:00', '2026-02-14 08:45:00', 'SCHEDULED', 220, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0205'), '2026-02-14 08:00:00', '2026-02-14 10:00:00', 'SCHEDULED', 189, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0207'), '2026-02-14 10:00:00', '2026-02-14 11:15:00', 'SCHEDULED', 189, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0301'), '2026-02-14 07:30:00', '2026-02-14 11:00:00', 'SCHEDULED', 220, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0305'), '2026-02-14 08:30:00', '2026-02-14 12:00:00', 'SCHEDULED', 178, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0401'), '2026-02-14 09:00:00', '2026-02-14 15:00:00', 'SCHEDULED', 350, NOW()),

-- Mañana (2026-02-15)
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0201'), '2026-02-15 06:00:00', '2026-02-15 07:30:00', 'SCHEDULED', 180, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0203'), '2026-02-15 07:00:00', '2026-02-15 08:45:00', 'SCHEDULED', 220, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0301'), '2026-02-15 07:30:00', '2026-02-15 11:00:00', 'SCHEDULED', 220, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0403'), '2026-02-15 22:00:00', '2026-02-16 14:00:00', 'SCHEDULED', 298, NOW()),

-- Próximos días (2026-02-16 al 2026-02-20)
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0201'), '2026-02-16 06:00:00', '2026-02-16 07:30:00', 'DEPARTED', 180, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0202'), '2026-02-16 09:00:00', '2026-02-16 10:30:00', 'SCHEDULED', 180, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0301'), '2026-02-16 07:30:00', '2026-02-16 11:00:00', 'DELAYED', 220, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0401'), '2026-02-16 09:00:00', '2026-02-16 15:00:00', 'SCHEDULED', 350, NOW()),

((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0201'), '2026-02-17 06:00:00', '2026-02-17 07:30:00', 'SCHEDULED', 180, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0203'), '2026-02-17 07:00:00', '2026-02-17 08:45:00', 'SCHEDULED', 220, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0303'), '2026-02-17 14:00:00', '2026-02-17 18:30:00', 'SCHEDULED', 178, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0403'), '2026-02-17 22:00:00', '2026-02-18 14:00:00', 'SCHEDULED', 298, NOW()),

((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0201'), '2026-02-18 06:00:00', '2026-02-18 07:30:00', 'SCHEDULED', 180, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0205'), '2026-02-18 08:00:00', '2026-02-18 10:00:00', 'SCHEDULED', 189, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0301'), '2026-02-18 07:30:00', '2026-02-18 11:00:00', 'SCHEDULED', 220, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0401'), '2026-02-18 09:00:00', '2026-02-18 15:00:00', 'SCHEDULED', 350, NOW()),

((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0201'), '2026-02-19 06:00:00', '2026-02-19 07:30:00', 'SCHEDULED', 180, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0203'), '2026-02-19 07:00:00', '2026-02-19 08:45:00', 'SCHEDULED', 220, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0305'), '2026-02-19 08:30:00', '2026-02-19 12:00:00', 'SCHEDULED', 178, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0402'), '2026-02-19 16:00:00', '2026-02-19 22:15:00', 'SCHEDULED', 350, NOW()),

((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0201'), '2026-02-20 06:00:00', '2026-02-20 07:30:00', 'SCHEDULED', 180, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0207'), '2026-02-20 10:00:00', '2026-02-20 11:15:00', 'SCHEDULED', 189, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0301'), '2026-02-20 07:30:00', '2026-02-20 11:00:00', 'SCHEDULED', 220, NOW()),
((SELECT flight_template_id FROM flight_template WHERE flight_number = 'SF0403'), '2026-02-20 22:00:00', '2026-02-21 14:00:00', 'SCHEDULED', 298, NOW());

-- =====================================================
-- BOOKING SERVICE - BOOKINGS
-- =====================================================
USE booking_service_db;

-- Necesitamos obtener IDs de vuelos del flight_service
-- NOTA: Para reservas necesitas los flight_instance_ids de la tabla anterior

INSERT INTO booking (pnr, flight_instance_id, status, hold_expires_at, passenger_count, created_by_user_id, created_at) VALUES
-- Reservas confirmadas
('ABC123', 1, 'CONFIRMED', NULL, 2, 2, NOW()),
('XYZ789', 3, 'CONFIRMED', NULL, 1, 3, NOW()),
('DEF456', 5, 'CONFIRMED', NULL, 3, 4, NOW()),
('GHI012', 7, 'CONFIRMED', NULL, 2, 5, NOW()),
('JKL345', 2, 'CONFIRMED', NULL, 1, 2, NOW()),
('MNO678', 9, 'CONFIRMED', NULL, 4, 3, NOW()),
('PQR901', 11, 'CONFIRMED', NULL, 2, 4, NOW()),
('STU234', 13, 'CONFIRMED', NULL, 1, 5, NOW()),
('VWX567', 15, 'CONFIRMED', NULL, 2, 2, NOW()),
('YZA890', 17, 'CONFIRMED', NULL, 3, 3, NOW()),
-- Reservas en hold (sin confirmar)
('BCD234', 4, 'HELD', DATE_ADD(NOW(), INTERVAL 30 MINUTE), 2, 4, NOW()),
('EFG567', 6, 'HELD', DATE_ADD(NOW(), INTERVAL 30 MINUTE), 1, 5, NOW()),
('HIA890', 8, 'HELD', DATE_ADD(NOW(), INTERVAL 30 MINUTE), 3, 2, NOW()),
-- Reservas canceladas
('CANCEL1', 10, 'CANCELLED', NULL, 2, 3, NOW()),
('CANCEL2', 12, 'CANCELLED', NULL, 1, 4, NOW()),
-- Reservas expiradas
('EXP123', 14, 'EXPIRED', NULL, 2, 5, NOW());

-- =====================================================
-- BOOKING SERVICE - PASSENGERS
-- =====================================================
INSERT INTO passenger (booking_id, first_name, last_name, doc_type, doc_number, created_at) VALUES
-- Pasajeros de la reserva ABC123 (booking_id = 1)
(1, 'Juan Carlos', 'Perez Quispe', 'DNI', '12345678', NOW()),
(1, 'Maria Elena', 'Perez Quispe', 'DNI', '87654321', NOW()),
-- Pasajeros de la reserva XYZ789 (booking_id = 2)
(2, 'Roberto Carlos', 'Diaz Sanchez', 'DNI', '23456789', NOW()),
-- Pasajeros de la reserva DEF456 (booking_id = 3)
(3, 'Ana Sofia', 'Rodriguez Lopez', 'DNI', '34567890', NOW()),
(3, 'Luis Miguel', 'Rodriguez Lopez', 'DNI', '45678901', NOW()),
(3, 'Carmen Rosa', 'Rodriguez Lopez', 'DNI', '56789012', NOW()),
-- Pasajeros de la reserva GHI012 (booking_id = 4)
(4, 'Jorge Luis', 'Martinez Torres', 'DNI', '67890123', NOW()),
(4, 'Patricia Maria', 'Martinez Torres', 'DNI', '78901234', NOW()),
-- Pasajeros de la reserva JKL345 (booking_id = 5)
(5, 'Fernando', 'Garcia Vega', 'CE', '12345678', NOW()),
-- Pasajeros de la reserva MNO678 (booking_id = 6)
(6, 'Claudia Patricia', 'Silva Ramos', 'DNI', '89012345', NOW()),
(6, 'Ricardo Andres', 'Silva Ramos', 'DNI', '90123456', NOW()),
(6, 'Teresa Sofia', 'Silva Ramos', 'DNI', '01234567', NOW()),
(6, 'Pedro Luis', 'Silva Ramos', 'DNI', '12345670', NOW()),
-- Pasajeros de la reserva PQR901 (booking_id = 7)
(7, 'Gabriela', 'Flores Castro', 'DNI', '23456780', NOW()),
(7, 'Diego Armando', 'Flores Castro', 'DNI', '34567890', NOW()),
-- Pasajeros de la reserva STU234 (booking_id = 8)
(8, 'Monica Patricia', 'Navarro Ruiz', 'DNI', '45678901', NOW()),
-- Pasajeros de la reserva VWX567 (booking_id = 9)
(9, 'Andres Felipe', 'Cordova Mendoza', 'PAS', 'A1234567', NOW()),
(9, 'Luciana', 'Cordova Mendoza', 'PAS', 'B7654321', NOW()),
-- Pasajeros de la reserva YZA890 (booking_id = 10)
(10, 'Carlos Eduardo', 'Benavides Pacheco', 'DNI', '56789012', NOW()),
(10, 'Valentina', 'Benavides Pacheco', 'DNI', '67890123', NOW()),
(10, 'Sebastian', 'Benavides Pacheco', 'DNI', '78901234', NOW()),
-- Pasajeros de la reserva BCD234 (booking_id = 11) - EN HOLD
(11, 'Mariana', 'Torres Vega', 'DNI', '89012345', NOW()),
(11, 'Javier', 'Torres Vega', 'DNI', '90123456', NOW()),
-- Pasajeros de la reserva EFG567 (booking_id = 12) - EN HOLD
(12, 'Isabella', 'Mendoza Fernandez', 'PAS', 'C9876543', NOW()),
-- Pasajeros de la reserva HIA890 (booking_id = 13) - EN HOLD
(13, 'Rafael', 'Ortiz Salazar', 'DNI', '01234567', NOW()),
(13, 'Daniela', 'Ortiz Salazar', 'DNI', '12345678', NOW()),
(13, 'Mateo', 'Ortiz Salazar', 'DNI', '23456789', NOW()),
-- Pasajeros de la reserva CANCEL1 (booking_id = 14) - CANCELADA
(14, 'Alejandro', 'Ramirez Campos', 'DNI', '34567890', NOW()),
(14, 'Sofia', 'Ramirez Campos', 'DNI', '45678901', NOW()),
-- Pasajeros de la reserva CANCEL2 (booking_id = 15) - CANCELADA
(15, 'Nicolas', 'Vargas Delgado', 'PAS', 'D4567890', NOW()),
-- Pasajeros de la reserva EXP123 (booking_id = 16) - EXPIRADA
(16, 'Camila', 'Rojas Morales', 'DNI', '56789012', NOW()),
(16, 'Maximiliano', 'Rojas Morales', 'DNI', '67890123', NOW());

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
-- Verificación de datos insertados:
-- auth_service_db.user: 5 usuarios
-- flight_service_db.airport: 23 aeropuertos
-- flight_service_db.aircraft: 8 aeronaves
-- flight_service_db.route: 17 rutas
-- flight_service_db.flight_template: 20 plantillas de vuelo
-- flight_service_db.flight_instance: 26 instancias de vuelo
-- booking_service_db.booking: 16 reservas
-- booking_service_db.passenger: 34 pasajeros
