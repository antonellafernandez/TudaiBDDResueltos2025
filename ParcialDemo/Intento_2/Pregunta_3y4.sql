-- Pregunta 3
-- Utilizando el esquema unc_esq_peliculas. Contar todos los departamentos que no pertenezcan
-- a ninguna ciudad y que la calle empiece con la letra C.
SELECT COUNT(d.id_departamento) AS cantidad
FROM unc_esq_peliculas.departamento d
WHERE d.id_ciudad IS NULL
AND d.calle LIKE 'C%';

-- Pregunta 4
-- Utilizando el esquema unc_esq_voluntario. Cual/Cuales son los coordinadores(nombre) que han tenido
-- a cargo la mayor cantidad de voluntarios que hayan realizado cualquier tarea terminada en CLERK.
SELECT coor.nro_voluntario, coor.nombre AS "Coordinador", COUNT(v.nombre)
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.voluntario coor ON v.id_coordinador = coor.nro_voluntario
JOIN unc_esq_voluntario.tarea t ON v.id_tarea = t.id_tarea
WHERE t.id_tarea  LIKE '%CLERK'
GROUP BY coor.nro_voluntario, coor.nombre
ORDER BY 3 DESC;
