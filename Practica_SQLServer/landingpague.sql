-- ============================================================
-- BASE DE DATOS: legumfrutsaas
-- Versión corregida y mejorada
-- Cambios aplicados:
--   1. UNIQUE (id_usuario, id_sucursal) en usuarios_sucursaltbl
--   2. FK id_usuario_modificacion en ventas_historial
--   3. id_empresa + id_usuario agregados a movimientos_inventario
--   4. CHECK de PAGO_CREDITO en movimientos_caja corregido
--      (usa id_pago en lugar de id_venta)
--   5. Eliminado INSERT inválido al final
--   6. Índices duplicados eliminados
-- ============================================================

CREATE DATABASE legumfrutsaas;
GO
USE legumfrutsaas;
GO

-- ============================================================
-- EMPRESAS
-- ============================================================
CREATE TABLE empresas (
                          id_empresa          INT             IDENTITY(1,1) PRIMARY KEY,
                          nombre_empresa      VARCHAR(100)    NOT NULL,
                          razon_social        VARCHAR(100)    NOT NULL,
                          ruc                 CHAR(13)        NOT NULL UNIQUE,
                          tipo_contribuyente  VARCHAR(30),
                          direccion           VARCHAR(200),
                          provincia           VARCHAR(50),
                          telefono            VARCHAR(20),
                          email_empresa       VARCHAR(100),
                          fecha_creacion      DATETIME2       NOT NULL DEFAULT GETUTCDATE(),
                          fecha_modificacion  DATETIME2       NOT NULL DEFAULT GETUTCDATE(),
                          aux1                VARCHAR(100),
                          aux2                VARCHAR(100),
                          aux3                VARCHAR(100)
);

-- ============================================================
-- SUCURSALES
-- ============================================================
CREATE TABLE sucursales (
                            id_sucursal INT          IDENTITY(1,1) PRIMARY KEY,
                            id_empresa  INT          NOT NULL,
                            nombre      VARCHAR(100) NOT NULL,
                            direccion   VARCHAR(200),
                            estado      BIT          DEFAULT 1,

                            FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)
);

-- ============================================================
-- CAJAS
-- ============================================================
CREATE TABLE cajas (
                       id_caja     INT         IDENTITY(1,1) PRIMARY KEY,
                       id_sucursal INT         NOT NULL,
                       nombre      VARCHAR(50) NOT NULL,
                       estado      BIT         DEFAULT 1,

                       FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

-- ============================================================
-- USUARIOS
-- ============================================================
CREATE TABLE usuarios (
                          id_user            INT          IDENTITY(1,1) PRIMARY KEY,
                          id_empresa         INT          NOT NULL,
                          nombre             VARCHAR(50)  NOT NULL,
                          email              VARCHAR(70)  NOT NULL,
                          pass_hash          VARCHAR(255) NOT NULL,
                          cedula             CHAR(10),
                          num_telefono       VARCHAR(15),
                          rol                VARCHAR(20)  NOT NULL
                              CHECK (rol IN ('ADMIN','CAJERO','SUPERVISOR')),
                          secret_2fa         VARCHAR(100) NULL,
                          estado             BIT          DEFAULT 1,
                          is_deleted         BIT          NOT NULL DEFAULT 0,
                          fecha_creacion     DATETIME2    NOT NULL DEFAULT GETUTCDATE(),
                          fecha_modificacion DATETIME2    NOT NULL DEFAULT GETUTCDATE(),
                          aux1               VARCHAR(100),
                          aux2               VARCHAR(100),
                          aux3               VARCHAR(100),

                          CONSTRAINT fk_usuario_empresa
                              FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)
);

