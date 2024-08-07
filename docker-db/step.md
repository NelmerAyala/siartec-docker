# Create Dockerfile with:

FROM postgres
ENV POSTGRES_PASSWORD passworddb
ENV POSTGRES_DB namedb
COPY script.sql /docker-entrypoint-initdb.d/

    note: script.sql file debe estar en la raiz de donde se está posiicionado

# Create image:

docker build -t emblem-db ./

# View images:

docker images -a

# Create container:

docker run -d --name emblem-db-container -p 5433:5432 emblem-db

# Create tag image:

docker tag emblem-db:latest emblem-db:staging

# Generate backup (postgresql)

- command:
  pg_dump -U usuario -W -h host basename > basename.sql

  . -U => Se refiere al Usuario, en este caso puede ser el usuario propietario de la base de datos o el usuario postgres
  . -W => Con este parámetro conseguiremos que nos solicite el password del usuario antes especificado
  . -h => Con este indicamos cuál es el servidor PostgreSQL al que nos conectaremos para obtener nuestro dump, si estamos local podemos colocar localhost sino ponemos la IP del servidor PostgreSQL
  . basename => Este es el ultimo parámetro realmente en esta linea de comando, por esa razon no tiene alguna letra que indique que el siguiente parámetro es el nombre de la base de datos
  . > basename.sql => Esta parte en realidad solo indica que la salida de nuestro comando pg_dump la guarde en un archivo basename.sql

# Restores Backup (Postgresql)

- command:
  psql -U username -W -h host basename < basename.sql

# Create user to app

- ## Add in file .sql :

`--
  -- Name: siartecapp; Type: USER;
  --
  CREATE USER siartecapp WITH ENCRYPTED PASSWORD '514RT3C';
  GRANT ALL PRIVILEGES ON DATABASE siartec TO siartecapp;
`

# Note: the username, password and db name must be the same as those in the backend .env file

<!-- Dentro de directorio Postgres configurar -->

C:\Program Files\PostgreSQL\15\data
./var/lib/postgresql/data/pg_hba.conf

- abri archivo _pg_hba.conf_ y configurar la ip del servidor:
  host all all 192.168.250.12/32 scram-sha-256
