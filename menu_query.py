from database import select_query, update_query


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


def checkout(cursor, rid, fid, pid):
    oid, food_price = select_query(cursor,
                                   "select oid, sum(price) from menu join orders "
                                   "using(rid, fid) "
                                   "group by oid, rid, fid "
                                   "having rid = %s and fid = %s",
                                   (rid, fid))[0][0]
    deliver_cost = select_query(cursor,
                                "select deliverCost from delivers join orders using(oid) "
                                "where oid = %s;", (oid,))[0][0]
    total_price = food_price + deliver_cost
    return {
        'total price': total_price,
        'fool price': food_price,
        'deliver cost': deliver_cost
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


def place_order(connection, cursor, username, rid, fid, total_price):
    availability = select_query(cursor,
                                'select availability '
                                'from menu '
                                'where rid = %s and fid = %s;',
                                (rid, fid))[0][0]
    if not availability:
        raise Exception
    update_query(connection, cursor,
                 'update menu '
                 'set noOfOrders = noOfOrders + 1 '
                 'where rid = %s and fid = %s;',
                 (rid, fid))
    update_query(connection, cursor,
                 'update customers '
                 'set rewardPoints = rewardPoints + round(%s) '
                 'where uid = ('
                 'select uid '
                 'from customers join users using(uid) '
                 'where username = %s);',
                 (total_price, username))
