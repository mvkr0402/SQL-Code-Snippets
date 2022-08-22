--- Fill the blank values in the table

create table brands 
(
category varchar(20),
brand_name varchar(20)
);
insert into brands values
('chocolates','5-star')
,(null,'dairy milk')
,(null,'perk')
,(null,'eclair')
,('Biscuits','britannia')
,(null,'good day')
,(null,'boost');


--over(order by (select null)) used to generate the row number in the same order as data
with cte1 as (
select *,row_number() over(order by (select null)) rn from brands)

, cte2 as (
select *,lead(rn,1,9999) over (order by rn) as next_rn from cte1 where CATEGORY is not null)

select cte2.CATEGORY,cte1.BRAND_NAME from cte1 
inner join cte2 on cte1.rn >= cte2.rn and cte1.rn <= cte2.next_rn-1
-- inner join cte2 on cte1.rn >= cte2.rn and (cte1.rn <= cte2.next_rn-1 or cte2.next_rn is null) -- if we dont want to use max num in lead to fill nulls

