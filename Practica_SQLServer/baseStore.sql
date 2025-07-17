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

-- Eliminación de tablas en orden inverso de dependencia para evitar errores
-- (Si se ejecuta el script completo, es útil para recrear la DB)
drop table if exists store.OrderItems;
drop table if exists store.Orders;
drop table if exists store.Inventory;
drop table if exists store.Users;
drop table if exists store.Products;
drop table if exists store.Categories;
drop table if exists store.Brands;


create table store.Categories(
CategoryId int identity(1,1) not null,
Name nvarchar(70) not null,
Description nvarchar(max) not null,
IsActive bit default (1),
constraint UQ_CategoryName unique(Name),
constraint PK_CategoryId primary key(CategoryId)
);

create table store.Brands(
BrandId int identity(1,1) not null,
Name nvarchar(100) not null,
Description nvarchar(max) not null,
constraint UQ_BrandName unique(Name),
constraint PK_BrandId primary key(BrandId)
);

create table store.Products(
ProductId int identity(1,1) not null,
Name nvarchar(100) not null,
Description nvarchar(max) not null,
Price decimal(10, 2) not null,
DateCreated datetime default getdate(),
SKU nvarchar(100) not null,
Weight decimal(10,2) not null,
Dimensions nvarchar(200) not null,
IsActive bit default (1),
CategoryId int not null,
BrandId int not null,
constraint PK_ProductId primary key(ProductId),
constraint UQ_SKU unique(SKU),
constraint FK_Category foreign key(CategoryId)
    references store.Categories(CategoryId),
constraint FK_Brand foreign key(BrandId)
    references store.Brands(BrandId)
);

create table store.Users(
UserId int identity(1,1) not null,
Name nvarchar(200) not null,
Email nvarchar(200) not null,
Phone nvarchar(20) not null,
RegisteredAt datetime default getdate(),
IsActive bit default(1),
constraint UQ_Email unique(Email),
constraint PK_UserId primary key(UserId)
);

create table store.Inventory(
InventoryId int identity(1,1) not null,
ProductId int unique, -- Unique para relación 1 a 1 con Product
Stock int,
LastUpdated datetime default getdate(),
constraint PK_InventoryId primary key(InventoryId),
constraint FK_Product_Inventory foreign key(ProductId)
    references store.Products(ProductId)
);

create table store.Orders(
OrderId int identity(1,1) not null,
UserId int not null,
OrderDate datetime default getdate(),
TotalAmount decimal(10,2) not null,
Status nvarchar(20) default 'enviado',
PaymentMethod nvarchar(50) not null,
ShippingCost decimal(10,2) not null,
constraint PK_OrderId primary key(OrderId),
constraint FK_User_Order foreign key(UserId)
    references store.Users(UserId)
);

create table store.OrderItems(
OrderItemId int identity(1,1) not null,
OrderId int not null,
ProductId int not null,
Quantity int not null, -- Cambiado a INT si siempre son cantidades enteras
Subtotal decimal(10,2) not null,
constraint PK_OrderItemId primary key(OrderItemId),
constraint FK_Order_OrderItem foreign key(OrderId)
     references store.Orders(OrderId),
constraint FK_Product_OrderItem foreign key(ProductId)
     references store.Products(ProductId)
);