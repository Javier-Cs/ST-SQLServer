create database MaestroDetalleDB;
use MaestroDetalleDB;


create table venta_tbl(
    id int primary key identity(1,1),
    fecha  datetime default getDate(),
    cliente nvarchar(100)
)

create table detalle_tbl(
    id int primary key identity(1,1),
    id_venta int,
    nombre nvarchar(50),
    cantidad int ,
    precio decimal(18,2),
--- para la relacion deben de tener el mismo tipo de dato
    constraint FK_ventaid foreign key (id_venta)
        references venta_tbl(id)
);

--- creamos un tipo
    CREATE TYPE Detail AS TABLE(
        Id int,
        Cantidad int,
        Nombre nvarchar(50),
        Precio decimal(18,2)
        primary key(Id)
    )


CREATE PROCEDURE Sp_Procedure
@Cliente Nvarchar(50),
@LstConceptos Detail READONLY
AS
BEGIN
    DECLARE @IdVenta int
    insert into venta_tbl(cliente, fecha) values(@Cliente, getDate())

    set @IdVenta = @@IDENTITY

    INSERT INTO detalle_tbl(nombre, cantidad, precio, id_venta)
            select Nombre, Cantidad, Precio, @IdVenta from @LstConceptos


END
GO