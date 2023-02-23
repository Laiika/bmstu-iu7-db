-- 1. Инструкция SELECT, использующая предикат сравнения
-- получить список альбомов, выпущенных в 2020 году
SELECT *
FROM albums
WHERE issue_year = 2020;

-- 2. Инструкция SELECT, использующая предикат BETWEEN
-- получить число айдолов (участников групп) в возрасте от 15 до 25 лет
SELECT COUNT(*) AS number_of_members
FROM members
WHERE age BETWEEN 15 AND 25;

-- 3. Инструкция SELECT, использующая предикат LIKE
-- получить список альбомов, в названии которых есть слово always
SELECT *
FROM albums 
WHERE name LIKE '%always%';

-- 4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом
-- получить список песен в жанре 'pop' из альбомов, выпущенных в 2016 году
SELECT *
FROM songs 
WHERE album_id IN (SELECT album_id
                   FROM albums
                   WHERE issue_year = 2016)
      AND genre = 'pop';

-- 5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом
-- получить список групп, в которых есть хотя бы один участник младше 15 лет
SELECT *
FROM groups AS G
WHERE EXISTS (SELECT 1
              FROM members AS M
              WHERE G.group_id = M.group_id AND M.age < 15);

-- 6. Инструкция SELECT, использующая предикат сравнения с квантором
-- получить список компаний, которые основаны позже любой компании из Кореи
SELECT *
FROM entertainments
WHERE founding_year > ALL (SELECT founding_year
                           FROM entertainments
                           WHERE country = 'Korea');

-- 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
-- получить среднее значение продаж альбомов, выпущенных в 2014 году
SELECT AVG(sales) AS average_sales
FROM albums
WHERE issue_year = 2014;

-- 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов
-- получить для каждой группы число брендов, с которыми она сотрудничает
SELECT group_id, name,
       (SELECT COUNT(*)
        FROM rel_br_gr
        WHERE group_id = groups.group_id) AS number_of_brands
FROM groups;

-- 9. Инструкция SELECT, использующая простое выражение CASE
-- выделить компании, формирующие группы
SELECT entertainment_id, name, country,
       CASE country
            WHEN 'Korea' THEN 'parent company of the groups'
            ELSE 'company to promote abroad'
       END AS type
FROM entertainments
ORDER BY type;

-- 10. Инструкция SELECT, использующая поисковое выражение CASE
-- типизация групп по поколениям
SELECT group_id, name, founding_year,
       CASE 
           WHEN founding_year > 2017 THEN '4 kpop generation'
           WHEN founding_year > 2011 THEN '3 kpop generation'
           WHEN founding_year > 2004 THEN '2 kpop generation'
           ELSE '1 kpop generation'
       END AS generation
FROM groups
ORDER BY generation;

-- 11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT
-- получить таблицу <год выпуска альбомов, количество выпущенных альбомов>
SELECT issue_year, COUNT(*) AS number_of_albums
INTO temp albums_sales
FROM albums
GROUP BY issue_year
ORDER BY issue_year;

SELECT * FROM albums_sales;
DROP TABLE albums_sales; 

-- 12. Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM
-- получить список групп, у которых есть хоть 1 альбом, продажи которого превысили 10.000.000, и число таких альбомов
SELECT G.group_id, COUNT(*) AS number_of_popular_albums
FROM groups G INNER JOIN (SELECT album_id, group_id
                          FROM albums
                          WHERE sales > 10000000) AS popular_albums ON G.group_id = popular_albums.group_id
GROUP BY G.group_id;

-- 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3
-- получить список групп, у которых есть хоть одна песня длительностью более 4.5 минут
SELECT group_id, name
FROM groups
WHERE group_id IN (SELECT DISTINCT group_id
                   FROM albums
                   WHERE album_id IN (SELECT DISTINCT album_id
                                      FROM songs
                                      WHERE duration > 4.5));

-- 14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING
-- 
SELECT G.group_id, COUNT(*) AS number_of_members
FROM groups G INNER JOIN members AS M ON G.group_id = M.group_id
GROUP BY G.group_id
ORDER BY G.group_id;


