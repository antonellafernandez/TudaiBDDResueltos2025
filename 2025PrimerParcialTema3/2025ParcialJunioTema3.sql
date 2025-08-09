-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-07-13 17:15:52.031

-- tables
-- Table: CONSULTA
CREATE TABLE CONSULTA (
    id_consulta int  NOT NULL,
    id_turno int  NOT NULL,
    diagnostico text  NOT NULL,
    observaciones text  NULL,
    id_obra_social int  NULL,
    CONSTRAINT CONSULTA_pk PRIMARY KEY (id_consulta)
);

-- Table: DOMICILIO_PACIENTE
CREATE TABLE DOMICILIO_PACIENTE (
    id_domicilio int  NOT NULL,
    id_paciente int  NOT NULL,
    direccion varchar(255)  NOT NULL,
    ciudad varchar(100)  NULL,
    CONSTRAINT DOMICILIO_PACIENTE_pk PRIMARY KEY (id_domicilio)
);

-- Table: ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
    id_tipo_esp int  NOT NULL,
    id_especialidad int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    descripcion text  NULL,
    CONSTRAINT ESPECIALIDAD_pk PRIMARY KEY (id_especialidad,id_tipo_esp)
);

-- Table: HISTORIAL_TURNO
CREATE TABLE HISTORIAL_TURNO (
    id_historial int  NOT NULL,
    id_turno int  NOT NULL,
    fecha int  NOT NULL,
    estado_anterior varchar(10)  NOT NULL,
    estado_nuevo varchar(10)  NOT NULL,
    CONSTRAINT HISTORIAL_TURNO_pk PRIMARY KEY (id_historial)
);

-- Table: OBRA_SOCIAL
CREATE TABLE OBRA_SOCIAL (
    id_obra_social int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    telefono varchar(20)  NOT NULL,
    CONSTRAINT OBRA_SOCIAL_pk PRIMARY KEY (id_obra_social)
);

-- Table: PACIENTE
CREATE TABLE PACIENTE (
    id_paciente int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    apellido varchar(100)  NOT NULL,
    email varchar(100)  NOT NULL,
    telefono varchar(20)  NULL,
    CONSTRAINT PACIENTE_pk PRIMARY KEY (id_paciente)
);

-- Table: PROFESIONAL
CREATE TABLE PROFESIONAL (
    id_profesional int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    apellido varchar(100)  NOT NULL,
    email varchar(100)  NULL,
    id_especialidad int  NULL,
    id_tipo_esp int  NULL,
    CONSTRAINT PROFESIONAL_pk PRIMARY KEY (id_profesional)
);

-- Table: TIPO_ESPECIALIDAD
CREATE TABLE TIPO_ESPECIALIDAD (
    id_tipo_esp int  NOT NULL,
    descripcion varchar(120)  NOT NULL,
    CONSTRAINT TIPO_ESPECIALIDAD_pk PRIMARY KEY (id_tipo_esp)
);

-- Table: TURNO
CREATE TABLE TURNO (
    id_turno int  NOT NULL,
    id_paciente int  NOT NULL,
    id_profesional int  NOT NULL,
    fecha date  NOT NULL,
    estado varchar(10)  NOT NULL,
    CONSTRAINT TURNO_pk PRIMARY KEY (id_turno)
);

-- foreign keys
-- Reference: CONSULTA_OBRA_SOCIAL (table: CONSULTA)
ALTER TABLE CONSULTA ADD CONSTRAINT CONSULTA_OBRA_SOCIAL
    FOREIGN KEY (id_obra_social)
    REFERENCES OBRA_SOCIAL (id_obra_social)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: CONSULTA_TURNO (table: CONSULTA)
ALTER TABLE CONSULTA ADD CONSTRAINT CONSULTA_TURNO
    FOREIGN KEY (id_turno)
    REFERENCES TURNO (id_turno)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: DOMICILIO_PACIENTE_PACIENTE (table: DOMICILIO_PACIENTE)
ALTER TABLE DOMICILIO_PACIENTE ADD CONSTRAINT DOMICILIO_PACIENTE_PACIENTE
    FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: HISTORIAL_TURNO_TURNO (table: HISTORIAL_TURNO)
ALTER TABLE HISTORIAL_TURNO ADD CONSTRAINT HISTORIAL_TURNO_TURNO
    FOREIGN KEY (id_turno)
    REFERENCES TURNO (id_turno)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PROFESIONAL_Table_8 (table: PROFESIONAL)
ALTER TABLE PROFESIONAL ADD CONSTRAINT PROFESIONAL_Table_8
    FOREIGN KEY (id_especialidad, id_tipo_esp)
    REFERENCES ESPECIALIDAD (id_especialidad, id_tipo_esp)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: TURNO_PACIENTE (table: TURNO)