-- ============================================================
-- USUARIOS <-> SUCURSALES  (tabla pivote)
-- CORRECCIÓN: UNIQUE para evitar duplicados
-- ============================================================
CREATE TABLE usuarios_sucursaltbl (
                                      id_Usu_Suc  INT IDENTITY(1,1) PRIMARY KEY,
                                      id_empresa  INT NOT NULL,
                                      id_usuario  INT NOT NULL,
                                      id_sucursal INT NOT NULL,

                                      CONSTRAINT UX_usuario_sucursal UNIQUE (id_usuario, id_sucursal),

                                      CONSTRAINT fk_usu_suc_sucursal
                                          FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal),

                                      CONSTRAINT fk_usu_suc_empresa
                                          FOREIGN KEY (id_empresa ) REFERENCES empresas(id_empresa),

                                      CONSTRAINT fk_usu_suc_usuario
                                          FOREIGN KEY (id_usuario) REFERENCES usuarios(id_user)
);

-- ============================================================
-- APERTURAS DE CAJA
-- ============================================================
CREATE TABLE aperturas_caja (
                                id_apertura              INT           IDENTITY(1,1) PRIMARY KEY,
                                id_caja                  INT           NOT NULL,
                                id_usuario               INT           NOT NULL,

                                fecha_apertura           DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
                                monto_inicial            DECIMAL(18,2) NOT NULL,

                                fecha_cierre             DATETIME2     NULL,
                                total_ventas             DECIMAL(18,2) NULL,
                                total_credito            DECIMAL(18,2) NULL,
                                total_efectivo_sistema   DECIMAL(18,2) NULL,
                                monto_fisico             DECIMAL(18,2) NULL,
                                diferencia               DECIMAL(18,2) NULL,

                                estado                   VARCHAR(20)   NOT NULL DEFAULT 'ABIERTA'
                                    CHECK (estado IN ('ABIERTA','CERRADA')),

                                FOREIGN KEY (id_caja)    REFERENCES cajas(id_caja),
                                FOREIGN KEY (id_usuario) REFERENCES usuarios(id_user),

                                CHECK (
                                    (estado = 'ABIERTA'
                                        AND fecha_cierre IS NULL)
                                        OR
                                    (estado = 'CERRADA'
                                        AND fecha_cierre IS NOT NULL
                                        AND total_ventas IS NOT NULL
                                        AND total_efectivo_sistema IS NOT NULL)
                                    )
);

-- Solo puede haber una apertura ABIERTA por caja a la vez
CREATE UNIQUE INDEX UX_caja_apertura_abierta
    ON aperturas_caja(id_caja)
    WHERE estado = 'ABIERTA';

CREATE INDEX IX_apertura_estado
    ON aperturas_caja(id_caja, estado);

-- ============================================================
-- CLIENTES
-- ============================================================
CREATE TABLE clientes (
                          id_cliente             INT           IDENTITY(1,1) PRIMARY KEY,
                          id_empresa             INT           NOT NULL,
                          nombre                 VARCHAR(100)  NOT NULL,
                          telefono               VARCHAR(20),
                          cedula_ruc             CHAR(13),
                          email                  VARCHAR(100),
                          tipo                   VARCHAR(50),
                          estado                 BIT           DEFAULT 1,
                          is_deleted             BIT           NOT NULL DEFAULT 0,
                          fecha_creacion         DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
                          fecha_eliminacion      DATETIME2     NULL,
                          id_usuario_eliminacion INT           NULL,
                          limite_credito         DECIMAL(18,2) NOT NULL DEFAULT 0
                              CHECK (limite_credito >= 0),
                          dias_credito           INT           NOT NULL DEFAULT 0
                              CHECK (dias_credito >= 0),
                          aux1                   VARCHAR(100),
                          aux2                   VARCHAR(100),
                          aux3                   VARCHAR(100),

                          CONSTRAINT fk_cliente_empresa
                              FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa),

                          CONSTRAINT fK_cliente_usuario_eliminacion
                              FOREIGN KEY (id_usuario_eliminacion) REFERENCES usuarios(id_user),

    -- Soft-delete coherente: si borrado, debe tener fecha y usuario
                          CONSTRAINT CK_clientes_softdelete
                              CHECK (
                                  (is_deleted = 0
                                      AND fecha_eliminacion IS NULL
                                      AND id_usuario_eliminacion IS NULL)
                                      OR
                                  (is_deleted = 1
                                      AND fecha_eliminacion IS NOT NULL
                                      AND id_usuario_eliminacion IS NOT NULL)
                                  )
);

