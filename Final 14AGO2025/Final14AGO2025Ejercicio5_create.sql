-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2025-11-24 15:35:17.818

-- tables
-- Table: CONDICION
CREATE TABLE CONDICION (
    id_condicion int  NOT NULL,
    horas_uso int  NOT NULL,
    descripcion text  NOT NULL,
    CONSTRAINT CONDICION_pk PRIMARY KEY (id_condicion)
);

-- Table: EJEMPLAR_EQ
CREATE TABLE EJEMPLAR_EQ (
    nro_ejemplar int  NOT NULL,
    anio int  NOT NULL,
    cod_catalogo int  NOT NULL,
    CONSTRAINT EJEMPLAR_EQ_pk PRIMARY KEY (nro_ejemplar,cod_catalogo)
);

-- Table: EQUIPO
CREATE TABLE EQUIPO (
    cod_catalogo int  NOT NULL,
    nombre_eq varchar(20)  NOT NULL,
    marca varchar(20)  NOT NULL,
    CONSTRAINT EQUIPO_pk PRIMARY KEY (cod_catalogo)
);

-- Table: LO_INTEGRAN
CREATE TABLE LO_INTEGRAN (
    id_prestamo int  NOT NULL,
    nro_ejemplar int  NOT NULL,
    cod_catalogo int  NOT NULL,
    id_condicion int  NOT NULL,
    CONSTRAINT LO_INTEGRAN_pk PRIMARY KEY (id_prestamo,nro_ejemplar,cod_catalogo)
);

-- Table: NO_SOCIO
CREATE TABLE NO_SOCIO (
    nro_celular int  NOT NULL,
    id_usuario int  NOT NULL,
    CONSTRAINT NO_SOCIO_pk PRIMARY KEY (id_usuario)
);

-- Table: PRESTAMO
CREATE TABLE PRESTAMO (
    id_prestamo int  NOT NULL,
    fecha_desde date  NOT NULL,
    fecha_hasta date  NOT NULL,
    id_usuario int  NOT NULL,
    CONSTRAINT PRESTAMO_pk PRIMARY KEY (id_prestamo)
);

-- Table: SOCIO
CREATE TABLE SOCIO (
    nro_carnet int  NOT NULL,
    id_usuario int  NOT NULL,
    CONSTRAINT AK1_SOCIO UNIQUE (nro_carnet) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT SOCIO_pk PRIMARY KEY (id_usuario)
);

-- Table: USUARIO
CREATE TABLE USUARIO (
    id_usuario int  NOT NULL,
    nombre varchar(20)  NOT NULL,
    email varchar(20)  NOT NULL,
    tipo_usu varchar(10)  NOT NULL,
    CONSTRAINT USUARIO_pk PRIMARY KEY (id_usuario)
);

-- foreign keys
-- Reference: EJEMPLAR_EQ_EQUIPO (table: EJEMPLAR_EQ)
ALTER TABLE EJEMPLAR_EQ ADD CONSTRAINT EJEMPLAR_EQ_EQUIPO
    FOREIGN KEY (cod_catalogo)
    REFERENCES EQUIPO (cod_catalogo)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: LO_INTEGRAN_CONDICION (table: LO_INTEGRAN)
ALTER TABLE LO_INTEGRAN ADD CONSTRAINT LO_INTEGRAN_CONDICION
    FOREIGN KEY (id_condicion)
    REFERENCES CONDICION (id_condicion)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: LO_INTEGRAN_EJEMPLAR_EQ (table: LO_INTEGRAN)
ALTER TABLE LO_INTEGRAN ADD CONSTRAINT LO_INTEGRAN_EJEMPLAR_EQ
    FOREIGN KEY (nro_ejemplar, cod_catalogo)
    REFERENCES EJEMPLAR_EQ (nro_ejemplar, cod_catalogo)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: LO_INTEGRAN_PRESTAMO (table: LO_INTEGRAN)
ALTER TABLE LO_INTEGRAN ADD CONSTRAINT LO_INTEGRAN_PRESTAMO
    FOREIGN KEY (id_prestamo)
    REFERENCES PRESTAMO (id_prestamo)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: NO_SOCIO_USUARIO (table: NO_SOCIO)
ALTER TABLE NO_SOCIO ADD CONSTRAINT NO_SOCIO_USUARIO
    FOREIGN KEY (id_usuario)
    REFERENCES USUARIO (id_usuario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PRESTAMO_SOCIO (table: PRESTAMO)
ALTER TABLE PRESTAMO ADD CONSTRAINT PRESTAMO_SOCIO
    FOREIGN KEY (id_usuario)
    REFERENCES SOCIO (id_usuario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: SOCIO_USUARIO (table: SOCIO)
ALTER TABLE SOCIO ADD CONSTRAINT SOCIO_USUARIO
    FOREIGN KEY (id_usuario)
    REFERENCES USUARIO (id_usuario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

