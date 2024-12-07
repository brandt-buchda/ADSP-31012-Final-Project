# COMPLETE!
DROP TABLE IF EXISTS chicago_taxi.company_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.company_mart (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company VARCHAR(64) UNIQUE
);

# COMPLETE!
DROP TABLE IF EXISTS chicago_taxi.taxi_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.taxi_mart (
    taxi_id INT PRIMARY KEY AUTO_INCREMENT,
    taxi_id_original BINARY(64) UNIQUE
);

# COMPLETE!
DROP TABLE IF EXISTS chicago_taxi.location_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.location_mart (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    longitude DECIMAL(11,9),
    latitude DECIMAL(11,9),
    location POINT
);

# COMPLETE!
DROP TABLE IF EXISTS chicago_taxi.payment_type_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.payment_type_mart (
    payment_type_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_type VARCHAR(32) UNIQUE
);

# COMPLETE!
DROP TABLE IF EXISTS chicago_taxi.census_tract_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.census_tract_mart (
    census_tract_id INT PRIMARY KEY AUTO_INCREMENT,
    census_tract CHAR(11)
);

# COMPLETE!
DROP TABLE IF EXISTS chicago_taxi.traffic_region_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.traffic_region_mart (
    region_id INT PRIMARY KEY,
    region VARCHAR(64),
    description TEXT,
    nw_location_id INT,
    se_location_id INT,
    FOREIGN KEY (nw_location_id) REFERENCES location_mart(location_id),
    FOREIGN KEY (se_location_id) REFERENCES location_mart(location_id)
);

# Joshua
DROP TABLE IF EXISTS chicago_taxi.traffic_congestion_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.traffic_congestion_mart (
    congestion_id INT PRIMARY KEY AUTO_INCREMENT,
    time DATETIME,
    region_id INT,
    speed_percent DECIMAL(5,2),
    bus_count INT,
    hour INT,
    day_of_week INT,
    month INT,
    FOREIGN KEY (region_id) REFERENCES traffic_region_mart(region_id)
);

# ONGOING...
DROP TABLE IF EXISTS chicago_taxi.trip_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.trip_mart (
    trip_id BINARY(20) PRIMARY KEY,
    start_timestamp DATETIME,
    end_timestamp DATETIME,
    seconds SMALLINT UNSIGNED,
    miles DECIMAL(5,2),
    fare DECIMAL(5,2) NULL,
    tips DECIMAL(5,2) NULL,
    extras DECIMAL(5,2) NULL,
    total DECIMAL(6,2),
    pickup_location_id INT,
    dropoff_location_id INT,
    company_id INT,
    taxi_id INT NULL,
    payment_type_id INT,
    FOREIGN KEY (pickup_location_id) REFERENCES location_mart(location_id),
    FOREIGN KEY (dropoff_location_id) REFERENCES location_mart(location_id),
    FOREIGN KEY (company_id) REFERENCES company_mart(company_id),
    FOREIGN KEY (taxi_id) REFERENCES taxi_mart(taxi_id),
    FOREIGN KEY (payment_type_id) REFERENCES payment_type_mart(payment_type_id)
);

# Joshua
DROP TABLE IF EXISTS chicago_taxi.trip_congestion_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.trip_congestion_mart (
    trip_id BINARY(20),
    traffic_congestion_id INT,
    PRIMARY KEY (trip_id, traffic_congestion_id),
    FOREIGN KEY (trip_id) REFERENCES trip(trip_id),
    FOREIGN KEY (traffic_congestion_id) REFERENCES traffic_congestion_mart(congestion_id)
);

# LAST
DROP TABLE IF EXISTS chicago_taxi.trip_tract_mart;
CREATE TABLE IF NOT EXISTS chicago_taxi.trip_tract_mart (
    trip_id BINARY(20),
    census_tract_id INT,
    PRIMARY KEY (trip_id, census_tract_id),
    FOREIGN KEY (trip_id) REFERENCES trip_mart(trip_id),
    FOREIGN KEY (census_tract_id) REFERENCES census_tract_mart(census_tract_id)
);
