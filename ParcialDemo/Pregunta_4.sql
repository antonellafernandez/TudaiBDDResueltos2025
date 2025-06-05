-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-01 00:00:07.082

-- tables
-- Table: CONTRATA
CREATE TABLE CONTRATA (
    id_servicio int  NOT NULL,
    cod_tipo_serv int  NOT NULL,
    DNI int  NOT NULL
);

-- Table: MULTI_SERV
CREATE TABLE MULTI_SERV (
    DNI int  NOT NULL
);

-- Table: SERVICIO
CREATE TABLE SERVICIO (
    cod_tipo_serv int  NOT NULL,
    id_servicio int  NOT NULL,
    nombre_servicio varchar(120)  NOT NULL
);

-- Table: TIPO_SERVICIO
CREATE TABLE TIPO_SERVICIO (
    cod_tipo_serv int  NOT NULL,
    nombre_tipo_serv varchar(40)  NOT NULL,
    descripcion_tipo_serv text  NOT NULL,
    CONSTRAINT AK_TIPO_SERVICIO UNIQUE (nombre_tipo_serv) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- Table: UNI_SERV
CREATE TABLE UNI_SERV (
    DNI int  NOT NULL,
    id_servicio int  NOT NULL,
    cod_tipo_serv int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL
);

-- Table: USUARIO
CREATE TABLE USUARIO (
    DNI int  NOT NULL,
    e_mail varchar(120)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    fecha_nac date  NOT NULL,
    CONSTRAINT AK_USUARIO UNIQUE (e_mail) NOT DEFERRABLE  INITIALLY IMMEDIATE
);

-- End of file.

/* Pregunta 4

1) De la sentencia Declarativa mas restrictuva que controle lo siguiente:
- Un Servicio no puede ser contratado en las dos modalidades de Servicio

2) En caso de que no pueda ser implementado en PostgreSQL declarativamente, de la solución procedural
mas eficiente. */

-- 1) CHECK Global
/*
CREATE ASSERTION servicio_modalidad
CHECK (NOT EXISTS (
       SELECT 1
       FROM CONTRATA c
       JOIN UNI_SERV us ON (c.cod_tipo_serv = us.cod_tipo_serv
       AND c.id_servicio = us.id_servicio)
)); */

-- 2) TRIGGER
-- CONTRATA
CREATE FUNCTION fn_contrata_servicio_no_duplicado()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM UNI_SERV us
        WHERE us.cod_tipo_serv = NEW.cod_tipo_serv
        AND us.id_servicio = NEW.id_servicio
    ) THEN RAISE EXCEPTION 'ERROR! El Servicio ya existe en UNI_SERV.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_contrata_servicio_no_duplicado
BEFORE INSERT OR UPDATE OF cod_tipo_serv, id_servicio ON CONTRATA
FOR EACH ROW EXECUTE FUNCTION fn_contrata_servicio_no_duplicado();

-- UNI_SERV
CREATE FUNCTION fn_uni_serv_servicio_no_duplicado()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM contrata c
        WHERE c.cod_tipo_serv = NEW.cod_tipo_serv
        AND c.id_servicio = NEW.id_servicio
    ) THEN RAISE EXCEPTION 'ERROR! El Servicio ya existe en CONTRATA.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_uni_serv_servicio_no_duplicado
BEFORE INSERT OR UPDATE OF cod_tipo_serv, id_servicio ON UNI_SERV
FOR EACH ROW EXECUTE FUNCTION fn_uni_serv_servicio_no_duplicado();

/* Resuelto cátedra

CREATE OR REPLACE FUNCTION verificar_contratacion() RETURNS trigger AS $$
   BEGIN
	IF (TG_TABLE_NAME = 'uni_serv' ) THEN
        IF EXISTS (SELECT 1 FROM contrata
            WHERE id_servicio = NEW.id_servicio
            AND cod_tipo_serv = NEW.cod_tipo_serv
            ) THEN
            RAISE EXCEPTION 'El servicio % de tipo % ya está contratado en modalidad múltiple', NEW.id_servicio, NEW.cod_tipo_serv;
        END IF;
	ELSIF (TG_TABLE_NAME = 'contrata') THEN
        IF EXISTS (SELECT 1 FROM uni_serv
            WHERE id_servicio = NEW.id_servicio
            AND cod_tipo_serv = NEW.cod_tipo_serv
        ) THEN
        RAISE EXCEPTION 'El servicio % de tipo %  ya está contratado en modalidad única', NEW.id_servicio , NEW.cod_tipo_serv;
    END IF;
    END IF;
    RETURN NEW;
END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER TRG_B_INS_UPD_uni_serv
BEFORE INSERT OR UPDATE OF id_servicio, cod_tipo_serv
ON uni_serv
FOR EACH ROW
EXECUTE FUNCTION verificar_contratacion();

CREATE TRIGGER TRG_B_INS_UPD__contrata
BEFORE INSERT OR UPDATE OF id_servicio, cod_tipo_serv
ON contrata
FOR EACH ROW
EXECUTE FUNCTION verificar_contratacion(); */
