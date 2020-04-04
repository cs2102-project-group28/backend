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


@app.route('/customer/<username>/update', methods=['GET', 'POST'])
def update(username):
    if request.method == 'POST':
        new_user = request.json
        id = int(new_user['uid'])
        if new_user['username'] != '':
            username = new_user['username']
            if new_user['password'] == '' and new_user['phone'] == '':
                return {'message': 'All fields are empty'}, 400
        password = new_user['password']
        phone = new_user['phone']
        uqr.update(connection, cursor, id, username, password, phone)
        return Response(status=200)


@app.route('/customer/<username>/order', methods=['GET', 'POST'])
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

    if request.method == 'GET':
        return json.dumps({
            'data': mqr.get_menu(cursor, '', '', '', '', '')
        }), 200


if __name__ == '__main__':
    connection, cursor = db.init()
    # app.run(host='0.0.0.0', port=5000, debug=True)
    # print(qr.login(cursor, 'ledelheit2j', 'AeNqTx4HHKZ'))
    # uqr.update(connection, cursor, 52, 'pjuares1f', 'Ta0zdMsvk', '99691149')
    print(mqr.get_menu(cursor, "['Alfa']", "['Chinese']", '', '', ''))
