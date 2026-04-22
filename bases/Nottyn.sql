CREATE TABLE usuario_tbl(
    idUsuario INT IDENTITY(1,1) PRIMARY KEY,
    codex varchar(15) NOT NULL UNIQUE,
    avatar_name VARCHAR(30) NOT NULL,
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    is_deleted BIT DEFAULT  0,
    fecha_Elimih DATETIME2 NULL,
    pass_hash VARCHAR(225)NOT NULL
);


CREATE TABLE notax_tbl(
    idNotaX int  IDENTITY(1,1) PRIMARY KEY,
    codex_notax varchar(15) NOT NULL UNIQUE,

    idUsuario INT NULL,
    alias_anonimo VARCHAR(50) NULL,

    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    estado BIT DEFAULT 1,
    is_deleted BIT NOT NULL DEFAULT 0,
    fecha_Elimi DATETIME2 NULL,

    CONSTRAINT fk_usuario
        FOREIGN KEY(idUsuario) REFERENCES usuario_tbl(idUsuario),

    CONSTRAINT ck_nota_autor
        CHECK (
            (idUsuario IS NOT NULL AND alias_anonimo IS NULL)
                OR (idUsuario IS NULL AND alias_anonimo IS NOT NULL)
            );


CREATE TABLE nota_bloque_tbl(
    idBloque INT IDENTITY(1,1) PRIMARY KEY,
    IdNota INT NOT NULL,

    tipo VARCHAR(10) NOT NULL
        CHECK (tipo IN ('text', 'code')),

    contenido NVARCHAR(MAX) NOT NULL,
    lenguaje VARCHAR(15) NULL,

    orden INT NOT NULL,
    lineas INT NULL,

    CONSTRAINT fk_bloque_nota
        FOREIGN KEY (IdNota) REFERENCES notax_tbl(idNotaX)

);



CREATE INDEX idx_bloque_nota_orden
    ON nota_bloque_tbl (IdNota, orden);

CREATE UNIQUE INDEX uq_bloque_nota_orden
    ON nota_bloque_tbl (IdNota, orden);

CREATE INDEX idx_nota_usuario
    ON notax_tbl (idUsuario);
WHERE is_deleted = 0;



SELECT * FROM usuariotbl;