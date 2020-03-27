from flask import Flask
import database as db

app = Flask(__name__)


@app.route('/')
def main():
    connection, cursor = db.init()
    return ''


if __name__ == '__main__':
    app.run()
