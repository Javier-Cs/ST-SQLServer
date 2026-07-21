CREATE DATABASE CedeSys_db;

USE CedeSys_db;


CREATE TABLE empresa_tbl(
    id_empresa INT IDENTITY(1,1) PRIMARY KEY,
    nombre_empresa VARCHAR(70) NOT NULL UNIQUE,
    direccion_empresa VARCHAR(100) NOT NULL,
    ruc_empresa VARCHAR(20) NOT NULL,
    url_img_empresa VARCHAR(300) NOT NULL,
    estado_empresa BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    fecha_creacion_empresa DATETIME2 DEFAULT GETDATE(),
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

CREATE TABLE usuario_tbl(
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    nombre_user VARCHAR(70) NOT NULl,
    rol VARCHAR(20)  NOT NULL
        CHECK (rol IN ('ADMINISTRADOR','VENDEDOR','SUPERVISOR')),
    email VARCHAR(70)  NOT NULL,
    pass_hash VARCHAR(300) NOT NULL,
    direccion_user VARCHAR(100) NOT NULL,
    cedula_user VARCHAR(12) NOT NULL UNIQUE,
    url_img_user VARCHAR(300) NOT NULL,
    estado_user BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    fecha_creacion_empresa DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa)
);

CREATE TABLE credec_empres_tbl(
    id_cred_use INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    servidor_smtp VARCHAR(100) NULL,
    puerto_smtp INT NULL,
    correo_empresa VARCHAR(100) NULL,
    password_hash  VARBINARY(MAX) NOT NULL,
    ssl_tls BIT DEFAULT  1,
    estado_cred BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    fecha_creacion_cred DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME2 NULL DEFAULT GETUTCDATE(),

    CONSTRAINT fk_credenc_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa)
);

CREATE TABLE cliente_tbl(
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    nombre VARCHAR(100)  NOT NULL,
    telefono             VARCHAR(20),
    cedula_ruc           CHAR(13),
    email                VARCHAR(100),
    tipo_cliente         VARCHAR(50) NOT NULL
        CHECK(tipo_cliente IN ('PERSONA', 'EMPRESA')),
    razon_social VARCHAR(100)  NOT NULL,
    nombre_comercial VARCHAR(100) NOT NULL,
    direccion             VARCHAR(200),
    ciudad                VARCHAR(30),
    provincia             VARCHAR(30),
    estado               BIT           DEFAULT 1,
    is_deleted           BIT           NOT NULL DEFAULT 0,
    fecha_creacion       DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
    fecha_eliminacion    DATETIME2     NULL,
    limite_credito         DECIMAL(18,2) NOT NULL DEFAULT 0
        CHECK (limite_credito >= 0),
    dias_credito           INT           NOT NULL DEFAULT 0
        CHECK (dias_credito >= 0),

    CONSTRAINT fk_cliente_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa),
);


CREATE TABLE producto_tbl(
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    id_categoria INT NOT NULL,
    codigo VARCHAR(200) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    descripcion VARCHAR(100) NULL,
    precio_compra DECIMAL(18,2) NOT NULL,
    precio_venta DECIMAL(18,2) NOT NULL,
    stock_minimo  INT NULL ,
    stock_actual INT NULL,
    porcentaje_iva  DECIMAL(5,2) NOT NULL,
    estado BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,

    CONSTRAINT fk_product_empresa
        FOREIGN KEY (id_empresa) REFERENCES  empresa_tbl(id_empresa),

    CONSTRAINT fk_product_categoria
        FOREIGN KEY (id_categoria) REFERENCES categoria_producto_tbl(id_categoria)

);


CREATE TABLE categoria_producto_tbl(
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    id_producto INT NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    estado BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    fecha_venta DATETIME DEFAULT GETDATE(),
    f_actualiz_venta DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_categoria_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa)

);

CREATE TABLE ventas_tbl(
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_empresa INT NOT NULL,
    id_usuario INT NOT NULL,

    numero_documento VARCHAR(20) NOT NULL,
    observacion_venta VARCHAR(300) NULL,
    tipo_venta VARCHAR(20) NOT NULL
        CHECK(tipo_venta IN ('CREDITO','CONTADO')),
    estado_de_venta VARCHAR(20) NOT NULL
        CHECK(estado_de_venta IN ('PAGADA','ANULADA','PENDIENTE','DEUDA', 'BORRADOR')),

    estado BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,

    fecha_venta DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    fecha_modificacion DATETIME2 DEFAULT GETUTCDATE(),

    sub_total DECIMAL(18,2) NOT NULL DEFAULT 0,
    descuento DECIMAL(18,2) NOT NULL DEFAULT 0,
    valor_iva  DECIMAL(18,2) NOT NULL DEFAULT 0,
    total DECIMAL(18,2) NOT NULL DEFAULT  0,

    /*
    EL VUELTO Y EFECTIVO RECIBIDO VA EN OTRA TABLA
    efectivo_recibido DECIMAL(18,2) NOT NULL,
    monto_vuelto DECIMAL(18,2) NOT NULL,*/

    CONSTRAINT fk_venta_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente_tbl(id_cliente),

    CONSTRAINT fk_venta_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa),

    CONSTRAINT fk_venta_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario_tbl(id_usuario)
);

CREATE TABLE detalle_venta_tbl(
    id_detalle_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,

    /* VALORES PARA FUTUROS CAMBIOS*/
    codigo_producto VARCHAR(100) NULL,
    descripcion_producto VARCHAR(300) NULL,
    unidad_medida VARCHAR(20),
    orden_linea INT,

    cantidad DECIMAL(18,2) NOT NULL,
    precio_unitario DECIMAL(18,2) NOT NULL,
    porcentaje_descuento DECIMAL(18,2) NOT NULL,
    valor_descuento DECIMAL(18,2) NOT NULL,
    porcentaje_iva DECIMAL(5,2) NOT NULL,
    valor_iva DECIMAL(18,2) NOT NULL,
    subtotal_linea DECIMAL(18,2) NOT NULL,

    estado BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    fecha_detalle_venta DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_detalle_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa),

    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (id_venta) REFERENCES ventas_tbl(id_venta),

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto) REFERENCES producto_tbl(id_producto),
);

CREATE INDEX IX_DetalleVenta
    ON detalle_venta_tbl(id_venta);


CREATE INDEX IX_DetalleProducto
    ON detalle_venta_tbl(id_producto);



