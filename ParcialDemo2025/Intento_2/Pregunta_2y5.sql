-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-03 12:54:38.084

-- tables
-- Table: EMPRESA
CREATE TABLE EMPRESA (
    CUIT varchar(11)  NOT NULL,
    razon_social varchar(120)  NOT NULL,
    nombre_comercial varchar(120)  NOT NULL,
    e_mail varchar(120)  NOT NULL,
    fecha_inicio_actividades date  NOT NULL,
    CONSTRAINT AK_EMPRESA UNIQUE (e_mail) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: MULTI_SUMINISTRO
CREATE TABLE MULTI_SUMINISTRO (
    CUIT varchar(11)  NOT NULL
);

-- Table: PROVEE
CREATE TABLE PROVEE (
    cod_tipo_sum int  NOT NULL,
    id_suministro int  NOT NULL,
    CUIT varchar(11)  NOT NULL
);

-- Table: SUMINISTRO
CREATE TABLE SUMINISTRO (
    cod_tipo_sum int  NOT NULL,
    id_suministro int  NOT NULL,
    nombre_suministro varchar(20)  NOT NULL
);

-- Table: TIPO_SUMINISTRO
CREATE TABLE TIPO_SUMINISTRO (
    cod_tipo_sum int  NOT NULL,
    nombre_tipo_sum varchar(120)  NOT NULL,
    descripcion_tipo_sum text  NOT NULL,
    CONSTRAINT AK_TIPO_SUMINISTRO UNIQUE (nombre_tipo_sum) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: UNI_SUMINISTRO
CREATE TABLE UNI_SUMINISTRO (
    CUIT varchar(11)  NOT NULL,
    cod_tipo_sum int  NOT NULL,
    id_suministro int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL
);

/* Pregunta 5

Escriba las sentencias sentencias SQL de declaración de claves primarias (PK), claves alterativas (AK) y claves extranjeras (FK) que faltan teniendo en cuenta los siguiente:

a) Deben definirse las acciones referenciales para que cada vez que se elimine o modifique (PK) de empresa debe hacerse también de las tablas subtipo de la jerarquía.

b) Los nombres de los tipos de suministro deben ser únicos.
En TIPO_SUMINISTRO esta línea CONSTRAINT AK_TIPO_SUMINISTRO UNIQUE (nombre_tipo_sum) NOT DEFERRABLE  INITIALLY IMMEDIATE
cumple ya esta condición. */
-- Primary keys
ALTER TABLE EMPRESA ADD CONSTRAINT PK_EMPRESA PRIMARY KEY (CUIT);
ALTER TABLE MULTI_SUMINISTRO ADD CONSTRAINT PK_MULTI_SUMINISTRO PRIMARY KEY (CUIT);
ALTER TABLE TIPO_SUMINISTRO ADD CONSTRAINT PK_TIPO_SUMINISTRO PRIMARY KEY (cod_tipo_sum);
ALTER TABLE UNI_SUMINISTRO ADD CONSTRAINT PK_UNI_SIMINISTRO PRIMARY KEY (CUIT);
-- Resuelto
ALTER TABLE PROVEE ADD CONSTRAINT PK_PROVEE PRIMARY KEY (id_suministro, cod_tipo_sum, CUIT);
ALTER TABLE SUMINISTRO ADD CONSTRAINT PK_SUMINISTRO PRIMARY KEY (id_suministro, cod_tipo_sum);

-- Foreign keys
-- Inicio resuelto
ALTER TABLE PROVEE ADD CONSTRAINT FK_PROVEE_SUMINISTRO
    FOREIGN KEY (id_suministro, cod_tipo_sum)
    REFERENCES SUMINISTRO (id_suministro, cod_tipo_sum);
-- Fin resuelto
ALTER TABLE PROVEE ADD CONSTRAINT FK_PROVEE_MULTI_SUM
    FOREIGN KEY (CUIT)
    REFERENCES MULTI_SUMINISTRO (CUIT);

ALTER TABLE SUMINISTRO ADD CONSTRAINT FK_SUMINISTRO_TIPO_SUMINISTRO
    FOREIGN KEY (cod_tipo_sum)
    REFERENCES TIPO_SUMINISTRO (cod_tipo_sum);

-- Inicio resuelto
ALTER TABLE MULTI_SUMINISTRO ADD CONSTRAINT FK_MULTI_SUM_EMPRESA
    FOREIGN KEY (CUIT)
    REFERENCES EMPRESA (CUIT)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE UNI_SUMINISTRO ADD CONSTRAINT FK_UNI_SUM_EMPRESA
    FOREIGN KEY (CUIT)
    REFERENCES EMPRESA (CUIT)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
-- Fin resuelto
ALTER TABLE UNI_SUMINISTRO ADD CONSTRAINT FK_UNI_SUM_SUMINISTRO
    FOREIGN KEY (id_suministro, cod_tipo_sum)
    REFERENCES SUMINISTRO (id_suministro, cod_tipo_sum);
-- End of file.

/* Pregunta 2
1) De la sentencia declarativa mas restrictiva que controle lo siguiente:
- Un mismo suministro, no puede ser ofrecido por una empresa en sus dos modalidades */
-- CHECK Global
/*
CREATE ASSERTION suministro_modalidad
CHECK (NOT EXISTS(
    SELECT 1
    FROM PROVEE p
    JOIN UNI_SUMINISTRO us ON (p.cod_tipo_sum = us.cod.cod_tipo_sum AND p.id_suministro = us.id_suministro)
)); */

-- 2) En caso de que no pueda ser implementado en PostgreSQL declarativamente, de la solución procedural mas eficiente.
CREATE FUNCTION fn_suministro_no_duplicado()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_TABLE_NAME = 'PROVEE') THEN
        IF EXISTS (
        SELECT 1 FROM UNI_SUMINISTRO
        WHERE cod_tipo_sum = NEW.cod_tipo_sum
        AND id_suministro = NEW.id_suministro)
        THEN RAISE EXCEPTION 'ERROR! Ya existe el Suministro % de tipo % contratado en modalidad única.', NEW.id_suministro, NEW.cod_tipo_sum;
        END IF;
    ELSEIF (TG_TABLE_NAME = 'UNI_SUMINISTRO') THEN
        IF EXISTS (
        SELECT 1 FROM PROVEE
        WHERE cod_tipo_sum = NEW.cod_tipo_sum
        AND id_suministro = NEW.id_suministro)
        THEN RAISE EXCEPTION 'ERROR! Ya existe el Suministro % de tipo % contratado en modalidad múltiple.', NEW.id_suministro, NEW.cod_tipo_sum;
        END IF;
    END IF;
    RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_uni_suministro
BEFORE INSERT OR UPDATE OF cod_tipo_sum, id_suministro ON UNI_SUMINISTRO
FOR EACH ROW EXECUTE FUNCTION fn_suministro_no_duplicado();

CREATE TRIGGER tr_provee
BEFORE INSERT OR UPDATE OF cod_tipo_sum, id_suministro ON PROVEE
FOR EACH ROW EXECUTE FUNCTION fn_suministro_no_duplicado();
