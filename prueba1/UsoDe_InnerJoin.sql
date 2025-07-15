if not exists(select * from sys.databases where name = 'Joins_db')
begin
create database Joins_db
end;

use Joins_db

/* borrar antigua tabla de clientes*/
drop table joins.ordenes;

create schema joins

    create table joins.clientes (
        idcliente int not null primary key,
        nombre varchar(20) not null,
        apellido varchar(30) not null,
        direccion varchar(100) not null,
        ciudad varchar(50) not null,
        telefono numeric(10) null,
    );

INSERT INTO joins.clientes (idcliente, nombre, apellido, direccion, ciudad, telefono)
VALUES
    (1, 'Juan', 'Pérez', 'Calle 123', 'Ciudad A', 1234567890),
    (2, 'María', 'González', 'Avenida 456', 'Ciudad B', 2345678901),
    (3, 'Pedro', 'López', 'Calle Principal', 'Ciudad C', 3456789012),
    (4, 'Laura', 'Martínez', 'Avenida Central', 'Ciudad A', 4567890123),
    (5, 'Carlos', 'Hernández', 'Calle 789', 'Ciudad B', 5678901234),
    (6, 'Ana', 'Sánchez', 'Avenida Secundaria', 'Ciudad C', 6789012345),
    (7, 'Luis', 'Rodríguez', 'Calle 321', 'Ciudad A', 7890123456),
    (8, 'Sofía', 'Fernández', 'Avenida 654', 'Ciudad B', 8901234567),
    (9, 'Andrés', 'Gómez', 'Calle Secundaria', 'Ciudad C', 9012345678),
    (10, 'Marta', 'Torres', 'Avenida Principal', 'Ciudad A', 1234567890),
    (11, 'Alejandro', 'Vargas', 'Calle Central', 'Ciudad B', 2345678901),
    (12, 'Patricia', 'Ortega', 'Avenida 123', 'Ciudad C', 3456789012),
    (13, 'Roberto', 'Jiménez', 'Calle 456', 'Ciudad A', 4567890123),
    (14, 'Elena', 'Ruíz', 'Avenida 789', 'Ciudad B', 5678901234),
    (15, 'Javier', 'Navarro', 'Calle Secundaria', 'Ciudad C', 6789012345),
    (16, 'Carolina', 'Lara', 'Avenida 321', 'Ciudad A', 7890123456),
    (17, 'Diego', 'Silva', 'Calle 654', 'Ciudad B', 8901234567),
    (18, 'Lucía', 'Romero', 'Avenida Central', 'Ciudad C', 9012345678),
    (19, 'Gabriel', 'Flores', 'Calle Principal', 'Ciudad A', 1234567890),
    (20, 'Valentina', 'Mendoza', 'Avenida Secundaria', 'Ciudad B', 2345678901),
    (21, 'Mario', 'López', 'Calle 789', 'Ciudad A', 3456789012),
    (22, 'Camila', 'García', 'Avenida 456', 'Ciudad B', 4567890123),
    (23, 'José', 'Hernández', 'Calle Principal', 'Ciudad C', 5678901234),
    (24, 'Isabel', 'Rojas', 'Avenida Central', 'Ciudad A', 6789012345),
    (25, 'Fernando', 'Gómez', 'Calle 123', 'Ciudad B', 7890123456),
    (26, 'Ana', 'Lara', 'Avenida Secundaria', 'Ciudad C', 8901234567),
    (27, 'Pedro', 'Fuentes', 'Calle 321', 'Ciudad A', 9012345678),
    (28, 'Sara', 'Martínez', 'Avenida 654', 'Ciudad B', 1234567890),
    (29, 'Gabriel', 'Sánchez', 'Calle Secundaria', 'Ciudad C', 2345678901),
    (30, 'Valeria', 'Ortega', 'Avenida Principal', 'Ciudad A', 3456789012),
    (31, 'Luisa', 'Vargas', 'Calle Central', 'Ciudad B', 4567890123),
    (32, 'Daniel', 'Silva', 'Avenida 123', 'Ciudad C', 5678901234),
    (33, 'Carolina', 'Torres', 'Calle 456', 'Ciudad A', 6789012345),
    (34, 'Andrés', 'Guzmán', 'Avenida 789', 'Ciudad B', 7890123456),
    (35, 'María', 'Romero', 'Calle Secundaria', 'Ciudad C', 8901234567),
    (36, 'Alejandro', 'Mendoza', 'Avenida 321', 'Ciudad A', 9012345678),
    (37, 'Valentina', 'Pérez', 'Calle 654', 'Ciudad B', 1234567890),
    (38, 'Roberto', 'Fernández', 'Avenida Central', 'Ciudad C', 2345678901),
    (39, 'Laura', 'González', 'Calle Principal', 'Ciudad A', 3456789012),
    (40, 'Javier', 'Soto', 'Avenida Secundaria', 'Ciudad B', 4567890123);

