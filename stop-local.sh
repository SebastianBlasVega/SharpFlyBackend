#!/bin/bash

# Script para detener servicios en local

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SharpFly Backend - Detener Servicios${NC}"
echo -e "${GREEN}========================================${NC}"

# Cambiar al directorio raíz del proyecto
cd "$(dirname "$0")"

# Función para detener un servicio
stop_service() {
    local service_name=$1
    local pid_file="logs/$service_name.pid"

    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p $pid > /dev/null 2>&1; then
            echo -e "${YELLOW}Deteniendo $service_name (PID: $pid)...${NC}"
            kill $pid
            rm "$pid_file"
            echo -e "${GREEN}✓ $service_name detenido${NC}"
        else
            echo -e "${YELLOW}⚠️  $service_name no está corriendo (PID: $pid)${NC}"
            rm "$pid_file"
        fi
    else
        echo -e "${YELLOW}⚠️  No se encontró PID para $service_name${NC}"
    fi
}

# Detener servicios
stop_service "auth-service"
stop_service "flight-service"
stop_service "booking-service"

# Preguntar si también se quiere detener la base de datos
echo -e "\n${YELLOW}¿Deseas detener también la base de datos Docker? (y/n)${NC}"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${YELLOW}Deteniendo base de datos...${NC}"
    docker-compose down
    echo -e "${GREEN}✓ Base de datos detenida${NC}"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Servicios detenidos${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
