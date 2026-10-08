#!/bin/bash
# Восстановление на момент времени (день 8).
# Использование: pitr_restore.sh /backups/base1 "2026-10-05 12:00:00"
# Запускается в одноразовом контейнере при ОСТАНОВЛЕННОМ основном сервере.
set -euo pipefail
B="${1:?укажите каталог базовой копии}"
T="${2:?укажите время восстановления}"
D=/var/lib/postgresql/data

find "$D" -mindepth 1 -delete
tar xzf "$B/base.tar.gz" -C "$D"
mkdir -p "$D/pg_wal"
[ -f "$B/pg_wal.tar.gz" ] && tar xzf "$B/pg_wal.tar.gz" -C "$D/pg_wal"

cat >> "$D/postgresql.auto.conf" <<EOT
restore_command = 'cp /archive/%f %p'
recovery_target_time = '$T'
recovery_target_action = 'promote'
EOT
touch "$D/recovery.signal"
chmod 700 "$D"
echo "Готово. Запустите сервер: docker compose up -d db"
