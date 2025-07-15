-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-07-15 22:31:02.877

-- tables
-- Table: AUTOR
CREATE TABLE AUTOR (
    id_autor int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    pais varchar(100)  NOT NULL,
    CONSTRAINT AUTOR_pk PRIMARY KEY (id_autor)
);

-- Table: CATEGORIA_LIBRO
CREATE TABLE CATEGORIA_LIBRO (
    id_tipo_cat int  NOT NULL,
    id_categoria int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    descripcion text  NULL,
    CONSTRAINT CATEGORIA_LIBRO_pk PRIMARY KEY (id_tipo_cat,id_categoria)
);

-- Table: DETALLE_PRESTAMO
CREATE TABLE DETALLE_PRESTAMO (
    id_prestamo int  NOT NULL,
    id_libro int  NOT NULL,
    fecha_devolucion date  NULL,
    estado_ejemplar varchar(10)  NULL,
    CONSTRAINT DETALLE_PRESTAMO_pk PRIMARY KEY (id_prestamo,id_libro)
);

-- Table: DIRECCION_USUARIO
CREATE TABLE DIRECCION_USUARIO (
    id_direccion int  NOT NULL,
    id_usuario int  NOT NULL,
    direccion varchar(255)  NOT NULL,
    ciudad varchar(100)  NULL,
    CONSTRAINT DIRECCION_USUARIO_pk PRIMARY KEY (id_direccion)
);

-- Table: HISTORIAL_PRESTAMO
CREATE TABLE HISTORIAL_PRESTAMO (
    id_historial int  NOT NULL,
    id_prestamo int  NOT NULL,
    fecha date  NOT NULL,
    evento varchar(100)  NULL,
    CONSTRAINT HISTORIAL_PRESTAMO_pk PRIMARY KEY (id_historial)
);

-- Table: LIBRO
CREATE TABLE LIBRO (
    id_libro int  NOT NULL,
    id_tipo_cat int  NULL,
    id_categoria int  NULL,
    titulo varchar(100)  NOT NULL,
    id_autor int  NOT NULL,
    CONSTRAINT LIBRO_pk PRIMARY KEY (id_libro)
);

-- Table: PRESTAMO
CREATE TABLE PRESTAMO (
    id_prestamo int  NOT NULL,
    id_usuario int  NOT NULL,
    fecha_prestamo date  NOT NULL,
    estado varchar(50)  NULL,
    CONSTRAINT PRESTAMO_pk PRIMARY KEY (id_prestamo)
);

-- Table: TIPO_CATEGORIA
CREATE TABLE TIPO_CATEGORIA (
    id_tipo_cat int  NOT NULL,
    nombre_tipo_cat varchar(120)  NOT NULL,
    CONSTRAINT TIPO_CATEGORIA_pk PRIMARY KEY (id_tipo_cat)
);

-- Table: USUARIO
CREATE TABLE USUARIO (
    id_usuario int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    apellido varchar(100)  NOT NULL,
    email varchar(100)  NOT NULL,
    telefono varchar(20)  NULL,
    CONSTRAINT USUARIO_pk PRIMARY KEY (id_usuario)
);

-- foreign keys
-- Reference: CATEGORIA_LIBRO_TIPO_CATEGORIA (table: CATEGORIA_LIBRO)
ALTER TABLE CATEGORIA_LIBRO ADD CONSTRAINT CATEGORIA_LIBRO_TIPO_CATEGORIA
    FOREIGN KEY (id_tipo_cat)
    REFERENCES TIPO_CATEGORIA (id_tipo_cat)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: DETALLE_PRESTAMO_LIBRO (table: DETALLE_PRESTAMO)
ALTER TABLE DETALLE_PRESTAMO ADD CONSTRAINT DETALLE_PRESTAMO_LIBRO
    FOREIGN KEY (id_libro)
    REFERENCES LIBRO (id_libro)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: DETALLE_PRESTAMO_PRESTAMO (table: DETALLE_PRESTAMO)
ALTER TABLE DETALLE_PRESTAMO ADD CONSTRAINT DETALLE_PRESTAMO_PRESTAMO
    FOREIGN KEY (id_prestamo)
    REFERENCES PRESTAMO (id_prestamo)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: DIRECCION_USUARIO_USUARIO (table: DIRECCION_USUARIO)
