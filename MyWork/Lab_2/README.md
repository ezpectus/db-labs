# Lab 2 — DDL: CREATE TABLE, INSERT

## 🇺🇦 Українською

Фізична реалізація схеми з Lab 1 у **PostgreSQL**: створення 5 таблиць через `CREATE TABLE` з типами даних, сурогатними UUID-ключами (User, Video, Comment) та композитними первинними ключами для зв'язкових таблиць (`Like`, `Subscription`), зовнішніми ключами та обмеженнями (`UNIQUE`, `CHECK`, `ON DELETE CASCADE`), а також наповнення тестовими даними через `INSERT` (5 користувачів, відео, коментарі, лайки, підписки).

### Файли

- `schema.sql` — DDL-скрипт: `CREATE EXTENSION`, `CREATE TABLE`, `INSERT`
- `er_schema_old.mmd` / `er_schema_new.mmd` — діаграми схеми до/після переходу на композитні ключі
- `tasks.md` — завдання лабораторної
- `report_lab2.md` / `report_lab2.pdf` — звіт
- `screenshots/` — скріншоти виконання в pgAdmin

---

## 🇬🇧 English

Physical implementation of the Lab 1 schema in **PostgreSQL**: 5 tables created via `CREATE TABLE` with data types, UUID surrogate keys (User, Video, Comment) and composite primary keys for junction tables (`Like`, `Subscription`), foreign keys and constraints (`UNIQUE`, `CHECK`, `ON DELETE CASCADE`), plus test data inserted via `INSERT` (5 users, videos, comments, likes, subscriptions).

### Files

- `schema.sql` — DDL script: `CREATE EXTENSION`, `CREATE TABLE`, `INSERT`
- `er_schema_old.mmd` / `er_schema_new.mmd` — schema diagrams before/after composite keys
- `tasks.md` — lab assignment
- `report_lab2.md` / `report_lab2.pdf` — report
- `screenshots/` — execution screenshots from pgAdmin
