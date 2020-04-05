from database import select_query, update_query


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
