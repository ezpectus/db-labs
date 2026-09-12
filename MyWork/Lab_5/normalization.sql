-- ============================================
-- Lab 5: Нормалізація (1NF, 2NF, 3NF)
-- Проєкт: VideoHub (відеохостинг-платформа)
-- Степаненко Денис, ІМ-051
-- ============================================

-- ============================================
-- КРОК 1: ДЕНОРМАЛІЗОВАНА СХЕМА (з проблемами)
-- ============================================

-- Денормалізована таблиця Video з порушеннями 1NF та 3NF
CREATE TABLE "VideoDenormalized" (
    id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title                   VARCHAR(255) NOT NULL,
    description             TEXT,
    url                     VARCHAR(500) NOT NULL,
    views                   INT DEFAULT 0,
    created_at              TIMESTAMP NOT NULL DEFAULT now(),
    author_id               UUID NOT NULL,
    author_username         VARCHAR(100) NOT NULL,
    author_email            VARCHAR(255) NOT NULL,
    tags                    TEXT NOT NULL,
    category_and_subcategory TEXT NOT NULL
);

-- Вставка денормалізованих даних
INSERT INTO "VideoDenormalized" (title, description, url, views, author_id, author_username, author_email, tags, category_and_subcategory) VALUES
    ('PostgreSQL Tutorial for Beginners', 'Learn PostgreSQL basics.', 'https://cdn.videohub.com/videos/vid1.mp4', 15000, 'a1b2c3d4-0001-0000-0000-000000000001', 'denys_dev', 'denys@example.com', 'postgresql,database,tutorial,beginners', 'Tech/Databases'),
    ('React Hooks Deep Dive', 'Complete guide to React Hooks.', 'https://cdn.videohub.com/videos/vid2.mp4', 25000, 'a1b2c3d4-0001-0000-0000-000000000001', 'denys_dev', 'denys@example.com', 'react,javascript,hooks,frontend', 'Tech/Programming'),
    ('Minecraft Survival Episode 1', 'Let''s play Minecraft survival.', 'https://cdn.videohub.com/videos/vid3.mp4', 50000, 'a1b2c3d4-0002-0000-0000-000000000002', 'maria_gaming', 'maria@example.com', 'minecraft,gaming,survival,letsplay', 'Gaming/Sandbox'),
    ('Italian Pasta Recipe', 'Authentic Italian pasta from scratch.', 'https://cdn.videohub.com/videos/vid4.mp4', 8000, 'a1b2c3d4-0003-0000-0000-000000000003', 'oleg_cook', 'oleg@example.com', 'cooking,italian,pasta,recipe', 'Lifestyle/Cooking'),
    ('Morning Yoga Routine', '20 minute morning yoga for beginners.', 'https://cdn.videohub.com/videos/vid5.mp4', 12000, 'a1b2c3d4-0004-0000-0000-000000000004', 'anna_fitness', 'anna@example.com', 'yoga,fitness,morning,beginners', 'Health/Yoga');

-- Перегляд денормалізованих даних
SELECT * FROM "VideoDenormalized";

-- ============================================
-- КРОК 2: АНАЛІЗ ПОРУШЕНЬ
-- ============================================

-- 1NF: tags містить кілька значень через кому — не атомарне
--       category_and_subcategory містить два значення — не атомарне
-- 3NF: author_username та author_email транзитивно залежать від author_id
--       (video_id → author_id → username, email)

-- Демонстрація проблеми 1NF: неможливо відфільтрувати за одним тегом
-- Цей запит НЕ працює правильно:
SELECT title, tags FROM "VideoDenormalized" WHERE tags LIKE '%database%';

-- Демонстрація проблеми 3NF: дублювання даних автора
-- Якщо denys_dev змінить email — треба оновити всі його відео
SELECT author_username, author_email, COUNT(*) AS video_count
FROM "VideoDenormalized"
GROUP BY author_username, author_email;

-- ============================================
-- КРОК 3: ВИПРАВЛЕННЯ — НОРМАЛІЗАЦІЯ
-- ============================================

-- 3.1. Створити таблицю Tag (справочник тегів)
CREATE TABLE "Tag" (
    id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name    VARCHAR(50) UNIQUE NOT NULL
);

-- 3.2. Створити зв'язуючу таблицю VideoTag (M:N)
CREATE TABLE "VideoTag" (
    video_id UUID NOT NULL REFERENCES "Video"(id) ON DELETE CASCADE,
    tag_id   UUID NOT NULL REFERENCES "Tag"(id) ON DELETE CASCADE,
    PRIMARY KEY (video_id, tag_id)
);

