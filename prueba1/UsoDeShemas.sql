--- creacion de schemas cobros

create schema cobros;

create table cobros.users(
idUser int not null,
nameuser nvarchar not null,
edaduser int not null
);

--- creacion de schemas ventas
create schema ventas;
create table ventas.users(
idUser int not null,
nameuser nvarchar not null,
edaduser int not null
);

--- eliminar una tabla de una schema especifica
drop table ventas.users;

select * from ventas.users

