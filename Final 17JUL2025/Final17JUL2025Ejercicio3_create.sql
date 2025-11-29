-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2025-11-24 15:15:36.324

-- tables
-- Table: DISCIPLINA
CREATE TABLE DISCIPLINA (
    codigo_disciplina int  NOT NULL,
    nombre varchar(120)  NOT NULL,
    descripcion text  NOT NULL,
    CONSTRAINT DISCIPLINA_pk PRIMARY KEY (codigo_disciplina)
);

-- Table: ESTADIO
CREATE TABLE ESTADIO (
    id_estado int  NOT NULL,
    nombre_estado varchar(120)  NOT NULL,
    CONSTRAINT ESTADIO_pk PRIMARY KEY (id_estado)
);

-- Table: ESTA_ASIGNADO
CREATE TABLE ESTA_ASIGNADO (
    codigo_disciplina int  NOT NULL,
    id_investigador int  NOT NULL,
    codigo_proyecto int  NOT NULL,
    CONSTRAINT ESTA_ASIGNADO_pk PRIMARY KEY (codigo_disciplina,id_investigador,codigo_proyecto)
);

-- Table: INVESTIGADOR
CREATE TABLE INVESTIGADOR (
    id_investigador int  NOT NULL,
    dni int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    apellido varchar(60)  NOT NULL,
    direccion varchar(120)  NOT NULL,
    fecha_nacimiento date  NOT NULL,
    CONSTRAINT INVESTIGADOR_pk PRIMARY KEY (id_investigador)
);

-- Table: PROYECTO
CREATE TABLE PROYECTO (
    codigo_proyecto int  NOT NULL,
    nombre varchar(120)  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL,
    monto decimal(10,0)  NOT NULL,
    id_investigador int  NOT NULL,
    id_estado int  NOT NULL,
    CONSTRAINT AK1_PROYECTO UNIQUE (id_investigador) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT PROYECTO_pk PRIMARY KEY (codigo_proyecto)
);

-- Table: SABE_REALIZAR
CREATE TABLE SABE_REALIZAR (
    id_investigador int  NOT NULL,
    id_tarea int  NOT NULL,
    CONSTRAINT SABE_REALIZAR_pk PRIMARY KEY (id_investigador,id_tarea)
);

-- Table: SE_DESEMPENIA
CREATE TABLE SE_DESEMPENIA (
    codigo_disciplina int  NOT NULL,
    id_investigador int  NOT NULL,
    CONSTRAINT SE_DESEMPENIA_pk PRIMARY KEY (codigo_disciplina,id_investigador)
);

-- Table: TAREA
CREATE TABLE TAREA (
    id_tarea int  NOT NULL,
    nombre varchar(120)  NOT NULL,
    horas int  NOT NULL,
    CONSTRAINT TAREA_pk PRIMARY KEY (id_tarea)
);

-- Table: TELEFONO_INVESTIGADOR
CREATE TABLE TELEFONO_INVESTIGADOR (
    id_investigador int  NOT NULL,
    telefono varchar(15)  NOT NULL,
    CONSTRAINT TELEFONO_INVESTIGADOR_pk PRIMARY KEY (id_investigador,telefono)
);

-- foreign keys
-- Reference: ESTA_ASIGNADO_PROYECTO (table: ESTA_ASIGNADO)
ALTER TABLE ESTA_ASIGNADO ADD CONSTRAINT ESTA_ASIGNADO_PROYECTO
    FOREIGN KEY (codigo_proyecto)
    REFERENCES PROYECTO (codigo_proyecto)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: ESTA_ASIGNADO_SE_DESEMPENIA (table: ESTA_ASIGNADO)
ALTER TABLE ESTA_ASIGNADO ADD CONSTRAINT ESTA_ASIGNADO_SE_DESEMPENIA
    FOREIGN KEY (codigo_disciplina, id_investigador)
    REFERENCES SE_DESEMPENIA (codigo_disciplina, id_investigador)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PROYECTO_ESTADIO (table: PROYECTO)
ALTER TABLE PROYECTO ADD CONSTRAINT PROYECTO_ESTADIO
    FOREIGN KEY (id_estado)
    REFERENCES ESTADIO (id_estado)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PROYECTO_INVESTIGADOR (table: PROYECTO)
ALTER TABLE PROYECTO ADD CONSTRAINT PROYECTO_INVESTIGADOR
    FOREIGN KEY (id_investigador)
    REFERENCES INVESTIGADOR (id_investigador)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: SABE_REALIZAR_INVESTIGADOR (table: SABE_REALIZAR)
ALTER TABLE SABE_REALIZAR ADD CONSTRAINT SABE_REALIZAR_INVESTIGADOR
    FOREIGN KEY (id_investigador)
    REFERENCES INVESTIGADOR (id_investigador)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: SABE_REALIZAR_TAREA (table: SABE_REALIZAR)
ALTER TABLE SABE_REALIZAR ADD CONSTRAINT SABE_REALIZAR_TAREA
    FOREIGN KEY (id_tarea)
    REFERENCES TAREA (id_tarea)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: SE_DESEMPENIA_DISCIPLINA (table: SE_DESEMPENIA)
ALTER TABLE SE_DESEMPENIA ADD CONSTRAINT SE_DESEMPENIA_DISCIPLINA
    FOREIGN KEY (codigo_disciplina)
    REFERENCES DISCIPLINA (codigo_disciplina)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: SE_DESEMPENIA_INVESTIGADOR (table: SE_DESEMPENIA)
ALTER TABLE SE_DESEMPENIA ADD CONSTRAINT SE_DESEMPENIA_INVESTIGADOR
    FOREIGN KEY (id_investigador)
    REFERENCES INVESTIGADOR (id_investigador)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: TELEFONO_INVESTIGADOR_INVESTIGADOR (table: TELEFONO_INVESTIGADOR)
ALTER TABLE TELEFONO_INVESTIGADOR ADD CONSTRAINT TELEFONO_INVESTIGADOR_INVESTIGADOR
    FOREIGN KEY (id_investigador)
    REFERENCES INVESTIGADOR (id_investigador)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

