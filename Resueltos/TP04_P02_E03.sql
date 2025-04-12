-- Table: distribuidor_nac
CREATE TABLE IF NOT EXISTS distribuidor_nac (
    id_distribuidor numeric(5,0) NOT NULL,
    nombre character varying(80) NOT NULL,
    direccion character varying(120) NOT NULL,
    telefono character varying(20),
    nro_inscripcion numeric(8,0) NOT NULL,
    encargado character varying(60) NOT NULL,
    id_distrib_mayorista numeric(5,0),
    CONSTRAINT pk_distribuidorNac PRIMARY KEY (id_distribuidor)
);

-- 3.1 Se solicita llenarla con la información correspondiente a los datos completos de
-- todos los distribuidores nacionales.
INSERT INTO distribuidor_nac(
                             id_distribuidor,
                             nombre,
                             direccion,
                             telefono,
                             nro_inscripcion,
                             encargado,
                             id_distrib_mayorista)
SELECT
    d.id_distribuidor,
    d.nombre,
    d.direccion,
    d.telefono,
    n.nro_inscripcion,
    n.encargado,
    n.id_distrib_mayorista
FROM unc_esq_peliculas.distribuidor d
JOIN unc_esq_peliculas.nacional n ON d.id_distribuidor = n.id_distribuidor
WHERE tipo = 'N';

-- 3.2 Agregar a la definición de la tabla distribuidor_nac, el campo "codigo_pais"
-- que indica el código de país del distribuidor mayorista que atiende a cada distribuidor nacional.
-- (codigo_pais varchar(5) NULL)
ALTER TABLE distribuidor_nac
ADD COLUMN codigo_pais varchar(5) NULL;

-- 3.3. Para todos los registros de la tabla distribuidor_nac, llenar el nuevo campo "codigo_pais"
-- con el valor correspondiente existente en la tabla "Internacional".
UPDATE distribuidor_nac dn
SET codigo_pais = i.codigo_pais
FROM unc_esq_peliculas.internacional i
WHERE dn.id_distribuidor = i.id_distribuidor;

-- 3.4. Eliminar de la tabla distribuidor_nac los registros que no
-- tienen asociado un distribuidor mayorista.
DELETE FROM distribuidor_nac
WHERE id_distrib_mayorista IS NULL;
