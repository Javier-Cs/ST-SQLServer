CREATE DATABASE PeopleData_db;
use PeopleData_db;

create table usuario_tbl(
    id_usuario int identity(1,1) primary key,
    nombre_user varchar(70) NOT NULL,
    rol_user varchar(15) NOT NULL,
    email_user varchar(70) NULL UNIQUE,
    passHass varchar(275) NOT NULL,
    telefono varchar(13) NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    estado_user bit default 0,
    is_deleted bit default 1
);


CREATE TABLE login_attempts(
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(200),
    fecha DATETIME,
    ip VARCHAR(100)
);

select * from usuario_tbl;

INSERT INTO usuario_tbl
(
    nombre_user,
    rol_user,
    email_user,
    passHass,
    telefono,
    estado_user,
    is_deleted
)
VALUES
    (
        '',
        '',
        '',
        '',
        '',
        1,
        0
    );


SELECT * from login_attempts;

DELETE usuario_tbl
where id_usuario= 4
use nottyn_db;

