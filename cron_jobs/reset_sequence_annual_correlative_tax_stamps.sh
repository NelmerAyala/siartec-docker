#!/bin/bash

# Definir la variable de entorno para la contraseña
export PGPASSWORD='administrator'

# Definir la ruta para el archivo de log, incluyendo la fecha
LOG_PATH="/logs/reset_sequences/annual_correlative_tax_stamps/reset_sequence_$(date +\%Y-\%m-\%d).log"

# Ejecutar el comando y redirigir la salida al archivo de log
{
  echo "Ejecutando reinicio de secuencia: $(date)"
  # Ejecutar el comando de reinicio de secuencia
  psql -U postgres -d siartec -c "SELECT reset_sequence('annual_correlative_tax_stamps');"
  echo "Finalización del script: $(date)"
} >> "$LOG_PATH" 2>&1

# Desexportar la variable para mayor seguridad
unset PGPASSWORD