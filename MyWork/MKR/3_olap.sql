-- КР з БД, Степаненко Денис, ІМ-051, Варіант 4
-- Завдання 3 (виконується після 1_schema.sql і 2_oltp.sql)

-- ============================================================
-- ЗАВДАННЯ 3. OLAP запити (аналітика)
-- ============================================================

-- 1. Загальний дохід за типом події
SELECT e.event_type, SUM(p.total_price) AS total_revenue
FROM purchases p
JOIN event_tickets et ON p.event_ticket_id = et.id
JOIN events e ON et.event_id = e.id
GROUP BY e.event_type
ORDER BY total_revenue DESC;

-- 2. Топ-10 найбільш продаваних подій (за кількістю проданих квитків)
SELECT e.name, e.event_date, SUM(p.quantity) AS tickets_sold
FROM purchases p
JOIN event_tickets et ON p.event_ticket_id = et.id
JOIN events e ON et.event_id = e.id
GROUP BY e.id, e.name, e.event_date
ORDER BY tickets_sold DESC
LIMIT 10;

-- 3. Середня ціна проданого квитка за майданчиком
SELECT v.name AS venue, ROUND(SUM(p.total_price) / SUM(p.quantity), 2) AS avg_ticket_price
FROM purchases p
JOIN event_tickets et ON p.event_ticket_id = et.id
JOIN events e ON et.event_id = e.id
JOIN venues v ON e.venue_id = v.id
GROUP BY v.id, v.name
ORDER BY avg_ticket_price DESC;

-- 4. Клієнти, які купили квитки на кілька різних подій в один і той же день
SELECT c.full_name, e.event_date, COUNT(DISTINCT e.id) AS events_count
FROM purchases p
JOIN clients c ON p.client_id = c.id
JOIN event_tickets et ON p.event_ticket_id = et.id
JOIN events e ON et.event_id = e.id
GROUP BY c.id, c.full_name, e.event_date
HAVING COUNT(DISTINCT e.id) > 1
ORDER BY e.event_date;
