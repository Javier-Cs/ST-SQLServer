create table users_tbl(
idPersonas int not null,
nombre nvarchar(20) not null,
edad int not null,
--- implementamos un valor por defecto por medio del constraint default
ciudad nvarchar(30) default('No Tiene'),
);
--- permite y asigna el valor por defecto
insert into users_tbl values(2, 'Carla', 18, default);
insert into users_tbl values(3, 'Esther', 20);



-----------------------
create table users_tbl(
idPersonas int not null,
nombre nvarchar(20) not null,
edad int not null,
ciudad nvarchar(30),
);


--- como agregar un default a una tabla ya creada
alter table users_tbl
add constraint DF_ciudad
default 'No hay' for ciudad;


--- como eliminar un default
alter  table users_tbl
drop constraint DF_ciudad;