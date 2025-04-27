-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-29 17:10:41.777

-- tables
-- Table: P5P2E3_ARTICULO
CREATE TABLE P5P2E3_ARTICULO (
    id_articulo int  NOT NULL,
    titulo varchar(120)  NOT NULL,
    autor varchar(30)  NOT NULL,
    fecha_publicacion date  NOT NULL,
    nacionalidad varchar(15)  NOT NULL,
    CONSTRAINT AK_P5P1E1_ARTICULO UNIQUE (titulo) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT PK_P5P2E3_ARTICULO PRIMARY KEY (id_articulo)
);

-- Table: P5P2E3_CONTIENE
CREATE TABLE P5P2E3_CONTIENE (
    id_articulo int  NOT NULL,
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    CONSTRAINT PK_P5P2E3_CONTIENE PRIMARY KEY (id_articulo,idioma,cod_palabra)
);

-- Table: P5P2E3_PALABRA
CREATE TABLE P5P2E3_PALABRA (
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    descripcion varchar(25)  NOT NULL,
    CONSTRAINT PK_P5P2E3_PALABRA PRIMARY KEY (idioma,cod_palabra)
);

-- foreign keys
-- Reference: FK_P5P2E3_CONTIENE_ARTICULO (table: P5P2E3_CONTIENE)
ALTER TABLE P5P2E3_CONTIENE ADD CONSTRAINT FK_P5P2E3_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES P5P2E3_ARTICULO (id_articulo)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E3_CONTIENE_PALABRA (table: P5P2E3_CONTIENE)
ALTER TABLE P5P2E3_CONTIENE ADD CONSTRAINT FK_P5P2E3_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES P5P2E3_PALABRA (idioma, cod_palabra)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

-- Ejercicio 3

-- A. Controlar que las nacionalidades sean 'Argentina' 'Español' 'Inglés' 'Alemán' o 'Chilena'.
ALTER TABLE P5P2E3_ARTICULO -- DOMAIN!
ADD CONSTRAINT ck_nacionalidades_validas
CHECK(nacionalidad IN('Argentina', 'Inglés', 'Alemán', 'Chilena'));

-- B. Para las fechas de publicaciones se debe considerar que sean fechas posteriores o iguales al 2010.
ALTER TABLE P5P2E3_ARTICULO
ADD CONSTRAINT ck_fecha_publicacion
CHECK (EXTRACT(YEAR FROM fecha_publicacion) >= 2010);

-- C. Cada palabra clave puede aparecer como máximo en 5 artículos.
CREATE ASSERTION ck_cant_palabras_claves_max
CHECK (
    NOT EXISTS (
        SELECT COUNT(id_articulo)
        FROM P5P2E3_CONTIENE
        GROUP BY idioma, cod_palabra
        HAVING COUNT(id_articulo) > 5
    )
);

-- D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
-- claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
-- artículos que contengan hasta 10 palabras claves.
CREATE ASSERTION ck_cantidad_palabras
CHECK (
    NOT EXISTS (
        SELECT id_articulo
        FROM p5p2e3_articulo
        WHERE (nacionalidad LIKE 'Argentina' AND
        id_articulo IN (
            SELECT id_articulo
            FROM p5p2e3_contiene
            GROUP BY id_articulo
            HAVING COUNT(*) > 15)
       ) OR (
            nacionalidad NOT LIKE 'Argentina' AND
            id_articulo IN (SELECT id_articulo
            FROM p5p2e3_contiene
            GROUP BY id_articulo
            HAVING COUNT(*) > 10)
       )
    )
); -- RESUELTO CÁTEDRA

-- Recordar!
-- DOMAIN Regla para definir el conjunto de los valores válidos de un atributo.
-- CHECK Regla sobre una sola fila de una tabla.
-- ASSERTION Regla sobre sobre un número arbitrario de atributos de un número arbitrario de tablas.

