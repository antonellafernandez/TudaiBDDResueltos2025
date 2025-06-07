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

-- End of file.

/* Pregunta 2
1) De la sentencia declarativa mas restrictiva que controle lo siguiente
- To do Proyecto debe tener un Directivo, si tiene personal trabajando en él */
/*
CREATE ASSERTION proyecto_con_directivo_y_personal
CHECK (NOT EXISTS (
    SELECT 1
    FROM TRABAJA_EN te
    WHERE NOT EXISTS (
       SELECT 1
       FROM DIRECTIVO d
       WHERE te.cod_tipo_proyecto = d.cod_tipo_proyecto
       AND te.id_proy = d.id_proy
    )
)); */

-- 2) En caso de que no pueda ser implementado en PostgreSQL declarativamente, de la solución procedural
-- mas eficiente.
-- TRABAJA_EN
CREATE OR REPLACE FUNCTION fn_trabaja_en()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM DIRECTIVO d
        WHERE NEW.cod_tipo_proy = d.cod_tipo_proy
        AND NEW.id_proyecto = d.id_proyecto
    )
    THEN RAISE EXCEPTION 'ERROR! El Proyecto id %, código tipo %, no tiene Directivo a cargo.', NEW.id_proyecto, NEW.cod_tipo_proy;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_trabaja_en
BEFORE INSERT OR UPDATE OF cod_tipo_proy, id_proyecto ON TRABAJA_EN
FOR EACH ROW EXECUTE FUNCTION fn_trabaja_en();

-- DIRECTIVO
CREATE OR REPLACE FUNCTION fn_directivo()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM TRABAJA_EN te
        WHERE OLD.cod_tipo_proy = te.cod_tipo_proy
        AND OLD.id_proyecto = te.id_proyecto
    )
    AND NOT EXISTS (
        SELECT 1
        FROM DIRECTIVO d
        WHERE OLD.cod_tipo_proy = d.cod_tipo_proy
        AND OLD.id_proyecto = d.id_proyecto
    )
    THEN RAISE EXCEPTION 'ERROR! El Proyecto id %, código tipo %, debe tener Directivo a cargo.', OLD.id_proyecto, OLD.cod_tipo_proy;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_directivo
BEFORE DELETE OR UPDATE OF cod_tipo_proy, id_proyecto ON DIRECTIVO
FOR EACH ROW EXECUTE fn_directivo();
