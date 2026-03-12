create database Legumfrutstore;
use Legumfrutstore;

CREATE TABLE clientes (
    id_cliente     INT IDENTITY(1,1) PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(20),
    email          VARCHAR(100),
    tipo           VARCHAR(50),
    estado         BIT DEFAULT 1,
    fecha_creacion  DATETIME DEFAULT GETDATE()
);

CREATE TABLE ventas (
    id_venta           INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente         INT NOT NULL,
    nombre_vendedor    VARCHAR(20),
    descripcion_venta  VARCHAR(300),
    tipo_venta         VARCHAR(20),
    estado_venta       VARCHAR(30) DEFAULT 'SIN DEFINIR',
    efectivo_recibido  DECIMAL(10,2) NOT NULL,
    monto_total_Venta  DECIMAL(10,2) NOT NULL,
    monto_vuelto       DECIMAL(10,2) NOT NULL,
    fecha_venta        DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_ventas_clientes
        FOREIGN KEY (id_cliente)
            REFERENCES clientes(id_cliente)
);



---- tabla de registro de pago
create table registro_pago_Ventas(
        id_pago int identity(1,1) primary key,
        fecha_pago datetime not null default DATEADD(HOUR, -5, GETUTCDATE()) ,
        id_clientef  int not null,
        ---id_ventaf int not null,

    --- estos datos serian del pago total de las ventas
        efectivo_recibido_del_pago decimal(10,2) not null,
        valor_a_pagar decimal(10,2) not null ,
        vuelto_de_deudas_Totales decimal(10,2) not null,
    constraint fk_clientes foreign key (id_clientef) references clientes(id_cliente),
    --constraint fk_ventas foreign key (id_clientef) references ventas(id_venta)
);


CREATE TABLE pago_ventas (
    id_pagof int not null,
    id_ventaf int not null,

    constraint pk_pago_ventas primary key (id_pagof, id_ventaf),
    constraint fk_pagoVenta_pago foreign key (id_pagof) REFERENCES registro_pago_Ventas(id_pago),
    constraint fk_pagoVenta_venta foreign key (id_ventaf) references ventas(id_venta)
);

create table Productos(
    ProductId int identity(1,1) not null,
    Code_barras NVARCHAR(50) not null,
    Nombre nvarchar(100) not null,
    Description nvarchar(max) not null,
    Precio decimal(10, 2) not null,
    PrecioVariable BIT DEFAULT 0,
    Fecha_creacion datetime default getdate(),
    IsActive bit default (1),
    constraint PK_ProductId primary key(ProductId)
);

CREATE TABLE detalle_venta(
    id_detalleVenta INT IDENTITY(1,1) PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL,
    precio_unitario DECIMAL(18,2) NOT NULL,
    subtotal DECIMAL(18,2) NOT NULL,
    descuento DECIMAL(18,2) NOT NULL,
    valor_total DECIMAL(18,2) NOT NULL,
    CONSTRAINT fk_detalle_venta_venta
        FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    CONSTRAINT fk_detalle_venta_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CHECK (subtotal = cantidad * precio_unitario),
    CHECK (valor_total = subtotal - descuento)
);


CREATE TABLE ventas (
    id_venta           INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente         INT NOT NULL,
    tipo_venta         VARCHAR(20) NOT NULL CHECK (tipo_venta IN ('CONTADO','CREDITO')),
    tipo_documento VARCHAR(20) NOT NULL DEFAULT 'VENTA'
        CHECK (tipo_documento IN ('VENTA','DEVOLUCION')),
    fecha_venta        DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    subtotal DECIMAL(18,2),
    descuento_total DECIMAL(18,2),
    total DECIMAL(18,2),
    estado VARCHAR(20) DEFAULT 'ABIERTA',
    row_version ROWVERSION,
    CHECK (tipo_documento IN ('VENTA','DEVOLUCION')),
    CONSTRAINT fk_ventas_clientes
        FOREIGN KEY (id_cliente)
            REFERENCES clientes(id_cliente)
);


CREATE UNIQUE INDEX IX_Productos_CodigoBarras
    ON Productos(Code_barras)
    WHERE Code_barras NULL;

CREATE INDEX IX_detalleVenta_venta
    ON detalle_venta(id_venta);

CREATE INDEX IX_detalleVenta_producto
    ON detalle_venta(id_producto);






------------------- CONSULTAS
select * from ventas
where estado_venta = 'deuda' and
    tipo_venta = 'credito'


select * from ventas
where estado_venta = @estadoventa and
    tipo_venta = @tipoventa

select  * From ventas where estado_venta = ''
    where id_venta = @idventa and
      estado_venta = @estadoventa and
      tipo_venta = @tipoventa


--- conulta para obtener los datos de la venta y el cliente
SELECT
    v.id_venta,
    v.nombre_vendedor,
    v.descripcion_venta,
    v.tipo_venta,
    v.estado_venta,
    v.efectivo_recibido,
    v.monto_total_Venta,
    v.monto_vuelto,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.telefono,
    c.email,
    c.tipo AS tipo_cliente,
    c.estado AS estado_cliente,
    c.fecha_creacion
FROM ventas v
         INNER JOIN clientes c
                    ON v.id_cliente = c.id_cliente;



--- ELIMINAR UN CLIENTE ESPECIFICO
DELETE FROM clientes
       WHERE id_cliente = 4;

--- ELIMINAR PRIMERO LA VENTA ANTES DE LÑ USUARIO
DELETE FROM ventas
WHERE id_cliente = 4;

DELETE FROM clientes
WHERE id_cliente = 4;

--- CAMBIAR ESTADO DE DE DEUDA
UPDATE ventas
SET estado_venta = 'PAGADO'
WHERE id_cliente = 4
  AND estado_venta = 'DEUDA';


-- CAMBIERE VENTA ESPECIFICA
UPDATE ventas
SET estado_venta = 'PAGADO'
WHERE id_venta = 10
  AND estado_venta = 'DEUDA';


drop table ventas;
drop table clientes;

---- delete from clientes where id_cliente = 4

UPDATE ventas
SET estado_venta = 'PAGADO'
WHERE id_venta = 7
  AND id_cliente = 1
  AND estado_venta = 'DEUDA'


    tipo_venta

UPDATE ventas
SET tipo_venta = 'CREDITO'
WHERE id_venta = 7
  AND tipo_venta = 'CONTADO'
