-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-28 21:22:26.905

-- tables
-- Table: P5P2E4_ALGORITMO
CREATE TABLE P5P2E4_ALGORITMO (
    id_algoritmo int  NOT NULL,
    nombre_metadata varchar(40)  NOT NULL,
    descripcion varchar(256)  NOT NULL,
    costo_computacional varchar(15)  NOT NULL,
    CONSTRAINT PK_P5P2E4_ALGORITMO PRIMARY KEY (id_algoritmo)
);

-- Table: P5P2E4_IMAGEN_MEDICA
CREATE TABLE P5P2E4_IMAGEN_MEDICA (
    id_paciente int  NOT NULL,
    id_imagen int  NOT NULL,
    modalidad varchar(80)  NOT NULL,
    descripcion varchar(180)  NOT NULL,
    descripcion_breve varchar(80)  NULL,
    CONSTRAINT PK_P5P2E4_IMAGEN_MEDICA PRIMARY KEY (id_paciente,id_imagen)
);

-- Table: P5P2E4_PACIENTE
CREATE TABLE P5P2E4_PACIENTE (
    id_paciente int  NOT NULL,
    apellido varchar(80)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    domicilio varchar(120)  NOT NULL,
    fecha_nacimiento date  NOT NULL,
    CONSTRAINT PK_P5P2E4_PACIENTE PRIMARY KEY (id_paciente)
);

-- Table: P5P2E4_PROCESAMIENTO
CREATE TABLE P5P2E4_PROCESAMIENTO (
    id_algoritmo int  NOT NULL,
    id_paciente int  NOT NULL,
    id_imagen int  NOT NULL,
    nro_secuencia int  NOT NULL,
    parametro decimal(15,3)  NOT NULL,
    CONSTRAINT PK_P5P2E4_PROCESAMIENTO PRIMARY KEY (id_algoritmo,id_paciente,id_imagen,nro_secuencia)
);

