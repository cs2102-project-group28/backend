import time

from database import select_query


def summary(cursor, username, month, year):
    uid = select_query(cursor,
                       'select uid from users where username = %s;', (username,))[0][0]
    is_full_time = len(select_query(cursor,
                                    'select 1 '
                                    'from fulltimeriders '
                                    'where uid = %s;', (uid,))) > 0
    if is_full_time:
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
                            'where month = %s and year = %s and uid = %s;',
                            (month, year, uid))[0]
        return {
                'type': 'full time',
                'uid': data[0],
                'no. rating': (data[1] if data[1] else 0),
                'average rating': data[2] / data[1] if data[1] else None,
                'no. order': data[3],
                'salary': data[4] * 4,
                'total time': data[5] * 4,
                'average deliver time': str(
                    time.strftime('%H:%M:%S', time.gmtime(round((data[6] / data[3]).total_seconds()))))
            }
    else:
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
                            'where month = %s and year = %s and uid = %s;',
                            (month, year, uid))[0]
        return {
            'type': 'part time',
            'uid': data[0],
            'no. rating': (data[1] if data[1] else 0),
            'average rating': data[2] / data[1] if data[1] else None,
            'no. order': data[3],
            'salary': data[4] * 4,
            'total time': data[5],
            'average deliver time':
                str(time.strftime('%H:%M:%S', time.gmtime(round((data[6] / data[3]).total_seconds()))))
        }
