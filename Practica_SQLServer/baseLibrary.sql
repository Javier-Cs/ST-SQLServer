create database graph_Db;

use graph_Db;
create schema library;

select * from library.books_tbl;
select * from library.authors_tbl;

drop table library.authors_tbl;
drop table library.books_tbl;
drop table library.users_tbl;
drop table library.reserv_tbl;
drop table library.loans_tbl;


-- Tabla para los libros
create table library.books_tbl(
    id int identity(1,1),
    title nvarchar(60) not null,
    year_public int not null,
    editorial nvarchar(50) not null,
    code nvarchar(100) not null,
    state bit not null default 1,
    nume_page int not null,
    id_autor int not null,

    constraint Pk_libroId primary key(id),
    constraint Fk_autorId foreign key(id_autor)
        references library.authors_tbl(id)
);


-- Tabla para los autores
create table library.authors_tbl(
    id int identity(1,1),
    name nvarchar(100) not null,
    last_Name nvarchar(100) not null,

    constraint Pk_autorId primary key(id)
);



-- Tabla para los usuarios
create table library.users_tbl(
    id int identity(1,1),
    name nvarchar(100) not null,
    last_name nvarchar(100) not null,
    email nvarchar(50) not null,
    date_regis date default getDate() not null,

    constraint PK_userId primary key(id)
);


-- Tabla para los préstamos
create table library.loans_tbl(
    id int identity(1,1),
    id_book int not null,
    id_user int not null,
    date_loan date default getdate() not null,
    date_devol_loan date null,
    date_real_de_loan date not null,

    constraint Pk_loanId primary key(id),

    constraint Fk_bookId foreign key(id_book)
        references library.books_tbl(id),

    constraint Fk_userId foreign key(id_user)
        references library.users_tbl(id)
);


-- Tabla para las reservas
create table library.reserv_tbl(
    id int identity(1,1),
    id_book int not null,
    id_user int not null,
    status nvarchar(20) default 'pendiente',
    date_res date default getdate() not null,

    constraint Pk_reservId primary key(id),

    constraint Fk_bookId foreign key(id_book)
        references library.books_tbl(id),

    constraint Fk_userId foreign key(id_user)
        references library.users_tbl(id)
);

