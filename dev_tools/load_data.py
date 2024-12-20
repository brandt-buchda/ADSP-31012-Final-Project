import pymysql

TABLES = [
    "taxi_trips_2019_raw",
    "taxi_trips_2023_raw",
    "network_trips_2019_raw",
    "network_trips_2023_raw",
    "traffic_tracker_2019_raw",
    "traffic_tracker_2023_raw",
]

def get_column_names(cursor, table_name):
    cursor.execute(f"SHOW COLUMNS FROM {table_name}")
    columns = cursor.fetchall()
    return [column[0] for column in columns]

def main():
    local = pymysql.connect(host="localhost", user="root", password="rootroot", db="chicago_taxi")
    gcp = pymysql.connect(host="35.192.134.73", user="dev", password="tt0Ibr0eb4R", db="chicago_taxi")

    try:
        for TABLE in TABLES:
            with gcp.cursor() as cursor:

                cursor.execute(
                f"""
                SELECT * 
                FROM chicago_taxi.{"sample_" + TABLE}
                """)
                samples = cursor.fetchall()

            with local.cursor() as cursor:
                cursor.execute(f"""TRUNCATE TABLE chicago_taxi.{TABLE};""")

                column_names = get_column_names(cursor, TABLE)

                placeholders = ', '.join(['%s'] * len(column_names))

                insert_sample_query = f"""
                INSERT INTO chicago_taxi.{TABLE} ({', '.join(column_names)}) 
                VALUES ({placeholders})
                """

                cursor.executemany(insert_sample_query, samples)
                local.commit()
                print(f"Loaded data into {TABLE} successfully.")

    finally:
        local.close()
        gcp.close()

if __name__ == "__main__":
    main()