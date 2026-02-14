#!/bin/bash

# Script para iniciar servicios en local
# Este script inicia la base de datos en Docker y los servicios Spring Boot en local

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SharpFly Backend - Inicio Local${NC}"
echo -e "${GREEN}========================================${NC}"

# Cambiar al directorio raíz del proyecto
cd "$(dirname "$0")"

# Verificar si .env existe, si no, crearlo desde .env.example
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creando .env desde .env.example...${NC}"
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Por favor revisa el archivo .env y ajusta las variables según necesites${NC}"
fi

# Iniciar solo la base de datos en Docker
echo -e "\n${GREEN}1. Iniciando base de datos MySQL en Docker...${NC}"
docker-compose up -d db

# Esperar a que la base de datos esté lista
echo -e "${YELLOW}Esperando a que la base de datos esté lista...${NC}"
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if docker-compose exec -T db mysqladmin ping -h localhost --silent 2>/dev/null; then
        echo -e "${GREEN}✓ Base de datos lista${NC}"
        break
    fi
    attempt=$((attempt + 1))
    echo -n "."
    sleep 1
done

if [ $attempt -eq $max_attempts ]; then
    echo -e "${RED}✗ La base de datos no está disponible después de $max_attempts segundos${NC}"
    exit 1
fi

# Función para iniciar un servicio
start_service() {
    local service_name=$1
    local service_path=$2
    local port=$3

    echo -e "\n${GREEN}2. Iniciando $service_name en puerto $port...${NC}"

    # Verificar si el puerto ya está en uso
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  El puerto $port ya está en uso. Saltando $service_name.${NC}"
        return 0
    fi

    cd "$service_path"

    # Compilar y ejecutar en background
    mvn spring-boot:run -Dspring-boot.run.profiles=dev > ../logs/$service_name.log 2>&1 &

    local pid=$!
    echo $pid > ../logs/$service_name.pid
    echo -e "${GREEN}✓ $service_name iniciado (PID: $pid)${NC}"
    echo -e "${YELLOW}  Logs: logs/$service_name.log${NC}"

    cd -
}

# Crear directorio de logs si no existe
mkdir -p logs

# Iniciar servicios
start_service "auth-service" "auth-service" "8990"
start_service "flight-service" "flight-service" "8082"
start_service "booking-service" "booking-service" "8083"

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Todos los servicios iniciados${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${NC}Servicios disponibles:${NC}"
echo -e "  • Auth Service:   http://localhost:8990"
echo -e "  • Flight Service: http://localhost:8082"
echo -e "  • Booking Service: http://localhost:8083"
echo -e "\n${YELLOW}Para detener los servicios, usa:${NC}"
echo -e "  ./stop-local.sh"
echo ""
