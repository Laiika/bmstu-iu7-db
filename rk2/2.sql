-- инструкция SELECT, использующая предикат сравнения
-- получить список штрафов, которые могут быть заменены на предупреждения
SELECT *
FROM fines
WHERE warning = TRUE;

-- инструкция, использующая оконную функцию
-- вывести максимальный размер штрафа для каждого типа штрафа
SELECT * 
FROM (SELECT fine_type,
      MAX(fine_size) OVER(PARTITION BY fine_type) as max_fine_size
      FROM fines) as mf
GROUP BY fine_type, max_fine_size;

-- инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM
-- получить список водителей, у которых есть хоть 1 машина, выпущенная в период с 2010 до 2015, и число таких машин
SELECT D.driver_id, COUNT(*) AS number_of_cars
FROM drivers D INNER JOIN (SELECT car_id, driver_id
                          FROM cars
                          WHERE release_date BETWEEN '01-01-2010' AND '01-01-2015') AS some_cars ON D.driver_id = some_cars.driver_id
GROUP BY D.driver_id;