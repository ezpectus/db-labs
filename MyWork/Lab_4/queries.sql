-- ============================================
-- Lab 4: OLAP — Агрегація, GROUP BY, HAVING, JOIN
-- Проєкт: VideoHub (відеохостинг-платформа)
-- Степаненко Денис, ІМ-051
-- ============================================

-- ============================================
-- ДОДАТКОВІ ТЕСТОВІ ДАНІ ДЛЯ АНАЛІТИКИ
-- Базові дані з Lab 2 занадто рівномірні (у кожного автора
-- рівно 1 відео, у кожного відео рівно 1 коментар) —
-- агрегати та HAVING повертали б порожні результати.
-- Додаємо нерівномірність: у одного автора 3 відео,
-- в одного відео 3 коментарі, є користувач без відео.
-- ============================================

-- Новий користувач БЕЗ відео (для LEFT/FULL JOIN)
INSERT INTO "User" (id, email, username, password, google_id, avatar, banner, description) VALUES
    ('a1b2c3d4-0006-0000-0000-000000000006', 'guest@example.com', 'test_guest', 'hashed_pass_6', NULL, NULL, NULL, 'Just watching, not uploading yet.');

-- Ще 2 відео для denys_dev (тепер у нього 3 відео)
INSERT INTO "Video" (id, title, description, url, thumbnail, views, author_id) VALUES
    ('b2c3d4e5-0006-0000-0000-000000000006', 'Docker Compose in 15 Minutes', 'Quick start with Docker Compose for local dev.', 'https://cdn.videohub.com/videos/vid6.mp4', 'https://cdn.videohub.com/thumbs/vid6.jpg', 8500, 'a1b2c3d4-0001-0000-0000-000000000001'),
    ('b2c3d4e5-0007-0000-0000-000000000007', 'REST API Design Best Practices', 'How to design clean REST endpoints.', 'https://cdn.videohub.com/videos/vid7.mp4', 'https://cdn.videohub.com/thumbs/vid7.jpg', 23000, 'a1b2c3d4-0001-0000-0000-000000000001');

-- Ще 2 коментарі до першого відео (тепер у нього 3)
INSERT INTO "Comment" (id, text, user_id, video_id) VALUES
    ('c3d4e5f6-0006-0000-0000-000000000006', 'Saved me hours, thanks!', 'a1b2c3d4-0004-0000-0000-000000000004', 'b2c3d4e5-0001-0000-0000-000000000001'),
    ('c3d4e5f6-0007-0000-0000-000000000007', 'Waiting for part 2!', 'a1b2c3d4-0005-0000-0000-000000000005', 'b2c3d4e5-0001-0000-0000-000000000001');

-- Ще 3 лайки (різна кількість лайків на відео)
INSERT INTO "Like" (user_id, video_id) VALUES
    ('a1b2c3d4-0002-0000-0000-000000000002', 'b2c3d4e5-0003-0000-0000-000000000003'),
    ('a1b2c3d4-0004-0000-0000-000000000004', 'b2c3d4e5-0002-0000-0000-000000000002'),
    ('a1b2c3d4-0006-0000-0000-000000000006', 'b2c3d4e5-0001-0000-0000-000000000001');

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
