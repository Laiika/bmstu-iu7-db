-- 1.1 Скалярная функция
-- Получить количество альбомов, выпущенных указанной группой за конкретный год
CREATE OR REPLACE FUNCTION count_albums(cur_group_id INT, year INT) 
RETURNS INT 
AS '
	SELECT COUNT(*) 
       FROM albums
	WHERE group_id = cur_group_id AND issue_year = year
' LANGUAGE SQL;

SELECT count_albums(125, 1995);

-- 1.2 Подставляемая табличная функция
-- Получить количество участников по группам
CREATE OR REPLACE FUNCTION count_members_in_groups() 
RETURNS TABLE (group_id INT, number_of_members INT) 
AS '
	SELECT group_id, COUNT(*) AS number_of_members
       FROM members
	GROUP BY group_id
       ORDER BY group_id
' LANGUAGE SQL;

SELECT count_members_in_groups();

-- 1.3 Многооператорная табличная функция
-- Получить все альбомы с продажами выше средних за указанный год
CREATE OR REPLACE FUNCTION popular_albums(year INT) 
RETURNS TABLE (album_id INT, name VARCHAR(100), sales BIGINT) 
AS '
DECLARE 
       avg_sales BIGINT;
BEGIN       
       SELECT AVG(al.sales) 
       INTO avg_sales
       FROM albums al
       WHERE al.issue_year = year;

       RETURN QUERY
       SELECT al.album_id, al.name, al.sales 
       FROM albums al
       WHERE al.sales > avg_sales AND al.issue_year = year;
END;
' LANGUAGE plpgsql;

SELECT *
FROM popular_albums(2015);

-- 1.4 Рекурсивная функция
-- Получить наибольший общий делитель двух чисел
CREATE OR REPLACE FUNCTION gcd(first INT, second INT)
RETURNS INT
AS '
BEGIN
       IF second = 0 THEN
              RETURN first;
       END IF;

       RETURN gcd(second, first % second);
END;
' LANGUAGE plpgsql;

SELECT *
FROM gcd(111, 259);

-- 2.1 Хранимая процедура с параметрами
-- Увеличить продажи альбома
CREATE OR REPLACE PROCEDURE inc_album_sales(id INT, new_sales INT)
AS '
BEGIN
	UPDATE albums
       SET sales = sales + new_sales
       WHERE album_id = id;
END;
' LANGUAGE plpgsql;

SELECT * 
FROM albums  
WHERE album_id = 1;

CALL inc_album_sales(1, 500000);
SELECT * 
FROM albums  
WHERE album_id = 1;

-- 2.2 Рекурсивная хранимая процедуру
-- Получить факториал числа
CREATE OR REPLACE PROCEDURE factorial(num int, INOUT res INT, start int DEFAULT 1)
AS ' 
BEGIN
       IF start = 1 THEN
              res = num;
              CALL factorial(num - 1, res, 0);
	ELSIF num > 0 THEN
		res = res * num;
		CALL factorial(num - 1, res, 0);
       ELSIF num < 0 THEN
              res = 1;
       END IF;
END; 
' LANGUAGE plpgsql;

CALL factorial(5, NULL);

-- 2.3 Хранимая процедура с курсором
-- Получить id групп, основанных в определенном году
CREATE OR REPLACE PROCEDURE group_founding_year(input_year INT)
AS '
DECLARE
	id INT;
       my_cursor CURSOR FOR 
              SELECT group_id 
              FROM groups 
              WHERE founding_year = input_year;
BEGIN
       OPEN my_cursor;
       LOOP
              FETCH my_cursor
              INTO id;
              EXIT WHEN NOT FOUND;
              RAISE NOTICE ''group id =  %'', id;
       END LOOP;
       CLOSE my_cursor;
END;
' LANGUAGE plpgsql;

CALL group_founding_year(2014);

