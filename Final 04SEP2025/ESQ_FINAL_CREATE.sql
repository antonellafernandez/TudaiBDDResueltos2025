-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-09-01 18:03:02.421

-- tables
-- Table: CONTACTO_ESTACION
CREATE TABLE CONTACTO_ESTACION (
    id_contacto serial  NOT NULL,
    id_satelite int  NOT NULL,
    id_estacion int  NOT NULL,
    fecha_contacto timestamp  NOT NULL,
    duracion_minutos int  NULL,
    tipo_contacto varchar(50)  NULL,
    CONSTRAINT CONTACTO_ESTACION_pk PRIMARY KEY (id_contacto)
);

-- Table: ESTACION_TERRENA
CREATE TABLE ESTACION_TERRENA (
    id_estacion serial  NOT NULL,
    nombre varchar(100)  NOT NULL,
    pais varchar(100)  NOT NULL,
    ubicacion_lat decimal(9,6)  NOT NULL,
    ubicacion_lon decimal(9,6)  NOT NULL,
    responsable varchar(100)  NULL,
    CONSTRAINT ESTACION_TERRENA_pk PRIMARY KEY (id_estacion)
);

-- Table: IMAGENES_CAPTURADAS
CREATE TABLE IMAGENES_CAPTURADAS (
    id_imagen serial  NOT NULL,
    id_sensor int  NOT NULL,
    fecha_captura timestamp  NOT NULL,
    ubicacion_centro_lat decimal(9,6)  NOT NULL,
    ubicacion_centro_lon decimal(9,6)  NOT NULL,
    resolucion decimal(6,2)  NOT NULL,
    formato varchar(20)  NOT NULL,
    ruta_archivo varchar(255)  NULL,
    CONSTRAINT IMAGENES_CAPTURADAS_pk PRIMARY KEY (id_imagen)
);

-- Table: MISION
CREATE TABLE MISION (
    id_mision serial  NOT NULL,
    nombre_mision varchar(100)  NOT NULL,
    objetivo text  NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NULL,
    CONSTRAINT MISION_pk PRIMARY KEY (id_mision)
);

-- Table: ORBITA
CREATE TABLE ORBITA (
    id_orbita serial  NOT NULL,
    tipo_orbita varchar(50)  NOT NULL,
    altitud_km decimal(8,2)  NULL,
    inclinacion_grados decimal(5,2)  NULL,
    periodo_minutos decimal(6,2)  NULL,
    CONSTRAINT ORBITA_pk PRIMARY KEY (id_orbita)
);

-- Table: SATELITE
CREATE TABLE SATELITE (
    id_satelite serial  NOT NULL,
    nombre varchar(100)  NOT NULL,
    pais_origen varchar(100)  NOT NULL,
    agencia varchar(100)  NOT NULL,
    fecha_lanzamiento date  NOT NULL,
    vida_util_estimada int  NOT NULL,
    estado varchar(5)  NOT NULL,
    id_tipo int  NOT NULL,
    id_orbita int  NOT NULL,
    CONSTRAINT SATELITE_pk PRIMARY KEY (id_satelite)
);

-- Table: SATELITE_MISION
CREATE TABLE SATELITE_MISION (
    id_satelite int  NOT NULL,
    id_mision int  NOT NULL,
    CONSTRAINT SATELITE_MISION_pk PRIMARY KEY (id_satelite,id_mision)
);

-- Table: SENSOR
CREATE TABLE SENSOR (
    id_sensor serial  NOT NULL,
    id_satelite int  NOT NULL,
    nombre_sensor varchar(100)  NOT NULL,
    tipo_sensor varchar(50)  NOT NULL,
    resolucion decimal(6,2)  NOT NULL,
    ancho_banda decimal(6,2)  NULL,
    CONSTRAINT SENSOR_pk PRIMARY KEY (id_sensor)
);

-- Table: TIPO_SATELITE
CREATE TABLE TIPO_SATELITE (
    id_tipo serial  NOT NULL,
    descripcion varchar(100)  NOT NULL,
    CONSTRAINT TIPO_SATELITE_pk PRIMARY KEY (id_tipo)
);

-- foreign keys
-- Reference: FK_0 (table: SENSOR)
ALTER TABLE SENSOR ADD CONSTRAINT FK_0
    FOREIGN KEY (id_satelite)
    REFERENCES SATELITE (id_satelite)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_1 (table: CONTACTO_ESTACION)
