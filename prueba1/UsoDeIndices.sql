--crear la tabla clientes
drop table clientes

CREATE TABLE clientes (
                          id INT,
                          nombre VARCHAR(30),
                          apellido VARCHAR(30),
                          direccion VARCHAR(50),
                          edad INT,
                          telefono VARCHAR(20),
                          fecha_nacimiento DATE
);


--insertar estos registros en la tabla clientes
insert into clientes values(1, 'Juan', 'Perez', 'Calle 123', 25, '555-1234', '2000-01-01');
insert into clientes values(2, 'Maria', 'Lopez', 'Avenida 456', 30, '555-5678', '1995-05-10');
insert into clientes values(3, 'Carlos', 'Gomez', 'Carrera 789', 40, '555-9012', '1983-12-15');
insert into clientes values(4, 'Ana', 'Rodriguez', 'Plaza 789', 32, '555-4321', '1989-08-20');
insert into clientes values(5, 'Pedro', 'Martinez', 'Avenida 987', 45, '555-6789', '1978-03-05');
insert into clientes values(6, 'Laura', 'Sanchez', 'Calle 456', 27, '555-0987', '1996-11-12');
insert into clientes values(7, 'Luis', 'Hernandez', 'Calle 654', 38, '555-3456', '1984-07-25');
insert into clientes values(8, 'Carolina', 'Torres', 'Avenida 321', 29, '555-8765', '1992-09-03');
insert into clientes values(9, 'Diego', 'Gonzalez', 'Carrera 246', 42, '555-6543', '1979-06-18');
insert into clientes values(10, 'Sofia', 'Rojas', 'Plaza 135', 31, '555-2109', '1990-04-14');
insert into clientes values(11, 'Andres', 'Fernandez', 'Calle 789', 37, '555-1092', '1985-02-28');
insert into clientes values(12, 'Valentina', 'Morales', 'Calle 246', 26, '555-5432', '1997-10-23');
insert into clientes values(13, 'Roberto', 'Gutierrez', 'Avenida 753', 43, '555-4321', '1978-12-09');
insert into clientes values(14, 'Daniela', 'Navarro', 'Plaza 159', 33, '555-6789', '1988-06-14');
insert into clientes values(15, 'Jorge', 'Paz', 'Carrera 357', 44, '555-0987', '1977-01-30');
insert into clientes values(16, 'Catalina', 'Silva', 'Calle 852', 28, '555-3456', '1995-11-05');
insert into clientes values(17, 'Gonzalo', 'Luna', 'Avenida 951', 39, '555-8765', '1982-08-12');
insert into clientes values(18, 'Camila', 'Vargas', 'Carrera 753', 30, '555-6543', '1993-03-28');
insert into clientes values(19, 'Felipe', 'Cortes', 'Calle 357', 35, '555-2109', '1986-09-13');
insert into clientes values(20, 'Marcela', 'Ortega', 'Plaza 852', 37, '555-1092', '1985-02-28');


select * from clientes;

--- Indices ---
create clustered index Indx_cliente
on clientes(id);
