INSERT INTO chicago_taxi.census_tract
(census_tract)
SELECT DISTINCT pickup_census_tract
FROM chicago_taxi.taxi_trips_staging

UNION

SELECT DISTINCT dropoff_census_tract
FROM chicago_taxi.taxi_trips_staging

UNION

SELECT DISTINCT pickup_census_tract
FROM chicago_taxi.network_trips_staging

UNION

SELECT DISTINCT dropoff_census_tract
FROM chicago_taxi.network_trips_staging;
