# Lab 4 — Агрегація, GROUP BY, HAVING, JOIN

## Завдання

Використовуючи розширену БД (додані предмети-м'ясо, кролик, сезон Осінь, більше CreatureDrop/CreatureBiome), виконати:

### Базова агрегація

1. **COUNT(DISTINCT)** — кількість типів предметів:
   ```sql
   SELECT COUNT(DISTINCT item_type) AS quantity_of_item_types FROM Item;
   ```

2. **SUM** — кількість днів у році:
   ```sql
   SELECT SUM(quantity_of_days) AS days_in_full_year FROM Season;
   ```

3. **MIN** — найменше здоров'я серед персонажів:
   ```sql
   SELECT MIN(max_health) AS lowest_health FROM GameCharacter;
   ```

4. **MAX** — найбільший розум серед персонажів:
   ```sql
   SELECT MAX(max_sanity) AS highest_sanity FROM GameCharacter;
   ```

5. **AVG з WHERE** — середній розмір стеку предметів (не Голова/Тіло/Рука):
   ```sql
   SELECT AVG(max_stack) AS average_stack_size FROM Item WHERE item_type != 'Голова' AND item_type != 'Тіло' AND item_type != 'Рука';
   ```

### Групування (GROUP BY)

1. Максимальне здоров'я за типом поведінки істот, сортування за спаданням:
   ```sql
   SELECT behaviour, MAX(health) AS health FROM Creature GROUP BY behaviour ORDER BY health DESC;
   ```

2. Кількість істот кожного типу поведінки:
   ```sql
   SELECT behaviour, COUNT(creature_id) AS creature FROM Creature GROUP BY behaviour ORDER BY creature DESC;
   ```

3. Середня поширеність біомів за типом розташування:
   ```sql
   SELECT biome_location, AVG(spread) AS average_spread FROM Biome GROUP BY biome_location;
   ```

### Фільтрування груп (HAVING)

1. Середня поширеність біомів > 10:
   ```sql
   SELECT biome_location, AVG(spread) AS average_spread FROM Biome GROUP BY biome_location HAVING AVG(spread) > 10;
   ```

2. Групування персонажів за силою атаки, середній розум < 185:
   ```sql
   SELECT strength_attack, AVG(max_sanity) AS average_characters_sanity FROM GameCharacter GROUP BY strength_attack HAVING AVG(max_sanity) < 185;
   ```

### JOIN

1. **INNER JOIN** — які істоти зустрічаються в які сезони (Creature ↔ CreatureForSeason ↔ Season).

2. **LEFT JOIN** — які предмети не зустрічаються в жодному біомі (Item LEFT JOIN ItemsInBiome WHERE biome_id IS NULL).

3. **FULL OUTER JOIN** — дані біомів та істот з їхнім зв'язком (CreatureBiome FULL OUTER JOIN Creature + Biome).

4. **CROSS JOIN** — всі можливі комбінації біомів та подій.

### Багатотаблична агрегація

1. **CROSS JOIN + AVG** — середнє здоров'я істот та середня сила атаки персонажа → кількість атак для перемоги:
   ```sql
   SELECT ROUND(AVG(c.health)::numeric, 2) AS average_creature_health,
          ROUND(AVG(gc.strength_attack)::numeric, 2) AS average_character_damage,
          ROUND((AVG(c.health) / AVG(gc.strength_attack))::numeric, 2) AS quantity_of_attacks
   FROM Creature c CROSS JOIN GameCharacter gc;
   ```

2. **INNER JOIN + WHERE + ORDER BY** — істоти з предметами 'м'ясо', прив'язані до біомів, з розрахунком кількості вбивств для повного стеку:
   ```sql
   SELECT b.biome_name, c.creature_name, cd.quantity_of_resources, i.item_name, i.max_stack,
          (i.max_stack / cd.quantity_of_resources) AS quantity_of_death_for_full_stack
   FROM CreatureBiome cb
   INNER JOIN Biome b USING (biome_id)
   INNER JOIN Creature c USING (creature_id)
   INNER JOIN CreatureDrop cd USING (creature_id)
   INNER JOIN Item i USING (item_id)
   WHERE i.item_name LIKE '%м''ясо%'
   ORDER BY b.biome_name DESC;
   ```

## Оригінал

- SQL-скрипт: `../TesliaDiana/lab4/data.sql`
- PDF-звіт: `../TesliaDiana/lab4/DB_Lab4_Teslia_Diana_IM-41.pdf`
