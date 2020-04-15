from database import select_query


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
