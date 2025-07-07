create table clientes(
                         idcliente int not null primary key,
                         nombre varchar(20) not null,
                         apellido varchar(20) not null,
                         direccion varchar(100) not null,
                         pais varchar(50) not null,
                         ciudad varchar(30) not null);


insert into clientes values(1, 'Juan', 'Pérez', 'Calle Principal 123', 'México', 'Ciudad de México');
insert into clientes values(2, 'María', 'Gómez', 'Avenida Central 456', 'España', 'Madrid');
insert into clientes values(3, 'Carlos', 'López', 'Rua Principal 789', 'Brasil', 'Río de Janeiro');
insert into clientes values(4, 'Ana', 'Rodríguez', '123 Main Street', 'Estados Unidos', 'Nueva York');
insert into clientes values(5, 'Luis', 'Fernández', 'Rue Principale 456', 'Francia', 'París');
insert into clientes values(6, 'Laura', 'García', 'Hauptstrasse 789', 'Alemania', 'Berlín');
insert into clientes values(7, 'Pedro', 'Martínez', 'Via Roma 123', 'Italia', 'Roma');
insert into clientes values(8, 'Sofía', 'Hernández', 'Rua Principal 456', 'Portugal', 'Lisboa');
insert into clientes values(9, 'Diego', 'Torres', 'Calle Mayor 789', 'Argentina', 'Buenos Aires');
insert into clientes values(10, 'Valentina', 'Luna', '123 First Street', 'Canadá', 'Toronto');
insert into clientes values(11, 'Andrés', 'Silva', 'Rue Principale 456', 'Suiza', 'Zúrich');
insert into clientes values(12, 'Camila', 'Chavez', 'Hauptstrasse 789', 'Austria', 'Viena');
insert into clientes values(13, 'Miguel', 'Vargas', 'Via Roma 123', 'Italia', 'Roma');
insert into clientes values(14, 'Paula', 'Castillo', 'Rua Principal 456', 'Portugal', 'Lisboa');
insert into clientes values(15, 'Gustavo', 'Mendoza', 'Calle Mayor 789', 'Chile', 'Santiago');
insert into clientes values(16, 'Fernanda', 'Paz', '123 Main Street', 'Australia', 'Sídney');
insert into clientes values(17, 'Roberto', 'Ruíz', 'Rue Principale 456', 'Bélgica', 'Bruselas');
insert into clientes values(18, 'Lucía', 'Sanchez', 'Hauptstrasse 789', 'Holanda', 'Ámsterdam');
insert into clientes values(19, 'Javier', 'Gallardo', 'Via Roma 123', 'Italia', 'Roma');
insert into clientes values(20, 'Isabella', 'Ortega', 'Rua Principal 456', 'Portugal', 'Lisboa');
insert into clientes values(21, 'Manuel', 'Santos', 'Avenida Central 789', 'España', 'Barcelona');
insert into clientes values(22, 'Julia', 'Herrera', 'Rua Principal 123', 'Brasil', 'São Paulo');
insert into clientes values(23, 'Fernando', 'González', '123 Main Street', 'Estados Unidos', 'Los Ángeles');
insert into clientes values(24, 'Carolina', 'Navarro', 'Rue Principale 456', 'Francia', 'Marsella');
insert into clientes values(25, 'Gabriel', 'López', 'Hauptstrasse 789', 'Alemania', 'Hamburgo');
insert into clientes values(26, 'Valeria', 'Rojas', 'Via Roma 123', 'Italia', 'Venecia');
insert into clientes values(27, 'Ricardo', 'Montes', 'Rua Principal 456', 'Portugal', 'Oporto');
insert into clientes values(28, 'Marcela', 'Chávez', 'Calle Mayor 789', 'Argentina', 'Córdoba');
insert into clientes values(29, 'Jorge', 'Figueroa', '123 First Street', 'Canadá', 'Montreal');
insert into clientes values(30, 'Renata', 'Vargas', 'Rue Principale 456', 'Suiza', 'Ginebra');
insert into clientes values(31, 'Mateo', 'Castro', 'Hauptstrasse 789', 'Austria', 'Salzburgo');
insert into clientes values(32, 'Daniela', 'Peña', 'Via Roma 123', 'Italia', 'Florencia');
insert into clientes values(33, 'Sebastián', 'Lara', 'Rua Principal 456', 'Portugal', 'Lisboa');
insert into clientes values(34, 'Valentina', 'Salazar', 'Calle Mayor 789', 'Chile', 'Valparaíso');
insert into clientes values(35, 'Martín', 'Ortiz', '123 Main Street', 'Australia', 'Melbourne');
insert into clientes values(36, 'Catalina', 'Soto', 'Rue Principale 456', 'Bélgica', 'Lieja');
insert into clientes values(37, 'Alejandro', 'Ríos', 'Hauptstrasse 789', 'Holanda', 'Róterdam');
insert into clientes values(38, 'Isabel', 'Silva', 'Via Roma 123', 'Italia', 'Roma');
insert into clientes values(39, 'Leonardo', 'Guerrero', 'Rua Principal 456', 'Portugal', 'Lisboa');
insert into clientes values(40, 'Renata', 'Molina', 'Calle Mayor 789', 'Argentina', 'Rosario');


select * from clientes;

select * from clientes
where pais='Italia' and ciudad='Roma';

select * from clientes
where ciudad='Venecia' or ciudad='Roma';

select * from clientes
where not pais = 'Alemania' and not pais = 'Italia';
