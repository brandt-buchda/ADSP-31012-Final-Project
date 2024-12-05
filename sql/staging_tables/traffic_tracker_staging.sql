DROP TABLE IF EXISTS chicago_taxi.traffic_tracker_staging;

CREATE TABLE IF NOT EXISTS chicago_taxi.traffic_tracker_staging (
    traffic_id INT AUTO_INCREMENT,
    time DATETIME NULL,
    region_id TINYINT NULL,
    speed DECIMAL(5,2) NULL,
    region VARCHAR(127),
    bus_count SMALLINT UNSIGNED NULL,
    num_reads SMALLINT UNSIGNED NULL,
    hour TINYINT UNSIGNED NULL,
    day_of_week TINYINT UNSIGNED NULL,
    month TINYINT UNSIGNED NULL,
    description VARCHAR(255),
    record_id CHAR(15) NULL,
    west DECIMAL(11,9) NULL,
    east DECIMAL(11,9) NULL,
    south DECIMAL(11,9) NULL,
    north DECIMAL(11,9) NULL,
    nw_location POINT NULL,
    se_location POINT NULL,
    row_id INT,
    PRIMARY KEY(traffic_id)
);