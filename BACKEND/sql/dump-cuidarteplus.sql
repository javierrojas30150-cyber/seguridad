--
-- PostgreSQL database dump
--
-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS cuidarteplus;

--
-- Name: cuidarteplus; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE cuidarteplus WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Spain.1252';

ALTER DATABASE cuidarteplus OWNER TO postgres;

\connect cuidarteplus

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;

ALTER SCHEMA public OWNER TO postgres;

COMMENT ON SCHEMA public IS 'standard public schema';

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id bigint NOT NULL,
    nombre_usuario text NOT NULL,
    contrasena text NOT NULL,
    correo text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuarios ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    nombre text NOT NULL
);

ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--
-- Name: tipo_examen_medico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_examen_medico (
    id bigint NOT NULL,
    nombre text NOT NULL
);

ALTER TABLE public.tipo_examen_medico OWNER TO postgres;

--
-- Name: tipo_examen_medico_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tipo_examen_medico ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tipo_examen_medico_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--
-- Name: pacientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pacientes (
    id bigint NOT NULL,
    rut text NOT NULL,
    primer_nombre text NOT NULL,
    apellido_paterno text NOT NULL,
    apellido_materno text,
    fecha_nacimiento date NOT NULL,
    sexo text NOT NULL,
    nacionalidad text,
    estado_civil text,
    email text NOT NULL,
    telefono text,
    direccion text,
    contacto_emergencia_nombre text,
    contacto_emergencia_telefono text,
    contacto_emergencia_relacion text,
    tipo_prevision text,
    tiene_convenio boolean DEFAULT false,
    grupo_sanguineo text,
    alergias text,
    enfermedades_cronicas text,
    discapacidades text,
    observaciones_medicas_generales text,
    usuario_id bigint,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT pacientes_sexo_check CHECK ((sexo = ANY (ARRAY['M'::text, 'F'::text, 'O'::text]))),
    CONSTRAINT pacientes_estado_civil_check CHECK ((estado_civil = ANY (ARRAY['soltero'::text, 'casado'::text, 'divorciado'::text, 'viudo'::text, 'union_libre'::text])))
);

ALTER TABLE public.pacientes OWNER TO postgres;

