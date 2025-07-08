--- verificamos si existe la base de datos mediante el if
--- si no existe(buscamos la base de datos cuando el nombre sea 'TiendaOnline_DB' )
if not exists (select * from sys.databases where name = 'TiendaOnline_DB')
-- si no existe generamo la base de datos
begin
create database Tiendaonline_DB;
end;

--- uso de la base de datos
use Tiendaonline_DB
go

create schema practica
    go

--- creacion de la tabla
create table practica.Clientes_tbl(
    ClienteId int not null identity(1,1),
    Nombre nvarchar(40) not null,
    Apellido nvarchar(40) not null,
    Email nvarchar(40) unique not null,
    Fecha_Registro date default getDate(),
    Activo bit default 1,
    constraint Pk_ClienteId primary key (ClienteId)
)
go
drop table practica.Clientes_tbl;


create table practica.Productos_tbl(
    ProductoId int identity(1,1),
    Nombre_producto nvarchar(50) not null,
    descrpcion_producto nvarchar(200) not null,
    precio decimal(10,2) not null,
    stock int not null,
    categoria nvarchar(20) not null,
    Fecha_actualizacion Datetime default getdate(),
    constraint PK_ProductoId primary key(ProductoId),
)
    go
drop table practica.Productos_tbl;


create table practica.Pedido_tbl(
    PedidoId int identity(1,1),
    Cliente_id int not null,
    FechaPedido datetime default getdate(),
    Estado nvarchar(20) default 'Pendiente',
    Total decimal(10,2) not null,
    constraint PK_PedidoId primary key(PedidoId),
    constraint FK_Cliente_id foreign key(Cliente_id)
    references practica.Clientes_tbl(ClienteId)
)
    go
drop table practica.Pedido_tbl


create table practica.DetallesPedido_tbl(
    DetalleId int identity(1,1),
    Pedido_Id int not null,
    Producto_Id int not null,
    Cantidad int not null,
    PrecioUnitario decimal(10,2) not null,

    constraint FK_Pedido_Id foreign key(Pedido_Id)
        references practica.Pedido_tbl(PedidoId),

    constraint FK_Producto_Id foreign key(Producto_Id)
        references practica.Productos_tbl(ProductoId)
)
    go
drop table practica.DetallesPedido_tbl




-- Insertar datos de ejemplo
INSERT INTO practica.Clientes_tbl (Nombre, Apellido, Email, Fecha_Registro, Activo) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', '2023-01-15', 1),
('María', 'Gómez', 'maria.gomez@example.com', '2023-02-20', 1),
('Carlos', 'López', 'carlos.lopez@example.com', '2023-03-10', 0),
('Ana', 'Díaz', 'ana.diaz@example.com', '2023-04-05', 1),
('Pedro', 'Ruiz', 'pedro.ruiz@example.com', '2023-05-12', 1),
('Laura', 'Martínez', 'laura.martinez@example.com', '2023-06-01', 1);



INSERT INTO practica.Productos_tbl (Nombre_producto, descrpcion_producto, precio, stock, categoria) VALUES
('Laptop Gamer X1', 'Potente laptop para juegos de última generación', 1200.00, 50, 'Electrónica'),
('Teclado Mecánico RGB', 'Teclado retroiluminado con switches mecánicos', 75.50, 120, 'Accesorios'),
('Ratón Inalámbrico Pro', 'Ratón ergonómico de alta precisión', 40.00, 200, 'Accesorios'),
('Monitor Curvo 27"', 'Monitor con resolución 4K y 144Hz', 350.00, 30, 'Electrónica'),
('Disco SSD 1TB', 'Unidad de estado sólido de alta velocidad', 90.00, 150, 'Componentes'),
('Webcam Full HD', 'Webcam con micrófono integrado', 25.00, 80, 'Accesorios'),
('Silla Gamer Ergonómica', 'Silla cómoda para largas sesiones de juego', 180.00, 40, 'Muebles');


INSERT INTO practica.Pedido_tbl (Cliente_id, FechaPedido, Estado, Total) VALUES
(1, '2023-06-20 10:30:00', 'Enviado', 1275.50),
(2, '2023-06-22 14:00:00', 'Pendiente', 40.00),
(1, '2023-07-01 09:15:00', 'Entregado', 350.00),
(4, '2023-07-05 11:45:00', 'Pendiente', 90.00),
(5, '2023-07-07 16:00:00', 'Cancelado', 25.00),
(2, '2023-07-08 10:00:00', 'Pendiente', 255.50); -- Nuevo pedido para María

INSERT INTO practica.DetallesPedido_tbl (Pedido_Id, Producto_Id, Cantidad, PrecioUnitario) VALUES
(1, 1, 1, 1200.00), -- Laptop Gamer
(1, 2, 1, 75.50),   -- Teclado Mecánico
(2, 3, 1, 40.00),   -- Ratón Inalámbrico
(3, 4, 1, 350.00),  -- Monitor Curvo
(4, 5, 1, 90.00),   -- Disco SSD
(5, 6, 1, 25.00),   -- Webcam Full HD
(6, 7, 1, 180.00),   -- Silla Gamer
(6, 2, 1, 75.50);    -- Teclado Mecánico