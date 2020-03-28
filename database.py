import psycopg2
from password import password


def init():
    global connection
    connection = psycopg2.connect(user="postgres",
                                  password=password,
                                  host="localhost",
                                  port="5432",
                                  database="pizza")


try:
    init()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM pizzas;")
    query = cursor.fetchall()
    print(query)
except (Exception, psycopg2.Error) as error:
    print("Error while connecting to PostgreSQL", error)
finally:
    # closing database connection.
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
