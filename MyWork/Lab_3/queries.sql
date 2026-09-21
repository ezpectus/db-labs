-- ============================================
-- Lab 3: OLTP — SELECT, INSERT, UPDATE, DELETE
-- Проєкт: VideoHub (відеохостинг-платформа)
-- Степаненко Денис, ІМ-051
-- ============================================

-- ============================================
-- SELECT (Read)
-- ============================================

-- 1. Вибір усіх даних з таблиці User
SELECT * FROM "User";

-- 2. Вибір конкретних колонок з WHERE — відео з переглядами > 10000
SELECT title, views, author_id FROM "Video" WHERE views > 10000;

-- 3. Вибір з сортуванням та LIKE — користувачі з username, що містить 'a'
SELECT username, email, created_at FROM "User" WHERE username LIKE '%a%' ORDER BY created_at;

-- 4. Вибір з LIMIT — топ-3 відео за переглядами
SELECT title, views FROM "Video" ORDER BY views DESC LIMIT 3;
