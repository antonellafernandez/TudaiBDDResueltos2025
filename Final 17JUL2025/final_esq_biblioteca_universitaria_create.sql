-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-07-16 00:13:23.922

-- tables
-- Table: AUTOR
CREATE TABLE AUTOR (
    id_autor int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    pais varchar(100)  NOT NULL,
    CONSTRAINT Autores_pk PRIMARY KEY (id_autor)
);

-- Table: CATEGORIA_LIBRO
CREATE TABLE CATEGORIA_LIBRO (
    id_tipo_cat int  NOT NULL,
    id_categoria int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    descripcion text  NULL,
    CONSTRAINT CategoriasLibros_pk PRIMARY KEY (id_categoria,id_tipo_cat)
);

-- Table: DETALLE_PRESTAMO
CREATE TABLE DETALLE_PRESTAMO (
    id_prestamo int  NOT NULL,
    id_libro int  NOT NULL,
    fecha_devolucion int  NULL,
    estado_ejemplar varchar(10)  NULL,
    CONSTRAINT DETALLE_PRESTAMO_pk PRIMARY KEY (id_prestamo,id_libro)
);

-- Table: DIRECCION_USUARIO
CREATE TABLE DIRECCION_USUARIO (
    id_direccion int  NOT NULL,
    usuario_id int  NOT NULL,
    direccion varchar(255)  NOT NULL,
    ciudad varchar(100)  NULL,
    CONSTRAINT DireccionesUsuario_pk PRIMARY KEY (id_direccion)
);

-- Table: HISTORIAL_PRESTAMO
CREATE TABLE HISTORIAL_PRESTAMO (
    id_historial int  NOT NULL,
    prestamo_id int  NOT NULL,
    fecha date  NOT NULL,
    evento varchar(100)  NULL,
    CONSTRAINT HistorialPrestamos_pk PRIMARY KEY (id_historial)
);

-- Table: LIBRO
CREATE TABLE LIBRO (
    id_libro int  NOT NULL,
    id_tipo_cat int  NULL,
    id_categoria int  NULL,
    titulo varchar(100)  NOT NULL,
    autor_id int  NOT NULL,
    ejemplar_unico boolean  NOT NULL,
    CONSTRAINT Libros_pk PRIMARY KEY (id_libro)
);

-- Table: PRESTAMO
CREATE TABLE PRESTAMO (
    id_prestamo int  NOT NULL,
    usuario_id int  NOT NULL,
    fecha_prestamo date  NOT NULL,
    estado varchar(50)  NULL,
    CONSTRAINT Prestamos_pk PRIMARY KEY (id_prestamo)
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
    email varchar(100)  NULL,
    telefono varchar(20)  NULL,
    CONSTRAINT Usuarios_pk PRIMARY KEY (id_usuario)
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

-- Reference: FK_1 (table: LIBRO)
ALTER TABLE LIBRO ADD CONSTRAINT FK_1
    FOREIGN KEY (autor_id)
    REFERENCES AUTOR (id_autor)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_2 (table: PRESTAMO)
ALTER TABLE PRESTAMO ADD CONSTRAINT FK_2
    FOREIGN KEY (usuario_id)
    REFERENCES USUARIO (id_usuario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_5 (table: DIRECCION_USUARIO)
ALTER TABLE DIRECCION_USUARIO ADD CONSTRAINT FK_5
    FOREIGN KEY (usuario_id)
    REFERENCES USUARIO (id_usuario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_6 (table: HISTORIAL_PRESTAMO)
ALTER TABLE HISTORIAL_PRESTAMO ADD CONSTRAINT FK_6
    FOREIGN KEY (prestamo_id)
    REFERENCES PRESTAMO (id_prestamo)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: LIBRO_CATEGORIA_LIBRO (table: LIBRO)
ALTER TABLE LIBRO ADD CONSTRAINT LIBRO_CATEGORIA_LIBRO
    FOREIGN KEY (id_categoria, id_tipo_cat)
    REFERENCES CATEGORIA_LIBRO (id_categoria, id_tipo_cat)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

