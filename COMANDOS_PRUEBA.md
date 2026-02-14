# SharpFly Backend - Guía de Inicio y Pruebas

## 1. Iniciar todos los servicios con Docker Compose

```bash
cd /home/jerucho/Documentos/Cibertec/DSWII/SharpFlyBackend

# Construir y levantar todos los servicios
docker-compose up --build

# Para ver logs en tiempo real
docker-compose logs -f

# Para detener todo
docker-compose down
```

## 2. Verificar que los servicios estén corriendo

```bash
# Verificar el API Gateway
curl http://localhost:8080/

# Verificar Auth Service
curl http://localhost:8990/

# Verificar Flight Service
curl http://localhost:8082/

# Verificar Booking Service
curl http://localhost:8083/
```

## 3. Flujo Completo de Prueba

### PASO 1: Crear usuario

```bash
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "juanperez",
    "password": "password123",
    "role": "USER"
  }'
```

**Respuesta esperada:** Usuario creado con ID

### PASO 2: Login y obtener token JWT

```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "juanperez",
    "password": "password123"
  }'
```

**Respuesta esperada:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Guardar el token** para usar en los siguientes pasos (reemplazar `<TOKEN>`):

```bash
export TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### PASO 3: Crear aeropuertos

```bash
# Aeropuerto de Lima
curl -X POST http://localhost:8080/api/v1/airports \
  -H "Content-Type: application/json" \
  -d '{
    "iata": "LIM",
    "name": "Jorge Chavez International",
    "city": "Lima",
    "country": "Peru",
    "timezone": "America/Lima"
  }'

# Aeropuerto de Santiago
curl -X POST http://localhost:8080/api/v1/airports \
  -H "Content-Type: application/json" \
  -d '{
    "iata": "SCL",
    "name": "Arturo Merino Benitez",
    "city": "Santiago",
    "country": "Chile",
    "timezone": "America/Santiago"
  }'
```

**Respuesta esperada:** Aeropuertos creados con IDs (asumamos ID 1 y 2)

### PASO 4: Crear aeronave

```bash
curl -X POST http://localhost:8080/api/v1/aircraft \
  -H "Content-Type: application/json" \
  -d '{
    "code": "A320-1",
    "model": "Airbus A320",
    "seatCapacity": 150
  }'
```

**Respuesta esperada:** Aeronave creada (asumamos ID 1)

### PASO 5: Crear ruta

```bash
curl -X POST http://localhost:8080/api/v1/routes \
  -H "Content-Type: application/json" \
  -d '{
    "originAirport": {"airportId": 1},
    "destinationAirport": {"airportId": 2}
  }'
```

**Respuesta esperada:** Ruta creada (asumamos ID 1)

### PASO 6: Crear plantilla de vuelo

```bash
curl -X POST http://localhost:8080/api/v1/flight-templates \
  -H "Content-Type: application/json" \
  -d '{
    "flightNumber": "LA123",
    "route": {"routeId": 1},
    "aircraft": {"aircraftId": 1},
    "defaultDurationMinutes": 240
  }'
```

**Respuesta esperada:** Plantilla creada (asumamos ID 1)

### PASO 7: Crear instancia de vuelo

```bash
curl -X POST http://localhost:8080/api/v1/flight-instances \
  -H "Content-Type: application/json" \
  -d '{
    "flightTemplate": {"flightTemplateId": 1},
    "departureAt": "2024-07-01T10:00:00",
    "arrivalAt": "2024-07-01T14:00:00",
    "capacity": 150
  }'
```

**Respuesta esperada:** Instancia creada (asumamos ID 1)

### PASO 8: Buscar vuelos disponibles

```bash
# Buscar por ciudades
curl -X GET "http://localhost:8080/api/v1/flight-instances/search?originCity=Lima&destinationCity=Santiago&start=2024-06-01T00:00:00&end=2024-07-31T23:59:59"

# Ver próximos vuelos
curl http://localhost:8080/api/v1/flight-instances/upcoming
```

### PASO 9: Crear una reserva

```bash
# Reserva rápida (30 minutos de hold)
curl -X POST "http://localhost:8080/api/v1/bookings/quick?flightInstanceId=1&passengerCount=2&userId=1&holdMinutes=30"
```

**Respuesta esperada:**
```json
{
  "bookingId": 1,
  "pnr": "AB12CD",
  "status": "HELD",
  "holdExpiresAt": "2024-06-01T10:30:00",
  ...
}
```

### PASO 10: Confirmar la reserva

```bash
curl -X POST http://localhost:8080/api/v1/bookings/AB12CD/confirm
```

**Respuesta esperada:** Status cambia a "CONFIRMED"

### PASO 11: Ver reservas del usuario

```bash
curl http://localhost:8080/api/v1/bookings/user/1
```

## 4. Endpoints Útiles para Testing

### Ver todos los aeropuertos
```bash
curl http://localhost:8080/api/v1/airports
```

### Ver todas las rutas
```bash
curl http://localhost:8080/api/v1/routes
```

### Ver vuelos por estado
```bash
curl http://localhost:8080/api/v1/flight-instances/status/SCHEDULED
```

### Ver reservas por vuelo
```bash
curl http://localhost:8080/api/v1/bookings/flight/1
```

### Contar reservas confirmadas en un vuelo
```bash
curl http://localhost:8080/api/v1/bookings/count/flight/1
```

## 5. Actualizar estado de un vuelo

```bash
# Actualizar vuelo a DESPEGADO
curl -X PATCH http://localhost:8080/api/v1/flight-instances/1/status?status=DEPARTED

# Actualizar vuelo a ATERRIZADO
curl -X PATCH http://localhost:8080/api/v1/flight-instances/1/status?status=ARRIVED
```

## 6. Cancelar una reserva

```bash
curl -X POST http://localhost:8080/api/v1/bookings/AB12CD/cancel
```

## 7. Probar búsqueda de vuelos por fecha

```bash
# Vuelos en un rango de fechas
curl -X GET "http://localhost:8080/api/v1/flight-instances/by-date-range?start=2024-06-01T00:00:00&end=2024-06-30T23:59:59"
```

## Resumen de Puertos

| Servicio | Puerto | URL |
|-----------|---------|-----|
| API Gateway | 8080 | http://localhost:8080 |
| Auth Service | 8990 | http://localhost:8990 |
| Flight Service | 8082 | http://localhost:8082 |
| Booking Service | 8083 | http://localhost:8083 |
| MySQL | 3307 | localhost:3307 |

## Troubleshooting

### Si los servicios no se conectan entre sí:
- Verificar que todos estén en la red `micro-network`:
  ```bash
  docker network ls
  docker network inspect sharpflybackend_micro-network
  ```

### Si hay errores de base de datos:
- Verificar que MySQL esté corriendo:
  ```bash
  docker ps | grep mysql
  ```
- Ver logs de MySQL:
  ```bash
  docker-compose logs db
  ```

### Ver logs de un servicio específico:
```bash
docker-compose logs auth-service
docker-compose logs flight-service
docker-compose logs booking-service
docker-compose logs api-gateway
```

### Reconstruir un solo servicio:
```bash
docker-compose up -d --build flight-service
```

## Notas Importantes

1. **Usar siempre el API Gateway (puerto 8080)** para todas las peticiones
2. **Los IDs en los ejemplos** (1, 2, etc.) son supuestos, usar los IDs reales devueltos por la API
3. **Guardar el token JWT** después del login para usarlo en endpoints protegidos
4. **Los PNR se generan automáticamente** - son códigos únicos de 6 caracteres
5. **Las reservas expiran** si no se confirman dentro del tiempo de hold (default: 30 minutos)
