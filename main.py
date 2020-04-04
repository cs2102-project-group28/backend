from flask import Flask, request
from flask_cors import CORS
import database as db
import query as qr

app = Flask(__name__, static_folder='static', template_folder='static/build')
cors = CORS(app, resources={r"/*": {"origins": "*", "supports_credentials": True}})


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = request.json
        username = user['username']
        password = user['password']
        pos = qr.login(cursor, username, password)
        if pos is None:
            return {'message': 'Username or password is incorrect'}, 400
        return pos, 200


if __name__ == '__main__':
    connection, cursor = db.init()
    # app.run(host='0.0.0.0', port=5000, debug=True)
    print(qr.login(cursor, 'ledelheit2j', 'Hk5rHRvDY'))
