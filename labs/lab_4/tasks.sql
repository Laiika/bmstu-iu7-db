CREATE EXTENSION IF NOT EXISTS PLPYTHON3U;

-- 1. Определяемая пользователем скалярная функция 
-- Определить, к какому поколению кпоп относится группа
CREATE OR REPLACE FUNCTION get_generation(founding_year INT) 
RETURNS VARCHAR
AS $$
    if (founding_year > 2017):
        return "4 kpop generation"
    elif (founding_year > 2011):
        return "3 kpop generation"
    elif (founding_year > 2004):
        return "2 kpop generation"
    else:
        return "1 kpop generation"
$$ LANGUAGE PLPYTHON3U;

SELECT group_id, name, founding_year, get_generation(founding_year) AS generation
FROM groups;

-- 2. Пользовательская агрегатная функция 
-- Получить прибыль с альбомов
CREATE OR REPLACE FUNCTION get_sum_price(a BIGINT, pr INT, b BIGINT) 
RETURNS BIGINT 
AS $$
    return a + pr * b
$$ LANGUAGE PLPYTHON3U;

CREATE AGGREGATE get_sum_price_agr(INT, BIGINT)
(
    initcond = 0,
    stype = BIGINT,
    sfunc = get_sum_price
);

SELECT get_sum_price_agr(price, sales)
FROM albums
WHERE group_id = 33;

-- 3. Определяемая пользователем табличная функция
-- Получить список участников группы 
CREATE OR REPLACE FUNCTION get_members(group_id INT)
RETURNS TABLE (member_id INT, name VARCHAR, surname VARCHAR, age INT)
AS $$
    plan = plpy.prepare("SELECT member_id, name, surname, age FROM members WHERE group_id = $1", ["int"])
    res = plpy.execute(plan, [group_id])
    res_table = []
    if res is not None:
        for row in res:
            res_table.append(row)
    return res_table
$$ LANGUAGE PLPYTHON3U;

SELECT * 
FROM get_members(3);

-- 4. Хранимая процедура
-- Обновить позицию участника в группе
CREATE OR REPLACE PROCEDURE update_member_pos(member_id INT, pos VARCHAR) 
AS $$
    plan = plpy.prepare("UPDATE members SET position = $1 WHERE member_id = $2", ["varchar", "int"])
    plpy.execute(plan, [pos, member_id])
$$ LANGUAGE PLPYTHON3U;

SELECT * 
FROM members
WHERE member_id = 1003;

CALL update_member_pos(1003, 'sub-vocalist');

SELECT * 
FROM members
WHERE member_id = 1003;

-- 5. Триггер
-- Триггер на добавление в таблицу брендов
CREATE OR REPLACE FUNCTION insert_brands()
RETURNS TRIGGER
AS $$
    plpy.notice("Information added in table brands")
    plpy.notice(f"brand_id = {TD['new']['brand_id']}, name = {TD['new']['name']}")
$$ LANGUAGE PLPYTHON3U;

DROP TRIGGER IF EXISTS brs_insert_tr ON brands;

CREATE TRIGGER brs_insert_tr
AFTER INSERT ON brands 
FOR EACH ROW
EXECUTE FUNCTION insert_brands();

INSERT INTO brands
SELECT MAX(brand_id) + 1, 'Dior', 1946, 'Christian Dior'
FROM brands;

-- 6. Определяемый пользователем тип данных
-- Получить число участников в каждой группе, основанной в указанный год
DROP TYPE IF EXISTS group_members_num;
CREATE TYPE group_members_num as
(
    group_id INT,
    num_of_members INT
);

CREATE OR REPLACE FUNCTION groups_mems_cnt(f_year INT)
RETURNS SETOF group_members_num
AS $$
    query = '''
    SELECT g.group_id, COUNT(*) AS num_of_members
    FROM groups g JOIN members m ON g.group_id = m.group_id 
    WHERE founding_year = $1
    GROUP BY g.group_id
    ORDER BY g.group_id;
    '''
    plan = plpy.prepare(query, ["int"])
    res = plpy.execute(plan, [f_year])
    if res is not None:
        return res
$$ language plpython3u;

SELECT * 
FROM groups_mems_cnt(2013);