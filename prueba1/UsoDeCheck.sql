create table users_TBL(
    id int not null,
    nombre nvarchar(20) not null,
    edad int,
    --- sirve para limitar la entrada de datos
    constraint CK_edad check(edad >= 18)

    --- también se puede hacer así, pero no definimos un nombre al constraint
    --- edad int check(edad >20)


);