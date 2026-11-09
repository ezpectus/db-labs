-- Контрольна робота з дисципліни "Вступ до баз даних"
-- Степаненко Денис, ІМ-051
-- 09.11.2026
-- Варіант 4
-- Тема: Система продажу квитків на події

-- ============================================================
-- ЗАВДАННЯ 1. Схема бази даних
-- ============================================================
-- Сутності з ТЗ: майданчики, події, типи квитків, клієнти, покупки.
-- Ціна і кількість доступних квитків залежать від конкретної події,
-- тому винесені в окрему таблицю event_tickets (зв'язок подія-тип квитка).
-- Покупки захищені RESTRICT, щоб видалення клієнта чи пропозиції
-- не стерло історію продажів.

-- для повторного запуску файлу
DROP TABLE IF EXISTS purchases, event_tickets, clients, events, ticket_types, venues CASCADE;

CREATE TABLE venues (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(120) NOT NULL,
    location    VARCHAR(200) NOT NULL,
    capacity    INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE events (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    event_date  DATE NOT NULL,
    event_time  TIME NOT NULL,
    event_type  VARCHAR(50) NOT NULL,
    venue_id    INT NOT NULL REFERENCES venues(id) ON DELETE RESTRICT
);

CREATE TABLE ticket_types (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE event_tickets (
    id              SERIAL PRIMARY KEY,
    event_id        INT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    ticket_type_id  INT NOT NULL REFERENCES ticket_types(id) ON DELETE RESTRICT,
    price           NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    available_count INT NOT NULL CHECK (available_count >= 0),
    UNIQUE (event_id, ticket_type_id)
);

CREATE TABLE clients (
    id            SERIAL PRIMARY KEY,
    full_name     VARCHAR(120) NOT NULL,
    email         VARCHAR(120) NOT NULL UNIQUE,
    phone         VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    registered_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE purchases (
    id              SERIAL PRIMARY KEY,
    client_id       INT NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
    event_ticket_id INT NOT NULL REFERENCES event_tickets(id) ON DELETE RESTRICT,
    purchase_date   TIMESTAMPTZ NOT NULL DEFAULT now(),
    quantity        INT NOT NULL CHECK (quantity > 0),
    total_price     NUMERIC(10, 2) NOT NULL CHECK (total_price >= 0)
);

-- ============================================================
-- Тестові дані
-- ============================================================

INSERT INTO venues (name, location, capacity) VALUES
    ('НСК "Олімпійський"', 'Київ, вул. Велика Васильківська, 55', 70050),
    ('Палац спорту', 'Київ, пл. Спортивна, 1', 10000),
    ('Національна опера України', 'Київ, вул. Володимирська, 50', 1650),
    ('Атлас', 'Київ, вул. Січових Стрільців, 37-41', 1500);

INSERT INTO events (name, event_date, event_time, event_type, venue_id) VALUES
    ('Концерт "Океан Ельзи"', '2026-12-05', '19:00', 'Концерт', 1),
    ('Світлана Тарабарова', '2026-11-20', '19:00', 'Концерт', 4),
    ('Бумбокс', '2026-11-20', '20:00', 'Концерт', 2),
    ('Вистава "Лісова пісня"', '2026-11-20', '18:00', 'Театр', 3),
    ('Вистава "Наталка Полтавка"', '2026-12-10', '18:30', 'Театр', 3),
    ('Динамо - Шахтар', '2026-11-25', '19:00', 'Спорт', 1),
    ('Фінал Кубка з баскетболу', '2026-12-01', '17:00', 'Спорт', 2),
    ('Вечір стендапу', '2026-11-28', '20:00', 'Стендап', 4),
    ('The Hardkiss', '2026-12-12', '20:00', 'Концерт', 4),
    ('Скрябін. Трибют-концерт', '2026-12-15', '19:00', 'Концерт', 2),
    ('Льодове шоу "Казка"', '2026-12-20', '15:00', 'Шоу', 2),
    ('Симфонічний оркестр', '2026-12-22', '19:00', 'Концерт', 3);

INSERT INTO ticket_types (name) VALUES
    ('VIP'),
    ('Звичайний'),
    ('Студентський');

-- ціна і залишок квитків для кожної події по типах
INSERT INTO event_tickets (event_id, ticket_type_id, price, available_count) VALUES
    (1, 1, 2500, 299),
    (1, 2, 900, 4996),
    (1, 3, 500, 1500),
    (2, 1, 1200, 100),
    (2, 2, 600, 798),
    (2, 3, 350, 300),
    (3, 1, 1500, 200),
    (3, 2, 700, 3994),
    (3, 3, 400, 1000),
    (4, 1, 900, 148),
    (4, 2, 450, 997),
    (4, 3, 250, 298),
    (5, 1, 800, 150),
    (5, 2, 400, 998),
    (5, 3, 200, 300),
    (6, 1, 1800, 498),
    (6, 2, 350, 19994),
    (6, 3, 150, 4998),
    (7, 1, 1000, 150),
    (7, 2, 300, 2998),
    (7, 3, 120, 500),
    (8, 1, 900, 80),
    (8, 2, 500, 597),
    (9, 1, 1400, 120),
    (9, 2, 700, 698),
    (9, 3, 400, 250),
    (10, 1, 1600, 180),
    (10, 2, 750, 3496),
    (10, 3, 420, 800),
    (11, 1, 1100, 200),
    (11, 2, 550, 2497),
    (11, 3, 300, 600),
    (12, 1, 950, 118),
    (12, 2, 500, 900),
    (12, 3, 280, 250);

INSERT INTO clients (full_name, email, phone, password_hash) VALUES
    ('Денис Степаненко', 'den.stepanenko@gmail.com', '+380501112233', 'hash_den'),
    ('Ольга Коваль', 'olga.koval@gmail.com', '+380672223344', 'hash_olga'),
    ('Андрій Мельник', 'andriy.melnyk@ukr.net', '+380933334455', 'hash_andriy'),
    ('Марія Шевченко', 'maria.shev@gmail.com', '+380504445566', 'hash_maria'),
    ('Ігор Бондар', 'igor.bondar@gmail.com', '+380675556677', 'hash_igor'),
    ('Катерина Лисенко', 'katya.lysenko@ukr.net', '+380936667788', 'hash_katya'),
    ('Олександр Гнатюк', 'o.hnatyuk@gmail.com', '+380507778899', 'hash_oleks'),
    ('Назар Вовк', 'nazar.vovk@gmail.com', '+380678889900', 'hash_nazar');

INSERT INTO purchases (client_id, event_ticket_id, purchase_date, quantity, total_price) VALUES
    (1, 5,  '2026-11-01 14:30', 2, 1200),
    (1, 8,  '2026-11-01 15:10', 2, 1400),
    (2, 1,  '2026-11-02 10:15', 1, 2500),
    (2, 2,  '2026-11-02 10:15', 4, 3600),
    (3, 8,  '2026-11-03 12:40', 2, 1400),
    (3, 12, '2026-11-03 13:05', 2, 500),
    (4, 10, '2026-11-04 09:20', 2, 1800),
    (4, 11, '2026-11-04 09:20', 3, 1350),
    (5, 17, '2026-11-05 18:00', 4, 1400),
    (5, 18, '2026-11-05 18:00', 2, 300),
    (6, 20, '2026-11-05 20:30', 2, 600),
    (1, 17, '2026-11-06 11:45', 2, 700),
    (8, 23, '2026-11-06 19:10', 3, 1500),
    (2, 25, '2026-11-07 13:00', 2, 1400),
    (3, 28, '2026-11-07 16:25', 4, 3000),
    (6, 31, '2026-11-08 10:35', 3, 1650),
    (4, 33, '2026-11-08 12:50', 2, 1900),
    (5, 8,  '2026-11-09 09:15', 2, 1400),
    (8, 16, '2026-11-09 11:30', 2, 3600),
    (6, 14, '2026-11-09 14:00', 2, 800);
