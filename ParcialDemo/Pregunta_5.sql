-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-04 12:38:51.138

-- tables
-- Table: DIRECTIVO
CREATE TABLE DIRECTIVO (
    DNI int  NOT NULL,
    cod_tipo_proy int  NOT NULL,
    id_proyecto int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL
);

-- Table: EMPLEADO
CREATE TABLE EMPLEADO (
    DNI int  NOT NULL,
    e_mail varchar(120)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    fecha_nac date  NOT NULL,
    CONSTRAINT AK_EMPLEADO UNIQUE (e_mail) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: PROYECTO
CREATE TABLE PROYECTO (
    cod_tipo_proy int  NOT NULL,
    id_proyecto int  NOT NULL,
    nombre_proyecto varchar(120)  NOT NULL
);

-- Table: TECNICO
CREATE TABLE TECNICO (
    DNI int  NOT NULL
);

-- Table: TIPO_PROYECTO
CREATE TABLE TIPO_PROYECTO (
    cod_tipo_proy int  NOT NULL,
    nombre_tipo_proy varchar(40)  NOT NULL,
    descripcion_tipo_proy text  NOT NULL,
    CONSTRAINT AK_TIPO_PROYECTO UNIQUE (nombre_tipo_proy) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: TRABAJA_EN
CREATE TABLE TRABAJA_EN (
    cod_tipo_proy int  NOT NULL,
    id_proyecto int  NOT NULL,
    DNI int  NOT NULL
);

-- Primary Key
ALTER TABLE DIRECTIVO ADD CONSTRAINT PK_DIRECTIVO PRIMARY KEY (DNI);
ALTER TABLE EMPLEADO ADD CONSTRAINT PK_EMPLEADO PRIMARY KEY (DNI);
ALTER TABLE TECNICO ADD CONSTRAINT PK_TECNICO PRIMARY KEY (DNI);
ALTER TABLE TIPO_PROYECTO ADD  CONSTRAINT PK_TIPO_PROYECTO PRIMARY KEY (cod_tipo_proy);

-- Resuelto
ALTER TABLE TRABAJA_EN ADD CONSTRAINT PK_TRABAJA_EN PRIMARY KEY (cod_tipo_proy, id_proyecto, DNI);
ALTER TABLE PROYECTO ADD CONSTRAINT PK_PROYECTO PRIMARY KEY (id_proyecto, cod_tipo_proy);

-- Foreign Keys
ALTER TABLE PROYECTO ADD CONSTRAINT FK_PROYECTO_TIPO_PROYECTO
    FOREIGN KEY (cod_tipo_proy)
    REFERENCES TIPO_PROYECTO (cod_tipo_proy);
ALTER TABLE TRABAJA_EN ADD CONSTRAINT FK_TRABAJA_EN_PROYECTO
    FOREIGN KEY (id_proyecto, cod_tipo_proy)
    REFERENCES PROYECTO (id_proyecto, cod_tipo_proy);
ALTER TABLE TRABAJA_EN ADD CONSTRAINT FK_TRABAJA_EN_TECNICO
    FOREIGN KEY (DNI)
    REFERENCES TECNICO (DNI)
    -- Resuelto
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Resuelto
ALTER TABLE TECNICO ADD CONSTRAINT FK_TECNICO_EMPLEADO
    FOREIGN KEY (DNI)
    REFERENCES EMPLEADO (DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
ALTER TABLE DIRECTIVO ADD CONSTRAINT FK_DIRECTIVO_EMPLEADO
    FOREIGN KEY (DNI)
    REFERENCES EMPLEADO (DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
ALTER TABLE DIRECTIVO ADD CONSTRAINT FK_DIRECTIVO_PROYECTO
    FOREIGN KEY (id_proyecto, cod_tipo_proy)
    REFERENCES PROYECTO (id_proyecto, cod_tipo_proy);

-- End of file.

/* Pregunta 5

Escriba las sentencias sentencias SQL de declaración de claves primarias (PK), claves alterativas (AK)
y claves extranjeras (FK) que faltan teniendo en cuenta los siguiente:

a) Deben definirse las acciones referenciales para que cada vez que se elimine o modifique (PK)
de un empleado debe hacerse también de las tablas subtipo de la jerarquía.

b) Los e-mails de los empleados deben ser únicos. */

-- En EMPLEADO esto ya cumple que el e_mail sea único
-- CONSTRAINT AK_EMPLEADO UNIQUE (e_mail) NOT DEFERRABLE  INITIALLY IMMEDIATE
