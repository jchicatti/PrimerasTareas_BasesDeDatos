# Cilindros

Para darnos una primera idea es bueno saber primero de cuantas películas por tienda estamos hablando.<br>
Tambien puede ser util saber el volumen total necesario y el numero de cilindros minimos que debe haber considerando el peso total.
```
create view storage_data AS(
	select store_id, count(*) as totpelis, (count(*)*5040) as volumen_total,
	(count(*)*0.5) as peso_total, (count(*)*0.5/50) as num_cil_peso
	from inventory i group by store_id
);
select * from storage_data;
```
En este caso: <br>
![image](https://user-images.githubusercontent.com/56322123/114284602-9e41c300-9a16-11eb-9a4a-c8042088653c.png)

<br>Idealmente, queremos que cada cilindro se use a su maxima potencia.
Esto quiere decir, que contenga los 50kg que puede cargar. Se considera que esta carga es la carga libre disponible
y no incluye el material mismo del cilindro.
```
select 50/0.5;
```
Por lo tanto, cada cilindro debería ser diseñado para que albergue 100 películas.

Aquí esto se pone medio ingenieril porque no es eficiente acomodar rectángulos
dentro de un círculo de forma que todos puedan dar al exterior.

Como en este caso debemos tener mas de 20 cilindros por tienda, lo mejor es optimizar el volumen de los cilindros.

![plano1](https://user-images.githubusercontent.com/56322123/114284091-173f1b80-9a13-11eb-83c2-53180fc468e0.png)

Podemos tener 20 slots para películas en un nivel.

![case1](https://user-images.githubusercontent.com/56322123/114284121-553c3f80-9a13-11eb-8aa0-d811e0e9f71b.png)

Y hacer un cilindro con 5 niveles con el centro libre para albergar el mecanismo.

![tower1](https://user-images.githubusercontent.com/56322123/114284127-5bcab700-9a13-11eb-96eb-c6836ef17e7f.png)

Las dimensiones externas de cada cilindro son:<br><br>
55.4 cm de radio de la base.<br>
115 cm de alto.<br>

Para un total de:
```
select pi()*pow(55.4,2)*115;
```
1,108,835.8 centímetros cúbicos de volumen.<br><br>
O poco más de 1 metro cúbico.
