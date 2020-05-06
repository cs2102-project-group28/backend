import time
from datetime import datetime

from database import select_query, update_query, transaction


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


def set_deliver_depart_time(connection, cursor, username, oid):
    now = datetime.now()
    update_query(connection, cursor,
                 'update delivers '
                 'set departTime = %s '
                 'where oid = %s and uid = ('
                 'select uid from users where username = %s);',
                 (now, oid, username))


def set_deliver_complete_time(connection, cursor, username, oid):
    now = datetime.now()
    update_query(connection, cursor,
                 'update delivers '
                 'set completeTime = %s '
                 'where oid = %s and uid = ('
                 'select uid from users where username = %s);',
                 (now, oid, username))


def add_schedule_part_time(username, sid):
    insert_format = 'insert into WeeklyWorks (uid, sid) values {}'\
        .format(','
                .join(['((select uid from users where username = %s), %s)'] * len(sid)))
    arr = []
    for item in sid:
        arr += [username, int(item)]
    transaction(insert_format, tuple(arr))


def delete_schedule_part_time(connection, cursor, username, sid):
    sid = tuple([int(item) for item in sid])
    update_query(connection, cursor,
                 'delete from WeeklyWorks '
                 'where uid = (select uid from users where username = %s) and sid in %s;', (username, sid))


def add_schedule_full_time(connection, cursor, username, startday, endday, shift):
    day = []
    if startday < endday:
        for i in range(startday, endday + 1):
            day.append(i)
    else:
        for i in range(startday, 8):
            day.append(i)
        for i in range(1, endday + 1):
            day.append(i)
    for i in range(len(day)):
        sid_morning = (day[i] - 1) * 8 + shift
        sid_afternoon = (day[i] - 1) * 8 + shift + 4
        update_query(connection, cursor,
                     'insert into MonthlyWorks (uid, sid) '
                     'values '
                     '((select uid from users where username = %s), %s), '
                     '((select uid from users where username = %s), %s);', (username, sid_morning, username, sid_afternoon))
