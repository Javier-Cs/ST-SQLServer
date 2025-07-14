-- #4
-- Clientes que Compraron el Producto 'Teclado Mecánico RGB':
-- Descripción: Identifica el Nombre y Apellido de todos los clientes
-- que han comprado el producto con el Nombre_producto 'Teclado Mecánico RGB'.
-- Cada cliente debe aparecer una única vez.
--
-- Tablas involucradas: practica.Clientes_tbl,
-- practica.Pedido_tbl, practica.DetallesPedido_tbl, practica.Productos_tbl.

select * from practica.Clientes_tbl
select * from practica.Productos_tbl
select * from practica.Pedido_tbl
select * from practica.DetallesPedido_tbl


select
    clit.Nombre, Apellido as "Nombres completos del cliente",
    prod.Nombre_producto as "Nombre del producto comprado"
from practica.Clientes_tbl as clit

inner join practica.Pedido_tbl as ped
on clit.ClienteId = ped.Cliente_id

inner join practica.DetallesPedido_tbl as detPed
on ped.PedidoId = detPed.Pedido_Id

inner join practica.Productos_tbl as prod
on detPed.Producto_Id = prod.ProductoId
where prod.Nombre_producto = 'Teclado Mecánico RGB'