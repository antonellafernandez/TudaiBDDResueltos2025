-- tables
-- Table: SATELITE
CREATE TABLE IF NOT EXISTS SATELITE (
    id_satelite int  NOT NULL,
    nombre varchar(40)  NOT NULL,
    tipo varchar(20)  NOT NULL,
    fecha_lanzamiento date  NOT NULL,
    agencia_operadora varchar(40)  NOT NULL,
    estado varchar(20)  NOT NULL,
    CONSTRAINT SATELITE_pk0 PRIMARY KEY (id_satelite),
    CONSTRAINT SATELITE_ak0 UNIQUE (nombre) NOT DEFERRABLE INITIALLY IMMEDIATE
);

-- Table: EQUIPO
CREATE TABLE IF NOT EXISTS EQUIPO (
    id_equipo int  NOT NULL,
    nombre varchar(20)  NOT NULL,
    tipo varchar(20)  NOT NULL,
    CONSTRAINT EQUIPO_pk0 PRIMARY KEY (id_equipo)
);

-- Table: INSTALADO
CREATE TABLE IF NOT EXISTS EQUIPO_INSTALADO (
    id_satelite int  NOT NULL,
    id_equipo int  NOT NULL,
    estado varchar(20)  NOT NULL,
    fecha_instalacion date  NOT NULL,
    CONSTRAINT EQUIPO_INSTALADO_pk0 PRIMARY KEY (id_satelite),
    CONSTRAINT EQUIPO_INSTALADO_pk1 PRIMARY KEY (id_equipo)
);

-- Table: MISION
CREATE TABLE IF NOT EXISTS MISION (
    id_mision int  NOT NULL,
    nombre_mision int  NOT NULL,
    fecha_inicio date  NOT NULL,
    fecha_fin date  NOT NULL,
    id_satelite int  NOT NULL,
    CONSTRAINT MISION_pk0 PRIMARY KEY (id_mision)
);

-- Table: OBJETIVO_MISION
CREATE TABLE IF NOT EXISTS OBJETIVO_MISION (
    id_mision int  NOT NULL,
    objetivo varchar(40)  NOT NULL,
    CONSTRAINT OBJETIVO_MISION_pk0 PRIMARY KEY (id_mision),
    CONSTRAINT OBJETIVO_MISION_pk1 PRIMARY KEY (objetivo)
);

-- Table: ANOMALIA
CREATE TABLE IF NOT EXISTS ANOMALIA (
    id_evento int  NOT NULL,
    fecha_evento date  NOT NULL,
    tipo_evento varchar(20)  NOT NULL,
    resuelto boolean  NOT NULL,
    descripcio varchar(40)  NOT NULL,
    id_satelite int  NOT NULL,
    id_equipo int  NOT NULL,
    CONSTRAINT ANOMALIA_pk0 PRIMARY KEY (id_evento)
);

-- Modificaciones
ALTER TABLE EQUIPO_INSTALADO ADD CONSTRAINT EQUIPO_INSTALADO_fk0
    FOREIGN KEY (id_satelite)
    REFERENCES SATELITE(id_satelite)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE;
ALTER TABLE EQUIPO_INSTALADO ADD CONSTRAINT EQUIPO_INSTALADO_fk1
    FOREIGN KEY (id_equipo)
    REFERENCES EQUIPO(id_equipo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE;

ALTER TABLE MISION ADD CONSTRAINT MISION_fk0
    FOREIGN KEY (id_satelite)
    REFERENCES SATELITE(id_satelite)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE;

ALTER TABLE OBJETIVO_MISION ADD CONSTRAINT OBJETIVO_MISION_fk0
    FOREIGN KEY (id_mision)
    REFERENCES MISION(id_mision)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE;

ALTER TABLE ANOMALIA ADD CONSTRAINT ANOMALIA_fk0
    FOREIGN KEY (id_satelite)
    REFERENCES EQUIPO_INSTALADO(id_satelite)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE;
ALTER TABLE ANOMALIA ADD CONSTRAINT ANOMALIA_fk1
    FOREIGN KEY (id_equipo)
    REFERENCES EQUIPO_INSTALADO(id_equipo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE;

-- End of file.
