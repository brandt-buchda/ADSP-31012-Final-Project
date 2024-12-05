# ADSP-31012-Final-Project

## Installing dependencies

This project is managed using Pipenv. To install pipenv, run the following command 

```shell
pip install pipenv
```

Pipenv automatically tracks and controls python package dependencies. To install all the required packages run the following command:

```shell
pipenv install
```

## Loading data into localhost

Run the following commands in order to pull data into your local server

```shell
cd dev_tools
```

```shell
python create_raw_tables.py
```

```shell
python load_data.py
```
