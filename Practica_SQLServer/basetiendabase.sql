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


---- tabla de registro de pago
create  table(
        id_pago_deud int identity(1,1) primary key,
        fecha_pago datetime not null,
        nombre_cliente_deudor nvarchar(30) not null,
        nombre_vendedort nvarchar(49) not null,
        numero_ttal_ventas int not null,
        efectivo_recibido decimal(10,2) not null,
        valor_a_pagar decimal(10,2) not null ,
        vuelto_de_deuda decimal(10,2) not null
);









