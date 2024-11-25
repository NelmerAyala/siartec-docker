#!/bin/bash

# Define el URL del endpoint
API_URL_AUTH="http://192.168.0.120:8020/auth/sign-in"
API_URL_SYNC="http://192.168.0.120:8020/calculation-factor/synchronize"

EMAIL="shyf.infosiartec@gmail.com"
PASSWORD="Tigger32xl@"

# Definir la ruta para el archivo de log, incluyendo la fecha
LOG_PATH="/logs/endpoints/calculation_factor/create_calculation_factor_$(date +\%Y-\%m-\%d).log"

# Ejecutar el comando y redirigir la salida al archivo de log
{
  echo "Ejecutando consumo de endpoint: $(date)"
  
  # Ejecutar el comando curl a endpoint /auth/sign-in
  AUTH=$(curl -s -X POST "$API_URL_AUTH" -H "Content-Type: application/json" -d '{"email": "'"$EMAIL"'", "password": "'"$PASSWORD"'"}')

  # Extrae el access_token del JSON anidado
  ACCESS_TOKEN=$(echo $AUTH | jq -r '.access_token')

  # Verifica si se obtuvo el access_token
  if [ "$ACCESS_TOKEN" == "null" ] || [ -z "$ACCESS_TOKEN" ]; then
    echo "Error: No se pudo obtener el token."
    exit 1
  fi

  echo "Access Token obtenido: $ACCESS_TOKEN"

  # Ejecutar el comando curl a endpoint /calculation-factor/synchronize
  RESPONSE=$(curl --silent --request GET $API_URL_SYNC -H "Authorization: Bearer $ACCESS_TOKEN")
  
  # Muestra la respuesta
  echo "Respuesta del servidor:"
  echo "$RESPONSE"

  echo "Finalización del script: $(date)"
} >> "$LOG_PATH" 2>&1

# Desexportar la variable para mayor seguridad
unset API_URL_AUTH
unset API_URL_SYNC
unset EMAIL
unset PASSWORD
