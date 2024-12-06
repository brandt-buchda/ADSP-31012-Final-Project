DROP TEMPORARY TABLE IF EXISTS valid_row_ids;

CREATE TEMPORARY TABLE valid_row_ids AS
SELECT row_id
FROM traffic_tracker_2023_raw
WHERE
    -- Validate Datetime Columns
    (STR_TO_DATE(NULLIF(time, ''), '%m/%d/%Y %h:%i:%s %p') IS NOT NULL) AND

    -- Validate Numeric Columns
    (speed IS NULL OR (speed >= 0.0 AND speed <= 999.9)) AND

    -- Validate String Columns (with NULLIF for empty string)
    (NULLIF(record_id, '') IS NULL OR LENGTH(record_id) = 15) AND

    -- Validate Geospatial Columns
    ((NULLIF(TRIM(TRAILING '\r' FROM nw_location), '') IS NULL) OR
    (nw_location REGEXP 'POINT (.*\\..* .*\\..*)' AND ST_IsValid(ST_GeomFromText(nw_location)))) AND
    ((NULLIF(TRIM(TRAILING '\r' FROM se_location), '') IS NULL) OR
    (se_location REGEXP 'POINT (.*\\..* .*\\..*)' AND ST_IsValid(ST_GeomFromText(se_location))));


INSERT INTO chicago_taxi.traffic_tracker_staging
(time, region_id, speed, region, bus_count, num_reads, hour, day_of_week, month, description, record_id, west, east, south, north, nw_location, se_location, row_id)
SELECT
    STR_TO_DATE(NULLIF(time, ''), '%m/%d/%Y %h:%i:%s %p'),
    NULLIF(region_id, ''),
    NULLIF(speed, ''),
    NULLIF(region, ''),
    NULLIF(bus_count, ''),
    NULLIF(num_reads, ''),
    NULLIF(hour, ''),
    NULLIF(day_of_week, ''),
    NULLIF(month, ''),
    NULLIF(description, ''),
    NULLIF(record_id, ''),
    NULLIF(west, ''),
    NULLIF(east, ''),
    NULLIF(south, ''),
    NULLIF(north, ''),
    IF(nw_location = '', NULL, ST_GeomFromText(nw_location)),
    IF(se_location = '', NULL, ST_GeomFromText(se_location)),
    row_id
FROM traffic_tracker_2023_raw
WHERE row_id IN (SELECT row_id FROM valid_row_ids);
