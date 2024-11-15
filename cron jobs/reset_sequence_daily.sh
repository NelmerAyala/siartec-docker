#!/bin/bash

# Definir la variable de entorno para la contraseña
export PGPASSWORD='tu_contraseña'

# Ejecutar el comando de reinicio de secuencia
psql -U tu_usuario -d tu_base_de_datos -c "SELECT reset_sequence('daily_seq');"

# Desexportar la variable para mayor seguridad
unset PGPASSWORD