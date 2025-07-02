--|USER|------------------------------------
CREATE TABLE users_tbl (
id_user int primary key identity(1,1),
username NVARCHAR(50) NOT NULL UNIQUE,
password_hash NVARCHAR(255) NOT NULL,
email NVARCHAR(100) NOT NULL UNIQUE,
enabled BIT DEFAULT 1
);