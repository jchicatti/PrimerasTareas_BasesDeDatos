--Tarea

-- Hay dos interpretaciones para lo que plantea el problema como una delta mensual.
--A) El cambio en las cantidades que lleva pagando el cliente en todo lo que lleva de ser nuestro cliente y desglosar ese desarrollo por mes.
--B) Cuanto cambia lo que paga nuestro cliente en un mismo mes y sólo en ese mes. Y desglosar eso para cada mes.

												--A
-- Si optamos por la solución A que es la que me pareció más lógica y a la que se refiere el problema:
with deltas_monto as (
	select o.order_id,
	o.customer_id as cliente,
	o.order_date as fecha,
	sum(od.quantity*od.unit_price) as monto,
	lag(sum(od.quantity*od.unit_price),1,(0)::float) over w as monto_tmenos1,
	(sum(od.quantity*od.unit_price)-lag(sum(od.quantity*od.unit_price),1,(0)::float) over w) as delta
	from orders o join order_details od using (order_id) group by o.order_id
	window w as (partition by customer_id order by order_date)
	)
select cliente,
extract(year from fecha) as anio,
extract(month from fecha) as mes,
avg(delta) as prom_deltas
from deltas_monto group by anio,cliente, mes order by cliente, anio, mes;

--Si nos queremos poner meta podemos sacar el promedio de los promedios de las deltas.
--Obtenemos un numero que nos dice el lifetime value TOTAL por cliente.
create view meta_deltas as (
	with deltas_monto as (
		select o.order_id,
		o.customer_id as cliente,
		o.order_date as fecha,
		sum(od.quantity*od.unit_price) as monto,
		lag(sum(od.quantity*od.unit_price),1,(0)::float) over w as monto_tmenos1,
		(sum(od.quantity*od.unit_price)-lag(sum(od.quantity*od.unit_price),1,(0)::float) over w) as delta
		from orders o join order_details od using (order_id) group by o.order_id
		window w as (partition by customer_id order by order_date)
	)
	select cliente,
	extract(year from fecha) as anio,
	extract(month from fecha) as mes,
	avg(delta) as prom_deltas
	from deltas_monto group by anio, cliente, mes order by cliente, anio, mes
);
--Obtenemos así a los clientes que tenemos que cuidar más:
select cliente, avg(prom_deltas) as total_delta from meta_deltas
group by cliente having avg(prom_deltas)>0 order by avg(prom_deltas) desc;




						--B
--Si hacemos borron y cuenta nueva de la delta del cliente en cada mes la tabla se ve diferente
--La mayoría no hace mas de una compra por mes y esto hace que las deltas se vuelvan grandes pues solo se cuenta esa única compra.
--En este caso pues no nos dice muchísimo.
with deltas_monto as (
	select o.order_id,
	o.customer_id as cliente,
	o.order_date as fecha,
	sum(od.quantity*od.unit_price) as monto,
	lag(sum(od.quantity*od.unit_price),1,(0)::float) over w as monto_tmenos1,
	(sum(od.quantity*od.unit_price)-lag(sum(od.quantity*od.unit_price),1,(0)::float) over w) as delta
	from orders o join order_details od using (order_id) group by o.order_id
	window w as (partition by customer_id, extract(year from o.order_date),
	extract(month from o.order_date) order by order_date)
)
select cliente,
extract(year from fecha) as anio,
extract(month from fecha) as mes,
avg(delta) as prom_deltas
from deltas_monto group by anio, cliente, mes order by cliente, anio, mes;

create view meta_deltas2 as (
	with deltas_monto as (
		select o.order_id,
		o.customer_id as cliente,
		o.order_date as fecha,
		sum(od.quantity*od.unit_price) as monto,
		lag(sum(od.quantity*od.unit_price),1,(0)::float) over w as monto_tmenos1,
		(sum(od.quantity*od.unit_price)-lag(sum(od.quantity*od.unit_price),1,(0)::float) over w) as delta
		from orders o join order_details od using (order_id) group by o.order_id
		window w as (partition by customer_id, extract(year from o.order_date),
		extract(month from o.order_date) order by order_date)
	)
	select cliente,
	extract(year from fecha) as anio,
	extract(month from fecha) as mes,
	avg(delta) as prom_deltas
	from deltas_monto group by anio, cliente, mes order by cliente, anio, mes
);

--Aquí sacar un average no nos da un buen panorama de como están nuestros clientes.
select cliente, avg(prom_deltas) as total_deltas from meta_deltas2
group by cliente order by avg(prom_deltas) desc;