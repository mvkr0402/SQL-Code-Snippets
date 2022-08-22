--Solution 1
SELECT * FROM Employee WHERE sal = 
         (
            SELECT MIN(sal) FROM Employee 
            WHERE  sal IN (
                                 SELECT DISTINCT TOP N
                                     sal FROM Employee 
                                         ORDER BY sal DESC
                             )
        );
--Solution 2

With cte as
(select * from Employee order by salary desc limit N)
select * from cte order by salary asc limit 1;

--Solution 3

with cte as 
(select salary , dense_rank() over(order by salary desc) as r
from Employee)
select * from cte where r = N;
