/* En el sistema de gestión de planes de servicios a usuarios de la figura se requiere controlar
que los usuarios mayores a 21 años que contratan más de un servicio no pueden superar los
5 servicios contratados. */
CREATE ASSERTION servicios_contratados_max
CHECK (
    NOT EXISTS (
        SELECT u.DNI
        FROM USUARIO u
        WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, u.fecha_nac)) > 21
        AND u.DNI IN (
            SELECT c.DNI
            FROM CONTRATA c
            GROUP BY c.DNI
            HAVING COUNT(*) > 5
        )
    )
);