ALTER TABLE TURNO ADD CONSTRAINT TURNO_PACIENTE
    FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: TURNO_PROFESIONAL (table: TURNO)
ALTER TABLE TURNO ADD CONSTRAINT TURNO_PROFESIONAL
    FOREIGN KEY (id_profesional)
    REFERENCES PROFESIONAL (id_profesional)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Table_8_TIPO_ESPECIALIDAD (table: ESPECIALIDAD)
ALTER TABLE ESPECIALIDAD ADD CONSTRAINT Table_8_TIPO_ESPECIALIDAD
    FOREIGN KEY (id_tipo_esp)
    REFERENCES TIPO_ESPECIALIDAD (id_tipo_esp)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

/* 4- Plantee la consulta SQL para obtener el listado de los pacientes que tienen al menos un turno con un profesional de
la especialidad de nombre 'Cardiología' y además no poseen ningún registro en el historial de turnos correspondiente a
esos turnos. */

SELECT p.*
FROM PACIENTE p
JOIN TURNO t ON p.id_paciente = t.id_paciente
JOIN PROFESIONAL pr ON t.id_profesional = pr.id_profesional
JOIN ESPECIALIDAD e ON (pr.id_tipo_esp = e.id_tipo_esp AND pr.id_especialidad = e.id_especialidad)
WHERE e.nombre = 'Cardiología'
AND NOT EXISTS(
    SELECT 1
    FROM HISTORIAL_TURNO ht
    WHERE t.id_turno = ht.id_turno);

/* 5- Utilizando funciones ventana, plantee la consulta SQL para obtener un informe detallado de atención médica que
incluya el identificador y apellido del paciente, el identificador y apellido del profesional, el identifiador y fecha del turno,
y además, la cantidad total de turnos atendidos por cada profesional, ordenado de forma descendente según la
cantidad de turnos por profesional. */

SELECT
    p.id_paciente,
    p.nombre,
    pr.id_profesional,
    pr.apellido,
    t.id_turno,
    t.fecha,
    COUNT(*) OVER (PARTITION BY pr.id_profesional) AS total_turnos_profesional
FROM PACIENTE p
JOIN TURNO t ON p.id_paciente = t.id_paciente
JOIN PROFESIONAL pr ON t.id_profesional = pr.id_profesional
ORDER BY total_turnos_profesional DESC;

/* 6- Para el esquema de la figura plantee el recurso declarativo más adecuado que controle que todas las
especialidaddes que contengan el string 'Cirugía' deben tener descripción. */

-- RI TUPLA, implica valores de una sola fila en la tabla ESPECIALIDAD
ALTER TABLE ESPECIALIDAD ADD CONSTRAINT CK_e6
CHECK(
    nombre NOT LIKE '%Cirugía%' OR descripcion IS NOT NULL
);

