-- Creates
CREATE TABLE IF NOT EXISTS REPOSITORIO (
	id_repositorio int NOT NULL,
	nombre varchar(40) NOT NULL,
	publico boolean NOT NULL,
	descripcion varchar(40) NOT NULL,
	duenio varchar(40),
	CONSTRAINT REPOSITORIO_pk0 PRIMARY KEY (id_repositorio)
);

CREATE TABLE IF NOT EXISTS COLECCION (
	id_coleccion int NOT NULL,
	titulo_coleccion varchar(40) NOT NULL,
	descripcion varchar(40) NOT NULL,
	CONSTRAINT COLECCION_pk0 PRIMARY KEY (id_coleccion)
);

CREATE TABLE IF NOT EXISTS OBJETO (
	id_objeto int NOT NULL,
	id_coleccion int NOT NULL,
	id_repositorio int NOT NULL,
	titulo varchar(40) NOT NULL,
	descripcion varchar(40) NOT NULL,
	fuente varchar(40) NOT NULL,
	fecha date NOT NULL,
	tipo int NOT NULL,
	CONSTRAINT OBJETO_pk0 PRIMARY KEY (id_objeto, id_coleccion)
);

CREATE TABLE IF NOT EXISTS AUDIO (
	id_objeto int NOT NULL,
	id_coleccion int NOT NULL,
	formato varchar(40) NOT NULL,
	duracion int NOT NULL,
	CONSTRAINT AUDIO_pk0 PRIMARY KEY (id_objeto, id_coleccion)
);

CREATE TABLE IF NOT EXISTS VIDEO (
	id_objeto int NOT NULL,
	id_coleccion int NOT NULL,
	resolucion varchar(40) NOT NULL,
	frames_x_segundo int NOT NULL,
	CONSTRAINT VIDEO_pk0 PRIMARY KEY (id_objeto, id_coleccion)
);

CREATE TABLE IF NOT EXISTS DOCUMENTO (
	id_objeto int NOT NULL,
	id_coleccion int NOT NULL,
	tipo_publicacion varchar(40) NOT NULL,
	modos_color varchar(40) NOT NULL,
	resolucion_captura varchar(40) NOT NULL,
	CONSTRAINT DOCUMENTO_pk0 PRIMARY KEY (id_objeto, id_coleccion)
);

-- FK
ALTER TABLE OBJETO ADD CONSTRAINT OBJETO_fk1
    FOREIGN KEY (id_coleccion) REFERENCES COLECCION(id_coleccion);
ALTER TABLE OBJETO ADD CONSTRAINT OBJETO_fk2
    FOREIGN KEY (id_repositorio) REFERENCES REPOSITORIO(id_repositorio);

ALTER TABLE AUDIO ADD CONSTRAINT AUDIO_fk0
    FOREIGN KEY (id_objeto) REFERENCES OBJETO(id_objeto);
ALTER TABLE AUDIO ADD CONSTRAINT AUDIO_fk1
    FOREIGN KEY (id_coleccion) REFERENCES COLECCION(id_coleccion);

ALTER TABLE VIDEO ADD CONSTRAINT VIDEO_fk0
    FOREIGN KEY (id_objeto) REFERENCES OBJETO(id_objeto);
ALTER TABLE VIDEO ADD CONSTRAINT VIDEO_fk1
    FOREIGN KEY (id_coleccion) REFERENCES COLECCION(id_coleccion);

ALTER TABLE DOCUMENTO ADD CONSTRAINT DOCUMENTO_fk0
    FOREIGN KEY (id_objeto) REFERENCES OBJETO(id_objeto);
ALTER TABLE DOCUMENTO ADD CONSTRAINT DOCUMENTO_fk1
    FOREIGN KEY (id_coleccion) REFERENCES COLECCION(id_coleccion);

-- Inserts para REPOSITORIO
INSERT INTO REPOSITORIO (id_repositorio, nombre, publico, descripcion, duenio) VALUES
(1, 'Repo1', true, 'Descripcion1', 'Duenio1'),
(2, 'Repo2', false, 'Descripcion2', 'Duenio2'),
(3, 'Repo3', true, 'Descripcion3', 'Duenio3'),
(4, 'Repo4', false, 'Descripcion4', 'Duenio4'),
(5, 'Repo5', true, 'Descripcion5', 'Duenio5'),
(6, 'Repo6', false, 'Descripcion6', 'Duenio6'),
(7, 'Repo7', true, 'Descripcion7', 'Duenio7'),
(8, 'Repo8', false, 'Descripcion8', 'Duenio8'),
(9, 'Repo9', true, 'Descripcion9', 'Duenio9'),
(10, 'Repo10', false, 'Descripcion10', 'Duenio10');

