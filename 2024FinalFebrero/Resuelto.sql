CREATE TABLE CLIENTE (
    zona char(2)  NOT NULL,
    nroC int  NOT NULL,
    apell_nombre varchar(50)  NOT NULL,
    ciudad varchar(20)  NOT NULL,
    fecha_alta date  NOT NULL,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (zona,nroC)
);

CREATE TABLE INSTALACION (
    Zona char(2)  NOT NULL,
    NroC int  NOT NULL,
    idServ int  NOT NULL,
    fecha_instalacion date  NOT NULL,
    cantHoras int  NOT NULL,
    tarea varchar(50)  NOT NULL,
    CONSTRAINT PK_INSTALACION PRIMARY KEY (Zona,NroC,idServ)
);

CREATE TABLE SERVICIO (
    idServ int  NOT NULL,
    nombreServ varchar(50)  NOT NULL,
    anio_comienzo int  NOT NULL,
    anio_fin int  NULL,
    tipoServ char(1)  NOT NULL,
    CONSTRAINT PK_SERVICIO PRIMARY KEY (idServ)
);

CREATE TABLE SERV_MONITOREO (
    idServ int  NOT NULL,
    caracteristica varchar(80)  NOT NULL,
    CONSTRAINT PK_SERV_MONITOREO PRIMARY KEY (idServ)
);

CREATE TABLE SERV_VIGILANCIA (
    idServ int  NOT NULL,
    situacion varchar(80)  NOT NULL,
    CONSTRAINT PK_SERV_VIGILANCIA PRIMARY KEY (idServ)
);

ALTER TABLE INSTALACION ADD CONSTRAINT FK_INSTALACION_CLIENTE
    FOREIGN KEY (Zona, NroC)
    REFERENCES CLIENTE (zona, nroC)  
;

ALTER TABLE INSTALACION ADD CONSTRAINT FK_INSTALACION_SERVICIO
    FOREIGN KEY (idServ)
    REFERENCES SERVICIO (idServ)  
;

ALTER TABLE SERV_MONITOREO ADD CONSTRAINT FK_SMONITOREO_SERVICIO
    FOREIGN KEY (idServ)
    REFERENCES SERVICIO (idServ)  
;

ALTER TABLE SERV_VIGILANCIA ADD CONSTRAINT FK_SVIGILANCIA_SERVICIO
    FOREIGN KEY (idServ)
    REFERENCES SERVICIO (idServ)  
;

