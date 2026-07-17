CREATE DATABASE CedeSys_db;

USE CedeSys_db;


CREATE TABLE empresa_tbl(
    id_empresa INT IDENTITY(1,1) PRIMARY KEY,
    nombre_empresa VARCHAR(70) NOT NULL UNIQUE,
    direccion_empresa VARCHAR(100) NOT NULL,
    ruc_empresa VARCHAR(20) NOT NULL,
    url_img_empresa VARCHAR(300) NOT NULL UNIQUE,
    estado_empresa BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    fecha_creacion_empresa DATETIME2 DEFAULT GETDATE(),
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

CREATE TABLE usuario_tbl(
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    nombre_user VARCHAR(70) NOT NULL UNIQUE,
    email VARCHAR(70)  NOT NULL,
    pass_hash VARCHAR(300) NOT NULL UNIQUE,
    direccion_user VARCHAR(100) NOT NULL,
    ic_user VARCHAR(12) NOT NULL UNIQUE,
    rol VARCHAR(20)  NOT NULL
        CHECK (rol IN ('ADMINISTRADOR','VENDEDOR','SUPERVISOR')),
    url_img_user VARCHAR(300) NOT NULL UNIQUE,
    estado_user BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    fecha_creacion_empresa DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),

    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa)
);

CREATE TABLE credec_empres_tbl(
    id_cred_use INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NULL,
    servidor_smtp VARCHAR(100) NULL,
    puerto_smtp INT NULL,
    correo_empresa VARCHAR(100) NULL,
    password_hash  VARBINARY(MAX) NOT NULL,
    ssl_tls BIT DEFAULT  1,
    estado_cred BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    fecha_creacion_cred DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME2 NULL DEFAULT GETUTCDATE(),

    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa)
);

CREATE TABLE cliente_tbl(
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NULL,
    nombre VARCHAR(100)  NOT NULL,
    telefono             VARCHAR(20),
    cedula_ruc           CHAR(13),
    email                VARCHAR(100),
    tipo                 VARCHAR(50),
    estado               BIT           DEFAULT 1,
    is_deleted           BIT           NOT NULL DEFAULT 0,
    fecha_creacion       DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
    fecha_eliminacion    DATETIME2     NULL,
    limite_credito         DECIMAL(18,2) NOT NULL DEFAULT 0
        CHECK (limite_credito >= 0),
    dias_credito           INT           NOT NULL DEFAULT 0
        CHECK (dias_credito >= 0),

    CONSTRAINT fk_cliente_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa),

);