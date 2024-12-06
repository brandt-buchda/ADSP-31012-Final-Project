# Insert from Taxi Trips
INSERT INTO chicago_taxi.trip_tract
SELECT
    t.trip_id,
    c.census_tract_id
FROM chicago_taxi.taxi_trips_staging t
INNER JOIN chicago_taxi.census_tract c ON c.census_tract = t.pickup_census_tract OR c.census_tract = t.dropoff_census_tract;

# Insert from Network Provider Trips
INSERT INTO chicago_taxi.trip_tract
SELECT
    t.trip_id,
    c.census_tract_id
FROM chicago_taxi.network_trips_staging t
INNER JOIN chicago_taxi.census_tract c ON c.census_tract = t.pickup_census_tract OR c.census_tract = t.dropoff_census_tract;