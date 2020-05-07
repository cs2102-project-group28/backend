from database import select_query, update_query
from datetime import date, datetime
from service import convert_date


def get_menu(cursor, rName, rCategory, location, fName, fCategory):
    if len(rName) == 0:
        rName = tuple(select_query(cursor, 'select rName from restaurants'))
    if len(rCategory) == 0:
        rCategory = tuple(select_query(cursor, 'select rCategory from restaurants'))
    if len(location) == 0:
        location = tuple(select_query(cursor, 'select location from restaurants'))
    if len(fName) == 0:
        fName = tuple(select_query(cursor, 'select fName from foodItems'))
    if len(fCategory) == 0:
        fCategory = tuple(select_query(cursor, 'select fCategory from foodItems'))

    ret = select_query(cursor,
                       'select * '
                       'from restaurants join menu using(rid) '
                       'join foodItems using(fid) '
                       'where '
                       'rName in %s '
                       'and rCategory in %s '
                       'and location in %s '
                       'and fName in %s '
                       'and fCategory in %s;',
                       (rName, rCategory, location, fName, fCategory,))

    query = list()
    for item in ret:
        query.append({
            'rid': item[0],
            'fid': item[1],
            'rName': item[2],
            'rCategory': item[3],
            'location': item[4],
            'minSpent': item[5],
            'availability': item[6],
            'noOfOrders': item[8],
            'price': item[9],
            'fName': item[10],
            'fCategory': item[11]
        })
    return query


def get_food(cursor, string):
    all_food = select_query(cursor,
                            """select fName from foodItems where 
                            lower(fName) like '%%' || %s || '%%';""",
                            (string,))
    return [item[0] for item in all_food]


def get_restaurant(cursor, restaurant):
    if restaurant is None:
        all_restaurants = select_query(cursor,
                                       "select rName, location from Restaurants;",
                                       (restaurant,))
    else:
        all_restaurants = select_query(cursor,
                                       """select rName, location from Restaurants 
                                       where lower(rName) like '%%' || %s || '%%';""",
                                       (restaurant,))
    return [
        {
            'rName': item[0],
            'location': item[1]
        } for item in all_restaurants
    ]


