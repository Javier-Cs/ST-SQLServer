-- uso de distinct
use Tiendaonline_DB
go


select * from practica.Clientes_tbl
select * from practica.Productos_tbl
select * from practica.Pedido_tbl
select * from practica.DetallesPedido_tbl

-- obtener los id peretido
select Cliente_id, count(*) as cantidad
from practica.Pedido_tbl
group by Cliente_id;


-- obtener los cliente que tengan mas de un pedido
select distinct
    ClienteId as cli,
    Nombre as cli,
    Apellido as cli
-- uso de tabla cliente
from practica.Clientes_tbl as cli
-- uso de practica
inner join practica.Pedido_tbl as pe
-- comparación entre tablas
on cli.ClienteId = pe.Cliente_id;