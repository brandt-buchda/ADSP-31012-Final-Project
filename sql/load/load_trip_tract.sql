-- Insert from Taxi Trips (using the trip table as the main source)
INSERT INTO chicago_taxi.trip_tract (trip_id, census_tract_id)
SELECT
    t.trip_id,
    c.census_tract_id
FROM chicago_taxi.taxi_trips_staging t
INNER JOIN chicago_taxi.census_tract c
    ON c.census_tract = t.pickup_census_tract
WHERE EXISTS (SELECT 1 FROM chicago_taxi.trip tr WHERE tr.trip_id = t.trip_id)  -- Ensure the trip_id exists in the trip table
UNION
SELECT
    t.trip_id,
    c.census_tract_id
FROM chicago_taxi.taxi_trips_staging t
INNER JOIN chicago_taxi.census_tract c
    ON c.census_tract = t.dropoff_census_tract
WHERE EXISTS (SELECT 1 FROM chicago_taxi.trip tr WHERE tr.trip_id = t.trip_id);  -- Ensure the trip_id exists in the trip table

-- Insert from Network Provider Trips (using the trip table as the main source)
INSERT INTO chicago_taxi.trip_tract (trip_id, census_tract_id)
SELECT
    t.trip_id,
    c.census_tract_id
FROM chicago_taxi.network_trips_staging t
INNER JOIN chicago_taxi.census_tract c
    ON c.census_tract = t.pickup_census_tract
WHERE EXISTS (SELECT 1 FROM chicago_taxi.trip tr WHERE tr.trip_id = t.trip_id)  -- Ensure the trip_id exists in the trip table
UNION
SELECT
    t.trip_id,
    c.census_tract_id
FROM chicago_taxi.network_trips_staging t
INNER JOIN chicago_taxi.census_tract c
    ON c.census_tract = t.dropoff_census_tract
WHERE EXISTS (SELECT 1 FROM chicago_taxi.trip tr WHERE tr.trip_id = t.trip_id);  -- Ensure the trip_id exists in the trip table
