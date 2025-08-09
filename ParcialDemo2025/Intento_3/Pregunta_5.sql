-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-01 00:00:07.082

-- tables
-- Table: CONTRATA
CREATE TABLE CONTRATA (
    id_servicio int  NOT NULL,
    cod_tipo_serv int  NOT NULL,
    DNI int  NOT NULL
);

-- Table: MULTI_SERV
CREATE TABLE MULTI_SERV (
    DNI int  NOT NULL
);

-- Table: SERVICIO
CREATE TABLE SERVICIO (
    cod_tipo_serv int  NOT NULL,
    id_servicio int  NOT NULL,
    nombre_servicio varchar(120)  NOT NULL
);

-- Table: TIPO_SERVICIO
CREATE TABLE TIPO_SERVICIO (
    cod_tipo_serv int  NOT NULL,
    nombre_tipo_serv varchar(40)  NOT NULL,
    descripcion_tipo_serv text  NOT NULL,
    CONSTRAINT AK_TIPO_SERVICIO UNIQUE (nombre_tipo_serv) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: UNI_SERV
CREATE TABLE UNI_SERV (
    DNI int  NOT NULL,
    id_servicio int  NOT NULL,
    cod_tipo_serv int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL
);

-- Table: USUARIO
CREATE TABLE USUARIO (
    DNI int  NOT NULL,
    e_mail varchar(120)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    fecha_nac date  NOT NULL,
    CONSTRAINT AK_USUARIO UNIQUE (e_mail) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Primary keys
ALTER TABLE MULTI_SERV ADD CONSTRAINT PK_MULTI_SERV PRIMARY KEY (DNI);
ALTER TABLE TIPO_SERVICIO ADD CONSTRAINT PK_TIPO_SERVICIO PRIMARY KEY (cod_tipo_serv);
ALTER TABLE UNI_SERV ADD CONSTRAINT PK_UNI_SERV PRIMARY KEY (DNI);
ALTER TABLE USUARIO ADD CONSTRAINT PK_USUARIO PRIMARY KEY (DNI);
-- Resuelto
ALTER TABLE CONTRATA ADD CONSTRAINT PK_CONTRATA PRIMARY KEY (id_servicio, cod_tipo_serv, DNI);
ALTER TABLE SERVICIO ADD CONSTRAINT PK_SERVICIO PRIMARY KEY (id_servicio, cod_tipo_serv);

-- Foreign keys
ALTER TABLE CONTRATA ADD CONSTRAINT FK_CONTRATA_MULTI_SERV
    FOREIGN KEY (DNI)
    REFERENCES MULTI_SERV (DNI);
-- Inicio resuelto
ALTER TABLE UNI_SERV ADD CONSTRAINT FK_CONTRATA_MULTI_SERV
    FOREIGN KEY (DNI)
    REFERENCES MULTI_SERV (DNI)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
-- Fin resuelto

ALTER TABLE MULTI_SERV ADD CONSTRAINT FK_MULTI_SERV_USUARIO
    FOREIGN KEY (DNI)
    REFERENCES USUARIO (DNI)
	ON DELETE  CASCADE
    ON UPDATE  CASCADE;

ALTER TABLE SERVICIO ADD CONSTRAINT FK_SERVICIO_TIPO_SERVICIO
    FOREIGN KEY (cod_tipo_serv)
    REFERENCES TIPO_SERVICIO (cod_tipo_serv);

ALTER TABLE UNI_SERV ADD CONSTRAINT FK_UNI_SERV_SERVICIO
    FOREIGN KEY (id_servicio, cod_tipo_serv)
    REFERENCES SERVICIO (id_servicio, cod_tipo_serv);
-- Inicio resuelto
ALTER TABLE UNI_SERV ADD CONSTRAINT FK_UNI_SERV_USUARIO
    FOREIGN KEY (DNI)
    REFERENCES USUARIO (DNI);
-- Fin resuelto

/* Pregunta 5

Escriba las sentencias sentencias SQL de declaración de claves primarias (PK), claves alterativas (AK)
y claves extranjeras (FK) que faltan teniendo en cuenta los siguiente:

a) Deben definirse las acciones referenciales para que cada vez que se elimine o modifique (PK)
de usuario debe hacerse también de las tablas subtipo en la jerarquía.

b) El nombre del tipo de servicio debe ser único.
CONSTRAINT AK_TIPO_SERVICIO UNIQUE (nombre_tipo_serv) NOT DEFERRABLE  INITIALLY IMMEDIATE */
-- End of file.
