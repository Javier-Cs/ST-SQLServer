CREATE TABLE Empleados_TBL(
NOMBRE VARCHAR(20),
APELLIDO VARCHAR(30),
EDAD NUMERIC(2),
TELEFONO NUMERIC(10),
DIRECCION VARCHAR(100),
FECHA_NACIMIENTO DATE,
SALARIO DECIMAL(18,2),
ACTIVO CHAR(2)
);

EXEC SP_HELP Empleados_TBL


---- modificacion de la tabla Empleados_TBL
ALTER TABLE Empleados_TBL
    ADD ID_EMPLEADO INT

INSERT INTO Empleados_TBL VALUES('MARIA','LOPEZ',23,0965432865,'CALLE V Y LA TERCERA AVENIDA','2025-05-30',470.00, 'SI',1);
INSERT INTO Empleados_TBL VALUES('JORGE','SANCHEZ',27,6751146000,'CALLE Y Y LA 3 AVENIDA','2023-05-14',373.70, 'SI',3);
INSERT INTO Empleados_TBL VALUES('MARTA','HERNANDEZ',18,1996442000,'CALLE Y Y LA 8 AVENIDA','2024-10-17',326.26, 'SI',4);
INSERT INTO Empleados_TBL VALUES('ANA','GOMEZ',27,9676505000,'CALLE X Y LA 1 AVENIDA','2023-09-12',896.10, 'NO',2);
INSERT INTO Empleados_TBL VALUES('SOFIA','CASTILLO',53,2037486000,'CALLE X Y LA 9 AVENIDA','2024-03-09',908.56, 'NO',1);
INSERT INTO Empleados_TBL VALUES('LUIS','MORALES',36,8787733000,'CALLE Y Y LA 10 AVENIDA','2024-07-10',429.27, 'SI',2);
INSERT INTO Empleados_TBL VALUES('JUAN','PEREZ',56,7689536000,'CALLE X Y LA 1 AVENIDA','2024-12-22',398.38, 'NO',2);
INSERT INTO Empleados_TBL VALUES('LUIS','LOPEZ',55,3494952000,'CALLE Z Y LA 2 AVENIDA','2025-11-09',575.12, 'NO',2);
INSERT INTO Empleados_TBL VALUES('LUIS','SANCHEZ',47,9982027000,'CALLE Z Y LA 10 AVENIDA','2023-11-18',666.41, 'NO',4);
INSERT INTO Empleados_TBL VALUES('LUIS','LOPEZ',52,4704155000,'CALLE Y Y LA 1 AVENIDA','2023-01-15',758.98, 'SI',3);
INSERT INTO Empleados_TBL VALUES('LUIS','HERNANDEZ',61,9370147000,'CALLE V Y LA 1 AVENIDA','2023-04-13',716.50, 'SI',4);


SELECT * FROM Empleados_TBL;
select top 5 * from Empleados_TBL;


---  uso de top para obtener el 50% de empleados
select top 50 percent * from Empleados_TBL;

--- uso de top usando filtro where para obrtener 3 empleados que su estado se 'NO'
select top 3 * from Empleados_TBL
where ACTIVO = 'NO';