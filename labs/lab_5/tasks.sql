-- 1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
-- данные в JSON(Oracle, Postgres). 

SELECT row_to_json(ms)
FROM members ms;

SELECT row_to_json(gs)
FROM groups gs;

SELECT row_to_json(als)
FROM albums als;

SELECT row_to_json(ss)
FROM songs ss;

SELECT row_to_json(ens)
FROM entertainments ens;

SELECT row_to_json(brs)
FROM brands brs;

-- 2. Выполнить загрузку и сохранение JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице
-- базы данных, созданной в первой лабораторной работе.

CREATE TABLE IF NOT EXISTS groups_copy(
    group_id INT PRIMARY KEY,
	name VARCHAR(100),
    fandom VARCHAR(100),
    founding_year INT,
    website VARCHAR(100),
    CONSTRAINT gr_year_constraint CHECK (founding_year BETWEEN 1990 AND 2022)
);

COPY (SELECT row_to_json(gs) FROM groups gs)
TO '/var/lib/postgresql/data/gs.json';

CREATE TABLE IF NOT EXISTS json_table
(
    data JSON
);

COPY json_table 
FROM '/var/lib/postgresql/data/gs.json';

INSERT INTO groups_copy
SELECT
    (data->>'group_id')::INT,
    data->>'name',
    data->>'fandom',
    (data->>'founding_year')::INT,
    data->>'website'
FROM json_table;

SELECT * 
FROM groups_copy;

-- 3. Создать таблицу, в которой будет атрибут(-ы) с типом JSON, или
-- добавить атрибут с типом JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE.

CREATE TABLE IF NOT EXISTS for_task3
(
    id int PRIMARY KEY,
    name VARCHAR(100),
    info JSON
);

INSERT INTO for_task3 VALUES
(1, 'BTS', '{"fandom": "ARMY", "color": "purple"}'),
(2, 'EXO', '{"fandom": "EXO-L", "color": "silver"}'),
(3, 'ITZY', '{"fandom": "Midzy", "color": "neon"}'),
(4, 'BlackPink', '{"fandom": "BLINK", "color": "black & pink"}');

INSERT INTO for_task3(id, name) VALUES
(5, 'aespa');

SELECT * 
FROM for_task3;

-- 4. Выполнить следующие действия:

-- 4.1 Извлечь JSON фрагмент из JSON документа

SELECT 
    name AS group_name,
    info AS fandom_name_and_color
FROM for_task3
WHERE id = 1;

-- 4.2 Извлечь значения конкретных узлов или атрибутов JSON документа

SELECT 
    name AS group_name,
    info->>'fandom' AS fandom_name,
    info->>'color' AS fandom_color
FROM for_task3;

-- 4.3 Выполнить проверку существования узла или атрибута

SELECT *
FROM for_task3
WHERE json_extract_path(info, 'color') IS NOT NULL;

-- 4.4 Изменить JSON документ

UPDATE for_task3
SET info = info::jsonb || '{"color": "green"}'::jsonb
WHERE id = 3;

-- 4.5 Разделить JSON документ на несколько строк по узлам

SELECT
    json_extract_path(info, 'fandom') fandom_name,
    json_extract_path(info, 'color') fandom_color
FROM for_task3
WHERE info IS NOT NULL;
