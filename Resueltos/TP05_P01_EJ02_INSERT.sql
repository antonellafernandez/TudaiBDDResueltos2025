-- EMPLEADO
INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 1, 'Juan', 'Garcia', 'Jefe');
INSERT INTO tp5_p1_ej2_empleado VALUES ('B', 1, 'Luis', 'Lopez', 'Adm');
INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 2, 'María', 'Casio', 'CIO');

-- PROYECTO
INSERT INTO tp5_p1_ej2_proyecto VALUES (1, 'Proy 1', 2019, NULL);
INSERT INTO tp5_p1_ej2_proyecto VALUES (2, 'Proy 2', 2018, 2019);
INSERT INTO tp5_p1_ej2_proyecto VALUES (3, 'Proy 3', 2020, NULL);

-- TRABAJA_EN
INSERT INTO tp5_p1_ej2_trabaja_en VALUES ('A ', 1, 1, 35, 'T1');
INSERT INTO tp5_p1_ej2_trabaja_en VALUES ('A ', 2, 2, 25, 'T3');

-- AUSPICIO
INSERT INTO tp5_p1_ej2_auspicio VALUES (2, 'McDonald', 'A ', 2);

/* Ejercicio 2

a) Indique el resultado de las siguientes operaciones, teniendo en cuenta las acciones referenciales
   e instancias dadas. En caso de que la operación no se pueda realizar,
   indicar qué regla/s entra/n en conflicto y cuál es la causa. En caso de que sea aceptada,
   comente el resultado que produciría (NOTA: en cada caso considere el efecto sobre
   la instancia original de la BD, los resultados no son acumulativos). */

    -- b.1) Como el proyecto con id_proyecto = 3 no está referenciado en ninguna tabla,
    -- la operación se realiza con éxito.
    delete from tp5_p1_ej2_proyecto where id_proyecto = 3;

    -- b.2) Aunque AUSPICIO tiene ON UPDATE RESTRICT (que impide cambiar el valor si hay referencias),
    -- como no hay ninguna referencia al proyecto con id_proyecto = 3, no se bloquea la operación.
    update tp5_p1_ej2_proyecto set id_proyecto = 7 where id_proyecto = 3;

    -- b.3) ERROR! Key (id_proyecto)=(1) is still referenced from table "tp5_p1_ej2_trabaja_en".
    -- TP5_P1_EJ2_TRABAJA_EN tiene  ON DELETE RESTRICT (impide cambiar el valor si hay referencias).
    delete from tp5_p1_ej2_proyecto where id_proyecto = 1;

    -- b.4) Se borra con éxito ya que no está referenciado ese empleado en otra tabla.
    delete from tp5_p1_ej2_empleado where tipo_empleado = 'A ' and nro_empleado = 2;

    -- b.5) La operación se realiza exitosamente.

        -- • Cualquier fila en TRABAJA_EN que tenga id_proyecto = 1 ahora tendrá id_proyecto = 3.

        -- • No rompe ninguna regla, ya que el valor nuevo (3) existe en PROYECTO y el ON UPDATE
        -- en esta tabla no afecta, porque estás actualizando desde el lado dependiente,
        -- no desde la tabla referenciada.
    update tp5_p1_ej2_trabaja_en set id_proyecto = 3 where id_proyecto = 1;

    -- b.6) ERROR! Key (id_proyecto)=(2) is still referenced from table "tp5_p1_ej2_auspicio".
    -- TP5_P1_EJ2_AUSPICIO tiene ON UPDATE  RESTRICT (impide cambiar el valor si hay referencias).
    update tp5_p1_ej2_proyecto set id_proyecto = 5 where id_proyecto = 2;

-- b) Indique el resultado de la siguiente operaciones justificando su elección:

update tp5_p1_ej2_auspicio set id_proyecto = 66, nro_empleado = 10
    where id_proyecto = 22
    and tipo_empleado = 'A '
    and nro_empleado = 5;

-- Back (?)
update tp5_p1_ej2_auspicio set id_proyecto = 22, nro_empleado = 5
    where id_proyecto = 66
    and tipo_empleado = 'A '
    and nro_empleado = 10;

-- EMPLEADO
INSERT INTO TP5_P1_EJ2_EMPLEADO VALUES ('A ', 5, 'Carlos', 'Méndez', 'Analista');
INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 10, 'Pepe', 'Argento', 'Papucho');

-- PROYECTO
INSERT INTO TP5_P1_EJ2_PROYECTO VALUES (22, 'Proyecto Ejemplo', 2024, NULL);
INSERT INTO tp5_p1_ej2_proyecto VALUES (66, 'Proy 66', 1966, NULL);

-- AUSPICIO
INSERT INTO TP5_P1_EJ2_AUSPICIO VALUES (22, 'CocaCola', 'A ', 5);

-- (suponga que existe la tupla asociada) --> Realicé los INSERT

    -- i. realiza la modificación si existe el proyecto 22 y el empleado TipoE = 'A' ,NroE = 5

    -- ii. realiza la modificación si existe el proyecto 22 sin importar si existe el
    -- empleado TipoE = 'A' ,NroE = 5

    -- iii.se modifican los valores, dando de alta el proyecto 66 en caso de que no exista
    -- (si no se violan restricciones de nulidad), sin importar si existe el empleado

    -- iv. se modifican los valores, y se da de alta el proyecto 66 y el empleado correspondiente
    -- (si no se violan restricciones de nulidad)

    -- v. no permite en ningún caso la actualización debido a la modalidad de la restricción
    -- entre la tabla empleado y auspicio.

    -- vi. ninguna de las anteriores, cuál?

    -- La consulta no modifica nada porque no existe ese registro.

    -- ERROR! Key (tipo_empleado, nro_empleado)=(A , 10) is not present in table "tp5_p1_ej2_empleado".
    -- Tuve que insertar el Empleado (tipo_empleado, nro_empleado)=(A , 10)
    -- y el Proyecto (id_proyecto)=(66).

-- d) Indique cuáles de las siguientes operaciones serán aceptadas/rechazadas,
-- según se considere para las relaciones AUSPICIO-EMPLEADO y AUSPICIO-PROYECTO match:
-- i) simple, ii) parcial, o iii) full:

    -- a. ERROR! MATCH FULL does not allow mixing of null and nonnull key values.
    -- (tipo_empleado, nro_empleado) MATCH FULL pide que ambos sean nulos o no nulos.
    insert into TP5_P1_EJ2_AUSPICIO values (1, 'Dell' , 'B', null);

    -- b. Inserta OK
    insert into TP5_P1_EJ2_AUSPICIO values (2, 'Oracle', null, null);

    -- c. ERROR! (tipo_empleado, nro_empleado)=(A, 3) no existe
    insert into TP5_P1_EJ2_AUSPICIO values (3, 'Google', 'A ', 3);

    -- d. ERROR! MATCH FULL
    insert into TP5_P1_EJ2_AUSPICIO values (1, 'HP', null, 3);
