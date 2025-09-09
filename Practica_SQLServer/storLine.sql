create database storLine
use storLine

create schema stor

    create table stor.client_tbl(
        id int identity(1,1),
        name_lastname nvarchar(100) not null,
        ci nvarchar(15) not null,
        fecha_regist date not null,
        telefono nvarchar(15),
        constraint Pk_clientId primary key(id),

    );


create table stor.product_tbl(
    id int identity(1,1),
    code nvarchar(200) not null,
    name nvarchar(50) not null,
    price decimal(18,2) not null,
    cant int not null,
    estado bit default 1,
    fech_actu date not null,
    aviso nvarchar(20) not null,
    constraint Pk_productId primary key(id),
);

create table stor.factura_tbl(
    id int identity(1,1),
    fecha_gene date not null,
    total decimal not null,
    isdeudor bit default 0,
    id_client int not null,
    id_producto int not null,
    constraint Pk_facturaId primary key(id),

    constraint Fk_clientId foreign key(id_client)
        references stor.client_tbl(id),
    constraint Fk_autorId foreign key(id_producto)
        references stor.product_tbl(id)
);


create table stor.factura_deudas_tbl(
    id int identity(1,1),
    fecha_generada date not null,
    total_facturas decimal not null,
    id_factura int not null,
    constraint Pk_deudorId primary key(id),
    constraint Fk_facturaId foreign key(id_factura)
        references stor.factura_tbl(id)
);








-- Crear la base de datos
CREATE DATABASE storLine;
GO

-- Usar la base de datos
USE storLine;
GO

-- Crear el esquema
CREATE SCHEMA stor;
GO

-- Tabla de clientes
CREATE TABLE stor.client_tbl(
    id INT IDENTITY(1,1),
    name_lastname NVARCHAR(100) NOT NULL,
    ci NVARCHAR(15) NOT NULL,
    fecha_regist DATE NOT NULL,
    telefono NVARCHAR(15),
    CONSTRAINT Pk_clientId PRIMARY KEY(id)
);
GO

-- Tabla de productos
CREATE TABLE stor.product_tbl(
    id INT IDENTITY(1,1),
    code NVARCHAR(200) NOT NULL,
    name NVARCHAR(50) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL, -- Cambiado a 'stock' para mayor claridad
    estado BIT DEFAULT 1,
    fech_actu DATE NOT NULL,
    aviso NVARCHAR(20) NOT NULL,
    CONSTRAINT Pk_productId PRIMARY KEY(id)
);
GO

-- Tabla de facturas (con campos para gestionar el crédito)
-- Aquí se gestionan las facturas, tanto las pagadas al contado como las de crédito.
CREATE TABLE stor.factura_tbl(
    id INT IDENTITY(1,1),
    fecha_gene DATE NOT NULL,
    total DECIMAL(18,2) NOT NULL,
    is_credito BIT DEFAULT 0, -- Indica si es una venta a crédito (deudor)
    is_pagada BIT DEFAULT 0, -- Indica si la deuda ha sido saldada (solo para facturas a crédito)
    id_client INT NOT NULL,
    CONSTRAINT Pk_facturaId PRIMARY KEY(id),
    CONSTRAINT Fk_clientId FOREIGN KEY(id_client)
        REFERENCES stor.client_tbl(id)
);
GO

-- Tabla de detalles de la factura (para manejar múltiples productos por factura)
-- Esta es una tabla de unión que conecta 'factura_tbl' con 'product_tbl'.
-- Permite que una factura contenga varios productos, cada uno con su cantidad y precio unitario
-- en el momento de la venta.
CREATE TABLE stor.factura_detalle_tbl(
    id_factura INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(18,2) NOT NULL, -- Guardamos el precio unitario al momento de la venta
    CONSTRAINT Pk_facturaDetalleId PRIMARY KEY(id_factura, id_producto),
    CONSTRAINT Fk_facturaDetalle_factura FOREIGN KEY(id_factura)
        REFERENCES stor.factura_tbl(id),
    CONSTRAINT Fk_facturaDetalle_producto FOREIGN KEY(id_producto)
        REFERENCES stor.product_tbl(id)
);
GO

-- Ahora, para ver las facturas por pagar de un cliente, simplemente puedes hacer una consulta a la tabla 'factura_tbl':
SELECT * FROM stor.factura_tbl WHERE is_credito = 1 AND is_pagada = 0 AND id_client = [ID_CLIENTE];