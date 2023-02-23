-- создать хранимую процедуру с выходным параметром, которая уничтожает все SQL DML триггеры (триггеры типа 'TR') в текущей базе данных
-- выходной параметр возвращает количество уничтоженных триггеров

--
CREATE OR REPLACE FUNCTION update_func()
RETURNS TRIGGER
AS $$
BEGIN
    RAISE NOTICE 'Test for update';
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER update_trigger 
BEFORE UPDATE ON drivers
FOR EACH ROW
EXECUTE FUNCTION update_func();

--
CREATE OR REPLACE FUNCTION del_triggers()
RETURNS INT
AS $$
DECLARE
    t_name RECORD;
    t_table RECORD;
    cur CURSOR FOR
        SELECT trigger_name
        FROM information_schema.triggers
        WHERE trigger_catalog = 'RK2' AND trigger_schema = 'public'
    cnt INT;
BEGIN
    cnt = 0;
    OPEN cur;
    LOOP
        FETCH cur
        INTO t_name;
        EXIT WHEN NOT FOUND;
        FOR t_table IN
            (SELECT event_object_table
            FROM information_schema.triggers
            WHERE trigger_name = t_name.trigger_name)
        LOOP
           EXECUTE 'DROP TRIGGER ' || t_name.trigger_name || ' ON ' || t_table.event_object_table || ';';
           cnt = cnt + 1;
        END LOOP;
    END LOOP;
    CLOSE cur;
    RETURN cnt;
END;
$$ LANGUAGE PLPGSQL;

SELECT del_triggers();