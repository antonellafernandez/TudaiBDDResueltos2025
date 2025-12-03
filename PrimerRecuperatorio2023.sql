/*

⭐ En el esquema unc_esq_voluntario, ¿cuál sería la consulta SQL que permite listar los id de los coordinadores y la
cantidad de voluntarios que cada uno coordina, sólo si estos voluntarios pertenecen a instituciones que poseen
director y si dicha cantidad es mayor que 5 Seleccione una:

    Resuelvo:

    SELECT v.id_coordinador, COUNT(v.nro_voluntario) AS cantidad_coordinados
    FROM VOLUNTARIO v
    JOIN INSTITUCION i USING (id_institucion)
    WHERE i.id_director IS NOT NULL
    GROUP BY v.id_coordinador
    HAVING COUNT(v.nro_voluntario) > 5;

    Respuesta correcta la b.

a. SELECT id_coordinador, count(nro_voluntario) cant
FROM voluntario v JOIN institucion i ON (v.id_institucion =
i.id_institucion)
WHERE id_director != NULL
GROUP BY id_coordinador
HAVING count(*) >5;

b. SELECT id_coordinador, count(nro_voluntario) cant
FROM voluntario v JOIN institucion i ON (v.id_institucion
= i.id_institucion)
WHERE id_director IS NOT NULL
GROUP BY id_coordinador
HAVING count(nro_voluntario) >5;

c. SELECT id_coordinador, count(nro_voluntario) cant
FROM voluntario v JOIN institucion i ON (v.id_institucion =
i.id_institucion)
WHERE id_director IS NOT NULL
GROUP BY v.id_institucion
HAVING count(*) >5;

d. SELECT id_coordinador, count(nro_voluntario) cant
FROM voluntario JOIN institucion i ON (v.id_institucion =
i.id_institucion)
WHERE id_director IS NOT NULL
AND count(nro_voluntario) >5
GROUP BY id_coordinador;

e. Ninguna de las otras opciones.

⭐ Utilizando el esquema de películas unc_esq_peliculas, cual es la cantidad de empleados mayores de 60 años que son jefes de
otros empleados y además son jefes de departamento.

Seleccione una:

a. 5
b. 12
c. 11
d. Ninguna de las otras opciones es correcta.

    SELECT COUNT(DISTINCT e2.id_empleado) AS cantidad
    FROM unc_esq_peliculas.empleado e
    JOIN unc_esq_peliculas.empleado e2 ON e.id_jefe = e2.id_empleado
    JOIN unc_esq_peliculas.departamento d ON d.jefe_departamento = e2.id_empleado
    WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM e2.fecha_nacimiento) > 60;

    Respuesta d. Ninguna de las otras opciones es correcta.

⭐ En base al esquema de películas, listar los nombres de las 2 productoras que hayan producido la mayor cantidad de
películas entregadas al menos una vez.

Seleccione una:

a. "Productora Bigatti ", "Productora Errasti "
b. "Productora Gastañga", "Productora Costanzo "
c. "Productora Bigatti ", "Productora Martinez "
d. "Productora Marise ", "Productora Grela "
e. Ninguna de las opciones es Correcta.
f. "Productora Gomez ", "Productora Perez "
g. "Productora Sivori ", "Productora Ayge "

    SELECT ep.nombre_productora, COUNT(re.codigo_pelicula) AS cantidad_entregadas
    FROM unc_esq_peliculas.empresa_productora ep
    JOIN unc_esq_peliculas.pelicula p USING (codigo_productora)
    JOIN unc_esq_peliculas.renglon_entrega re USING (codigo_pelicula)
    GROUP BY ep.codigo_productora
    ORDER BY cantidad_entregadas DESC
    LIMIT 2;

    Respuesta correcta c.

*/
