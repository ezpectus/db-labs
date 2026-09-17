# Lab 5 — Нормалізація (1NF, 2NF, 3NF)

## 🇺🇦 Українською

Перевірка схеми на відповідність **нормальним формам** та виправлення порушень «на живому»: створено навмисно денормалізовану таблицю `VideoDenormalized` (CSV-теги, склеєна категорія, дубльовані дані автора), продемонстровано аномалії, після чого схему нормалізовано — довідник `Tag` + junction-таблиця `VideoTag` (M:N) і серія `ALTER TABLE` → `VideoFixed`.

### Файли

- `normalization.sql` — денормалізована таблиця, аналіз порушень, нові таблиці, ALTER-серія, перевірка
- `tasks.md` — завдання лабораторної
- `report_lab5.md` / `report_lab5.pdf` — звіт
- `screenshots/` — скріншоти до/після в pgAdmin

---

## 🇬🇧 English

Checking the schema against **normal forms** and fixing violations live: a deliberately denormalized `VideoDenormalized` table (CSV tags, concatenated category, duplicated author data) is created, anomalies are demonstrated, then the schema is normalized — a `Tag` lookup table + `VideoTag` junction table (M:N) and a series of `ALTER TABLE` statements → `VideoFixed`.

### Files

- `normalization.sql` — denormalized table, violation analysis, new tables, ALTER sequence, verification
- `tasks.md` — lab assignment
- `report_lab5.md` / `report_lab5.pdf` — report
- `screenshots/` — before/after screenshots from pgAdmin
