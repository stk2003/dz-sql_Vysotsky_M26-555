-- Высоцкий Константин Сергеевич
-- Вариант 19 (18 % 26 + 1 = 19)
-- Условия задания: заполнить таблицы, созданные в рамках домашнего задания к практическому занятию 1,
-- не менее чем 5-ю осмысленными записями, данные взять из аналогичных систем в реальной жизни.
-- 1) Выберите автомобили (все поля таблицы), зарегистрированные в московском регионе.
-- 2) Выберите для каждого автомобиля (госномер) число заказов, в которых он участвовал,
--    кроме автомобилей с нулевым числом заказов.

CREATE TABLE cars (
    car_plate VARCHAR(12) NOT NULL PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    car_class VARCHAR(10) NOT NULL CHECK (car_class IN ('бизнес', 'эконом')),
    color VARCHAR(30) NOT NULL,
    production_year INTEGER NOT NULL CHECK (production_year BETWEEN 1900 AND 2026)
);

CREATE TABLE drivers (
    inn CHAR(12) NOT NULL PRIMARY KEY,
    surname VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    birth_date DATE NOT NULL,
    passport_series CHAR(4) NOT NULL,
    passport_number CHAR(6) NOT NULL,
    car_plate VARCHAR(12) NOT NULL,
    CONSTRAINT uq_driver_passport UNIQUE (passport_series, passport_number),
    CONSTRAINT fk_driver_car FOREIGN KEY (car_plate) REFERENCES cars (car_plate)
);

CREATE TABLE tariffs (
    tariff_id INTEGER NOT NULL PRIMARY KEY,
    tariff_name VARCHAR(50) NOT NULL,
    day_time VARCHAR(5) NOT NULL CHECK (day_time IN ('день', 'ночь')),
    distance_zone VARCHAR(20) NOT NULL CHECK (distance_zone IN ('в пределах МКАД', 'за МКАД', 'Подмосковье')),
    price_per_km DECIMAL(10, 2) NOT NULL CHECK (price_per_km > 0),
    CONSTRAINT uq_tariff UNIQUE (tariff_name, day_time, distance_zone)
);

CREATE TABLE orders (
    order_id INTEGER NOT NULL PRIMARY KEY,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    pickup_address VARCHAR(200) NOT NULL,
    destination_address VARCHAR(200) NOT NULL,
    passenger_count INTEGER NOT NULL CHECK (passenger_count > 0),
    estimated_length DECIMAL(10, 2) NOT NULL CHECK (estimated_length > 0),
    inn CHAR(12) NOT NULL,
    CONSTRAINT fk_order_driver FOREIGN KEY (inn) REFERENCES drivers (inn)
);

CREATE TABLE payments (
    order_id INTEGER NOT NULL,
    tariff_id INTEGER NOT NULL,
    mileage DECIMAL(10, 2) NOT NULL CHECK (mileage >= 0),
    cost DECIMAL(10, 2) NOT NULL CHECK (cost >= 0),
    CONSTRAINT pk_payments PRIMARY KEY (order_id, tariff_id),
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders (order_id),
    CONSTRAINT fk_payment_tariff FOREIGN KEY (tariff_id) REFERENCES tariffs (tariff_id)
);

INSERT INTO cars (car_plate, brand, car_class, color, production_year) VALUES
('А123ВС77', 'Hyundai Solaris', 'эконом', 'белый', 2020),
('В456ТМ97', 'Kia Rio', 'эконом', 'серый', 2019),
('Е789КН99', 'Toyota Camry', 'бизнес', 'чёрный', 2021),
('М321ОР177', 'Skoda Octavia', 'эконом', 'серебристый', 2022),
('Т654АХ197', 'Mercedes-Benz E-Class', 'бизнес', 'чёрный', 2018),
('Р111ГК78', 'Volkswagen Polo', 'эконом', 'синий', 2017),
('У222МВ02', 'Renault Logan', 'эконом', 'белый', 2016);

