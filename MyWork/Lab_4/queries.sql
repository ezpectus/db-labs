-- ============================================
-- Lab 4: OLAP — Агрегація, GROUP BY, HAVING, JOIN
-- Проєкт: VideoHub (відеохостинг-платформа)
-- Степаненко Денис, ІМ-051
-- ============================================

-- ============================================
-- БАЗОВА АГРЕГАЦІЯ
-- ============================================

-- 1. COUNT — кількість відео на платформі
SELECT COUNT(*) AS total_videos FROM "Video";

-- 2. COUNT(DISTINCT) — кількість унікальних авторів відео
SELECT COUNT(DISTINCT author_id) AS unique_authors FROM "Video";

-- 3. SUM — сумарна кількість переглядів усіх відео
SELECT SUM(views) AS total_views FROM "Video";

-- 4. MIN / MAX — мінімальна та максимальна кількість переглядів
SELECT MIN(views) AS min_views, MAX(views) AS max_views FROM "Video";

-- 5. AVG — середня кількість переглядів
SELECT ROUND(AVG(views), 0) AS avg_views FROM "Video";

-- ============================================
-- ГРУПУВАННЯ (GROUP BY)
-- ============================================

-- 1. Кількість відео кожного автора
SELECT u.username, COUNT(v.id) AS video_count
FROM "User" u
INNER JOIN "Video" v ON u.id = v.author_id
GROUP BY u.username
ORDER BY video_count DESC;

-- 2. Сумарні перегляди за автором
SELECT u.username, SUM(v.views) AS total_views
FROM "User" u
INNER JOIN "Video" v ON u.id = v.author_id
GROUP BY u.username
ORDER BY total_views DESC;

-- 3. Кількість коментарів для кожного відео
SELECT v.title, COUNT(c.id) AS comment_count
FROM "Video" v
LEFT JOIN "Comment" c ON v.id = c.video_id
GROUP BY v.title
ORDER BY comment_count DESC;

-- ============================================
-- ФІЛЬТРУВАННЯ ГРУП (HAVING)
-- ============================================

-- 1. Автори з більш ніж 1 відео
SELECT u.username, COUNT(v.id) AS video_count
FROM "User" u
INNER JOIN "Video" v ON u.id = v.author_id
GROUP BY u.username
HAVING COUNT(v.id) > 1;

-- 2. Відео з більш ніж 1 коментарем
SELECT v.title, COUNT(c.id) AS comment_count
FROM "Video" v
INNER JOIN "Comment" c ON v.id = c.video_id
GROUP BY v.title
HAVING COUNT(c.id) > 1;

-- 3. Автори з сумарними переглядами > 20000
SELECT u.username, SUM(v.views) AS total_views
FROM "User" u
INNER JOIN "Video" v ON u.id = v.author_id
GROUP BY u.username
HAVING SUM(v.views) > 20000;

