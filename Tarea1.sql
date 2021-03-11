--1. Cómo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campaña?

select concat(c.first_name, ' ', c.last_name), c.email from customer c
join address a using (address_id) join city c2 using (city_id) join country c3 using (country_id)
where c3.country='Canada';

--2. Qué cliente ha rentado más de nuestra sección de adultos

select c.customer_id, concat(c.first_name, ' ', c.last_name) as full_name, count(c.customer_id) as veces from customer c
join rental r using (customer_id) join inventory i using (inventory_id) join film f using (film_id) --join film_category fc using (film_id) join category c2 using (category_id)
where f.rating in ('R','NC-17') group by c.customer_id order by veces desc limit 2;

--3. Qué películas son las más rentadas en todas nuestras stores?

	--Simple/Total/Lo que se pide:
	select f.title, count(f.film_id) as veces from film f
	join inventory i using (film_id) join rental r using (inventory_id)
	group by f.title order by veces desc;
	
	--Nos muestra la MÁS rentada POR CADA store
	select distinct on (s.store_id) s.store_id, f.title, count(f.film_id) as veces
	from film f join inventory i using (film_id) join rental r using (inventory_id) join store s using (store_id)
	group by f.title,s.store_id order by s.store_id, veces desc;
	
	--Forma tabular para los contadores:
	select f.title, s.store_id, count(f.film_id) as veces from film f join inventory i using (film_id) join rental r using (inventory_id) join store s using (store_id)
	group by cube(f.title,s.store_id) order by f.title, veces desc;

--4. Cuál es nuestro revenue por store?'

select s.store_id, sum(p.amount) as total from store s
join inventory i using (store_id) join rental r using (inventory_id) join payment p using (rental_id)
group by s.store_id;