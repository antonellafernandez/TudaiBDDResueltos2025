-- Pregunta 2
-- Utilizando el esquema unc_esq_voluntario. Cuáles son los 2 coordinadores(nombre) que han tenido
-- a cargo la menor cantidad de voluntarios que hayan realizado cualquier tarea terminada en CLERK.
SELECT coor.nro_voluntario, coor.nombre, COUNT(DISTINCT v.nro_voluntario) AS cantidad_voluntarios
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.voluntario coor ON v.id_coordinador = coor.nro_voluntario
JOIN unc_esq_voluntario.tarea t ON v.id_tarea = t.id_tarea
WHERE t.nombre_tarea LIKE '%CLERK'
GROUP BY coor.nro_voluntario, coor.nombre
ORDER BY cantidad_voluntarios ASC
LIMIT 2;

-- Pregunta 4
-- Utilizando el esquema unc_esq_peliculas. Cuantos empleados hay cuyo sueldo supera 6.000 y cuyo apellido
-- no contenga la letra A.
SELECT COUNT(e.id_empleado) AS cantidad
FROM unc_esq_peliculas.empleado e
WHERE e.sueldo > 6000
AND e.apellido NOT LIKE '%A%'
AND e.apellido NOT LIKE '%a%';
