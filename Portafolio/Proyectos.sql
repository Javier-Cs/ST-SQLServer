--|PROYECTOS|------------------------------------
create table project_tbl(
id_projct int primary key identity(1,1),
titul_projct nvarchar(100) NOT NULL,
descrip_projct nvarchar(600) NOT NULL,
contxt_projct nvarchar(max) NOT NULL,
reposi_projct nvarchar(100) NOT NULL,
imagen_projct nvarchar(200) NOT NULL
);

create table project_skills_tbl(
id_project int NOT NULL,
id_skills int NOT NULL,
primary key(id_project, id_skills),
foreign key(id_project) references project_tbl(id_projct) on delete cascade,
foreign key(id_skills) references skillsUso_tbl(id_skill) on delete cascade,
);