/*

1. Sobre el esquema dado (link), incorpore los siguientes controles en SQL estándar mediante el recurso declarativo
más restrictivo y utilizando sólo las tablas y atributos necesarios. Justifique el tipo de restricción definida en cada
caso.

a) Los clientes con menos de 3 años de antigüedad pueden tener hasta 3 servicios instalados de cada tipo.

CREATE ASSERTION ej1a CHECK ( NOT EXISTS (
SELECT 1
FROM INSTALACION i
JOIN CLIENTE c ON i.NroC = c.nroC AND i.Zona = c.zona
JOIN SERVICIO s ON i.idServ = s.idServ
WHERE CURRENT_DATE - c.fecha_alta < INTERVAL '3' YEAR
GROUP BY c.zona, c.nroc, s.tipoServ
HAVING COUNT(*) > 3
));

b) La fecha de instalación de cada servicio no puede ser anterior ni posterior a los años de comienzo y de fin,
respectivamente, asociadas a dicho servicio.

CREATE ASSERTION ej1b CHECK ( NOT EXISTS (
SELECT 1
FROM INSTALACION i
JOIN SERVICIO s ON i.idServ = s.idServ
WHERE EXTRACT(YEAR FROM i.fecha_instalacion) < s.anio_comienzo
OR (s.anio_fin IS NOT NULL AND EXTRACT(YEAR FROM i.fecha_instalacion) > s.anio_fin)
));

c) El año de comienzo de los servicios que son de vigilancia debe ser posterior a 2020.

ALTER TABLE SERVICIO
ADD CONSTRAINT ck_ej1c
CHECK (
    tipoServ <> 'V'
    OR anio_comienzo > 2020
);

2. Considere que en la tabla Servicio del esquema dado (link), se ha agregado un atributo cant_clientes en el cual
se requiere registrar la cantidad de clientes a los que se ha instalado cada servicio.

Explique e implemente en forma completa y de modo eficiente en PostgreSQL una solución que en cada caso
permita:

a) establecer el valor inicial de cant_clientes a partir de los datos ya existentes en la BD.

UPDATE SERVICIO s SET cant_clientes = (
    SELECT COUNT(*)
    FROM INSTALACION i
    WHERE s.idServ = i.idServ
);

b) mantener automáticamente actualizado el atributo cant_clientes ante operaciones sobre la BD.

CREATE OR REPLACE TRIGGER tr_ej2b
AFTER INSERT OR UPDATE OF idServ OR DELETE ON SERVICIO
FOR EACH ROW EXECUTE FUNCTION fn_ej2b();

CREATE OR REPLACE FUNCTION fn_ej2b() RETURNS TRIGGER AS
$$
BEGIN

    IF (TR_OP = 'INSERT) THEN
        UPDATE SERVICIO s SET cant_clientes = cant_clientes + 1
        WHERE s.idServ = NEW.idServ;

        RETURN NEW;

    ELSE IF (TR_OP = 'UPDATE') THEN
        UPDATE SERVICIO s SET cant_clientes = cant_clientes + 1
        WHERE s.idServ = NEW.idServ;

        UPDATE SERVICIO s SET cant_clientes = cant_clientes - 1
        WHERE s.idServ = OLD.idServ;

        RETURN NEW;

    ELSE IF (TR_OP = 'DELETE') THEN
        UPDATE SERVICIO s SET cant_clientes = cant_clientes - 1
        WHERE s.idServ = OLD.idServ;

        RETURN OLD;
    END IF;

END;
$$ LANGUAGE 'plpgsql';

3. Dados los siguientes servicios requeridos sobre el esquema de Películas (unc_esq_peliculas), plantee el SQL que
lo resuelve:

a. ¿Cuántos distribuidores nacionales han realizado exactamente 10 entregas?

SELECT COUNT(*) AS cantidad_distribuidores
FROM (
    SELECT d.id_distribuidor
    FROM ENTREGA e
    JOIN DISTRIBUIDOR d ON e.id_distribuidor = d.id_distribuidor
    WHERE d.tipo = 'N'
    GROUP BY d.id_distribuidor
    HAVING COUNT(*) = 10
) AS sub

b. Listar el/los distribuidor/es con la mayor cantidad de entregas realizadas, indicando cuál es dicha cantidad.

SELECT d.id_distribuidor, cantidad_entregas
FROM (
    SELECT
        d.id_distribuidor,
        COUNT(*) AS cantidad_entregas,
        RANK() OVER (ORDER BY COUNT(*) DESC) as ranking
    FROM ENTREGA e
    JOIN DISTRIBUIDOR d ON e.id_distribuidor = d.id_distribuidor
    GROUP BY d.id_distribuidor
) AS sub
WHERE ranking = 1

4.  que se ha planteado la siguiente consulta sobre el esquema de Películas (unc_esq_peliculas) a fin de
recuperar la información sobre las películas en idioma Italiano incluidas en alguna entrega de distribuidores
nacionales.

SELECT *
FROM pelicula p JOIN renglon_entrega re ON (p.codigo_pelicula = re.codigo_pelicula)
JOIN entrega e ON (e.nro_entrega = re.nro_entrega)
JOIN video v (ON e.id_video = v.id_video)
JOIN distribuidor d ON (d.id_distribuidor =e.id_distribuidor)
JOIN nacional n ON (n.id_distribuidor = d.id_distribuidor)
WHERE d.tipo = 'N' and idioma = 'Italiano';

Analice si la consulta permite responder a lo solicitado y si representa una consulta optimizada o no. Si su
respuesta es SÍ, justifique por qué, de lo contrario reescriba la consulta justificando las estrategias consideradas
para su optimización.

Consulta optimizada:

SELECT DISTINCT p.*
FROM RENGLON_ENTREGA re
JOIN PELICULA p ON re.codigo_pelicula = p.codigo_pelicula
JOIN ENTREGA e ON re.nro_entrega = e.nro_entrega
JOIN DISTRIBUIDOR d ON e.id_distribuidor = d.id_distribuidor
WHERE d.tipo = 'N' AND p.idioma = 'ITALIANO'

5. Sobre el esquema dado (link) construya una vista que contenga lo indicado en cada caso y que resulte
automáticamente actualizable en PostgreSQL siempre que sea posible (justifique por qué es posible o no):

Para aquella/s vista/s que no soporte/n actualización automática en PostgreSQL, provea una implementación
procedural que permita propagar convenientemente operaciones de inserción sobre la vista. Explique
brevemente cómo funciona su solución.

a) Datos de los clientes dados de alta el año actual que poseen únicamente instalaciones de servicios de
vigilancia.

CREATE OR REPLACE ej_5a AS
SELECT c.*
FROM CLIENTE c
WHERE EXTRACT (YEAR FROM c.fecha_alta) = EXTRACT (YEAR FROM CURRENT_DATE)
AND EXISTS (
    SELECT 1
    FROM INSTALACION i
    JOIN SERVICIO s ON i.idServ = s.idServ
    WHERE c.zona = i.Zona
    AND c.nroC = i.NroC
    AND s.tipoServ = 'V')
AND NOT EXISTS (
    SELECT 1
    FROM INSTALACION i
    JOIN SERVICIO s ON i.idServ = s.idServ
    WHERE c.zona = i.Zona
    AND c.nroC = i.NroC
    AND s.tipoServ <> 'V'
);

b) Datos completos asociados a cada servicio incluyendo su situación o su característica, según sea su tipo.

CREATE OR REPLACE VIEW ej_5b AS
SELECT s.*, COALESCE (sm.caracteristica, sv.situacion) AS caracteristica_o_situacion
FROM SERVICIO s
LEFT JOIN SERV_MONITOREO sm ON s.idServ = sm.idServ
LEFT JOIN SERV_VIGILANCIA sv ON s.idServ = sv.idServ

No es automáticamente actualizable porque hay tres tablas base involucradas
y también hay ambigüedad sobre a qué tabla escribir cuando se toca caracteristica_o_situacion.

CREATE OR REPLACE TRIGGER tr_ej5b
INSTEAD OF INSERT ON ej_5b
FOR EACH ROW EXECUTE FUNCTION fn_ej5b();

CREATE OR REPLACE FUNCTION fn_ej5b() RETURNS TRIGGER AS
$$
BEGIN

    INSERT INTO SERVICIO (idServ, nombreServ, anio_comienzo, anio_fin, tipoServ)
    VALUES (NEW.idServ, NEW.nombreServ, NEW.anio_comienzo, NEW.anio_fin, NEW.tipoServ);

    IF (NEW.tipoServ = 'M') THEN
    INSERT INTO SERVICIO_MONITOREO (idServ, caracteristica)
    VALUES (NEW.idServ, NEW.caracteristica_o_situacion);

    ELSE IF (NEW.tipoServ = 'V') THEN
    INSERT INTO SERVICIO_VIGILANCIA (idServ, situacion)
    VALUES (NEW.idServ, NEW.caracteristica_o_situacion);

    END IF;
    RETURN NULL;

END;
$$ LANGUAGE 'plpgsql';

*/