INSERT INTO drivers (inn, surname, first_name, patronymic, birth_date, passport_series, passport_number, car_plate) VALUES
('770000000001', 'Иванов', 'Иван', 'Иванович', '1988-04-12', '4510', '123456', 'А123ВС77'),
('770000000002', 'Петров', 'Пётр', 'Петрович', '1990-07-23', '4511', '234567', 'В456ТМ97'),
('770000000003', 'Сидоров', 'Алексей', 'Сергеевич', '1985-11-05', '4512', '345678', 'Е789КН99'),
('770000000004', 'Кузнецов', 'Дмитрий', 'Андреевич', '1992-02-14', '4513', '456789', 'М321ОР177'),
('770000000005', 'Смирнов', 'Михаил', 'Викторович', '1979-09-30', '4514', '567890', 'Т654АХ197'),
('780000000006', 'Волков', 'Артём', 'Игоревич', '1995-01-18', '6315', '678901', 'Р111ГК78'),
('020000000007', 'Хайруллин', 'Ринат', 'Рафкатович', '1991-05-21', '8034', '789012', 'У222МВ02');

INSERT INTO tariffs (tariff_id, tariff_name, day_time, distance_zone, price_per_km) VALUES
(1, 'Эконом днём в МКАД', 'день', 'в пределах МКАД', 35.00),
(2, 'Эконом ночью в МКАД', 'ночь', 'в пределах МКАД', 45.00),
(3, 'Эконом днём за МКАД', 'день', 'за МКАД', 45.00),
(4, 'Эконом ночью за МКАД', 'ночь', 'за МКАД', 55.00),
(5, 'Бизнес днём в МКАД', 'день', 'в пределах МКАД', 100.00),
(6, 'Бизнес ночью за МКАД', 'ночь', 'за МКАД', 150.00),
(7, 'Бизнес в Подмосковье', 'день', 'Подмосковье', 90.00);

INSERT INTO orders (order_id, order_date, order_time, pickup_address, destination_address, passenger_count, estimated_length, inn) VALUES
(1, '2026-10-05', '08:30:00', 'Москва, ул. Тверская, 12', 'Москва, аэропорт Шереметьево', 1, 32.50, '770000000001'),
(2, '2026-10-05', '14:15:00', 'Москва, ул. Арбат, 20', 'Москва, Киевский вокзал', 2, 6.80, '770000000002'),
(3, '2026-10-06', '09:05:00', 'Москва, Ленинградский проспект, 30', 'Москва, ул. Тверская, 12', 1, 12.40, '770000000003'),
(4, '2026-10-06', '22:40:00', 'Москва, аэропорт Домодедово', 'Москва, ул. Пятницкая, 7', 3, 55.00, '770000000005'),
(5, '2026-10-07', '07:50:00', 'Москва, ул. Мясницкая, 24', 'Москва, Курский вокзал', 1, 4.20, '770000000001'),
(6, '2026-10-07', '16:20:00', 'Москва, ВДНХ, главный вход', 'Москва, проспект Мира, 150', 2, 9.00, '770000000004'),
(7, '2026-10-08', '11:10:00', 'Москва, Парк культуры, 1', 'Москва, ул. Большая Якиманка, 30', 1, 5.50, '770000000002'),
(8, '2026-10-08', '23:30:00', 'Химки, ул. Молодёжная, 5', 'Москва, аэропорт Шереметьево', 2, 18.00, '770000000005'),
(9, '2026-10-09', '10:00:00', 'Москва, ул. Лесная, 5', 'Москва, аэропорт Внуково', 1, 28.00, '780000000006');

INSERT INTO payments (order_id, tariff_id, mileage, cost) VALUES
(1, 1, 31.20, 1092.00),
(1, 3, 1.30, 58.50),
(2, 1, 6.80, 238.00),
(3, 5, 12.40, 1240.00),
(4, 6, 55.00, 8250.00),
(5, 1, 4.20, 147.00),
(6, 1, 9.00, 315.00),
(7, 1, 5.50, 192.50),
(8, 4, 18.00, 990.00),
(9, 3, 28.00, 1260.00);

SELECT *
FROM cars
WHERE RIGHT(car_plate, 2) IN ('77', '97', '99')
   OR RIGHT(car_plate, 3) IN ('177', '197', '199', '777', '799');

SELECT c.car_plate, COUNT(o.order_id) AS order_count
FROM cars c
JOIN drivers d ON d.car_plate = c.car_plate
JOIN orders o ON o.inn = d.inn
GROUP BY c.car_plate
HAVING COUNT(o.order_id) > 0
ORDER BY order_count DESC, c.car_plate;
