#!/bin/bash

# Define el URL del endpoint
API_URL="http://192.168.0.120:8020/calculation-factor/synchronize"

# Definir la ruta para el archivo de log, incluyendo la fecha
LOG_PATH="/logs/endpoints/calculation_factor/create_calculation_factor_$(date +\%Y-\%m-\%d).log"

# Ejecutar el comando y redirigir la salida al archivo de log
{
  echo "Ejecutando consumo de endpoint: $(date)"
  
  # Ejecutar el comando curl a endpoint /calculation-factor/synchronize
  RESPONSE=$(curl --silent --request GET $API_URL)
  
  # Muestra la respuesta
  echo "Respuesta del servidor:"
  echo "$RESPONSE"

  echo "Finalización del script: $(date)"
} >> "$LOG_PATH" 2>&1

# Desexportar la variable para mayor seguridad
unset API_URL
