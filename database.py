import psycopg2
from password import password


def init():
    connection = psycopg2.connect(user="postgres",
                                  password=password,
                                  host="localhost",
                                  port="5432",
                                  database="project")
    cursor = connection.cursor()
    return connection, cursor


def close(cursor, connection):
    if connection:
        cursor.close()
        connection.close()


def query(cursor, string, param=None):
    cursor.execute(string, param)
    return cursor.fetchall()
