/*

2a. Se necesita controlar que un Investigador(sin importar su proyecto)
no pueda trabajar en mas de 3 áreas de Investigación.

    CREATE ASSERTION ej2a CHECK (
    NOT EXISTS (
        SELECT nro_investigador
        FROM TRABAJA_EN te
        GROUP BY nro_investigador
        HAVING COUNT(DISTINCT cod_area) > 3
    ));

TABLA           INSERT      UPDATE      DELETE
TRABAJA_EN      SI          SI          NO

CREATE OR REPLACE TRIGGER tr_ej2a
BEFORE INSERT OR UPDATE OF nro_investigador, cod_area
ON TRABAJA_EN
FOR EACH ROW EXECUTE FUNCTION fn_ej2a();

CREATE OR REPLACE FUNCTION fn_ej2a() RETURNS TRIGGER AS
$$
BEGIN

    IF ((SELECT COUNT(DISTINCT cod_area)
        FROM TRABAJA_EN te
        WHERE nro_investigador = NEW.nro_investigador) > 2)

    THEN RAISE EXCEPTION
        'El investigador nro_investigador = % no puede trabajar en más de tres áreas.',
        NEW.nro_investigador;
    END IF;

    RETURN NEW;

END;
$$ LANGUAGE 'plpgsql';

2b. Se necesita controlar que si la descripcion del área de Investigación contiene la frase "aplicada"
(sin importar si está en mayúsculas o mínusculas) el atributo investigacion_aplicada debe ser true.

    ALTER TABLE INVESTIGACION_APLICADA
    ADD CONSTRAINT ck_ej2b CHECK (
        (descripcion ILIKE '%aplicada%' AND investigacion_aplicada = TRUE)
        OR descripcion NOT ILIKE '%aplicada%'
    );

3. Ante el siguiente modelo. Cree una vista automáticamente actualizable en PostgreSQL, optimizada bajo reglas de
equivalencia (nombre cuales de ellas) y que las tuplas no puedan migrarse donde se seleccione el nombre y apellido de
aquellos médicos que atienden en más de 3 centros de salud con sala de atención y que además tengan especialidad
PEDIATRIA.

CREATE OR REPLACE VIEW v3 AS
SELECT
    m.nro_matricula,
    m.nombre,
    m.apellido
FROM MEDICO m
WHERE
    m.tipo_especialidad = 'PED'
    AND (
        SELECT COUNT(DISTINCT a.cod_centro) AS cant
        FROM ATIENDE a
        JOIN CENTRO_SALUD c USING (cod_centro)
        WHERE m.tipo_especialidad = a.tipo_especialidad
        AND m.cod_especialidad = a.cod_especialidad
        AND m.nro_matricula = a.nro_matricula)
        AND c.sala_atencion = TRUE) > 3
WITH CHECK OPTION;

*/