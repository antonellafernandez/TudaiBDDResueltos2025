/*

⭐ Utilizando el esquema unc_esq_voluntarios. Cuál/es es/son el/los nombre/s y apellido/s
de los voluntarios que poseen mail de hotmail y son mayores de 28 años.

    SELECT v.nombre, v.apellido
    FROM unc_esq_voluntario.voluntario v
    WHERE v.e_mail ILIKE '%@hotmail%'
    AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, v.fecha_nacimiento)) > 28;

⭐ Utilizando el esquema unc_esq_peliculas. Cuáles son los 3 primeros identificadores
de ciudad y nombre de ciudad de aquellas ciudades que no tienen un departamento y donde
el nombre de la ciudad comience con G ordenados por identificador de país descendentemente.

    SELECT c.id_ciudad, c.nombre_ciudad
    FROM unc_esq_peliculas.ciudad c
    LEFT JOIN unc_esq_peliculas.departamento d USING (id_ciudad)
    WHERE d.id_departamento IS NULL
    AND c.nombre_ciudad ILIKE 'G%'
    ORDER BY c.id_pais DESC
    LIMIT 3;

⭐ Utilizando el esquema de películas (unc_esq_peliculas). Cuál/Cuáles son los Empleados más viejos (identificador) que han
participado en departamentos cuyos distribuidores han tenido más de 3 entregas tomando los años 2006 y 2009 (no entre,
sólo esos dos años).

⭐ Plantee el recurso declarativo más adecuado que controle que “en cada sucursal rural y por cada categoría
pueden haber como máximo 50 productos".

    CREATE ASSERTION ch1 CHECK (
    NOT EXISTS (
        SELECT ps.cod_sucursal, ps.tipo_categoria, ps.cod_categoria
        FROM PRODUCTOS_X_SUCURSAL ps
        JOIN SUCURSAL s USING (cod_sucursal)
        WHERE s.sucursal_rural = TRUE
        GROUP BY ps.cod_sucursal, ps.tipo_categoria, ps.cod_categoria
        HAVING COUNT(DISTINCT ps.nro_producto) > 50
    ));

TABLE                   INSERT  UPDATE              DELETE
SUCURSAL                NO      SI sucursal_rural   NO
PRODUCTOS_X_SUCURSAL    SI      SI                  NO

CREATE OR REPLACE TRIGGER tr_sucursal
BEFORE UPDATE OF sucursal_rural ON SUCURSAL
FOR EACH ROW EXECUTE FUNCTION fn_sucursal();

CREATE OR REPLACE FUNCTION fn_sucursal() RETURNS TRIGGER AS
$$
BEGIN

    IF (NEW.sucursal_rural = TRUE) THEN

        IF EXISTS (
            SELECT ps.cod_sucursal, ps.tipo_categoria, ps.cod_categoria
            FROM PRODUCTOS_X_SUCURSAL ps
            WHERE ps.cod_sucursal = NEW.cod_sucursal
            GROUP BY ps.cod_sucursal, ps.tipo_categoria, ps.cod_categoria
            HAVING COUNT(DISTINCT ps.nro_producto) > 49
        ) THEN
        RAISE EXCEPTION 'La sucursal id = % puede tener máximo 50 productos si es rural.', NEW.cod_sucursal;
        END IF;

        RETURN NEW;

    END IF;

    RETURN NEW;

END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE TRIGGER tr_prodxsuc
BEFORE INSERT OR UPDATE OF cod_sucursal, tipo_categoria, cod_categoria
ON PRODUCTOS_X_SUCURSAL
FOR EACH ROW EXECUTE FUNCTION fn_prodxsuc();

CREATE OR REPLACE FUNCTION fn_prodxsuc() RETURNS TRIGGER AS
$$
DECLARE v_rural BOOLEAN;
BEGIN

    SELECT s.sucursal_rural
    INTO v_rural
    FROM SUCURSAL s
    WHERE s.cod_sucursal = NEW.cod_sucursal;

    IF (v_rural = TRUE) THEN

        IF EXISTS (
            SELECT ps.cod_sucursal, ps.tipo_categoria, ps.cod_categoria
            FROM PRODUCTOS_X_SUCURSAL ps
            WHERE ps.cod_sucursal = NEW.cod_sucursal
            AND ps.tipo_categoria = NEW.tipo_categoria
            AND ps.cod_categoria = NEW.cod_categoria
            GROUP BY ps.cod_sucursal, ps.tipo_categoria, ps.cod_categoria
            HAVING COUNT(DISTINCT ps.nro_producto) > 49
        ) THEN
        RAISE EXCEPTION 'La sucursal id = % puede tener máximo 50 productos si es rural.', NEW.cod_sucursal;
        END IF;

        RETURN NEW;

    END IF;

    RETURN NEW;

END;
$$ LANGUAGE 'plpgsql';

*/