CREATE INDEX IX_clientes_cedula
    ON clientes(cedula_ruc);

-- ============================================================
-- VENTAS
-- ============================================================
CREATE TABLE ventas (
                        id_venta          INT           IDENTITY(1,1) PRIMARY KEY,
                        id_empresa        INT           NOT NULL,
                        id_cliente        INT           NOT NULL,
                        id_caja           INT           NOT NULL,
                        id_usuario        INT           NOT NULL,
                        id_apertura       INT           NOT NULL,

                        tipo_venta        VARCHAR(20)   NOT NULL
                            CHECK (tipo_venta IN ('CONTADO','CREDITO')),
                        tipo_documento    VARCHAR(20)   NOT NULL DEFAULT 'VENTA'
                            CHECK (tipo_documento IN ('VENTA','DEVOLUCION')),

                        efectivo_recibido DECIMAL(18,2) NOT NULL,
                        monto_total       DECIMAL(18,2) NOT NULL,
                        monto_vuelto      DECIMAL(18,2) NOT NULL,

                        fecha_venta       DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
                        id_venta_origen   INT           NULL,
                        row_version       ROWVERSION,

                        aux1              VARCHAR(100),
                        aux2              VARCHAR(100),
                        aux3              VARCHAR(100),

    -- Contado: efectivo >= total y vuelto correcto
    -- Crédito: sin efectivo ni vuelto
                        CHECK (
                            (tipo_venta = 'CONTADO'
                                AND efectivo_recibido >= monto_total
                                AND monto_vuelto = efectivo_recibido - monto_total)
                                OR
                            (tipo_venta = 'CREDITO'
                                AND efectivo_recibido = 0
                                AND monto_vuelto = 0)
                            ),

    -- VENTA: monto >= 0 y sin origen
    -- DEVOLUCION: monto <= 0 y con origen
                        CONSTRAINT CK_ventas_montos_validos
                            CHECK (
                                (tipo_documento = 'VENTA'
                                    AND monto_total >= 0
                                    AND id_venta_origen IS NULL)
                                    OR
                                (tipo_documento = 'DEVOLUCION'
                                    AND monto_total <= 0
                                    AND id_venta_origen IS NOT NULL)
                                ),

                        CONSTRAINT fk_ventas_empresa
                            FOREIGN KEY (id_empresa)    REFERENCES empresas(id_empresa),
                        CONSTRAINT fk_ventas_clientes
                            FOREIGN KEY (id_cliente)    REFERENCES clientes(id_cliente),
                        CONSTRAINT fk_ventas_usuario
                            FOREIGN KEY (id_usuario)    REFERENCES usuarios(id_user),
                        CONSTRAINT fk_ventas_caja
                            FOREIGN KEY (id_caja)       REFERENCES cajas(id_caja),
                        CONSTRAINT fk_ventas_apertura
                            FOREIGN KEY (id_apertura)   REFERENCES aperturas_caja(id_apertura),
                        CONSTRAINT fk_ventas_devolucion
                            FOREIGN KEY (id_venta_origen) REFERENCES ventas(id_venta)
);

-- Una venta solo puede tener una devolución
CREATE UNIQUE INDEX UX_devolucion_unica
    ON ventas(id_venta_origen)
    WHERE tipo_documento = 'DEVOLUCION';

CREATE INDEX IX_ventas_caja_fecha
    ON ventas(id_caja, fecha_venta);

CREATE INDEX IX_ventas_apertura
    ON ventas(id_apertura);

CREATE INDEX IX_ventas_cliente_fecha
    ON ventas(id_empresa, id_cliente, fecha_venta);

-- ============================================================
-- PRODUCTOS
-- ============================================================
CREATE TABLE productos (
                           id_producto        INT           IDENTITY(1,1) PRIMARY KEY,
                           id_empresa         INT           NOT NULL,
                           codigo_barras      VARCHAR(50)   NOT NULL,
                           nombre             VARCHAR(40)   NOT NULL,
                           estado             BIT           DEFAULT 1,
                           categoria          VARCHAR(30)   NOT NULL,
                           fecha_creacion     DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
                           fecha_modificacion DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
                           precio_unitario    DECIMAL(18,2) NOT NULL,
                           precio_mayor       DECIMAL(18,2) NOT NULL,
                           tiene_iva          BIT           DEFAULT 1,
                           iva                DECIMAL(5,2)  NOT NULL,

                           CONSTRAINT UX_producto_codigo UNIQUE (id_empresa, codigo_barras),

                           FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa)
);

