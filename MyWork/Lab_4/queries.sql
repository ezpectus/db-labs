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

