DROP TABLE IF EXISTS chicago_taxi.traffic_tracker_2019_raw;

CREATE TABLE IF NOT EXISTS chicago_taxi.traffic_tracker_2019_raw (
    time VARCHAR(255) NULL,
    region_id VARCHAR(255) NULL,
    speed VARCHAR(255),
    region VARCHAR(255),
    bus_count VARCHAR(255),
    num_reads VARCHAR(255),
    hour VARCHAR(255),
    day_of_week VARCHAR(255),
    month VARCHAR(255),
    description VARCHAR(255),
    record_id VARCHAR(255),
    west VARCHAR(255),
    east VARCHAR(255),
    south VARCHAR(255),
    north VARCHAR(255),
    nw_location VARCHAR(255),
    se_location VARCHAR(255),
    row_id INT AUTO_INCREMENT,
    PRIMARY KEY(row_id)
);