--- si el servidor de sqlserver esta por europá habra un desface de tiempo en la fecha de 5 horas aproximadamente

--- por lo que se deberia de usar
SELECT DATEADD(HOUR, -5, GETUTCDATE()) AS HoraEcuador;

---pero si existyen tablas ya creadas con DEFAULT GETDATE()
--- se debe de buscar sui constraint y eliminarlo y cambiar el default

SELECT
    dc.name as nombre_contraint,
    c.name as columna

from sys.default_constraints dc
         join sys.columns c
              ON dc.parent_object_id = c.object_id
                  AND dc.parent_column_id = c.column_id

where OBJECT_NAME(dc.parent_object_id) = 'clientes';

ALTER TABLE clientes
DROP CONSTRAINT DF__clientes__fecha___17036CC0;

ALTER TABLE clientes
    ADD CONSTRAINT DF_clientes_fecha_creacion
        DEFAULT DATEADD(HOUR, -5, GETUTCDATE())
    FOR fecha_creacion;






--- ventas
SELECT dc.name
FROM sys.default_constraints dc
         JOIN sys.columns c
              ON dc.parent_object_id = c.object_id
                  AND dc.parent_column_id = c.column_id
WHERE OBJECT_NAME(dc.parent_object_id) = 'ventas'
  AND c.name = 'fecha_venta';

ALTER TABLE ventas
DROP CONSTRAINT DF__ventas__fecha_ve__1AD3FDA4;

ALTER TABLE ventas
    ADD CONSTRAINT DF_ventas_fecha_venta
        DEFAULT DATEADD(HOUR, -5, GETUTCDATE())
    FOR fecha_venta;