def checkout(connection, cursor, username, rid, fid, quantity, ptype, pid, location):
    availability = select_query(cursor,
                                'select availability '
                                'from menu '
                                'where rid = %s and fid in %s;',
                                (rid, fid))[0][0]
    if not availability:
        raise Exception('This item is not available')
    now = datetime.now()
    oid = select_query(cursor,
                       'select count(*) + 1 from orders;')[0][0]
    update_query(connection, cursor,
                 'insert into orders (oid, orderTime, rid, cid) '
                 'values '
                 '('
                 '%s, %s, %s, '
                 '(select uid from users where username = %s)'
                 ');',
                 (oid, now, rid, username))
    for i in range(len(fid)):
        update_query(connection, cursor,
                     'insert into contains (oid, fid, quantity) '
                     'values '
                     '(%s, %s, %s);', (oid, fid[i], quantity[i]))
        update_query(connection, cursor,
                     'update menu m '
                     'set noOfOrders = noOfOrders + '
                     '(select quantity '
                     'from contains c '
                     'where c.fid = %s and oid = %s'
                     ') '
                     'where rid = %s and fid = %s;',
                     (fid[i], oid, rid, fid[i]))
    total_price = select_query(cursor,
                               'select sum(price*quantity) as totalPrice '
                               'from contains join orders using(oid) '
                               'join menu using(rid, fid) '
                               'where oid = %s', (oid,))[0][0]
    min_spent = select_query(cursor,
                             'select minSpent '
                             'from restaurants join orders using(rid) '
                             'where oid = %s;', (oid,))[0][0]
    if total_price < min_spent:
        raise Exception('Minimum spent is not met')
    discount = 0
    if ptype == 'flat':
        flat_promo = select_query(cursor,
                                  'select distinct flatAmount '
                                  'from flat join promotes using(pid) '
                                  'where pid = %s '
                                  'and (fid is null or fid in %s) '
                                  'and (rid is null or rid = %s) '
                                  'and minAmount <= %s;', (pid, fid, rid, total_price))
        if len(flat_promo) > 0:
            discount = flat_promo[0][0]
    elif ptype == 'percentage':
        percent_promo = select_query(cursor,
                                     'select percent, quantity, price, maxAmount '
                                     'from percentage join promotes pr using(pid) '
                                     'join contains c on('
                                     'pr.fid is null or c.fid = pr.fid) '
                                     'join menu m on('
                                     'pr.rid is null or m.rid = pr.rid) '
                                     'where pid = %s '
                                     'and c.fid in %s '
                                     'and m.rid = %s;', (pid, fid, rid))
        if len(percent_promo) > 0:
            discount = sum(item[0] * item[1] * item[2] for item in percent_promo)
            discount = min(discount, percent_promo[0][3])
    update_query(connection, cursor,
                 'update customers '
                 'set rewardPoints = rewardPoints + round(%s) '
                 'where uid = ('
                 'select uid '
                 'from customers join users using(uid) '
                 'where username = %s);',
                 (total_price - discount, username))
    part_time = select_query(cursor,
                             'select w.uid '
                             'from weeklyworks w join schedules using(sid) '
                             'where startTime <= %s and endTime >= %s '
                             'and dayOfWeek = %s '
                             'and not exists ('
                             'select 1 '
                             'from delivers d '
                             'where (completeTime is null or completeTime > %s) and d.uid = w.uid'
                             ');',
                             (now.strftime('%H:%M'), now.strftime('%H:%M'), convert_date(now.strftime("%A")), now))
    full_time = select_query(cursor,
                             'select uid '
                             'from monthlyworks w join schedules using(sid) '
                             'where startTime <= %s and endTime >= %s '
                             'and dayOfWeek = %s '
                             'and not exists ('
                             'select 1 '
                             'from delivers d '
                             'where (completeTime is null or completeTime > %s) and d.uid = w.uid'
                             ');',
                             (now.strftime('%H:%M'), now.strftime('%H:%M'), convert_date(now.strftime("%A")), now))
    rider = (part_time + full_time)[0][0]
    update_query(connection, cursor,
                 'insert into delivers (uid, oid, startTime, deliverCost, location) '
                 'values (%s, %s, %s, 10, %s);',
                 (rider, oid, now, location))
    return {
        'oid': oid,
        'food price': total_price,
        'discount': discount,
        'deliver cost': 10,
        'total price': total_price - discount + 10,
        'rider': rider
    }


def view_monthly_order(cursor, username, month, year):
    uid = select_query(cursor,
                       'select uid from users where username = %s;',
                       (username,))[0][0]
    all_order = select_query(cursor,
                             'select count(*), sum(price), rName, location '
                             'from orders join menu using(rid, fid) '
                             'join manages using(rid) '
                             'join restaurants using(rid) '
                             'where (select extract(month from orderTime)) = %s '
                             'and (select extract(year from orderTime)) = %s '
                             'group by (rName, location, uid) '
                             'having uid = %s;',
                             (month, year, uid))[0]
    top_5 = select_query(cursor,
                         'select fName, cid, orderTime '
                         'from orders join menu using(rid, fid) '
                         'join restaurants using(rid) '
                         'join foodItems using(fid) '
                         'join manages using(rid) '
                         'group by (fName, cid, uid, orderTime) '
                         'having (select extract(month from orderTime)) = %s '
                         'and (select extract(year from orderTime)) = %s '
                         'and uid = %s '
                         'order by sum(noOfOrders) desc '
                         'limit 5;',
                         (month, year, uid))
    return {
        'total orders': all_order[0],
        'total cost': all_order[1],
        'rName': all_order[2],
        'location': all_order[3],
        'favorite food': [
            {
                'fName': item[0],
                'cid': item[1],
                'order time': item[2]
            } for item in top_5
        ]
    }


