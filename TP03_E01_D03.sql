CREATE TABLE IF NOT EXISTS "CLIENTE" (
	"id_cliente" bigint NOT NULL UNIQUE,
	"garante" bigint,
	"CUIT" bigint NOT NULL,
	"apellido" varchar(43) NOT NULL,
	"nombre" varchar(43) NOT NULL,
	"calle" varchar(43) NOT NULL,
	"puerta" bigint NOT NULL,
	"piso" bigint NOT NULL,
	"e_mail" varchar(43),
	"telefono" bigint NOT NULL,
	PRIMARY KEY ("id_cliente")
);

CREATE TABLE IF NOT EXISTS "ENVIO" (
	"nro_envio" bigint NOT NULL UNIQUE,
	"id_cliente" bigint NOT NULL,
	"id_prod_quim" bigint NOT NULL,
	"cantidad" bigint NOT NULL,
	"peso" bigint NOT NULL,
	PRIMARY KEY ("nro_envio")
);

CREATE TABLE IF NOT EXISTS "PRODUCTO_QUIMICO" (
	"id_prod_quim" bigint NOT NULL UNIQUE,
	"nombre_prod_quim" varchar(43) NOT NULL,
	"formula" varchar(43) NOT NULL,
	"tipo_pq" bigint NOT NULL,
	PRIMARY KEY ("id_prod_quim")
);

CREATE TABLE IF NOT EXISTS "COMPUESTO_QUIMICO" (
	"id_prod_quim" bigint NOT NULL UNIQUE,
	"id_comp_quim" bigint NOT NULL UNIQUE,
	"porcentaje" bigint NOT NULL,
	PRIMARY KEY ("id_prod_quim", "id_comp_quim")
);

CREATE TABLE IF NOT EXISTS "PQ_LIQUIDO" (
	"id_prod_quim" bigint NOT NULL UNIQUE,
	"inflamable" boolean NOT NULL,
	"tipo_envase" varchar(43) NOT NULL,
	"cond_traslado" varchar(43),
	PRIMARY KEY ("id_prod_quim")
);

CREATE TABLE IF NOT EXISTS "1742783189" (

);

CREATE TABLE IF NOT EXISTS "PQ_SOLIDO" (
	"id_prod_quim" bigint NOT NULL UNIQUE,
	"forma" varchar(43) NOT NULL,
	"empaque_max" varchar(43) NOT NULL,
	PRIMARY KEY ("id_prod_quim")
);

ALTER TABLE "CLIENTE" ADD CONSTRAINT "CLIENTE_fk1" FOREIGN KEY ("garante") REFERENCES "CLIENTE"("id_cliente");

ALTER TABLE "ENVIO" ADD CONSTRAINT "ENVIO_fk1" FOREIGN KEY ("id_cliente") REFERENCES "CLIENTE"("id_cliente");
ALTER TABLE "ENVIO" ADD CONSTRAINT "ENVIO_fk2" FOREIGN KEY ("id_prod_quim") REFERENCES "PRODUCTO_QUIMICO"("id_prod_quim");

ALTER TABLE "COMPUESTO_QUIMICO" ADD CONSTRAINT "COMPUESTO_QUIMICO_fk0" FOREIGN KEY ("id_prod_quim") REFERENCES "PRODUCTO_QUIMICO"("id_prod_quim");
ALTER TABLE "COMPUESTO_QUIMICO" ADD CONSTRAINT "COMPUESTO_QUIMICO_fk1" FOREIGN KEY ("id_comp_quim") REFERENCES "PRODUCTO_QUIMICO"("id_prod_quim");

ALTER TABLE "PQ_LIQUIDO" ADD CONSTRAINT "PQ_LIQUIDO_fk0" FOREIGN KEY ("id_prod_quim") REFERENCES "PRODUCTO_QUIMICO"("id_prod_quim");

ALTER TABLE "PQ_SOLIDO" ADD CONSTRAINT "PQ_SOLIDO_fk0" FOREIGN KEY ("id_prod_quim") REFERENCES "PRODUCTO_QUIMICO"("id_prod_quim");
