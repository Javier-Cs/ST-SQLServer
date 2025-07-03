--- base de datos de prueba conexion a astro
create database pruebaAstro_db;
use pruebaAstro_db
create table formulario_TBL(
    idform int identity(1,1) not null,
    nombre nvarchar(80) not null,
    correo nvarchar(90) not null unique,
    mensaje nvarchar(max) not null,
    constraint PK_idform primary key(idform)
);