-- foreign keys
-- Reference: FK_P5P2E4_IMAGEN_MEDICA_PACIENTE (table: P5P2E4_IMAGEN_MEDICA)
ALTER TABLE P5P2E4_IMAGEN_MEDICA ADD CONSTRAINT FK_P5P2E4_IMAGEN_MEDICA_PACIENTE
    FOREIGN KEY (id_paciente)
    REFERENCES P5P2E4_PACIENTE (id_paciente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E4_PROCESAMIENTO_ALGORITMO (table: P5P2E4_PROCESAMIENTO)
ALTER TABLE P5P2E4_PROCESAMIENTO ADD CONSTRAINT FK_P5P2E4_PROCESAMIENTO_ALGORITMO
    FOREIGN KEY (id_algoritmo)
    REFERENCES P5P2E4_ALGORITMO (id_algoritmo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E4_PROCESAMIENTO_IMAGEN_MEDICA (table: P5P2E4_PROCESAMIENTO)
ALTER TABLE P5P2E4_PROCESAMIENTO ADD CONSTRAINT FK_P5P2E4_PROCESAMIENTO_IMAGEN_MEDICA
    FOREIGN KEY (id_paciente, id_imagen)
    REFERENCES P5P2E4_IMAGEN_MEDICA (id_paciente, id_imagen)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

-- Ejercicio 2

-- Implemente de manera procedural las restricciones que no pudo realizar de manera declarativa en
-- el ejercicio 4 del Práctico 5 Parte 2.

-- Ayuda: las restricciones que no se pudieron realizar de manera declarativa fueron las de los items
-- B, C, D, E.

-- B. Cada imagen no debe tener más de 5 procesamientos.
/* ALTER TABLE p5p2e4_procesamiento
ADD CONSTRAINT CK_CANTIDAD_PROCESAMIENTOS
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM p5p2e4_procesamiento
        GROUP BY id_paciente, id_imagen
        HAVING COUNT(*) > 5
    )
); */

--> Eventos                         INSERT		UPDATE		DELETE
--  Tablas p5p2e4_procesamiento		si			si			no
--                                                          id_paciente,
--                                                          id_imagen

CREATE OR REPLACE FUNCTION fn_cant_proc_imagen()
RETURNS TRIGGER AS
    $$ DECLARE cant INTEGER;
        BEGIN
            SELECT COUNT(*) INTO cant
            FROM P5P2E4_PROCESAMIENTO
            WHERE id_paciente = NEW.id_paciente
            AND id_imagen = NEW.id_imagen;

            IF (cant > 4) THEN
                RAISE EXCEPTION 'Más de 5 procesamientos para la imagen % del paciente %',
                    NEW.id_imagen, NEW.id_paciente;
            END IF;

            RETURN NEW;
        END
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_cant_proc_imagen
BEFORE INSERT OR UPDATE OF id_paciente, id_imagen ON P5P2E4_PROCESAMIENTO
FOR EACH ROW EXECUTE PROCEDURE fn_cant_proc_imagen();

-- C. Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una indica la fecha de la imagen y
-- la otra la fecha de procesamiento de la imagen y controle que la segunda no sea menor que la primera.
ALTER TABLE p5p2e4_imagen_medica
ADD COLUMN fecha_img date;

ALTER TABLE p5p2e4_procesamiento
ADD COLUMN fecha_proc date;
/*
CREATE ASSERTION
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM p5p2e4_imagen_medica i
        JOIN p5p2e4_procesamiento p ON (i.id_paciente = p.id_paciente AND i.id_imagen = p.id_imagen)
        WHERE fecha_proc < fecha_img
    )
); */

CREATE OR REPLACE FUNCTION fn_fecha_img_proc()
RETURNS TRIGGER AS
    $$
        BEGIN
            IF (NEW.fecha_img > (
                SELECT MAX(fecha_proc)
                FROM P5P2E4_PROCESAMIENTO p
                WHERE NEW.id_paciente = p.id_paciente AND NEW.id_imagen = p.id_imagen))
            THEN RAISE EXCEPTION 'Fecha de procesamiento menor que el %; fecha de la imagen % del paciente %.',
                NEW.fecha_img, NEW.id_imagen, NEW.id_paciente;
        END IF;

        RETURN NEW;
        END
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_fecha_img_proc
BEFORE UPDATE OF fecha_img ON P5P2E4_IMAGEN_MEDICA
FOR EACH ROW EXECUTE PROCEDURE fn_fecha_img_proc();

--              --              --              --
--              --              --              --

CREATE OR REPLACE FUNCTION fn_fecha_proc_img()
RETURNS TRIGGER AS
    $$
        BEGIN
            IF (NEW.fecha_proc > (
                SELECT fecha_img
                FROM P5P2E4_IMAGEN_MEDICA i
                WHERE NEW.id_paciente = i.id_paciente AND
                NEW.id_imagen = i.id_imagen))
            THEN RAISE EXCEPTION 'Fecha de la imagen % del paciente % es mayor que la de procesamiento %',
                NEW.id_imagen, NEW.id_paciente, NEW.fecha_proc;
            END IF;

            RETURN NEW;
        END
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_FECHA_PROC_IMG
BEFORE INSERT OR UPDATE OF fecha_proc, id_imagen, id_paciente ON P5P2E4_PROCESAMIENTO
FOR EACH ROW EXECUTE PROCEDURE FN_FECHA_PROC_IMG();

-- D. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.
/* ALTER TABLE p5p2e4_imagen_medica
ADD CONSTRAINT CK_CANTIDAD_PROCESAMIENTOS
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM p5p2e4_imagen_medica
        WHERE modalidad = 'FLUOROSCOPIA'
        GROUP BY id_paciente, EXTRACT(YEAR FROM fecha_img)
        HAVING COUNT(*) > 2
    )
); */

-- E. No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de FLUOROSCOPIA
/* CREATE ASSERTION
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM p5p2e4_imagen_medica i
        JOIN p5p2e4_procesamiento p ON (i.id_paciente = p.id_paciente AND i.id_imagen = p.id_imagen)
        JOIN p5p2e4_algoritmo a ON ( p.id_algoritmo = a.id_algoritmo )
        WHERE modalidad = 'FLUOROSCOPIA'
        AND costo_computacional = 'O(n)'
    )
); */