-- Inserts para COLECCION
INSERT INTO COLECCION (id_coleccion, titulo_coleccion, descripcion) VALUES
(1, 'Coleccion1', 'Descripcion1'),
(2, 'Coleccion2', 'Descripcion2'),
(3, 'Coleccion3', 'Descripcion3'),
(4, 'Coleccion4', 'Descripcion4'),
(5, 'Coleccion5', 'Descripcion5'),
(6, 'Coleccion6', 'Descripcion6'),
(7, 'Coleccion7', 'Descripcion7'),
(8, 'Coleccion8', 'Descripcion8'),
(9, 'Coleccion9', 'Descripcion9'),
(10, 'Coleccion10', 'Descripcion10');

-- Inserts para OBJETO
INSERT INTO OBJETO (id_objeto, id_coleccion, id_repositorio, titulo, descripcion, fuente, fecha, tipo) VALUES
(1, 1, 1, 'Objeto1', 'Desc1', 'Fuente1', '2024-01-01', 1),
(2, 2, 2, 'Objeto2', 'Desc2', 'Fuente2', '2024-01-02', 2),
(3, 3, 3, 'Objeto3', 'Desc3', 'Fuente3', '2024-01-03', 3),
(4, 4, 4, 'Objeto4', 'Desc4', 'Fuente4', '2024-01-04', 4),
(5, 5, 5, 'Objeto5', 'Desc5', 'Fuente5', '2024-01-05', 5),
(6, 6, 6, 'Objeto6', 'Desc6', 'Fuente6', '2024-01-06', 6),
(7, 7, 7, 'Objeto7', 'Desc7', 'Fuente7', '2024-01-07', 7),
(8, 8, 8, 'Objeto8', 'Desc8', 'Fuente8', '2024-01-08', 8),
(9, 9, 9, 'Objeto9', 'Desc9', 'Fuente9', '2024-01-09', 9),
(10, 10, 10, 'Objeto10', 'Desc10', 'Fuente10', '2024-01-10', 10);

-- Inserts para AUDIO
INSERT INTO AUDIO (id_objeto, id_coleccion, formato, duracion) VALUES
(1, 1, 'MP3', 120),
(2, 2, 'WAV', 150),
(3, 3, 'FLAC', 200),
(4, 4, 'AAC', 180),
(5, 5, 'OGG', 210),
(6, 6, 'MP3', 170),
(7, 7, 'WAV', 190),
(8, 8, 'FLAC', 220),
(9, 9, 'AAC', 160),
(10, 10, 'OGG', 230);

-- Inserts para VIDEO
INSERT INTO VIDEO (id_objeto, id_coleccion, resolucion, frames_x_segundo) VALUES
(1, 1, '1920x1080', 30),
(2, 2, '1280x720', 24),
(3, 3, '3840x2160', 60),
(4, 4, '1920x1080', 30),
(5, 5, '1280x720', 24),
(6, 6, '1920x1080', 30),
(7, 7, '1280x720', 24),
(8, 8, '3840x2160', 60),
(9, 9, '1920x1080', 30),
(10, 10, '1280x720', 24);

-- Inserts para DOCUMENTO
INSERT INTO DOCUMENTO (id_objeto, id_coleccion, tipo_publicacion, modos_color, resolucion_captura) VALUES
(1, 1, 'Revista', 'Color', '300dpi'),
(2, 2, 'Libro', 'Escala de grises', '600dpi'),
(3, 3, 'Artículo', 'Color', '300dpi'),
(4, 4, 'Revista', 'Color', '300dpi'),
(5, 5, 'Libro', 'Escala de grises', '600dpi'),
(6, 6, 'Artículo', 'Color', '300dpi'),
(7, 7, 'Revista', 'Color', '300dpi'),
(8, 8, 'Libro', 'Escala de grises', '600dpi'),
(9, 9, 'Artículo', 'Color', '300dpi'),
(10, 10, 'Revista', 'Color', '300dpi');

-- Selects
SELECT * FROM REPOSITORIO;
SELECT * FROM COLECCION;
SELECT * FROM OBJETO;
SELECT * FROM AUDIO;
SELECT * FROM VIDEO;
SELECT * FROM DOCUMENTO;
