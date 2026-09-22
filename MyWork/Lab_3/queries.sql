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

-- ============================================
-- INSERT (Create)
-- ============================================

-- 1. Додати нового користувача
INSERT INTO "User" (email, username, password, description)
VALUES ('kate@example.com', 'kate_art', 'hashed_pass_6', 'Digital artist sharing creative process.');

-- Перевірка
SELECT * FROM "User" WHERE username = 'kate_art';

-- 2. Додати нове відео (author_id — користувач kate_art)
INSERT INTO "Video" (title, description, url, thumbnail, views, author_id)
VALUES (
    'Digital Painting Tutorial — Procreate',
    'Step by step digital painting in Procreate.',
    'https://cdn.videohub.com/videos/vid6.mp4',
    'https://cdn.videohub.com/thumbs/vid6.jpg',
    0,
    (SELECT id FROM "User" WHERE username = 'kate_art')
);

-- Перевірка
SELECT * FROM "Video" WHERE title = 'Digital Painting Tutorial — Procreate';

-- 3. Додати новий коментар
INSERT INTO "Comment" (text, user_id, video_id)
VALUES (
    'Amazing tutorial, learned so much!',
    (SELECT id FROM "User" WHERE username = 'denys_dev'),
    (SELECT id FROM "Video" WHERE title = 'Digital Painting Tutorial — Procreate')
);

-- Перевірка
SELECT * FROM "Comment" WHERE text = 'Amazing tutorial, learned so much!';
