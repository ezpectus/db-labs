# Лабораторні роботи з баз даних

**Студент:** Степаненко Денис  
**Група:** ІМ-051  
**НТУУ «КПІ ім. Ігоря Сікорського», ФІОТ**

Цей репозиторій містить виконання лабораторних робіт з дисципліни «Бази даних».

## Проєкт

База даних розроблена на основі реального проєкту **VideoHub** — відеохостинг-платформи (аналог YouTube).
Вихідний код проєкту: [https://github.com/ezpectus/VideoHub](https://github.com/ezpectus/VideoHub)

Схема БД: `User`, `Video`, `Comment`, `Like`, `Subscription` — 5 сутностей, 4 зв'язки.

## Структура

```
DB_labs/
├── MyWork/        — лабораторні роботи
│   ├── Lab_1/     — Концептуальна модель БД (ER-діаграма) ✅
│   ├── Lab_2/     — DDL: CREATE TABLE, INSERT ✅
│   ├── Lab_3/     — OLTP: SELECT, INSERT, UPDATE, DELETE ✅
│   ├── Lab_4/     — OLAP: JOIN, агрегація, GROUP BY, HAVING ✅
│   ├── Lab_5/     — Нормалізація (1NF–3NF)
│   ├── Lab_6/     — Міграції схем (Prisma ORM)
│   └── extras/    — Додаткові SQL-запити
├── DB_Labs/       — Офіційні завдання лабораторних (не в git)
└── DB_template/   — Темплейт оформлення (VuePress, не в git)
```

## Лабораторні

| # | Тема | Опис | Статус |
|---|------|------|--------|
| 1 | ER-діаграма | Концептуальна модель: 5 сутностей, 4 зв'язки | ✅ |
| 2 | DDL | CREATE TABLE, INSERT — фізична схема в PostgreSQL | ✅ |
| 3 | OLTP | SELECT, INSERT, UPDATE, DELETE — CRUD-операції | ✅ |
| 4 | OLAP | JOIN, GROUP BY, HAVING, агрегатні функції | ✅ |
| 5 | Нормалізація | 1NF, 2NF, 3NF — перевірка та виправлення схеми | ⬜ |
| 6 | Міграції | Prisma ORM — міграції схеми, контроль версій | ⬜ |

## Технології

- PostgreSQL
- SQL (DDL, DML, OLAP)
- Prisma ORM
- Mermaid (ER-діаграми)