CREATE INDEX IX_productos_nombre
    ON productos(nombre);

-- ============================================================
-- DETALLE DE VENTA
-- ============================================================
CREATE TABLE detalle_venta (
                               id_detalleVenta INT           IDENTITY(1,1) PRIMARY KEY,
                               id_venta        INT           NOT NULL,
                               id_producto     INT           NOT NULL,

                               cantidad        INT           NOT NULL CHECK (cantidad > 0),
                               precio_unitario DECIMAL(18,2) NOT NULL CHECK (precio_unitario >= 0),
                               subtotal        DECIMAL(18,2) NOT NULL CHECK (subtotal >= 0),
                               descuento       DECIMAL(18,2) NOT NULL DEFAULT 0 CHECK (descuento >= 0),
                               valor_total     DECIMAL(18,2) NOT NULL CHECK (valor_total >= 0),

                               FOREIGN KEY (id_venta)    REFERENCES ventas(id_venta),
                               FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ============================================================
-- INVENTARIO  (stock actual por sucursal)
-- ============================================================
CREATE TABLE inventario (
                            id_sucursal         INT           NOT NULL,
                            id_producto         INT           NOT NULL,
                            id_empresa          INT           NOT NULL,

                            stock               INT           NOT NULL DEFAULT 0 CHECK (stock >= 0),
                            stock_minimo        INT           NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),

                            row_version         ROWVERSION,
                            fecha_actualizacion DATETIME2     NOT NULL DEFAULT GETUTCDATE(),

                            PRIMARY KEY (id_sucursal, id_producto),

                            FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal),
                            FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
                            FOREIGN KEY (id_empresa)  REFERENCES empresas(id_empresa)
);

-- ============================================================
-- MOVIMIENTOS DE INVENTARIO
-- CORRECCIÓN: se agregan id_empresa e id_usuario
-- ============================================================
CREATE TABLE movimientos_inventario (
                                        id_movimiento INT           IDENTITY(1,1) PRIMARY KEY,
                                        id_sucursal   INT           NOT NULL,
                                        id_empresa    INT           NOT NULL,   -- multi-tenant
                                        id_producto   INT           NOT NULL,
                                        id_usuario    INT           NOT NULL,   -- auditoría: quién lo hizo
                                        tipo          VARCHAR(20)   NOT NULL
                                            CHECK (tipo IN ('VENTA','COMPRA','AJUSTE','TRANSFERENCIA')),
                                        referencia    VARCHAR(100),
                                        cantidad      INT           NOT NULL CHECK (cantidad > 0),
                                        id_venta      INT           NULL,
                                        fecha         DATETIME2     DEFAULT GETUTCDATE(),

                                        FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal),
                                        FOREIGN KEY (id_empresa)  REFERENCES empresas(id_empresa),
                                        FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
                                        FOREIGN KEY (id_usuario)  REFERENCES usuarios(id_user),
                                        FOREIGN KEY (id_venta)    REFERENCES ventas(id_venta),

    -- VENTA debe tener id_venta; COMPRA/AJUSTE/TRANSFERENCIA no
                                        CONSTRAINT CK_MOVIMIENTO_INV_COHERENCIA
                                            CHECK (
                                                (tipo = 'VENTA' AND id_venta IS NOT NULL)
                                                    OR
                                                (tipo IN ('COMPRA','AJUSTE','TRANSFERENCIA') AND id_venta IS NULL)
                                                )
);

CREATE INDEX IX_movimientos_inventario_producto_sucursal
    ON movimientos_inventario(id_sucursal, id_producto);

