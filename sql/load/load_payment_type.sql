INSERT INTO chicago_taxi.payment_type
(payment_type)
SELECT
DISTINCT(payment_type)
FROM chicago_taxi.taxi_trips_staging;