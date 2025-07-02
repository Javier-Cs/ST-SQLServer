--|CV|------------------------------------
create table contextCv_tbl(
id_contxtCv int primary key identity(1,1),
titulo_cv nvarchar(30) NOT NULL,
contxt_cv nvarchar(max) NOT NULL
);

create table experiencia_tbl(
id_experi int primary key identity(1,1),
titl_experi nvarchar(200) NOT NULL,
tiemp_experi nvarchar(200) NOT NULL,
contxt_experi nvarchar(max) NOT NULL
);

create table skillsUso_tbl(
id_skill int primary key identity(1,1),
imagen_skill nvarchar(100) NOT NULL,
titulo_skill nvarchar(20) NOT NULL
);


--|BLOG|------------------------------------