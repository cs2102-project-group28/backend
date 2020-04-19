from database import select_query
import time


def month_summary(cursor, month, year):
    all_order = select_query(cursor,
                             'select count(*), sum(price), sum(deliverCost) '
                             'from orders join menu using(rid, fid) '
                             'join delivers using(oid) '
                             'where (select extract(month from orderTime)) = %s '
                             'and (select extract(year from orderTime)) = %s;',
                             (month, year))[0]
    user_order_in_month = select_query(cursor,
                                       'select distinct cid '
                                       'from orders '
                                       'where (select extract(month from orderTime)) = %s '
                                       'and (select extract(year from orderTime)) = %s;',
                                       (month, year))
    user_ids = tuple([item[0] for item in user_order_in_month])
    user_summary = select_query(cursor,
                                'select cid, count(*), sum(price), sum(deliverCost) '
                                'from orders join menu using(rid, fid) '
                                'join delivers using(oid) '
                                'where (select extract(month from orderTime)) = %s '
                                'and (select extract(year from orderTime)) = %s '
                                'group by (cid) '
                                'having cid in %s;',
                                (month, year, user_ids))
    ret = {
        'no. of orders': all_order[0],
        'total price': all_order[1] + all_order[2],
        'user': [
            {
                'cid': item[0],
                'no. of orders': item[1],
                'total price': item[2] + item[3]
            }
            for item in user_summary
        ]
    }
    return ret


def order_summary(cursor, area, day, starttime, endtime):
    data = select_query(cursor,
                        'select oid, orderTime, rName, fName, cid '
                        'from orders o join delivers d using(oid) '
                        'join restaurants using(rid) '
                        'join foodItems using(fid) '
                        'where d.location = %s '
                        'and date(orderTime) = %s and (select orderTime::time) >= %s '
                        'and (select orderTime::time) <= %s;',
                        (area, day, starttime, endtime))
    ret = [
        {
            'oid': item[0],
            'orderTime': item[1],
            'rName': item[2],
            'fName': item[3],
            'uid': item[4]
        }
        for item in data
    ]
    return {
        'no. of order': len(ret),
        'order': ret
    }


def part_time_summary(cursor, month, year):
    data = select_query(cursor,
                        'with '
                        'RiderRating as '
                        '(select uid, count(*) as numRating, sum(rating) as totalRating, '
                        '(select extract(month from orderTime)) as month, '
                        '(select extract(year from orderTime)) as year '
                        'from delivers join parttimeriders using(uid) '
                        'join orders using(oid) '
                        'where rating is not null '
                        'group by uid, month, year), '
                        ''
                        'RiderOrder as '
                        '(select uid, count(*) as numOrder, '
                        '(select extract(month from orderTime)) as month, '
                        '(select extract(year from orderTime)) as year '
                        'from delivers join parttimeriders using(uid) '
                        'join orders using(oid) '
                        'group by uid, month, year), '
                        ''
                        'RiderWork as '
                        '(select uid, psalary, '
                        'sum(EXTRACT(HOUR FROM endTime) - EXTRACT(HOUR FROM startTime)) as totalTime '
                        'from parttimeriders join riders using(uid) '
                        'join weeklyworks using(uid) '
                        'join schedules using(sid) '
                        'group by uid, psalary), '
                        ''
                        'RiderDeliver as '
                        '(select uid, sum(completeTime - departTime) as deliverTime '
                        'from delivers '
                        'group by (uid))'
                        ''
                        'select uid, numRating, totalRating, numOrder, psalary, totalTime, deliverTime '
                        'from RiderRating right join RiderOrder '
                        'using(uid, month, year) '
                        'join RiderWork using(uid) '
                        'join RiderDeliver using(uid) '
                        'where month = %s and year = %s;',
                        (month, year,))
    return [
        {
            'type': 'part time',
            'uid': item[0],
            'no. rating': (item[1] if item[1] else 0),
            'average rating': item[2] / item[1] if item[1] else None,
            'no. order': item[3],
            'salary': item[4],
            'total time': item[5],
            'average deliver time': str(time.strftime('%H:%M:%S', time.gmtime(round((item[6] / item[3]).total_seconds()))))
        }
        for item in data
    ]


def full_time_summary(cursor, month, year):
    data = select_query(cursor,
                        'with '
                        'RiderRating as '
                        '(select uid, count(*) as numRating, sum(rating) as totalRating, '
                        '(select extract(month from orderTime)) as month, '
                        '(select extract(year from orderTime)) as year '
                        'from delivers join fulltimeriders using(uid) '
                        'join orders using(oid) '
                        'where rating is not null '
                        'group by uid, month, year), '
                        ''
                        'RiderOrder as '
                        '(select uid, count(*) as numOrder, '
                        '(select extract(month from orderTime)) as month, '
                        '(select extract(year from orderTime)) as year '
                        'from delivers join fulltimeriders using(uid) '
                        'join orders using(oid) '
                        'group by uid, month, year), '
                        ''
                        'RiderWork as '
                        '(select uid, fsalary, '
                        'sum(EXTRACT(HOUR FROM endTime) - EXTRACT(HOUR FROM startTime)) as totalTime '
                        'from fulltimeriders join riders using(uid) '
                        'join monthlyworks using(uid) '
                        'join schedules using(sid) '
                        'group by uid, fsalary), '
                        ''
                        'RiderDeliver as '
                        '(select uid, sum(completeTime - departTime) as deliverTime '
                        'from delivers '
                        'group by (uid))'
                        ''
                        'select uid, numRating, totalRating, numOrder, fsalary, totalTime, deliverTime '
                        'from RiderRating right join RiderOrder '
                        'using(uid, month, year) '
                        'join RiderWork using(uid) '
                        'join RiderDeliver using(uid) '
                        'where month = %s and year = %s;',
                        (month, year,))
    return [
        {
            'type': 'full time',
            'uid': item[0],
            'no. rating': (item[1] if item[1] else 0),
            'average rating': item[2] / item[1] if item[1] else None,
            'no. order': item[3],
            'salary': item[4],
            'total time': item[5],
            'average deliver time': str(time.strftime('%H:%M:%S', time.gmtime(round((item[6] / item[3]).total_seconds()))))
        }
        for item in data
    ]


def rider_summary(cursor, month, year):
    part_time = part_time_summary(cursor, month, year)
    full_time = full_time_summary(cursor, month, year)
    return {
        'part time': part_time,
        'full time': full_time
    }
