--- tabla principal o de referencia
create table Clientes_tbl(
    idCliente int not null ,
    nombre nvarchar(20) not null,
    apellido nvarchar(40) not null,
    eded int not null,
    constraint  Pk_clientes primary key (idCliente)
);


--- tabla hija
create table orden_tbl(
    idOrden int not null,
    articulo nvarchar(30) not null,
    id_cliente int not null,
    --- definicion de FK en la tabla a la tabla Clientes_tbl a isCliente
    constraint FK_ordenes_clientes foreign key references Clientes_tbl(idCliente)
);