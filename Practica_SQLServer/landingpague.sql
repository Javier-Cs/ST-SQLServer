CREATE DATABASE legumfrutsadb;
USE legumfrutsadb;

CREATE TABLE empresas(
    id_empresa INT PRIMARY KEY,
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
    id_caja INT IDENTITY(1,1) PRIMARY KEY,
    id_sucursal INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    estado BIT DEFAULT 1,
    CONSTRAINT FK_caja_sucursal
        FOREIGN KEY (id_sucursal)
            REFERENCES sucursales(id_sucursal)
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
    CONSTRAINT fk_sucursal
        FOREIGN KEY(id_sucursal)
            REFERENCES sucursales(id_sucursal)
);


CREATE TABLE aperturas_caja (
    id_apertura INT IDENTITY PRIMARY KEY,
    id_sucursal INT NOT NULL,
    id_caja INT NOT NULL,
    id_usuario INT NOT NULL,

    fecha_apertura DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    monto_inicial DECIMAL(18,2) NOT NULL,

    fecha_cierre DATETIME2 NULL,
    total_ventas DECIMAL(18,2) NULL,
    total_credito DECIMAL(18,2) NULL,
    total_efectivo_sistema DECIMAL(18,2) NULL,
    monto_fisico DECIMAL(18,2) NULL,
    diferencia DECIMAL(18,2) NULL,

    estado VARCHAR(20) NOT NULL DEFAULT 'ABIERTA'
        CHECK (estado IN ('ABIERTA','CERRADA')),

    FOREIGN KEY (id_caja)
        REFERENCES cajas(id_caja),

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_user),

    CHECK (
        (estado = 'ABIERTA' AND fecha_cierre IS NULL)
            OR
        (estado = 'CERRADA'
            AND fecha_cierre IS NOT NULL
            AND total_ventas IS NOT NULL
            AND total_efectivo_sistema IS NOT NULL)
        )
);

CREATE UNIQUE INDEX UX_caja_apertura_abierta
    ON aperturas_caja(id_caja, id_sucursal)
    WHERE estado = 'ABIERTA';


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
    fecha_eliminacion DATETIME2 NULL,
    id_usuario_eliminacion INT NULL,
    limite_credito DECIMAL(18,2) NOT NULL DEFAULT 0
        CHECK (limite_credito >= 0),
    dias_credito INT NOT NULL DEFAULT 0
        CHECK (dias_credito >= 0),
    aux1 VARCHAR(100),
    aux2 VARCHAR(100),
    aux3 VARCHAR(100),

    CONSTRAINT fk_cliente_empresa
        FOREIGN KEY (id_empresa)
            REFERENCES empresas(id_empresa),

    CONSTRAINT CK_clientes_softdelete
        CHECK (
            (is_deleted = 0 AND fecha_eliminacion IS NULL AND id_usuario_eliminacion IS NULL)
                OR
            (is_deleted = 1 AND fecha_eliminacion IS NOT NULL AND id_usuario_eliminacion IS NOT NULL)
            ),
    CONSTRAINT fK_cliente_usuario_eliminacion
        FOREIGN KEY (id_usuario_eliminacion)
            REFERENCES usuarios(id_user)
);

CREATE TABLE ventas (
    id_venta           INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente         INT NOT NULL,
    id_sucursal        INT NOT NULL,
    id_caja            INT NOT NULL,
    id_usuario         INT NOT NULL,
    id_apertura INT NOT NULL,

    tipo_venta         VARCHAR(20) NOT NULL CHECK (tipo_venta IN ('CONTADO','CREDITO')),
    tipo_documento VARCHAR(20) NOT NULL DEFAULT 'VENTA'
        CHECK (tipo_documento IN ('VENTA','DEVOLUCION')),

    fecha_venta        DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    id_venta_origen INT NULL,
    row_version ROWVERSION,

    CHECK (tipo_documento IN ('VENTA','DEVOLUCION')),

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

    CONSTRAINT fk_venta_caja
        FOREIGN KEY (id_caja)
            REFERENCES cajas(id_caja),

    CONSTRAINT FK_devolucion_venta
        FOREIGN KEY (id_venta_origen)
            REFERENCES ventas(id_venta),

    CONSTRAINT FK_aperturaCaja_venta
        FOREIGN KEY (id_apertura)
            REFERENCES aperturas_caja (id_apertura)

);

CREATE TABLE pagos_venta(
    id_ventaPago INT IDENTITY(1,1) PRIMARY KEY,
    id_venta INT NOT NULL,
    tipo_pago VARCHAR(15) NOT NULL
        CHECK (tipo_pago IN ( 'EFECTIVO','TARJETA','TRANSFERENCIA')),
    monto DECIMAL(18,2) NOT NULL,
    CONSTRAINT fk_id_venta
        FOREIGN KEY (id_venta)
            REFERENCES ventas(id_venta)
);

CREATE UNIQUE INDEX UX_devolucion_unica
    ON ventas(id_venta_origen)
    WHERE tipo_documento = 'DEVOLUCION';


CREATE TABLE productos(
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    codigo_barras VARCHAR(50) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    estado BIT DEFAULT 1,
    categoria VARCHAR(30) NOT NULL,
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT UX_producto_codigo UNIQUE (codigo_barras)
);


