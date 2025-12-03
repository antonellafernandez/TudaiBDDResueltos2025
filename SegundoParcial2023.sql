/*

1. Se debe controlar que “los investigadores con apellido que comiencen con la letra A hasta la J
pueden trabajar a lo sumo en 5 proyectos" cuya restricción declarativa es:

    CREATE ASSERTION ej1 CHECK (
    NOT EXISTS (
        SELECT i.nro_investigador
        FROM INVESTIGADOR i
        JOIN TRABAJA_EN te USING (tipo_proyecto, cod_proyecto, nro_investigador)
        WHERE i.apellido >= 'A'
        AND i.apellido < 'K'
        GROUP BY i.nro_investigador
        HAVING COUNT(DISTINCT (te.cod_proyecto, te.tipo_proyecto)) > 5
    ));

    TABLE           INSERT      UPDATE                  DELETE
    INVESTIGADOR    NO          SI apellido     NO
    TRABAJA_EN      SI          SI tipo_proyecto,       NO
                                cod_proyecto,
                                nro_investigador

    CREATE OR REPLACE TRIGGER tr_ej1_investigador
    BEFORE UPDATE OF apellido ON INVESTIGADOR
    FOR EACH ROW EXECUTE FUNCTION fn_ej1_investigador();

    CREATE OR REPLACE FUNCTION fn_ej1_investigador() RETURNS TRIGGER AS
    $$
    BEGIN

    IF (
        NEW.apellido >= 'A'
        AND NEW.apellido < 'K'
        AND (
        SELECT COUNT(DISTINCT (te.cod_proyecto, te.tipo_proyecto))
        FROM TRABAJA_EN te
        WHERE te.nro_investigador = NEW.nro_investigador
        ) > 4)
    THEN RAISE EXCEPTION 'El investigador nro_investigador = % no puede trabajar en más de 5 proyectos.',
    NEW.nro_investigador;
    END IF;

    RETURN NEW;

    END;
    $$ LANGUAGE 'plpgsql';

    CREATE OR REPLACE TRIGGER tr_ej1_trabajaen
    BEFORE INSERT OR UPDATE OF tipo_proyecto, cod_proyecto, nro_investigador
    ON TRABAJA_EN
    FOR EACH ROW EXECUTE FUNCTION fn_ej1_trabajaen();

CREATE OR REPLACE FUNCTION fn_ej1_trabajaen() RETURNS TRIGGER AS
$$
DECLARE
    v_apellido INVESTIGADOR.apellido%type;
BEGIN

    SELECT i.apellido
    INTO v_apellido
    FROM INVESTIGADOR i
    WHERE i.nro_investigador = NEW.nro_investigador;

    IF (
        v_apellido >= 'A'
        AND v_apellido < 'K'
        AND (
        SELECT COUNT(DISTINCT (te.cod_proyecto, te.tipo_proyecto))
        FROM TRABAJA_EN te
        WHERE te.nro_investigador = NEW.nro_investigador
        ) > 4) THEN
    RAISE EXCEPTION 'El investigador nro_investigador = % no puede trabajar en más de 5 proyectos.',
    NEW.nro_investigador;
    END IF;

    RETURN NEW;

END;
$$ LANGUAGE 'plpgsql';

2. Se necesita mantener actualizado la cantidad de productos por cada categoría y la cantidad de
sucursales por cada categoría; los nuevos atributos se deben llamar cant_prod, cant_suc.

ALTER TABLE CATEGORIA
ADD COLUMN cant_prod INTEGER NOT NULL DEFAULT 0
ADD COLUMN cant_suc INTEGER NOT NULL DEFAULT 0;

UPDATE CATEGORIA c
SET cant_prod = (
    SELECT COUNT(*)
    FROM PRODUCTO p
    WHERE p.tipo_categoria = c.tipo_categoria
    AND p.cod_categoria = c.cod_categoria);

UPDATE CATEGORIA c
SET cant_suc = (
    SELECT COUNT(DISTINCT ps.cod_sucursal)
    FROM PRODUCTOS_X_SUCURSAL ps
    WHERE ps.tipo_categoria = c.tipo_categoria
    AND ps.cod_categoria = c.cod_categoria);

TABLA       INSERT      UPDATE                              DELETE
PRODUCTO    SI          SI tipo_categoria, cod_categoria    SI
SUCURSAL    SI          SI tipo_categoria, cod_categoria    SI

CREATE OR REPLACE TRIGGER tr_e2_producto
AFTER INSERT OR UPDATE OF tipo_categoria, cod_categoria OR DELETE
ON PRODUCTO
FOR EACH ROW EXECUTE FUNCTION fn_ej2_producto();

CREATE OR REPLACE FUNCTION fn_ej2_producto() RETURNS TRIGGER AS
$$
BEGIN

    IF (TG_OP = 'INSERT') THEN

        UPDATE CATEGORIA SET cant_prod = cant_prod + 1
        WHERE tipo_categoria = NEW.tipo_categoria
        AND cod_categoria = NEW.cod_categoria;

        RETURN NEW;

    ELSE IF (TG_OP = 'UPDATE') THEN

        UPDATE CATEGORIA SET cant_prod = cant_prod + 1
        WHERE tipo_categoria = NEW.tipo_categoria
        AND cod_categoria = NEW.cod_categoria;

        UPDATE CATEGORIA SET cant_prod = cant_prod - 1
        WHERE tipo_categoria = OLD.tipo_categoria
        AND cod_categoria = OLD.cod_categoria;

        RETURN NEW;

    ELSE IF (TG_OP = 'DELETE') THEN

        UPDATE CATEGORIA SET cant_prod = cant_prod - 1
        WHERE tipo_categoria = OLD.tipo_categoria
        AND cod_categoria = OLD.cod_categoria;

        RETURN OLD;

    END IF;

END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE TRIGGER tr_e2_xsucursal
AFTER INSERT OR UPDATE OF tipo_categoria, cod_categoria OR DELETE
ON PRODUCTO_X_SUCURSAL
FOR EACH ROW EXECUTE FUNCTION fn_ej2_xsucursal();

CREATE OR REPLACE FUNCTION fn_ej2_xsucursal() RETURNS TRIGGER AS
$$
BEGIN

    IF (TG_OP = 'INSERT') THEN

        UPDATE CATEGORIA SET cant_suc = cant_suc + 1
        WHERE tipo_categoria = NEW.tipo_categoria
        AND cod_categoria = NEW.cod_categoria;

        RETURN NEW;

    ELSE IF (TG_OP = 'UPDATE') THEN

        UPDATE CATEGORIA SET cant_suc = cant_suc + 1
        WHERE tipo_categoria = NEW.tipo_categoria
        AND cod_categoria = NEW.cod_categoria;

        UPDATE CATEGORIA SET cant_suc = cant_suc - 1
        WHERE tipo_categoria = OLD.tipo_categoria
        AND cod_categoria = OLD.cod_categoria;

        RETURN NEW;

    ELSE IF (TG_OP = 'DELETE') THEN

        UPDATE CATEGORIA SET cant_suc = cant_suc - 1
        WHERE tipo_categoria = OLD.tipo_categoria
        AND cod_categoria = OLD.cod_categoria;

        RETURN OLD;

    END IF;

END;
$$ LANGUAGE 'plpgsql';

*/