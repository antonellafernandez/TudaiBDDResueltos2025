-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-06-01 17:51:47.998

-- tables
-- Table: CATEGORIA
CREATE TABLE CATEGORIA (
    id_tipo_cat int  NOT NULL,
    id_categoria int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    descripcion text  NULL,
    CONSTRAINT Categorias_pk PRIMARY KEY (id_categoria,id_tipo_cat)
);

-- Table: CLIENTE
CREATE TABLE CLIENTE (
    id_cliente int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    apellido varchar(100)  NOT NULL,
    email varchar(100)  NOT NULL,
    telefono varchar(20)  NULL,
    CONSTRAINT Clientes_pk PRIMARY KEY (id_cliente)
);

-- Table: DETALLE_PEDIDO
CREATE TABLE DETALLE_PEDIDO (
    id_producto int  NOT NULL,
    id_pedido int  NOT NULL,
    cantidad int  NOT NULL,
    precio_unitario decimal(10,2)  NOT NULL,
    CONSTRAINT DetallePedido_pk PRIMARY KEY (id_producto,id_pedido)
);

-- Table: DIRECCION_ENTREGA
CREATE TABLE DIRECCION_ENTREGA (
    id_direccion int  NOT NULL,
    cliente_id int  NOT NULL,
    direccion varchar(255)  NULL,
    ciudad varchar(100)  NULL,
    cp varchar(10)  NULL,
    CONSTRAINT DireccionesEntrega_pk PRIMARY KEY (id_direccion)
);

-- Table: HISTORIAL_CAMBIO_ESTADO
CREATE TABLE HISTORIAL_CAMBIO_ESTADO (
    id_historial int  NOT NULL,
    pedido_id int  NOT NULL,
    fecha date  NOT NULL,
    estado_anterior varchar(50)  NOT NULL,
    estado_nuevo varchar(50)  NOT NULL,
    CONSTRAINT HistorialCambiosEstado_pk PRIMARY KEY (id_historial)
);

-- Table: PEDIDO
CREATE TABLE PEDIDO (
    id_pedido int  NOT NULL,
    fecha date  NOT NULL,
    estado varchar(50)  NOT NULL,
    id_direccion int  NOT NULL,
    CONSTRAINT Pedidos_pk PRIMARY KEY (id_pedido)
);

-- Table: PRODUCTO
CREATE TABLE PRODUCTO (
    id_producto int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    stock int  NOT NULL,
    id_proveedor int  NOT NULL,
    id_tipo_cat int  NULL,
    id_categoria int  NULL,
    CONSTRAINT Productos_pk PRIMARY KEY (id_producto)
);

-- Table: PROVEEDOR
CREATE TABLE PROVEEDOR (
    id_proveedor int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    email varchar(100)  NOT NULL,
    telefono varchar(20)  NOT NULL,
    CONSTRAINT Proveedores_pk PRIMARY KEY (id_proveedor)
);

-- Table: TIPO_CATEGORIA
CREATE TABLE TIPO_CATEGORIA (
    id_tipo_cat int  NOT NULL,
    nombre_tipo_cat varchar(120)  NOT NULL,
    CONSTRAINT TIPO_CATEGORIA_pk PRIMARY KEY (id_tipo_cat)
);

-- foreign keys
-- Reference: CATEGORIA_TIPO_CATEGORIA (table: CATEGORIA)
ALTER TABLE CATEGORIA ADD CONSTRAINT CATEGORIA_TIPO_CATEGORIA
    FOREIGN KEY (id_tipo_cat)
    REFERENCES TIPO_CATEGORIA (id_tipo_cat)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: DetallePedido_Pedidos (table: DETALLE_PEDIDO)
ALTER TABLE DETALLE_PEDIDO ADD CONSTRAINT DetallePedido_Pedidos
    FOREIGN KEY (id_pedido)
    REFERENCES PEDIDO (id_pedido)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: DetallePedido_Productos (table: DETALLE_PEDIDO)