CREATE TABLE precios_producto(
    id_precio       INT IDENTITY(1,1) PRIMARY KEY,
    id_producto     INT NOT NULL,
    tipo_precio     VARCHAR(39) NOT NULL
        CHECK(tipo_precio IN ('NORMAL','MAYORISTA','PROMOCION')),
    precio          DECIMAL(18,2) NOT NULL,
    fecha_inicio    DATETIME2 DEFAULT GETUTCDATE(),
    fecha_fin       DATETIME2 DEFAULT NULL,
    CONSTRAINT fk_producto
        FOREIGN KEY (id_producto)
            REFERENCES productos(id_producto)
);


CREATE TABLE movimientos_caja (
    id_movimiento INT IDENTITY PRIMARY KEY,
    id_apertura INT NOT NULL,
    id_venta INT NULL,
    tipo VARCHAR(20) NOT NULL
        CHECK (tipo IN ('VENTA','PAGO_CREDITO','RETIRO','INGRESO','AJUSTE')),
    monto DECIMAL(18,2) NOT NULL,
    descripcion VARCHAR(200),
    fecha DATETIME2 DEFAULT GETUTCDATE(),
    id_usuario INT NOT NULL,

    FOREIGN KEY (id_apertura)
        REFERENCES aperturas_caja(id_apertura),

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_user),

    FOREIGN KEY (id_venta)
        REFERENCES ventas(id_venta),

    CHECK (monto > 0),

    CONSTRAINT CK_movimientos_caja_coherencia
        CHECK (
            (tipo IN ('VENTA','PAGO_CREDITO') AND id_venta IS NOT NULL)
                OR
            (tipo IN ('RETIRO','INGRESO','AJUSTE') AND id_venta IS NULL)
            )
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

CREATE TABLE inventario (
    id_sucursal INT NOT NULL,
    id_producto INT NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
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

CREATE INDEX IX_inventario_producto
    ON inventario(id_producto,id_sucursal);


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
    id_producto INT NOT NULL,
    sucursal_origen INT NULL,
    sucursal_destino INT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('VENTA','COMPRA','AJUSTE','TRANSFERENCIA')),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    id_venta INT NULL,
    fecha DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    CONSTRAINT CK_MOVIMIENTO_INV_COHERENCIA
        CHECK(
            (tipo = 'VENTA' AND id_venta IS NOT NULL )
                OR
            (tipo IN('COMPRA','AJUSTE','TRANSFERENCIA') AND id_venta IS NULL)
            )
);


CREATE TABLE cuentas_por_cobrar (
    id_cuenta INT IDENTITY PRIMARY KEY,
    id_venta INT NOT NULL,
    id_cliente INT NOT NULL,
    saldo_inicial DECIMAL(18,2) NOT NULL CHECK (saldo_inicial >= 0),
    saldo_actual  DECIMAL(18,2) NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('PENDIENTE','PAGADA','VENCIDA')),
    fecha_creacion DATETIME2 DEFAULT GETUTCDATE(),
    fecha_vencimiento DATETIME2 NULL,
    CHECK (saldo_actual >= 0 AND saldo_actual <= saldo_inicial),

    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT FK_cuenta_venta_credito
        FOREIGN KEY (id_venta)
            REFERENCES ventas(id_venta)

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

CREATE TABLE auditoria (
    id_auditoria INT IDENTITY PRIMARY KEY,
    tabla VARCHAR(50) NOT NULL,
    id_registro INT NOT NULL,
    accion VARCHAR(20) NOT NULL
        CHECK (accion IN ('INSERT','UPDATE','DELETE')),
    datos_anteriores NVARCHAR(MAX),
    datos_nuevos NVARCHAR(MAX),
    fecha DATETIME2 DEFAULT GETUTCDATE(),
    id_usuario INT NULL,

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_user)
);


CREATE INDEX IX_auditoria_tabla_registro
    ON auditoria(tabla, id_registro);

CREATE INDEX IX_cuentas_cliente_saldo
    ON cuentas_por_cobrar(id_cliente, saldo_actual);

CREATE INDEX IX_pagos_cuenta
    ON pagos_credito(id_cuenta);

CREATE INDEX IX_cuentas_cliente_estado
    ON cuentas_por_cobrar(id_cliente, estado);

CREATE INDEX IX_ventas_sucursal_fecha
    ON ventas(id_sucursal, fecha_venta);

CREATE INDEX IX_ventas_apertura
    ON ventas(id_apertura);

CREATE INDEX IX_ventas_caja_fecha
    ON ventas(id_caja, id_sucursal, fecha_venta);

CREATE INDEX IX_clientes_cedula
    ON clientes(cedula_ruc);

CREATE INDEX IX_productos_nombre
    ON productos(nombre);

CREATE INDEX IX_ventas_cliente_fecha
    ON ventas(id_cliente, fecha_venta);

CREATE INDEX IX_movimientos_caja_apertura
    ON movimientos_caja(id_apertura);

CREATE INDEX IX_movimientos_inventario_producto_sucursal
    ON movimientos_inventario(id_sucursal, id_producto);

CREATE INDEX IX_detalleVenta_venta
    ON detalle_venta(id_venta);

CREATE INDEX IX_apertura_estado
    ON aperturas_caja(id_caja, id_sucursal, estado);

CREATE UNIQUE INDEX UX_cuenta_por_venta
    ON cuentas_por_cobrar(id_venta);

