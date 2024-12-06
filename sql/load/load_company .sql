INSERT INTO chicago_taxi.company
(company)
SELECT DISTINCT company
FROM chicago_taxi.taxi_trips_staging;

INSERT INTO chicago_taxi.company
    (company)
VALUES ('Network Provider');