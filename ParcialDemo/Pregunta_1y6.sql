-- Pregunta 1

-- Utilizando el esquema unc_esq_peliculas. Contar todos los distribuidores nacionales cuyo
-- teléfono empiece con 23.
SELECT COUNT(*) AS cantidad
FROM unc_esq_peliculas.distribuidor d
WHERE d.tipo = 'N'
AND d.telefono LIKE '23%';

-- Pregunta 6

-- Utilizando el esquema unc_esq_voluntario. De qué  país(nombre) hay mayor cantidad de voluntarios
-- que realizan una tarea terminada en REP.
SELECT p.id_pais, p.nombre_pais, COUNT(v.nro_voluntario) AS cantidad_vol
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion i ON v.id_institucion = i.id_institucion
JOIN unc_esq_voluntario.direccion d ON i.id_direccion = d.id_direccion
JOIN unc_esq_voluntario.pais p ON d.id_pais = p.id_pais
WHERE v.id_tarea LIKE '%REP'
GROUP BY p.id_pais, p.nombre_pais
ORDER BY 3 DESC
LIMIT 1;
