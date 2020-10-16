-- 16.10.2020 Day 10

use sakila;
select * from customer;

-- returns customer_id & city
select c.customer_id, ct.city from customer as c
join address on c.address_id = address.address_id
join city as ct on ct.city_id = address.city_id;

-- returns total amount paid by customer (checked)
select customer_id, sum(amount) from payment
group by customer_id;

select sum(amount) from payment 
where customer_id = 1;

-- returns most rented film category 


-- returns customer - name of category 
select r.customer_id, ct.name as category  from rental as r
join inventory as i on r.inventory_id = i.inventory_id
join film_category as fc on fc.film_id = i.film_id
join category as ct on ct.category_id = fc.category_id
order by r.customer_id;

-- calculate number of category per customer id 
select r.customer_id, ct.name as category, count(ct.name)  from rental as r
join inventory as i on r.inventory_id = i.inventory_id
join film_category as fc on fc.film_id = i.film_id
join category as ct on ct.category_id = fc.category_id
group by ct.name, r.customer_id
order by r.customer_id, count(ct.name) desc;

-- adding ranking column to the above
select r.customer_id as customer_id, ct.name as category, count(ct.name), 
dense_rank() over (partition by r.customer_id order by count(ct.name) desc) as ranking 
from rental as r
join inventory as i on r.inventory_id = i.inventory_id
join film_category as fc on fc.film_id = i.film_id
join category as ct on ct.category_id = fc.category_id
group by ct.name, r.customer_id
order by r.customer_id, count(ct.name) desc;

-- selecting where rank = 1
select customer_id, category from

(select r.customer_id as customer_id, ct.name as category, count(ct.name), 
dense_rank() over (partition by r.customer_id order by count(ct.name) desc) as ranking 
from rental as r
join inventory as i on r.inventory_id = i.inventory_id
join film_category as fc on fc.film_id = i.film_id
join category as ct on ct.category_id = fc.category_id
group by ct.name, r.customer_id
order by r.customer_id, count(ct.name) desc) as magic_table

where ranking = 1
order by customer_id;

-- ------------------------------------------------
--  how to keep only one record per customer 





(select count(distinct(customer_id)) from rental as lim);
-- -----------------------------------

-- returns total films rented by customer 

select customer_id, count(inventory_id) from rental 
group by customer_id;


-- returns how many films rented this month (15/05/2005 - 30/05/2005)
select customer_id, count(rental_id) as films from rental
where rental_date >= 20050515 and rental_date <= 20050530
group by customer_id
order by customer_id
;
#we have missing customers who haven't rented last month - we will need to extend it to all customers and add 0


-- returns whether or not a customer rented that month Y/N
# IF(condition, value_if_true, value_if_false)

select customer_id, if(films_rented > 1, 'YES', 'NO') as rent_this_month from
(select c.customer_id as customer_id, count(r.rental_id) as films_rented from rental as r
right outer join customer as c on      
r.customer_id = c.customer_id and 
r.rental_date >= 20050625 and r.rental_date <= 20050724 
group by c.customer_id 
order by c.customer_id) as magic_table
;
-- -----------------------------------------------------------------------------------


-- returns amount of films rented last month 
# last month - 25/05/2005 - 24/06/2005
select c.customer_id, count(r.rental_id) as films_rented from rental as r
right outer join customer as c on      
r.customer_id = c.customer_id and 
r.rental_date >= 20050525 and r.rental_date <= 20050624 
group by c.customer_id 
order by c.customer_id; -- ---------------------------------------------------------------------- 