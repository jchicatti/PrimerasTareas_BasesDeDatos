		
		--Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
CREATE VIEW payment_interval
AS (
with p as(
	select c.customer_id, max(p.payment_date) as latest, min(p.payment_date) as oldest
	from customer c join payment p on c.customer_id=p.customer_id
	group by c.customer_id
), ct as (
	select p2.customer_id, count(*) as totPays from payment p2 group by p2.customer_id
)
select p.customer_id, concat(c.first_name, ' ', c.last_name) as client,
age(p.latest,p.oldest)/ct.totPays as avg_interval
from p p join ct ct on p.customer_id=ct.customer_id join customer c on ct.customer_id=c.customer_id
order by c.customer_id
);



		--Sigue una distribución normal?
CREATE VIEW payment_interval_numeric
AS (
	with p as(
	select c.customer_id, max(p.payment_date) as latest, min(p.payment_date) as oldest
	from customer c join payment p on c.customer_id=p.customer_id
	group by c.customer_id order by c.customer_id
	), ct as (
		select p2.customer_id, count(*) as totPays from payment p2 group by p2.customer_id
	)
	select p.customer_id, concat(c.first_name, ' ', c.last_name) as client,
	extract(epoch from (age(p.latest,p.oldest)/ct.totPays)) as avg_interval
	from p p join ct ct on p.customer_id=ct.customer_id join customer c on ct.customer_id=c.customer_id
	order by c.customer_id
);


select * from histogram('payment_interval_numeric','avg_interval'); --R: No es normal


		--Qué tanto difiere ese promedio del tiempo entre rentas por cliente?
CREATE VIEW order_interval
AS (
	with p as(
		select c.customer_id, max(r.rental_date) as latest, min(r.rental_date) as oldest
		from customer c join rental r on c.customer_id=r.customer_id
		group by c.customer_id order by c.customer_id
	), ct as (
		select r2.customer_id, count(*) as totRents from rental r2 group by r2.customer_id order by r2.customer_id
	)
	select p.customer_id, concat(c.first_name, ' ', c.last_name) as client,
	age(p.latest,p.oldest)/ct.totRents as avg_interval
	from p p join ct ct on p.customer_id=ct.customer_id join customer c on ct.customer_id=c.customer_id
	order by c.customer_id
);


select oi.customer_id, concat(c.first_name, ' ', c.last_name) as client,
(oi.avg_interval-pa.avg_interval) as diferencia
from order_interval oi join
payment_interval pa on oi.customer_id=pa.customer_id join customer c on pa.customer_id=c.customer_id;



