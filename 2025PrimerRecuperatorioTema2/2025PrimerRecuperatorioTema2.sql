-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-07-13 19:06:29.822

-- tables
-- Table: CATEGORIA
CREATE TABLE CATEGORIA (
    id_tipo_cat int  NOT NULL,
    id_categoria int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    descripcion text  NULL,
    CONSTRAINT CATEGORIA_pk PRIMARY KEY (id_tipo_cat,id_categoria)
);

-- Table: CURSADA
CREATE TABLE CURSADA (
    id_inscripcion int  NOT NULL,
    id_curso int  NOT NULL,
    nota numeric(3,0)  NOT NULL,
    CONSTRAINT CURSADA_pk PRIMARY KEY (id_inscripcion,id_curso)
);

-- Table: CURSO
CREATE TABLE CURSO (
    id_curso int  NOT NULL,
    titulo varchar(100)  NOT NULL,
    descripcion text  NOT NULL,
    id_docente int  NOT NULL,
    id_tipo_cat int  NULL,
    id_categoria int  NULL,
    CONSTRAINT CURSO_pk PRIMARY KEY (id_curso)
);

-- Table: DOCENTE
CREATE TABLE DOCENTE (
    id_docente int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    apellido varchar(100)  NOT NULL,
    email varchar(100)  NOT NULL,
    titulo varchar(100)  NOT NULL,
    CONSTRAINT DOCENTE_pk PRIMARY KEY (id_docente)
);

-- Table: ESTUDIANTE
CREATE TABLE ESTUDIANTE (
    id_estudiante int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    apellido varchar(100)  NOT NULL,
    email varchar(100)  NOT NULL,
    telefono varchar(20)  NULL,
    CONSTRAINT ESTUDIANTE_pk PRIMARY KEY (id_estudiante)
);

-- Table: HISTORIAL_PROGRESO
CREATE TABLE HISTORIAL_PROGRESO (
    id_historial int  NOT NULL,
    id_inscripcion int  NOT NULL,
    fecha date  NOT NULL,
    modulo varchar(100)  NOT NULL,
    estado varchar(50)  NOT NULL,
    CONSTRAINT HISTORIAL_PROGRESO_pk PRIMARY KEY (id_historial)
);

-- Table: INSCRIPCION
CREATE TABLE INSCRIPCION (
    id_inscripcion int  NOT NULL,
    id_estudiante int  NOT NULL,
    fecha date  NOT NULL,
    estado varchar(50)  NULL,
    CONSTRAINT INSCRIPCION_pk PRIMARY KEY (id_inscripcion)
);

-- Table: PERFIL_ESTUDIANTE
CREATE TABLE PERFIL_ESTUDIANTE (
    id_perfil int  NOT NULL,
    id_estudiante int  NOT NULL,
    bio text  NOT NULL,
    foto varchar(255)  NULL,
    CONSTRAINT PERFIL_ESTUDIANTE_pk PRIMARY KEY (id_perfil)
);

-- Table: TIPO_CATEGORIA
CREATE TABLE TIPO_CATEGORIA (
    id_tipo_cat int  NOT NULL,
    nombre_tipo_cat varchar(120)  NOT NULL,
    CONSTRAINT TIPO_CATEGORIA_pk PRIMARY KEY (id_tipo_cat)
);

-- foreign keys
-- Reference: CATEGORIA_TIPO_CATEGORIA (table: CATEGORIA)
ALTER TABLE CATEGORIA ADD CONSTRAINT CATEGORIA_TIPO_CATEGORIA
    FOREIGN KEY (id_tipo_cat)
    REFERENCES TIPO_CATEGORIA (id_tipo_cat)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: CURSADA_CURSO (table: CURSADA)
ALTER TABLE CURSADA ADD CONSTRAINT CURSADA_CURSO
    FOREIGN KEY (id_curso)
    REFERENCES CURSO (id_curso)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: CURSADA_INSCRIPCION (table: CURSADA)
ALTER TABLE CURSADA ADD CONSTRAINT CURSADA_INSCRIPCION
    FOREIGN KEY (id_inscripcion)
    REFERENCES INSCRIPCION (id_inscripcion)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: CURSO_CATEGORIA (table: CURSO)
ALTER TABLE CURSO ADD CONSTRAINT CURSO_CATEGORIA
    FOREIGN KEY (id_tipo_cat, id_categoria)
    REFERENCES CATEGORIA (id_tipo_cat, id_categoria)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: CURSO_DOCENTE (table: CURSO)
ALTER TABLE CURSO ADD CONSTRAINT CURSO_DOCENTE
    FOREIGN KEY (id_docente)
    REFERENCES DOCENTE (id_docente)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: HISTORIAL_PROGRESO_INSCRIPCION (table: HISTORIAL_PROGRESO)
