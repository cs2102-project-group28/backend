from database import select_query
import ast


def get_menu(cursor, rName, rCategory, location, fName, fCategory):
    if rName == '':
        rName = tuple(select_query(cursor, 'select rName from restaurants'))
    else:
        rName = tuple(ast.literal_eval(rName))
    if rCategory == '':
        rCategory = tuple(select_query(cursor, 'select rCategory from restaurants'))
    else:
        rCategory = tuple(ast.literal_eval(rCategory))
    if location == '':
        location = tuple(select_query(cursor, 'select location from restaurants'))
    else:
        location = tuple(ast.literal_eval(location))
    if fName == '':
        fName = tuple(select_query(cursor, 'select fName from foodItems'))
    else:
        fName = tuple(ast.literal_eval(fName))
    if fCategory == '':
        fCategory = tuple(select_query(cursor, 'select fCategory from foodItems'))
    else:
        fCategory = tuple(ast.literal_eval(fCategory))

    return select_query(cursor,
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
