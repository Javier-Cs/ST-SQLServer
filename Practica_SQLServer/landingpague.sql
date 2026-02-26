CREATE DATABASE legumfrutsadb;
USE legumfrutsadb;

CREATE TABLE empresas(
    id_empresa INT PRIMARY KEY CHECK (id_empresa = 1),
    nombre_empresa VARCHAR(100) NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    ruc CHAR(13) NOT NULL UNIQUE,
    tipo_contribuyente VARCHAR(30),
    direccion VARCHAR(200),
    provincia VARCHAR(50),
    telefono VARCHAR(20),
    email_empresa VARCHAR(100),
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    aux1 VARCHAR(100),
    aux2 VARCHAR(100),
    aux3 VARCHAR(100)
);


CREATE TABLE sucursales (
    id_sucursal INT IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    estado BIT DEFAULT 1,
    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)
);

CREATE TABLE cajas (
    id_caja INT IDENTITY PRIMARY KEY,
    id_sucursal INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    estado BIT DEFAULT 1,
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

CREATE TABLE usuarios(
    id_user int identity(1,1) PRIMARY KEY,
    id_sucursal INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(70) NOT NULL,
    pass_hash VARCHAR(255)NOT NULL,
    cedula CHAR(10),
    num_telefono VARCHAR(15),
    rol VARCHAR(20) NOT NULL CHECK(rol IN ('ADMIN','CAJERO','SUPERVISOR')),
    estado BIT DEFAULT 1,
    is_deleted BIT NOT NULL DEFAULT 0,
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    aux1 VARCHAR(100),
    aux2 VARCHAR(100),
    aux3 VARCHAR(100),
    CONSTRAINT fk_empresa
        FOREIGN KEY(id_sucursal)
        REFERENCES empresas(id_sucursal)
);



CREATE TABLE clientes (
    id_cliente     INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa     INT NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(20),
    cedula_ruc          CHAR(13),
    email          VARCHAR(100),
    tipo           VARCHAR(50),
    estado         BIT DEFAULT 1,
    is_deleted     BIT NOT NULL DEFAULT 0,
    fecha_creacion  DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    aux1 VARCHAR(100),
    aux2 VARCHAR(100),
    aux3 VARCHAR(100),

    CONSTRAINT fk_cliente_empresa
        FOREIGN KEY (id_empresa)
            REFERENCES empresas(id_empresa)
);

CREATE TABLE ventas (
    id_venta           INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente         INT NOT NULL,
    id_sucursal        INT NOT NULL,
    id_caja            INT NOT NULL,
    id_usuario         INT NOT NULL,
    tipo_venta         VARCHAR(20),
    estado_venta       VARCHAR(20) DEFAULT 'COMPLETADA',
    efectivo_recibido  DECIMAL(18,2) NOT NULL,
    monto_total_Venta  DECIMAL(18,2) NOT NULL,
    monto_vuelto       DECIMAL(18,2) NOT NULL,
    fecha_venta        DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    row_version ROWVERSION,
    aux1 VARCHAR(100),
    aux2 VARCHAR(100),
    aux3 VARCHAR(100),

    CONSTRAINT fk_ventas_clientes
        FOREIGN KEY (id_cliente)
            REFERENCES clientes(id_cliente),

    CONSTRAINT fk_ventas_sucursal
        FOREIGN KEY (id_sucursal)
            REFERENCES sucursales(id_sucursal),

    CONSTRAINT fk_ventas_usuario
        FOREIGN KEY (id_usuario)
            REFERENCES usuarios(id_user),

    CONSTRAINT CK_ventas_montos_validos
        CHECK (monto_total_Venta >= 0 AND efectivo_recibido >= 0 AND monto_vuelto >= 0)
);

CREATE TABLE productos(
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    bodigo_barras VARCHAR(50) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    estado BIT DEFAULT 1,
    categoria VARCHAR(30) NOT NULL,
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    precio_unitario DECIMAL(18,2) NOT NULL,
    precio_mayor DECIMAL(18,2) NOT NULL,
    tiene_iva BIT DEFAULT 1,
    iva DECIMAL(5,2) NOT NULL,
    CONSTRAINT fk_productos_empresa
        FOREIGN KEY (id_empresa)
            REFERENCES empresas(id_empresa)
);


CREATE TABLE detalle_venta(
    id_detalleVenta INT IDENTITY(1,1) PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,

    cantidad INT NOT NULL,
    precio_unitario DECIMAL(18,2) NOT NULL,
    subtotal DECIMAL(18,2) NOT NULL,
    descuento DECIMAL(18,2) NOT NULL,
    valor_total DECIMAL(18,2) NOT NULL,

    CONSTRAINT fk_detalle_venta_venta
        FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),

    CONSTRAINT fk_detalle_venta_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)

);

CREATE TABLE inventario (
    id INT IDENTITY,
    id_sucursal INT NOT NULL,
    id_producto INT NOT NULL,

    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT DEFAULT 0,
    row_version ROWVERSION,

    fecha_actualizacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    PRIMARY KEY (id_sucursal, id_producto),
    CONSTRAINT fk_inventario_sucursal
        FOREIGN KEY (id_sucursal) REFERENCES inventario(id_sucursal ),

    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto),

    CONSTRAINT cK_INVENTARIO_STOCK_NO_NEHGATIVO
        CHECK ( stock >= 0 )
);


CREATE TABLE ventas_historial (
    id_historial INT IDENTITY PRIMARY KEY,
    id_venta INT NOT NULL,
    id_usuario_modificacion INT NOT NULL,
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    monto_total_anterior DECIMAL(18,2),
    monto_total_nuevo DECIMAL(18,2),
    datos_anteriores NVARCHAR(MAX),
    CONSTRAINT fk_historial_venta FOREIGN KEY(id_venta) REFERENCES ventas(id_venta)
);



CREATE TABLE movimientos_inventario (
    id_movimiento INT IDENTITY PRIMARY KEY,
    id_sucursal INT NOT NULL,
    id_producto INT NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('VENTA','COMPRA','AJUSTE','TRANSFERENCIA')),
    cantidad INT NOT NULL,
    referencia VARCHAR(100),
    fecha DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);







--- implementacion de indice para busqueda de empresas
CREATE INDEX IX_empresas_nombre
ON empresas(nombre_empresa);



CREATE INDEX IX_clientes_empresa_nombre
ON clientes(id_empresa, nombre);

--- index para productos
CREATE INDEX IX_productos_empresa
ON productos(id_empresa);

CREATE INDEX IX_productos_empresa_categoria
ON productos(id_empresa, categoria);


--- index para ventas
CREATE INDEX IX_venta_empresa_usuario
ON ventas(id_empresa, id_usuario);

CREATE INDEX IX_ventas_empresa_cliente
ON ventas(id_empresa, id_cliente);


--- index para detalle venta
CREATE INDEX IX_detalle_producto_venta
    ON detalle_venta(id_producto, id_venta);


----
CREATE INDEX IX_ventas_dashboard
    ON ventas(id_empresa, fecha_venta)
    INCLUDE (monto_total_Venta, id_usuario);

---
CREATE UNIQUE INDEX IX_productos_empresa_codigo
ON productos(id_empresa, bodigo_barras);

---




ALTER TABLE detalle_venta
ALTER COLUMN precio_unitario DECIMAL(18,2) NOT NULL;



ALTER TABLE clientes ADD is_deleted BIT NOT NULL DEFAULT 0;
ALTER TABLE productos ADD is_deleted BIT NOT NULL DEFAULT 0;
ALTER TABLE ventas ADD is_deleted BIT NOT NULL DEFAULT 0;


