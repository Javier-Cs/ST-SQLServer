if not exists (select * from sys.databases where name = 'ConexionCs_db')
begin
create database ConexionCs_db
end

use
ConexionCs_db
go

create schema conect
    go

create table conect.Persona_tbl(
idPersona int identity(1,1),
nombrePersona nvarchar(40) not null,
apellidoPersona nvarchar(59) not null,
edad int not null,
constraint Pk_id_Persona primary key(idPersona)
)
    go

Insert Into conect.Persona_tbl Values ('Pedro','Reyes',35);
Insert Into conect.Persona_tbl Values ('Marco','Guzman',35);
Insert Into conect.Persona_tbl Values ('Sandra','Medina',35);
Insert Into conect.Persona_tbl Values ('Carlos','Montalvan',35);
Insert Into conect.Persona_tbl Values ('Milagros','Hurtado',35);
Insert Into conect.Persona_tbl Values ('Sebastian','Contreras',35);

select * from conect.Persona_tbl;

select * from conect.Persona_tbl where nombrePersona like 's%'
    go