--
-- Name: pacientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pacientes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pacientes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--
-- Name: usuario_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_roles (
    id bigint NOT NULL,
    usuario_id bigint NOT NULL,
    rol_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE public.usuario_roles OWNER TO postgres;

--
-- Name: usuario_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuario_roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.usuario_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--
-- Name: examen_medico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.examen_medico (
    id bigint NOT NULL,
    tipo_examen_medico_id bigint NOT NULL,
    paciente_id bigint NOT NULL,
    diagnosis text,
    tratamiento text,
    observaciones text,
    notas text,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE public.examen_medico OWNER TO postgres;

--
-- Name: examen_medico_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.examen_medico ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.examen_medico_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--
-- Name: documentos_examen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documentos_examen (
    id bigint NOT NULL,
    examen_medico_id bigint NOT NULL,
    paciente_id bigint NOT NULL,
    documento bytea NOT NULL,
    nombre_archivo text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE public.documentos_examen OWNER TO postgres;

--
-- Name: documentos_examen_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.documentos_examen ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.documentos_examen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--
-- Name: auditoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auditoria (
    id bigint NOT NULL,
    usuario_id bigint,
    accion text NOT NULL,
    fecha_hora timestamp with time zone DEFAULT now()
);

ALTER TABLE public.auditoria OWNER TO postgres;

--
-- Name: auditoria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auditoria ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles OVERRIDING SYSTEM VALUE VALUES (1, 'admin');
INSERT INTO public.roles OVERRIDING SYSTEM VALUE VALUES (2, 'medico');
INSERT INTO public.roles OVERRIDING SYSTEM VALUE VALUES (3, 'paciente');



--
-- Data for Name: tipo_examen_medico; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (1, 'Hemograma completo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (2, 'Perfil lipídico');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (3, 'Glicemia');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (4, 'Glicemia en ayunas');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (5, 'Hemoglobina glicosilada (HbA1c)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (6, 'Curva de tolerancia a la glucosa');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (7, 'Radiografía de tórax');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (8, 'Radiografía de columna');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (9, 'Radiografía de extremidades');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (10, 'Radiografía de cráneo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (11, 'Electrocardiograma');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (12, 'Electrocardiograma de esfuerzo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (13, 'Holter de 24 horas');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (14, 'Ecografía abdominal');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (15, 'Ecografía pélvica');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (16, 'Ecografía obstétrica');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (17, 'Ecografía de tiroides');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (18, 'Ecografía de próstata');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (19, 'Ecografía de mama');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (20, 'Ecocardiograma');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (21, 'Ecocardiograma Doppler');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (22, 'Prueba de función hepática');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (23, 'Perfil hepático completo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (24, 'Bilirrubina total y fraccionada');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (25, 'Prueba de función renal');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (26, 'Urea y creatinina');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (27, 'Depuración de creatinina');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (28, 'Análisis de orina');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (29, 'Urocultivo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (30, 'Análisis de heces');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (31, 'Coprocultivo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (32, 'Parasitológico');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (33, 'Sangre oculta en heces');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (34, 'Perfil tiroideo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (35, 'TSH');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (36, 'T3 y T4');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (37, 'Anticuerpos antitiroideos');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (38, 'Perfil hormonal');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (39, 'Testosterona');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (40, 'Estradiol');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (41, 'Progesterona');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (42, 'Prolactina');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (43, 'Cortisol');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (44, 'Vitamina D');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (45, 'Vitamina B12');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (46, 'Ácido fólico');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (47, 'Ferritina');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (48, 'Transferrina');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (49, 'Hierro sérico');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (50, 'Ácido úrico');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (51, 'Proteína C reactiva (PCR)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (52, 'Velocidad de sedimentación globular (VSG)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (53, 'Antígeno prostático específico (PSA)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (54, 'Mamografía');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (55, 'Densitometría ósea');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (56, 'Tomografía computarizada (TAC)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (57, 'TAC de cráneo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (58, 'TAC de tórax');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (59, 'TAC de abdomen');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (60, 'Resonancia magnética (RMN)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (61, 'RMN de cráneo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (62, 'RMN de columna');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (63, 'Endoscopia digestiva alta');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (64, 'Colonoscopia');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (65, 'Biopsia');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (66, 'Citología cervicovaginal (Papanicolaou)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (67, 'Frotis de garganta');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (68, 'Cultivo de esputo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (69, 'Espirometría');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (70, 'Prueba de alergias');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (71, 'Test de embarazo');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (72, 'Prueba de VIH');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (73, 'Hepatitis B');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (74, 'Hepatitis C');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (75, 'Sífilis (VDRL)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (76, 'Grupo sanguíneo y factor Rh');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (77, 'Coagulación');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (78, 'Tiempo de protrombina (TP)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (79, 'Tiempo de tromboplastina parcial (TTP)');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (80, 'INR');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (81, 'Marcadores tumorales');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (82, 'CEA');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (83, 'CA 19-9');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (84, 'CA 125');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (85, 'PSA libre');
INSERT INTO public.tipo_examen_medico OVERRIDING SYSTEM VALUE VALUES (86, 'Otro');

--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 3, true);

--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);

--
-- Name: tipo_examen_medico_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_examen_medico_id_seq', 86, true);

--
-- Name: pacientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pacientes_id_seq', 20, true);

--
-- Name: usuario_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_roles_id_seq', 3, true);

--
-- Name: examen_medico_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.examen_medico_id_seq', 1, true);

--
-- Name: documentos_examen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documentos_examen_id_seq', 1, true);

--
-- Name: auditoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auditoria_id_seq', 1, true);

--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);

--
-- Name: usuarios usuarios_nombre_usuario_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_nombre_usuario_key UNIQUE (nombre_usuario);

--
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);

--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);

--
-- Name: roles roles_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key UNIQUE (nombre);

--
-- Name: tipo_examen_medico tipo_examen_medico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_examen_medico
    ADD CONSTRAINT tipo_examen_medico_pkey PRIMARY KEY (id);

--
-- Name: tipo_examen_medico tipo_examen_medico_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_examen_medico
    ADD CONSTRAINT tipo_examen_medico_nombre_key UNIQUE (nombre);

--
-- Name: pacientes pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes
    ADD CONSTRAINT pacientes_pkey PRIMARY KEY (id);

--
-- Name: pacientes pacientes_rut_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes
    ADD CONSTRAINT pacientes_rut_key UNIQUE (rut);

--
-- Name: usuario_roles usuario_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_roles
    ADD CONSTRAINT usuario_roles_pkey PRIMARY KEY (id);

--
-- Name: usuario_roles usuario_roles_usuario_id_rol_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_roles
    ADD CONSTRAINT usuario_roles_usuario_id_rol_id_key UNIQUE (usuario_id, rol_id);

--
-- Name: examen_medico examen_medico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examen_medico
    ADD CONSTRAINT examen_medico_pkey PRIMARY KEY (id);

--
-- Name: documentos_examen documentos_examen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos_examen
    ADD CONSTRAINT documentos_examen_pkey PRIMARY KEY (id);

--
-- Name: auditoria auditoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_pkey PRIMARY KEY (id);

--
-- Name: pacientes pacientes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes
    ADD CONSTRAINT pacientes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE SET NULL;

--
-- Name: usuario_roles usuario_roles_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_roles
    ADD CONSTRAINT usuario_roles_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.roles(id) ON DELETE CASCADE;

--
-- Name: usuario_roles usuario_roles_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_roles
    ADD CONSTRAINT usuario_roles_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;

--
-- Name: examen_medico examen_medico_paciente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examen_medico
    ADD CONSTRAINT examen_medico_paciente_id_fkey FOREIGN KEY (paciente_id) REFERENCES public.pacientes(id) ON DELETE CASCADE;

--
-- Name: examen_medico examen_medico_tipo_examen_medico_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examen_medico
    ADD CONSTRAINT examen_medico_tipo_examen_medico_id_fkey FOREIGN KEY (tipo_examen_medico_id) REFERENCES public.tipo_examen_medico(id);

--
-- Name: documentos_examen documentos_examen_examen_medico_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos_examen
    ADD CONSTRAINT documentos_examen_examen_medico_id_fkey FOREIGN KEY (examen_medico_id) REFERENCES public.examen_medico(id) ON DELETE CASCADE;

--
-- Name: documentos_examen documentos_examen_paciente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos_examen
    ADD CONSTRAINT documentos_examen_paciente_id_fkey FOREIGN KEY (paciente_id) REFERENCES public.pacientes(id) ON DELETE CASCADE;

--
-- Name: auditoria auditoria_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE SET NULL;

--
-- Name: idx_pacientes_rut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pacientes_rut ON public.pacientes(rut);

--
-- Name: idx_pacientes_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pacientes_usuario_id ON public.pacientes(usuario_id);

--
-- Name: idx_examen_medico_paciente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_examen_medico_paciente_id ON public.examen_medico(paciente_id);

--
-- Name: idx_documentos_examen_examen_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_documentos_examen_examen_id ON public.documentos_examen(examen_medico_id);

--
-- Name: idx_documentos_examen_paciente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_documentos_examen_paciente_id ON public.documentos_examen(paciente_id);

--
-- Name: idx_auditoria_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auditoria_usuario_id ON public.auditoria(usuario_id);

--
-- Name: idx_auditoria_fecha_hora; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auditoria_fecha_hora ON public.auditoria(fecha_hora);

--
-- PostgreSQL database dump complete
--

-- Patient and account seed records are excluded from this public copy.
