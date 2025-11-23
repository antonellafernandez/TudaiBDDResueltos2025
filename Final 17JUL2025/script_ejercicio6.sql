-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-02-12 13:41:12.77

-- tables
-- Table: DISCIPLINA
CREATE TABLE DISCIPLINA (
    codigo_disciplina int  NOT NULL,
    nombre varchar(120)  NOT NULL,
    descripcion text  NOT NULL
);

-- Table: ESTADIO
CREATE TABLE ESTADIO (
    id_estado int  NOT NULL,
    nombre_estado varchar(120)  NOT NULL
);

-- Table: INVESTIGADOR
CREATE TABLE INVESTIGADOR (
    id_investigador int  NOT NULL,
    dni int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    apellido varchar(60)  NOT NULL,
    direccion varchar(120)  NOT NULL,
    fecha_nacimiento date  NOT NULL
);

-- Table: PROYECTO
CREATE TABLE PROYECTO (
    codigo_proyecto int  NOT NULL,
    nombr varchar(120)  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NOT NULL,
    monto numeric(10,0)  NOT NULL
);

-- Table: TAREA
CREATE TABLE TAREA (
    id_tarea int  NOT NULL,
    nombre_tarea varchar(120)  NOT NULL,
    horas int  NOT NULL
);

-- End of file.

