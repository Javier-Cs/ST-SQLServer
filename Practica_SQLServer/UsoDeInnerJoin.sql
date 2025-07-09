if not exists(select * from sys.databases where name = 'TestJoin_db')
begin
create database TestJoin_db
end

use TestJoin_db
go

create schema Test
    go

CREATE TABLE Test.Departamentos
(
    Id int,
    Nombre varchar(20)
);

CREATE TABLE Test.Empleados
(
    Nombre varchar(20),
    DepartamentoId int
);

INSERT INTO Test.Departamentos VALUES(31, 'Sales');
INSERT INTO Test.Departamentos VALUES(33, 'Engineering');
INSERT INTO Test.Departamentos VALUES(34, 'Clerical');
INSERT INTO Test.Departamentos VALUES(35, 'Marketing');

INSERT INTO Test.Empleados VALUES('Rafferty', 31);
INSERT INTO Test.Empleados VALUES('Jones', 33);
INSERT INTO Test.Empleados VALUES('Heisenberg', 33);
INSERT INTO Test.Empleados VALUES('Robinson', 34);
INSERT INTO Test.Empleados VALUES('Smith', 34);
INSERT INTO Test.Empleados VALUES('Williams', NULL);


SELECT * FROM Test.Empleados;
SELECT * FROM Test.Departamentos;

--- uso de INNER JOIN

---
select *
from Test.Empleados e
join Test.Departamentos d
--- obtenemos los registros que tengan un id similar en las tablas
on e.DepartamentoId = d.Id



--- uso de INNER JOIN
-- seleccionando registros espesificos  y dandoles un alias
---
select
e.Nombre as 'Empleado',
d.Nombre as 'Departamento'
from Test.Empleados e

join Test.Departamentos d
on e.DepartamentoId = d.Id