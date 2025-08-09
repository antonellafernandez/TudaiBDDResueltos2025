-- Pregunta 1
SELECT t.id_tarea, t.sueldo_maximo, t.sueldo_maximo - t.sueldo_maximo AS diferencia
FROM unc_esq_peliculas.tarea t
WHERE t.sueldo_maximo < 10500
ORDER BY 3 DESC
LIMIT 3;

-- Pregunta 2
SELECT *, 'sup'
FROM unc_esq_voluntario.voluntario v
UNION
SELECT *, 'vol'
FROM unc_esq_voluntario.voluntario
WHERE id_coordinador = voluntario.nro_voluntario;

-- Pregunta 3
SELECT p.codigo_pelicula, p.formato, p.titulo
FROM unc_esq_peliculas.pelicula p
WHERE NOT EXISTS (
        SELECT 1
        FROM unc_esq_peliculas.renglon_entrega re
        WHERE p.codigo_pelicula = re.codigo_pelicula )
AND p.titulo LIKE 'K%'
ORDER BY p.titulo ASC
LIMIT 3;

-- Pregunta 4
SELECT COUNT(DISTINCT em.id_empleado) AS cantidad
FROM unc_esq_peliculas.empleado em
JOIN unc_esq_peliculas.departamento de ON em.id_departamento = de.id_departamento
JOIN unc_esq_peliculas.distribuidor di ON de.id_distribuidor = di.id_distribuidor
WHERE di.id_distribuidor IN (
    SELECT en.id_distribuidor
    FROM unc_esq_peliculas.entrega en
    WHERE EXTRACT(YEAR FROM en.fecha_entrega) IN (2001, 2005)
    GROUP BY en.id_distribuidor
    HAVING COUNT(*) > 3);

-- Pregunta 6
/*
FK_VISITA_LABORATORIO
ON UPDATE CASCADE
-- Si se actualiza la clave primaria del laboratorio referenciado,
-- también se actualiza automáticamente la clave foránea en la tabla VISITA.
ON DELETE RESTRICT
-- No permite eliminar un laboratorio si existen visitas que lo referencian.

FK_VISITA_MEDICO
ON UPDATE RESTRICT
-- No permite actualizar el ID del médico si hay visitas que lo referencian.
ON DELETE CASCADE
-- Si se elimina un médico, también se eliminan automáticamente
-- todas las visitas asociadas a ese médico.

DELETE FROM MEDICO WHERE tipo_doc = ‘DNI’ AND nro_doc =’32456’; -- PROCEDE
DELETE FROM VISITA WHERE id_lab = 1; -- FALLA está referenciado
UPDATE MEDICO SET nro_doc = 33376 WHERE nro_doc = 34266; -- FALLA está referenciado
UPDATE LABORATORIO SET id_lab = 8 WHERE id_lab = 3; -- PROCEDE
UPDATE MEDICO SET nro_doc = 33376 WHERE nro_doc = 12376; -- PROCEDE no está referenciado
DELETE FROM LABORATORIO WHERE id_lab = 2; -- FALLA está referenciado
DELETE FROM MEDICO WHERE tipo_doc = ‘PAS’; -- PROCEDE */
