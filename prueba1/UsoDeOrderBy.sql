select * from Empleados;

--- uso de order By
--- de forma acendente y decen
select * from Empleados order by EDAD;

select * from Empleados order by EDAD desc;

select * from Empleados order by idempleado;

select * from Empleados order by idempleado desc;

---  uso de order by y where
select EDAD from Empleados
where EDAD > 28
order by EDAD;

--- uso de distintos campos
select nombre, APELLIDO, EDAD , SALARIO
FROM Empleados
order by EDAD desc, SALARIO asc;

