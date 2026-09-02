# Lab 3 — SELECT, INSERT, UPDATE, DELETE

## Завдання

Використовуючи БД з Lab 2, виконати базові операції CRUD.

### SELECT

1. **Вибір усіх даних** з таблиці Item:
   ```sql
   SELECT * FROM Item;
   ```

2. **Вибір конкретних колонок з WHERE** — назва та опис предметів типу 'Рука':
   ```sql
   SELECT item_name, description FROM Item WHERE item_type = 'Рука';
   ```

3. **Вибір з сортуванням та LIKE** — біоми, опис яких починається на 'Біом%', відсортовані за spread:
   ```sql
   SELECT biome_name, description FROM Biome WHERE description LIKE 'Біом%' ORDER BY spread;
   ```

### INSERT

1. Додати новий предмет 'Хутро біфало' та перевірити результат SELECT-ом.
2. Додати новий сезон 'Осінь' та перевірити результат SELECT-ом.

### UPDATE

1. Змінити погоду сезону 'Осінь' на 'Rain'. До та після — SELECT для перевірки.
2. Знайти біоми зі spread BETWEEN 1 AND 9, оновити їх spread = 8. До та після — SELECT.

### DELETE

1. **Безпечне видалення**: спробувати видалити предмет 'Зрізана трава' (який має FK-зв'язок у ItemsInBiome) — отримати помилку. Потім видалити спершу запис з ItemsInBiome, а потім сам предмет.
2. Видалити предмет 'Хутро біфало' (який не має зв'язків) — просте видалення.

## Оригінал

- SQL-скрипт: `../TesliaDiana/lab3/data.sql`
- PDF-звіт: `../TesliaDiana/lab3/DB_Lab3_Teslia_Diana_IM-41.pdf`
