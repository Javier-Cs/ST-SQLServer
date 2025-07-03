select * from Empleados

---implementacion de as alias y concatenacion

--- asignamos un alias de forma normal
select nombre as nombrempleado, APELLIDO as apellidos, EDAD as edad from Empleados;

--- asignamos un nombre de alias con espacios usando comillas dobles
select nombre as "Nombre empleado", APELLIDO as "Apellidos empleado", EDAD as "Edad empleado"
from Empleados;

--- concatenacion de valores
select nombre+' '+apellido as "nombre y apellido" from Empleados;
select nombre+' - '+apellido as "nombre y apellido" from Empleados;

select nombre+' '+apellido +' - '+
       cast(EDAD as varchar(3))as "nombre y apellido"
from Empleados;