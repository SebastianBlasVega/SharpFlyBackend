# Solución al Error 401 - Autenticación JWT

## Problema
Recibes un error 401 al intentar acceder a `http://localhost:8080/api/v1/aircrafts` con un token JWT.

## Diagnóstico
Todos los servicios tienen configurado el **mismo secret JWT**:
- Secret: `NDI0MjQyNDI0MjQyNDI0MjQyNDI0MjQyNDI0MjQyNDI0MjQyNDI0MjQyNDI0Mg==`

El problema es que probablemente:
1. No tienes usuarios creados en la base de datos
2. Los usuarios no tienen el rol correcto (USER o ADMIN)
3. Las contraseñas no están hasheadas correctamente

## Solución Paso a Paso

### Paso 1: Ejecutar el script SQL para crear usuarios

```bash
# Conectarse a la base de datos MySQL
mysql -h 127.0.0.1 -P 3307 -u root -p
# Contraseña: root_password

# Ejecutar el script
source /tmp/init-users.sql

# Verificar los usuarios
USE auth_db;
SELECT id, username, role FROM user;
```

### Paso 2: Probar el login

```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user","password":"password123"}'
```

Deberías recibir una respuesta como:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Paso 3: Verificar el contenido del JWT

Ve a [jwt.io](https://jwt.io/) y pega el token para ver su contenido. Debería tener:

```json
{
  "uid": 2,
  "roles": ["USER"],
  "sub": "user",
  "iat": 1234567890,
  "exp": 1234567890
}
```

**IMPORTANTE**: El claim `roles` debe ser un array con el valor `USER` o `ADMIN`.

### Paso 4: Probar el endpoint protegido

```bash
# Reemplaza YOUR_TOKEN con el token obtenido en el paso 2
curl -X GET http://localhost:8080/api/v1/aircrafts \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Paso 5: Usar el script de prueba automatizada

```bash
# Ejecutar el script de prueba
./test-auth.sh
```

## Usuarios de Prueba Disponibles

| Usuario | Contraseña | Rol  |
|---------|------------|------|
| admin   | password123 | ADMIN |
| user    | password123 | USER  |
| juan.perez | password123 | USER |
| maria.gomez | password123 | USER |

## Verificación de Configuración

### Verificar que el API Gateway está ejecutándose con el profile correcto

```bash
# Ver logs del API Gateway
tail -f logs/api-gateway.log | grep -i "profile"
```

Debería mostrar algo como: `The following 1 profile is active: "dev"`

### Verificar que los servicios Docker están corriendo

```bash
docker-compose ps
```

Todos los servicios deben estar "Up".

## Solución de Problemas Comunes

### Error: "No se puede conectar al servidor"

Verifica que los servicios estén corriendo:
```bash
./start-docker-services.sh  # Si no están corriendo
./start-gateway-local.sh    # Si el API Gateway no está corriendo
```

### Error: "401 Unauthorized"

1. Verifica que el token sea válido usando jwt.io
2. Verifica que el token tenga el claim `roles` con valor `USER` o `ADMIN`
3. Verifica que el secret JWT sea el mismo en todos los servicios

### Error: "403 Forbidden"

El usuario no tiene el rol necesario. Usa el usuario `admin` que tiene rol `ADMIN`.

### El token expira muy rápido

El tiempo de expiración está configurado en `application.yml`:
```yaml
security:
  jwt:
    expiration-ms: 36000000  # 10 horas
```

## Recursos Adicionales

- [Documentación de Spring Security JWT](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html)
- [jwt.io - Debugger](https://jwt.io/)
- Script de prueba: `./test-auth.sh`
- Script SQL: `/tmp/init-users.sql`
