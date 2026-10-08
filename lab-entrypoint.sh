#!/bin/bash
# Запускаем cron (для дня 10) и передаём управление штатному entrypoint PostgreSQL
service cron start >/dev/null 2>&1 || cron
exec docker-entrypoint.sh "$@"
