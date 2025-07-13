-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-07-12 20:07:27.279

-- tables
-- Table: INGENIERO
CREATE TABLE INGENIERO (
    id_ingeniero int  NOT NULL,
    nombre varchar  NOT NULL,
    apellido varchar  NOT NULL,
    contacto varchar  NULL,
    especialidad varchar  NOT NULL,
    remuneracion decimal(8,2)  NOT NULL,
    CONSTRAINT INGENIERO_pk PRIMARY KEY (id_ingeniero)
);

-- Table: PROYECTO
CREATE TABLE PROYECTO (
    id_sector int  NOT NULL,
    nro_proyecto int  NOT NULL,
    nombre varchar  NOT NULL,
    presupuesto decimal(12,2)  NOT NULL,
    fecha_ini date  NOT NULL,
    fecha_fin date  NULL,
    director int  NOT NULL,
    CONSTRAINT PROYECTO_pk PRIMARY KEY (id_sector,nro_proyecto)
);

-- Table: SECTOR
CREATE TABLE SECTOR (
    id_sector int  NOT NULL,
    descripcion varchar  NOT NULL,
    ubicacion varchar  NOT NULL,
    cant_empleados int  NOT NULL,
    CONSTRAINT SECTOR_pk PRIMARY KEY (id_sector)
);

-- Table: TRABAJA
CREATE TABLE TRABAJA (
    horas_sem int  NULL,
    id_ingeniero int  NOT NULL,
    id_sector int  NOT NULL,
    nro_proyecto int  NOT NULL,
    CONSTRAINT TRABAJA_pk PRIMARY KEY (id_ingeniero,id_sector,nro_proyecto)
);

-- foreign keys
-- Reference: PROYECTO_INGENIERO (table: PROYECTO)
ALTER TABLE PROYECTO ADD CONSTRAINT PROYECTO_INGENIERO
    FOREIGN KEY (director)
    REFERENCES INGENIERO (id_ingeniero)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PROYECTO_SECTOR (table: PROYECTO)
ALTER TABLE PROYECTO ADD CONSTRAINT PROYECTO_SECTOR
    FOREIGN KEY (id_sector)
    REFERENCES SECTOR (id_sector)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: TRABAJA_INGENIERO (table: TRABAJA)
ALTER TABLE TRABAJA ADD CONSTRAINT TRABAJA_INGENIERO
    FOREIGN KEY (id_ingeniero)
    REFERENCES INGENIERO (id_ingeniero)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: TRABAJA_PROYECTO (table: TRABAJA)
ALTER TABLE TRABAJA ADD CONSTRAINT TRABAJA_PROYECTO
    FOREIGN KEY (id_sector, nro_proyecto)
    REFERENCES PROYECTO (id_sector, nro_proyecto)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

/* 3) Plantee la implementación completa en SQL estándar de las siguientes restricciones de integridad, mediante el recurso
declarativo más restrictivo (explique y justifique su elección).
a) Los proyectos sin fecha de finalización asignada no deben superar $100000 de presupuesto.
b) El director asignado a un proyecto debe haber trabajado al menos en 5 proyectos ya finalizados en el mismo sector.
c) En cada proyecto pueden trabajar 10 ingenieros como máximo.

-- a) RI TUPLA, involucra valores de una sola fila de la tabla PROYECTO
ALTER TABLE PROYECTO ADD CONSTRAINT CK_e3a
CHECK(
    fecha_fin IS NOT NULL OR presupuesto <= 100000
);

-- b) RI GLOBAL, involucra más de una tabla
CREATE ASSERTION AS_e3b CHECK(NOT EXISTS(
    SELECT 1
    FROM PROYECTO p
    WHERE (
        SELECT COUNT(*)
        FROM PROYECTO p2
        JOIN TRABAJA t ON p2.id_sector = t.id_sector AND p2.nro_proyecto = t.nro_proyecto
        WHERE t.id_ingeniero = p.director
        AND p2.id_sector = p.id_sector
        AND p2.fecha_fin IS NOT NULL
        ) < 5
));

-- c) RI GLOBAL, involucra más de una tabla
CREATE ASSERTION AS_e3c CHECK(NOT EXISTS(
    SELECT 1
    FROM PROYECTO p
    WHERE (
        SELECT COUNT(DISTINCT t.id_ingeniero)
        FROM TRABAJA t
        WHERE p.id_sector = t.id_sector
        AND p.nro_proyecto = t.nro_proyecto
    ) > 10
)); */

/* 4) a) Escriba en PostgreSQL las declaraciones de todos los triggers que considere necesario definir para poder satisfacer la
restricción 3) b).
b) Implemente de forma completa y eficiente (en PostgreSQL) una función asociada a las inserciones.
c) Provea una operación concreta sobre la BD que despertaría el trigger definido en 4) b) y ecplique cómo funcionaría dicha
activación. */

-- INSERT, UPDATE           PROYECTO id_sector, director
-- INSERT, UPDATE, DELETE   TRABAJA id_ingeniero, id_sector, nro_proyecto

-- Vista
CREATE OR REPLACE VIEW v_P4 AS
SELECT p.id_sector, p.director, COUNT(DISTINCT p2.nro_proyecto) AS cant_finalizados
FROM PROYECTO p
LEFT JOIN TRABAJA t ON t.id_ingeniero = p.director AND t.id_sector = p.id_sector
LEFT JOIN PROYECTO p2 ON t.id_sector = p2.id_sector AND t.nro_proyecto = p2.nro_proyecto
WHERE p2.fecha_fin IS NOT NULL
GROUP BY p.id_sector, p.director
HAVING COUNT(DISTINCT p2.nro_proyecto) < 5;

-- Función
CREATE OR REPLACE FUNCTION fn_P4() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS(SELECT 1 FROM v_P4) THEN RAISE EXCEPTION 'Error';
    END IF;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

-- Triggers
CREATE OR REPLACE TRIGGER tr_proyecto
BEFORE INSERT OR UPDATE OF id_sector, director ON PROYECTO
FOR EACH ROW EXECUTE FUNCTION fn_P4();

CREATE OR REPLACE TRIGGER tr_trabaja
BEFORE INSERT OR UPDATE OF id_ingeniero, id_sector, nro_proyecto OR DELETE ON TRABAJA
FOR EACH ROW EXECUTE FUNCTION fn_P4();

/* 5) Construya una vista actualizable con el identificador, nombre, presupuesto de los poyectos que finalicen antes del
31/12/19 o que tengan uno o más ingenieros trrabajando más de 40 horas semanales.
Responda lo siguiente:
a) Los proyectos sin fecha de finalización asignada aparecen listados en la vista?
   Un proyecto sin fecha_fin asignada no aparece en la vista, ya que p.fecha_fin < DATE '31-12-19' sería FALSE,
   a menos que tenga algún ingeniero que trabaje más de 40 horas semanales.
b) Si se le agrega la opción WITH CHECK OPTION que pasará con las actualizaciones a la vista?
   Con WITH CHECK OPTION: cualquier cambio debe seguir cumpliendo el WHERE de la vista; si no, la operación falla. */
CREATE OR REPLACE VIEW VISTA_PROYECTO_e5 AS
SELECT p.id_sector, p.nro_proyecto, p.nombre, p.presupuesto
FROM PROYECTO p
WHERE p.fecha_fin < DATE '31-12-19'
OR EXISTS (
    SELECT 1
    FROM TRABAJA t
    WHERE p.id_sector = t.id_sector
    AND p.nro_proyecto = t.nro_proyecto
    AND t.horas_sem > 40);
