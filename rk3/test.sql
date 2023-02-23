CREATE OR REPLACE FUNCTION late_func(dt DATE) 
RETURNS TABLE(mins INT, cnt INT)
AS
$$
    SELECT EXTRACT (HOURS FROM t - '09:00:00') * 60 + EXTRACT (MINUTES FROM t - '09:00:00'), COUNT(*) AS cnt
    FROM 
    (
        SELECT employee_id, MIN(time) AS t
        FROM employee_visit
        WHERE date = dt AND type = 1
        GROUP BY employee_id
    ) AS tmp
    WHERE t > '09:00:00'
    GROUP BY t - '09:00:00'
$$LANGUAGE SQL;

SELECT * FROM late_func('2018-12-14');