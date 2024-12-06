INSERT INTO chicago_taxi.traffic_congestion
(time, region_id, speed_percent, bus_count, hour, day_of_week, month)
SELECT
    t.time,
    tr.region_id,
    t.speed AS speed_percent,
    t.bus_count,
    t.hour,
    t.day_of_week,
    t.month
FROM chicago_taxi.traffic_tracker_staging t
INNER JOIN chicago_taxi.location l1 ON l1.location = t.nw_location
INNER JOIN chicago_taxi.location l2 ON l2.location = t.se_location
INNER JOIN chicago_taxi.traffic_region tr
    ON l1.location_id = tr.nw_location_id
    AND l2.location_id = tr.se_location_id;