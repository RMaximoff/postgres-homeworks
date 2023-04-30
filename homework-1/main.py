"""Скрипт для заполнения данными таблиц в БД Postgres."""
import csv
import psycopg2


connect = psycopg2.connect("host=localhost "
                           "port=5432 "
                           "dbname=north "
                           "user=postgres "
                           "password=2175")
cursor = connect.cursor()

queries = {'north_data/employees_data.csv': 'INSERT INTO employees VALUES (default, %s, %s, %s, %s, %s)',
           'north_data/customers_data.csv': 'INSERT INTO customers VALUES (%s, %s, %s)',
           'north_data/orders_data.csv': 'INSERT INTO orders VALUES (%s, %s, %s, %s, %s)'}

for i in queries:
    with open(i, 'r') as file:
        csvreader = csv.reader(file)
        next(csvreader)
        rows = [v for v in csvreader]
        cursor.executemany(queries[i], rows)
        connect.commit()

connect.close()

