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
