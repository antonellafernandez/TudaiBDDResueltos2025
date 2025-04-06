-- Consultas con anidamiento (usando IN, NOT IN, EXISTS, NOT EXISTS):

-- 1.1. Listar todas las películas que poseen entregas de películas de idioma inglés durante el año 2006. (P)
/*
SELECT *
FROM unc_esq_peliculas.pelicula
WHERE idioma ILIKE 'Inglés'
AND codigo_pelicula IN (
    SELECT id_video
    FROM unc_esq_peliculas.entrega
    WHERE EXTRACT(YEAR FROM fecha_entrega) = 2006
); */

-- 1.2. Indicar la cantidad de películas que han sido entregadas en 2006 por un distribuidor nacional.
-- Trate de resolverlo utilizando ensambles.(P)
/*
SELECT COUNT(p.codigo_pelicula)
FROM unc_esq_peliculas.pelicula p
JOIN unc_esq_peliculas.renglon_entrega re ON p.codigo_pelicula = re.codigo_pelicula
JOIN unc_esq_peliculas.entrega e ON re.nro_entrega = e.nro_entrega
JOIN unc_esq_peliculas.distribuidor d ON e.id_distribuidor = d.id_distribuidor
WHERE EXTRACT(YEAR FROM e.fecha_entrega) = 2006
AND d.tipo = 'N'; */

-- 1.3. Indicar los departamentos que no posean empleados cuya diferencia de sueldo máximo y
-- mínimo (asociado a la tarea que realiza) no supere el 40% del sueldo máximo. (P)
-- (Probar con 10% para que retorne valores)
/*
SELECT d.id_departamento
FROM unc_esq_peliculas.departamento d
WHERE NOT EXISTS (
    SELECT 1
    FROM unc_esq_peliculas.empleado e
    JOIN unc_esq_peliculas.tarea t ON e.id_tarea = t.id_tarea
    WHERE e.id_departamento = d.id_departamento
    AND (t.sueldo_maximo - t.sueldo_minimo) <= (t.sueldo_maximo * 0.1)
); ¡CORREGIR! NO DEVUELVE NADA */

-- 1.4. Liste las películas que nunca han sido entregadas por un distribuidor nacional.(P)
/*
SELECT *
FROM unc_esq_peliculas.pelicula p
WHERE NOT EXISTS (
    SELECT 1
    FROM unc_esq_peliculas.renglon_entrega re
    JOIN unc_esq_peliculas.entrega e ON re.nro_entrega = e.nro_entrega
    JOIN unc_esq_peliculas.distribuidor d ON e.id_distribuidor = d.id_distribuidor
    WHERE d.tipo = 'N'
    AND re.codigo_pelicula = p.codigo_pelicula
); */

-- 1.5. Determinar los jefes que poseen personal a cargo y cuyos departamentos
-- (los del jefe) se encuentren en la Argentina.
/*
SELECT DISTINCT e.id_jefe
FROM unc_esq_peliculas.empleado e
JOIN unc_esq_peliculas.empleado jefe ON e.id_jefe = jefe.id_empleado
JOIN unc_esq_peliculas.departamento d ON jefe.id_empleado = d.jefe_departamento
JOIN unc_esq_peliculas.ciudad c ON d.id_ciudad = c.id_ciudad
WHERE c.id_pais ILIKE 'AR'; */

-- 1.6. Liste el apellido y nombre de los empleados que pertenecen aaquellos departamentos
-- de Argentina y donde el jefe de departamento posee una comisión de más del 10% de la que
-- posee su empleado a cargo.
/*
SELECT e.apellido, e.nombre
FROM unc_esq_peliculas.empleado e
JOIN unc_esq_peliculas.empleado jefe ON e.id_jefe = jefe.id_empleado
JOIN unc_esq_peliculas.departamento d ON e.id_departamento = d.id_departamento
JOIN unc_esq_peliculas.ciudad c ON d.id_ciudad = c.id_ciudad
WHERE c.id_pais ILIKE 'AR'
AND jefe.porc_comision > (e.porc_comision + 10); */

-- Consultas que involucran agrupamiento:

-- 1.7. Indicar la cantidad de películas entregadas a partir del 2010, por género.
/*
SELECT COUNT(re.codigo_pelicula) AS cantidad_entregas, p.genero
FROM unc_esq_peliculas.renglon_entrega re
JOIN unc_esq_peliculas.pelicula p ON re.codigo_pelicula = p.codigo_pelicula
JOIN unc_esq_peliculas.entrega e ON re.nro_entrega = e.nro_entrega
WHERE EXTRACT(YEAR FROM e.fecha_entrega) > 2010
GROUP BY p.genero; */

-- 1.8. Realizar un resumen de entregas por día, indicando el video club al cual se le realizó la entrega
-- y la cantidad entregada. Ordenar el resultado por fecha.
/*
SELECT
    e.fecha_entrega,
    e.id_video,
    COUNT(e.nro_entrega) AS cantidad_entregada
FROM unc_esq_peliculas.entrega e
GROUP BY e.fecha_entrega, e.id_video
ORDER BY e.fecha_entrega; */

-- 1.9. Listar, para cada ciudad, el nombre de la ciudad y la cantidad de empleados mayores de edad
-- que desempeñan tareas en departamentos de la misma y que posean al menos 30 empleados.
/*
SELECT
    c.nombre_ciudad,
    COUNT(e.id_empleado) AS cantidad_empleados_mayores_de_edad
FROM unc_esq_peliculas.ciudad c
JOIN unc_esq_peliculas.departamento d ON c.id_ciudad = d.id_ciudad
JOIN unc_esq_peliculas.empleado e ON d.id_departamento = e.id_departamento
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.fecha_nacimiento)) >= 18
GROUP BY c.nombre_ciudad
HAVING COUNT(e.id_empleado) >= 30; */
