-- #3
-- Detalles Completos de Pedidos con Productos de Alto Valor:
-- Descripción: Muestra el PedidoId, FechaPedido, Nombre del cliente, Nombre_producto, Cantidad y
-- PrecioUnitario para cada ítem en los pedidos donde el PrecioUnitario del producto
-- en ese detalle de pedido es superior a $100.00.
-- Tablas involucradas: practica.Pedido_tbl, practica.Clientes_tbl,
-- practica.DetallesPedido_tbl, practica.Productos_tbl.

select * from practica.Clientes_tbl
select * from practica.Productos_tbl
select * from practica.Pedido_tbl
select * from practica.DetallesPedido_tbl

select
--practica.Clientes_tbl.Nombre as "Nombre cliente",
--practica.Pedido_tbl.Cliente_id as "id del pedido",
--practica.Pedido_tbl.FechaPedido as "fecha de ingreso del pedido",
--practica.Productos_tbl.Nombre_producto as "Nombre del producto",
--practica.Productos_tbl.stock as "stock",
--practica.DetallesPedido_tbl.PrecioUnitario as "precio unitario"

cli.Nombre as "Nombre cliente",
ped.Cliente_id as "id del pedido",
ped.FechaPedido as "fecha de ingreso del pedido",
prod.Nombre_producto as "Nombre del producto",
prod.stock as "stock",
detpe.PrecioUnitario as "precio unitario"

from practica.Clientes_tbl as cli
         inner join
     practica.Pedido_tbl as ped
     on cli.ClienteId = ped.Cliente_id

         inner join
     practica.DetallesPedido_tbl as detpe
     on ped.PedidoId = detpe.Pedido_Id

         inner join
     practica.Productos_tbl as prod
     on detpe.Producto_Id = prod.ProductoId

where
    detpe.PrecioUnitario > 100.00