ALTER TABLE HISTORIAL_PROGRESO ADD CONSTRAINT HISTORIAL_PROGRESO_INSCRIPCION
    FOREIGN KEY (id_inscripcion)
    REFERENCES INSCRIPCION (id_inscripcion)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: INSCRIPCION_ESTUDIANTE (table: INSCRIPCION)
ALTER TABLE INSCRIPCION ADD CONSTRAINT INSCRIPCION_ESTUDIANTE
    FOREIGN KEY (id_estudiante)
    REFERENCES ESTUDIANTE (id_estudiante)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PERFIL_ESTUDIANTE_ESTUDIANTE (table: PERFIL_ESTUDIANTE)
ALTER TABLE PERFIL_ESTUDIANTE ADD CONSTRAINT PERFIL_ESTUDIANTE_ESTUDIANTE
    FOREIGN KEY (id_estudiante)
    REFERENCES ESTUDIANTE (id_estudiante)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

/* 6- Dada la siguiente restricción general (posiblemente incompleta) que controla que "Un estudiante sólo se puede
inscribir a más de dos cursos del Tipo de Categoría IA (id_tipo_cat = 10) con un docente que no sea 'Doctor' una
vez por año"

CREATE ASSERTION P6T2 CHECK(NOT EXISTS(
    SELECT 1 FROM INSCRIPCION i
    JOIN CURSADA c ON c.id_inscripcion = i.id_inscripcion
    JOIN CURSO cu ON cu.id_curso = c.id_curso
    JOIN DOCENTE d on cu.id_docente = d.id_docente
    WHERE cu.id_tipo_cat = 10
    AND d.titulo NOT ILIKE 'Doctor%'
));

a) De el GROUP BY y el HAVING (en caso de ser necesario).

SELECT
    i.id_estudiante,
    EXTRACT(YEAR FROM i.fecha) AS anio,
    COUNT(*) AS cantidad
FROM INSCRIPCION i
JOIN CURSADA c ON c.id_inscripcion = i.id_inscripcion
JOIN CURSO cu ON cu.id_curso = c.id_curso
JOIN DOCENTE d ON cu.id_docente = d.id_docente
WHERE cu.id_tipo_cat = 10
AND d.titulo NOT ILIKE 'Doctor%'
GROUP BY i.id_estudiante, EXTRACT(YEAR FROM i.fecha)
HAVING COUNT(*) > 2;

b) Complete la tabla con el análisis de qué eventos y campos son necesarios para implementar la restricción con triggers.

TABLA               INSERT              UPDATE                          DELETE
INSCRIPCION         SI                  SI id_estudiante, fecha         NO
CURSADA             SI                  SI id_curso, id_inscripcion     NO
CURSO               SI                  SI id_tipo_cat, id_docente      NO
DOCENTE             SI                  SI titulo                       NO

c) Escriba todos los triggers (sólo encabezados).

CREATE OR REPLACE TRIGGER tr_inscripcion
BEFORE INSERT OR UPDATE OF id_estudiante, fecha ON INSCRIPCION
FOR EACH ROW EXECUTE FUNCTION fn_P6T2();

CREATE OR REPLACE TRIGGER tr_cursada
BEFORE INSERT OR UPDATE OF id_curso, id_inscripcion ON CURSADA
FOR EACH ROW EXECUTE FUNCTION fn_P6T2();

CREATE OR REPLACE TRIGGER tr_curso
BEFORE INSERT OR UPDATE OF id_tipo_cat, id_docente ON CURSO
FOR EACH ROW EXECUTE FUNCTION fn_P6T2();

CREATE OR REPLACE TRIGGER tr_docente
BEFORE INSERT OR UPDATE OF titulo ON DOCENTE
FOR EACH ROW EXECUTE FUNCTION fn_P6T2();

d) Utilizando la consulta de la restricción como base construya una vista (v_t2) (modificarla en caso de ser necesario
para) que será utilizada en todas las funciones del o de los triggers a implementar.

CREATE OR REPLACE VIEW v_t2 AS
SELECT
    i.id_estudiante,
    EXTRACT(YEAR FROM i.fecha) AS anio,
    COUNT(*) AS cantidad
FROM INSCRIPCION i
JOIN CURSADA c ON c.id_inscripcion = i.id_inscripcion
JOIN CURSO cu ON cu.id_curso = c.id_curso
JOIN DOCENTE d ON cu.id_docente = d.id_docente
WHERE cu.id_tipo_cat = 10
AND d.titulo NOT ILIKE 'Doctor%'
GROUP BY i.id_estudiante, EXTRACT(YEAR FROM i.fecha)
HAVING COUNT(*) > 2;

e) Utilizando la vista del punto d), implemente la o las funciones para hacer cumplir la restricción en PostgreSQL

CREATE OR REPLACE FUNCTION fn_P6T2 RETURNS TRIGGER AS $$
BEGIN
    IF (EXISTS (SELECT 1 FROM v_t2)) THEN RAISE EXCEPTION 'Error';
    END IF;
    RETURN NEW;
END; $$ LANGUAGE 'plpgsql'; */
