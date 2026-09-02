# Lab 6 — Prisma ORM (міграції)

## Завдання

Використати **Prisma ORM** для роботи з нормалізованою БД з Lab 5.

### Кроки

1. **Ініціалізувати Prisma** у Node.js-проєкті:
   - `package.json` з залежностями `prisma` та `@prisma/client`
   - `prisma.config.ts` — конфігурація
   - `.env` з `DATABASE_URL` (PostgreSQL)

2. **Створити `schema.prisma`** — описати всі моделі з Lab 5:
   - generator client (prisma-client-js)
   - datasource db (postgresql, env DATABASE_URL)
   - Моделі: biome, biomestructure, characterfeature, creature, creaturebiome, creaturedrop, creatureforseason, eventforseason, events, featureskill, gamecharacter, Item, itemsinbiome, itemstypes, itemtoitemtype, itemtypefood, season, startitem, structurecreature, structureevent, structures, summoncreature
   - ENUM: type_behaviour, type_biome, type_food_characteristic, type_weather

3. **Міграція 1: add-craft-recipe-table**
   - Додати нову модель `CraftRecipe` (id, recipe_name, station_required, description)
   - Зв'язок: `Item.recipe_id` → `CraftRecipe.id` (M:1)
   - Згенерувати SQL з FOREIGN KEY-обмеженнями

4. **Міграція 2: add-recipe_id_field**
   - Видалити зайве поле `recipe_id` (старе статичне)
   - Додати нове поле `recipe_id` з зв'язком на `CraftRecipe`
   - Перейменувати `Item.item_id` → `Item.id`
   - Оновити всі FOREIGN KEY, що посилаються на Item

5. **Перевірка результатів**
   - Запуск: `npx dotenv -e ./.env -- npx prisma studio`
   - Перевірити дані в таблицях через Prisma Studio

### Модель CraftRecipe

```prisma
model CraftRecipe {
  id              Int    @id @default(autoincrement())
  recipe_name     String
  station_required Int?
  description     String?

  items           Item[] @relation("CraftRecipeItems")
}
```

### Модель Item (оновлена)

```prisma
model Item {
  id          Int     @id @default(autoincrement())
  item_name   String
  max_stack   Int
  durability  Int?
  recipe_id   Int?
  description String

  craftRecipe       CraftRecipe?     @relation("CraftRecipeItems", fields: [recipe_id], references: [id])
  creaturedrops     creaturedrop[]
  itemsInBiomes     itemsinbiome[]
  itemToItemTypes   itemtoitemtype[]
  startItems        startitem[]
  itemTypeFoods     itemtypefood[]
}
```

## Оригінал

- Prisma-проєкт: `../TesliaDiana/lab6/`
- Schema: `../TesliaDiana/lab6/prisma/schema.prisma`
- Міграції: `../TesliaDiana/lab6/prisma/migrations/`
- Notes (опис міграцій): `../TesliaDiana/lab6/notes.md`