ALTER TABLE DIRECCION_USUARIO ADD CONSTRAINT DIRECCION_USUARIO_USUARIO
    FOREIGN KEY (id_usuario)
    REFERENCES USUARIO (id_usuario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: HISTORIAL_PRESTAMO_PRESTAMO (table: HISTORIAL_PRESTAMO)
ALTER TABLE HISTORIAL_PRESTAMO ADD CONSTRAINT HISTORIAL_PRESTAMO_PRESTAMO
    FOREIGN KEY (id_prestamo)
    REFERENCES PRESTAMO (id_prestamo)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: LIBRO_AUTOR (table: LIBRO)
ALTER TABLE LIBRO ADD CONSTRAINT LIBRO_AUTOR
    FOREIGN KEY (id_autor)
    REFERENCES AUTOR (id_autor)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: LIBRO_CATEGORIA_LIBRO (table: LIBRO)
ALTER TABLE LIBRO ADD CONSTRAINT LIBRO_CATEGORIA_LIBRO
    FOREIGN KEY (id_tipo_cat, id_categoria)
    REFERENCES CATEGORIA_LIBRO (id_tipo_cat, id_categoria)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PRESTAMO_USUARIO (table: PRESTAMO)
ALTER TABLE PRESTAMO ADD CONSTRAINT PRESTAMO_USUARIO
    FOREIGN KEY (id_usuario)
    REFERENCES USUARIO (id_usuario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

/* 4- Plantee la consulta SQL para obtener un listado con todos los libros indicando el id y el título del libro, la cantidad de
veces que fue prestado, la cantidad de veces que fue devuelto y la cantidad de préstamos activos que posee (estado del
préstamo = 'activo'). Debe mostrar todos los libros, aunque nunca hayan sido prestados.
Ayuda: para contar los préstamosa activos puede usar (CASE WHEN estado = 'activo' THEN 1 ELSE null END). */

SELECT l.id_libro,
       l.titulo,
       COUNT(dp.id_libro) AS cantidad_prestados,
       SUM(CASE WHEN dp.fecha_devolucion IS NOT NULL THEN 1 ELSE 0 END) AS cantidad_devueltos,
       SUM(CASE WHEN p.estado = 'activo' THEN 1 ELSE 0 END) AS prestamos_activos
FROM LIBRO l
LEFT JOIN DETALLE_PRESTAMO dp ON l.id_libro = dp.id_libro
LEFT JOIN PRESTAMO p ON dp.id_prestamo = p.id_prestamo
GROUP BY l.id_libro, l.titulo;

/* 5- Utilizando funciones de ventana, plantee la consulta SQL para obtener un informe de libros que incluya el identificador
y título del libro, el nombre de la categoría y el nombre del tipo de categoría y además la cantidad total de libros
existentes dentro de ambos tipos de categoría y categoría. El informe debe estar ordenado en forma descendente según
dicha cantidad total. */

SELECT l.id_libro,
       l.titulo,
       cl.nombre,
       tc.nombre_tipo_cat,
       COUNT(*) OVER (PARTITION BY l.id_tipo_cat, l.id_categoria) AS cantidad_total_libros
FROM LIBRO l
JOIN CATEGORIA_LIBRO cl ON (l.id_tipo_cat = cl.id_tipo_cat AND l.id_categoria = cl.id_categoria)
JOIN TIPO_CATEGORIA tc ON cl.id_tipo_cat = tc.id_tipo_cat
ORDER BY cantidad_total_libros DESC;

/* -6 Para el esquema de la figura plantee el recurso declarativo más adecuado que controle que cada préstamo tenga
un único evento "devolucion". */

-- RI TUPLA, involucra valores de una sola fila en la tabla HISTORIAL_PRESTAMO
ALTER TABLE HISTORIAL_PRESTAMO ADD CONSTRAINT CK_P6
CHECK (
    NOT EXISTS (
        SELECT id_prestamo
        FROM HISTORIAL_PRESTAMO
        WHERE evento = 'devolucion'
        GROUP BY id_prestamo
        HAVING COUNT(*) > 1
));

/* 7- Dada la siguiente restricción general "Un libro no puede tener más de 10 préstamos por mes y cada usuario de estos
préstamos tiene que tener al menos una dirección":
a) Plantee el assertion correspondiente optimizado.
b) Complete la tabla con los eventos a controlar por cada tabla interviniente.
c) De los triggers y funciones sólo para el caso de INSERT.

-- a)
CREATE OR REPLACE ASSERTION CK_P7
CHECK (
    NOT EXISTS (
        SELECT dp.id_libro,
            EXTRACT(YEAR FROM p.fecha_prestamo) AS anio,
            EXTRACT(MONTH FROM p.fecha_prestamo) AS mes
        FROM DETALLE_PRESTAMO dp
        JOIN PRESTAMO p ON dp.id_prestamo = p.id_prestamo
        JOIN USUARIO u ON p.id_usuario = u.id_usuario
        LEFT JOIN DIRECCION_USUARIO du ON p.id_usuario = du.id_usuario
        GROUP BY dp.id_libro, anio, mes
        HAVING COUNT(*) > 10
        OR SUM(CASE WHEN du.id_direccion IS NULL THEN 1 ELSE 0 END) > 0
));

-- b)                   INSERT          UPDATE                  DELETE
DETALLE_PRESTAMO        SI              SI id_libro             NO
PRESTAMO                SI              SI id_prestamo, fecha   NO
USUARIO                 NO              SI id_ususario          NO
DIRECCION_USUARIO       NO              SI id_usuario           SI */

-- c)
-- Vista
CREATE OR REPLACE VIEW v_p7 AS
SELECT dp.id_libro,
            EXTRACT(YEAR FROM p.fecha_prestamo) AS anio,
            EXTRACT(MONTH FROM p.fecha_prestamo) AS mes
        FROM DETALLE_PRESTAMO dp
        JOIN PRESTAMO p ON dp.id_prestamo = p.id_prestamo
        JOIN USUARIO u ON p.id_usuario = u.id_usuario
        LEFT JOIN DIRECCION_USUARIO du ON p.id_usuario = du.id_usuario
        GROUP BY dp.id_libro, anio, mes
        HAVING COUNT(*) > 10
        OR SUM(CASE WHEN du.id_direccion IS NULL THEN 1 ELSE 0 END) > 0;

-- Función
CREATE OR REPLACE FUNCTION fn_p7() RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM v_p7) THEN RAISE EXCEPTION 'Error';
    END IF;
    RETURN NEW;
END; $$ LANGUAGE 'plpgsql';

-- Trigger
CREATE OR REPLACE TRIGGER tr_detalle_prestamo
BEFORE INSERT ON DETALLE_PRESTAMO
FOR EACH ROW EXECUTE FUNCTION fn_p7();

CREATE OR REPLACE TRIGGER tr_prestamo
BEFORE INSERT ON PRESTAMO
FOR EACH ROW EXECUTE FUNCTION fn_p7();
