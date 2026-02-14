#!/bin/bash

# Script para iniciar el API Gateway localmente
# Asegúrate de que los servicios Docker estén iniciados primero (usando start-docker-services.sh)

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SharpFly Backend - API Gateway Local${NC}"
echo -e "${GREEN}========================================${NC}"

# Cambiar al directorio raíz del proyecto
cd "$(dirname "$0")"

# Verificar si los servicios Docker están corriendo
echo -e "${YELLOW}Verificando servicios Docker...${NC}"

if ! docker-compose ps db | grep -q "Up"; then
    echo -e "${RED}✗ Los servicios Docker no están iniciados${NC}"
    echo -e "${YELLOW}Ejecuta primero: ./start-docker-services.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Servicios Docker detectados${NC}"

# Verificar si el puerto 8080 está disponible
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${RED}✗ El puerto 8080 ya está en uso${NC}"
    echo -e "${YELLOW}Detén el proceso que está usando el puerto 8080${NC}"
    exit 1
fi

# Crear directorio de logs si no existe
mkdir -p logs

# Iniciar el API Gateway
echo -e "\n${GREEN}Iniciando API Gateway en puerto 8080...${NC}"
echo -e "${YELLOW}Profile: dev (localhost)${NC}"

cd api-gateway

# Ejecutar en background con profile dev
mvn spring-boot:run -Dspring-boot.run.profiles=dev > ../logs/api-gateway.log 2>&1 &

pid=$!
echo $pid > ../logs/api-gateway.pid
echo -e "${GREEN}✓ API Gateway iniciado (PID: $pid)${NC}"

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ API Gateway disponible${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${NC}API Gateway: http://localhost:8080${NC}"
echo -e "\n${YELLOW}Logs disponibles en: logs/api-gateway.log${NC}"
echo -e "${YELLOW}Para detener el API Gateway:${NC}"
echo -e "  kill \$(cat logs/api-gateway.pid)"
echo -e "  o usa: ./stop-gateway-local.sh"
echo ""
