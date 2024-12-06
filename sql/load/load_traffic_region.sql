INSERT IGNORE INTO chicago_taxi.traffic_region
    (region_id,
     region,
     description,
     nw_location_id,
     se_location_id)
SELECT
    region_id,
    region,
    description,
    l1.location_id as nw_location_id,
    l2.location_id as se_location_id
FROM chicago_taxi.traffic_tracker_staging t
INNER JOIN chicago_taxi.location l1 ON l1.location = t.nw_location
INNER JOIN chicago_taxi.location l2 ON l2.location = t.se_location;