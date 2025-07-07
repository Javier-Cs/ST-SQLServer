select * from clientes

--- obtenemos los valores que terminen en a
select * from clientes
where nombre like '%a'

--- obtenemos los valores que inician en a
select * from clientes
where nombre like 'a%'

--- obtenemos los valores que inician en a y terminen en e
select * from clientes
where nombre like 'a%e'

--- obtenemos los valores que contengan una a en cualquier parte
select * from clientes
where nombre like '%a%'

--- obtenemos los valores que contenga una a como segundo caracter
select * from clientes
where nombre like '_a%'