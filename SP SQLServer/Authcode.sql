
select * from PermisosEmpresas

--------create dataBase pruebasDB;
--------use pruebasDB;

create table credenciales_tbl(
                                 codigo int identity(1,1) primary key,
                                 usuario varchar(50) not null unique,
                                 codeempresa varchar(10) not null,
                                 pass varchar(200),
                                 fechacreacion Datetime not null default Getdate(),
                                 puedcreartk bit not null default 0,
                                 activo bit not null default 1
);

insert into credenciales_tbl (usuario,codeempresa,pass)values('javier', '100', 'RegularXM12');

select * from credenciales_tbl

update credenciales_tbl
set activo = 1
where codigo = 1 and codeempresa = '100';




--sp
create PROCEDURE sp_validarUser
    @usuario VARCHAR(50),
    @pass VARCHAR(200),
    @codiRespuest CHAR(3) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
@activo BIT,
        @puedeCrearTk BIT;

    -- 1. Verificar usuario y contraseña
SELECT
    @activo = activo,
    @puedeCrearTk = puedcreartk
FROM credenciales_tbl
WHERE usuario = @usuario
  AND pass = @pass;

-- Usuario o password incorrectos
IF @activo IS NULL
BEGIN
        SET @codiRespuest = '000';
        RETURN;
END

    -- Usuario inactivo
    IF @activo = 0
BEGIN
        SET @codiRespuest = '001';
        RETURN;
END

    -- No puede crear token
    IF @puedeCrearTk = 0
BEGIN
        SET @codiRespuest = '005';
        RETURN;
END

    -- OK
    SET @codiRespuest = '002';
END;
GO

exec sp_validarUser 'javier', 'RegularXM12'
