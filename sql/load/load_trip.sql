# Insert from Taxi Trips
INSERT INTO chicago_taxi.trip
SELECT
    trip_id,
    trip_start_timestamp,
    trip_end_timestamp,
    trip_seconds,
    trip_miles,
    fare,
    tips,
    extras + tolls,
    trip_total,
    l1.location_id as pickup_location_id,
    l2.location_id as dropoff_location_id,
    c.company_id,
    ta.taxi_id,
    p.payment_type_id
FROM chicago_taxi.taxi_trips_staging t
INNER JOIN chicago_taxi.location l1 ON t.pickup_centroid_location = l1.location
INNER JOIN chicago_taxi.location l2 ON t.dropoff_centroid_location = l2.location
INNER JOIN chicago_taxi.company c ON t.company = c.company
INNER JOIN chicago_taxi.taxi ta on ta.taxi_id_original = t.taxi_id
INNER JOIN chicago_taxi.payment_type p ON t.payment_type = p.payment_type;

# Insert from Network Provider Trips
INSERT INTO chicago_taxi.trip
SELECT
    trip_id,
    trip_start_timestamp,
    trip_end_timestamp,
    trip_seconds,
    trip_miles,
    fare,
    tips,
    additional_charges,
    trip_total,
    l1.location_id as pickup_location_id,
    l2.location_id as dropoff_location_id,
    c.company_id,
    NULL as taxi_id,
    p.payment_type_id
FROM chicago_taxi.network_trips_staging t
INNER JOIN chicago_taxi.location l1 ON t.pickup_centroid_location = l1.location
INNER JOIN chicago_taxi.location l2 ON t.dropoff_centroid_location = l2.location
INNER JOIN chicago_taxi.company c ON c.company = 'Network Provider'
INNER JOIN chicago_taxi.payment_type p ON p.payment_type = 'Mobile';

