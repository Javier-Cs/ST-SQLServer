CREATE DATABASE ProcesosDB;
USE ProcesosDB;

--- validacion de tabla existente
if not exists (select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_CATALOG = 'PersonaPr_Tbl')

CREATE TABLE PersonaPr_Tbl(
Id int primary key identity(1,1),
cedula nvarchar(12) not null,
nombres nvarchar(89) not null,
apellidos nvarchar(100) not null,
telefono nvarchar(13) not null,
foto varbinary(MAX)null,
estado bit default 1,
fecha_registro datetime default getdate()
)

SELECT * FROM PersonaPr_Tbl;

--- SP ---
--- Agregar personas ---

CREATE PROCEDURE SP_CrearPersona(
    @CEDULA NVARCHAR(12),
    @NOMBRES NVARCHAR(89),
    @APELLIDOS NVARCHAR(100),
    @TELEFONO NVARCHAR(13),
    @FOTO VARBINARY(MAX),
    @RESULTADO BIT OUTPUT
)
    AS
BEGIN
	SET @RESULTADO = 1
	IF NOT EXISTS (SELECT  * FROM [dbo].[PersonaPr_Tbl] WHERE cedula = @CEDULA)
		INSERT INTO [dbo].[PersonaPr_Tbl](cedula, nombres, apellidos, telefono, foto)
		VALUES(@CEDULA, @NOMBRES, @APELLIDOS, @TELEFONO, @FOTO)
	ELSE
		SET @RESULTADO = 0

END
GO

