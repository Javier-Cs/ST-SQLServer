--- nos conectamos con el usuario SA
--- ejecutamos esta setencia una solo vez

    CREATE LOGIN nomdre_de_usuario_nuevo
    WITH PASSWORD = 'contraseña_de_usuario',
    CHECK_POLICY = ON;

--- nomdre_de_usuario_nuevo, YA EXISTE
--- Pero NO puede entrar a ninguna base


--- elegimos una base de datos o la creamos

USE la_base_de_datos;
GO

CREATE USER cap_javiuser FOR LOGIN cap_javiuser;

--- asignamos los permisos necesarios

ALTER ROLE db_datareader ADD MEMBER cap_javiuser;
ALTER ROLE db_datawriter ADD MEMBER cap_javiuser;
GRANT EXECUTE TO cap_javiuser;

--- SPs en otro schema (ojo aquí)
GRANT EXECUTE ON SCHEMA::app TO cap_javiuser;