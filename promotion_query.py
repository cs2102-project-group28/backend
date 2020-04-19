from database import select_query


def get_flat(cursor, uid, startdate, enddate):
    if enddate is None:
        promotion = select_query(cursor,
                                 'with Temp as '
                                 '(select pid, startDate, endDate, flatAmount, minAmount, fid, uid '
                                 'from promotions join flat using(pid) '
                                 'join promotes p using(pid) '
                                 'join manages m '
                                 'on (p.rid is null or p.rid = m.rid) '
                                 'where uid = %s) '
                                 ''
                                 'select pid, startDate, endDate, flatAmount, minAmount, mana.rid, count(*), sum(price), max(orderTime), min(orderTime) '
                                 'from Temp t, orders o, menu m, manages mana '
                                 'where mana.uid = t.uid '
                                 'and mana.rid = o.rid and '
                                 'mana.rid = m.rid and '
                                 'm.fid = o.fid and '
                                 'case '
                                 'when t.fid is not null then o.fid = t.fid '
                                 'else true '
                                 'end '
                                 'and date(orderTime) >= %s '
                                 'group by (pid, startDate, endDate, flatAmount, minAmount, mana.rid);',
                                 (uid, startdate))
    else:
        promotion = select_query(cursor,
                                 'with Temp as '
                                 '(select pid, startDate, endDate, flatAmount, minAmount, fid, uid '
                                 'from promotions join flat using(pid) '
                                 'join promotes p using(pid) '
                                 'join manages m '
                                 'on (p.rid is null or p.rid = m.rid) '
                                 'where uid = %s) '
                                 ''
                                 'select pid, startDate, endDate, flatAmount, minAmount, mana.rid, count(*), sum(price), max(orderTime), min(orderTime) '
                                 'from Temp t, orders o, menu m, manages mana '
                                 'where mana.uid = t.uid '
                                 'and mana.rid = o.rid and '
                                 'mana.rid = m.rid and '
                                 'm.fid = o.fid and '
                                 'case '
                                 'when t.fid is not null then o.fid = t.fid '
                                 'else true '
                                 'end '
                                 'and date(orderTime) >= %s and date(orderTime) <= %s '
                                 'group by (pid, startDate, endDate, flatAmount, minAmount, mana.rid);',
                                 (uid, startdate, enddate))
    return [
        {
            'type': 'flat promotion',
            'pid': item[0],
            'startDate': item[1].strftime('%d/%m/%Y'),
            'endTime': item[2].strftime('%d/%m/%Y'),
            'flatAmount': item[3],
            'minAmount': item[4],
            'rid': item[5],
            'no. of orders': item[6],
            'orders per day': item[6] / ((item[8] - item[9]).days + 1),
            'total price': item[7],
        } for item in promotion
    ]


def get_percentage(cursor, uid, startdate, enddate):
    if enddate is None:
        promotion = select_query(cursor,
                                 'with Temp as '
                                 '(select pid, startDate, endDate, percent, maxAmount, fid, uid '
                                 'from promotions join percentage using(pid) '
                                 'join promotes p using(pid) '
                                 'join manages m '
                                 'on (p.rid is null or p.rid = m.rid) '
                                 'where uid = %s) '
                                 ''
                                 'select pid, startDate, endDate, percent, maxAmount, mana.rid, count(*), sum(price), max(orderTime), min(orderTime) '
                                 'from Temp t, orders o, menu m, manages mana '
                                 'where mana.uid = t.uid '
                                 'and mana.rid = o.rid and '
                                 'mana.rid = m.rid and '
                                 'm.fid = o.fid and '
                                 'case '
                                 'when t.fid is not null then o.fid = t.fid '
                                 'else true '
                                 'end '
                                 'and date(orderTime) >= %s '
                                 'group by (pid, startDate, endDate, percent, maxAmount, mana.rid);',
                                 (uid, startdate))
    else:
        promotion = select_query(cursor,
                                 'with Temp as '
                                 '(select pid, startDate, endDate, percent, maxAmount, fid, uid '
                                 'from promotions join percentage using(pid) '
                                 'join promotes p using(pid) '
                                 'join manages m '
                                 'on (p.rid is null or p.rid = m.rid) '
                                 'where uid = %s) '
                                 ''
                                 'select pid, startDate, endDate, percent, maxAmount, mana.rid, count(*), sum(price), max(orderTime), min(orderTime) '
                                 'from Temp t, orders o, menu m, manages mana '
                                 'where mana.uid = t.uid '
                                 'and mana.rid = o.rid and '
                                 'mana.rid = m.rid and '
                                 'm.fid = o.fid and '
                                 'case '
                                 'when t.fid is not null then o.fid = t.fid '
                                 'else true '
                                 'end '
                                 'and date(orderTime) >= %s and date(orderTime) <= %s '
                                 'group by (pid, startDate, endDate, percent, maxAmount, mana.rid);',
                                 (uid, startdate, enddate))
    return [
        {
            'type': 'percentage promotion',
            'pid': item[0],
            'startDate': item[1].strftime('%d/%m/%Y'),
            'endTime': item[2].strftime('%d/%m/%Y'),
            'percentage': item[3],
            'maxAmount': item[4],
            'rid': item[5],
            'no. of orders': item[6],
            'orders per day': item[6] / ((item[8] - item[9]).days + 1),
            'total price': item[7],
        } for item in promotion
    ]


def summary(cursor, startdate, enddate, username):
    uid = select_query(cursor,
                       'select uid from users where username = %s;',
                       (username,))[0][0]
    flat_promotion = get_flat(cursor, uid, startdate, enddate)
    percentage_promotion = get_percentage(cursor, uid, startdate, enddate)
    return flat_promotion + percentage_promotion
