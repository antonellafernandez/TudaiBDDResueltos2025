-- 1. Seleccione el identificador y nombre de todas las instituciones que son Fundaciones. (V)
/* SELECT id_institucion, nombre_institucion
FROM unc_esq_voluntario.institucion
WHERE nombre_institucion LIKE 'FUNDACION%';
*/

-- 2. Seleccione el identificador de distribuidor, identificador de departamento y nombre de todos
-- los departamentos. (P)
/* SELECT id_distribuidor, id_departamento, nombre
FROM unc_esq_peliculas.departamento;
*/

-- 3. Muestre el nombre, apellido y el teléfono de todos los empleados cuyo id_tarea sea 7231,
-- ordenados por apellido y nombre. (P)
/* SELECT nombre AS n, apellido AS a, telefono AS t
FROM unc_esq_peliculas.empleado
WHERE id_tarea = '7231'
ORDER BY a ASC, n ASC;
*/

-- 4. Muestre el apellido e identificador de todos los empleados que no cobran porcentaje de
-- comisión. (P)
/* SELECT apellido, id_empleado
FROM unc_esq_peliculas.empleado
WHERE porc_comision IS NULL;
*/

-- 5. Muestre el apellido y el identificador de la tarea de todos los voluntarios que no tienen
-- coordinador. (V)
/* SELECT apellido, id_tarea
FROM unc_esq_voluntario.voluntario
WHERE id_coordinador IS NULL;
*/

-- 6. Muestre los datos de los distribuidores internacionales que no tienen registrado teléfono. (P)
/* SELECT *
FROM unc_esq_peliculas.distribuidor
WHERE tipo = 'I'
AND telefono IS NULL;
*/

-- 7. Muestre los apellidos, nombres y mails de los empleados con cuentas de gmail y cuyo
-- sueldo sea superior a $ 1000. (P)
/* SELECT apellido, nombre, e_mail
FROM unc_esq_peliculas.empleado
WHERE e_mail LIKE '%@gmail.com%'
AND sueldo > 1000;
*/

-- 8. Seleccione los diferentes identificadores de tareas que se utilizan en la tabla empleado. (P)
/* SELECT DISTINCT id_tarea
FROM unc_esq_peliculas.empleado;
*/

-- 9. Muestre el apellido, nombre y mail de todos los voluntarios cuyo teléfono comienza con
-- +51. Coloque el encabezado de las columnas de los títulos 'Apellido y Nombre'; y 'Dirección
-- de mail'. (V)
/* SELECT apellido || ', ' || nombre AS "Apellido y Nombre", e_mail AS "Dirección de mail"
FROM unc_esq_voluntario.voluntario
WHERE telefono LIKE '+51%'
*/

-- 10. Hacer un listado de los cumpleaños de todos los empleados donde se muestre el nombre y
-- el apellido (concatenados y separados por una coma) y su fecha de cumpleaños (solo el
-- día y el mes), ordenado de acuerdo al mes y día de cumpleaños en forma ascendente. (P)
/* SELECT nombre || ', ' || apellido AS "Nombre y Appellido",
       EXTRACT(DAY FROM fecha_nacimiento) AS dia_cumple,
       EXTRACT(MONTH FROM fecha_nacimiento) AS mes_cumple
FROM unc_esq_peliculas.empleado
ORDER BY mes_cumple, dia_cumple
*/

-- 11. Recupere la cantidad mínima, máxima y promedio de horas aportadas por los voluntarios
-- nacidos desde 1990. (V)
/* SELECT MIN(horas_aportadas),
       MAX(horas_aportadas),
       AVG(horas_aportadas)
FROM unc_esq_voluntario.voluntario
WHERE EXTRACT(YEAR FROM fecha_nacimiento) >= 1990;
*/

-- 12. Listar la cantidad de películas que hay por cada idioma. (P)
/* SELECT idioma, COUNT(codigo_pelicula) AS cantidad_peliculas
FROM unc_esq_peliculas.pelicula
GROUP BY idioma
ORDER BY idioma;
*/

-- 13. Calcular la cantidad de empleados por departamento. (P)
/* SELECT id_departamento, COUNT(id_empleado) AS cantidad_empleados
FROM unc_esq_peliculas.empleado
GROUP BY id_departamento
ORDER BY id_departamento;
*/

-- 14. Mostrar los códigos de películas que han recibido entre 3 y 5 entregas. (veces entregadas,
-- NO cantidad de películas entregadas).
/* SELECT codigo_pelicula, COUNT(*) AS cantidad_entregas
FROM unc_esq_peliculas.renglon_entrega
GROUP BY codigo_pelicula
HAVING COUNT(*) BETWEEN 3 AND 5;
*/

-- 15. ¿Cuántos cumpleaños de voluntarios hay cada mes?
/* SELECT EXTRACT(MONTH FROM fecha_nacimiento) AS mes_cumpleanios, COUNT(*) AS cantidad_cumpleanios
FROM unc_esq_voluntario.voluntario
GROUP BY mes_cumpleanios
ORDER BY mes_cumpleanios;
*/

-- 16. ¿Cuáles son las 2 instituciones que más voluntarios tienen?
/* SELECT id_institucion, COUNT(nro_voluntario) AS cantidad_voluntarios
FROM unc_esq_voluntario.voluntario
GROUP BY id_institucion
ORDER BY cantidad_voluntarios DESC
LIMIT 2;
*/

-- 17. ¿Cuáles son los id de ciudades que tienen más de un departamento?
/* SELECT id_ciudad, COUNT(id_departamento) AS cantidad_departamentos
FROM unc_esq_peliculas.departamento
GROUP BY id_ciudad
HAVING COUNT(id_departamento) > 1;
*/
