from database import select_query


def summary(cursor, startdate, enddate):
    if enddate is None:
        all_food = select_query(cursor,
                                'select pid, startDate, endDate, rid, fid, count(*), sum(price) '
                                'from promotions join promotes using(pid) '
                                'join orders using(rid, fid) '
                                'join menu using(rid, fid)'
                                'group by (pid, startDate, endDate, rid, fid, orderTime) '
                                'having date(orderTime) >= %s;', (startdate,))
    else:
        all_food = select_query(cursor,
                                'select pid, startDate, endDate, rid, fid, count(*), sum(price) '
                                'from promotions join promotes using(pid) '
                                'join orders using(rid, fid) '
                                'join menu using(rid, fid)'
                                'group by (pid, startDate, endDate, rid, fid, orderTime) '
                                'having date(orderTime) >= %s and date(orderTime) <= %s;', (startdate, enddate))
    return [{
        'pid': item[0],
        'startDate': item[1].strftime('%d/%m/%Y'),
        'endTime': item[2].strftime('%d/%m/%Y'),
        'rid': item[3],
        'fid': item[4],
        'no. of orders': item[5],
        'orders per day': item[5] / (item[2] - item[1]).days,
        'total price': item[6],
    } for item in all_food]