-- 3.3. Створити нормалізовану таблицю VideoNormalized
CREATE TABLE "VideoNormalized" (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    url         VARCHAR(500) NOT NULL,
    views       INT DEFAULT 0,
    created_at  TIMESTAMP NOT NULL DEFAULT now(),
    author_id   UUID NOT NULL,
    category    VARCHAR(50) NOT NULL,
    subcategory VARCHAR(50) NOT NULL
);

-- ============================================
-- КРОК 4: ALTER TABLE — ВИПРАВЛЕННЯ ДЕНОРМАЛІЗОВАНОЇ ТАБЛИЦІ
-- ============================================

-- 4.1. Додати атомарні колонки
ALTER TABLE "VideoDenormalized" ADD COLUMN category VARCHAR(50);
ALTER TABLE "VideoDenormalized" ADD COLUMN subcategory VARCHAR(50);

-- 4.2. Розбити category_and_subcategory на дві колонки
UPDATE "VideoDenormalized" 
SET category = split_part(category_and_subcategory, '/', 1),
    subcategory = split_part(category_and_subcategory, '/', 2);

-- 4.3. Видалити неатомарну колонку
ALTER TABLE "VideoDenormalized" DROP COLUMN category_and_subcategory;

-- 4.4. Видалити транзитивно-залежні колонки (3NF)
ALTER TABLE "VideoDenormalized" DROP COLUMN author_username;
ALTER TABLE "VideoDenormalized" DROP COLUMN author_email;

-- 4.5. Видалити неатомарну колонку tags (після створення Tag + VideoTag)
ALTER TABLE "VideoDenormalized" DROP COLUMN tags;

-- 4.6. Перейменувати таблицю
ALTER TABLE "VideoDenormalized" RENAME TO "VideoFixed";

-- ============================================
-- КРОК 5: ЗАПОВНЕННЯ ТАБЛИЦЬ TAG та VIDEOTAG
-- ============================================

-- Додати унікальні теги
INSERT INTO "Tag" (name) VALUES
    ('postgresql'), ('database'), ('tutorial'), ('beginners'),
    ('react'), ('javascript'), ('hooks'), ('frontend'),
    ('minecraft'), ('gaming'), ('survival'), ('letsplay'),
    ('cooking'), ('italian'), ('pasta'), ('recipe'),
    ('yoga'), ('fitness'), ('morning')
ON CONFLICT (name) DO NOTHING;

-- Додати зв'язки відео-теги (для перших 5 відео з Lab 2)
INSERT INTO "VideoTag" (video_id, tag_id)
SELECT v.id, t.id FROM "Video" v
CROSS JOIN "Tag" t
WHERE (v.title = 'PostgreSQL Tutorial for Beginners' AND t.name IN ('postgresql','database','tutorial','beginners'))
   OR (v.title = 'React Hooks Deep Dive' AND t.name IN ('react','javascript','hooks','frontend'))
   OR (v.title = 'Minecraft Survival Episode 1' AND t.name IN ('minecraft','gaming','survival','letsplay'))
   OR (v.title = 'Italian Pasta Recipe' AND t.name IN ('cooking','italian','pasta','recipe'))
   OR (v.title = 'Morning Yoga Routine' AND t.name IN ('yoga','fitness','morning','beginners'))
ON CONFLICT DO NOTHING;

-- ============================================
-- КРОК 6: ПЕРЕВІРКА ПІСЛЯ НОРМАЛІЗАЦІЇ
-- ============================================

-- Відео з тегами через JOIN (замість tags через кому)
SELECT v.title, t.name AS tag
FROM "Video" v
INNER JOIN "VideoTag" vt ON v.id = vt.video_id
INNER JOIN "Tag" t ON vt.tag_id = t.id
ORDER BY v.title, t.name;

-- Відео з категорією та підкатегорією (атомарні поля)
SELECT title, category, subcategory FROM "VideoFixed" ORDER BY title;

-- Відео з автором через JOIN (замість author_username в таблиці)
SELECT vf.title, u.username, u.email
FROM "VideoFixed" vf
INNER JOIN "User" u ON vf.author_id = u.id
ORDER BY vf.title;

-- Перевірка: немає дублювання email автора
SELECT u.username, u.email, COUNT(vf.id) AS video_count
FROM "User" u
LEFT JOIN "VideoFixed" vf ON u.id = vf.author_id
GROUP BY u.username, u.email
ORDER BY video_count DESC;

-- ============================================
-- ОЧИЩЕННЯ
-- ============================================

-- Видалити допоміжні таблиці після демонстрації
-- (розкоментувати якщо потрібно)
-- DROP TABLE IF EXISTS "VideoTag" CASCADE;
-- DROP TABLE IF EXISTS "Tag" CASCADE;
-- DROP TABLE IF EXISTS "VideoFixed" CASCADE;
-- DROP TABLE IF EXISTS "VideoNormalized" CASCADE;
