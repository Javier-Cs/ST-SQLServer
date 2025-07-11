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



--- Ejercicio 1
--- Necesitas obtener el nombre y el apellido de todos los clientes que están activos y cuyo correo electrónico no sea nulo.
--- Además, los resultados deben estar ordenados alfabéticamente por el apellido y, si el apellido es el mismo, por el nombre.
--- Finalmente, solo muestra los primeros 3 clientes de la lista resultante.
--------------------------------------------------
select top(3) Nombre, Apellido from practica.Clientes_tbl
--- el Not Email = ´null´ -> busca los correos que tengan literalmente null como cadena de texto
---where  Activo = 1 and not Email = 'null'
where  Activo = 1 and Email is not null
order by Apellido asc;


--- Ejercicio 2
--- Muestra el nombre del producto, su precio y el stock disponible de todos aquellos
--- productos que pertenecen a la categoría 'Electrónica' o 'Accesorios',
--- y cuyo stock sea inferior a 100 unidades.
--- Los productos deben aparecer ordenados de menor a mayor precio.
--------------------------------------------------
select Nombre_Producto, precio, stock, categoria
from practica.Productos_tbl
--- con in selecionamos los valores especificos
where categoria in( 'Electrónica', 'Accesorios') and stock <100
order by precio asc


--- Ejercicio 3
-- Lista todos los pedidos que se encuentran en estado 'Pendiente'.
-- Para cada pedido, muestra el ID del pedido, la fecha del pedido
-- y el nombre completo del cliente que realizó ese pedido.
-- Incluye solo los pedidos de los clientes con ID 1, 2 o 4.
--------------------------------------------------
select * from practica.Pedido_tbl;

select
    p.PedidoId,
    p.FechaPedido,
    c.Nombre+' '+ c.Apellido as "Nombre cliente"

from practica.Pedido_tbl p
         inner join practica.Clientes_tbl c
                    on
                        p.Cliente_id = c.ClienteId
where Estado ='Pendiente' and p.Cliente_id in(1,2,4)


--- Ejercicio 4
-- Ha habido una actualización de inventario y de descripciones.
-- Actualiza el stock del producto 'Laptop Gamer X1' para que sea 45.
-- Actualiza el precio y la descripción del producto 'Teclado Mecánico RGB'.
-- Su nuevo precio debe ser 80.00 y
-- su descripción debe ser: 'Teclado mecánico retroiluminado de alta gama con switches Cherry MX'.
--------------------------------------------------

select * from practica.Productos_tbl

update practica.Productos_tbl set stock = 45
where Nombre_producto = 'Laptop Gamer X1'

update practica.Productos_tbl
set precio = 80.00, descrpcion_producto = 'Teclado mecánico retroiluminado de alta gama con switches Cherry MX'
where Nombre_producto = 'Teclado Mecánico RGB'


--- Ejercicio 5
-- Encuentra el nombre y apellido de todos los clientes que NO han realizado ningún pedido hasta la fecha.
-- Identifica los nombres de los productos que nunca han sido parte de ningún pedido.
--------------------------------------------------
select * from practica.Clientes_tbl
select * from practica.Productos_tbl
select * from practica.Pedido_tbl
select * from practica.DetallesPedido_tbl

select
    C.Nombre as 'nombre',
    C.Apellido as 'apellido'

from practica.Clientes_tbl as C
left join practica.Pedido_tbl as P
on C.ClienteId = P.Cliente_id
where P.PedidoId is null


select
    P.Nombre_producto as 'Nombre de los productos sin pedido'
from
    practica.Productos_tbl as P
        left join
    practica.DetallesPedido_tbl as DP
    on
        P.ProductoId = DP.Producto_Id
where DP.DetalleId is null;


--- Ejercicio 5
-- Identifica y elimina de la tabla Clientes a todos aquellos clientes que están marcados como inactivos (Activo = 0) y que,
-- además, no tienen ningún pedido registrado en la tabla Pedidos.
-- Ten mucho cuidado con esta operación y asegúrate de entender lo que haces.
--------------------------------------------------
select * from practica.Clientes_tbl
select * from practica.Productos_tbl
select * from practica.Pedido_tbl
select * from practica.DetallesPedido_tbl


delete C
from  practica.Clientes_tbl as C
left  join practica.Pedido_tbl as P
on
C.ClienteId = P.Cliente_id
where P.PedidoId is null and Activo = 0

---- opcion 2

delete from practica.Clientes_tbl
where Activo = 0
  and
    not exists(
        select 1
        from practica.Pedido_tbl
        where Cliente_id = practica.Clientes_tbl.ClienteId
    );



--- Ejercicio 7
-- Inserta un nuevo producto en la tabla Productos
-- Inserta un nuevo pedido para la cliente 'Laura Martínez' (deberás encontrar su ClienteID).
--------------------------------------------------
select * from practica.Clientes_tbl
select * from practica.Productos_tbl
select * from practica.Pedido_tbl
select * from practica.DetallesPedido_tbl


    insert into practica.Productos_tbl
values( 'Auriculares Gaming Pro','Auriculares con sonido envolvente 7.1', 95.00, 70, 'Audio', GETDATE());

insert into practica.Pedido_tbl
values(6, GETDATE(), 'Pendiente',0);

insert into practica.DetallesPedido_tbl
values(8, 8, 1,95.00);




-- parte 1
-- obteniendo el id dinamicamente para pedido y detalle pedido
insert into practica.Productos_tbl
values( 'Monitor Gaming Pro','Auriculares con sonido envolvente 7.1', 95.00, 70, 'Audio', GETDATE());

-- obtener el id del producto que acabamos de insertar
Declare @nuevoIdProducto int;
-- scope_identity() devuelve el ultimo id de la entidad creado actualmente
set @nuevoIdProducto = SCOPE_IDENTITY();
-- imprimimos el id obtenido
print 'id del producto nuevo ' + cast(@nuevoIdProducto as nvarchar(10));

-- parte 2
-- obtenemos el id de laura
declare @idLaura int;
select @idLaura = ClienteId
from practica.Clientes_tbl
where Nombre = 'Laura' and Apellido = 'Martínez'
    print 'id: ' + cast(@idLaura as nvarchar(5));