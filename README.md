# Стенд

## Требования

Docker Desktop (Windows/macOS) или Docker Engine + compose plugin (Linux). ~2 ГБ места.

## Запуск

    docker compose up -d --build
    docker compose ps

Первый запуск занимает 2-3 минуты (создаётся база на ~500 тыс. строк).

| Что                | Адрес / параметры                                                              |
| ------------------ | ------------------------------------------------------------------------------ |
| PostgreSQL         | localhost:5432, БД `college`, пользователь `postgres`, пароль из `.env`        |
| pgAdmin            | http://localhost:8080 (логин/пароль из `.env`); сервер добавлять с хостом `db` |
| psql               | `docker compose exec -u postgres db psql -d college`                           |
| Shell в контейнере | `docker compose exec db bash`                                                  |

## Что уже настроено

- Учебная БД `college`: groups, students, subjects, grades (500 тыс. строк, **без индексов** — день 9).
- Роли для работы не созданы.
- Включены `wal_level=replica`, `archive_mode` (WAL в /archive).
- Подключены pg_stat_statements, pgcrypto, pg_cron; лог запросов дольше 500 мс.
- В контейнере работает cron (`crontab -u postgres -e`), бэкапы пишите в /backups.
- Роль `replicator` и правило в pg_hba.conf готовы.

## Сброс стенда в исходное состояние

    docker compose --profile replica down -v
    docker compose up -d --build
