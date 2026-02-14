#!/bin/bash

# Script para iniciar todos los servicios en Docker (incluyendo microservicios)
set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SharpFly Backend - Modo Docker${NC}"
echo -e "${GREEN}========================================${NC}"

# Cambiar al directorio raíz del proyecto
cd "$(dirname "$0")"

# Verificar si .env existe, si no, crearlo desde .env.example
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creando .env desde .env.example...${NC}"
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Por favor revisa el archivo .env y ajusta las variables según necesites${NC}"
fi

# Construir y levantar todos los servicios
echo -e "${GREEN}Construyendo e iniciando servicios...${NC}"
docker-compose up --build -d

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Todos los servicios iniciados${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${NC}Servicios disponibles:${NC}"
echo -e "  • API Gateway:    http://localhost:8080"
echo -e "  • Auth Service:   http://localhost:8990"
echo -e "  • Flight Service: http://localhost:8082"
echo -e "  • Booking Service: http://localhost:8083"
echo -e "  • MySQL:          localhost:3307"
echo -e "\n${YELLOW}Para ver los logs:${NC}"
echo -e "  docker-compose logs -f [servicio]"
echo -e "\n${YELLOW}Para detener todos los servicios:${NC}"
echo -e "  docker-compose down"
echo ""
