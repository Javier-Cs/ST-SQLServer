CREATE DATABASE legumfrutsadb;
USE legumfrutsadb;

CREATE TABLE empresas(
    id_empresa INT IDENTITY(1,1) PRIMARY KEY,
    nombre_empresa VARCHAR(100) NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    ruc CHAR(13) NOT NULL UNIQUE,
    tipo_contribuyente VARCHAR(30),
    direccion VARCHAR(200),
    provincia VARCHAR(50),
    telefono VARCHAR(20),
    email_empresa VARCHAR(100),
    fecha_creacion DATETIME DEFAULT  DATEADD(HOUR, -5, GETUTCDATE()),
    fecha_modificacion DATETIME DEFAULT DATEADD(HOUR, -5, GETUTCDATE()),
    aux1 VARCHAR(100),
    aux2 VARCHAR(100),
    aux3 VARCHAR(100)
);

CREATE TABLE usuarios(
    id_user int identity(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(70) NOT NULL UNIQUE,
    pass VARCHAR(255)NOT NULL,
    cedula CHAR(10),
    telefono VARCHAR(20),
    rol VARCHAR(20) NOT NULL CHECK(rol IN ('ADMIN','USER','VENDEDOR','VISUALIZADOR')),
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT  DATEADD(HOUR, -5, GETUTCDATE()),
    fecha_modificacion DATETIME DEFAULT DATEADD(HOUR, -5, GETUTCDATE()),
    aux1 VARCHAR(100),
    aux2 VARCHAR(100),
    aux3 VARCHAR(100),
    CONSTRAINT fk_empresa
        FOREIGN KEY(id_empresa)
        REFERENCES empresas(id_empresa)
);



CREATE TABLE clientes (
    id_cliente     INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa     INT NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(20),
    email          VARCHAR(100),
    tipo           VARCHAR(50),
    estado         BIT DEFAULT 1,
    fecha_creacion  DATETIME DEFAULT DATEADD(HOUR, -5, GETUTCDATE()),
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
    id_empresa         INT NOT NULL,
    id_usuario         INT NOT NULL,
    descripcion_venta  VARCHAR(300),
    tipo_venta         VARCHAR(20),
    estado_venta       VARCHAR(30) DEFAULT 'SIN DEFINIR',
    efectivo_recibido  DECIMAL(10,2) NOT NULL,
    monto_total_Venta  DECIMAL(10,2) NOT NULL,
    monto_vuelto       DECIMAL(10,2) NOT NULL,
    fecha_venta        DATETIME DEFAULT DATEADD(HOUR, -5, GETUTCDATE()),
    aux1 VARCHAR(100),
    aux2 VARCHAR(100),
    aux3 VARCHAR(100),

    CONSTRAINT fk_ventas_clientes
        FOREIGN KEY (id_cliente)
            REFERENCES clientes(id_cliente),

    CONSTRAINT fk_ventas_empresa
        FOREIGN KEY (id_empresa)
            REFERENCES empresas(id_empresa),

    CONSTRAINT fk_ventas_usuario
        FOREIGN KEY (id_usuario)
            REFERENCES usuarios(id_user)
);

CREATE TABLE productos(
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    estado BIT DEFAULT 1,
    categoria VARCHAR(30) NOT NULL,
    fecha_creacion DATETIME DEFAULT  DATEADD(HOUR, -5, GETUTCDATE()),
    fecha_modificacion DATETIME DEFAULT DATEADD(HOUR, -5, GETUTCDATE()),
    precio_unitario DECIMAL(10,2) NOT NULL,
    precio_mayor DECIMAL(10,2) NOT NULL,
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
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(5,2) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_detalle_venta_venta
        FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),

    CONSTRAINT fk_detalle_venta_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)

);

CREATE TABLE inventario (
    id INT IDENTITY PRIMARY KEY,
    id_empresa INT NOT NULL,
    id_producto INT NOT NULL,

    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT DEFAULT 0,

    fecha_actualizacion DATETIME DEFAULT DATEADD(HOUR, -5, GETUTCDATE()),

    CONSTRAINT fk_inventario_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa),

    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto),

    CONSTRAINT uq_empresa_producto
        UNIQUE (id_empresa, id_producto)
);