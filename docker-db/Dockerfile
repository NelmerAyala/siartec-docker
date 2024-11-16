FROM postgres:16.4-alpine3.20

ENV POSTGRES_DB siartec
ENV POSTGRES_PASSWORD administrator

COPY cron_jobs /cron_jobs
COPY logs /logs 
COPY siartec.sql /docker-entrypoint-initdb.d/