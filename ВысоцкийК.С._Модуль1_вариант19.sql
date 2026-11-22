-- Высоцкий Константин Сергеевич
-- Вариант 19 (18 % 26 + 1 = 19)
-- Условия задания: описание таксопарка (автомобили, водители, тарифы, заказы, информация об оплате).
-- В одном заказе тарифы могут комбинироваться (для каждого тарифа своя информация об оплате).
-- Каждый водитель на все заказы ездит на одной и той же машине, но у разных водителей машины могут быть разными.

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
