# Lab 2 — DDL + наповнення даними

## Завдання

На основі концептуальної моделі з Lab 1 створити фізичну схему БД у PostgreSQL:

1. **CREATE TYPE** — створити перелічувані типи:
   - `type_behaviour` AS ENUM ('Hostile', 'Neutral', 'Passive')
   - `type_weather` AS ENUM ('Rain', 'Snow', 'Sun', 'Light')
   - `type_biome` AS ENUM ('Earth', 'Cave')

2. **CREATE TABLE** — створити всі таблиці-сутності з типами даних, PRIMARY KEY, CHECK-обмеження:
   - `Item` — item_type VARCHAR(32), max_stack BETWEEN 1 AND 40, durability BETWEEN 0 AND 100, recipe_id UNIQUE > 0, description TEXT NOT NULL UNIQUE
   - `Creature` — behaviour type_behaviour, health > 0, speed_move >= 0, speed_attack >= 0, strength_attack > 0
   - `Structures` — structure_type, structure_name, description UNIQUE
   - `Biome` — biome_location type_biome, spread BETWEEN 0.1 AND 100
   - `GameCharacter` — max_health > 0, max_hunger > 0, max_sanity > 0, speed_move >= 0, strength_attack >= 0, feature UNIQUE, description UNIQUE
   - `Events` — event_name, description UNIQUE
   - `Season` — quantity_of_days BETWEEN 1 AND 20, weather type_weather

3. **CREATE TABLE** — створити всі зв'язуючі таблиці (M:N) з FOREIGN KEY та складеними PRIMARY KEY:
   - CreatureDrop, StartItem, ItemsInBiome, CreatureForSeason, EventForSeason, SummonCreature, CreatureBiome, BiomeStructure, StructureEvent, StructureCreature
   - StructureCreature має додатковий атрибут quantity_of_creatures

4. **INSERT** — заповнити всі таблиці тестовими даними:
   - 8 предметів (шапка, желет, спис, трава, павутина, паркан, сокира, міні-робот)
   - 5 істот (павук-воїн, свин-перевертень, біфало, індик, гонча)
   - 5 структур (тулецитова стіна, місячна стіна, алхімічний двигун, скриня-пастка, обманка-лігво)
   - 3 біоми (савана, ліс, лабіринт)
   - 3 персонажі (Вілсон, WX-78, Венді)
   - 3 події (пожежа, повнолуння, дощ)
   - 3 сезони (літо, зима, весна)
   - Дані для зв'язуючих таблиць

## Оригінал

- SQL-скрипт: `../TesliaDiana/lab2/data.sql`
- PDF-звіт: `../TesliaDiana/lab2/DB_Lab2_Teslia_Diana_IM-41.pdf`
