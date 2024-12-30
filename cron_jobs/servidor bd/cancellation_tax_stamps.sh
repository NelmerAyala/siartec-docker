#!/bin/bash

# Definir la variable de entorno para la contraseña
export PGPASSWORD='administrator'

# Definir la ruta para el archivo de log, incluyendo la fecha
LOG_PATH="/logs/tax_stamps/cancellation_daily/cancellation_daily_$(date +\%Y-\%m-\%d).log"

# Ejecutar el comando y redirigir la salida al archivo de log
{
  echo "Ejecutando cancelación de estampillas: $(date)"
  # Ejecutar el comando de cancelación de estampillas
  psql -U postgres -d siartec -c "UPDATE tax_stamp SET statusId=(SELECT id FROM status WHERE code ='CANCELED') WHERE statusId=(SELECT id FROM status WHERE code='GENERATED');"
  echo "Finalización del script: $(date)"
} >> "$LOG_PATH" 2>&1

# Desexportar la variable para mayor seguridad
unset PGPASSWORD