/* 7- Dada la siguiente restricción general que controla que "cada profesional de la especialidad de nombre 'Clínica Médica'
no puede tener turnos ni consultas sobre el mismo paciente por distintas obras sociales por año" plantee los triggers
necesarios para implementarla en PostgreSQL.

CREATE ASSERTION chk_turnos CHECK NOT EXISTS (
    SELECT 1
    FROM TURNO t
    JOIN PROFESIONAL pr ON (t.id_profesional = pr.id_profesional)
    JOIN ESPECIALIDAD e ON (pr.id_tipo_esp = e.id_tipo_esp AND pr.id_especialidad = e.id_especialidad)
    JOIN CONSULTA c ON (t.id_turno = c.id_turno)
    WHERE c.id_obra_social IS NOT NULL
    AND UPPER(e.nombre) = 'CLINICA MEDICA'
    GROUP BY t.id_paciente, EXTRACT(YEAR FROM t.fecha)
    HAVING COUNT(DISTINCT c.id_obra_social) > 1
);

TABLA               INSERT              UPDATE                                  DELETE
TURNO               SI                  SI id_paciente, id_profesional,fecha    NO
ESPECIALIDAD        SI                  SI id_tipo_esp, id_especialidad         NO
PROFESIONAL         SI                  SI id_tipo_esp, id_especialidad         NO
CONSULTA            SI                  SI id_turno, id_obra_social             NO

-- Vista
CREATE OR REPLACE VIEW v_t3 AS
SELECT 1
FROM TURNO t
JOIN PROFESIONAL pr ON (t.id_profesional = pr.id_profesional)
JOIN ESPECIALIDAD e ON (pr.id_tipo_esp = e.id_tipo_esp AND pr.id_especialidad = e.id_especialidad)
JOIN CONSULTA c ON (t.id_turno = c.id_turno)
WHERE c.id_obra_social IS NOT NULL
AND UPPER(e.nombre) = 'CLINICA MEDICA'
GROUP BY t.id_paciente, EXTRACT(YEAR FROM t.fecha)
HAVING COUNT(DISTINCT c.id_obra_social) > 1;

-- Triggers
CREATE OR REPLACE TRIGGER tr_turno
BEFORE INSERT OR UPDATE OF id_paciente, id_profesional, fecha ON TURNO
FOR EACH ROW EXECUTE FUNCTION fn_P7T3();

CREATE OR REPLACE TRIGGER tr_especialidad
BEFORE INSERT OR UPDATE OF id_tipo_esp, id_especialidad ON ESPECIALIDAD
FOR EACH ROW EXECUTE FUNCTION fn_P7T3();

CREATE OR REPLACE TRIGGER tr_profesional
BEFORE INSERT OR UPDATE OF id_tipo_esp, id_especialidad ON PROFESIONAL
FOR EACH ROW EXECUTE FUNCTION fn_P7T3();

CREATE OR REPLACE TRIGGER tr_consulta
BEFORE INSERT OR UPDATE OF id_turno, id_obra_social ON CONSULTA
FOR EACH ROW EXECUTE FUNCTION fn_P7T3();

-- Función
CREATE OR REPLACE FUNCTION fn_P7T3() RETURNS TRIGGER AS $$
BEGIN
    IF (EXISTS (SELECT 1 FROM v_t3)) THEN RAISE EXCEPTION 'Error';
    END IF;
    RETURN NEW;
END; $$ LANGUAGE 'plpgsql'; */

/* Adicional ChatGPT - Construya una vista actualizable con el identificador, fecha y estado de los turnos que
sean anteriores al 31/12/25 o que tengan asociado al menos una consulta obra social asignada.
Responda lo siguiente:
a) ¿Los turnos posteriores a la fecha asignada aparecen listados en la vista?
   Sí, pero solo si tienen al menos una consulta asociada con obra social asignada.
b) Si se le agrega la opción WITH CHECK OPTION, qué pasa con las actualizaciones a la vista?
   Con WITH CHECK OPTION: cualquier cambio debe seguir cumpliendo el WHERE de la vista; si no, la operación falla. */

CREATE OR REPLACE VIEW vista_turnos_filtrados AS
SELECT t.id_turno, t.fecha, t.estado
FROM TURNO t
WHERE t.fecha < DATE '31-12-25'
OR EXISTS (
    SELECT 1
    FROM CONSULTA c
    WHERE t.id_turno = c.id_turno
    AND c.id_obra_social IS NOT NULL
)
WITH CHECK OPTION;

/* Adicional ChatGPT - Considere la siguiente consulta sobre el esquema de salud dado, cuyo objetivo es obtener
información sobre los pacientes que tienen turnos con profesionales de la especialidad "Cardiología"
y que hayan tenido consultas con obra social "Particular":

SELECT p.nombre, p.apellido, t.fecha, pr.nombre, pr.apellido, o.nombre
FROM PACIENTE p, TURNO t, PROFESIONAL pr, CONSULTA c, OBRA_SOCIAL o, ESPECIALIDAD e
WHERE p.id_paciente = t.id_paciente
  AND t.id_profesional = pr.id_profesional
  AND t.id_turno = c.id_turno
  AND pr.id_especialidad = e.id_especialidad
  AND pr.id_tipo_esp = e.id_tipo_esp
  AND c.id_obra_social = o.id_obra_social
  AND e.nombre = 'Cardiología'
  AND o.nombre = 'Particular'
  AND p.email IS NOT NULL
ORDER BY t.fecha;

Analice si la consulta permite responder a lo solicitado y si representa una consulta optimizada o no. Si su
respuesta es SÍ, justifique por qué, de lo contrario reescriba la consulta justificando las estrategias consideradas
para su optimización. */

SELECT p.*
FROM PACIENTE p
JOIN TURNO t ON p.id_paciente = t.id_paciente
JOIN PROFESIONAL pr ON t.id_profesional = pr.id_profesional
JOIN (SELECT * FROM ESPECIALIDAD WHERE nombre = 'Cardiología') e ON (pr.id_tipo_esp = e.id_tipo_esp AND pr.id_especialidad = e.id_especialidad)
JOIN CONSULTA c ON t.id_turno = c.id_turno
JOIN (SELECT * FROM OBRA_SOCIAL WHERE nombre = 'Particular') os ON c.id_obra_social = os.id_obra_social;
