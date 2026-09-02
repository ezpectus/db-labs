# Lab 5 — Нормалізація (1NF, 2NF, 3NF)

## Завдання

Провести перевірку та нормалізацію БД до 3NF.

### Крок 1: Перевірка 1NF

**Правила:**
- Усі атрибути містять лише атомарні (неподільні) значення
- Відсутні повторювані групи атрибутів
- Кожен запис унікальний
- Порядок записів не важливий

**Проблема:** атрибут `feature TEXT` у `GameCharacter` містив кілька рис через кому — порушення 1NF.

**Рішення:**
- Створити таблицю `FeatureSkill` (feature_id PK, feature_skill TEXT)
- Створити зв'язуючу таблицю `CharacterFeature` (feature_id FK, character_id FK, складений PK)
- Видалити атрибут `feature` з `GameCharacter`

### Крок 2: Перевірка 2NF

**Правила:**
- Знаходиться в 1NF
- Кожен неключовий атрибут повністю функціонально залежить від первинного ключа

**Результат:** виконується для всіх таблиць.

### Крок 3: Перевірка 3NF

**Правила:**
- Знаходиться в 2NF
- Відсутні транзитивні залежності неключових атрибутів від первинного ключа

**Результат:** виконується, але таблиця `Item` потребує покращення.

### Крок 4: Виправлення таблиці Item

**Проблема:** `item_type` був єдиним VARCHAR-полем, предмети не могли мати кілька типів.

**Рішення:**
- Створити таблицю `ItemsTypes` (item_type_id PK, item_type_name VARCHAR)
- Створити зв'язуючу таблицю `ItemToItemType` (item_id FK, item_type_id FK, складений PK)
- Створити таблицю `ItemTypeFood` (item_id FK, food_characteristic ENUM, characteristic_value REAL) — для предметів-їжі з додатковими характеристиками (HUNGER, HEALTH, SANITY)
- Створити тип `type_food_characteristic` AS ENUM ('HUNGER', 'HEALTH', 'SANITY')
- Видалити `item_type` з `Item`

### Крок 5: Демонстрація денормалізації

Показати приклад порушення нормалізації:
- **Зміна #1:** об'єднати health, speed_move, speed_attack, strength_attack в одне TEXT-поле `characteristics` — порушення 1NF.
- **Зміна #2:** додати item_id, durability, quantity_of_resources в Creature — порушення 1NF та 3NF (транзитивна залежність).

### Підсумок змін схеми

| До | Після |
|----|-------|
| `GameCharacter.feature TEXT` | `FeatureSkill` + `CharacterFeature` (M:N) |
| `Item.item_type VARCHAR` | `ItemsTypes` + `ItemToItemType` (M:N) |
| — | `ItemTypeFood` (характеристики їжі) |
| ENUM: ('Hostile','Neutral','Passive') | ENUM: ('HOSTILE','NEUTRAL','PASSIVE') — верхній регістр |
| UNIQUE на description | прибрано UNIQUE з description |

## Оригінал

- SQL-скрипт (до та після нормалізації): `../TesliaDiana/lab5/data.sql`
- PDF-звіт: `../TesliaDiana/lab5/DB_Lab5_Teslia_Diana_IM-41.pdf`
