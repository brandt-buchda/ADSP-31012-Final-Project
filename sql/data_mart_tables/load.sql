INSERT INTO chicago_taxi.company_mart
SELECT * FROM chicago_taxi.company;

INSERT INTO chicago_taxi.taxi_mart
SELECT * FROM chicago_taxi.taxi;

INSERT INTO chicago_taxi.location_mart
SELECT * FROM chicago_taxi.location;

INSERT INTO chicago_taxi.payment_type_mart
SELECT * FROM chicago_taxi.payment_type;

INSERT INTO chicago_taxi.census_tract_mart
SELECT * FROM chicago_taxi.census_tract;

INSERT INTO chicago_taxi.traffic_region_mart
SELECT * FROM chicago_taxi.traffic_region;

INSERT INTO chicago_taxi.traffic_congestion_mart
SELECT * FROM chicago_taxi.traffic_congestion;

INSERT INTO chicago_taxi.trip_mart
SELECT *
FROM chicago_taxi.trip
WHERE RAND() <= 0.01;

# INSERT INTO chicago_taxi.trip_congestion_mart
# SELECT * FROM chicago_taxi.trip_congestion;
#
# INSERT INTO chicago_taxi.trip_tract_mart
# SELECT * FROM chicago_taxi.trip_tract;