def view_past_order(cursor, username, startdate, enddate):
    uid = select_query(cursor,
                       'select uid from users where username = %s', (username,))[0][0]
    if startdate is None and enddate is None:
        order = select_query(cursor,
                             'select orderTime, rName, fName, price '
                             'from users join orders on uid = cid '
                             'join restaurants using(rid) '
                             'join foodItems using(fid) '
                             'join menu using(rid, fid) '
                             'where uid = %s', uid)
    elif startdate is None:
        order = select_query(cursor,
                             'select orderTime, rName, fName, price '
                             'from users join orders on uid = cid '
                             'join restaurants using(rid) '
                             'join foodItems using(fid) '
                             'join menu using(rid, fid) '
                             'where uid = %s and date(orderTime) <= %s', (uid, enddate))
    elif enddate is None:
        order = select_query(cursor,
                             'select orderTime, rName, fName, price '
                             'from users join orders on uid = cid '
                             'join restaurants using(rid) '
                             'join foodItems using(fid) '
                             'join menu using(rid, fid) '
                             'where uid = %s and date(orderTime) >= %s', (uid, startdate))
    else:
        order = select_query(cursor,
                             'select orderTime, rName, fName, price, review '
                             'from users join orders on uid = cid '
                             'join restaurants using(rid) '
                             'join foodItems using(fid) '
                             'join menu using(rid, fid) '
                             'where uid = %s and date(orderTime) >= %s and date(orderTime) <= %s',
                             (uid, startdate, enddate))
    return [
        {
            "order time": item[0],
            "restaurant": item[1],
            "foodItem": item[2],
            "price": item[3],
            'review': item[4]
        } for item in order
    ]


def review_order(connection, cursor, username, oid, content):
    update_query(connection, cursor,
                 'update orders '
                 'set review = %s '
                 'where oid = %s and cid = ('
                 'select uid from users where username = %s);',
                 (content, oid, username))


def view_review(cursor, rid):
    review = select_query(cursor,
                          'select username, orderTime, review '
                          'from orders join users on (cid = uid) '
                          'where rid = %s and review is not null;', (rid,))
    return [
        {
            'username': item[0],
            'orderTime': item[1].strftime("%d/%m/%Y %H:%M:%S"),
            'review': item[2]
        }
        for item in review
    ]


def rate_deliver(connection, cursor, oid, rating):
    update_query(connection, cursor,
                 'update delivers '
                 'set rating = %s '
                 'where oid = %s;', (rating, oid))


def get_recent_location(cursor, username):
    locations = select_query(cursor,
                             'select distinct location '
                             'from users join orders on(uid = cid) '
                             'join delivers using(oid) '
                             'order by startTime desc '
                             'limit 5;')
    return locations


def add_food(connection, cursor, username, fName, fCategory):
    update_query(connection, cursor,
                 'insert into FoodItems (fid, fName, fCategory) '
                 'values ((select count(*) from FoodItems) + 1, %s, %s);', ((fName,), (fCategory,)))


def update_menu(connection, cursor, username, min_spent, avai, day_limit, no_orders, price, fid):
    rid = select_query(cursor,
                       'select rid from manages join users using(uid) '
                       'where username = %s', (username,))[0][0]
    if min_spent is not None:
        update_query(connection, cursor,
                     'update restaurants '
                     'set minSpent = %s '
                     'where rid = %s;', (float(min_spent), rid))
    if avai is not None:
        update_query(connection, cursor,
                     'update menu '
                     'set availability = %s '
                     'where rid = %s and fid = %s;', ((avai,), rid, fid))
    if day_limit is not None:
        update_query(connection, cursor,
                     'update menu '
                     'set dayLimit = %s '
                     'where rid = %s and fid = %s;', (int(day_limit), rid, fid))
    if no_orders is not None:
        update_query(connection, cursor,
                     'update menu '
                     'set noOfOrders = %s '
                     'where rid = %s and fid = %s;', (int(no_orders), rid, fid))
    if price is not None:
        update_query(connection, cursor,
                     'update menu '
                     'set price = %s '
                     'where rid = %s and fid = %s;', (float(price), rid, fid))
