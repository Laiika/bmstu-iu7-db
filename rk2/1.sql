CREATE DATABASE IF NOT EXISTS RK2;

CREATE TABLE IF NOT EXISTS cars(
    car_id INT PRIMARY KEY,
	brand VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL, 
    release_date DATE,
    registration_date DATE,

    driver_id,
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS drivers(
    driver_id INT PRIMARY KEY,
    dr_number VARCHAR(100) NOT NULL,
    phone VARCHAR(100) NOT NULL,
	fio VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS fines(
    fine_id INT PRIMARY KEY,
	fine_type VARCHAR(100) NOT NULL,
    fine_size NUMERIC,
    warning BOOLEAN
);

CREATE TABLE IF NOT EXISTS rel_dr_fine(
    id INT PRIMARY KEY,
    driver_id INT,
    fine_id INT,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (fine_id) REFERENCES fines(fine_id) ON DELETE CASCADE
);

-- cars
INSERT INTO cars 
VALUES (1, 'brand1', 'model1', '01-01-2011', '01-02-2011', 1),
        (2, 'brand2', 'model2', '01-01-2012', '01-02-2012', 1),
        (3, 'brand3', 'model3', '01-01-2013', '01-02-2013', 3),
        (4, 'brand4', 'model4', '01-01-2014', '01-02-2014', 4),
        (5, 'brand5', 'model5', '01-01-2015', '01-02-2015', 5),
        (6, 'brand5', 'model6', '01-01-2016', '01-02-2016', 6),
        (7, 'brand7', 'model7', '01-01-2017', '01-02-2017', 7),
        (8, 'brand5', 'model8', '01-01-2018', '01-02-2018', 8),
        (9, 'brand9', 'model9', '01-01-2019', '01-02-2019', 8),
        (10, 'brand10', 'model10', '01-01-2020', '01-02-2020', 9);

-- drivers
INSERT INTO drivers 
VALUES(1, '56 04 491941', '89877045701', 'fio1'),
        (2, '56 04 491942', '89877045702', 'fio2'),
        (3, '56 04 491943', '89877045703', 'fio3'),
        (4, '56 04 491944', '89877045704', 'fio4'),
        (5, '56 04 491945', '89877045705', 'fio5'),
        (6, '56 04 491946', '89877045706', 'fio6'),
        (7, '56 04 491947', '89877045707', 'fio7'),
        (8, '56 04 491948', '89877045708', 'fio8'),
        (9, '56 04 491949', '89877045709', 'fio9'),
        (10, '56 04 491940', '89877045700', 'fio10');

-- fines
INSERT INTO fines 
VALUES(1, 'type1', 50000, FALSE),
        (2, 'type2', 250000, FALSE),
        (3, 'type3', 50000, TRUE),
        (4, 'type1', 540000, FALSE),
        (5, 'type5', 30000, TRUE),
        (6, 'type6', 60000, FALSE),
        (7, 'type1', 700, FALSE),
        (8, 'type9', 50000, TRUE),
        (9, 'type9', 50000, TRUE),
        (10, 'type10', 100000, FALSE);

-- rel
INSERT INTO rel_dr_fine 
VALUES (1, 2, 1),
        (2, 1, 2),
        (3, 3, 10),
        (4, 3, 7),
        (5, 9, 9),
        (6, 9, 3),
        (7, 2, 4),
        (8, 8, 5),
        (9, 3, 3),
        (10, 6, 6);
