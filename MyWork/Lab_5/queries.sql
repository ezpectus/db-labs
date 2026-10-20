-- ============================================
-- Lab 5: Нормалізація — аналіз 1NF/2NF/3NF
-- Проєкт: VideoHub (відеохостинг-платформа)
-- Степаненко Денис, ІМ-051
-- ============================================

-- ============================================
-- АНАЛІЗ ПОТОЧНОЇ СХЕМИ
-- ============================================

-- 1. Структура всіх таблиць: колонки та типи
SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('User', 'Video', 'Comment', 'Like', 'Subscription')
ORDER BY table_name, ordinal_position;

-- 2. Усі обмеження схеми (PK, FK, CHECK, UNIQUE)
SELECT conrelid::regclass AS table_name, conname, contype, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass::text, contype;

-- ============================================
-- ПЕРЕВІРКА 1NF — АТОМАРНІСТЬ
-- ============================================

-- 1NF: кожна комірка містить одне атомарне значення.
-- У схемі VideoHub немає списків у комірках: теги, телефони,
-- ролі зберігаються окремими таблицями/рядками, не через кому.
-- Перевірка: жодна колонка не є масивом або рядком-списком.
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND data_type IN ('ARRAY', 'text[]')
  AND table_name IN ('User', 'Video', 'Comment', 'Like', 'Subscription');
-- Очікуємо: 0 рядків — порушень 1NF немає.

-- ============================================
-- ПЕРЕВІРКА 2NF — ЧАСТКОВІ ЗАЛЕЖНОСТІ
-- ============================================

-- 2NF стосується таблиць із композитним ключем: Like(user_id, video_id)
-- та Subscription(subscriber_id, channel_id).
-- Не-ключовий атрибут цих таблиць — created_at — залежить від ПАРИ
-- (факт лайка існує саме для пари юзер+відео), а не від частини ключа.
-- Часткових залежностей немає → 2NF виконано.

-- Демонстрація: created_at має сенс лише для повної пари
SELECT user_id, video_id, created_at FROM "Like" LIMIT 3;

-- ============================================
-- ПЕРЕВІРКА 3NF — ТРАНЗИТИВНІ ЗАЛЕЖНОСТІ
-- ============================================

-- 3NF: не-ключовий атрибут не залежить від іншого не-ключового.
-- У "Video" немає author_email/author_name — тільки author_id (FK).
-- Email живе в "User" і змінюється в ОДНОМУ місці.
-- Перевірка: у Video немає колонок, що дублюють атрибути User.
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'Video'
  AND column_name LIKE 'author_%';
-- Очікуємо: лише author_id.

-- ============================================
-- ДЕНОРМАЛІЗОВАНИЙ ПРИКЛАД (ПОРУШЕННЯ 3NF)
-- ============================================

-- Створюємо таблицю з транзитивною залежністю:
-- video_id → author_id → author_email (email залежить не від
-- ключа відео, а через автора — класичне порушення 3NF)
CREATE TABLE video_stats (
    video_id     UUID PRIMARY KEY REFERENCES "Video"(id) ON DELETE CASCADE,
    title        VARCHAR(255) NOT NULL,
    views        INTEGER NOT NULL DEFAULT 0,
    author_id    UUID NOT NULL REFERENCES "User"(id),
    author_email VARCHAR(255) NOT NULL
);

-- Наповнюємо денормалізованими даними (JOIN з нормальних таблиць)
INSERT INTO video_stats (video_id, title, views, author_id, author_email)
SELECT v.id, v.title, v.views, v.author_id, u.email
FROM "Video" v
JOIN "User" u ON u.id = v.author_id;

SELECT * FROM video_stats;

-- ============================================
-- АНОМАЛІЇ ДЕНОРМАЛІЗОВАНОЇ ТАБЛИЦІ
-- ============================================

-- Аномалія ОНОВЛЕННЯ: email автора зберігається в КОЖНОМУ рядку
-- його відео. Зміна email = оновити всі рядки автора, пропустив
-- один — розсинхрон.
UPDATE video_stats SET author_email = 'new_email@example.com'
WHERE author_id = (SELECT id FROM "User" WHERE username = 'denys_dev');
-- Якби відео було 1000 — 1000 оновлень замість одного в "User".

-- Аномалія ВСТАВКИ: не можна зберегти email нового автора,
-- у якого ще немає відео (video_id — PRIMARY KEY, NOT NULL).
-- Аномалія ВИДАЛЕННЯ: видалення останнього відео автора
-- знищує і факт існування його email у цій таблиці.
DELETE FROM video_stats
WHERE author_id = (SELECT id FROM "User" WHERE username = 'max_music');

-- ============================================
-- НОРМАЛІЗАЦІЯ (ВИПРАВЛЕННЯ)
-- ============================================

-- Видаляємо денормалізовану таблицю — дані повертаються
-- до нормалізованої форми: email живе ТІЛЬКИ в "User",
-- зв'язок через author_id (FK).
DROP TABLE video_stats;

-- Нормалізований доступ: та сама інформація через JOIN —
-- email завжди актуальний, зберігається в одному місці
SELECT v.title, v.views, u.email AS author_email
FROM "Video" v
JOIN "User" u ON u.id = v.author_id;
