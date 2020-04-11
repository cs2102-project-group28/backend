from database import select_query
from datetime import date


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


def checkout(cursor, rid, fids):
    total_price = select_query(cursor,
                               "select sum(price) from menu "
                               "where rid = %s and fid in %s",
                               (rid, fids))[0][0]
    return {
        'total price': total_price,
    }


def view_monthly_order(cursor):
    today_datetime = date.today()
    all_order = select_query(cursor,
                             'select count(*), sum(price) '
                             'from orders join menu using(rid, fid) '
                             'where (select extract(month from orderTime)) = %s;',
                             (today_datetime.month,))[0]
    top_5 = select_query(cursor,
                         'select fName, rName, location '
                         'from orders join menu using(rid, fid) '
                         'join restaurants using(rid) '
                         'join foodItems using(fid) '
                         'group by (fName, rName, location, orderTime) '
                         'having (select extract(month from orderTime)) = %s '
                         'order by sum(noOfOrders) desc '
                         'limit 5;',
                         (today_datetime.month,))
    return {
        'total orders': all_order[0],
        'total cost': all_order[1],
        'favorite food': [
            {
                'fName': item[0],
                'rName': item[1],
                'location': item[2]
            } for item in top_5
        ]
    }
