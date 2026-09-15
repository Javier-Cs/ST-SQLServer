CREATE DATABASE BoxCente_db;

USE BoxCente_db;

-- EMPRESAS
CREATE TABLE empresa_tbl (
    id_empresa INT IDENTITY(1,1) PRIMARY KEY,
    nombre_empresa VARCHAR(70) NOT NULL UNIQUE,
    url_img_empresa VARCHAR(300) NOT NULL,
    estado_empresa BIT NOT NULL DEFAULT 1,
    is_deleted BIT NOT NULL DEFAULT 0,
    fecha_creacion_empresa DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),
    fecha_modificacion DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME()
);


-- USUARIOS
CREATE TABLE usuario_tbl (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    id_empresa INT NOT NULL,
    nombre_user VARCHAR(70) NOT NULL,
    rol VARCHAR(20) NOT NULL
        CHECK (rol IN ('ADMINISTRADOR', 'USUARIO')),
    email VARCHAR(70) NOT NULL,
    pass_hash VARCHAR(300) NOT NULL,
    url_img_user VARCHAR(300) NOT NULL,
    estado_user BIT NOT NULL DEFAULT 1,
    is_deleted BIT NOT NULL DEFAULT 0,

    fecha_creacion_empresa DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    fecha_modificacion DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (id_empresa)
            REFERENCES empresa_tbl(id_empresa),

    CONSTRAINT uq_usuario_email
        UNIQUE (id_empresa, email)
);


-- SESIONES
CREATE TABLE session_tbl (
    id_session INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,

    created_at DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    expire_at DATETIME2 NOT NULL
        DEFAULT DATEADD(DAY, 7, SYSUTCDATETIME()),

    removed_at DATETIME2 NULL,
    last_activity_at DATETIME2 NULL,
    ip_address VARCHAR(45) NULL,
    user_agent NVARCHAR(500) NULL,

    CONSTRAINT fk_usuario_session
        FOREIGN KEY (user_id)
            REFERENCES usuario_tbl(id_usuario)
);


-- BUCKETS
CREATE TABLE Buckets_tbl (
    id_bucket INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    is_public BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT fk_usuario_bucket
        FOREIGN KEY (user_id)
            REFERENCES usuario_tbl(id_usuario),

    CONSTRAINT uq_usuario_bucket
        UNIQUE (user_id, nombre)
);


-- FOLDERS
CREATE TABLE Folder_tbl (
    id_folder INT IDENTITY(1,1) PRIMARY KEY,
    buckets_id INT NOT NULL,
    parent_folder_id INT NULL,
    nombre VARCHAR(255) NOT NULL,

    create_at DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT fk_folder_bucket
        FOREIGN KEY (buckets_id)
            REFERENCES Buckets_tbl(id_bucket),

    CONSTRAINT fk_folder_parent
        FOREIGN KEY (parent_folder_id)
            REFERENCES Folder_tbl(id_folder)
);


-- Carpetas hijas:
-- No permite dos carpetas con el mismo nombre
-- dentro del mismo folder padre.

CREATE UNIQUE INDEX uq_folder_parent_name
    ON Folder_tbl (buckets_id, parent_folder_id, nombre)
    WHERE parent_folder_id IS NOT NULL;


-- Carpetas raíz:
-- No permite dos carpetas raíz con el mismo nombre
-- dentro del mismo bucket.

CREATE UNIQUE INDEX uq_folder_root_name
    ON Folder_tbl (buckets_id, nombre)
    WHERE parent_folder_id IS NULL;



-- FILES
CREATE TABLE Files_tbl (
    id_files INT IDENTITY(1,1) PRIMARY KEY,
    buckets_id INT NOT NULL,
    folder_id INT NULL,
    usuario_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    object_key VARCHAR(1000) NOT NULL UNIQUE,
    content_type VARCHAR(150) NOT NULL,
    size BIGINT NOT NULL,
    extencion VARCHAR(20) NULL,
    is_public BIT NOT NULL DEFAULT 0,

    create_at DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    update_at DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT fk_file_bucket
        FOREIGN KEY (buckets_id)
            REFERENCES Buckets_tbl(id_bucket),

    CONSTRAINT fk_file_folder
        FOREIGN KEY (folder_id)
            REFERENCES Folder_tbl(id_folder),

    CONSTRAINT fk_file_user
        FOREIGN KEY (usuario_id)
            REFERENCES usuario_tbl(id_usuario)
);



-- API KEYS
CREATE TABLE Api_key_tbl (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    key_prefix VARCHAR(20) NOT NULL,
    key_hash VARCHAR(500) NOT NULL,

    creat_at DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    expires_at DATETIME2 NULL,
    revoked_at DATETIME2 NULL,
    last_used_at DATETIME2 NULL,

    CONSTRAINT fk_api_user
        FOREIGN KEY (user_id)
            REFERENCES usuario_tbl(id_usuario)
);



-- PERMISSIONS
CREATE TABLE Permissions_tbl (
    id INT IDENTITY(1,1) PRIMARY KEY,
    buckets_id INT NULL,
    folder_id INT NULL,
    usuario_id INT NOT NULL,
    files_id INT NULL,
    can_read BIT NOT NULL DEFAULT 0,
    can_write BIT NOT NULL DEFAULT 0,
    can_delete BIT NOT NULL DEFAULT 0,
    can_manage BIT NOT NULL DEFAULT 0,

    created_at DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT fk_permiss_bucket
        FOREIGN KEY (buckets_id)
            REFERENCES Buckets_tbl(id_bucket),

    CONSTRAINT fk_permiss_folder
        FOREIGN KEY (folder_id)
            REFERENCES Folder_tbl(id_folder),

    CONSTRAINT fk_permiss_user
        FOREIGN KEY (usuario_id)
            REFERENCES usuario_tbl(id_usuario),

    CONSTRAINT fk_permiss_file
        FOREIGN KEY (files_id)
            REFERENCES Files_tbl(id_files),

    CONSTRAINT ck_permission_resource
        CHECK (
            (buckets_id IS NOT NULL AND folder_id IS NULL AND files_id IS NULL)
                OR
            (buckets_id IS NULL AND folder_id IS NOT NULL AND files_id IS NULL)
                OR
            (buckets_id IS NULL AND folder_id IS NULL AND files_id IS NOT NULL)
        )
);
