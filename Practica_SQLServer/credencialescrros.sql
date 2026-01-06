create database ServiciosGenerales_db;
use ServiciosGenerales_db;


create table CredencialesCorreos(
    Credecod int identity(1,1) not null,
    nombre nvarchar(30) not null,
    email nvarchar(50) unique not null,
    pass nvarchar(40) not null,
    host nvarchar(40) not null,
    puerto int not null,
    usassl bit default 1,
    estado bit default 1,
    intervaloMinutos int not null,
    ultimoChequeo datetime
        constraint PK_CredeCode primary key(Credecod)
);

create table listaNegracorrs(
    Correocod int identity(1,1),
    corrsempresas nvarchar(50) not null,
    Credecod int not null,
    constraint PK_Correocod primary key(Correocod),
    constraint FK_Credecod_CredencialesCorreos foreign key(Credecod)
        references CredencialesCorreos(Credecod)
);