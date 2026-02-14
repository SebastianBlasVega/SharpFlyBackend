# SharpFly Backend - Configuración de Desarrollo Local

## Arquitectura de Base de Datos

**IMPORTANTE:** Todos los entornos (local y Docker) usan la **misma base de datos MySQL** que se ejecuta en Docker.

- **MySQL Docker:** `localhost:3307` (expuesto desde el contenedor)
- **Usuario:** `root`
- **Contraseña:** `root_password`

## Bases de Datos

- `auth_db` - Servicio de autenticación
- `flight_db` - Servicio de vuelos
- `booking_db` - Servicio de reservas

## Usuarios de Prueba

| Usuario | Contraseña | Rol  |
|---------|------------|------|
| admin   | password123 | ADMIN |
| user    | password123 | USER  |
| juan.perez | password123 | USER |
| maria.gomez | password123 | USER |

## Modos de Ejecución

### Modo 1: Desarrollo Local (Recomendado para desarrollo de servicios)

**Servicios:** Todos los servicios Spring Boot se ejecutan localmente
**Base de datos:** MySQL en Docker (puerto 3307)

```bash
# 1. Asegurarse de que MySQL esté corriendo
docker compose up -d db

# 2. Verificar que MySQL esté listo
docker ps | grep mysql

# 3. Iniciar los servicios localmente
# En terminales separadas:
cd auth-service
mvn spring-boot:run

cd flight-service
mvn spring-boot:run

cd booking-service
mvn spring-boot:run

cd api-gateway
mvn spring-boot:run
```

### Modo 2: Híbrido (Recomendado para desarrollo del API Gateway)

**API Gateway:** Local
**Microservicios:** Docker
**Base de datos:** MySQL en Docker

```bash
# 1. Iniciar microservicios en Docker
./start-docker-services.sh

# 2. Iniciar API Gateway localmente
./start-gateway-local.sh
```

### Modo 3: Docker Completo (Producción/Pruebas)

**Todos los servicios:** Docker

```bash
# Iniciar todo en Docker
./start-docker.sh
```

## Pasos Iniciales (Primera Vez)

### 1. Iniciar MySQL

```bash
cd /home/jerucho/Documentos/Cibertec/DSWII/SharpFlyBackend
docker compose up -d db
```

### 2. Crear Bases de Datos y Usuarios

```bash
mysql -h 127.0.0.1 -P 3307 -u root -proot_password < scripts/init-complete.sql
```

O manualmente:

```bash
mysql -h 127.0.0.1 -P 3307 -u root -proot_password
```

```sql
-- Crear bases de datos
CREATE DATABASE IF NOT EXISTS auth_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS flight_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS booking_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Usar auth_db
USE auth_db;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL DEFAULT 'USER'
);

-- Insertar usuarios de prueba
INSERT INTO user (username, password, role) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ADMIN'),
('user', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'USER'),
('juan.perez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'USER'),
('maria.gomez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'USER')
ON DUPLICATE KEY UPDATE username=username;

-- Verificar usuarios
SELECT id, username, role FROM user;
```

### 3. Verificar Conexión

```bash
# Ver bases de datos
mysql -h 127.0.0.1 -P 3307 -u root -proot_password -e "SHOW DATABASES;"

# Ver usuarios
mysql -h 127.0.0.1 -P 3307 -u root -proot_password auth_db -e "SELECT * FROM user;"
```

## Probar la Autenticación

### Login

```bash
curl -X POST http://localhost:8990/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user","password":"password123"}'
```

Respuesta esperada:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Probar Endpoint Protegido

```bash
# Reemplaza YOUR_TOKEN con el token obtenido
curl -X GET http://localhost:8080/api/v1/aircrafts \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Verificación del JWT

Ve a [jwt.io](https://jwt.io/) y pega el token para ver su contenido:

```json
{
  "uid": 2,
  "roles": ["USER"],
  "sub": "user",
  "iat": 1234567890,
  "exp": 1234567890
}
```

## Troubleshooting

### MySQL no está corriendo

```bash
docker ps | grep mysql
docker compose up -d db
```

### Error: "Communications link failure"

Verifica que MySQL esté corriendo y accesible:
```bash
docker ps | grep mysql
telnet localhost 3307
```

### Error: "Access denied"

Verifica las credenciales:
```bash
mysql -h 127.0.0.1 -P 3307 -u root -proot_password
```

### El servicio no inicia

Verifica que el puerto esté disponible:
```bash
lsof -i :8990  # auth-service
lsof -i :8082  # flight-service
lsof -i :8083  # booking-service
lsof -i :8080  # api-gateway
```

### Verificar logs

```bash
# Ver logs de MySQL
docker logs mysql-db -f

# Ver logs de servicios (si se ejecutan con scripts)
tail -f logs/*.log
```

## Configuración de JWT

Todos los servicios usan el **mismo secret JWT**:
```
NDI0MjQyNDI0MjQyNDI0MjQyNDI0MjQyNDI0MjQyNDI0MjQyNDI0MjQyNDI0Mg==
```

Este secret está configurado en:
- `auth-service/src/main/resources/application-dev.yml`
- `flight-service/src/main/resources/application.yml`
- `booking-service/src/main/resources/application.yml`
- `api-gateway/src/main/resources/application.yml`

## Puertos

| Servicio       | Puerto |
|---------------|--------|
| API Gateway   | 8080   |
| Auth Service  | 8990   |
| Flight Service| 8082   |
| Booking Service| 8083  |
| MySQL         | 3307   |
