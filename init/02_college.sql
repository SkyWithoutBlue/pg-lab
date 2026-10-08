-- Учебная база "college". Намеренно: без индексов на grades (для дня 9) и без ролей (для дня 5).
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_cron;

CREATE TABLE groups (
    group_id   serial PRIMARY KEY,
    name       varchar(20) NOT NULL UNIQUE,
    year_start int NOT NULL
);

CREATE TABLE students (
    student_id serial PRIMARY KEY,
    full_name  varchar(100) NOT NULL,
    birth_date date NOT NULL,
    email      varchar(100),
    group_id   int NOT NULL REFERENCES groups(group_id)
);

CREATE TABLE subjects (
    subject_id serial PRIMARY KEY,
    title      varchar(100) NOT NULL UNIQUE,
    hours      int NOT NULL CHECK (hours > 0)
);

CREATE TABLE grades (
    grade_id   bigserial PRIMARY KEY,
    student_id int NOT NULL REFERENCES students(student_id),
    subject_id int NOT NULL REFERENCES subjects(subject_id),
    grade      int NOT NULL CHECK (grade BETWEEN 2 AND 5),
    graded_at  date NOT NULL
);

INSERT INTO groups (name, year_start)
SELECT 'ИСП-' || (20 + g) || n, 2020 + g
FROM generate_series(1, 4) g, generate_series(1, 3) n;

INSERT INTO subjects (title, hours) VALUES
 ('Базы данных', 144), ('Программирование', 200), ('Операционные системы', 120),
 ('Сети', 110), ('Математика', 90), ('Английский язык', 80),
 ('Web-разработка', 150), ('Информационная безопасность', 100);

INSERT INTO students (full_name, birth_date, email, group_id)
SELECT 'Студент №' || i,
       date '2003-01-01' + (random() * 1500)::int,
       'student' || i || '@college.local',
       1 + (i % 12)
FROM generate_series(1, 1000) i;

-- ~500 000 оценок: хватит, чтобы медленные запросы были заметны
INSERT INTO grades (student_id, subject_id, grade, graded_at)
SELECT 1 + (random() * 999)::int,
       1 + (random() * 7)::int,
       2 + (random() * 3)::int,
       date '2024-09-01' + (random() * 700)::int
FROM generate_series(1, 500000);

ANALYZE;
