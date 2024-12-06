-- Create a temporary staging table to deduplicate locations
DROP TEMPORARY TABLE IF EXISTS temp_unique_locations;
CREATE TEMPORARY TABLE temp_unique_locations AS (
    SELECT DISTINCT pickup_centroid_location AS location,
           AVG(pickup_centroid_longitude) AS longitude,
           AVG(pickup_centroid_latitude) AS latitude
    FROM chicago_taxi.taxi_trips_staging
    WHERE pickup_centroid_location IS NOT NULL
    GROUP BY pickup_centroid_location

    UNION

    SELECT DISTINCT dropoff_centroid_location AS location,
           AVG(dropoff_centroid_longitude) AS longitude,
           AVG(dropoff_centroid_latitude) AS latitude
    FROM chicago_taxi.taxi_trips_staging
    WHERE dropoff_centroid_location IS NOT NULL
    GROUP BY dropoff_centroid_location

    UNION

    SELECT DISTINCT pickup_centroid_location AS location,
           AVG(pickup_centroid_longitude) AS longitude,
           AVG(pickup_centroid_latitude) AS latitude
    FROM chicago_taxi.network_trips_staging
    WHERE pickup_centroid_location IS NOT NULL
    GROUP BY pickup_centroid_location

    UNION

    SELECT DISTINCT dropoff_centroid_location AS location,
           AVG(dropoff_centroid_longitude) AS longitude,
           AVG(dropoff_centroid_latitude) AS latitude
    FROM chicago_taxi.network_trips_staging
    WHERE dropoff_centroid_location IS NOT NULL
    GROUP BY dropoff_centroid_location

    UNION

    SELECT DISTINCT nw_location AS location,
           AVG(west) AS longitude,
           AVG(north) AS latitude
    FROM chicago_taxi.traffic_tracker_staging
    WHERE nw_location IS NOT NULL
    GROUP BY nw_location

    UNION

    SELECT DISTINCT se_location AS location,
           AVG(east) AS longitude,
           AVG(south) AS latitude
    FROM chicago_taxi.traffic_tracker_staging
    WHERE se_location IS NOT NULL
    GROUP BY se_location
);

-- Insert or update, using a different approach
INSERT INTO chicago_taxi.location (location, longitude, latitude)
SELECT location, longitude, latitude
FROM temp_unique_locations
ON DUPLICATE KEY UPDATE
    longitude = VALUES(longitude),
    latitude = VALUES(latitude);

DELETE l1 FROM chicago_taxi.location l1
INNER JOIN chicago_taxi.location l2
WHERE
    l1.location = l2.location AND
    (
        l1.longitude IS NULL OR
        l1.latitude IS NULL OR
        (l2.longitude IS NOT NULL AND l2.latitude IS NOT NULL AND l1.location_id > l2.location_id)
    );