/* borrar antigua tabla de ordenes
   drop table ordenes*/


create table joins.ordenes(
                              id_orden int not null primary key,
                              idcliente int foreign key references joins.clientes(idcliente),
                              fecha_orden date default getdate(),
                              id_vendedor int not null
);

insert into joins.ordenes values(1, 1, '2020-01-12' ,1);
insert into joins.ordenes values(2, 2, '2021-03-20', 2);
insert into joins.ordenes values(3, 3, '2021-06-10', 3);
insert into joins.ordenes values(4, 4, '2021-09-05', 4);
insert into joins.ordenes values(5, 5, GETDATE(),5);
insert into joins.ordenes values(6, 1, '2022-02-28', 1);
insert into joins.ordenes values(7, 2, '2022-05-14', 2);
insert into joins.ordenes values(8, 3, '2022-07-29', 3);
insert into joins.ordenes values(9, 4, GETDATE(), 4);
insert into joins.ordenes values(10, 5, '2022-12-23', 5);
insert into joins.ordenes values(11, 1, '2023-02-14', 1);
insert into joins.ordenes values(12, 2, '2023-04-30', 2);
insert into joins.ordenes values(13, 3, GETDATE(), 3);
insert into joins.ordenes values(14, 4, '2023-09-28', 4);
insert into joins.ordenes values(15, 5, '2023-11-12', 5);
insert into joins.ordenes values(16, 1, '2023-02-05', 1);
insert into joins.ordenes values(17, 2, '2023-04-12', 2);
insert into joins.ordenes values(18, 3, '2023-07-20', 3);
insert into joins.ordenes values(19, 4, GETDATE(), 4);
insert into joins.ordenes values(20, 5, '2023-12-30', 5);
insert into joins.ordenes values(21, 1, '2021-01-15', 1);
insert into joins.ordenes values(22, 2, '2021-03-20', 2);
insert into joins.ordenes values(23, 3, '2021-06-10', 3);
insert into joins.ordenes values(24, 4, '2021-09-05', 4);
insert into joins.ordenes values(25, 5, GETDATE(), 5);
insert into joins.ordenes values(26, 1, '2022-02-28', 1);
insert into joins.ordenes values(27, 2, '2022-05-14', 2);
insert into joins.ordenes values(28, 3, '2022-07-29', 3);
insert into joins.ordenes values(29, 4, GETDATE(), 4);
insert into joins.ordenes values(30, 5, '2022-12-23', 5);
insert into joins.ordenes values(31, 1, '2023-02-14', 1);
insert into joins.ordenes values(32, 2, '2023-04-30', 2);
insert into joins.ordenes values(33, 3, GETDATE(), 3);
insert into joins.ordenes values(34, 4, '2023-09-28', 4);
insert into joins.ordenes values(35, 5, '2023-11-12', 5);
insert into joins.ordenes values(36, 1, '2023-02-05', 1);
insert into joins.ordenes values(37, 2, '2023-04-12', 2);
insert into joins.ordenes values(38, 3, '2023-07-20', 3);
insert into joins.ordenes values(39, 4, GETDATE(), 4);
insert into joins.ordenes values(40, 5, '2023-12-30', 5);


select * from joins.clientes
select * from joins.ordenes



--- uso de joins

--- uso de inner join

select ord.id_orden, ord.fecha_orden, client.nombre, client.apellido
FROM joins.ordenes as ord
inner join joins.clientes as client
on ord.idcliente = client.idcliente
where ord.fecha_orden > '2023-04-01'
go


-- uso de left join
select * from joins.clientes
select * from joins.ordenes

select cli.nombre, cli.apellido, ord.id_orden, ord.fecha_orden
from joins.clientes as cli
         left join joins.ordenes as ord
                   on  cli.idcliente = ord.idcliente
order by ord.id_orden
    go


-- uso de Right join
select ord.id_orden ,cli.nombre, cli.apellido
from joins.clientes as cli
         right join joins.ordenes as ord
                    on ord.idcliente = cli.idcliente
order by ord.id_orden
    go

select ord.id_orden ,cli.nombre, cli.apellido
from joins.ordenes as ord
         right join joins.clientes as cli
                    on ord.idcliente = cli.idcliente
order by ord.id_orden
    go

-- full join
select ord.id_orden, cli.nombre, cli.apellido,
       cli.telefono, cli.ciudad, ord.fecha_orden, ord.id_vendedor
from joins.ordenes as ord
         full join joins.clientes as cli
                   on ord.idcliente = cli.idcliente