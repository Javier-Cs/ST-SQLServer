select * from Empleados
--- in para datos especificos
select * from Empleados where id_empleado in (1,3,5,6,7);

-- between para un rango determinado
select * from Empleados where id_empleado
between 1 and 7

select * from Empleados
where sueldo between 2000 and 3000;


select * from Empleados
where sueldo between 2000 and 2500
  and puesto not in ('asistente','Gerente');