import os

import pymysql
from pathlib import Path

TABLES = [
    "taxi_trips_2019_raw",
    "taxi_trips_2023_raw",
    "network_trips_2019_raw",
    "network_trips_2023_raw",
    "traffic_tracker_2019_raw",
    "traffic_tracker_2023_raw"]


def main():
    local = pymysql.connect(host="localhost", user="root", password="rootroot", db="chicago_taxi")

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

    local.close()


if __name__ == "__main__":
    main()