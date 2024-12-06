INSERT INTO chicago_taxi.taxi
(taxi_id_original)
SELECT DISTINCT(taxi_id)
FROM chicago_taxi.taxi_trips_staging