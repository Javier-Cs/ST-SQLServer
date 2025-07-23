
if not exists(select * from sys.databases where name = 'PORTAFOLIO_WEB_DB')
begin
CREATE DATABASE PORTAFOLIO_WEB_DB;
end;


USE PORTAFOLIO_WEB_DB;
go;


CREATE SCHEMA webP
    go;

--|HOME|------------------------------------
create table webP.home_tbl(
    idHome int primary key identity(1,1),
    presentHome nvarchar(100) NOT NULL,
    tituloHome nvarchar(100) NOT NULL,
    contextoHomeb nvarchar(max) NOT NULL
);

create table webP.tecnolMaxUso_tbl(
    id_tecno int primary key identity(1,1),
    imagen_tecno nvarchar(100) NOT NULL,
    titulo_tecno nvarchar(20) NOT NULL
);

create table webP.fraseRandom_tbl(
    id_frase int primary key identity(1,1),
    frase nvarchar(400) NOT NULL
);




--|CV|------------------------------------
create table webP.contextCv_tbl(
    id_contxtCv int primary key identity(1,1),
    titulo_cv nvarchar(30) NOT NULL,
    contxt_cv nvarchar(max) NOT NULL
);

create table webP.experiencia_tbl(
    id_experi int primary key identity(1,1),
    titl_experi nvarchar(200) NOT NULL,
    tiemp_experi nvarchar(200) NOT NULL,
    contxt_experi nvarchar(max) NOT NULL
);

create table webP.skillsUso_tbl(
    id_skill int primary key identity(1,1),
    imagen_skill nvarchar(100) NOT NULL,
    titulo_skill nvarchar(20) NOT NULL
);




--|PROYECTOS|------------------------------------
create table webP.project_tbl(
    id_projct int primary key identity(1,1),
    titul_projct nvarchar(100) NOT NULL,
    descrip_projct nvarchar(600) NOT NULL,
    contxt_projct nvarchar(max) NOT NULL,
    reposi_projct nvarchar(100) NOT NULL,
    imagen_projct nvarchar(200) NOT NULL
);

create table webP.project_skills_tbl(
    id_project int NOT NULL,
    id_skills int NOT NULL,
    primary key(id_project, id_skills),
    foreign key(id_project) references webP.project_tbl(id_projct) on delete cascade,
    foreign key(id_skills) references webP.skillsUso_tbl(id_skill) on delete cascade,
);




--|BLOG|------------------------------------



--|CONTACTO|------------------------------------
create table webP.contct_tbl(
    id_contact int primary key identity(1,1),
    nmbre_contct nvarchar(30) NOT NULL,
    url_contct nvarchar(30) NOT NULL,
    img_contct nvarchar(100) NOT NULL
);



--|USER|------------------------------------
CREATE TABLE webP.users_tbl (
    id_user int primary key identity(1,1),
    username NVARCHAR(50) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    enabled BIT DEFAULT 1
);


--|roles|------------------------------------

create table webP.roles_tbl(
    id_rol int identity(1,1) not null,
    nombre nvarchar(50) not null,
    constraint UQ_nombre_rol unique(nombre),
    constraint PK_id_rol primary key(id_rol)
);



--|roles de usuarios|------------------------------------
create table user_rol_tbl(
    id_rol int not null,
    id_user int not null,
    primary key (id_rol, id_user),
    constraint FK_id_rol foreign key(id_rol) references webP.roles_tbl(id_rol),
    constraint FK_id_user foreign key(id_user) references webP.users_tbl(id_user),
);
