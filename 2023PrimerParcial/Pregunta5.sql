-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-28 00:42:39.743

-- tables
-- Table: CATEGORIA
CREATE TABLE CATEGORIA (
    tipo_categoria char(3)  NOT NULL,
    cod_categoria int  NOT NULL,
    descripcion varchar(40)  NOT NULL,
    CONSTRAINT PK_CATEGORIA PRIMARY KEY (tipo_categoria,cod_categoria)
);

-- Table: PRODUCTO
CREATE TABLE PRODUCTO (
    tipo_categoria char(3)  NOT NULL,
    cod_categoria int  NOT NULL,
    nro_producto int  NOT NULL,
    descripcion varchar(30)  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    CONSTRAINT PK_PRODUCTO PRIMARY KEY (nro_producto,tipo_categoria,cod_categoria)
);

-- Table: PRODUCTOS_X_SUCURSAL
CREATE TABLE PRODUCTOS_X_SUCURSAL (
    tipo_categoria char(3)  NOT NULL,
    cod_categoria int  NOT NULL,
    nro_producto int  NOT NULL,
    cod_sucursal int  NOT NULL,
    CONSTRAINT PK_PRODUCTOS_X_SUCURSAL PRIMARY KEY (nro_producto,tipo_categoria,cod_categoria,cod_sucursal)
);

-- Table: SUCURSAL
CREATE TABLE SUCURSAL (
    cod_sucursal int  NOT NULL,
    nombre varchar(60)  NOT NULL,
    calle varchar(60)  NOT NULL,
    numero int  NOT NULL,
    sucursal_rural boolean  NOT NULL,
    CONSTRAINT PK_SUCURSAL PRIMARY KEY (cod_sucursal)
);

-- foreign keys
-- Reference: FK_PRODUCTOS_X_SUCURSAL_PRODUCTO (table: PRODUCTOS_X_SUCURSAL)
ALTER TABLE PRODUCTOS_X_SUCURSAL ADD CONSTRAINT FK_PRODUCTOS_X_SUCURSAL_PRODUCTO
    FOREIGN KEY (nro_producto, tipo_categoria, cod_categoria)
    REFERENCES PRODUCTO (nro_producto, tipo_categoria, cod_categoria)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_PRODUCTOS_X_SUCURSAL_SUCURSAL (table: PRODUCTOS_X_SUCURSAL)
ALTER TABLE PRODUCTOS_X_SUCURSAL ADD CONSTRAINT FK_PRODUCTOS_X_SUCURSAL_SUCURSAL
    FOREIGN KEY (cod_sucursal)
    REFERENCES SUCURSAL (cod_sucursal)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_PRODUCTO_CATEGORIA (table: PRODUCTO)
ALTER TABLE PRODUCTO ADD CONSTRAINT FK_PRODUCTO_CATEGORIA
    FOREIGN KEY (tipo_categoria, cod_categoria)
    REFERENCES CATEGORIA (tipo_categoria, cod_categoria)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

-- Pregunta 5
/*
CREATE ASSERTION ck_medico_sala
CHECK ( NOT EXISTS (
SELECT 1
FROM productos_x_sucursal p JOIN sucursal s on (p.cod_sucursal = s.cod_sucursal)
WHERE c.sucursal_rural = TRUE
GROUP BY tipo_categoria, cod_categoria, s.cod_sucursal
HAVING count(*) > 50)); */
