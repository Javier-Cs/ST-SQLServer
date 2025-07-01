-- manera normal de implementar un PK
create table user_TBl(
    iduser int not null,
    nombre varchar(15) not null,
    edad int not null,
    constraint PK_user primary key (iduser)
);


--- agregar un PK si la tabla ya fue creada o tiene datos
create table user_TBl(
    iduser int not null,
    nombre varchar(15) not null,
    edad int not null
);
--- esto siempre funcinara si el campo al que quieres establecera como PK no permite NULL
alter table user_TBl
add constraint PK_user primary key (iduser);




--- establecer como unique a un campo si la tabla ya fue creada o tiene datos
create table user_TBl(
    iduser int not null,
    nombre varchar(15) not null,
    edad int not null
);

alter table user_TBl
add constraint UQ_user unique (iduser);