-- ============================================================
-- MOVIMIENTOS DE CAJA
-- CORRECCIÓN: PAGO_CREDITO referencia id_pago (pagos_credito),
--             no id_venta. Se separa la FK en dos columnas.
-- ============================================================
CREATE TABLE movimientos_caja (
                                  id_movimiento INT           IDENTITY(1,1) PRIMARY KEY,
                                  id_apertura   INT           NOT NULL,
                                  id_usuario    INT           NOT NULL,
                                  tipo          VARCHAR(20)   NOT NULL
                                      CHECK (tipo IN ('VENTA','PAGO_CREDITO','RETIRO','INGRESO','AJUSTE')),
                                  monto         DECIMAL(18,2) NOT NULL CHECK (monto > 0),
                                  descripcion   VARCHAR(200),
                                  fecha         DATETIME2     DEFAULT GETUTCDATE(),

    -- Solo para tipo VENTA
                                  id_venta      INT           NULL,
    -- Solo para tipo PAGO_CREDITO
                                  id_pago       INT           NULL,

                                  FOREIGN KEY (id_apertura) REFERENCES aperturas_caja(id_apertura),
                                  FOREIGN KEY (id_usuario)  REFERENCES usuarios(id_user),
                                  FOREIGN KEY (id_venta)    REFERENCES ventas(id_venta),
    -- FK a pagos_credito se define después de crear esa tabla
    -- (ver ALTER TABLE al final del script)

    -- Coherencia: cada tipo referencia la columna correcta
                                  CONSTRAINT CK_movimientos_caja_coherencia
                                      CHECK (
                                          (tipo = 'VENTA'
                                              AND id_venta IS NOT NULL
                                              AND id_pago IS NULL)
                                              OR
                                          (tipo = 'PAGO_CREDITO'
                                              AND id_pago IS NOT NULL
                                              AND id_venta IS NULL)
                                              OR
                                          (tipo IN ('RETIRO','INGRESO','AJUSTE')
                                              AND id_venta IS NULL
                                              AND id_pago IS NULL)
                                          )
);

CREATE INDEX IX_movimientos_caja_apertura
    ON movimientos_caja(id_apertura);

-- ============================================================
-- CUENTAS POR COBRAR
-- ============================================================
CREATE TABLE cuentas_por_cobrar (
                                    id_cuenta         INT           IDENTITY(1,1) PRIMARY KEY,
                                    id_empresa        INT           NOT NULL,
                                    id_venta          INT           NOT NULL,
                                    id_cliente        INT           NOT NULL,
                                    saldo_inicial     DECIMAL(18,2) NOT NULL CHECK (saldo_inicial >= 0),
                                    saldo_actual      DECIMAL(18,2) NOT NULL,
                                    estado            VARCHAR(20)   NOT NULL
                                        CHECK (estado IN ('PENDIENTE','PAGADA','VENCIDA')),
                                    fecha_creacion    DATETIME2     DEFAULT GETUTCDATE(),
                                    fecha_vencimiento DATETIME2     NULL,

                                    CHECK (saldo_actual >= 0 AND saldo_actual <= saldo_inicial),

                                    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
                                    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa),

                                    CONSTRAINT FK_cuenta_venta_credito
                                        FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
);

-- Una venta de crédito genera exactamente una cuenta por cobrar
CREATE UNIQUE INDEX UX_cuenta_por_venta
    ON cuentas_por_cobrar(id_venta);

CREATE INDEX IX_cuentas_cliente_estado
    ON cuentas_por_cobrar(id_cliente, estado);

CREATE INDEX IX_cuentas_cliente_saldo
    ON cuentas_por_cobrar(id_cliente, saldo_actual);

-- ============================================================
-- PAGOS DE CRÉDITO
-- ============================================================
CREATE TABLE pagos_credito (
                               id_pago    INT           IDENTITY(1,1) PRIMARY KEY,
                               id_empresa INT           NOT NULL,
                               id_cuenta  INT           NOT NULL,
                               monto      DECIMAL(18,2) NOT NULL CHECK (monto > 0),
                               fecha_pago DATETIME2     DEFAULT GETUTCDATE(),
                               id_usuario INT           NOT NULL,

                               FOREIGN KEY (id_cuenta)  REFERENCES cuentas_por_cobrar(id_cuenta),
                               FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa),
                               FOREIGN KEY (id_usuario) REFERENCES usuarios(id_user)
);