ALTER TABLE CONTACTO_ESTACION ADD CONSTRAINT FK_1
    FOREIGN KEY (id_satelite)
    REFERENCES SATELITE (id_satelite)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_2 (table: CONTACTO_ESTACION)
ALTER TABLE CONTACTO_ESTACION ADD CONSTRAINT FK_2
    FOREIGN KEY (id_estacion)
    REFERENCES ESTACION_TERRENA (id_estacion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_3 (table: SATELITE_MISION)
ALTER TABLE SATELITE_MISION ADD CONSTRAINT FK_3
    FOREIGN KEY (id_satelite)
    REFERENCES SATELITE (id_satelite)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_4 (table: SATELITE_MISION)
ALTER TABLE SATELITE_MISION ADD CONSTRAINT FK_4
    FOREIGN KEY (id_mision)
    REFERENCES MISION (id_mision)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_5 (table: IMAGENES_CAPTURADAS)
ALTER TABLE IMAGENES_CAPTURADAS ADD CONSTRAINT FK_5
    FOREIGN KEY (id_sensor)
    REFERENCES SENSOR (id_sensor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: fk_orbita (table: SATELITE)
ALTER TABLE SATELITE ADD CONSTRAINT fk_orbita
    FOREIGN KEY (id_orbita)
    REFERENCES ORBITA (id_orbita)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: fk_tipo (table: SATELITE)
ALTER TABLE SATELITE ADD CONSTRAINT fk_tipo
    FOREIGN KEY (id_tipo)
    REFERENCES TIPO_SATELITE (id_tipo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

/* 1a) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las
tablas/atributos necesarios.

- Verificar que cada satélite tenga al menos una misión.

Seleccione la/las opción/es que considera correcta/s, de acuerdo a lo solicitado y justifique claramente porqué
la/s considera correcta/s.

a. CREATE ASSERTION check_satelite_mision CHECK ( NOT EXISTS (
SELECT 1 FROM satelite s LEFT JOIN satelite_mision m USING (id_satelite)
GROUP BY s.id_satelite HAVING COUNT(id_mision) < 1) );

b. ALTER TABLE satelite_mision ADD CONSTRAINT check_satelite_mision CHECK (NOT EXISTS (
SELECT 1 FROM satelite_mision s
GROUP BY s.id_satelite HAVING COUNT(*) < 1));

c. CREATE ASSERTION check_satelite_mision CHECK (NOT EXISTS (
SELECT 1 FROM satelite s LEFT JOIN satelite_mision m USING (id_satelite) LEFT JOIN mision (id_mision)
GROUP BY s.id_satelite HAVING COUNT(id_mision) < 1));

d. CREATE ASSERTION check_satelite_mision CHECK (EXISTS (
SELECT 1 FROM satelite s JOIN satelite_mision m USING (id_satelite)
GROUP BY s.id_satelite HAVING COUNT(id_mision) < 1) );

Las respuestas correctas son a y c porque ambas usan una ASSERTION (restricción general) y un LEFT JOIN entre
SATELITE y SATELITE_MISION. El LEFT JOIN garantiza que aparezcan todos los satélites, incluso los que no tienen filas
en SATELITE_MISION. Para esos satélites, id_mision queda en NULL, y por eso COUNT(id_mision) devuelve 0 (no cuenta nulos).
De esta forma, el HAVING COUNT(id_mision) < 1 detecta justamente los satélites sin misiones, y el NOT EXISTS impide que existan,
cumpliendo “cada satélite tiene al menos una misión”.

La opción c incluye la tabla MISION de más, pero no altera la lógica, por eso también es válida.

La opción b no es correcta porque un CHECK de tabla no puede garantizar la existencia de filas relacionadas en otra tabla,
y además solo ve satélites que ya tienen al menos una fila en SATELITE_MISION, con lo cual no controla los satélites sin misiones.

La opción d es incorrecta porque usa EXISTS en vez de NOT EXISTS y además un JOIN (no LEFT),
por lo que nunca considera satélites sin misiones y la condición del HAVING no se cumple para ningún grupo.
*/



/* 1b) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando solo las
tablas/atributos necesarios.

Las fechas de contacto de cada estación deben ser posteriores a la fecha de lanzamiento de cada satélite.

Resuelva según lo solicitado y justifique el tipo de chequeo utilizado.

CREATE ASSERTION e1b CHECK ( NOT EXISTS (
   SELECT 1
   FROM CONTACTO_ESTACION ce
   JOIN SATELITE s ON ce.id_satelite = s.id_satelite
   WHERE ce.fecha_contacto <= s.fecha_lanzamiento
   ));

El tipo de chequeo es general ya que los atributos que se deben controlar (fecha_contacto y fecha_lanzamiento)
pertenecen a dos tablas distintas del esquema (CONTACTO_ESTACION, SATELITE)
*/



/* 2a) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
actualizable en PostgreSQL, siempre que sea posible:

- V1: que contenga todos los datos de los satélites que aún no han hecho contacto con ninguna estación terrena.

CREATE OR REPLACE VIEW v1 AS
   SELECT *
   FROM SATELITE s
   WHERE NOT EXISTS (
    SELECT 1
    FROM CONTACTO_ESTACION ce
    WHERE ce.id_satelite = s.id_satelite);

⭐ Reglas de vista actualizable en PostgreSQL:
    • Tiene una sola tabla en el FROM.
    • No tiene JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN.
    • No tiene GROUP BY, HAVING, DISTINCT, UNION, etc.
    • No usa funciones de agregación.
    • No redefine columnas ni calcula expresiones.
*/



/* 2b) Considerando la siguiente definición para V1, seleccione la/s afirmación/es que considere correcta/s
respecto de esta vista y justifíquela/s claramente.

CREATE VIEW V1 AS
SELECT * FROM satélite s
WHERE NOT EXISTS (SELECT 1 FROM tipo_satélite t WHERE s.id_tipo = t.id_tipo AND upper(descripcion) like
‘%RECONOCIMIENTO%’)

a. Ninguna de las opciones es correcta.

b. No es posible reformular la consulta para seleccionar todos los satélites que son del tipo reconocimiento
(y sea automáticamente actualizable).

c. No resulta automáticamente actualizable en PostgreSQL.

d. Contiene todos los datos de los satélites de reconocimiento.

e. Es automáticamente actualizable en PostgreSQL.

f. Para seleccionar todos los satélites que son del tipo reconocimiento hay que reformular la consulta
cambiendo el NOT EXISTS por EXISTS.

g. No está correctamente correlacionada la consulta con la subconsulta.

h. Está correctamente correlacionada la consulta con la subconsulta.

Las resuestas correctas son e, f y h. */



/* 2c) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
actualizable en PostgreSQL, siempre que sea posible, y que se verifique que no haya migración de tuplas de la
vista. Resuelva según lo solicitado y justifique su solución.

- V2: Listar los satélites lanzados después del año 2024 que no poseen sensores.

CREATE OR REPLACE VIEW v2 AS
   SELECT *
   FROM SATELITE sa
   WHERE EXTRACT(YEAR FROM sa.fecha_lanzamiento) > 2024
   AND NOT EXISTS (
       SELECT 1
       FROM SENSOR se
       WHERE sa.id_satelite = se.id_satelite)
   WITH CHECK OPTION;

La vista se define sobre una sola tabla base (SATELITE), sin JOIN en el FROM, sin agregaciones, GROUP BY, DISTINCT, etc.

La subconsulta en el WHERE con NOT EXISTS no rompe la actualizabilidad.

Se agrega WITH CHECK OPTION para que las operaciones INSERT/UPDATE realizadas a través de la vista
no puedan dejar filas que no cumplan la condición de la vista. */



/* 3) Para el esquema dado, es necesario consultar los contactos de un satélite realizados después de una
determinada fecha, mostrando: estación, fecha del contacto y duración; el satélite y la fecha son datos que se
aportan. Resuelva con el recurso que considere más conveniente.

   CREATE OR REPLACE FUNCTION fe3(consulta_id_satelite INTEGER, consulta_fecha DATE) RETURNS TABLE (
       id_estacion      INTEGER,
       fecha_contacto   TIMESTAMP,
       duracion_minutos   INTEGER
   )
   AS $$ BEGIN
       RETURN QUERY
       SELECT ce.id_estacion, ce.fecha_contacto, ce.duracion_minutos
       FROM CONTACTO_ESTACION ce
       WHERE ce.id_satelite = consulta_id_satelite
       AND ce.fecha_contacto > consulta_fecha;
   END; $$ LANGUAGE 'plpgsql'; */



/* 4) Listar todas las imágenes capturadas mostrando el id_imagen, fecha_captura, id_sensor y un número de fila
ordenado por fecha de captura dentro de cada sensor además de la fecha de la primera imagen tomada por
ese sensor.

   CREATE OR REPLACE v4 AS
   SELECT ic.id_imagen,
          ic.fecha_captura,
          ic.id_sensor,
          ROW_NUMBER() OVER(PARTITION BY ic.id_sensor ORDER BY ic.fecha_captura), // Numera las imágenes dentro de cada sensor, según la fecha de captura.
          MIN(ic.fecha_captura) OVER(PARTITION BY ic.id_sensor) AS primera_imagen_tomada
   FROM IMAGENES_CAPTURADAS ic
   ORDER BY ic.id_sensor, ic.fecha_captura; */



/* 5a) Es posible plantear con una sentencia declarativa un control que no permita agregar imágenes a satélites
que están activos? Si su respuesta es positiva plantee el control, caso contrario justifique porque.

CREATE ASSERTION ej_5a CHECK (
NOT EXISTS (
    SELECT 1
    FROM SATELITE s
    JOIN SENSOR se ON s.id_satelite = se.id_satelite
    JOIN IMAGENES_CAPTURADAS ic ON se.id_sensor = ic.id_sensor
    WHERE s.estado = 'ACTIV'
)); */



/* 5b) En caso de que sea posible plantee de manera procedural lo requerido en el punto 5.a)

   TABLA                    INSERT      UPDATE              DELETE
   SATELITE                 NO          SI estado           NO
   SENSOR                   NO          SI id_satelite      NO
   IMAGENES_CAPTURADAS      SI          SI id_sensor        NO

   -- Trigger SATELITE
   CREATE OR REPLACE TRIGGER tr_ej5b_satelite
   BEFORE UPDATE OF estado ON SATELITE
   FOR EACH ROW EXECUTE FUNCTION fn_ej5b_satelite();

   -- Función SATELITE
   CREATE OR REPLACE FUNCTION fn_ej5b_satelite() RETURNS TRIGGER AS
   $$
   BEGIN

    IF (NEW.estado = 'ACTIV') THEN

        IF EXISTS (
            SELECT 1
            FROM SENSOR se
            JOIN IMAGENES_CAPTURADAS ic ON se.id_sensor = ic.id_sensor
            WHERE se.id_satelite = NEW.id_satelite
        )

        THEN RAISE EXCEPTION 'No se puede actualizar el estado a ACTIVO porque existen imágenes para
        el satélite id_satelite = %', NEW.id_satelite;

        END IF;

    END IF;

    RETURN NEW;

   END;
   $$ LANGUAGE 'plpgsql';



   -- Trigger SENSOR
   CREATE OR REPLACE TRIGGER tr_ej5b_sensor
   BEFORE UPDATE OF id_satelite ON SENSOR
   FOR EACH ROW EXECUTE FUNCTION fn_ej5b_sensor();

   -- Función SENSOR
   CREATE OR REPLACE FUNCTION fn_ej5b_sensor() RETURNS TRIGGER AS
   $$
   DECLARE

    v_estado SATELITE.estado%type;

   BEGIN

    SELECT s.estado
    INTO v_estado
    FROM SATELITE s
    WHERE s.id_satelite = NEW.id_satelite;

    IF (v_estado = 'ACTIV') THEN

        IF EXISTS (
            SELECT 1
            FROM IMAGENES_CAPTURADAS ic
            WHERE ic.id_sensor = NEW.id_sensor
        )

        THEN RAISE EXCEPTION 'No se puede modificar al id_satelite = % porque el sensor ya tiene imágenes.', NEW.id_satelite;

        END IF;

    END IF;

    RETURN NEW;

   END;
   $$ LANGUAGE 'plpgsql';


   -- Trigger IMAGENES_CAPTURADAS
   CREATE OR REPLACE TRIGGER tr_ej5b_imgcapt
   BEFORE INSERT OR UPDATE OF id_sensor
   ON IMAGENES_CAPTURADAS
   FOR EACH ROW EXECUTE FUNCTION fn_ej5b_imgcapt();

   -- Función IMAGENES_CAPTURADAS
   CREATE OR REPLACE FUNCTION fn_ej5b_imgcapt() RETURNS TRIGGER AS
   $$
   DECLARE
    v_satelite SENSOR.id_satelite%type;
    v_estado SATELITE.estado%type;
   BEGIN

       SELECT se.id_satelite
       INTO v_satelite
       FROM SENSOR se
       WHERE se.id_sensor = NEW.id_sensor;

       SELECT s.estado
       INTO v_estado
       FROM SATELITE s
       WHERE v_satelite = s.id_satelite;

       IF (v_estado = 'ACTIV') THEN
            RAISE EXCEPTION 'No se pueden agregar imágenes al satélite id = %', v_satelite;
       END IF;

       RETURN NEW;

   END;
   $$ LANGUAGE 'plpgsql'; */
