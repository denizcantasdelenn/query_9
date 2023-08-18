--find for each seller, if the brand of the second item (by date) they sold is their favorite brand.
--if a seller sold less than two items, report the answer fr that seller as 'no'.

create table users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

 --select * from orders
 --select * from users
 --select * from items

 with _second_item_seller as (
 select item_id, seller_id
 from (
 select *, 
 rank() over(partition by seller_id order by order_date) as second_sold_flag
 from orders)  A
 where second_sold_flag = 2)
 , second_is_favorite as (
 select u.user_id
 from _second_item_seller s
 inner join users u on s.seller_id = u.user_id
 inner join items i on s.item_id = i.item_id
 where u.favorite_brand = i.item_brand)
 , matched as (
 select *, 
 case when sf.user_id is null then 'No' else 'Yes' end as matched_flag
 from  orders o
 left join second_is_favorite sf on o.buyer_id = sf.user_id)

 select buyer_id, matched_flag
 from matched
 group by buyer_id, matched_flag



