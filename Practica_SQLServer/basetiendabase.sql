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

