CREATE DATABASE archi_db;

USE archi_db;

CREATE TABLE empresa_tbl(
    id_empresa INT IDENTITY(1,1) PRIMARY KEY,
    code_empresa VARCHAR(50) NOT NULL,
    nombre_empresa VARCHAR(70) NOT NULL UNIQUE,
    direccion_empresa VARCHAR(100) NOT NULL,
    ruc_empresa VARCHAR(20) NOT NULL,
    url_img_empresa VARCHAR(300) NOT NULL,
    estado_empresa BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    fecha_creacion_empresa DATETIME2 DEFAULT GETDATE(),
    fecha_modificacion DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE usuario_tbl(
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    nombre_user VARCHAR(70) NOT NULl,
    rol VARCHAR(20)  NOT NULL
        CHECK (rol IN ('ADMINISTRADOR','USUARIO','SUPERVISOR')),
    email VARCHAR(70)  NOT NULL,
    pass_hash VARCHAR(300) NOT NULL,
    direccion_user VARCHAR(100) NOT NULL,
    intentos_fallidos INT NOT NULL DEFAULT 0,
    cedula_user VARCHAR(12) NOT NULL UNIQUE,
    url_img_user VARCHAR(300) NOT NULL,
    estado_user BIT DEFAULT 1,
        is_deleted BIT DEFAULT 0,
    ultimo_login DATETIME2 NULL,
    fecha_creacion_usuario DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_modificacion DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa),

    CONSTRAINT uq_usuario_email
        UNIQUE(id_empresa,email)
);


CREATE TABLE auditoria_login_tbl(
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NULL,
    id_empresa INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    fecha DATETIME2 NOT NULL DEFAULT GETDATE(),
    ip VARCHAR(45) NOT NULL,
    user_agent VARCHAR(500) NULL,
    exito BIT NOT NULL,
    motivo_error VARCHAR(100) NULL,
    CONSTRAINT fk_empresa_audi_login
        FOREIGN KEY (id_empresa) REFERENCES empresa_tbl(id_empresa),
    CONSTRAINT fk_usuario_audi_login
        FOREIGN KEY (id_usuario) REFERENCES usuario_tbl(id_usuario)
);

CREATE TABLE sesion_tbl(
    id_sesion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    latitud DECIMAL(10,7),
    longitud DECIMAL(10,7),
    nombre_dispositivo VARCHAR(100),
    sistema_operativo VARCHAR(50),
    navegador VARCHAR(100),
    user_agent VARCHAR(500),
    refresh_token_hash VARCHAR(500) NOT NULL,
    fecha_inicio DATETIME2 NULL DEFAULT GETDATE(),
    fecha_expiracion DATETIME2 NULL,
    fecha_ultimo_acceso DATETIME2 NULL DEFAULT GETDATE(),
    ip VARCHAR(45) NOT NULL,
    activa BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    CONSTRAINT fk_usuario_sesion
        FOREIGN KEY (id_usuario) REFERENCES usuario_tbl(id_usuario)
);

CREATE TABLE archivos_tbl(
    id_archivo INT IDENTITY(1,1) PRIMARY KEY,
    usuario_id INT NOT NULL,
    empresa_id INT NOT NULL,

    nombre_archivo NVARCHAR(100) NOT NULL,
    ubicacion NVARCHAR(500) NOT NULL,

    tamano BIGINT NOT NULL,

    tipo_archivo VARCHAR(20) NOT NULL,
    extencion NVARCHAR(10) NOT NULL,

    fecha_archivo_subido DATETIME2 NOT NULL DEFAULT GETDATE(),
    fecha_modificacion DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT fk_usuario_archivo
        FOREIGN KEY (usuario_id)
        REFERENCES usuario_tbl(id_usuario),

    CONSTRAINT fk_empresa_archivo
        FOREIGN KEY (empresa_id)
        REFERENCES empresa_tbl(id_empresa)
);