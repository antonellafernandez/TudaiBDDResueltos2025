-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-04-12 20:11:58.771

-- tables
-- Table: ESQ_VOL_CONTINENTE
CREATE TABLE ESQ_VOL_CONTINENTE (
    id_continente int  NOT NULL,
    nombre_continente varchar  NULL,
    CONSTRAINT ESQ_VOL_CONTINENTE_pk PRIMARY KEY (id_continente)
);

-- Table: ESQ_VOL_DIRECCION
CREATE TABLE ESQ_VOL_DIRECCION (
    id_direccion int  NOT NULL,
    calle varchar(40)  NULL,
    codigo_postal varchar(12)  NULL,
    provincia varchar(25)  NULL,
    ciudad varchar(30)  NOT NULL,
    id_pais char(2)  NOT NULL,
    CONSTRAINT ESQ_VOL_DIRECCION_pk PRIMARY KEY (id_direccion)
);

-- Table: ESQ_VOL_HISTORICO
CREATE TABLE ESQ_VOL_HISTORICO (
    nro_voluntario int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NOT NULL,
    id_tarea varchar(10)  NOT NULL,
    id_institucion int  NULL,
    CONSTRAINT ESQ_VOL_HISTORICO_pk PRIMARY KEY (fecha_inicio,nro_voluntario)
);

-- Table: ESQ_VOL_INSTITUCION
CREATE TABLE ESQ_VOL_INSTITUCION (
    id_institucion int  NOT NULL,
    nombre_institucion varchar(60)  NOT NULL,
    id_direccion int  NULL,
    id_director int  NULL,
    CONSTRAINT ESQ_VOL_INSTITUCION_pk PRIMARY KEY (id_institucion)
);

-- Table: ESQ_VOL_PAIS
CREATE TABLE ESQ_VOL_PAIS (
    id_pais char(2)  NOT NULL,
    nombre_pais varchar  NULL,
    id_continente int  NOT NULL,
    CONSTRAINT ESQ_VOL_PAIS_pk PRIMARY KEY (id_pais)
);

-- Table: ESQ_VOL_TAREA
CREATE TABLE ESQ_VOL_TAREA (
    id_tarea varchar(10)  NOT NULL,
    nombre_tarea varchar(40)  NOT NULL,
    min_horas int  NULL,
    max_horas int  NULL,
    CONSTRAINT ESQ_VOL_TAREA_pk PRIMARY KEY (id_tarea)
);

-- Table: ESQ_VOL_VOLUNTARIO
CREATE TABLE ESQ_VOL_VOLUNTARIO (
    nro_voluntario int  NOT NULL,
    nombre varchar(20)  NULL,
    apellido varchar(25)  NOT NULL,
    e_mail varchar(25)  NOT NULL,
    telefono varchar(20)  NULL,
    fecha_nacimiento date  NOT NULL,
    id_tarea varchar(10)  NOT NULL,
    horas_aportadas decimal(8,2)  NULL,
    porcentaje decimal(2,2)  NULL,
    id_institucion int  NULL,
    id_coordinador int  NULL,
    CONSTRAINT ESQ_VOL_VOLUNTARIO_pk PRIMARY KEY (nro_voluntario)
);

-- foreign keys
-- Reference: ESQ_VOL_DIRECCION_ESQ_VOL_PAIS (table: ESQ_VOL_DIRECCION)
ALTER TABLE ESQ_VOL_DIRECCION ADD CONSTRAINT ESQ_VOL_DIRECCION_ESQ_VOL_PAIS
    FOREIGN KEY (id_pais)
    REFERENCES ESQ_VOL_PAIS (id_pais)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: ESQ_VOL_HISTORICO_ESQ_VOL_INSTITUCION (table: ESQ_VOL_HISTORICO)
