CREATE TABLE IF NOT EXISTS chicago_taxi.company (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS chicago_taxi.taxi (
    taxi_id INT PRIMARY KEY AUTO_INCREMENT,
    taxi_id_original BINARY(64)
);

CREATE TABLE IF NOT EXISTS chicago_taxi.location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    longitude DECIMAL(11,9),
    latitude DECIMAL(11,9),
    location POINT
);

CREATE TABLE IF NOT EXISTS chicago_taxi.payment_type (
    payment_type_id INT PRIMARY KEY,
    payment_type VARCHAR(32)
);

CREATE TABLE IF NOT EXISTS chicago_taxi.traffic_region (
    region_id INT PRIMARY KEY,
    region VARCHAR(64),
    west_longitude DECIMAL(9,6),
    west_latitude DECIMAL(9,6),
    south_latitude DECIMAL(9,6),
    north_latitude DECIMAL(9,6),
    description TEXT,
    current_speed INT,
    mv_location POINT
);

CREATE TABLE IF NOT EXISTS chicago_taxi.census_tract (
    census_tract_id INT PRIMARY KEY,
    census_tract VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS chicago_taxi.trip (
    trip_id INT PRIMARY KEY,
    start_timestamp DATETIME,
    end_timestamp DATETIME,
    seconds INT,
    miles INT,
    fare DECIMAL(6,2),
    tips DECIMAL(6,2),
    tolls DECIMAL(6,2),
    extras DECIMAL(6,2),
    trip_total DECIMAL(7,2),
    location_id INT,
    company_id INT,
    taxi_id INT,
    payment_type_id INT,
    FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (company_id) REFERENCES company(company_id),
    FOREIGN KEY (taxi_id) REFERENCES taxi(taxi_id),
    FOREIGN KEY (payment_type_id) REFERENCES payment_type(payment_type_id)
);

CREATE TABLE IF NOT EXISTS chicago_taxi.trip_congestion (
    trip_id INT,
    traffic_congestion_id INT,
    PRIMARY KEY (trip_id, traffic_congestion_id),
    FOREIGN KEY (trip_id) REFERENCES trip(trip_id)
);

CREATE TABLE IF NOT EXISTS chicago_taxi.traffic_congestion (
    congestion_id INT PRIMARY KEY,
    time DATETIME,
    traffic_region_id INT,
    speed_percent DECIMAL(5,2),
    bus_count INT,
    hour INT,
    day_of_week INT,
    month INT,
    FOREIGN KEY (traffic_region_id) REFERENCES traffic_region(region_id)
);

CREATE TABLE IF NOT EXISTS chicago_taxi.trip_tract (
    trip_id INT,
    census_tract_id INT,
    PRIMARY KEY (trip_id, census_tract_id),
    FOREIGN KEY (trip_id) REFERENCES trip(trip_id),
    FOREIGN KEY (census_tract_id) REFERENCES census_tract(census_tract_id)
);
