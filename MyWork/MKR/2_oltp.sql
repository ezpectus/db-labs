-- КР з БД, Степаненко Денис, ІМ-051, Варіант 4
-- Завдання 2 (таблиці і дані з 1_schema.sql)

-- ============================================================
-- ЗАВДАННЯ 2. OLTP запити
-- ============================================================

-- INSERT 1: реєстрація нового клієнта
INSERT INTO clients (full_name, email, phone, password_hash)
VALUES ('Софія Ткаченко', 'sofia.tkachenko@gmail.com', '+380931234567', 'hash_sofia');

-- INSERT 2: клієнт купує 2 VIP-квитки на матч "Динамо - Шахтар"
INSERT INTO purchases (client_id, event_ticket_id, quantity, total_price)
VALUES (4, 16, 2, 3600);

-- UPDATE 1: концерт The Hardkiss перенесли на день пізніше і на 21:00
UPDATE events
SET event_date = '2026-12-13', event_time = '21:00'
WHERE id = 9;

-- UPDATE 2: після продажу кількість доступних VIP-квитків на матч зменшилась
UPDATE event_tickets
SET available_count = available_count - 2
WHERE id = 16;

-- DELETE 1: клієнт повернув квитки, покупку видалено
DELETE FROM purchases
WHERE id = 20;

-- DELETE 2: видалення клієнта, який не зробив жодної покупки
DELETE FROM clients
WHERE id = 7;

-- SELECT 1: всі події на майданчику "Палац спорту"
SELECT e.name, e.event_date, e.event_time, e.event_type
FROM events e
JOIN venues v ON e.venue_id = v.id
WHERE v.name = 'Палац спорту'
ORDER BY e.event_date;

-- SELECT 2: доступні квитки на концерт "Океан Ельзи" за типом квитка
SELECT tt.name AS ticket_type, et.price, et.available_count
FROM event_tickets et
JOIN ticket_types tt ON et.ticket_type_id = tt.id
JOIN events e ON et.event_id = e.id
WHERE e.name = 'Концерт "Океан Ельзи"'
ORDER BY et.price DESC;