-- 15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING
-- получить все дуэты
SELECT G.group_id, COUNT(*) AS number_of_members
FROM groups G INNER JOIN members AS M ON G.group_id = M.group_id
GROUP BY G.group_id
HAVING COUNT(*) = 2
ORDER BY G.group_id;

-- 16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений
INSERT INTO members (member_id, name, surname, age, position, group_id)
VALUES (1001, 'Daehyun', 'Jeong', 18, 'vocalist', 1);

-- 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса
INSERT INTO members (member_id, name, surname, age, position, group_id)
SELECT MAX(member_id) + 1, 'Minho', 'Kim', MIN(age), 'vocalist', 1
FROM members;

-- 18. Простая инструкция UPDATE
UPDATE groups
SET name = 'EXO'
WHERE group_id = 339;

-- 19. Инструкция UPDATE со скалярным подзапросом в предложении SET
UPDATE songs
SET duration = (SELECT AVG(duration)
                FROM songs)
WHERE song_id = 95;

-- 20. Простая инструкция DELETE
DELETE FROM entertainments
WHERE country = 'Congo';

-- 21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE
-- удалить все бренды, которые не сотрудничают ни с одной группой
DELETE FROM brands 
WHERE brand_id IN (SELECT B.brand_id
                   FROM brands B LEFT JOIN rel_br_gr AS R ON B.brand_id = R.brand_id
                   WHERE R.brand_id IS NULL);

-- 22. Инструкция SELECT, использующая простое обобщенное табличное выражение
-- получить ОТВ <жанр, количество выпущенных песен>
WITH otv (genre, number_of_songs) AS (
       SELECT genre, COUNT(*) AS number_of_songs
       FROM songs
       GROUP BY genre
)

SELECT * 
FROM otv;

-- 23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение
-- для тестовой таблицы сотрудников компании получить структурное подразделение во главе с менеджером по маркетингу
CREATE TABLE employees(id INT PRIMARY KEY, name VARCHAR, post VARCHAR, m_id INT);
INSERT INTO employees (id, name, post, m_id) 
VALUES (1, 'Lee Soo Man', 'Director', NULL), (2, 'Bang Sihyuk', 'Artist Manager', 1), (3, 'Tak Young Jun', 'Marketing Manager', 1), 
(4, 'Scooter Brown', 'Information Technology Manager', 1), (5, 'Jiwon Park', 'HR', 2), (6, 'Lenzo Yun', 'Finance & Accounting Manager', 3),
(7, 'Matt Smith', 'Public Relations Manager', 3), (8, 'Lisa Jeong', 'Accountant', 6);

WITH RECURSIVE r_otv (id, name, post, m_id) AS (
       SELECT id, name, post, m_id
       FROM employees 
       WHERE id = 3 

       UNION ALL 
 
       SELECT e.id, e.name, e.post, e.m_id
       FROM employees e INNER JOIN r_otv otv ON e.m_id = otv.id
)
SELECT * FROM r_otv;
DROP TABLE employees;


-- 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
-- внутри группы определить средний, минимальный и максимальный возраст участников
SELECT name, surname, age,
       AVG(age) OVER(PARTITION BY group_id) avg_age,
       MIN(age) OVER(PARTITION BY group_id) min_age,
       MAX(age) OVER(PARTITION BY group_id) max_age,
       group_id
FROM members;

-- 25. Оконные функции для устранения дублей
CREATE TABLE test(name VARCHAR, surname VARCHAR, age INTEGER);
INSERT INTO test (name, surname, age) 
VALUES ('Daehyun', 'Jeong', 18), ('Minho', 'Kim', 22), ('Minho', 'Kim', 22), ('Daehyun', 'Jeong', 18), ('Minho', 'Kim', 22);

SELECT * FROM test;

WITH t_copy AS (DELETE FROM test RETURNING *)

INSERT INTO test (name, surname, age)
SELECT t.name, t.surname, t.age
FROM (SELECT name, surname, age, 
             ROW_NUMBER() OVER(PARTITION BY name, surname, age ORDER BY name, surname, age) num 
      FROM t_copy) AS t
WHERE num = 1;

SELECT * FROM test;
DROP TABLE test;

