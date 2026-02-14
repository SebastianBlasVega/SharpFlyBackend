#!/bin/bash

# Script para detener el API Gateway local

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Deteniendo API Gateway Local${NC}"
echo -e "${GREEN}========================================${NC}"

# Cambiar al directorio raíz del proyecto
cd "$(dirname "$0")"

# Verificar si existe el archivo PID
if [ ! -f logs/api-gateway.pid ]; then
    echo -e "${YELLOW}⚠️  No se encontró archivo PID del API Gateway${NC}"
    echo -e "${YELLOW}Intentando buscar proceso en el puerto 8080...${NC}"

    # Buscar proceso por puerto
    pid=$(lsof -ti :8080 2>/dev/null || echo "")

    if [ -z "$pid" ]; then
        echo -e "${YELLOW}No hay proceso ejecutándose en el puerto 8080${NC}"
        exit 0
    fi

    echo -e "${GREEN}Proceso encontrado (PID: $pid)${NC}"
else
    pid=$(cat logs/api-gateway.pid)
fi

# Detener el proceso
echo -e "${YELLOW}Deteniendo API Gateway (PID: $pid)...${NC}"

if kill $pid 2>/dev/null; then
    echo -e "${GREEN}✓ API Gateway detenido${NC}"
    rm -f logs/api-gateway.pid
else
    echo -e "${YELLOW}⚠️  El proceso $pid no está corriendo${NC}"
    rm -f logs/api-gateway.pid
fi

# Verificar que el puerto esté libre
sleep 1
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${RED}✗ El puerto 8080 todavía está en uso${NC}"
    echo -e "${YELLOW}Puedes forzar la detención con:${NC}"
    echo -e "  kill -9 \$(lsof -ti :8080)"
else
    echo -e "${GREEN}✓ Puerto 8080 liberado${NC}"
fi

echo ""
