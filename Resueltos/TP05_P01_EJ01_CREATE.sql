-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-23 21:41:16.165

-- tables
-- Table: P5P1E1_ARTICULO
CREATE TABLE P5P1E1_ARTICULO (
    id_articulo int  NOT NULL,
    titulo varchar(120)  NOT NULL,
    autor varchar(30)  NOT NULL,
    CONSTRAINT P5P1E1_ARTICULO_pk PRIMARY KEY (id_articulo)
);

-- Table: P5P1E1_CONTIENE
CREATE TABLE P5P1E1_CONTIENE (
    id_articulo int  NOT NULL,
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    CONSTRAINT P5P1E1_CONTIENE_pk PRIMARY KEY (id_articulo,idioma,cod_palabra)
);

-- Table: P5P1E1_PALABRA
CREATE TABLE P5P1E1_PALABRA (
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    descripcion varchar(25)  NOT NULL,
    CONSTRAINT P5P1E1_PALABRA_pk PRIMARY KEY (idioma,cod_palabra)
);

-- foreign keys
-- Reference: FK_P5P1E1_CONTIENE_ARTICULO (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES P5P1E1_ARTICULO (id_articulo)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P1E1_CONTIENE_PALABRA (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
    -- Ejercicio 1
    -- a) Cómo debería implementar las Restricciones de Integridad Referencial (RIR)
    -- si se desea que cada vez que se elimine un registro de la tabla PALABRA,
    -- también se eliminen los artículos que la referencian en la tabla CONTIENE.
    ON DELETE CASCADE
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

-- b) Verifique qué sucede con las palabras contenidas en cada artículo,
-- al eliminar una palabra, si definen la Acción Referencial para las bajas (ON DELETE)
-- de la RIR correspondiente como:
    -- ii) Restrict

        /*
        ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
        FOREIGN KEY (idioma, cod_palabra)
        REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
        ON DELETE RESTRICT
        NOT DEFERRABLE
        INITIALLY IMMEDIATE; */

        -- NO se podrá eliminar una palabra de PALABRA si esa palabra está siendo usada
        -- en algún artículo en la tabla CONTIENE

    -- iii) Es posible para éste ejemplo colocar SET NULL o SET DEFAULT para ON DELETE y ON UPDATE?

        -- SET NULL no se podría colocar ya que
        /*
        id_articulo int  NOT NULL,
        idioma char(2)  NOT NULL,
        cod_palabra int  NOT NULL,

        NO PERMITEN VALORES NULOS! */

        -- SET DEFAULT no se podría colocar porque las columnas deberían tener valores
        -- DEFAULT definidos
