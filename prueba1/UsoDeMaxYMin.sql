select * from articulos
--- obtenemos el valor mas alto
select max(precio) as "valor mas caro" from articulos;
--- obtenemos el valor mas bajo
select min(precio) as "valor mas barato" from articulos;



select  max(precio) as "valor mas caro",
        min(precio) as "valor mas barato", nombre
from articulos;