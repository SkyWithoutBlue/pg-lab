#!/bin/bash
# Пользователь для репликации + правило в pg_hba.conf (день 11)
set -e
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d postgres <<SQL
CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD '${REPLICATOR_PASSWORD}';
SQL
echo "host replication replicator all scram-sha-256" >> "$PGDATA/pg_hba.conf"
