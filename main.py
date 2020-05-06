from flask import Flask, request, Response
from flask_cors import CORS
import database as db
import user_query as uqr
import menu_query as mqr
import manager_query as mngqr
import promotion_query as pqr
import rider_query as rqr
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


@app.route('/register', methods=['POST'])
def register():
    if request.method == 'POST':
        new_user = request.json
        username = new_user['username']
        password = new_user['password']
        phone = int(new_user['phone'])
        user_type = new_user['userType']
        rider_type = new_user['riderType']
        if new_user['username'] == '' or new_user['password'] == '' or new_user['userType'] == '':
            return {'message': 'Some fields are empty'}, 400
        uqr.register(connection, cursor, username, password, phone, user_type, rider_type)
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


@app.route('/<username>/profile', methods=['POST'])
def view_profile(username):
    if request.method == 'POST':
        user = request.json
        phone = int(user['phone'])
        user_type = user['userType']
        reward_points = int(user['rewardPoints'])
        return {'data': uqr.get_profile(cursor, username, phone, user_type, reward_points)}, 200


@app.route('/<username>/update/customer', methods=['POST'])
def customer_update(username):
    if request.method == 'POST':
        card_update = request.json
        if 'creditCardNumber' not in card_update:
            uqr.customer_update(connection, cursor, username, cvv=card_update['cvv'])
        elif 'cvv' not in card_update:
            uqr.customer_update(connection, cursor, username, card_number=card_update['creditCardNumber'])
        else:
            uqr.customer_update(connection, cursor, username, card_update['creditCardNumber'], card_update['cvv'])
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
        return {'data': mqr.get_menu(cursor, rName, rCategory, location, fName, fCategory)}, 200


@app.route('/customer/<username>/order/checkout/<rid>/<list:fid>/<list:quantity>/promo', methods=['POST'])
def checkout(username, rid, fid, quantity):
    if request.method == 'POST':
        customer = request.json
        if customer['payment method'] == 'credit card':
            creditcard = int(customer['creditCardNumber'])
            cvv = int(customer['cvv'])
            try:
                uqr.verify_customer(cursor, username, creditcard, cvv)
            except Exception:
                return {'message': 'Credit card or cvv is not correct'}, 400
        try:
            ptype = request.args.get('ptype')
            pid = request.args.get('pid')
            return mqr.checkout(connection, cursor, username, rid, fid, quantity, ptype, pid, customer['location']), 200
        except Exception as e:
            return {'message': str(e)}, 400


@app.route('/customer/<username>/view-promotion', methods=['POST'])
def view_promotion(username):
    if request.method == 'POST':
        return {'data': pqr.view_promotion(cursor)}, 200


@app.route('/customer/<username>/past-order/date', methods=['POST'])
def past_order(username):
    startdate = request.args.get('startdate')
    enddate = request.args.get('enddate')
    return {'data': mqr.view_past_order(cursor, username, startdate, enddate)}, 200


@app.route('/customer/<username>/search-food/<item>', methods=['POST'])
def search_food(username, item):
    if request.method == 'POST':
        item = str.lower(item)
        return {'data': mqr.get_food(cursor, item)}, 200


@app.route('/customer/<username>/post-review/<oid>', methods=['POST'])
def review_order(username, oid):
    if request.method == 'POST':
        review = request.json
        content = review['content']
        mqr.review_order(connection, cursor, username, oid, content)
        return Response(status=200)


@app.route('/customer/<username>/view-review/<rid>', methods=['POST'])
def view_review(username, rid):
    if request.method == 'POST':
        return {"data": mqr.view_review(cursor, rid)}, 200


@app.route('/customer/<username>/rate-deliver/<oid>/<rating>', methods=['POST'])
def rate_deliver(username, oid, rating):
    if request.method == 'POST':
        mqr.rate_deliver(connection, cursor, oid, rating)
        return Response(status=200)


@app.route('/customer/<username>/recent-locations', methods=['POST'])
def recent_locations(username):
    if request.method == 'POST':
        locations = mqr.get_recent_location(cursor, username)
        return {"data": locations}, 200


@app.route('/customer/<username>/search-restaurant/<restaurant>', methods=['POST'])
def search_restaurants(username, restaurant):
    if request.method == 'POST':
        restaurant = str.lower(restaurant)
        return {'data': mqr.get_restaurant(cursor, restaurant)}, 200


@app.route('/staff/<username>/summary/promotion/<startdate>/<enddate>', methods=['POST'])
@app.route('/staff/<username>/summary/promotion/<startdate>', methods=['POST'])
def summary_promotion(username, startdate, enddate=None):
    if request.method == 'POST':
        data = pqr.summary(cursor, startdate, enddate, username)
        if len(data) == 0:
            return {'message': 'No promotions within this time for your restaurant'}, 400
        return {'data': data}, 200


@app.route('/staff/<username>/summary/order/<month>/<year>', methods=['POST'])
def view_monthly_order(username, month, year):
    if request.method == 'POST':
        return mqr.view_monthly_order(cursor, username, month, year), 200


@app.route('/manager/<username>/month-summary/<month>/<year>', methods=['POST'])
def month_summary(username, month, year):
    if request.method == 'POST':
        return mngqr.month_summary(cursor, month, year), 200


@app.route('/manager/<username>/order/<area>/<day>/<starttime>/<endtime>', methods=['POST'])
def order_summary(username, area, day, starttime, endtime):
    if request.method == 'POST':
        data = mngqr.order_summary(cursor, area, day, starttime, endtime)
        return data, 200


@app.route('/manager/<username>/rider/<month>/<year>', methods=['POST'])
def rider_summary(username, month, year):
    if request.method == 'POST':
        data = mngqr.rider_summary(cursor, month, year)
        return {'data': data}, 200


@app.route('/rider/<username>/summary/<month>/<year>', methods=['POST'])
def summary(username, month, year):
    if request.method == 'POST':
        data = rqr.summary(cursor, username, month, year)
        return data, 200


@app.route('/rider/<username>/set-deliver-depart/<oid>', methods=['POST'])
def set_deliver_depart_time(username, oid):
    if request.method == 'POST':
        rqr.set_deliver_depart_time(connection, cursor, username, oid)
        return Response(status=200)


@app.route('/rider/<username>/set-deliver-complete/<oid>', methods=['POST'])
def set_deliver_complete_time(username, oid):
    if request.method == 'POST':
        rqr.set_deliver_complete_time(connection, cursor, username, oid)
        return Response(status=200)


@app.route('/rider/part-time/<username>/add-schedule/<list:sid>', methods=['POST'])
def add_schedule_part_time(username, sid):
    if request.method == 'POST':
        try:
            rqr.add_schedule_part_time(connection, cursor, username, sid)
            return Response(status=200)
        except Exception as e:
            return {"message": str(e)}, 400


@app.route('/rider/part-time/<username>/delete-schedule/<list:sid>', methods=['POST'])
def delete_schedule(username, sid):
    if request.method == 'POST':
        try:
            rqr.delete_schedule_part_time(connection, cursor, username, sid)
            return Response(status=200)
        except Exception as e:
            return {"message": str(e)}, 400


@app.route('/rider/full-time/<username>/add-schedule/<startday>/<endday>/<shift>', methods=['POST'])
def add_schedule_full_time(username, startday, endday, shift):
    if request.method == 'POST':
        rqr.add_schedule_full_time(connection, cursor, username, int(startday), int(endday), int(shift))
        return Response(status=200)


if __name__ == '__main__':
    connection, cursor = db.init()
    app.run(host='0.0.0.0', port=5000, debug=True)
