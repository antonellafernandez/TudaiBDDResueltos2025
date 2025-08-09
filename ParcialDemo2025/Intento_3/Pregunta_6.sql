-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-01 00:52:31.178

-- tables
-- Table: ALUMNO
CREATE TABLE ALUMNO (
    DNI int  NOT NULL,
    LU int  NOT NULL,
    CONSTRAINT AK_ALUMNO UNIQUE (LU) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: CARRERA
CREATE TABLE CARRERA (
    id_carrera int  NOT NULL,
    nombre_titulo_otorgado text  NOT NULL,
    nombre_carrera text  NOT NULL,
    CONSTRAINT AK_CARRERA_1 UNIQUE (nombre_titulo_otorgado) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT AK_CARRERA_2 UNIQUE (nombre_carrera) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: DOCENTE
CREATE TABLE DOCENTE (
    DNI int  NOT NULL,
    id_profesor int  NOT NULL,
    fecha_ingreso date  NOT NULL,
    id_materia int  NOT NULL,
    id_carrera int  NOT NULL,
    CONSTRAINT AK_DOCENTE UNIQUE (id_profesor) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: MATERIA
CREATE TABLE MATERIA (
    id_carrera int  NOT NULL,
    id_materia int  NOT NULL,
    nombre_materia varchar(150)  NOT NULL,
    CONSTRAINT AK_MATERIA UNIQUE (nombre_materia) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: PERSONA
CREATE TABLE PERSONA (
    DNI int  NOT NULL,
    email varchar(120)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    nombre varchar(30)  NOT NULL,
    fecha_nac date  NOT NULL,
    CONSTRAINT AK_PERSONA UNIQUE (email) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: SE_INSCRIBE
CREATE TABLE SE_INSCRIBE (
    DNI int  NOT NULL,
    id_materia int  NOT NULL,
    id_carrera int  NOT NULL
);

-- End of file.

/* Pregunta 6

1) De la sentencia declarativa mas restrictiva que controle lo siguiente:
- Toda materia donde hay alumnos inscriptos, debe haber un docente */
-- CHECK Global
/*
CREATE ASSERTION materia_inscriptos_con_docente
CHECK (NOT EXISTS (
       SELECT 1
       FROM SE_INSCRIBE si
       WHERE NOT EXISTS (
            SELECT 1
            FROM DOCENTE d
            WHERE si.id_materia = d.id_materia
            AND si.id_carrera = d.id_carrera
))); */

-- 2) En caso de que no pueda ser implementado en PostgreSQL declarativamente, de la solución procedural
-- mas eficiente.

-- SE_INSCRIBE
CREATE OR REPLACE FUNCTION fn_verificar_se_inscribe()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM DOCENTE d
        WHERE NEW.id_materia = d.id_materia
        AND NEW.id_carrera = d.id_carrera)
        THEN RAISE EXCEPTION 'ERROR! La materia a la que se quiere inscribir no tiene docente asignado.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpqsql';

CREATE TRIGGER tr_verificar_se_inscribe
BEFORE INSERT OR UPDATE ON SE_INSCRIBE
FOR EACH ROW EXECUTE FUNCTION fn_verificar_se_inscribe();

-- DOCENTE
CREATE OR REPLACE FUNCTION fn_verificar_docente()
RETURNS TRIGGER AS $$
BEGIN
     IF EXISTS (SELECT 1
               FROM SE_INSCRIBE si
               WHERE si.id_materia = OLD.id_materia
               AND si.id_carrera = OLD.id_carrera)
     AND NOT EXISTS (SELECT 1
               FROM DOCENTE d
               WHERE d.id_materia = OLD.id_materia
               AND d.id_carrera = OLD.id_carrera)
     THEN RAISE EXCEPTION 'No hay un docente asignado a la materia % en la carrera %', OLD.id_materia, OLD.id_carrera;
     END IF;
     RETURN OLD;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tg_verificar_docente
AFTER DELETE OR UPDATE ON DOCENTE
FOR EACH ROW EXECUTE FUNCTION fn_verificar_docente();
