CREATE TABLE usuario_tbl(
    idUsuario INT IDENTITY(1,1) PRIMARY KEY,
    codex varchar(15) NOT NULL UNIQUE,
    avatar_name VARCHAR(30) NOT NULL,
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    pass_hash VARCHAR(225)NOT NULL
);


CREATE TABLE notax_tbl(
    idNotaX int  IDENTITY(1,1) PRIMARY KEY,
    codex_notax varchar(15) NOT NULL UNIQUE,
    codex_User VARCHAR(15) NOT NULL,
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    estado BIT DEFAULT 1,
    is_deleted BIT NOT NULL DEFAULT 0,
    notax NVARCHAR(MAX),

    CONSTRAINT fk_usuario
        FOREIGN KEY(codex_User) REFERENCES usuario_tbl(codex)
);


CREATE TABLE notaXcode_tbl(
    idNotaXcode int  IDENTITY(1,1) PRIMARY KEY,
    codex_notacod NVARCHAR(15) 	NOT NULL UNIQUE,
    codeX_notax VARCHAR(15) NOT NULL,
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    notax VARCHAR(MAX),

	CONSTRAINT fk_notax
	FOREIGN KEY(codeX_notax) REFERENCES notax_tbl(codex_notax),
);


CREATE TABLE nota_random_tbl(
    idNotaR int  IDENTITY(1,1) PRIMARY KEY,
    codex_notarandom varchar(15) NOT NULL UNIQUE,
    fechaCreacion DATETIME2 NOT NULL GETUTCDATE(),
    notax NVARCHAR(MAX),
    estado BIT DEFAULT 1,
    is_deleted BIT NOT NULL DEFAULT 0
);

CREATE TABLE notaRandomcode_tbl(
    idNotaXcode int  IDENTITY(1,1) PRIMARY KEY,
    codex_notacod NVARCHAR(15) 	NOT NULL UNIQUE,
    codex_notarandom VARCHAR(15) NOT NULL,
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    notax VARCHAR(MAX),

	CONSTRAINT fk_nota_random_code
	FOREIGN KEY(codex_notarandom) REFERENCES nota_random_tbl(codex_notarandom),
);


use Nottyn
SELECT * FROM usuariotbl;
