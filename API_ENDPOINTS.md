# SharpFly API - Documentación de Endpoints

## Base URL
- **Local**: `http://localhost:8080`
- **Auth Service**: `http://localhost:8990`
- **Flight Service**: `http://localhost:8082`
- **Booking Service**: `http://localhost:8083`

---

## AUTH SERVICE (Port 8990)

### Authentication
- `POST /auth/login` - Login y generación de JWT
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```

### User Management
- `POST /api/v1/users` - Crear usuario
- `GET /api/v1/users/{id}` - Obtener usuario por ID
- `GET /api/v1/users/username/{username}` - Obtener usuario por username
- `GET /api/v1/users` - Listar usuarios (opcional: `?role=ADMIN`)
- `PUT /api/v1/users/{id}` - Actualizar usuario
- `DELETE /api/v1/users/{id}` - Eliminar usuario
- `GET /api/v1/users/exists/username/{username}` - Verificar si existe username
- `POST /api/v1/users/validate?username=X&password=Y` - Validar credenciales

---

## FLIGHT SERVICE (Port 8082)

### Airports `/api/v1/airports`
- `POST /` - Crear aeropuerto
- `GET /{id}` - Obtener por ID
- `GET /iata/{iata}` - Obtener por código IATA (LIM, SCL, etc)
- `GET /` - Listar todos (opcional: `?activeOnly=true`)
- `PUT /{id}` - Actualizar aeropuerto
- `DELETE /{id}` - Eliminar aeropuerto
- `GET /exists/iata/{iata}` - Verificar existencia

### Aircraft `/api/v1/aircraft`
- `POST /` - Crear aeronave
- `GET /{id}` - Obtener por ID
- `GET /code/{code}` - Obtener por código (A320-1, etc)
- `GET /` - Listar todos (opcional: `?activeOnly=true`)
- `PUT /{id}` - Actualizar aeronave
- `DELETE /{id}` - Eliminar aeronave
- `GET /exists/code/{code}` - Verificar existencia

### Routes `/api/v1/routes`
- `POST /` - Crear ruta
- `GET /{id}` - Obtener por ID
- `GET /by-airports?originId=X&destinationId=Y` - Obtener ruta entre aeropuertos
- `GET /` - Listar todos (opcional: `?activeOnly=true`)
- `GET /by-origin/{originId}` - Rutas por origen
- `GET /by-destination/{destId}` - Rutas por destino
- `PUT /{id}` - Actualizar ruta
- `DELETE /{id}` - Eliminar ruta
- `GET /exists?originId=X&destinationId=Y` - Verificar existencia

### Flight Templates `/api/v1/flight-templates`
- `POST /` - Crear plantilla de vuelo
- `GET /{id}` - Obtener por ID
- `GET /number/{flightNumber}` - Obtener por número (LA123, etc)
- `GET /` - Listar todos (opcional: `?activeOnly=true`)
- `GET /by-route/{routeId}` - Por ruta
- `GET /by-aircraft/{aircraftId}` - Por aeronave
- `PUT /{id}` - Actualizar plantilla
- `DELETE /{id}` - Eliminar plantilla
- `GET /exists/number/{flightNumber}` - Verificar existencia

### Flight Instances `/api/v1/flight-instances`
- `POST /` - Crear instancia de vuelo
- `GET /{id}` - Obtener por ID (con detalles completos)
- `GET /` - Listar todas las instancias
- `GET /status/{status}` - Por estado (SCHEDULED, DELAYED, CANCELLED, DEPARTED, ARRIVED)
- `GET /by-date-range?start=2024-01-01T00:00:00&end=2024-01-31T23:59:59` - Por rango de fechas
- `GET /by-template/{templateId}` - Por plantilla
- `GET /search?originAirportId=X&start=Y&end=Z` - Buscar por aeropuerto origen y fechas
- `GET /search?originCity=Lima&destinationCity=Santiago&start=Y&end=Z` - Buscar por ciudades y fechas
- `GET /upcoming` - Próximos vuelos (departureAt > ahora)
- `PUT /{id}` - Actualizar instancia
- `PATCH /{id}/status?status=DEPARTED` - Actualizar estado
- `DELETE /{id}` - Eliminar instancia

---

## BOOKING SERVICE (Port 8083)

### Bookings `/api/v1/bookings`
- `POST /` - Crear reserva con pasajeros
  ```json
  {
    "flightInstanceId": 1,
    "passengerCount": 2,
    "createdByUserId": 1,
    "holdExpiresAt": "2024-01-01T12:00:00",
    "passengers": [
      {
        "firstName": "Juan",
        "lastName": "Perez",
        "docType": "DNI",
        "docNumber": "12345678"
      }
    ]
  }
  ```
- `POST /quick?flightInstanceId=X&passengerCount=Y&userId=Z&holdMinutes=30` - Reserva rápida
- `GET /{id}` - Obtener por ID
- `GET /pnr/{pnr}` - Obtener por PNR (ej: AB12CD)
- `GET /` - Listar todas las reservas
- `GET /flight/{flightInstanceId}` - Reservas por vuelo
- `GET /user/{userId}` - Reservas por usuario
- `GET /status/{status}` - Por estado (HELD, CONFIRMED, CANCELLED, EXPIRED)
- `GET /expired` - Reservas expiradas (held + vencidas)
- `GET /expiring?minutes=30` - Reservas que expiran en próximos N minutos
- `POST /{pnr}/confirm` - Confirmar reserva (HELD → CONFIRMED)
- `POST /{pnr}/cancel` - Cancelar reserva (→ CANCELLED)
- `PUT /{id}` - Actualizar reserva
- `DELETE /{id}` - Eliminar reserva
- `GET /exists/pnr/{pnr}` - Verificar existencia
- `GET /count/flight/{flightInstanceId}` - Contar reservas confirmadas+held

### Passengers `/api/v1/passengers`
- `POST /` - Crear pasajero
- `GET /{id}` - Obtener por ID
- `GET /booking/{bookingId}` - Pasajeros por reserva
- `GET /count/booking/{bookingId}` - Contar pasajeros de reserva
- `GET /search/doc/{docNumber}` - Buscar por número de documento
- `PUT /{id}` - Actualizar pasajero
- `DELETE /{id}` - Eliminar pasajero

---

## Ejemplos de Uso

### 1. Crear usuario y obtener token
```bash
# Crear usuario
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"username":"juan","password":"123456","role":"USER"}'

# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"juan","password":"123456"}'
```

### 2. Configurar aeropuertos y vuelos
```bash
# Crear aeropuerto origen
curl -X POST http://localhost:8080/api/v1/airports \
  -H "Content-Type: application/json" \
  -d '{"iata":"LIM","name":"Jorge Chavez","city":"Lima","country":"Peru","timezone":"America/Lima"}'

# Crear ruta
curl -X POST http://localhost:8080/api/v1/routes \
  -H "Content-Type: application/json" \
  -d '{"originAirport":{"airportId":1},"destinationAirport":{"airportId":2}}'

# Crear instancia de vuelo
curl -X POST http://localhost:8080/api/v1/flight-instances \
  -H "Content-Type: application/json" \
  -d '{
    "flightTemplate":{"flightTemplateId":1},
    "departureAt":"2024-06-01T10:00:00",
    "arrivalAt":"2024-06-01T14:00:00",
    "capacity":150
  }'
```

### 3. Crear reserva
```bash
# Reserva rápida (30 minutos de hold)
curl -X POST "http://localhost:8080/api/v1/bookings/quick?flightInstanceId=1&passengerCount=2&userId=1&holdMinutes=30"

# Confirmar reserva
curl -X POST http://localhost:8080/api/v1/bookings/AB12CD/confirm

# Buscar reservas por usuario
curl http://localhost:8080/api/v1/bookings/user/1
```

---

## Códigos de Estado

### FlightStatus
- `SCHEDULED` - Programado
- `DELAYED` - Retrasado
- `CANCELLED` - Cancelado
- `DEPARTED` - Despegado
- `ARRIVED` - Aterrizado

### BookingStatus
- `HELD` - Reservado (en espera de confirmación)
- `CONFIRMED` - Confirmado
- `CANCELLED` - Cancelado
- `EXPIRED` - Expirado (tiempo de hold agotado)

---

## Notas
- Todos los endpoints devuelven JSON
- Para endpoints que requieren autenticación, incluir header: `Authorization: Bearer <token>`
- Fechas en formato ISO 8601: `2024-01-01T10:00:00`
- PNR se genera automáticamente (6 caracteres alfanuméricos)
- Los tiempos de hold se configuran en minutos (default: 30)
