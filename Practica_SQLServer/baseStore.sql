-- creacion de la base de datos
if not exists(select * from sys.databases
where name = 'TiendaR_bd')
begin
create database TiendaR_bd
end;

-- uso de la base de datos
use TiendaR_bd
go

-- creacion de esquema
create schema store
    go


create table store.Products(
idProdu int identity(1,1) not null,
nameProdu nvarchar(100) not null,
descriProdu nvarchar(max) not null,
priceProdu decimal(10, 2) not null,
dateCreateProdu datetime default getdate(),
sku nvarchar(100) not null,
weightProdu decimal(10,2) not null,
dimencionProdu nvarchar(200) not null,
isActivo bit default (1),
stockProdu int,
id_categoria int not null,
id_marca int not null,
constraint PK_ProductoId primary key(idProdu),
constraint UQ_sku unique(sku),
constraint Fk_Categoria foreign key(id_categoria)
    references store.Categories(idCategoria),
constraint FK_Marca foreign key(id_marca)
    references store.Brands(idBrand)
);


create table store.Categories(
idCategoria int identity(1,1) not null,
nameCateg nvarchar(70) not null,
descriCateg nvarchar(max) not null,
isActivo bit default (1),
constraint UQ_namecate unique(nameCateg),
constraint PK_Categoria_id primary key(idCategoria)
);



create table store.Brands(
idBrand int identity(1,1) not null,
nameBrand nvarchar(100) not null,
descriBrand nvarchar(max) not null,
constraint UQ_nameBrand unique(nameBrand),
constraint PK_Brand_id primary key(idBrand)
);