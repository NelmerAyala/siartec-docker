#!/bin/bash

# Definir la variable de entorno para la contraseña
export PGPASSWORD='administrator'

# Ejecutar el comando de reinicio de secuencia
psql -U postgres -d siartec -c "SELECT reset_sequence('annual_correlative_tax_stamps');"

# Desexportar la variable para mayor seguridad
unset PGPASSWORD