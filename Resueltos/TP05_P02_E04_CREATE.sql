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

-- Ejercicio 4
-- RESUELTO CÁTEDRA

-- A. La modalidad de la imagen médica puede tomar los siguientes valores RADIOLOGIA CONVENCIONAL,
-- FLUOROSCOPIA, ESTUDIOS RADIOGRAFICOS CON FLUOROSCOPIA, MAMOGRAFIA, SONOGRAFIA,
ALTER TABLE p5p2e4_imagen_medica
ADD CONSTRAINT CK_MODALIDAD_VALIDA
CHECK (modalidad iN (
    'RADIOLOGIA CONVENCIONAL',
    'FLUOROSCOPIA',
    'ESTUDIOS RADIOGRAFICOS CON FLUOROSCOPIA',
    'MAMOGRAFIA',
    'SONOGRAFIA'
    )
);

-- B. Cada imagen no debe tener más de 5 procesamientos.
ALTER TABLE p5p2e4_procesamiento
ADD CONSTRAINT CK_CANTIDAD_PROCESAMIENTOS
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM p5p2e4_procesamiento
        GROUP BY id_paciente, id_imagen
        HAVING COUNT(*) > 5
    )
);

-- C. Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una
-- indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle
-- que la segunda no sea menor que la primera.
ALTER TABLE p5p2e4_imagen_medica
ADD COLUMN fecha_img date;

ALTER TABLE p5p2e4_procesamiento
ADD COLUMN fecha_proc date;

CREATE ASSERTION
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM p5p2e4_imagen_medica i
        JOIN p5p2e4_procesamiento p ON (i.id_paciente = p.id_paciente AND i.id_imagen = p.id_imagen)
        WHERE fecha_proc < fecha_img
    )
);

-- D. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.
ALTER TABLE p5p2e4_imagen_medica
ADD CONSTRAINT CK_CANTIDAD_PROCESAMIENTOS
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM p5p2e4_imagen_medica
        WHERE modalidad = 'FLUOROSCOPIA'
        GROUP BY id_paciente, EXTRACT(YEAR FROM fecha_img)
        HAVING COUNT(*) > 2
    )
);

-- E. No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de
-- FLUOROSCOPIA
CREATE ASSERTION
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM p5p2e4_imagen_medica i
        JOIN p5p2e4_procesamiento p ON (i.id_paciente = p.id_paciente AND i.id_imagen = p.id_imagen)
        JOIN p5p2e4_algoritmo a ON ( p.id_algoritmo = a.id_algoritmo )
        WHERE modalidad = 'FLUOROSCOPIA'
        AND costo_computacional = 'O(n)'
    )
);

