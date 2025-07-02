CREATE DATABASE PORTAFOLIO_WEB_DB;
USE PORTAFOLIO_WEB_DB;

--|HOME|------------------------------------
create table home_tbl(
idHome int primary key identity(1,1),
presentHome nvarchar(100) NOT NULL,
tituloHome nvarchar(100) NOT NULL,
contextoHomeb nvarchar(max) NOT NULL
);

create table tecnolMaxUso_tbl(
id_tecno int primary key identity(1,1),
imagen_tecno nvarchar(100) NOT NULL,
titulo_tecno nvarchar(20) NOT NULL
);

create table fraseRandom_tbl(
id_frase int primary key identity(1,1),
frase nvarchar(400) NOT NULL
);