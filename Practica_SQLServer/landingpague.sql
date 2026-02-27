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
    id_empresa INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    estado BIT DEFAULT 1,
    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)
);

CREATE TABLE cajas (
    id_caja INT IDENTITY(1,1),
    id_sucursal INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    estado BIT DEFAULT 1,
    CONSTRAINT PRIMARY KEY (id_sucursal, id_caja),
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
    CONSTRAINT PRIMARY KEY (id_user, id_sucursal),
    CONSTRAINT fk_sucursal
        FOREIGN KEY(id_sucursal)
        REFERENCES sucursales(id_sucursal)
);



CREATE TABLE clientes (
    id_cliente     INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa    INT NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(20),
    cedula_ruc          CHAR(13),
    email          VARCHAR(100),
    tipo           VARCHAR(50),
    estado         BIT DEFAULT 1,
    is_deleted     BIT NOT NULL DEFAULT 0,
    fecha_creacion  DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    limite_credito DECIMAL(18,2) NOT NULL DEFAULT 0,
    saldo_credito_actual DECIMAL(18,2) NOT NULL DEFAULT 0,
    dias_credito INT NOT NULL DEFAULT 0,
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
    tipo_venta         VARCHAR(20) NOT NULL CHECK (tipo_venta IN ('CONTADO','CREDITO')),
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

    CONSTRAINT fk_ventas_usuario_sucursal
        FOREIGN KEY (id_usuario, id_sucursal)
            REFERENCES usuarios(id_user, id_sucursal),

    CONSTRAINT fk_caja_sucursal
        FOREIGN KEY (id_caja, id_sucursal)
            REFERENCES cajas(id_caja, id_sucursal),

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
    iva DECIMAL(5,2) NOT NULL
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
        FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal ),

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



CREATE TABLE cuentas_por_cobrar (
    id_cuenta INT IDENTITY PRIMARY KEY,
    id_venta INT NOT NULL,
    id_cliente INT NOT NULL,
    saldo_inicial DECIMAL(18,2) NOT NULL,
    saldo_actual DECIMAL(18,2) NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('PENDIENTE','PAGADA','VENCIDA')),
    fecha_creacion DATETIME2 DEFAULT GETUTCDATE(),
    fecha_vencimiento DATETIME2 NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CHECK (saldo_actual >= 0)
);


CREATE TABLE pagos_credito (
    id_pago INT IDENTITY PRIMARY KEY,
    id_cuenta INT NOT NULL,
    monto DECIMAL(18,2) NOT NULL,
    fecha_pago DATETIME2 DEFAULT GETUTCDATE(),
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_cuenta) REFERENCES cuentas_por_cobrar(id_cuenta),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_user),
    CHECK (monto > 0)
);

CREATE INDEX IX_cuentas_venta
    ON cuentas_por_cobrar(id_venta);

CREATE UNIQUE INDEX UX_cuentas_por_venta
    ON cuentas_por_cobrar(id_venta);

CREATE INDEX IX_cuentas_cliente_saldo
    ON cuentas_por_cobrar(id_cliente, saldo_actual);

CREATE INDEX IX_cuentas_estado
    ON cuentas_por_cobrar(estado);


