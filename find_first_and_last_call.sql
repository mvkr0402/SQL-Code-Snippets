create table phonelog (Callerid int, Recipientid int, Datecalled datetime);

insert into phonelog (Callerid, Recipientid, Datecalled)
values (1, 2, '2019-01-01 09:00:00.000'), (1, 3, '2019-01-01 17:00:00.000'), (1, 4, '2019-01-01 23:00:00.000'), (2, 5, '2019-07-05 09:00:00.000'), (2, 3, '2019-07-05 17:00:00.000'), (2, 3, '2019-07-05 17:20:00.000'), (2, 5, '2019-07-05 23:00:00.000'), (2, 3, '2019-08-01 09:00:00.000'), (2, 3, '2019-08-01 17:00:00.000'), (2, 5, '2019-08-01 19:30:00.000'), (2, 4, '2019-08-02 09:00:00.000'), (2, 5, '2019-08-02 10:00:00.000'), (2, 5, '2019-08-02 10:45:00.000'), (2, 4, '2019-08-02 11:00:00.000');

with calls
as (
	select CALLERID, DATECALLED::date called_date, min(Datecalled) first_call, max(Datecalled) last_call
	from phonelog
	group by 1, 2
	)
select c.*, p1.Recipientid first_call, p2.Recipientid last_call
from calls c
inner join phonelog p1 on c.CALLERID = p1.CALLERID and c.first_call = p1.DATECALLED
inner join phonelog p2 on c.CALLERID = p2.CALLERID and c.last_call = p2.DATECALLED
where p1.Recipientid = p2.Recipientid
