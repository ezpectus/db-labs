# MyWork — лабораторні роботи з БД

**Степаненко Денис, ІМ-051**
**НТУУ «КПІ ім. Ігоря Сікорського», ФІОТ**

Проєкт: **VideoHub** — відеохостинг-платформа (аналог YouTube).
Вихідний код: [https://github.com/ezpectus/VideoHub](https://github.com/ezpectus/VideoHub)

БД: користувачі, відео, коментарі, лайки, підписки.
Технології: PostgreSQL, SQL, Prisma ORM.

## Лаби

| Лаба | Тема | Статус |
|------|------|--------|
| Lab_1 | Концептуальна модель БД (ER-діаграма) | ✅ |
| Lab_2 | DDL: CREATE TABLE, INSERT | ✅ |
| Lab_3 | OLTP: SELECT, INSERT, UPDATE, DELETE | ✅ |
| Lab_4 | OLAP: JOIN, агрегація, GROUP BY, HAVING | ✅ |
| Lab_5 | Нормалізація (1NF–3NF) | ✅ |
| Lab_6 | Міграції схем (Prisma ORM) | ✅ |

## Структура кожної лаби

```
Lab_N/
├── tasks.md          — завдання лабораторної
├── report_labN.md    — звіт у Markdown
├── report_labN.pdf   — PDF звіт
├── screenshots/      — скріншоти з pgAdmin/Prisma
├── *.sql             — SQL-запити (Lab 2-5)
└── *.prisma          — Prisma схема (Lab 6)
```
