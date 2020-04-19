from database import select_query


def month_summary(cursor, month, year):
    all_order = select_query(cursor,
                             'select count(*), sum(price), sum(deliverCost) '
                             'from orders join menu using(rid, fid) '
                             'join delivers using(oid) '
                             'where (select extract(month from orderTime)) = %s '
                             'and (select extract(year from orderTime)) = %s;',
                             (month, year))[0]
    user_order_in_month = select_query(cursor,
                                       'select cid '
                                       'from orders '
                                       'where (select extract(month from orderTime)) = %s '
                                       'and (select extract(year from orderTime)) = %s;',
                                       (month, year))
    user_ids = tuple([item[0] for item in user_order_in_month])
    user_summary = select_query(cursor,
                                'select cid, count(*), sum(price), sum(deliverCost) '
                                'from orders join menu using(rid, fid) '
                                'join delivers using(oid) '
                                'group by (cid) '
                                'having (select extract(month from orderTime)) = %s '
                                'and (select extract(year from orderTime)) = %s;'
                                'and cid in %s;',
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


def order_summary(cursor, area, starttime, endtime):
    data = select_query(cursor,
                        'select oid '
                        'from orders join delivers '
                        'using(oid) '
                        'where location = %s '
                        'and orderTime >= %s and orderTime <= %s;',
                        (area, starttime, endtime))
    return data


def part_time_summary(cursor, month, year):
    data = select_query(cursor,
                        'with '
                        'RiderRating as '
                        '(select uid, count(*) as numRating, sum(rating) as totalRating, '
                        '(select extract(month from orderTime)) as month, '
                        '(select extract(year from orderTime)) as year '
                        'from delivers join parttimeriders using(uid) '
                        'join orders using(uid) '
                        'group by uid, month, year '
                        'having rating is not null), '
                        ''
                        'RiderOrder as '
                        '(select uid, count(*) as numOrder, '
                        '(select extract(month from orderTime)) as month, '
                        '(select extract(year from orderTime)) as year '
                        'from delivers join parttimeriders using(uid) '
                        'join orders using(uid) '
                        'group by uid, month, year), '
                        ''
                        'RiderWork as '
                        '(select uid, salary, '
                        'sum(EXTRACT(HOUR FROM endTime) - EXTRACT(HOUR FROM startTime)) as totalTime '
                        'from parttimeriders join riders using(uid) '
                        'join weeklywork using(uid) '
                        'join schedules using(sid) '
                        'group by uid, salary) '
                        ''
                        'select * '
                        'from RiderRating join RiderOrder using(uid, month, year) '
                        'join RiderWord using(uid) '
                        'where month = %s and year = %s;',
                        (month, year,))
    return [
        {
            'uid': item[0],
            'no. rating': item[1],
            'average rating': item[2] / item[1],
            'no. order': item[5],
            'salary': item[6],
            'total time': item[7],
        }
        for item in data
    ]


def rider_summary(cursor, month, year):
    part_time = part_time_summary(cursor, month, year)
    return part_time
