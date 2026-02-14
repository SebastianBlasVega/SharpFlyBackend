#!/bin/bash

# Script para probar la autenticación completa
# Genera un JWT y hace una petición a los endpoints protegidos

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  SharpFly - Test de Autenticación${NC}"
echo -e "${BLUE}========================================${NC}"

# Configuración
GATEWAY_URL="http://localhost:8080"
AUTH_URL="${GATEWAY_URL}/auth"
AUTH_USER="user"
AUTH_PASS="password123"

echo -e "\n${YELLOW}1. Probando login...${NC}"
echo -e "${BLUE}URL: ${AUTH_URL}/login${NC}"
echo -e "${BLUE}Usuario: ${AUTH_USER}${NC}"
echo -e "${BLUE}Contraseña: ${AUTH_PASS}${NC}"

# Hacer login
LOGIN_RESPONSE=$(curl -s -X POST "${AUTH_URL}/login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"${AUTH_USER}\",\"password\":\"${AUTH_PASS}\"}")

echo -e "\n${GREEN}Respuesta del login:${NC}"
echo "$LOGIN_RESPONSE" | jq '.'

# Extraer el token
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token // empty')

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    echo -e "\n${RED}✗ Error: No se pudo obtener el token${NC}"
    echo -e "${YELLOW}Respuesta completa:${NC}"
    echo "$LOGIN_RESPONSE"
    exit 1
fi

echo -e "\n${GREEN}✓ Token obtenido:${NC}"
echo "$TOKEN" | cut -c1-50
echo "..."

# Decodificar el JWT (sin verificar la firma, solo para ver el contenido)
echo -e "\n${YELLOW}2. Decodificando JWT (contenido):${NC}"
echo "$TOKEN" | jq -R 'split(".") | .[0],.[1]' | jq -R 'gsub("-"; "+") | gsub("_"; "/") | . + "==" | . as $base64 | @base64d | fromjson'

# Hacer una petición a un endpoint protegido
echo -e "\n${YELLOW}3. Probando endpoint protegido /api/v1/aircrafts${NC}"

AIRCRAFTS_RESPONSE=$(curl -s -X GET "${GATEWAY_URL}/api/v1/aircrafts" \
  -H "Authorization: Bearer ${TOKEN}")

echo -e "\n${GREEN}Respuesta:${NC}"
echo "$AIRCRAFTS_RESPONSE" | jq '.'

# Verificar si la respuesta fue exitosa
if echo "$AIRCRAFTS_RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
    echo -e "\n${RED}✗ Error en la petición${NC}"
    exit 1
else
    echo -e "\n${GREEN}✓ Petición exitosa${NC}"
fi

echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}  Test completado exitosamente${NC}"
echo -e "${BLUE}========================================${NC}"
