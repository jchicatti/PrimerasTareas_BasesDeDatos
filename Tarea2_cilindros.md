Para darnos una primera idea. Es bueno saber primero
de cuantas películas por tienda estamos hablando.
Tambien puede ser util saber el volumen total necesario y
el numero de cilindros minimos que debe haber considerando el peso total.
```
create view storage_data AS(
	select store_id, count(*) as totpelis, (count(*)*5040) as volumen_total,
	(count(*)*0.5) as peso_total, (count(*)*0.5/50) as num_cil_peso
	from inventory i group by store_id
);
select * from storage_data;
```
Idealmente, queremos que cada cilindro se use a su maxima potencia.
Esto quiere decir, que contenga los 50kg que puede cargar.
```
select 50/0.5;
```
Por lo tanto, cada cilindro debería ser diseñado para que albergue 100 películas.

Aquí esto se pone medio ingenieril porque no es eficiente acomodar rectángulos
dentro de un círculo de forma que todos puedan dar al exterior.

Como en este caso debemos tener mas de 20 cilindros por tienda, lo mejor es optimizar el volumen de los cilindros.

![plano1](https://user-images.githubusercontent.com/56322123/114284091-173f1b80-9a13-11eb-83c2-53180fc468e0.png)

![case1](https://user-images.githubusercontent.com/56322123/114284121-553c3f80-9a13-11eb-8aa0-d811e0e9f71b.png)

![tower1](https://user-images.githubusercontent.com/56322123/114284127-5bcab700-9a13-11eb-96eb-c6836ef17e7f.png)
