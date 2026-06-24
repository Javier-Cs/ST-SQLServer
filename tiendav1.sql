create database Legumfrutstore;
use Legumfrutstore;

CREATE TABLE clientes (
                          id_cliente     INT IDENTITY(1,1) PRIMARY KEY,
                          nombre         VARCHAR(100) NOT NULL,
                          telefono       VARCHAR(20),
                          email          VARCHAR(100),
                          tipo           VARCHAR(50),
                          estado         BIT DEFAULT 1,
                          fecha_creacion  DATETIME DEFAULT GETDATE()
);

CREATE TABLE ventas (
                        id_venta           INT IDENTITY(1,1) PRIMARY KEY,
                        id_cliente         INT NOT NULL,
                        nombre_vendedor    VARCHAR(20),
                        descripcion_venta  VARCHAR(300),
                        tipo_venta         VARCHAR(20),
                        estado_venta       VARCHAR(30) DEFAULT 'SIN DEFINIR',
                        efectivo_recibido  DECIMAL(10,2) NOT NULL,
                        monto_total_Venta  DECIMAL(10,2) NOT NULL,
                        monto_vuelto       DECIMAL(10,2) NOT NULL,
                        fecha_venta        DATETIME DEFAULT GETDATE(),

                        CONSTRAINT fk_ventas_clientes
                            FOREIGN KEY (id_cliente)
                                REFERENCES clientes(id_cliente)
);


---- tabla de registro de pago
create table registro_pago_Ventas(
                                     id_pago int identity(1,1) primary key,
                                     fecha_pago datetime not null default DATEADD(HOUR, -5, GETUTCDATE()) ,
                                     id_clientef  int not null,
                                     numero_ventas int not null,
    --- estos datos serian del pago total de las ventas
                                     efectivo_recibido_del_pago decimal(10,2) not null,
                                     valor_a_pagar decimal(10,2) not null ,
                                     vuelto_de_deudas_Totales decimal(10,2) not null,
                                     constraint fk_clientes foreign key (id_clientef) references clientes(id_cliente),
    --constraint fk_ventas foreign key (id_clientef) references ventas(id_venta)
);


CREATE TABLE pago_ventas (
                             id_pagof int not null,
                             id_ventaf int not null,

                             constraint pk_pago_ventas primary key (id_pagof, id_ventaf),
                             constraint fk_pagoVenta_pago foreign key (id_pagof) REFERENCES registro_pago_Ventas(id_pago),
                             constraint fk_pagoVenta_venta foreign key (id_ventaf) references ventas(id_venta)
)



--- modificacion de ventas
ALTER TABLE ventas
    ADD id_usuario INT NULL;




CREATE TABLE usuarios(
                         id_usuario INT IDENTITY(1,1) PRIMARY KEY,
                         nombre VARCHAR(50) NOT NULL,
                         telefono VARCHAR(12) NULL,
                         estado bit DEFAULT 1,
                         tipo VARCHAR(20) DEFAULT 'VENDEDOR',
                         fecha_creacion DATETIME DEFAULT GETDATE()
);


CREATE TABLE cred_email(
                           id_crede INT IDENTITY(1,1) PRIMARY KEY,
                           id_usuario int not null,
                           correo VARCHAR(70) NOT NULL,
                           pass VARCHAR(100) NULL UNIQUE,
                           smtp_puerto varchar(10) NULL,
                           smtp_servidor varchar(70) null,
                           use_ssl bit null,
                           CONSTRAINT fk_crde_correo FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);


insert INTO cred_email (id_usuario, correo, pass, smtp_puerto, smtp_servidor, use_ssl) values(1, 'krchipullajavier@gmail.com','wmqppmqzroyirlwr','1', '2', 1);


--- Migrar vendedores existentes
INSERT INTO usuarios(nombre)
SELECT DISTINCT nombre_vendedor
FROM ventas
WHERE nombre_vendedor is not null;


--- Relacionar ventas con vendedores

UPDATE v
SET v.id_usuario = us.id_usuario
    FROM ventas v
INNER JOIN usuarios us
ON v.nombre_vendedor = us.nombre;

--- creacion de FK