ALTER TABLE DETALLE_PEDIDO ADD CONSTRAINT DetallePedido_Productos
    FOREIGN KEY (id_producto)
    REFERENCES PRODUCTO (id_producto)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_1 (table: PRODUCTO)
ALTER TABLE PRODUCTO ADD CONSTRAINT FK_1
    FOREIGN KEY (id_proveedor)
    REFERENCES PROVEEDOR (id_proveedor)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_5 (table: DIRECCION_ENTREGA)
ALTER TABLE DIRECCION_ENTREGA ADD CONSTRAINT FK_5
    FOREIGN KEY (cliente_id)
    REFERENCES CLIENTE (id_cliente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_6 (table: HISTORIAL_CAMBIO_ESTADO)
ALTER TABLE HISTORIAL_CAMBIO_ESTADO ADD CONSTRAINT FK_6
    FOREIGN KEY (pedido_id)
    REFERENCES PEDIDO (id_pedido)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: PEDIDO_DIRECCION_ENTREGA (table: PEDIDO)
ALTER TABLE PEDIDO ADD CONSTRAINT PEDIDO_DIRECCION_ENTREGA
    FOREIGN KEY (id_direccion)
    REFERENCES DIRECCION_ENTREGA (id_direccion)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: PRODUCTO_CATEGORIA (table: PRODUCTO)
ALTER TABLE PRODUCTO ADD CONSTRAINT PRODUCTO_CATEGORIA
    FOREIGN KEY (id_categoria, id_tipo_cat)
    REFERENCES CATEGORIA (id_categoria, id_tipo_cat)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

/* 1.a) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las
tablas/atributos necesarios.

- Verificar que cada pedido sólo incluya un producto sin categoría.

Seleccione la opción que considera correcta, de acuerdo a lo solicitado y justifique claramente porqué la
considera correcta (debajo de la pregunta 1.b ):

a. CREATE ASSERTION check_control_pedido
    CHECK ( NOT EXISTS
    ( SELECT 1
    FROM pedido pe JOIN detalle_pedido d using (id_pedido)
    JOIN producto p USING (id_producto)
    WHERE id_tipo_cat IS NOT NULL
    AND id_categoria IS NOT NULL
    GROUP BY d.id_pedido
    HAVING COUNT(*) > 1) );

b. Ninguna de las opciones es la correcta.

c. CREATE ASSERTION check_control_pedido
    CHECK ( EXISTS
    ( SELECT 1
    FROM pedido pe JOIN detalle_pedido d using (id_pedido)
    JOIN producto p USING (id_producto)
    WHERE id_tipo_cat IS NOT NULL
    AND id_categoria IS NOT NULL
    GROUP BY d.id_pedido
    HAVING COUNT(*) > 1) );

d. ALTER TABLE detalle_pedido ADD CONSTRAINT check_control_pedido
    CHECK (NOT EXISTS
    ( SELECT 1
    FROM detalle_pedido d JOIN producto p
    USING (id_producto)
    WHERE id_tipo_cat IS NULL
    AND id_categoria IS NULL
    GROUP BY d.id_pedido
    HAVING COUNT(*) > 1));

e. CREATE ASSERTION check_control_pedido
    CHECK ( NOT EXISTS
    ( SELECT 1
       FROM pedido pe JOIN detalle_pedido d using (id_pedido)
    JOIN producto p USING (id_producto)
    WHERE id_tipo_cat IS NULL
    AND id_categoria IS NULL
    GROUP BY d.id_pedido
    HAVING COUNT(*) > 1) );

f. CREATE ASSERTION check_control_pedido
    CHECK ( NOT EXISTS
    ( SELECT 1
    FROM detalle_pedido d JOIN producto p
    USING (id_producto)
    WHERE id_tipo_cat IS NULL
    AND id_categoria IS NULL
    GROUP BY d.id_pedido
    HAVING COUNT(*) > 1) );

La opción correcta es la f porque utiliza un ASSERTION que controla que no exista más de un registro
asociado a un pedido con más de un producto con id_tipo_cat NULL y id_categoria NULL.



1.b) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso
declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las
tablas/atributos necesarios.

La fecha en el historial de cambios debe ser posterior o igual a la del pedido.

Resuelva según lo solicitado y justifique el tipo de chequeo utilizado.

CREATE ASSERTION ch_e1b CHECK (
   NOT EXISTS (
   SELECT 1
   FROM PEDIDO p
   JOIN HISTORIAL_CAMBIO_ESTADO h ON p.id_pedido = h.pedido_id
   WHERE h.fecha < p.fecha));

Utilizo un ASSERTION porque la restricción involucra atributos de dos tablas diferentes
(PEDIDO e HISTORIAL_CAMBIO_ESTADO) y por lo tanto requiere un chequeo global.



2.a) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
actualizable en PostgreSQL, siempre que sea posible:

- V1: que contenga todos los datos de los pedidos cuyo monto total sea mayor a $100.000.

Considerando la siguiente definición para V1, seleccione la/s afirmación/es que considere correcta/s respecto
de esta vista (Nota: tenga en cuenta que las opciones incorrectamente seleccionadas pueden restar puntaje) y
justifíquela/s claramente (debajo de la pregunta 2.b).

    CREATE VIEW V1 AS
    SELECT *
    FROM pedido p
    WHERE EXISTS (SELECT 1
        FROM detalle_pedido d
        WHERE p.id_pedido = d.id_pedido
        GROUP BY id_pedido
        HAVING SUM (precio_unitario * cantidad) > 100000);

a. No está correctamente correlacionada la consulta con la subconsulta.

b. No es posible reformular la consulta para que cumpla con lo requerido (y sea automáticamente
actualizable).

c. Contiene todos los datos de los pedidos cuyo monto total sea mayor a $100.000.

d. Para cumplir lo requerido hay que reformular la consulta, sólo cambiando > por <=.

e. No resulta automáticamente actualizable en PostgreSQL.

f. Filtra correctamente los pedidos cuyo monto total es mayor a $100.000.

g. Es automáticamente actualizable en PostgreSQL.

h. Para cumplir lo requerido hay que reformular la consulta, el EXISTS por NOT EXISTS y el > (mayor) por <=
(menor igual).

i. Ninguna de las opciones.

j. Está correctamente correlacionada la consulta con la subconsulta.

Las respuestas correctas son la c y la f ya que la vista devuelve correctamente los pedidos cuyo monto total supera los $100.000,
la g porque el GROUP BY y la función de agregación SUM están dentro de la subconsulta sin afectar
el nivel superior, por lo que la vista sigue siendo automáticamente actualizable en PostgreSQL
y la j porquela subconsulta está adecuadamente correlacionada mediante la condición p.id_pedido = d.id_pedido.



2.b) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
actualizable en PostgreSQL, siempre que sea posible, y que se verifique que no haya migración de tuplas de la
vista. Resuelva según lo solicitado y justifique su solución.

- V2: Que liste todos los productos indicando el nombre, precio, stock, el nombre de su categoría y el nombre de
su tipo categoría. Debe incluir los productos sin categoría.

    CREATE OR REPLACE VIEW v2 AS
        SELECT
            p.id_producto,
            p.nombre,
            p.precio,
            p.stock,
            (SELECT c.nombre
             FROM CATEGORIA c
             WHERE c.id_tipo_cat = p.id_tipo_cat
             AND c.id_categoria = p.id_categoria) AS nombre_categoria
            (SELECT tc.nombre_tipo_cat
             FROM TIPO_CATEGORIA tc
             WHERE tc.id_tipo_cat = p.id_tipo_cat) AS nombre_tipo_categoria
        FROM PRODUCTO p;



3) Para el esquema dado, se ha creado la tabla productos_cliente donde se requiere registrar la siguiente
información para todos los clientes que están registrados en la base:

id_cliente, nombre, apellido, email, cantidad_productos, fecha_ultimo_pedido

Donde, para cada cliente:

- cantidad_productos corresponde a la cantidad de productos pedidos.
- fecha_ultimo_pedido es la fecha correspondiente al último pedido.

Nota: en caso que un cliente no registre pedidos, se deberá indicar apropiadamente.

a) Implemente el mét odo más adecuado en PostgreSQL que permita completar dicha tabla con la información
de todos los clientes a partir de los datos existentes en la base. Explique su solución e incluya la sentencia que
debería utilizar un usuario para la ejecución del mismo.

Nota: no puede utilizar sentencias de bucle (for, loop, etc.) para resolverlo.

CREATE OR REPLACE FUNCTION completar_productos_cliente() RETURNS void
   AS $$
   BEGIN
    INSERT INTO PRODUCTOS_CLIENTE (
        id_cliente,
        nombre,
        apellido,
        email,
        cantidad_productos,
        fecha_ultimo_pedido
    )
    SELECT
        c.id_cliente,
        c.nombre,
        c.apellido,
        c.email,
        COALESCE(SUM(d.cantidad), 0) AS cantidad_productos,
        MAX(p.fecha) AS fecha_ultimo_pedido
    FROM CLIENTE c
    LEFT JOIN DIRECCION_ENTREGA de
           ON de.cliente_id = c.id_cliente
    LEFT JOIN PEDIDO p
           ON p.id_direccion = de.id_direccion
    LEFT JOIN DETALLE_PEDIDO d
           ON d.id_pedido = p.id_pedido
    GROUP BY
        c.id_cliente,
        c.nombre,
        c.apellido,
        c.email;
   RETURN;
   END;
$$ LANGUAGE 'plpgsql';

Sentencia que ejecutaría el usuario: SELECT completar_productos_cliente();

3.b) Indique y justifique todos los eventos críticos necesarios para mantener los datos actualizados en la tabla
productos_cliente cuando se produzcan actualizaciones en la base. Incluya la declaración de los triggers
correspondientes en PostgreSQL y escriba la implementación de la/s función/es requerida/s para operaciones
de insert.

??



6) En el esquema dado se detectó un problema:
Algunos clientes logran registrar múltiples direcciones residenciales idénticas, generando redundancia
innecesaria en la tabla DIRECCION_ENTREGA.

Por otro lado, se quiere evitar que un cliente tenga más de una dirección registrada por ciudad, ya que esto
genera conflictos logísticos en los envíos.
La política que se desea imponer es:

- Un cliente no puede registrar más de una dirección en la misma ciudad, y no puede registrar direcciones
idénticas (mismo texto en dirección) más de una vez.

a) Agregar una restricción UNIQUE(cliente_id, direccion) en la tabla DIRECCION_ENTREGA.

b) Agregar una restricción UNIQUE(cliente_id, ciudad) en la tabla DIRECCION_ENTREGA.

c) Combinar las restricciones UNIQUE(usuario_id, direccion) y UNIQUE(usuario_id, ciudad) en la tabla, aunque
esto puede producir errores si se insertan direcciones distintas dentro de la misma ciudad.

d) Crear un trigger BEFORE INSERT OR UPDATE que consulte si ya existe una fila para el mismo cliente_id con la
misma ciudad o la misma dirección exacta, y si es así, rechace la operación.

e) Rediseñar la tabla DIRECCION_ENTREGA creando una entidad separada para CIUDAD, asociándola por clave
foránea y asegurando unicidad en una tabla intermedia.

f) Sólo se puede resolver a nivel de aplicación, ya que las bases de datos relacionales no permiten imponer
múltiples restricciones condicionales sobre columnas diferentes.

g) Ninguna opción es correcta.

La opción c es correcta porque combinar las restricciones UNIQUE (cliente_id, direccion) y (cliente_id, ciudad)
garantiza exactamente la política requerida: evita duplicar la misma dirección y evita registrar más de una dirección
en la misma ciudad para un cliente. La aclaración sobre posibles errores se refiere a que una inserción podría
violar una u otra restricción, pero eso es justamente el comportamiento deseado para hacer cumplir la política. */