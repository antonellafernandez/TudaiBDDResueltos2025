/* Pregunta 1

Sobre el esquema dado, incorpore los siguientes controles en SQL estándar mediante el recurso declarativo
más restrictivo y utilizando sólo las tablas y atributos necesarios. Justifique el tipo de restricción definida en cada
caso.
a) Los clientes con menos de 3 años de antigüedad pueden tener hasta 3 servicios instalados de cada tipo.
b) La fecha de instalación de cada servicio no puede ser anterior ni posterior a los años de comienzo y de fin,
respectivamente, asociadas a dicho servicio.
c) El año de comienzo de los servicios que son de vigilancia debe ser posterior a 2020.

-- a) RI GLOBAL, involucra más de una tabla
CREATE ASSERTION as_e1_a CHECK(NOT EXISTS(
       SELECT c.zona, c.nroC, s.tipoServ
       FROM CLIENTE c
       JOIN INSTALACION i ON (c.nroC = i.NroC AND c.zona = i.Zona)
       JOIN SERVICIO s ON (i.idServ = s.idServ)
       WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.fecha_alta)) < 3
       GROUP BY c.nroC, c.zona, s.tipoServ
       HAVING COUNT(*) > 3));

-- b) RI GLOBAL, involucra más de una tabla
CREATE ASSERTION as_e1_b CHECK(NOT EXISTS(
       SELECT i.idServ
       FROM INSTALACION i
       JOIN JOIN SERVICIO s ON (i.idServ = s.idServ)
       WHERE EXTRACT(YEAR FROM i.fecha_instalacion)) < s.anio_comienzo
       OR EXTRACT(YEAR FROM i.fecha_instalacion)) > s.anio_fin
));

-- c) RI TUPLA, involucra valores de una sola fila de la tabla SERVICIO
ALTER TABLE SERVICIO ADD CONSTRAINT CK_e1_c
CHECK (
   tipoServ <> 'V' OR anio_comienzo > 2020
);

-- Pregunta 2

Considere que en la tabla Servicio del esquema dado, se ha agregado un atributo cant_clientes en el cual
se requiere registrar la cantidad de clientes a los que se ha instalado cada servicio.
Explique e implemente en forma completa y de modo eficiente en PostgreSQL una solución que en cada caso
permita:
a) establecer el valor inicial de cant_clientes a partir de los datos ya existentes en la BD.
b) mantener automáticamente actualizado el atributo cant_clientes ante operaciones sobre la BD.

-- a)
ALTER TABLE SERVICIO ADD COLUMN cant_clientes INTEGER DEFAULT 0 NOT NULL;

UPDATE SERVICIO s
SET cant_clientes = (
    SELECT COUNT(DISTINCT i.nroC || '-' || i.zona)
    FROM INSTALACION i
    WHERE i.idServ = s.idServ);

-- b)
CREATE OR REPLACE FUNCTION fn_cant_clientes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE SERVICIO SET cant_clientes = cant_clientes + 1 WHERE idServ = NEW.idServ;
        RETURN NEW;
    ELSE IF (TG_OP = 'UPDATE') THEN
        UPDATE SERVICIO SET cant_clientes = cant_clientes + 1 WHERE idServ = NEW.idServ;
        UPDATE SERVICIO SET cant_clientes = cant_clientes - 1 WHERE idServ = OLD.idServ;
        RETURN NEW;
    ELSE IF (TG_OP = 'DELETE') THEN
        UPDATE SERVICIO SET cant_clientes = cant_clientes - 1 WHERE idServ = OLD.idServ;
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_cant_clientes
AFTER INSERT OR UPDATE OR DELETE OF idServ ON INSTALACION
FOR EACH ROW EXECUTE FUNCTION fn_cant_clientes();

-- Pregunta 3

Dados los siguientes servicios requeridos sobre el esquema de Películas (unc_esq_peliculas), plantee el SQL que
lo resuelve
1. ¿Cuántos distribuidores nacionales han realizado exactamente 10 entregas?
2. Listar el/los distribuidor/es con la mayor cantidad de entregas realizadas, indicando cuál es dicha cantidad.

-- 1.
SELECT COUNT(*)
FROM (
    SELECT d.id_distribuidor
    FROM unc_esq_peliculas.entrega e
    JOIN unc_esq_peliculas.distribuidor d ON e.id_distribuidor = d.id_distribuidor
    WHERE d.tipo = 'N'
    GROUP BY d.id_distribuidor
    HAVING COUNT(*) = 10
) AS subconsulta;

-- 2.
SELECT id_distribuidor, cantidad_entregas
FROM (
    SELECT d.id_distribuidor,
           COUNT(*) AS cantidad_entregas,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM unc_esq_peliculas.entrega e
    JOIN unc_esq_peliculas.distribuidor d ON e.id_distribuidor = d.id_distribuidor
    GROUP BY d.id_distribuidor
) sub
WHERE rnk = 1;

-- Pregunta 4

Considere que se ha planteado la siguiente consulta sobre el esquema de Películas (unc_esq_peliculas) a fin de
recuperar la información sobre las películas en idioma Italiano incluidas en alguna entrega de distribuidores
nacionales.

SELECT *
FROM pelicula p JOIN renglon_entrega re ON (p.codigo_pelicula =re.codigo_pelicula)
JOIN entrega e ON (e.nro_entrega = re.nro_entrega)
JOIN video v (ON e.id_video = v.id_video)
JOIN distribuidor d ON (d.id_distribuidor =e.id_distribuidor)
JOIN nacional n ON (n.id_distribuidor = d.id_distribuidor)
WHERE d.tipo = 'N' and idioma = 'Italiano';

Analice si la consulta permite responder a lo solicitado y si representa una consulta optimizada o no. Si su
respuesta es SÍ, justifique por qué, de lo contrario reescriba la consulta justificando las estrategias consideradas
para su optimización.

SELECT p.*
FROM (SELECT * FROM unc_esq_peliculas.pelicula WHERE idioma = 'Italiano') p
JOIN unc_esq_peliculas.renglon_entrega re ON p.codigo_pelicula = re.codigo_pelicula
JOIN unc_esq_peliculas.entrega e ON re.nro_entrega = e.nro_entrega
JOIN  (SELECT * FROM unc_esq_peliculas.distribuidor WHERE tipo = 'N') d ON e.id_distribuidor = d.id_distribuidor;

-- Pregunta 5

Sobre el esquema dado (link) construya una vista que contenga lo indicado en cada caso y que resulte
automáticamente actualizable en PostgreSQL siempre que sea posible (justifique por qué es posible o no):
a) datos de los clientes dados de alta el año actual que poseen únicamente instalaciones de servicios de
vigilancia.
b) datos completos asociados a cada servicio incluyendo su situación o su característica, según sea su tipo.

Para aquella/s vista/s que no soporte/n actualización automática en PostgreSQL, provea una implementación
procedural que permita propagar convenientemente operaciones de inserción sobre la vista. Explique
brevemente cómo funciona su solución. */

-- a)
CREATE OR REPLACE VIEW e5_a AS
SELECT c.*
FROM CLIENTE c
WHERE EXTRACT(YEAR FROM c.fecha_alta) = EXTRACT(YEAR FROM CURRENT_DATE)
AND NOT EXISTS (
    SELECT 1
    FROM INSTALACION i
    JOIN SERVICIO s ON i.idServ = s.idServ
    WHERE i.nroC = c.nroC
      AND i.zona = c.zona
      AND s.tipoServ <> 'V'
);