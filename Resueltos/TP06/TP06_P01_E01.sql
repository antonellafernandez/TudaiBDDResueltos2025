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

-- Ejercicio 1

-- Implemente de manera procedural las restricciones que no pudo realizar de manera declarativa en
-- el ejercicio 3 del Práctico 5 Parte 2.

-- Ayuda: las restricciones que no se pudieron realizar de manera declarativa fueron las de los items C y D;

-- C. Cada palabra clave puede aparecer como máximo en 5 artículos.
/* CREATE ASSERTION ck_cant_palabras_claves_max
CHECK (
    NOT EXISTS (
        SELECT COUNT(id_articulo)
        FROM P5P2E3_CONTIENE
        GROUP BY idioma, cod_palabra
        HAVING COUNT(id_articulo) > 5
    )
); */

CREATE OR REPLACE FUNCTION fn_maxArticulosxPalabra()
RETURNS TRIGGER AS
    $$ DECLARE cant INTEGER;
        BEGIN
            SELECT count(id_articulo) INTO cant
            FROM P5P2E3_CONTIENE
            WHERE idioma = NEW.idioma AND cod_palabra = NEW.cod_palabra;

            IF (cant > 4) THEN
                RAISE EXCEPTION 'Esta palabra está contenida en más de 5 artículos: ';
            END IF;

            RETURN NEW;
        END
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_pal_art
BEFORE INSERT OR UPDATE OF idioma, cod_palabra ON P5P2E3_CONTIENE
FOR EACH ROW EXECUTE PROCEDURE fn_maxArticulosxPalabra();

-- D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
-- claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
-- artículos que contengan hasta 10 palabras claves.
/* CREATE ASSERTION ck_cantidad_palabras
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
); */

CREATE OR REPLACE FUNCTION fn_cantPalabras_contiene()
RETURNS TRIGGER AS
    $$ DECLARE nac P5P2E3_ARTICULO.NACIONALIDAD%type; cant INTEGER;
        BEGIN
            SELECT nacionalidad INTO nac
            FROM P5P2E3_ARTICULO
            WHERE id_articulo = NEW.id_articulo;

            SELECT COUNT(*) INTO cant
            FROM P5P2E3_CONTIENE
            WHERE id_articulo = NEW.id_articulo;

            IF ((nac = 'Argentina' AND cant > 15)
                OR (nac != ' Argentina' AND cant > 10)) THEN
                    RAISE EXCEPTION 'ERROR, muchas palabras!';
            END IF;

            RETURN NEW;
        END
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_pal_cont_art_max
BEFORE INSERT OR UPDATE OF id_articulo ON P5P2E3_CONTIENE
FOR EACH ROW EXECUTE PROCEDURE fn_cantPalabras_contiene();

--              --              --              --
--              --              --              --

CREATE OR REPLACE FUNCTION fn_cantPalabras_articulo()
RETURNS TRIGGER AS
    $$ DECLARE cant INTEGER;
        BEGIN
            SELECT COUNT(*) INTO cant
            FROM P5P2E3_CONTIENE
            WHERE id_articulo = NEW.id_articulo;

            IF ((NEW.nacionalidad = 'Argentina' AND cant > 15)
                OR (NEW.nacionalidad != 'Argentina' AND cant > 10)) THEN
                -- NEW.nacionalidad refiere a la nacionalidad de la tupla
                -- que se está actualizando
                    RAISE EXCEPTION 'ERROR, muchas palabras!';
            END IF;

            RETURN NEW;
        END
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_pal_art
BEFORE UPDATE OF nacionalidad ON P5P2E3_ARTICULO
FOR EACH ROW EXECUTE PROCEDURE fn_cantPalabras_articulo();
