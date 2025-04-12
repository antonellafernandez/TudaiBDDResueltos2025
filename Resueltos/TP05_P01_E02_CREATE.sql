-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-24 19:20:52.273

-- tables
-- Table: TP5_P1_EJ2_AUSPICIO
CREATE TABLE TP5_P1_EJ2_AUSPICIO (
    id_proyecto int  NOT NULL,
    nombre_auspiciante varchar(20)  NOT NULL,
    tipo_empleado char(2)  NULL,
    nro_empleado int  NULL,
    CONSTRAINT TP5_P1_EJ2_AUSPICIO_pk PRIMARY KEY (id_proyecto,nombre_auspiciante)
);

-- Table: TP5_P1_EJ2_EMPLEADO
CREATE TABLE TP5_P1_EJ2_EMPLEADO (
    tipo_empleado char(2)  NOT NULL,
    nro_empleado int  NOT NULL,
    nombre varchar(40)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    cargo varchar(15)  NOT NULL,
    CONSTRAINT TP5_P1_EJ2_EMPLEADO_pk PRIMARY KEY (tipo_empleado,nro_empleado)
);

-- Table: TP5_P1_EJ2_PROYECTO
CREATE TABLE TP5_P1_EJ2_PROYECTO (
    id_proyecto int  NOT NULL,
    nombre_proyecto varchar(40)  NOT NULL,
    anio_inicio int  NOT NULL,
    anio_fin int  NULL,
    CONSTRAINT TP5_P1_EJ2_PROYECTO_pk PRIMARY KEY (id_proyecto)
);

-- Table: TP5_P1_EJ2_TRABAJA_EN
CREATE TABLE TP5_P1_EJ2_TRABAJA_EN (
    tipo_empleado char(2)  NOT NULL,
    nro_empleado int  NOT NULL,
    id_proyecto int  NOT NULL,
    cant_horas int  NOT NULL,
    tarea varchar(20)  NOT NULL,
    CONSTRAINT TP5_P1_EJ2_TRABAJA_EN_pk PRIMARY KEY (tipo_empleado,nro_empleado,id_proyecto)
);

-- foreign keys
-- Reference: FK_TP5_P1_EJ2_AUSPICIO_EMPLEADO (table: TP5_P1_EJ2_AUSPICIO)
ALTER TABLE TP5_P1_EJ2_AUSPICIO ADD CONSTRAINT FK_TP5_P1_EJ2_AUSPICIO_EMPLEADO
    FOREIGN KEY (tipo_empleado, nro_empleado)
    REFERENCES TP5_P1_EJ2_EMPLEADO (tipo_empleado, nro_empleado)
	MATCH FULL
    ON DELETE  SET NULL 
    ON UPDATE  RESTRICT 
;

-- Reference: FK_TP5_P1_EJ2_AUSPICIO_PROYECTO (table: TP5_P1_EJ2_AUSPICIO)
ALTER TABLE TP5_P1_EJ2_AUSPICIO ADD CONSTRAINT FK_TP5_P1_EJ2_AUSPICIO_PROYECTO
    FOREIGN KEY (id_proyecto)
    REFERENCES TP5_P1_EJ2_PROYECTO (id_proyecto)
    ON DELETE  RESTRICT 
    ON UPDATE  RESTRICT 
;

-- Reference: FK_TP5_P1_EJ2_TRABAJA_EN_EMPLEADO (table: TP5_P1_EJ2_TRABAJA_EN)
ALTER TABLE TP5_P1_EJ2_TRABAJA_EN ADD CONSTRAINT FK_TP5_P1_EJ2_TRABAJA_EN_EMPLEADO
    FOREIGN KEY (tipo_empleado, nro_empleado)
    REFERENCES TP5_P1_EJ2_EMPLEADO (tipo_empleado, nro_empleado)
    ON DELETE  CASCADE 
    ON UPDATE  RESTRICT 
;

-- Reference: FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO (table: TP5_P1_EJ2_TRABAJA_EN)
ALTER TABLE TP5_P1_EJ2_TRABAJA_EN ADD CONSTRAINT FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO
    FOREIGN KEY (id_proyecto)
    REFERENCES TP5_P1_EJ2_PROYECTO (id_proyecto)
    ON DELETE  RESTRICT 
    ON UPDATE  CASCADE 
;

-- End of file.
