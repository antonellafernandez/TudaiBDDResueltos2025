-- Considere la base de Voluntarios del Práctico 3 y resuelva las siguientes consultas
-- (pueden Involucrar anidamiento y/o agrupamiento).

-- 2.1. Muestre, para cada institución, su nombre y la cantidad de voluntarios que realizan aportes.
-- Ordene el resultado por nombre de institución.
/*
SELECT
    i.nombre_institucion,
    COUNT(v.nro_voluntario) AS cant_vol_realizan_aportes
FROM unc_esq_voluntario.institucion i
JOIN unc_esq_voluntario.voluntario v ON i.id_institucion = v.id_institucion
WHERE v.horas_aportadas IS NOT NULL
GROUP BY i.nombre_institucion
ORDER BY i.nombre_institucion; */

-- 2.2. Determine la cantidad de coordinadores en cada país, agrupados por nombre de país y nombre de continente.
-- Etiquete la primer columna como 'Número de coordinadores'
/*
SELECT DISTINCT
    COUNT(coordinador.nro_voluntario) AS "Número de coordinadores",
    p.nombre_pais,
    c.nombre_continente
FROM unc_esq_voluntario.voluntario coordinador
JOIN unc_esq_voluntario.voluntario v ON coordinador.nro_voluntario = v.id_coordinador
JOIN unc_esq_voluntario.institucion i ON v.id_institucion = i.id_institucion
JOIN unc_esq_voluntario.direccion d ON i.id_direccion = d.id_direccion
JOIN unc_esq_voluntario.pais p ON d.id_pais = p.id_pais
JOIN unc_esq_voluntario.continente c ON p.id_continente = c.id_continente
GROUP BY p.nombre_pais, c.nombre_continente
ORDER BY p.nombre_pais; */

-- 2.3. Escriba una consulta para mostrar el apellido, nombre y fecha de nacimiento de
-- cualquier voluntario que trabaje en la misma institución que el Sr. de apellido Zlotkey.
-- Excluya del resultado a Zlotkey.
/*
SELECT DISTINCT
    v.nombre,
    v.apellido,
    v.fecha_nacimiento
FROM unc_esq_voluntario.voluntario v
WHERE v.id_institucion IN (
    SELECT id_institucion
    FROM unc_esq_voluntario.voluntario
    WHERE apellido = 'Zlotkey'
)
AND v.apellido <> 'Zlotkey'; */

-- 2.4. Cree una consulta para mostrar los números de voluntarios y los apellidos de todos
-- los voluntarios cuya cantidad de horas aportadas sea mayor que la media de las horas aportadas.
-- Ordene los resultados por horas aportadas en orden ascendente.
/*
SELECT
    v.nro_voluntario,
    v.apellido
FROM unc_esq_voluntario.voluntario v
WHERE v.horas_aportadas > (
    SELECT AVG(v2.horas_aportadas)
    FROM unc_esq_voluntario.voluntario v2
)
ORDER BY v.horas_aportadas ASC; */
