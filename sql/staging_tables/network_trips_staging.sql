DROP TABLE IF EXISTS chicago_taxi.network_trips_staging;

CREATE TABLE IF NOT EXISTS chicago_taxi.network_trips_staging (
    trip_id BINARY(20),
    trip_start_timestamp DATETIME NULL,
    trip_end_timestamp DATETIME NULL,
    trip_seconds SMALLINT UNSIGNED NULL,
    trip_miles DECIMAL(5,2) UNSIGNED NULL,
    pickup_census_tract CHAR(11) NULL,
    dropoff_census_tract CHAR(11) NULL,
    pickup_community_area TINYINT UNSIGNED NULL,
    dropoff_community_area TINYINT UNSIGNED NULL,
    fare DECIMAL(5,2) UNSIGNED NULL,
    tips DECIMAL(5,2) UNSIGNED NULL,
    additional_charges DECIMAL(5,2) UNSIGNED NULL,
    trip_total DECIMAL(6,2) UNSIGNED NULL,
    pickup_centroid_latitude DECIMAL(11,9) NULL,
    pickup_centroid_longitude DECIMAL(11,9) NULL,
    pickup_centroid_location POINT NULL,
    dropoff_centroid_latitude DECIMAL(11,9) NULL,
    dropoff_centroid_longitude DECIMAL(11,9) NULL,
    dropoff_centroid_location POINT NULL,
    row_id INT,
    PRIMARY KEY(trip_id)
);
