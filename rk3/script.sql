CREATE TABLE IF NOT EXISTS employee(
    id INT PRIMARY KEY,
    fio VARCHAR(100),
    date_of_birth DATE,
    department VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS employee_visit(
    id INT PRIMARY KEY,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    date DATE,
    day_of_week VARCHAR,
    time TIME,
    type INT
);

-- Работники
INSERT INTO employee
VALUES (1, 'Иванов Иван Иванович', '1990-09-25', 'ИТ');

INSERT INTO employee
VALUES (2, 'Петров Петр Петрович', '1987-11-12', 'Бухгалтерия');

-- Пришли-ушли
INSERT INTO employee_visit
VALUES (1, 1, '2018-12-14', 'Суббота', '09:00:00', 1);

INSERT INTO employee_visit
VALUES (2, 1, '2018-12-14', 'Суббота', '09:20:00', 2);

INSERT INTO employee_visit
VALUES (3, 1, '2018-12-14', 'Суббота', '09:25:00', 1);

INSERT INTO employee_visit
VALUES (4, 2, '2018-12-14', 'Суббота', '09:05:00', 1);

-- Написать табличную функцию, возвращающую на сколько и кто опоздал в определенную дату
-- Дату необходимо вводить в качестве параметра
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


--1. Найти все отделы, в которых нет сотрудников моложе 25 лет
SELECT department
FROM employee
WHERE department NOT IN 
(
    SELECT DISTINCT(department)
    FROM employee
    WHERE EXTRACT (YEARS FROM now()) - EXTRACT (YEARS FROM date_of_birth) < 25
);

--2. Найти сотрудника, который пришел сегодня на работу раньше всех
SELECT fio
FROM employee_visit ev JOIN employee e ON ev.employee_id = e.id
WHERE date = CURRENT_DATE AND type = 1 AND time = (
    SELECT MIN(time)
    FROM employee_visit
    WHERE date = CURRENT_DATE AND type = 1
);

--3. Третий запрос (SQL)
--Найти сотрудников, опоздавших не менее 5-ти раз
SELECT e.id, e.fio 
FROM employee e JOIN employee_visit ev ON ev.employee_id = e.id
WHERE ev.time > '09:00:00' AND ev.type = 1
GROUP BY e.id, e.fio 
HAVING COUNT(e.id) > 5;