CREATE INDEX IX_pagos_cuenta
    ON pagos_credito(id_cuenta);

-- ============================================================
-- FK diferida: movimientos_caja -> pagos_credito
-- (se crea aquí porque pagos_credito ya existe)
-- ============================================================
ALTER TABLE movimientos_caja
    ADD CONSTRAINT fk_movimientos_caja_pago
        FOREIGN KEY (id_pago) REFERENCES pagos_credito(id_pago);

-- ============================================================
-- VENTAS HISTORIAL
-- CORRECCIÓN: FK a usuarios para id_usuario_modificacion
-- ============================================================
CREATE TABLE ventas_historial (
                                  id_historial             INT            IDENTITY(1,1) PRIMARY KEY,
                                  id_venta                 INT            NOT NULL,
                                  id_empresa               INT            NOT NULL,
                                  id_usuario_modificacion  INT            NOT NULL,
                                  fecha_modificacion       DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
                                  monto_total_anterior     DECIMAL(18,2),
                                  monto_total_nuevo        DECIMAL(18,2),
                                  datos_anteriores         NVARCHAR(MAX),

                                  CONSTRAINT fk_historial_venta
                                      FOREIGN KEY (id_venta)    REFERENCES ventas(id_venta),

                                  FOREIGN KEY (id_empresa)      REFERENCES empresas(id_empresa),

    -- CORRECCIÓN: FK que faltaba
                                  CONSTRAINT fk_historial_usuario
                                      FOREIGN KEY (id_usuario_modificacion) REFERENCES usuarios(id_user)
);

-- ============================================================
-- AUDITORÍA GENERAL
-- ============================================================
CREATE TABLE auditoria (
                           id_auditoria     INT           IDENTITY(1,1) PRIMARY KEY,
                           tabla            VARCHAR(50)   NOT NULL,
                           id_empresa       INT           NOT NULL,
                           id_registro      INT           NOT NULL,
                           accion           VARCHAR(20)   NOT NULL
                               CHECK (accion IN ('INSERT','UPDATE','DELETE')),
                           datos_anteriores NVARCHAR(MAX),
                           datos_nuevos     NVARCHAR(MAX),
                           fecha            DATETIME2     DEFAULT GETUTCDATE(),
                           id_usuario       INT           NULL,

                           FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa),
                           FOREIGN KEY (id_usuario) REFERENCES usuarios(id_user)
);

CREATE INDEX IX_auditoria_tabla_registro
    ON auditoria(tabla, id_registro);


INSERT INTO usuarios (
    id_empresa,
    nombre,
    email,
    pass_hash,
    cedula,
    num_telefono,
    rol,
    estado,
    is_deleted
)
VALUES (
           1, -- empresa
           'Don maximo - Administrador',
           'javiercarchipullaoffice@gmail.com',
           '$2a$10$EjemploHashAdmin1234567890abcdef',
           'o943849372',
           '079217166',
           'ADMIN',
           1,
           0
       );

INSERT INTO usuarios (
    id_empresa,
    nombre,
    email,
    pass_hash,
    cedula,
    num_telefono,
    rol,
    estado,
    is_deleted
)
VALUES (
           1,
           'Yusepi',
           'cajero1@legumfrut.com',
           '$2a$10$EjemploHashCajero1234567890abcd',
           '0923456789',
           '0988888888',
           'CAJERO',
           1,
           0
       );


INSERT INTO empresas (
    nombre_empresa,
    razon_social,
    ruc,
    tipo_contribuyente,
    direccion,
    provincia,
    telefono,
    email_empresa
)
VALUES (
           'Legumfrut SA',
           'Legumfrut Sistema S.A.',
           '0999999999001',
           'SOCIEDAD',
           'Av. 9 de Octubre y Malecón',
           'Guayas',
           '0987625163',
           'admin@legumfrut.com'
       );


select * from empresas;

select * from usuarios;


