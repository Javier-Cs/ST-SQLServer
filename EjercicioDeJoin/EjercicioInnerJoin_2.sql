--- 2
-- Productos Vendidos: Lista el Nombre_producto de todos los productos
-- que han sido comprados en algún pedido.
-- Asegúrate de que cada producto aparezca solo una vez.
select * from practica.Clientes_tbl
select * from practica.Productos_tbl
select * from practica.Pedido_tbl
select * from practica.DetallesPedido_tbl

select distinct
    ProductoId as "id producto",
    Nombre_producto as "nombre del producto"
from practica.Productos_tbl  as pro
    inner join practica.DetallesPedido_tbl dePedi
    on pro.ProductoId = dePedi.Producto_Id