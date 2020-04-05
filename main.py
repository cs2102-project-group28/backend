from flask import Flask, request, Response
from flask_cors import CORS
import database as db
import user_query as uqr
import menu_query as mqr
import json

app = Flask(__name__, static_folder='static', template_folder='static/build')
cors = CORS(app, resources={r"/*": {"origins": "*", "supports_credentials": True}})


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = request.json
        username = user['username']
        password = user['password']
        pos = uqr.login(cursor, username, password)
        if pos is None:
            return {'message': 'Username or password is incorrect'}, 400
        return pos, 200


@app.route('/<username>/update', methods=['POST'])
def update(username):
    if request.method == 'POST':
        new_user = request.json
        if 'password' not in new_user and 'phone' not in new_user:
            return {'message': 'All fields are empty'}, 400
        elif 'phone' not in new_user:
            uqr.update(connection, cursor, username, password=new_user['password'])
        elif 'password' not in new_user:
            uqr.update(connection, cursor, username, phone=int(new_user['phone']))
        else:
            uqr.update(connection, cursor, username, new_user['password'], new_user['phone'])
        return Response(status=200)


@app.route('/customer/<username>/order', methods=['POST'])
def view_menu(username):
    if request.method == 'POST':
        menu = request.json
        rName = menu['rName']
        rCategory = menu['rCategory']
        location = menu['location']
        fName = menu['fName']
        fCategory = menu['fCategory']
        return json.dumps({
            'data': mqr.get_menu(cursor, rName, rCategory, location, fName, fCategory)
        }), 200


if __name__ == '__main__':
    connection, cursor = db.init()
    app.run(host='0.0.0.0', port=5000, debug=True)
    # print(qr.login(cursor, 'ledelheit2j', 'AeNqTx4HHKZ'))
    # uqr.update(connection, cursor, 52, 'pjuares1f', 'Ta0zdMsvk', '99691149')
    # print(mqr.get_menu(cursor, "['Alfa']", '[]', '[]', '[]', '[]'))
