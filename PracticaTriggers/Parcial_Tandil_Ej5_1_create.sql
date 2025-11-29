-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-28 00:43:08.428

-- tables
-- Table: ATIENDE
CREATE TABLE ATIENDE (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nro_matricula int  NOT NULL,
    cod_centro int  NOT NULL,
    CONSTRAINT PK_ATIENDE PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad,cod_centro)
);

-- Table: CENTRO_SALUD
CREATE TABLE CENTRO_SALUD (
    cod_centro int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    calle varchar(60)  NOT NULL,
    numero int  NOT NULL,
    sala_atencion boolean  NOT NULL,
    CONSTRAINT PK_CENTRO_SALUD PRIMARY KEY (cod_centro)
);

-- Table: ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY (tipo_especialidad,cod_especialidad)
);

-- Table: MEDICO
CREATE TABLE MEDICO (
    tipo_especialidad char(3)  NOT NULL,
    cod_especialidad int  NOT NULL,
    nro_matricula int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    email varchar(30)  NOT NULL,
    CONSTRAINT PK_MEDICO PRIMARY KEY (nro_matricula,tipo_especialidad,cod_especialidad)
);

-- foreign keys
-- Reference: FK_ATIENDE_CENTRO_SALUD (table: ATIENDE)
ALTER TABLE ATIENDE ADD CONSTRAINT FK_ATIENDE_CENTRO_SALUD
    FOREIGN KEY (cod_centro)
    REFERENCES CENTRO_SALUD (cod_centro)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_ATIENDE_MEDICO (table: ATIENDE)
ALTER TABLE ATIENDE ADD CONSTRAINT FK_ATIENDE_MEDICO
    FOREIGN KEY (nro_matricula, tipo_especialidad, cod_especialidad)
    REFERENCES MEDICO (nro_matricula, tipo_especialidad, cod_especialidad)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_MEDICO_ESPECIALIDAD (table: MEDICO)
ALTER TABLE MEDICO ADD CONSTRAINT FK_MEDICO_ESPECIALIDAD
    FOREIGN KEY (tipo_especialidad, cod_especialidad)
    REFERENCES ESPECIALIDAD (tipo_especialidad, cod_especialidad)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

