# SharpFly Backend - Guía de Desarrollo

Esta guía te ayuda a configurar y ejecutar los microservicios en local y en Docker.

## 📋 Tabla de Contenidos

- [Requisitos Previos](#requisitos-previos)
- [Configuración Inicial](#configuración-inicial)
- [Modos de Ejecución](#modos-de-ejecución)
  - [Modo de Desarrollo Local](#modo-de-desarrollo-local)
  - [Modo Híbrido (API Gateway Local + Servicios Docker)](#modo-híbrido-api-gateway-local--servicios-docker)
  - [Modo Docker Completo](#modo-docker-completo)
- [Variables de Entorno](#variables-de-entorno)
- [Estructura de Servicios](#estructura-de-servicios)
- [Solución de Problemas](#solución-de-problemas)

## 🔧 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Java 21** (JDK/Eclipse Temurin)
- **Maven 3.9+**
- **Docker** y **Docker Compose**
- **Git**

### Verificar instalaciones:

```bash
java -version      # Debe ser Java 21
mvn -version       # Maven 3.9+
docker --version   # Docker 20+
docker-compose --version
```

## 🚀 Configuración Inicial

### 1. Clonar el repositorio (si aplica)

```bash
git clone <repository-url>
cd SharpFlyBackend
```

### 2. Configurar variables de entorno

```bash
# Copiar el archivo de ejemplo
cp .env.example .env

# Editar el archivo .env según tus necesidades
nano .env  # o tu editor preferido
```

**IMPORTANTE**: En producción, cambia el `JWT_SECRET` por uno seguro:
```bash
openssl rand -base64 64
```

## 💻 Modo de Desarrollo Local

Este modo es ideal para desarrollar y depurar los microservicios. Los servicios se ejecutan fuera de Docker con la base de datos dentro de Docker.

### Iniciar todos los servicios:

```bash
./start-local.sh
```

Este script:
1. Inicia la base de datos MySQL en Docker (puerto 3307)
2. Inicia los microservicios Spring Boot en sus puertos:
   - Auth Service: 8990
   - Flight Service: 8082
   - Booking Service: 8083

### Verificar que los servicios están corriendo:

```bash
# Ver los logs
tail -f logs/auth-service.log
tail -f logs/flight-service.log
tail -f logs/booking-service.log

# O verificar que los puertos estén escuchando
lsof -i :8990  # Auth Service
lsof -i :8082  # Flight Service
lsof -i :8083  # Booking Service
```

### Detener los servicios:

```bash
./stop-local.sh
```

### Iniciar un servicio individualmente:

```bash
cd auth-service
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

## 🔀 Modo Híbrido (API Gateway Local + Servicios Docker)

Este modo es ideal cuando quieres desarrollar y depurar el API Gateway localmente mientras los microservicios se ejecutan en Docker. Esto resuelve el problema de que el API Gateway no puede resolver los nombres de los contenedores Docker cuando se ejecuta fuera de Docker.

### Iniciar los microservicios en Docker:

```bash
./start-docker-services.sh
```

Este script inicia:
- Base de datos MySQL (puerto 3307)
- Auth Service (puerto 8990)
- Flight Service (puerto 8082)
- Booking Service (puerto 8083)

### Iniciar el API Gateway localmente:

```bash
./start-gateway-local.sh
```

Este script:
- Verifica que los servicios Docker estén corriendo
- Inicia el API Gateway con profile `dev` (configurado para usar localhost)
- El API Gateway se conecta a los servicios Docker usando localhost:PUERTO

### Detener el API Gateway local:

```bash
./stop-gateway-local.sh
```

### Detener los servicios Docker:

```bash
docker-compose down
```

### Ventajas de este modo:

1. **Depuración fácil**: Puedes depurar el API Gateway en tu IDE
2. **Rápido desarrollo**: Los cambios en el API Gateway se reflejan rápidamente
3. **Servicios aislados**: Los microservicios se ejecutan en Docker con su configuración de producción
4. **Configuración correcta**: El API Gateway usa `localhost:PUERTO` para conectarse a los servicios Docker

### Configuración de profiles en el API Gateway:

El API Gateway tiene dos perfiles:
- **dev**: Usa URLs de `localhost` (para ejecución local fuera de Docker)
- **prod**: Usa nombres de contenedores Docker (auth-service, flight-service, etc.)

Ver archivos:
- `api-gateway/src/main/resources/application-dev.yml`
- `api-gateway/src/main/resources/application-prod.yml`

## 🐳 Modo Docker Completo

Este modo es ideal para pruebas de integración y despliegue en producción. Todos los servicios (incluyendo los microservicios) se ejecutan en Docker.

### Iniciar todos los servicios:

```bash
./start-docker.sh
```

O manualmente:

```bash
docker-compose up --build -d
```

### Verificar el estado:

```bash
docker-compose ps
```

### Ver logs:

```bash
# Ver todos los logs
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f auth-service
docker-compose logs -f flight-service
docker-compose logs -f booking-service
```

### Detener todos los servicios:

```bash
docker-compose down

# Para eliminar también los volúmenes (datos):
docker-compose down -v
```

### Reconstruir un servicio específico:

```bash
docker-compose up -d --build flight-service
```

## 🔐 Variables de Entorno

Las variables de entorno se configuran en el archivo `.env`:

### Base de Datos

```bash
DB_ROOT_PASSWORD=root_password          # Contraseña de MySQL
DB_EXTERNAL_PORT=3307                   # Puerto expuesto fuera de Docker
```

### Seguridad

```bash
JWT_SECRET=tu_secreto_aqui              # Secreto para firmar JWTs
JWT_EXPIRATION_MS=36000000              # Tiempo de expiración del token (ms)
```

### Perfil de Spring

```bash
SPRING_PROFILES_ACTIVE=prod             # 'dev' para local, 'prod' para Docker
```

### Servicios

```bash
# Auth Service
AUTH_SERVER_PORT=8990
AUTH_EXTERNAL_PORT=8990
AUTH_DATASOURCE_URL=jdbc:mysql://db:3306/auth_db
AUTH_DATASOURCE_USERNAME=root
AUTH_DATASOURCE_PASSWORD=root_password

# Flight Service
FLIGHT_SERVER_PORT=8082
FLIGHT_EXTERNAL_PORT=8082
FLIGHT_DATASOURCE_URL=jdbc:mysql://db:3306/flight_db
FLIGHT_DATASOURCE_USERNAME=root
FLIGHT_DATASOURCE_PASSWORD=root_password

# Booking Service
BOOKING_SERVER_PORT=8083
BOOKING_EXTERNAL_PORT=8083
BOOKING_DATASOURCE_URL=jdbc:mysql://db:3306/booking_db
BOOKING_DATASOURCE_USERNAME=root
BOOKING_DATASOURCE_PASSWORD=root_password
FLIGHT_SERVICE_URL=http://flight-service:8082
```

## 🏗️ Estructura de Servicios

### Puertos

| Servicio       | Puerto Local | Puerto Docker |
|---------------|--------------|---------------|
| API Gateway   | 8080         | 8080          |
| Auth Service  | 8990         | 8990          |
| Flight Service| 8082         | 8082          |
| Booking Service| 8083        | 8083          |
| MySQL         | 3307         | 3306          |

### Perfiles de Spring

Cada servicio tiene dos perfiles:

- **dev**: Para desarrollo local
  - Base de datos en `localhost:3307`
  - Logs detallados (DEBUG)
  - DDL auto-update
  - SQL visible en consola

- **prod**: Para producción/Docker
  - Base de datos en `db:3306` (nombre del contenedor)
  - Logs de producción (INFO)
  - DDL validate
  - SQL oculto

## 🔧 Solución de Problemas

### Puerto ya en uso

```bash
# Encontrar el proceso
lsof -i :PUERTO

# Matar el proceso
kill -9 PID
```

### Limpiar todo y empezar de cero

```bash
# Detener servicios Docker
docker-compose down -v

# Limpiar procesos de Maven
pkill -f "spring-boot:run"

# Eliminar logs
rm -rf logs/
```

### Base de datos no inicia

```bash
# Ver logs de MySQL
docker-compose logs db

# Reiniciar solo la base de datos
docker-compose restart db
```

### Error de conexión a la base de datos

1. Verificar que la base de datos esté corriendo:
   ```bash
   docker-compose ps db
   ```

2. Verificar las credenciales en `.env`

3. Conectar manualmente para probar:
   ```bash
   mysql -h 127.0.0.1 -P 3307 -u root -p
   ```

### Logs no se generan

```bash
# Crear directorio de logs manualmente
mkdir -p logs

# Dar permisos de escritura
chmod 755 logs
```

## 📝 Scripts Disponibles

- `start-local.sh` - Inicia todos los servicios en modo desarrollo local
- `stop-local.sh` - Detiene servicios en modo desarrollo local
- `start-docker.sh` - Inicia todos los servicios en Docker (incluyendo API Gateway)
- `start-docker-services.sh` - Inicia solo microservicios en Docker (sin API Gateway)
- `start-gateway-local.sh` - Inicia el API Gateway localmente (requiere servicios Docker)
- `stop-gateway-local.sh` - Detiene el API Gateway local

## 🔄 Flujo de Trabajo Recomendado

### Para desarrollo del API Gateway:

1. Iniciar microservicios en Docker:
   ```bash
   ./start-docker-services.sh
   ```

2. Iniciar API Gateway localmente:
   ```bash
   ./start-gateway-local.sh
   ```

3. Desarrollar y probar cambios en el API Gateway

4. Ver logs del API Gateway:
   ```bash
   tail -f logs/api-gateway.log
   ```

5. Al terminar:
   ```bash
   ./stop-gateway-local.sh
   docker-compose down
   ```

### Para desarrollo de microservicios:

1. Iniciar servicios en local:
   ```bash
   ./start-local.sh
   ```

2. Desarrollar y probar cambios en microservicios

3. Ver logs en tiempo real:
   ```bash
   tail -f logs/NOMBRE_SERVICIO.log
   ```

4. Al terminar:
   ```bash
   ./stop-local.sh
   ```

### Para pruebas de integración completas:

1. Iniciar todo en Docker:
   ```bash
   ./start-docker.sh
   ```

2. Probar la aplicación completa

3. Ver logs:
   ```bash
   docker-compose logs -f
   ```

4. Al terminar:
   ```bash
   docker-compose down
   ```

## 🚢 Despliegue a Producción

1. **Cambiar el JWT_SECRET**:
   ```bash
   openssl rand -base64 64
   # Copiar el resultado a .env
   ```

2. **Ajustar variables sensibles** en `.env`:
   - Contraseñas de base de datos
   - JWT_SECRET
   - Puertos externos si es necesario

3. **Usar perfil prod** (ya configurado por defecto en docker-compose)

4. **Iniciar servicios**:
   ```bash
   docker-compose up -d
   ```

5. **Verificar salud de servicios**:
   ```bash
   docker-compose ps
   curl http://localhost:8080/actuator/health
   ```

## 📚 Recursos Adicionales

- [Documentación de Spring Boot](https://spring.io/projects/spring-boot)
- [Documentación de Docker Compose](https://docs.docker.com/compose/)
- [Documentación de MySQL](https://dev.mysql.com/doc/)