-- 2.4 Хранимая процедура доступа к метаданным
-- Получить поля и их типы для заданной таблицы
CREATE OR REPLACE PROCEDURE get_metadata(input_table VARCHAR(100))
AS '
DECLARE
       data RECORD;
       my_cursor CURSOR FOR
              SELECT column_name, data_type, is_nullable
              FROM information_schema.columns
              WHERE table_name = input_table;
BEGIN
       OPEN my_cursor;
       LOOP
              FETCH my_cursor 
              INTO data;
              EXIT WHEN NOT FOUND;
              RAISE NOTICE ''column name = %, data type = %, is nullable = %'', data.column_name, data.data_type, data.is_nullable;
       END LOOP;
       CLOSE my_cursor;
END;
' LANGUAGE plpgsql;

CALL get_metadata('members');

-- 3.1 Триггер AFTER

-- Создание триггерной функции 
CREATE OR REPLACE FUNCTION members_insert_info() 
RETURNS TRIGGER
AS '
BEGIN
       RAISE NOTICE ''New added information in table members'';
       RAISE NOTICE ''id = %, name = %, position = %, group_id = %'', NEW.member_id, NEW.name, NEW.position, NEW.group_id;
       RETURN NEW;
END;
' LANGUAGE plpgsql;

-- Создание триггера
CREATE OR REPLACE TRIGGER mem_insert_info_tr
AFTER INSERT ON members
FOR EACH ROW
EXECUTE FUNCTION members_insert_info();

--Проверка работы триггера
INSERT
INTO members (member_id, name, surname, age, position, group_id)
SELECT MAX(member_id) + 1, 'Jisoo', 'Kim', 18, 'vocalist', 3
FROM members;

-- 3.2 Триггер INSTEAD OF

CREATE OR REPLACE VIEW members_tmp AS
SELECT * 
FROM members
WHERE group_id = 3;

-- Создание триггерной функции 
CREATE OR REPLACE FUNCTION members_delete() 
RETURNS TRIGGER
AS '
BEGIN
       RAISE EXCEPTION ''Deletion prohibited'';
       RETURN NEW;
END;
' LANGUAGE plpgsql;

-- Создание триггера
CREATE OR REPLACE TRIGGER mem_delete_tr
INSTEAD OF DELETE ON members_tmp
FOR EACH ROW
EXECUTE FUNCTION members_delete();

--Проверка работы триггера
DELETE
FROM members_tmp
WHERE member_id = 1005;

SELECT *
FROM members_tmp;

-- доп таблица, которая будет хранить количество записей в других таблицах (на insert)

SELECT relname, n_live_tup 
INTO about_tables
FROM pg_stat_user_tables 
WHERE schemaname in ('public')
ORDER BY n_live_tup DESC;

-- Создание триггерной функции 
CREATE OR REPLACE FUNCTION func_insert() 
RETURNs TRIGGER
AS '
BEGIN
       UPDATE about_tables
       SET n_live_tup = n_live_tup + 1
       WHERE relname = TG_TABLE_NAME;
		return new;
END;
' LANGUAGE plpgsql;

-- Создание триггера
CREATE OR REPLACE TRIGGER insert_in_tables
AFTER INSERT ON members
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables2
AFTER INSERT ON groups
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables3
AFTER INSERT ON albums
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables4
AFTER INSERT ON songs
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables5
AFTER INSERT ON entertainments
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables6
AFTER INSERT ON brands
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables7
AFTER INSERT ON rel_br_gr
FOR EACH ROW
EXECUTE FUNCTION func_insert();

CREATE OR REPLACE TRIGGER insert_in_tables8
AFTER INSERT ON rel_ent_gr
FOR EACH ROW
EXECUTE FUNCTION func_insert();


select *
from about_tables at2 ;

INSERT
INTO members (member_id, name, surname, age, position, group_id)
SELECT MAX(member_id) + 1, 'Jisoo', 'Kim', 18, 'vocalist', 3
FROM members;

select *
from about_tables at2 ;
