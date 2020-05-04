from database import select_query, update_query
from datetime import date


def login(cursor, username, password):
    ret = select_query(cursor,
                       'select username, password from customers join users using(uid) '
                       'where username = %s and password = %s',
                       (username, password))
    if len(ret) != 0:
        return {
            'position': 'customer',
        }
    ret = select_query(cursor,
                       'select username, password from riders join users using(uid) '
                       'where username = %s and password = %s',
                       (username, password))
    if len(ret) != 0:
        return {
            'position': 'rider',
        }
    ret = select_query(cursor,
                       'select username, password from staffs join users using(uid) '
                       'where username = %s and password = %s',
                       (username, password))
    if len(ret) != 0:
        return {
            'position': 'staff',
        }
    ret = select_query(cursor,
                       'select username, password from managers join users using(uid) '
                       'where username = %s and password = %s',
                       (username, password))
    if len(ret) != 0:
        return {
            'position': 'manager',
        }
    return None


def get_profile(cursor, username, phone, user_type, reward_points):
    if len(phone) == 0:
        phone = select_query(cursor, 'select phone from users where username = %s', username)
    customer_query = select_query(cursor, 'select username from customers join users using(uid) where username = %s',
                                  username)
    if len(customer_query) != 0:
        user_type = 'customer'
    rider_query = select_query(cursor, 'select username from riders join users using(uid) where username = %s',
                               username)
    if len(rider_query) != 0:
        user_type = 'rider'
    staff_query = select_query(cursor, 'select username from staffs join users using(uid) where username = %s',
                               username)
    if len(staff_query) != 0:
        user_type = 'staff'
    manager_query = select_query(cursor, 'select username from managers join users using(uid) where username = %s',
                                 username)
    if len(manager_query) != 0:
        user_type = 'manager'
    if user_type == 'customer' and len(reward_points) == 0:
        reward_points = select_query(cursor, 'select rewardPoints from customers join users using(uid) '
                                             'where username = %s', username)
        return {'userName': username, 'phone': phone, 'userType': user_type, 'rewardPoints': reward_points}
    return {'userName': username, 'phone': phone, 'userType': user_type}


def update(connection, cursor, username, password=None, phone=None):
    if password is None:
        update_query(connection, cursor,
                     'update users set phone = %s where username = %s;',
                     ((phone,), username))
    if phone is None:
        update_query(connection, cursor,
                     'update users set password = %s where username = %s;',
                     (password, username))
    else:
        update_query(connection, cursor,
                     'update users set password = %s, phone = %s where username = %s;',
                     (password, (phone,), username))


def register(connection, cursor, username, password, phone, user_type):
    update_query(connection, cursor,
                 'insert into Users (uid, username, password, phone) values '
                 '((select count(*) from Users) + 1, %s, %s, %s);', (username, password, (phone,)))
    if user_type == 'customer':
        today = date.today()
        update_query(connection, cursor,
                     'insert into Customers (uid, rewardPoints, registerDate) values '
                     '((select count(*) from Users), 0, %s);', (today,))
    if user_type == 'rider':
        update_query(connection, cursor,
                     'insert into Riders (uid) values ((select count(*) from Users));')
    if user_type == 'staff':
        update_query(connection, cursor,
                     'insert into Staffs (uid) values ((select count(*) from Users));')
    if username == 'manager':
        update_query(connection, cursor,
                     'insert into Managers (uid) values ((select count(*) from Users));')


def verify_customer(cursor, username, creditcard, cvv):
    verified_creditcard, verified_cvv = select_query(cursor,
                                                     'select creditCardNumber, cvv from '
                                                     'customers join users using(uid) '
                                                     'where username = %s;', (username,))[0]
    if creditcard != verified_creditcard or cvv != verified_cvv:
        raise Exception


def customer_update(connection, cursor, username, card_number=None, cvv=None):
    uid = select_query(cursor,
                       'select uid from users where username = %s', (username,))[0][0]
    if card_number is None:
        update_query(connection, cursor,
                     'update customers set cvv = %s where uid = %s;',
                     (cvv, uid))
    elif cvv is None:
        update_query(connection, cursor,
                     'update customers set creditCardNumber = %s where uid = %s;',
                     (card_number, uid))
    else:
        update_query(connection, cursor,
                     'update customers set creditCardNumber = %s, cvv = %s where uid = %s;',
                     (card_number, cvv, uid))
