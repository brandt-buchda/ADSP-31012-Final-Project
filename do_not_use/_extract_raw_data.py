import os
import random

import pymysql
from pathlib import Path

LOCAL_SAMPLE_COUNT = 100000
TABLES = [
    "taxi_trips_2019_raw",
    "taxi_trips_2023_raw",
    "network_trips_2019_raw",
    "network_trips_2023_raw",
    "traffic_tracker_2019_raw",
    "traffic_tracker_2023_raw"]

def get_column_names(cursor, table_name):
    cursor.execute(f"SHOW COLUMNS FROM {table_name}")
    columns = cursor.fetchall()
    return [column[0] for column in columns]


def main():
    local = pymysql.connect(host="localhost", user="root", password="rootroot", db="chicago_taxi")
    gcp = pymysql.connect(host="35.192.134.73", user="dev", password="tt0Ibr0eb4R", db="chicago_taxi")

    # Resolve the directory to an absolute path
    directory = Path("../sql/raw_tables").resolve()

    # Ensure the directory exists
    if not directory.is_dir():
        print(f"Directory {directory} does not exist.")
        return

    # Process SQL files in the directory
    for filename in os.listdir(directory):
        if filename.endswith(".sql"):
            filepath = directory / filename
            try:
                with open(filepath, 'r') as file:
                    sql_script = file.read()

                with local.cursor() as cursor:
                    for statement in sql_script.split(';'):
                        trimmed_statement = statement.strip()
                        if trimmed_statement:  # Make sure the statement is not empty
                            cursor.execute(trimmed_statement)

                local.commit()
                print(f"Executed {filename} successfully.")
            except Exception as e:
                print(f"Failed to execute {filename}: {e}")

    pass

    try:
        for TABLE in TABLES:
            with gcp.cursor() as cursor:
                cursor.execute(
                f"""
                SELECT COUNT(*) FROM chicago_taxi.{TABLE};
                """)
                total_rows = cursor.fetchone()[0]

                random_row_ids = random.sample(range(1, total_rows + 1), LOCAL_SAMPLE_COUNT)

                cursor.execute(
                """
                CREATE TEMPORARY TABLE random_numbers (row_id INT);
                """)

                cursor.executemany(
                """
                INSERT INTO random_numbers (row_id) VALUES (%s);
                """,
                    [(row_id,) for row_id in random_row_ids])

                cursor.execute(
                f"""
                SELECT t.* 
                FROM chicago_taxi.{TABLE} t
                INNER JOIN random_numbers r ON t.row_id = r.row_id;
                """)
                samples = cursor.fetchall()

                cursor.execute(
                """
                DROP TEMPORARY TABLE random_numbers;
                """)

            with (local.cursor() as local_cursor):
                column_names_local = get_column_names(local_cursor, TABLE)

                placeholders = ', '.join(['%s'] * len(column_names_local))

                insert_sample_query = f"""
                INSERT INTO chicago_taxi.{TABLE} ({', '.join(column_names_local)}) 
                VALUES ({placeholders})
                """

                local_cursor.executemany(insert_sample_query, samples)
                local.commit()

            print(f"Loaded data into {TABLE} successfully.")
    finally:
        local.close()
        gcp.close()




if __name__ == "__main__":
    main()