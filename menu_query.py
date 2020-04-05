from database import select_query
import ast


def get_menu(cursor, rName, rCategory, location, fName, fCategory):
    rName = tuple(ast.literal_eval(rName))
    rCategory = tuple(ast.literal_eval(rCategory))
    location = tuple(ast.literal_eval(location))
    fName = tuple(ast.literal_eval(fName))
    fCategory = tuple(ast.literal_eval(fCategory))
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
            'rName': item[2],
            'rCategory': item[3],
            'location': item[4],
            'minSpent': item[5],
            'avalability': item[6],
            'noOfOrders': item[8],
            'price': item[9],
            'fName': item[10],
            'fCategory': item[11]
        })
    return query
