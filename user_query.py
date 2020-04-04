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


def update(connection, cursor, id, username, password, phone):
    if password == '':
        password = select_query(cursor, 'select password from users where uid = %s', (id,))[0]
    if phone == '':
        phone = select_query(cursor, 'select phone from users where uid = %s', (id,))[0]
    else:
        phone = int(phone)
    update_query(connection, cursor,
                 'update users set username = %s, password = %s, phone = %s where uid = %s;',
                 (username, password, (phone,), (id,)))
    # print(select_query(cursor, 'select * from users where uid = %s', (id,)))
