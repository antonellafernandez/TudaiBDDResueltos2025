-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-28 23:11:03.915

-- tables
-- Table: P5P2E5_CLIENTE
CREATE TABLE P5P2E5_CLIENTE (
    id_cliente int  NOT NULL,
    apellido varchar(80)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    estado char(5)  NOT NULL,
    CONSTRAINT PK_P5P2E5_CLIENTE PRIMARY KEY (id_cliente)
);

-- Table: P5P2E5_FECHA_LIQ
CREATE TABLE P5P2E5_FECHA_LIQ (
    dia_liq int  NOT NULL,
    mes_liq int  NOT NULL,
    cant_dias int  NOT NULL,
    CONSTRAINT PK_P5P2E5_FECHA_LIQ PRIMARY KEY (dia_liq,mes_liq)
);

-- Table: P5P2E5_PRENDA
CREATE TABLE P5P2E5_PRENDA (
    id_prenda int  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    descripcion varchar(120)  NOT NULL,
    tipo varchar(40)  NOT NULL,
    categoria varchar(80)  NOT NULL,
    CONSTRAINT PK_P5P2E5_PRENDA PRIMARY KEY (id_prenda)
);

-- Table: P5P2E5_VENTA
CREATE TABLE P5P2E5_VENTA (
    id_venta int  NOT NULL,
    descuento decimal(10,2)  NOT NULL,
    fecha timestamp  NOT NULL,
    id_prenda int  NOT NULL,
    id_cliente int  NOT NULL,
    CONSTRAINT PK_P5P2E5_VENTA PRIMARY KEY (id_venta)
);

-- foreign keys
-- Reference: FK_P5P2E5_VENTA_CLIENTE (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_CLIENTE
    FOREIGN KEY (id_cliente)
    REFERENCES P5P2E5_CLIENTE (id_cliente)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E5_VENTA_PRENDA (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_PRENDA
    FOREIGN KEY (id_prenda)
    REFERENCES P5P2E5_PRENDA (id_prenda)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

-- Ejercicio 5
-- A. Los descuentos en las ventas son porcentajes y deben estar entre 0 y 100.
-- CHECK atributo
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT ck_descuentos
CHECK (descuento >= 0 AND descuento <= 100);

-- B. Los descuentos realizados en fechas de liquidación deben superar el 30%.
-- CHECK global
CREATE ASSERTION desc_liq_mayor_30
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM P5P2E5_VENTA v
        JOIN P5P2E5_FECHA_LIQ f ON EXTRACT(DAY FROM v.fecha) = f.dia_liq
        AND EXTRACT(MONTH FROM v.fecha) = f.mes_liq
        WHERE v.descuento <= 30
    )
);

-- C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
-- CHECK tabla
ALTER TABLE P5P2E5_FECHA_LIQ ADD CONSTRAINT ck_liq_jul_dic_menor_5
CHECK (
    (mes_liq = 7 OR mes_liq = 12)
    AND cant_dias < 5
);

-- D. Las prendas de categoría ‘oferta’ no tienen descuentos.
-- CHECK global
CREATE ASSERTION oferta_sin_descuento
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM P5P2E5_VENTA v
        JOIN P5P2E5_PRENDA p ON v.id_prenda = p.id_prenda
        WHERE p.categoria = 'oferta' AND v.descuento > 0
    )
);
