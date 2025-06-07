-- Pregunta 1

-- Utilizando el esquema unc_esq_voluntarios. Mostrar los tres voluntarios (su PK) que más horas
-- aportadas tienen y posean coordinador.
SELECT v.nro_voluntario, v.horas_aportadas
FROM unc_esq_voluntario.voluntario v
WHERE v.id_coordinador IS NOT NULL
ORDER BY v.horas_aportadas DESC
LIMIT 3;

-- Pregunta 4

-- Utilizando el esquema unc_esq_voluntario. Cuántos voluntarios por cada tarea, nacidos entre 1998 y 1999,
-- que pertenecen a alguna FUNDACION han realizado tareas cuyo identificador contiene MAN
SELECT COUNT(*), t.id_tarea
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion i ON v.id_institucion = i.id_institucion
JOIN unc_esq_voluntario.tarea t ON v.id_tarea = t.id_tarea
WHERE EXTRACT(YEAR FROM(v.fecha_nacimiento)) BETWEEN 1998 AND 1999
AND i.nombre_institucion LIKE 'FUNDACION%'
AND t.id_tarea LIKE '%MAN%'
GROUP BY t.id_tarea;
