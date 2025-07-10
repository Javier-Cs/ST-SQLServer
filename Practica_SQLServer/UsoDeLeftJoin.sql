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

use TestJoin_db
go

SELECT * FROM Test.Empleados;
SELECT * FROM Test.Departamentos;

-- A diferencia de un INNER JOIN, donde se busca una intersección respetada por ambas tablas,
-- con LEFT JOIN damos prioridad a la tabla de la izquierda, y buscamos en la tabla derecha.
-- Si no existe ninguna coincidencia para alguna de las filas de la tabla de la izquierda,
-- de igual forma todos los resultados de la primera tabla se muestran.

select
E.Nombre as 'Empleado',
D.Nombre as 'Departamento'
-- definimos E para empleados
from Test.Empleados E
-- y D para departamentos
left join Test.Departamentos D
on E.DepartamentoId = D.Id