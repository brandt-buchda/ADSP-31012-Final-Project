INSERT INTO COMPANY
(company)
SELECT DISTINCT company
FROM chicago_taxi.taxi_trips_staging;

INSERT INTO COMPANY
    (company)
VALUES
    ('Network Provider');