ALTER TABLE ventas
    ADD CONSTRAINT fk_ventas_usuarios
        FOREIGN KEY (id_usuario)
            references usuarios (id_usuario)


SELECT
    v.id_venta,
    v.nombre_vendedor,
    v.id_usuario,
    usu.nombre
FROM ventas v
         LEFT JOIN usuarios usu
                   on v.id_usuario = usu.id_usuario;



SELECT * from usuarios;
SELECT * from ventas;





SELECT
    c.id_cliente,
    c.nombre,

    MAX(v.nombre_vendedor) AS nombre_vendedor,

    COUNT(v.id_venta) AS cantidadDeDeudas,

    SUM(v.monto_total_Venta) AS monto_total_Venta,

    MAX(v.fecha_venta) AS fecha_ultima_venta

FROM ventas v
         INNER JOIN clientes c
                    ON c.id_cliente = v.id_cliente

WHERE v.estado_venta = 'DEUDA'

GROUP BY
    c.id_cliente,
    c.nombre

ORDER BY monto_total_Venta DESC



    use  Legumfrutstore;
select * FROM ventas;
select * FROM clientes;
select * from usuarios;
select * from cred_email;


insert INTO cred_email (id_usuario, correo, pass, smtp_puerto, smtp_servidor, use_ssl) values(1, 'krchipullajavier@gmail.com','wmqppmqzroyirlwr','1', '2', 1);

update usuarios
set nombre = 'javier'
WHERE nombre = 'Cliente Final'



---select * from ventas
---         where estado_venta = 'deuda' and
---             tipo_venta = 'credito';


---select * from ventas
---where estado_venta = @estadoventa and
---    tipo_venta = @tipoventa

---select  * From ventas
---where id_venta = @idventa and
---      estado_venta = @estadoventa and
---      tipo_venta = @tipoventa

---drop table ventas;
---drop table clientes;

---- delete from clientes where id_cliente = 4

---UPDATE ventas
---SET nombre_vendedor = 'Maximo'
---WHERE id_venta = 49
---AND id_cliente = 1


---tipo_venta

---UPDATE ventas
---SET estado_venta = 'PAGADO'
---WHERE id_venta in (61,62,63,64,65,66,67,68,69)
---AND estado_venta = 'DEUDA'



UPDATE clientes
SET is_deleted = 1
WHERE id_cliente in (37,38,31,32,33,34,35,31)


UPDATE clientes
SET estado = 0
WHERE id_cliente in (37,38,31,32,33,34,35,31)

UPDATE clientes
SET tipo = 'DEUDOR'
WHERE tipo = 'deudor'

select * FROM clientes;



UPDATE ventas
set nombre_vendedor =  'Don Maximo'
WHERE nombre_vendedor = 'Maximo'

UPDATE clientes
SET telefono = '0000000000'
WHERE id_cliente = 15




SELECT
    v.id_venta,
    v.id_cliente,
    v.nombre_vendedor,
    c.nombre,
    v.tipo_venta,
    v.estado_venta,
    v.monto_total_Venta,
    v.fecha_venta
FROM ventas v
         INNER JOIN clientes c
                    ON v.id_cliente = c.id_cliente
WHERE 1=1 AND v.is_deleted = 0 AND v.fecha_venta >= '2026-01-27 01:29:37.780' AND v.fecha_venta < '2026-01-27 23:29:37.780'
ORDER BY v.fecha_venta DESC;



select nombre_vendedor from ventas;

use Legumfrutstore;
select * from usuarios;



ALTER TABLE usuarios
    ADD rol_usuario nvarchar(16) null;

ALTER TABLE usuarios
    ADD id_crede_gmail int null;

ALTER TABLE usuarios
    ADD email_user nvarchar(70) null;

ALTER TABLE usuarios
    ADD passHass nvarchar(280) null;

UPDATE usuarios
set email_user = 'm'
WHERE id_usuario in (5);

UPDATE usuarios
set nombre = 'Javier Carchipulla'
WHERE id_usuario in (1);



UPDATE usuarios
set passHass =''
WHERE id_usuario = 0;

UPDATE usuarios
set passHass =''
WHERE id_usuario = 0;


