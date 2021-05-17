create database subastas
go
use subastas
go
create table usuarios(
    dni int,
    mail varchar(100) not null unique,
    nombre varchar(60) not null,
    apellido varchar(60) not null,
    primary key(dni)
)
go
create table subasta(
    id int identity(1,1),
    descripción varchar(500) not null,
    precioBase money not null,
    usuario int,
    fechaInicio smalldatetime,
    fechaFin smalldatetime,
    primary key(id),
    foreign key(usuario) references usuarios(dni)
)
go
create table oferta(
    subasta int, 
    usuario int,
    precio money not null,
    fecha smalldatetime not null,
    primary key(subasta,usuario),
    foreign key(subasta) references subasta(id),
    foreign key(usuario) references usuarios(dni)
)

