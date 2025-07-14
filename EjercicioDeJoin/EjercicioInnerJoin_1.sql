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

-- Mejora de ejercicio 1

select distinct
    clienteId as 'id',
    Nombre as 'nombre',
    Apellido as 'apellido',
    -- nombre de la tabla izquierda
from practica.Cliente_tbl as cli
    -- nombre de la tabla derecha
inner join practica.Pedido_Tbl as pedi
group by
    cli.clienteId, cli.Nombre, cli.Apellido
having
    -- si la cantidad es mayor a 1
    count(pedi.PedidoId) > 1;