ALTER TABLE ESQ_VOL_HISTORICO ADD CONSTRAINT ESQ_VOL_HISTORICO_ESQ_VOL_INSTITUCION
    FOREIGN KEY (id_institucion)
    REFERENCES ESQ_VOL_INSTITUCION (id_institucion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: ESQ_VOL_HISTORICO_ESQ_VOL_TAREA (table: ESQ_VOL_HISTORICO)
ALTER TABLE ESQ_VOL_HISTORICO ADD CONSTRAINT ESQ_VOL_HISTORICO_ESQ_VOL_TAREA
    FOREIGN KEY (id_tarea)
    REFERENCES ESQ_VOL_TAREA (id_tarea)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: ESQ_VOL_HISTORICO_ESQ_VOL_VOLUNTARIO (table: ESQ_VOL_HISTORICO)
ALTER TABLE ESQ_VOL_HISTORICO ADD CONSTRAINT ESQ_VOL_HISTORICO_ESQ_VOL_VOLUNTARIO
    FOREIGN KEY (nro_voluntario)
    REFERENCES ESQ_VOL_VOLUNTARIO (nro_voluntario)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: ESQ_VOL_INSTITUCION_ESQ_VOL_DIRECCION (table: ESQ_VOL_INSTITUCION)
ALTER TABLE ESQ_VOL_INSTITUCION ADD CONSTRAINT ESQ_VOL_INSTITUCION_ESQ_VOL_DIRECCION
    FOREIGN KEY (id_direccion)
    REFERENCES ESQ_VOL_DIRECCION (id_direccion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: ESQ_VOL_INSTITUCION_ESQ_VOL_VOLUNTARIO (table: ESQ_VOL_INSTITUCION)
ALTER TABLE ESQ_VOL_INSTITUCION ADD CONSTRAINT ESQ_VOL_INSTITUCION_ESQ_VOL_VOLUNTARIO
    FOREIGN KEY (id_director)
    REFERENCES ESQ_VOL_VOLUNTARIO (nro_voluntario)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: ESQ_VOL_PAIS_ESQ_VOL_CONTINENTE (table: ESQ_VOL_PAIS)
ALTER TABLE ESQ_VOL_PAIS ADD CONSTRAINT ESQ_VOL_PAIS_ESQ_VOL_CONTINENTE
    FOREIGN KEY (id_continente)
    REFERENCES ESQ_VOL_CONTINENTE (id_continente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: ESQ_VOL_VOLUNTARIO_ESQ_VOL_INSTITUCION (table: ESQ_VOL_VOLUNTARIO)
ALTER TABLE ESQ_VOL_VOLUNTARIO ADD CONSTRAINT ESQ_VOL_VOLUNTARIO_ESQ_VOL_INSTITUCION
    FOREIGN KEY (id_institucion)
    REFERENCES ESQ_VOL_INSTITUCION (id_institucion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: ESQ_VOL_VOLUNTARIO_ESQ_VOL_TAREA (table: ESQ_VOL_VOLUNTARIO)
ALTER TABLE ESQ_VOL_VOLUNTARIO ADD CONSTRAINT ESQ_VOL_VOLUNTARIO_ESQ_VOL_TAREA
    FOREIGN KEY (id_tarea)
    REFERENCES ESQ_VOL_TAREA (id_tarea)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: ESQ_VOL_VOLUNTARIO_ESQ_VOL_VOLUNTARIO (table: ESQ_VOL_VOLUNTARIO)
ALTER TABLE ESQ_VOL_VOLUNTARIO ADD CONSTRAINT ESQ_VOL_VOLUNTARIO_ESQ_VOL_VOLUNTARIO
    FOREIGN KEY (id_coordinador)
    REFERENCES ESQ_VOL_VOLUNTARIO (nro_voluntario)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.


-- Ejercicio 1

-- Considere las siguientes restricciones que debe definir sobre el esquema de la BD de Voluntarios:

-- A. No puede haber voluntarios de más de 70 años. Aquí como la edad es un dato que
-- depende de la fecha actual lo deberíamos controlar de otra manera.
-- CHECK atributo
ALTER TABLE ESQ_VOL_VOLUNTARIO
ADD CONSTRAINT ck_menor_70
CHECK (EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento)) < 70);

-- A.Bis - Controlar que los voluntarios deben ser mayores a 18 años.
-- CHECK atributo
ALTER TABLE ESQ_VOL_VOLUNTARIO
ADD CONSTRAINT ck_mayor_18
CHECK (EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento)) >= 18);

-- B. Ningún voluntario puede aportar más horas que las de su coordinador.
-- CHECK tabla
ALTER TABLE ESQ_VOL_VOLUNTARIO ADD CONSTRAINT ck_voluntario_horas_aportadas
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM ESQ_VOL_VOLUNTARIO v
        WHERE v.horas_aportadas >= (
            SELECT horas_aportadas
            FROM ESQ_VOL_VOLUNTARIO c
            WHERE c.nro_voluntario = v.id_coordinador
        )
    )
);

-- C. Las horas aportadas por los voluntarios deben estar dentro de los valores máximos y
-- mínimos consignados en la tarea.
-- CHECK global
CREATE ASSERTION horas_aportadas_min_max
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM ESQ_VOL_VOLUNTARIO v
        JOIN ESQ_VOL_TAREA t ON v.id_tarea = t.id_tarea
        WHERE v.horas_aportadas NOT BETWEEN t.min_horas AND t.max_horas
    )
);

-- D. Todos los voluntarios deben realizar la misma tarea que su coordinador.
-- CHECK tabla
ALTER TABLE ESQ_VOL_VOLUNTARIO ADD CONSTRAINT ck_tarea_coordinador
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM ESQ_VOL_VOLUNTARIO v
        WHERE v.id_tarea <> (
            SELECT id_tarea
            FROM ESQ_VOL_VOLUNTARIO c
            WHERE c.nro_voluntario = v.id_coordinador
        )
    )
);

-- E. Los voluntarios no pueden cambiar de institución más de tres veces al año.
-- CHECK tabla??
CREATE ASSERTION cambio_institucion
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM ESQ_VOL_VOLUNTARIO v
        JOIN ESQ_VOL_HISTORICO historico ON v.nro_voluntario = historico.nro_voluntario
        GROUP BY historico.nro_voluntario
        HAVING COUNT(historico.id_institucion) > 3
        BETWEEN historico.fecha_inicio AND historico.fecha_fin
    )
); -- CORREGIR

-- F. En el histórico, la fecha de inicio debe ser siempre menor que la fecha de finalización.
-- CHECK tupla
ALTER TABLE ESQ_VOL_HISTORICO
ADD CONSTRAINT ck_fecha_inicio_menor_fin
CHECK (fecha_inicio < fecha_fin);

/*
        RESTRICCIÓN     TABLA/S                 ATRIBUTO/S                          TIPO DE RESTRICCIÓN
A.      CHECK           VOLUNTARIO              fecha_nacimiento                    Atributo

A.Bis   CHECK           VOLUNTARIO              fecha_nacimiento                    Atributo

B.      ASSERTION       VOLUNTARIO              id_coordinador, nro_voluntario,     Tabla
                                                horas_aportadas

C.      CHECK           VOLUNTARIO, TAREA       id_tarea, horas_aportadas,          Global
                                                min_horas, max_horas

D.      CHECK           VOLUNTARIO              nro_voluntario, id_tarea            Tabla

E.      CHECK           VOLUNTARIO, HISTORICO   ???                                 Tabla

F.      CHECK           HISTORICO               fecha_inicio, fecha_fin             Tupla
*/
