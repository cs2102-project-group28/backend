from database import query


def login(cursor, username, password):
    ret = query(cursor,
                'select username, password from customers join users using(uid) where username = %s and password = %s',
                (username, password))
    if len(ret) != 0:
        return {
            'position': 'customer',
        }
    ret = query(cursor,
                'select username, password from riders join users using(uid) where username = %s and password = %s',
                (username, password))
    if len(ret) != 0:
        return {
            'position': 'rider',
        }
    ret = query(cursor,
                'select username, password from staffs join users using(uid) where username = %s and password = %s',
                (username, password))
    if len(ret) != 0:
        return {
            'position': 'staff',
        }
    ret = query(cursor,
                'select username, password from managers join users using(uid) where username = %s and password = %s',
                (username, password))
    if len(ret) != 0:
        return {
            'position': 'manager',
        }
    return None
