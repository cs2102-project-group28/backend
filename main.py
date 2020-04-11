from flask import Flask, request, Response
from flask_cors import CORS
import database as db
import user_query as uqr
import menu_query as mqr
import json
from url_converter import ListConverter

app = Flask(__name__, static_folder='static', template_folder='static/build')
app.url_map.converters['list'] = ListConverter
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


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        new_user = request.json
        username = new_user['username']
        password = new_user['password']
        phone = new_user['phone']
        user_type = new_user['userType']
        if new_user['username'] == '' or new_user['password'] == '' or new_user['phone'] == '' \
                or new_user['userType'] == '':
            return {'message': 'Some fields are empty'}, 400
        uqr.register(connection, cursor, username, password, phone, user_type)
        return Response(status=200)


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
        rName = tuple(menu['rName'])
        rCategory = tuple(menu['rCategory'])
        location = tuple(menu['location'])
        fName = tuple(menu['fName'])
        fCategory = tuple(menu['fCategory'])
        return json.dumps({
            'data': mqr.get_menu(cursor, rName, rCategory, location, fName, fCategory)
        }), 200


@app.route('/customer/<username>/order/checkout/<rid>/<list:fids>', methods=['POST'])
def checkout(username, rid, fids):
    if request.method == 'POST':
        customer = request.json
        creditcard = int(customer['creditCardNumber'])
        cvv = int(customer['cvv'])
        if customer['payment method'] == 'credit card':
            try:
                uqr.verify_customer(cursor, username, creditcard, cvv)
            except Exception:
                return {'message': 'Credit card or cvv is not correct'}, 400
        return mqr.checkout(cursor, rid, fids), 200


@app.route('/customer/<username>/search-food/<item>', methods=['POST'])
def search_food(username, item):
    if request.method == 'POST':
        item = str.lower(item)
        return json.dumps({
            'data': mqr.get_food(cursor, item)
        }), 200


@app.route('/customer/<username>/search-restaurant/<restaurant>', methods=['POST'])
def search_restaurants(username, restaurant):
    if request.method == 'POST':
        restaurant = str.lower(restaurant)
        return json.dumps({
            'data': mqr.get_restaurant(cursor, restaurant)
        }), 200


if __name__ == '__main__':
    connection, cursor = db.init()
    app.run(host='0.0.0.0', port=5000, debug=True)
