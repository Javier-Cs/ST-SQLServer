--|CONTACTO|------------------------------------
create table contct_tbl(
id_contact int primary key identity(1,1),
nmbre_contct nvarchar(30) NOT NULL,
url_contct nvarchar(30) NOT NULL,
img_contct nvarchar(100) NOT NULL
);