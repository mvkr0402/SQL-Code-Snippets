1) . Write a querey to find all numbers that appear at least three times consecutively?

table
id num
1  1
2  1
3  1
4  2
5  1
6  2
7  2

Result 
1

Ans) select a.num from table a
      left join 
    table b 
      on a.id = b.id+1 and a.num =b.num
     left join 
    table c
      on a.id  = c.id+2 and a.num = c.num;
