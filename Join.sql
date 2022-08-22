--  ## NULL SAFE Join ##

create table tableA(colA int);
create table tableB(ColB int);
insert into tableA(colA) values(1),(2),(1),(5),(NULL),(NULL) ;
insert into tableB(colB) values(NULL),(2),(5),(5);

#null safe join . . Include nulls in join

select a.*,b.* from tableA a
inner join tableB b
on a.colA = b.colB
or
(a.colA is null and b.colB is null)

#using Snowflake function 
select a.*,b.* from tableA a
inner join tableB b
on equal_null(a.colA,b.colB)