/* Por cada sala de atención y por cada especialidad sólo pueden atender 2 médicos.

   CREATE ASSERTION ch_medicos CHECK (
       NOT EXISTS (
       SELECT 1
       FROM ATIENDE a
       JOIN MEDICO m ON (
            a.nro_matricula = m.nro_matricula
            AND a.tipo_especialidad = m.tipo_especialidad
            AND a.cod_especialidad = m.cod_especialidad
       )
       JOIN CENTRO_SALUD c ON a.cod_centro = c.cod_centro
       WHERE c.sala_atencion = TRUE
       GROUP BY a.cod_centro, a.tipo_especialidad, a.cod_especialidad
       HAVING COUNT(DISTINCT m.nro_matricula) > 2
   ));

   TABLA            INSERT          UPDATE                                  DELETE
   ATIENDE          nro_matricula   nro_matricula                           NO
   MEDICO           NO              cod_especialidad tipo_especialidad      NO
   CENTRO_SALUD     NO              sala_atencion                           NO

Se necesita mantener actualizada la cantidad de médicos y la cantidad de atenciones por cada
especialidad; los nuevos atributos se deben llamar cant_med, cant_atenciones.

1. De las sentencias SQL para modificar la o las tablas que crea adecuado junto con el tipo
de dato que corresponde (agregado de los atributos cant_med y cant_atenciones).

   ALTER TABLE ESPECIALIDAD
   ADD cant_med INTEGER NOT NULL DEFAULT 0,
   ADD cant_atenciones INTEGER NOT NULL DEFAULT 0;

2. Provea las sentencias de inicialización de dichos atributos, una para cant_med y otra
para cant_atenciones.

   UPDATE ESPECIALIDAD e SET e.cant_med = (
        SELECT COUNT(m.nro_matricula)
        FROM MEDICO m
        WHERE m.tipo_especialidad = e.tipo_especialidad
        AND m.cod_especialidad = e.cod_especialidad
   );

   UPDATE ESPECIALIDAD e SET cant_atenciones = (
        SELECT COUNT(*)
        FROM ATIENDE a
        WHERE a.tipo_especialidad = e.tipo_especialidad
        AND a.cod_especialidad = e.cod_especialidad
   );

3. Provea el/los trigger/s utilizando los parámetros adecuados para que se comporten lo
más eficientemente para que éstos nuevos atributos estén actualizados (cant_med y
cant_atenciones).

   TABLA        INSERT      UPDATE                                      DELETE
   MEDICO       SI          SI tipo_especialidad, cod_especialidad      SI
   ATIENDE      SI          SI tipo_especialidad, cod_especialidad      SI

   CREATE OR REPLACE TRIGGER tr_e3_medico
   AFTER INSERT OR UPDATE OF tipo_especialidad, cod_especialidad OR DELETE
   ON MEDICO
   FOR EACH ROW
   EXECUTE FUNCTION fn_e3_medico();

   CREATE OR REPLACE TRIGGER tr_e3_atiende
   AFTER INSERT OR UPDATE OF tipo_especialidad, cod_especialidad OR DELETE
   ON ATIENDE
   FOR EACH ROW
   EXECUTE FUNCTION fn_e3_atiende();

4. Provea la o las funciones que serán llamadas por él/los triggers del punto anterior (punto 3).

   CREATE OR REPLACE FUNCTION fn_e3_medico()
   RETURNS TRIGGER AS
       $$
           BEGIN
            IF (TG_OP = 'INSERT') THEN
                UPDATE ESPECIALIDAD e SET cant_med = cant_med + 1
                WHERE tipo_especialidad = NEW.tipo_especialidad
                AND cod_especialidad = NEW.cod_especialidad;

                RETURN NEW;
            ELSE IF (TG_OP = 'UPDATE') THEN
                UPDATE ESPECIALIDAD e SET cant_med = cant_med + 1
                WHERE tipo_especialidad = NEW.tipo_especialidad
                AND cod_especialidad = NEW.cod_especialidad;

                UPDATE ESPECIALIDAD e SET cant_med = cant_med - 1
                WHERE tipo_especialidad = OLD.tipo_especialidad
                AND cod_especialidad = OLD.cod_especialidad;

                RETURN NEW;
            ELSE IF (TG_OP = 'DELETE') THEN
                UPDATE ESPECIALIDAD e SET cant_med = cant_med - 1
                WHERE tipo_especialidad = OLD.tipo_especialidad
                AND cod_especialidad = OLD.cod_especialidad;

                RETURN OLD;
            END IF;
           END;
       $$
   LANGUAGE 'plpgsql';

   REATE OR REPLACE FUNCTION fn_e3_atiende()
   RETURNS TRIGGER AS
       $$
           BEGIN
            IF (TG_OP = 'INSERT') THEN
                UPDATE ESPECIALIDAD e SET cant_atenciones = cant_atenciones + 1
                WHERE tipo_especialidad = NEW.tipo_especialidad
                AND cod_especialidad = NEW.cod_especialidad;

                RETURN NEW;
            ELSE IF (TG_OP = 'UPDATE') THEN
                UPDATE ESPECIALIDAD e SET cant_atenciones = cant_atenciones + 1
                WHERE tipo_especialidad = NEW.tipo_especialidad
                AND cod_especialidad = NEW.cod_especialidad;

                UPDATE ESPECIALIDAD e SET cant_atenciones = cant_atenciones - 1
                WHERE tipo_especialidad = OLD.tipo_especialidad
                AND cod_especialidad = OLD.cod_especialidad;

                RETURN NEW;
            ELSE IF (TG_OP = 'DELETE') THEN
                UPDATE ESPECIALIDAD e SET cant_atenciones = cant_atenciones - 1
                WHERE tipo_especialidad = OLD.tipo_especialidad
                AND cod_especialidad = OLD.cod_especialidad;

                RETURN OLD;
            END IF;
           END;
       $$
   LANGUAGE 'plpgsql'; */
