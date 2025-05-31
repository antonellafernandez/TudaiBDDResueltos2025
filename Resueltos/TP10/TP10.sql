/* Ejercicio 1

Se desea obtener un listado de todos los voluntarios incluyendo identificador de voluntario,
nombre, apellido, email, identificador de institución, horas aportadas y por cada voluntario
el total de horas aportadas por todos los voluntarios de su misma institución.
Ordenado por el total de horas aportadas por institución en orden descendente. */
SELECT
    v.nro_voluntario,
    v.nombre,
    v.apellido,
    v.e_mail,
    v.id_institucion,
    v.horas_aportadas,
    SUM(v.horas_aportadas) OVER (PARTITION BY v.id_institucion) AS total_horas_institucion
FROM unc_esq_voluntario.voluntario v
ORDER BY total_horas_institucion DESC;

/* Ejercicio 2

Se desea obtener un listado de todos los voluntarios incluyendo su identificador, nombre, apellido, y
la tarea que desempeñan. Además, se requiere calcular un ranking por tarea, que indique la posición de
cada voluntario dentro de su tarea según la cantidad de horas aportadas, ubicando en los primeros puestos
a quienes más horas han contribuido. */
SELECT
    v.nro_voluntario,
    v.nombre,
    v.apellido,
    v.id_tarea,
    v.horas_aportadas,
    RANK() OVER (PARTITION BY v.id_tarea ORDER BY v.horas_aportadas DESC) AS ranking
FROM unc_esq_voluntario.voluntario v;

/* Ejercicio 3

Utilizando la consulta anterior, cómo se modificaría para obtener sólo aquellos voluntarios que
aportan más horas por tarea. */
WITH ranking_voluntarios AS (
    SELECT
        v.nro_voluntario,
        v.nombre,
        v.apellido,
        v.id_tarea,
        v.horas_aportadas,
        RANK() OVER (PARTITION BY v.id_tarea ORDER BY v.horas_aportadas DESC) AS ranking
    FROM unc_esq_voluntario.voluntario v
)
SELECT *
FROM ranking_voluntarios
WHERE ranking = 1;

/* Ejercicio 4

Se desea obtener un informe con la cantidad de voluntarios agrupada a distintos niveles geográficos:
por continente, por país y por ciudad. Probar variantes de GROUPING SETS, CUBE, y ROLLUP. */
-- GROUPING SETS: permite definir agrupaciones específicas
SELECT
    c.nombre_continente AS continente,
    p.nombre_pais AS pais,
    d.ciudad AS ciudad,
    COUNT(DISTINCT v.nro_voluntario) AS cantidad_voluntarios
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion i ON v.id_institucion = i.id_institucion
JOIN unc_esq_voluntario.direccion d ON i.id_direccion = d.id_direccion
JOIN unc_esq_voluntario.pais p ON d.id_pais = p.id_pais
JOIN unc_esq_voluntario.continente c ON p.id_continente = c.id_continente
GROUP BY GROUPING SETS (
    (c.nombre_continente),
    (p.nombre_pais),
    (d.ciudad)
)
ORDER BY c.nombre_continente, p.nombre_pais, d.ciudad;

-- ROLLUP: hace agregaciones jerárquicas de mayor a menor detalle
SELECT
    c.nombre_continente AS continente,
    p.nombre_pais AS pais,
    d.ciudad AS ciudad,
    COUNT(DISTINCT v.nro_voluntario) AS cantidad_voluntarios
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion i ON v.id_institucion = i.id_institucion
JOIN unc_esq_voluntario.direccion d ON i.id_direccion = d.id_direccion
JOIN unc_esq_voluntario.pais p ON d.id_pais = p.id_pais
JOIN unc_esq_voluntario.continente c ON p.id_continente = c.id_continente
GROUP BY ROLLUP (c.nombre_continente, p.nombre_pais, d.ciudad)
ORDER BY c.nombre_continente, p.nombre_pais, d.ciudad;

-- CUBE: todas las combinaciones posibles entre las columnas agrupadas
SELECT
    c.nombre_continente AS continente,
    p.nombre_pais AS pais,
    d.ciudad AS ciudad,
    COUNT(DISTINCT v.nro_voluntario) AS cantidad_voluntarios
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.institucion i ON v.id_institucion = i.id_institucion
JOIN unc_esq_voluntario.direccion d ON i.id_direccion = d.id_direccion
JOIN unc_esq_voluntario.pais p ON d.id_pais = p.id_pais
JOIN unc_esq_voluntario.continente c ON p.id_continente = c.id_continente
GROUP BY CUBE (c.nombre_continente, p.nombre_pais, d.ciudad)
ORDER BY c.nombre_continente, p.nombre_pais, d.ciudad;

/* Ejercicio 5

Se desea obtener un listado de todos los voluntarios que incluya su número de voluntario,
el identificador de la tarea que realiza, y la cantidad de horas aportadas.
Además, se requiere calcular el promedio de horas aportadas por tarea y, para cada voluntario,
la diferencia entre sus horas aportadas y ese promedio. */
SELECT
    v.nro_voluntario,
    v.id_tarea,
    v.horas_aportadas,
    AVG(v.horas_aportadas) OVER (PARTITION BY v.id_tarea) AS promedio_horas_aportadas_por_tarea,
    v.horas_aportadas - AVG(v.horas_aportadas) OVER (PARTITION BY v.id_tarea) AS diferencia_horas_aportadas_con_promedio
FROM unc_esq_voluntario.voluntario v;

/* Ejercicio 6

Se desea generar un listado con los voluntarios que han superado las 100 horas aportadas en total.
Para facilitar la consultas, se solicita utilizar una expresión común (CTE) que se defina
previamente la lógica de filtrado de los voluntarios con alto nivel de participación. */
-- CTE Common Table Expression
WITH voluntarios_superan_100_horas AS (
    SELECT *
    FROM unc_esq_voluntario.voluntario
    WHERE horas_aportadas > 100
)
SELECT *
FROM voluntarios_superan_100_horas;

/* Ejercicio 7

Utilizando el esquema de películas, generar un informe donde aparezca la película más entregada por mes
y año. Hacerlo con y sin funciones de ventana. */
WITH entregas_por_mes AS (
    SELECT
        EXTRACT(YEAR FROM e.fecha_entrega) AS anio,
        EXTRACT(MONTH FROM e.fecha_entrega) AS mes,
        re.codigo_pelicula,
        COUNT(*) AS cantidad_entregas
    FROM unc_esq_peliculas.renglon_entrega re
    JOIN unc_esq_peliculas.entrega e ON re.nro_entrega = e.nro_entrega
    GROUP BY EXTRACT(YEAR FROM e.fecha_entrega), EXTRACT(MONTH FROM e.fecha_entrega), re.codigo_pelicula
),
ranking_por_mes AS (
    SELECT *,
           RANK() OVER (PARTITION BY anio, mes ORDER BY cantidad_entregas DESC) AS ranking
    FROM entregas_por_mes
)
SELECT anio, mes, codigo_pelicula, cantidad_entregas
FROM ranking_por_mes
WHERE ranking = 1
ORDER BY anio, mes;
