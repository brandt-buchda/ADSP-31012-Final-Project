DROP TABLE IF EXISTS chicago_taxi.taxi_trips_2023_raw;

CREATE TABLE IF NOT EXISTS chicago_taxi.taxi_trips_2023_raw (
    trip_id VARCHAR(255) NULL,
    taxi_id VARCHAR(255) NULL,
    trip_start_timestamp VARCHAR(255),
    trip_end_timestamp VARCHAR(255),
    trip_seconds VARCHAR(255),
    trip_miles VARCHAR(255),
    pickup_census_tract VARCHAR(255),
    dropoff_census_tract VARCHAR(255),
    pickup_community_area VARCHAR(255),
    dropoff_community_area VARCHAR(255),
    fare VARCHAR(255),
    tips VARCHAR(255),
    tolls VARCHAR(255),
    extras VARCHAR(255),
    trip_total VARCHAR(255),
    payment_type VARCHAR(255),
    company VARCHAR(255),
    pickup_centroid_latitude VARCHAR(255),
    pickup_centroid_longitude VARCHAR(255),
    pickup_centroid_location VARCHAR(255),
    dropoff_centroid_latitude VARCHAR(255),
    dropoff_centroid_longitude VARCHAR(255),
    dropoff_centroid_location VARCHAR(255),
    row_id INT AUTO_INCREMENT,
    PRIMARY KEY(row_id)
);