CREATE TABLE IF NOT EXISTS "CATALOGO_LIBRO" (
	"cod_catalogo" bigint NOT NULL UNIQUE,
	"titulo" varchar(43) NOT NULL,
	"formato" varchar(43) NOT NULL,
	"editorial" varchar(43) NOT NULL,
	PRIMARY KEY ("cod_catalogo")
);

CREATE TABLE IF NOT EXISTS "AUTOR_CATALOGO_LIBRO" (
	"cod_catalogo" bigint NOT NULL,
	"autor" varchar(43) NOT NULL,
	PRIMARY KEY ("cod_catalogo", "autor")
);

CREATE TABLE IF NOT EXISTS "EJEMPLAR_LIB" (
	"cod_catalogo" bigint NOT NULL,
	"nro_ejemplar" bigint NOT NULL UNIQUE,
	"anio_edicion" bigint NOT NULL,
	"nro_edicion" bigint NOT NULL,
	PRIMARY KEY ("cod_catalogo", "nro_ejemplar")
);

CREATE TABLE IF NOT EXISTS "PRESTAMO" (
	"id_prestamo" bigint NOT NULL UNIQUE,
	"id_usuario" bigint NOT NULL,
	"fecha_desde" date NOT NULL,
	"fecha_hasta" date NOT NULL,
	PRIMARY KEY ("id_prestamo")
);

CREATE TABLE IF NOT EXISTS "LO_INTEGRAN" (
	"id_prestamo" bigint NOT NULL UNIQUE,
	"nro_ejemplar" bigint NOT NULL UNIQUE,
	PRIMARY KEY ("id_prestamo", "nro_ejemplar")
);

CREATE TABLE IF NOT EXISTS "USUARIO" (
	"id_usuario" bigint NOT NULL UNIQUE,
	"tipo_doc" varchar(3) NOT NULL,
	"nro_doc" bigint NOT NULL,
	"apellido" varchar(43) NOT NULL,
	"nombre" varchar(43) NOT NULL,
	"e_mal" varchar(43) NOT NULL,
	"tipo_usu" bigint NOT NULL,
	PRIMARY KEY ("id_usuario")
);

CREATE TABLE IF NOT EXISTS "SIN_CARNET" (
	"id_usuario" bigint NOT NULL UNIQUE,
	"nro_celular" bigint NOT NULL,
	PRIMARY KEY ("id_usuario")
);

CREATE TABLE IF NOT EXISTS "CON_CARNET" (
	"id_usuario" bigint NOT NULL UNIQUE,
	"nro_carnet" bigint NOT NULL,
	PRIMARY KEY ("id_usuario")
);


ALTER TABLE "AUTOR_CATALOGO_LIBRO" ADD CONSTRAINT "AUTOR_CATALOGO_LIBRO_fk0" FOREIGN KEY ("cod_catalogo") REFERENCES "CATALOGO_LIBRO"("cod_catalogo");

ALTER TABLE "EJEMPLAR_LIB" ADD CONSTRAINT "EJEMPLAR_LIB_fk0" FOREIGN KEY ("cod_catalogo") REFERENCES "CATALOGO_LIBRO"("cod_catalogo");

ALTER TABLE "PRESTAMO" ADD CONSTRAINT "PRESTAMO_fk1" FOREIGN KEY ("id_usuario") REFERENCES "CON_CARNET"("id_usuario");

ALTER TABLE "LO_INTEGRAN" ADD CONSTRAINT "LO_INTEGRAN_fk0" FOREIGN KEY ("id_prestamo") REFERENCES "PRESTAMO"("id_prestamo");
ALTER TABLE "LO_INTEGRAN" ADD CONSTRAINT "LO_INTEGRAN_fk1" FOREIGN KEY ("nro_ejemplar") REFERENCES "EJEMPLAR_LIB"("nro_ejemplar");

ALTER TABLE "SIN_CARNET" ADD CONSTRAINT "SIN_CARNET_fk0" FOREIGN KEY ("id_usuario") REFERENCES "USUARIO"("id_usuario");

ALTER TABLE "CON_CARNET" ADD CONSTRAINT "CON_CARNET_fk0" FOREIGN KEY ("id_usuario") REFERENCES "USUARIO"("id_usuario");
