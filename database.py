import psycopg2
from password import password


def init():
    connection = psycopg2.connect(user="postgres",
                                  password=password,
                                  host="localhost",
                                  port="5432",
                                  database="test")
    cursor = connection.cursor()
    return connection, cursor


def close(cursor, connection):
    if connection:
        cursor.close()
        connection.close()


def query(cursor, string):
    cursor.execute(string)
    return cursor.fetchall()
