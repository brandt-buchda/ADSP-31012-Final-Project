import pymysql

def main():
    local = pymysql.connect(host="localhost", user="root", password="rootroot", db="chicago_taxi")

    with local.cursor() as cursor:
        try:
            # Step 1: Validate rows in bulk and store valid row_ids in a temporary table
            cursor.execute("DROP TEMPORARY TABLE IF EXISTS valid_row_ids")
            cursor.execute("""
                CREATE TEMPORARY TABLE valid_row_ids AS
                SELECT row_id
                FROM taxi_trips_2019_raw
                WHERE
                    -- Validate Binary Columns
                    (trip_id IS NOT NULL AND LENGTH(trip_id) = 40 AND trip_id REGEXP '^[0-9a-fA-F]+$') AND
                    (taxi_id IS NULL OR (LENGTH(taxi_id) = 128 AND taxi_id REGEXP '^[0-9a-fA-F]+$')) AND
                
                    -- Validate Datetime Columns
                    (STR_TO_DATE(NULLIF(trip_start_timestamp, ''), '%m/%d/%Y %h:%i:%s %p') IS NOT NULL) AND
                    (STR_TO_DATE(NULLIF(trip_end_timestamp, ''), '%m/%d/%Y %h:%i:%s %p') IS NOT NULL) AND
                
                    -- Validate Numeric Columns
                    (trip_seconds IS NULL OR (trip_seconds >= 0 AND trip_seconds <= 65535)) AND
                    (trip_miles IS NULL OR (trip_miles >= 0.0 AND trip_miles <= 999.9)) AND
                    (fare IS NULL OR (fare >= 0.0 AND fare <= 999.99)) AND
                    (tips IS NULL OR (tips >= 0.0 AND tips <= 999.99)) AND
                    (tolls IS NULL OR (tolls >= 0.0 AND tolls <= 999.99)) AND
                    (extras IS NULL OR (extras >= 0.0 AND extras <= 999.99)) AND
                    (trip_total IS NULL OR (trip_total >= 0.0 AND trip_total <= 9999.99)) AND
                
                    -- Validate String Columns (with NULLIF for empty string)
                    (NULLIF(pickup_census_tract, '') IS NULL OR LENGTH(pickup_census_tract) = 11) AND
                    (NULLIF(dropoff_census_tract, '') IS NULL OR LENGTH(dropoff_census_tract) = 11) AND
                    (NULLIF(pickup_community_area, '') IS NULL OR (pickup_community_area >= 0 AND pickup_community_area <= 255)) AND
                    (NULLIF(dropoff_community_area, '') IS NULL OR (dropoff_community_area >= 0 AND dropoff_community_area <= 255)) AND
                    (NULLIF(payment_type, '') IS NULL OR LENGTH(payment_type) <= 32) AND
                    (NULLIF(company, '') IS NULL OR LENGTH(company) <= 64) AND
                
                    -- Validate Geospatial Columns
                    (pickup_centroid_location IS NULL OR
                    (NULLIF(pickup_centroid_location, '') IS NULL OR
                    (pickup_centroid_location REGEXP 'POINT (.*\\..* .*\\..*)' AND ST_IsValid(ST_GeomFromText(pickup_centroid_location))))) AND
                    (dropoff_centroid_location IS NULL OR
                    (NULLIF(dropoff_centroid_location, '') IS NULL OR
                    (dropoff_centroid_location REGEXP 'POINT (.*\\..* .*\\..*)' AND ST_IsValid(ST_GeomFromText(dropoff_centroid_location)))));
                """)

            # Step 2: Batch process valid rows
            cursor.execute("""
                INSERT INTO chicago_taxi.taxi_trips_staging
                SELECT 
                    UNHEX(trip_id),
                    UNHEX(taxi_id),
                    STR_TO_DATE(NULLIF(trip_start_timestamp, ''), '%m/%d/%Y %h:%i:%s %p'),
                    STR_TO_DATE(NULLIF(trip_end_timestamp, ''), '%m/%d/%Y %h:%i:%s %p'),
                    NULLIF(trip_seconds, ''),
                    NULLIF(trip_miles, ''),
                    NULLIF(pickup_census_tract, ''),
                    NULLIF(dropoff_census_tract, ''),
                    NULLIF(pickup_community_area, ''),
                    NULLIF(dropoff_community_area, ''),
                    NULLIF(fare, ''),
                    NULLIF(tips, ''),
                    NULLIF(tolls, ''),
                    NULLIF(extras, ''),
                    NULLIF(trip_total, ''),
                    NULLIF(payment_type, ''),
                    NULLIF(company, ''),
                    NULLIF(pickup_centroid_latitude, ''),
                    NULLIF(pickup_centroid_longitude, ''),
                    IF(pickup_centroid_location = '', NULL, ST_GeomFromText(pickup_centroid_location)),
                    NULLIF(dropoff_centroid_latitude, ''),
                    NULLIF(dropoff_centroid_longitude, ''),
                    IF(dropoff_centroid_location = '', NULL, ST_GeomFromText(dropoff_centroid_location)),
                    NULLIF(row_id, '')
                FROM taxi_trips_2019_raw
                WHERE row_id IN (SELECT row_id FROM valid_row_ids)
                """)

            # Delete the processed rows
            # rows_affected = cursor.execute("""
            #     DELETE FROM taxi_trips_2019_raw
            #     WHERE row_id IN (SELECT row_id FROM valid_row_ids)
            #     """)

            # Commit the changes
            local.commit()

        except Exception as e:
            print(f"Error: {e}")
        finally:
            local.close()


if __name__ == "__main__":
    main()