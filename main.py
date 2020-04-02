from flask import Flask, request
from flask_cors import CORS
import database as db
import json

app = Flask(__name__, static_folder='static', template_folder='static/build')
cors = CORS(app, resources={r"/*": {"origins": "*", "supports_credentials": True}})


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = request.json
        print(user)
        return json.dumps({'status': 'valid'})


if __name__ == '__main__':
    connection, cursor = db.init()
    app.run(host='0.0.0.0', port=5000, debug=True)
