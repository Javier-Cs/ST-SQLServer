---- solo puede existir uno por tabla

create table libros_TBL(
    --- identity aumenta el id de 1 en 1
    --- (1,1) sirve par definir el tipo de aumento  del id
    codigo int identity(1,1),
    titulo nvarchar(60) not null,
    autor nvarchar(40) not null
);

insert into libros values ('La elegancia del erizo','Juanin');
insert into libros values ('La luz','Pilar');
insert into libros values ('El valle','Marina');

--- si eliminamos un registro de la tabla
--- el id se remueve y no se puede volver a usar
delete from libros_TBL where codigo = 2;