--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.4
-- Dumped by pg_dump version 9.2.4
-- Started on 2015-02-07 02:56:19

SET statement_timeout = 0;
SET client_encoding = 'LATIN1';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 189 (class 3079 OID 11727)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2079 (class 0 OID 0)
-- Dependencies: 189
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 204 (class 1255 OID 71517)
-- Name: borrar_horarios(); Type: FUNCTION; Schema: public; Owner: Administrador
--

CREATE FUNCTION borrar_horarios() RETURNS integer
    LANGUAGE sql
    AS $$delete from horario h 
	where exists (select * from solucion s 
	where s.id_horario = h.id_horario);
	SELECT 1 AS ignore_this$$;


ALTER FUNCTION public.borrar_horarios() OWNER TO "Administrador";

--
-- TOC entry 202 (class 1255 OID 71204)
-- Name: truncate_all_tables(text); Type: FUNCTION; Schema: public; Owner: Administrador
--

CREATE FUNCTION truncate_all_tables(_username text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
   EXECUTE (
      SELECT 'TRUNCATE TABLE '
             || string_agg(quote_ident(t.tablename), ', ')
             || ' CASCADE'
      FROM   pg_tables t
      WHERE  t.tableowner = _username
      AND    t.schemaname = 'public'
      AND    t.tablename != 'aula_tipo'
      AND    t.tablename != 'restriccion_tipo'
   );
END
$$;


ALTER FUNCTION public.truncate_all_tables(_username text) OWNER TO "Administrador";

--
-- TOC entry 203 (class 1255 OID 71205)
-- Name: truncate_database(text); Type: FUNCTION; Schema: public; Owner: Administrador
--

CREATE FUNCTION truncate_database(user_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   tabla text;
BEGIN
   FOR tabla IN 
      SELECT t.tablename
      FROM   pg_tables t
      WHERE  t.tableowner = user_name
      AND    t.schemaname = 'public'
   LOOP
      EXECUTE 'TRUNCATE TABLE ' || quote_ident(tabla) || ' CASCADE';
   END LOOP;
END
$$;


ALTER FUNCTION public.truncate_database(user_name text) OWNER TO "Administrador";

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 168 (class 1259 OID 71206)
-- Name: area; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE area (
    cod_area integer NOT NULL,
    nombre_area text
);


ALTER TABLE public.area OWNER TO "Administrador";

--
-- TOC entry 2080 (class 0 OID 0)
-- Dependencies: 168
-- Name: TABLE area; Type: COMMENT; Schema: public; Owner: Administrador
--

COMMENT ON TABLE area IS '
';


--
-- TOC entry 169 (class 1259 OID 71212)
-- Name: asignatura; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE asignatura (
    id_materia integer NOT NULL,
    nombre_materia text,
    cod_area integer
);


ALTER TABLE public.asignatura OWNER TO "Administrador";

--
-- TOC entry 170 (class 1259 OID 71218)
-- Name: aula; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE aula (
    num_aula integer NOT NULL,
    nombre_aula text,
    tipo_aula integer,
    profesor integer,
    curso integer
);


ALTER TABLE public.aula OWNER TO "Administrador";

--
-- TOC entry 171 (class 1259 OID 71224)
-- Name: aula_tipo; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE aula_tipo (
    id_tipo_aula integer NOT NULL,
    nombre_tipo_aula text
);


ALTER TABLE public.aula_tipo OWNER TO "Administrador";

--
-- TOC entry 2081 (class 0 OID 0)
-- Dependencies: 171
-- Name: COLUMN aula_tipo.id_tipo_aula; Type: COMMENT; Schema: public; Owner: Administrador
--

COMMENT ON COLUMN aula_tipo.id_tipo_aula IS '
';


--
-- TOC entry 172 (class 1259 OID 71230)
-- Name: carga_academica; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE carga_academica (
    id_materia integer NOT NULL,
    id_curso integer NOT NULL,
    horas_semana integer
);


ALTER TABLE public.carga_academica OWNER TO "Administrador";

--
-- TOC entry 173 (class 1259 OID 71233)
-- Name: clase; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE clase (
    id_clase integer NOT NULL,
    materia integer,
    curso integer,
    profesor integer,
    aula integer,
    duracion integer
);


ALTER TABLE public.clase OWNER TO "Administrador";

--
-- TOC entry 174 (class 1259 OID 71236)
-- Name: curso; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE curso (
    id_curso integer NOT NULL,
    nombre_curso text,
    num_estudiantes integer,
    id_grado integer
);


ALTER TABLE public.curso OWNER TO "Administrador";

--
-- TOC entry 175 (class 1259 OID 71242)
-- Name: dia; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE dia (
    cod_dia integer NOT NULL,
    nombre_dia text
);


ALTER TABLE public.dia OWNER TO "Administrador";

--
-- TOC entry 176 (class 1259 OID 71248)
-- Name: grado; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE grado (
    id_grado integer NOT NULL,
    nombre_grado text
);


ALTER TABLE public.grado OWNER TO "Administrador";

--
-- TOC entry 177 (class 1259 OID 71254)
-- Name: hora; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE hora (
    cod_hora integer NOT NULL,
    inicio time without time zone,
    fin time without time zone,
    duracion double precision
);


ALTER TABLE public.hora OWNER TO "Administrador";

--
-- TOC entry 178 (class 1259 OID 71257)
-- Name: horario; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE horario (
    id_horario integer NOT NULL,
    nombre text,
    fecha timestamp without time zone,
    fitness double precision
);


ALTER TABLE public.horario OWNER TO "Administrador";

--
-- TOC entry 179 (class 1259 OID 71263)
-- Name: periodo; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE periodo (
    cod_periodo integer NOT NULL,
    dia integer,
    hora integer
);


ALTER TABLE public.periodo OWNER TO "Administrador";

--
-- TOC entry 180 (class 1259 OID 71266)
-- Name: periodo_cod_periodo_seq; Type: SEQUENCE; Schema: public; Owner: Administrador
--

CREATE SEQUENCE periodo_cod_periodo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 100000
    CACHE 1;


ALTER TABLE public.periodo_cod_periodo_seq OWNER TO "Administrador";

--
-- TOC entry 2082 (class 0 OID 0)
-- Dependencies: 180
-- Name: periodo_cod_periodo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Administrador
--

ALTER SEQUENCE periodo_cod_periodo_seq OWNED BY periodo.cod_periodo;


--
-- TOC entry 181 (class 1259 OID 71268)
-- Name: pref_carga_periodo; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE pref_carga_periodo (
    id_materia integer NOT NULL,
    id_curso integer NOT NULL,
    periodo integer NOT NULL
);


ALTER TABLE public.pref_carga_periodo OWNER TO "Administrador";

--
-- TOC entry 182 (class 1259 OID 71271)
-- Name: pref_profesor_materia; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE pref_profesor_materia (
    id_materia integer NOT NULL,
    id_curso integer NOT NULL,
    id_profesor integer NOT NULL
);


ALTER TABLE public.pref_profesor_materia OWNER TO "Administrador";

--
-- TOC entry 183 (class 1259 OID 71274)
-- Name: pref_profesor_periodo; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE pref_profesor_periodo (
    profesor integer NOT NULL,
    periodo integer NOT NULL
);


ALTER TABLE public.pref_profesor_periodo OWNER TO "Administrador";

--
-- TOC entry 184 (class 1259 OID 71277)
-- Name: profesor; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE profesor (
    id_profesor integer NOT NULL,
    nombre_profesor text,
    horas_max integer,
    correo text
);


ALTER TABLE public.profesor OWNER TO "Administrador";

--
-- TOC entry 185 (class 1259 OID 71283)
-- Name: restriccion_seq; Type: SEQUENCE; Schema: public; Owner: Administrador
--

CREATE SEQUENCE restriccion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000000
    CACHE 1;


ALTER TABLE public.restriccion_seq OWNER TO "Administrador";

--
-- TOC entry 186 (class 1259 OID 71285)
-- Name: restriccion; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE restriccion (
    id_restriccion integer DEFAULT nextval('restriccion_seq'::regclass) NOT NULL,
    id_horario integer,
    inicial character(1),
    mensaje text
);


ALTER TABLE public.restriccion OWNER TO "Administrador";

--
-- TOC entry 187 (class 1259 OID 71292)
-- Name: restriccion_tipo; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE restriccion_tipo (
    inicial character(1) NOT NULL,
    nombre text
);


ALTER TABLE public.restriccion_tipo OWNER TO "Administrador";

--
-- TOC entry 188 (class 1259 OID 71298)
-- Name: solucion; Type: TABLE; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE TABLE solucion (
    id_horario integer NOT NULL,
    id_clase integer NOT NULL,
    cod_periodo integer NOT NULL
);


ALTER TABLE public.solucion OWNER TO "Administrador";

--
-- TOC entry 2004 (class 2604 OID 71301)
-- Name: cod_periodo; Type: DEFAULT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY periodo ALTER COLUMN cod_periodo SET DEFAULT nextval('periodo_cod_periodo_seq'::regclass);


--
-- TOC entry 2017 (class 2606 OID 71303)
-- Name: pk_alua_tipo; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY aula_tipo
    ADD CONSTRAINT pk_alua_tipo PRIMARY KEY (id_tipo_aula);


--
-- TOC entry 2007 (class 2606 OID 71305)
-- Name: pk_area; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY area
    ADD CONSTRAINT pk_area PRIMARY KEY (cod_area);


--
-- TOC entry 2010 (class 2606 OID 71307)
-- Name: pk_asignatura; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY asignatura
    ADD CONSTRAINT pk_asignatura PRIMARY KEY (id_materia);


--
-- TOC entry 2015 (class 2606 OID 71309)
-- Name: pk_aula; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY aula
    ADD CONSTRAINT pk_aula PRIMARY KEY (num_aula);


--
-- TOC entry 2019 (class 2606 OID 71311)
-- Name: pk_carga_academica_COMPUESTA; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY carga_academica
    ADD CONSTRAINT "pk_carga_academica_COMPUESTA" PRIMARY KEY (id_materia, id_curso);


--
-- TOC entry 2021 (class 2606 OID 71313)
-- Name: pk_clase; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY clase
    ADD CONSTRAINT pk_clase PRIMARY KEY (id_clase);


--
-- TOC entry 2023 (class 2606 OID 71315)
-- Name: pk_curso; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT pk_curso PRIMARY KEY (id_curso);


--
-- TOC entry 2025 (class 2606 OID 71317)
-- Name: pk_dia; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY dia
    ADD CONSTRAINT pk_dia PRIMARY KEY (cod_dia);


--
-- TOC entry 2027 (class 2606 OID 71319)
-- Name: pk_grado; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY grado
    ADD CONSTRAINT pk_grado PRIMARY KEY (id_grado);


--
-- TOC entry 2029 (class 2606 OID 71321)
-- Name: pk_hora; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY hora
    ADD CONSTRAINT pk_hora PRIMARY KEY (cod_hora);


--
-- TOC entry 2031 (class 2606 OID 71323)
-- Name: pk_horario; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY horario
    ADD CONSTRAINT pk_horario PRIMARY KEY (id_horario);


--
-- TOC entry 2035 (class 2606 OID 71325)
-- Name: pk_periodo; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY periodo
    ADD CONSTRAINT pk_periodo PRIMARY KEY (cod_periodo);


--
-- TOC entry 2037 (class 2606 OID 71327)
-- Name: pk_pref_carga_periodo; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY pref_carga_periodo
    ADD CONSTRAINT pk_pref_carga_periodo PRIMARY KEY (id_materia, id_curso, periodo);


--
-- TOC entry 2039 (class 2606 OID 71329)
-- Name: pk_pref_profesor; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY pref_profesor_materia
    ADD CONSTRAINT pk_pref_profesor PRIMARY KEY (id_materia, id_curso, id_profesor);


--
-- TOC entry 2041 (class 2606 OID 71331)
-- Name: pk_pref_profesor_periodo; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY pref_profesor_periodo
    ADD CONSTRAINT pk_pref_profesor_periodo PRIMARY KEY (profesor, periodo);


--
-- TOC entry 2043 (class 2606 OID 71333)
-- Name: pk_profesor; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY profesor
    ADD CONSTRAINT pk_profesor PRIMARY KEY (id_profesor);


--
-- TOC entry 2045 (class 2606 OID 71335)
-- Name: pk_restriccion; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY restriccion
    ADD CONSTRAINT pk_restriccion PRIMARY KEY (id_restriccion);


--
-- TOC entry 2047 (class 2606 OID 71337)
-- Name: pk_restriccion_tipo; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY restriccion_tipo
    ADD CONSTRAINT pk_restriccion_tipo PRIMARY KEY (inicial);


--
-- TOC entry 2049 (class 2606 OID 71339)
-- Name: pk_solucion_compuesta; Type: CONSTRAINT; Schema: public; Owner: Administrador; Tablespace: 
--

ALTER TABLE ONLY solucion
    ADD CONSTRAINT pk_solucion_compuesta PRIMARY KEY (id_horario, id_clase, cod_periodo);


--
-- TOC entry 2008 (class 1259 OID 71340)
-- Name: fki_asignatura_area; Type: INDEX; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE INDEX fki_asignatura_area ON asignatura USING btree (cod_area);


--
-- TOC entry 2011 (class 1259 OID 71341)
-- Name: fki_aula_aulatipo; Type: INDEX; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE INDEX fki_aula_aulatipo ON aula USING btree (tipo_aula);


--
-- TOC entry 2012 (class 1259 OID 71342)
-- Name: fki_aula_curso; Type: INDEX; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE INDEX fki_aula_curso ON aula USING btree (curso);


--
-- TOC entry 2013 (class 1259 OID 71343)
-- Name: fki_aula_profesor; Type: INDEX; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE INDEX fki_aula_profesor ON aula USING btree (profesor);


--
-- TOC entry 2032 (class 1259 OID 71344)
-- Name: fki_periodo_dia; Type: INDEX; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE INDEX fki_periodo_dia ON periodo USING btree (dia);


--
-- TOC entry 2033 (class 1259 OID 71345)
-- Name: fki_periodo_hora; Type: INDEX; Schema: public; Owner: Administrador; Tablespace: 
--

CREATE INDEX fki_periodo_hora ON periodo USING btree (hora);


--
-- TOC entry 2050 (class 2606 OID 71346)
-- Name: fk_asignatura_area; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY asignatura
    ADD CONSTRAINT fk_asignatura_area FOREIGN KEY (cod_area) REFERENCES area(cod_area);


--
-- TOC entry 2051 (class 2606 OID 71356)
-- Name: fk_aula_aulatipo; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY aula
    ADD CONSTRAINT fk_aula_aulatipo FOREIGN KEY (tipo_aula) REFERENCES aula_tipo(id_tipo_aula);


--
-- TOC entry 2052 (class 2606 OID 71361)
-- Name: fk_aula_curso; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY aula
    ADD CONSTRAINT fk_aula_curso FOREIGN KEY (curso) REFERENCES curso(id_curso);


--
-- TOC entry 2053 (class 2606 OID 71366)
-- Name: fk_aula_profesor; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY aula
    ADD CONSTRAINT fk_aula_profesor FOREIGN KEY (profesor) REFERENCES profesor(id_profesor);


--
-- TOC entry 2054 (class 2606 OID 71381)
-- Name: fk_carga_curso; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY carga_academica
    ADD CONSTRAINT fk_carga_curso FOREIGN KEY (id_curso) REFERENCES curso(id_curso);


--
-- TOC entry 2055 (class 2606 OID 71386)
-- Name: fk_carga_materia; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY carga_academica
    ADD CONSTRAINT fk_carga_materia FOREIGN KEY (id_materia) REFERENCES asignatura(id_materia);


--
-- TOC entry 2056 (class 2606 OID 71391)
-- Name: fk_clase_aula; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY clase
    ADD CONSTRAINT fk_clase_aula FOREIGN KEY (aula) REFERENCES aula(num_aula);


--
-- TOC entry 2058 (class 2606 OID 71533)
-- Name: fk_clase_carga_academica; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY clase
    ADD CONSTRAINT fk_clase_carga_academica FOREIGN KEY (materia, curso) REFERENCES carga_academica(id_materia, id_curso) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2057 (class 2606 OID 71401)
-- Name: fk_clase_profesor; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY clase
    ADD CONSTRAINT fk_clase_profesor FOREIGN KEY (profesor) REFERENCES profesor(id_profesor);


--
-- TOC entry 2059 (class 2606 OID 71406)
-- Name: fk_curso_grado; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY curso
    ADD CONSTRAINT fk_curso_grado FOREIGN KEY (id_grado) REFERENCES grado(id_grado);


--
-- TOC entry 2060 (class 2606 OID 71416)
-- Name: fk_periodo_dia; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY periodo
    ADD CONSTRAINT fk_periodo_dia FOREIGN KEY (dia) REFERENCES dia(cod_dia);


--
-- TOC entry 2061 (class 2606 OID 71421)
-- Name: fk_periodo_hora; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY periodo
    ADD CONSTRAINT fk_periodo_hora FOREIGN KEY (hora) REFERENCES hora(cod_hora);


--
-- TOC entry 2062 (class 2606 OID 71426)
-- Name: fk_pref_carga_periodo_carga; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY pref_carga_periodo
    ADD CONSTRAINT fk_pref_carga_periodo_carga FOREIGN KEY (id_materia, id_curso) REFERENCES carga_academica(id_materia, id_curso);


--
-- TOC entry 2063 (class 2606 OID 71431)
-- Name: fk_pref_carga_periodo_id_periodo; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY pref_carga_periodo
    ADD CONSTRAINT fk_pref_carga_periodo_id_periodo FOREIGN KEY (periodo) REFERENCES periodo(cod_periodo);


--
-- TOC entry 2064 (class 2606 OID 71436)
-- Name: fk_pref_profesor_carga; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY pref_profesor_materia
    ADD CONSTRAINT fk_pref_profesor_carga FOREIGN KEY (id_materia, id_curso) REFERENCES carga_academica(id_materia, id_curso);


--
-- TOC entry 2065 (class 2606 OID 71441)
-- Name: fk_pref_profesor_materia_id_profesor; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY pref_profesor_materia
    ADD CONSTRAINT fk_pref_profesor_materia_id_profesor FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor);


--
-- TOC entry 2066 (class 2606 OID 71446)
-- Name: fk_pref_profesor_periodo_periodo; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY pref_profesor_periodo
    ADD CONSTRAINT fk_pref_profesor_periodo_periodo FOREIGN KEY (periodo) REFERENCES periodo(cod_periodo);


--
-- TOC entry 2067 (class 2606 OID 71451)
-- Name: fk_pref_profesor_periodo_profesor; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY pref_profesor_periodo
    ADD CONSTRAINT fk_pref_profesor_periodo_profesor FOREIGN KEY (profesor) REFERENCES profesor(id_profesor);


--
-- TOC entry 2069 (class 2606 OID 71506)
-- Name: fk_restriccion_horario; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY restriccion
    ADD CONSTRAINT fk_restriccion_horario FOREIGN KEY (id_horario) REFERENCES horario(id_horario) ON DELETE CASCADE;


--
-- TOC entry 2068 (class 2606 OID 71461)
-- Name: fk_restriccion_inicial; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY restriccion
    ADD CONSTRAINT fk_restriccion_inicial FOREIGN KEY (inicial) REFERENCES restriccion_tipo(inicial);


--
-- TOC entry 2072 (class 2606 OID 71538)
-- Name: fk_solucion_clase; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY solucion
    ADD CONSTRAINT fk_solucion_clase FOREIGN KEY (id_clase) REFERENCES clase(id_clase) ON DELETE CASCADE;


--
-- TOC entry 2071 (class 2606 OID 71487)
-- Name: fk_solucion_horario; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY solucion
    ADD CONSTRAINT fk_solucion_horario FOREIGN KEY (id_horario) REFERENCES horario(id_horario) ON DELETE CASCADE;


--
-- TOC entry 2070 (class 2606 OID 71482)
-- Name: fk_solucion_periodo; Type: FK CONSTRAINT; Schema: public; Owner: Administrador
--

ALTER TABLE ONLY solucion
    ADD CONSTRAINT fk_solucion_periodo FOREIGN KEY (cod_periodo) REFERENCES periodo(cod_periodo) ON DELETE CASCADE;


--
-- TOC entry 2078 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: Administrador
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM "Administrador";
GRANT ALL ON SCHEMA public TO "Administrador";
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-02-07 02:56:20

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.1
-- Dumped by pg_dump version 9.2.1
-- Started on 2015-02-10 07:10:40

SET statement_timeout = 0;
SET client_encoding = 'LATIN1';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- TOC entry 2096 (class 0 OID 0)
-- Dependencies: 180
-- Name: periodo_cod_periodo_seq; Type: SEQUENCE SET; Schema: public; Owner: Administrador
--

SELECT pg_catalog.setval('periodo_cod_periodo_seq', 30, true);


--
-- TOC entry 2097 (class 0 OID 0)
-- Dependencies: 185
-- Name: restriccion_seq; Type: SEQUENCE SET; Schema: public; Owner: Administrador
--

SELECT pg_catalog.setval('restriccion_seq', 1, true);


--
-- TOC entry 2073 (class 0 OID 91678)
-- Dependencies: 168
-- Data for Name: area; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO area (cod_area, nombre_area) VALUES (1, 'Sin Area');


--
-- TOC entry 2074 (class 0 OID 91684)
-- Dependencies: 169
-- Data for Name: asignatura; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (1, 'C. NATURALES', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (2, 'FISICA', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (3, 'QUIMICA', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (4, 'C. SOCIALES', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (5, 'FILOSOFIA', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (6, 'ECONOMIA', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (7, 'ETICA Y RELEGION', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (8, 'MATEMATICAS', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (10, 'INGLES', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (11, 'EDUCACION FISICA', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (12, 'EDUCACION ARTISTICA', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (13, 'TECNOLOGIA', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (14, 'GESTION SOCIAL', 1);
INSERT INTO asignatura (id_materia, nombre_materia, cod_area) VALUES (9, 'ESPAÑOL', 1);


--
-- TOC entry 2076 (class 0 OID 91696)
-- Dependencies: 171
-- Data for Name: aula_tipo; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO aula_tipo (id_tipo_aula, nombre_tipo_aula) VALUES (1, 'Magistral');
INSERT INTO aula_tipo (id_tipo_aula, nombre_tipo_aula) VALUES (2, 'Temática');


--
-- TOC entry 2081 (class 0 OID 91720)
-- Dependencies: 176
-- Data for Name: grado; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO grado (id_grado, nombre_grado) VALUES (1, '6to');
INSERT INTO grado (id_grado, nombre_grado) VALUES (2, '7mo');
INSERT INTO grado (id_grado, nombre_grado) VALUES (3, '8vo');
INSERT INTO grado (id_grado, nombre_grado) VALUES (4, '9no');
INSERT INTO grado (id_grado, nombre_grado) VALUES (5, '10mo');
INSERT INTO grado (id_grado, nombre_grado) VALUES (6, '11mo');


--
-- TOC entry 2079 (class 0 OID 91708)
-- Dependencies: 174
-- Data for Name: curso; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (601, '601', 10, 1);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (602, '602', 10, 1);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (603, '603', 10, 1);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (604, '604', 10, 1);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (701, '701', 10, 2);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (702, '702', 10, 2);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (703, '703', 10, 2);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (704, '704', 10, 2);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (801, '8vo 1', 10, 3);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (802, '8vo 2', 10, 3);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (803, '8vo 3', 10, 3);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (804, '8vo 4', 10, 3);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (901, '9no 1', 10, 4);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (902, '9no 2', 10, 4);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (903, '9no 3', 10, 4);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (904, '9no 4', 10, 4);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (905, '9no 5', 10, 4);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (1001, '10mo 1', 10, 5);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (1002, '10mo 2', 10, 5);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (1003, '10mo 3', 10, 5);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (1004, '10mo 4', 10, 5);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (1101, '11mo 1', 10, 6);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (1102, '11mo 2', 10, 6);
INSERT INTO curso (id_curso, nombre_curso, num_estudiantes, id_grado) VALUES (1103, '11mo 3', 10, 6);


--
-- TOC entry 2088 (class 0 OID 91749)
-- Dependencies: 184
-- Data for Name: profesor; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (1, 'Teresa Duque', 20, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (2, 'Angela Vargas', 20, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (3, 'Doris Vargas', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (4, 'Gina Forero', 22, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (5, 'Rubi Rogriguez', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (6, 'Blanca Moriano', 22, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (7, 'Nancy Lopez', 22, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (8, 'Ilse Garavito', 22, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (10, 'Gladys Leal', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (11, 'Doris Moriano', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (12, 'Alba Samanca', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (13, 'Doris Garzon', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (14, 'Edwin Cardenas', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (16, 'Fabiola Ruiz', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (17, 'Amanda Prieto', 20, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (18, 'Paola Ramirez', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (19, 'Danilo Garzon', 20, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (22, 'Andrea Beltran', 20, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (23, 'Carlos Gonzalez', 20, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (24, 'Pedro Medina', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (25, 'Edilson Prada', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (26, 'Angela Marin', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (27, 'Javier Almanza', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (28, 'Alexandra Lopez', 16, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (29, 'Leonel Ramirez', 16, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (30, 'Jorge Ospina', 16, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (31, 'Cristian Aguirre', 16, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (32, 'Monica Pulido', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (33, 'Liz Hernandez', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (21, 'Diana Cabana', 20, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (9, 'Mery Piñeros', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (15, 'Julia Castañeda', 24, NULL);
INSERT INTO profesor (id_profesor, nombre_profesor, horas_max, correo) VALUES (20, 'Graciela Peña', 20, NULL);


--
-- TOC entry 2075 (class 0 OID 91690)
-- Dependencies: 170
-- Data for Name: aula; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (102, 'Aula ->Teresa Duque', 1, 1, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (2, 'Aula ->Angela Vargas', 1, 2, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (214, 'Aula ->Doris Vargas', 1, 3, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (4, 'Aula ->Gina Forero', 1, 4, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (5, 'Aula ->Rubi Rogriguez', 1, 5, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (210, 'Aula ->Blanca Moriano', 1, 6, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (213, 'Aula ->Ilse Garavito', 1, 8, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (212, 'Aula ->Gladys Leal', 1, 10, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (215, 'Aula ->Doris Moriano', 1, 11, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (217, 'Aula ->Alba Samanca', 1, 12, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (216, 'Aula ->Doris Garzon', 1, 13, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (218, 'Aula ->Edwin Cardenas', 1, 14, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (207, 'Aula ->Fabiola Ruiz', 1, 16, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (209, 'Aula ->Amanda Prieto', 1, 17, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (206, 'Aula ->Paola Ramirez', 1, 18, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (202, 'Aula ->Danilo Garzon', 1, 19, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (203, 'Aula ->Andrea Beltran', 1, 22, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (21, 'Aula ->Pedro Medina', 1, 24, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (22, 'Aula ->Edilson Prada', 1, 25, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (23, 'Aula ->Angela Marin', 1, 26, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (24, 'Aula ->Javier Almanza', 1, 27, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (25, 'Aula ->Alexandra Lopez', 1, 28, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (26, 'Aula ->Leonel Ramirez', 1, 29, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (27, 'Aula ->Jorge Ospina', 1, 30, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (205, 'Aula ->Liz Hernandez', 1, 33, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (29, 'Aula ->Diana Cabana', 1, 21, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (211, 'Aula ->Mery Piñeros', 1, 9, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (208, 'Aula ->Julia Castañeda', 1, 15, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (201, 'Aula ->Graciela Peña', 1, 20, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (77, 'Monica Pulido', 1, 32, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (777, 'Nancy Lopez', 1, 7, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (7777, 'Carlos Gonzalez', 1, 23, NULL);
INSERT INTO aula (num_aula, nombre_aula, tipo_aula, profesor, curso) VALUES (7, 'Cristian Aguirre', 1, 31, NULL);


--
-- TOC entry 2077 (class 0 OID 91702)
-- Dependencies: 172
-- Data for Name: carga_academica; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 601, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 601, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 601, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 601, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 601, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 601, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 601, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 601, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 601, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 601, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 602, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 602, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 602, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 602, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 602, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 602, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 602, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 602, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 602, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 602, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 603, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 603, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 603, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 603, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 603, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 603, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 603, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 603, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 603, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 603, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 604, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 604, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 604, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 604, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 604, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 604, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 604, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 604, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 604, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 604, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 701, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 701, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 701, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 701, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 701, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 701, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 701, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 701, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 701, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 701, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 702, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 702, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 702, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 702, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 702, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 702, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 702, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 702, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 702, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 702, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 703, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 703, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 703, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 703, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 703, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 703, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 703, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 703, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 703, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 703, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 704, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 704, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 704, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 704, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 704, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 704, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 704, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 704, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 704, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 704, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 801, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 801, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 801, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 801, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 801, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 801, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 801, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 801, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 801, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 801, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 802, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 802, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 802, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 802, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 802, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 802, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 802, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 802, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 802, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 802, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 803, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 803, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 803, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 803, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 803, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 803, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 803, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 803, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 803, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 803, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 804, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 804, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 804, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 804, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 804, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 804, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 804, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 804, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 804, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 804, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 901, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 901, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 901, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 901, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 901, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 901, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 901, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 901, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 901, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 901, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 902, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 902, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 902, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 902, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 902, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 902, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 902, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 902, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 902, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 902, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 903, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 903, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 903, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 903, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 903, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 903, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 903, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 903, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 903, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 903, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 905, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 905, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 905, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 905, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 905, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 905, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 905, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 905, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 905, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 905, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (1, 904, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (4, 904, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (7, 904, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 904, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 904, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 904, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 904, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 904, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 904, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 904, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (2, 1001, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (2, 1002, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (2, 1003, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (2, 1004, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (3, 1001, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (3, 1002, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (3, 1003, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (3, 1004, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (5, 1001, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (5, 1002, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (5, 1003, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (5, 1004, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (6, 1001, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (6, 1002, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (6, 1003, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (6, 1004, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 1001, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 1002, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 1003, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 1004, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 1001, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 1002, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 1003, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 1004, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 1001, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 1002, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 1003, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 1004, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 1001, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 1002, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 1003, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 1004, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 1001, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 1002, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 1003, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 1004, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 1001, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 1002, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 1003, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 1004, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 1001, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 1002, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 1003, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 1004, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (2, 1101, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (2, 1102, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (2, 1103, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (3, 1101, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (3, 1102, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (3, 1103, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (5, 1101, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (5, 1102, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (5, 1103, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 1101, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 1102, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (8, 1103, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 1101, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 1102, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (9, 1103, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 1101, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 1102, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (10, 1103, 4);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 1101, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 1102, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (11, 1103, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 1101, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 1102, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (12, 1103, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 1101, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 1102, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (13, 1103, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 1101, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 1102, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (14, 1103, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (6, 1101, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (6, 1102, 2);
INSERT INTO carga_academica (id_materia, id_curso, horas_semana) VALUES (6, 1103, 2);


--
-- TOC entry 2078 (class 0 OID 91705)
-- Dependencies: 173
-- Data for Name: clase; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1004, 1, 602, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1006, 1, 603, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1007, 1, 604, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1008, 1, 604, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1058, 4, 602, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1059, 4, 602, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1060, 4, 603, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1061, 4, 603, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1062, 4, 604, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1063, 4, 604, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1105, 7, 602, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1106, 7, 603, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1107, 7, 604, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1139, 8, 603, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1140, 8, 603, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1141, 8, 604, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1185, 9, 602, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1186, 9, 602, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1187, 9, 603, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1188, 9, 603, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1189, 9, 604, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1190, 9, 604, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1233, 10, 602, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1234, 10, 602, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1235, 10, 603, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1237, 10, 604, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1238, 10, 604, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1273, 11, 602, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1274, 11, 603, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1275, 11, 604, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1298, 12, 603, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1009, 1, 701, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1010, 1, 701, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1011, 1, 702, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1012, 1, 702, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1013, 1, 703, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1014, 1, 703, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1016, 1, 704, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1064, 4, 701, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1065, 4, 701, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1066, 4, 702, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1067, 4, 702, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1070, 4, 704, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1071, 4, 704, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1108, 7, 701, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1109, 7, 702, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1111, 7, 704, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1143, 8, 701, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1145, 8, 702, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1149, 8, 704, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1191, 9, 701, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1192, 9, 701, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1239, 10, 701, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1240, 10, 701, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1276, 11, 701, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1300, 12, 701, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1017, 1, 801, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1018, 1, 801, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1019, 1, 802, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1020, 1, 802, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1021, 1, 803, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1023, 1, 804, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1024, 1, 804, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1072, 4, 801, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1073, 4, 801, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1074, 4, 802, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1075, 4, 802, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1076, 4, 803, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1077, 4, 803, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1078, 4, 804, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1079, 4, 804, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1112, 7, 801, 28, 25, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1113, 7, 802, 28, 25, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1151, 8, 801, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1152, 8, 801, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1153, 8, 802, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1154, 8, 802, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1155, 8, 803, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1199, 9, 801, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1025, 1, 901, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1026, 1, 901, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1027, 1, 902, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1028, 1, 902, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1029, 1, 903, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1030, 1, 903, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1032, 1, 904, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1033, 1, 905, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1034, 1, 905, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1080, 4, 901, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1081, 4, 901, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1082, 4, 902, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1083, 4, 902, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1084, 4, 903, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1085, 4, 903, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1086, 4, 904, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1087, 4, 904, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1088, 4, 905, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1116, 7, 901, 29, 26, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1117, 7, 902, 31, 7, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1118, 7, 903, 31, 7, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1119, 7, 904, 29, 26, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1120, 7, 905, 8, 213, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1035, 2, 1001, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1036, 2, 1001, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1037, 2, 1002, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1038, 2, 1002, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1039, 2, 1003, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1040, 2, 1003, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1041, 2, 1004, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1046, 3, 1001, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1047, 3, 1002, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1048, 3, 1003, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1049, 3, 1004, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1090, 5, 1001, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1091, 5, 1002, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1092, 5, 1003, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1093, 5, 1004, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1097, 6, 1001, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1098, 6, 1002, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1099, 6, 1003, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1100, 6, 1004, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1123, 8, 1002, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1124, 8, 1002, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1127, 8, 1004, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1125, 8, 1003, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1128, 8, 1004, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1043, 2, 1101, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1044, 2, 1102, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1045, 2, 1103, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1050, 3, 1101, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1051, 3, 1101, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1052, 3, 1102, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1053, 3, 1102, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1055, 3, 1103, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1002, 1, 601, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1057, 4, 601, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1104, 7, 601, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1135, 8, 601, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1136, 8, 601, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1138, 8, 602, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1142, 8, 604, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1183, 9, 601, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1184, 9, 601, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1231, 10, 601, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1232, 10, 601, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1320, 13, 601, 30, 27, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1321, 13, 602, 30, 27, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1323, 13, 604, 30, 27, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1272, 11, 601, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1296, 12, 601, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1297, 12, 602, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1299, 12, 604, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1345, 14, 602, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1344, 14, 601, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1346, 14, 603, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1347, 14, 604, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1144, 8, 701, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1193, 9, 702, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1194, 9, 702, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1197, 9, 704, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1198, 9, 704, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1241, 10, 702, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1242, 10, 702, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1245, 10, 704, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1246, 10, 704, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1277, 11, 702, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1279, 11, 704, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1303, 12, 704, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1324, 13, 701, 30, 27, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1348, 14, 701, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1158, 8, 804, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1201, 9, 802, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1202, 9, 802, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1203, 9, 803, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1204, 9, 803, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1205, 9, 804, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1206, 9, 804, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1247, 10, 801, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1248, 10, 801, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1249, 10, 802, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1250, 10, 802, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1251, 10, 803, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1252, 10, 803, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1254, 10, 804, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1280, 11, 801, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1281, 11, 802, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1282, 11, 803, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1283, 11, 804, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1304, 12, 801, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1306, 12, 803, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1307, 12, 804, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1328, 13, 801, 28, 25, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1352, 14, 801, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1159, 8, 901, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1160, 8, 901, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1162, 8, 902, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1163, 8, 903, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1164, 8, 903, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1165, 8, 904, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1166, 8, 904, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1167, 8, 905, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1168, 8, 905, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1207, 9, 901, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1208, 9, 901, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1209, 9, 902, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1210, 9, 902, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1211, 9, 903, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1213, 9, 904, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1214, 9, 904, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1215, 9, 905, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1216, 9, 905, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1255, 10, 901, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1256, 10, 901, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1257, 10, 902, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1258, 10, 902, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1259, 10, 903, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1260, 10, 903, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1261, 10, 904, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1262, 10, 904, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1264, 10, 905, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1284, 11, 901, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1285, 11, 902, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1286, 11, 903, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1287, 11, 904, 24, 21, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1288, 11, 905, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1308, 12, 901, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1309, 12, 902, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1310, 12, 903, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1311, 12, 904, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1312, 12, 905, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1332, 13, 901, 29, 26, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1333, 13, 902, 31, 7, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1334, 13, 903, 31, 7, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1335, 13, 904, 31, 7, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1356, 14, 901, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1357, 14, 902, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1358, 14, 903, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1359, 14, 904, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1360, 14, 905, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1169, 9, 1001, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1170, 9, 1001, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1171, 9, 1002, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1172, 9, 1002, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1174, 9, 1003, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1175, 9, 1004, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1176, 9, 1004, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1217, 10, 1001, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1218, 10, 1001, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1219, 10, 1002, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1220, 10, 1002, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1221, 10, 1003, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1222, 10, 1003, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1223, 10, 1004, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1224, 10, 1004, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1265, 11, 1001, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1267, 11, 1003, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1268, 11, 1004, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1289, 12, 1001, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1290, 12, 1002, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1291, 12, 1003, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1292, 12, 1004, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1313, 13, 1001, 29, 26, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1177, 9, 1101, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1178, 9, 1101, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1179, 9, 1102, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1180, 9, 1102, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1181, 9, 1103, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1225, 10, 1101, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1001, 1, 601, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1003, 1, 602, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1005, 1, 603, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1056, 4, 601, 6, 210, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1137, 8, 602, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1236, 10, 603, 19, 202, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1322, 13, 603, 30, 27, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1015, 1, 704, 1, 102, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1068, 4, 703, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1069, 4, 703, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1110, 7, 703, 7, 777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1146, 8, 702, 11, 215, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1147, 8, 703, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1148, 8, 703, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1150, 8, 704, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1195, 9, 703, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1196, 9, 703, 15, 208, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1243, 10, 703, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1244, 10, 703, 20, 201, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1278, 11, 703, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1301, 12, 702, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1302, 12, 703, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1325, 13, 702, 30, 27, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1326, 13, 703, 28, 25, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1327, 13, 704, 28, 25, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1349, 14, 702, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1350, 14, 703, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1351, 14, 704, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1022, 1, 803, 2, 2, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1114, 7, 803, 30, 27, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1115, 7, 804, 30, 27, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1156, 8, 803, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1157, 8, 804, 12, 217, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1200, 9, 801, 16, 207, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1253, 10, 804, 23, 7777, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1305, 12, 802, 26, 23, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1329, 13, 802, 28, 25, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1330, 13, 803, 28, 25, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1331, 13, 804, 28, 25, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1353, 14, 802, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1354, 14, 803, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1355, 14, 804, 32, 77, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1031, 1, 904, 3, 214, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1089, 4, 905, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1161, 8, 902, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1212, 9, 903, 17, 209, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1263, 10, 905, 21, 29, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1336, 13, 905, 29, 26, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1042, 2, 1004, 4, 4, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1121, 8, 1001, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1122, 8, 1001, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1126, 8, 1003, 13, 216, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1173, 9, 1003, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1266, 11, 1002, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1314, 13, 1002, 29, 26, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1315, 13, 1003, 29, 26, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1316, 13, 1004, 29, 26, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1337, 14, 1001, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1338, 14, 1002, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1339, 14, 1003, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1340, 14, 1004, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1054, 3, 1103, 5, 5, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1094, 5, 1101, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1095, 5, 1102, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1096, 5, 1103, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1129, 8, 1101, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1130, 8, 1101, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1131, 8, 1102, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1132, 8, 1102, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1133, 8, 1103, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1134, 8, 1103, 14, 218, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1182, 9, 1103, 18, 206, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1226, 10, 1101, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1227, 10, 1102, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1228, 10, 1102, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1229, 10, 1103, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1230, 10, 1103, 22, 203, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1269, 11, 1101, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1270, 11, 1102, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1271, 11, 1103, 25, 22, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1293, 12, 1101, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1294, 12, 1102, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1295, 12, 1103, 27, 24, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1317, 13, 1101, 31, 7, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1318, 13, 1102, 31, 7, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1319, 13, 1103, 31, 7, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1341, 14, 1101, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1342, 14, 1102, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1343, 14, 1103, 33, 205, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1101, 6, 1101, 10, 212, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1102, 6, 1102, 9, 211, 2);
INSERT INTO clase (id_clase, materia, curso, profesor, aula, duracion) VALUES (1103, 6, 1103, 9, 211, 2);


--
-- TOC entry 2080 (class 0 OID 91714)
-- Dependencies: 175
-- Data for Name: dia; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO dia (cod_dia, nombre_dia) VALUES (1, 'LUNES');
INSERT INTO dia (cod_dia, nombre_dia) VALUES (2, 'MARTES');
INSERT INTO dia (cod_dia, nombre_dia) VALUES (3, 'MIERCOLES');
INSERT INTO dia (cod_dia, nombre_dia) VALUES (4, 'JUEVES');
INSERT INTO dia (cod_dia, nombre_dia) VALUES (5, 'VIERNES');


--
-- TOC entry 2082 (class 0 OID 91726)
-- Dependencies: 177
-- Data for Name: hora; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO hora (cod_hora, inicio, fin, duracion) VALUES (1, NULL, NULL, NULL);
INSERT INTO hora (cod_hora, inicio, fin, duracion) VALUES (2, NULL, NULL, NULL);
INSERT INTO hora (cod_hora, inicio, fin, duracion) VALUES (3, NULL, NULL, NULL);
INSERT INTO hora (cod_hora, inicio, fin, duracion) VALUES (4, NULL, NULL, NULL);
INSERT INTO hora (cod_hora, inicio, fin, duracion) VALUES (5, NULL, NULL, NULL);
INSERT INTO hora (cod_hora, inicio, fin, duracion) VALUES (6, NULL, NULL, NULL);

--
-- TOC entry 2084 (class 0 OID 91735)
-- Dependencies: 179
-- Data for Name: periodo; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO periodo (cod_periodo, dia, hora) VALUES (1, 1, 1);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (2, 1, 2);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (3, 1, 3);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (4, 1, 4);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (5, 1, 5);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (6, 1, 6);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (7, 2, 1);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (8, 2, 2);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (9, 2, 3);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (10, 2, 4);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (11, 2, 5);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (12, 2, 6);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (13, 3, 1);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (14, 3, 2);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (15, 3, 3);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (16, 3, 4);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (17, 3, 5);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (18, 3, 6);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (19, 4, 1);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (20, 4, 2);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (21, 4, 3);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (22, 4, 4);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (23, 4, 5);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (24, 4, 6);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (25, 5, 1);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (26, 5, 2);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (27, 5, 3);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (28, 5, 4);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (29, 5, 5);
INSERT INTO periodo (cod_periodo, dia, hora) VALUES (30, 5, 6);


--
-- TOC entry 2085 (class 0 OID 91740)
-- Dependencies: 181
-- Data for Name: pref_carga_periodo; Type: TABLE DATA; Schema: public; Owner: Administrador
--



--
-- TOC entry 2086 (class 0 OID 91743)
-- Dependencies: 182
-- Data for Name: pref_profesor_materia; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 701, 2);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 702, 2);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 703, 2);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 704, 2);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 801, 2);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 802, 2);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 803, 2);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 804, 2);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 601, 1);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 602, 1);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 603, 1);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 604, 1);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 701, 1);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 702, 1);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 703, 1);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 704, 1);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 701, 3);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 702, 3);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 703, 3);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 704, 3);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 901, 3);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 902, 3);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 903, 3);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 904, 3);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 905, 3);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (2, 1001, 4);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (2, 1002, 4);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (2, 1003, 4);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (2, 1004, 4);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (2, 1101, 4);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (2, 1102, 4);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (2, 1103, 4);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 701, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 702, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 703, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (1, 704, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (3, 1001, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (3, 1002, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (3, 1003, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (3, 1004, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (3, 1101, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (3, 1102, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (3, 1103, 5);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 601, 6);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 602, 6);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 603, 6);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 604, 6);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 601, 6);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 602, 6);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 603, 6);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 604, 6);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 701, 7);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 702, 7);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 703, 7);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 704, 7);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 701, 7);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 702, 7);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 703, 7);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 704, 7);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 801, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 802, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 803, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 804, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 601, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 602, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 603, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 604, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 701, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 702, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 703, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 704, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 901, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 902, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 903, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 904, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 905, 8);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 901, 9);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 902, 9);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 903, 9);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 904, 9);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (4, 905, 9);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1101, 9);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1102, 9);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1103, 9);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (5, 1001, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (5, 1002, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (5, 1003, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (5, 1004, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (5, 1101, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (5, 1102, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (5, 1103, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1001, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1002, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1003, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1004, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1101, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1102, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (6, 1103, 10);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 601, 11);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 602, 11);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 603, 11);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 604, 11);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 701, 11);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 702, 11);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 703, 11);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 704, 11);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 701, 12);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 702, 12);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 703, 12);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 704, 12);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 801, 12);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 802, 12);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 803, 12);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 804, 12);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 901, 13);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 902, 13);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 903, 13);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 904, 13);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 905, 13);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1001, 13);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1002, 13);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1003, 13);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1004, 13);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1001, 14);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1002, 14);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1003, 14);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1004, 14);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1101, 14);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1102, 14);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (8, 1103, 14);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 601, 15);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 602, 15);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 603, 15);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 604, 15);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 701, 15);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 702, 15);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 703, 15);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 704, 15);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 701, 16);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 702, 16);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 703, 16);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 704, 16);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 801, 16);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 802, 16);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 803, 16);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 804, 16);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 901, 17);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 902, 17);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 903, 17);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 904, 17);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 905, 17);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1001, 18);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1002, 18);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1003, 18);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1004, 18);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1101, 18);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1102, 18);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1103, 18);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 601, 19);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 602, 19);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 603, 19);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 604, 19);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 701, 19);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 702, 19);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 703, 19);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 704, 19);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 701, 20);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 702, 20);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 703, 20);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 704, 20);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 801, 20);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 802, 20);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 803, 20);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 804, 20);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 901, 21);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 902, 21);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 903, 21);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 904, 21);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 905, 21);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1001, 22);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1002, 22);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1003, 22);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1004, 22);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1101, 22);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1102, 22);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1103, 22);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1001, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1002, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1003, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (9, 1004, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 801, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 802, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 803, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 804, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1001, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1002, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1003, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (10, 1004, 23);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 601, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 602, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 603, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 604, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 701, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 702, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 703, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 704, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 801, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 802, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 803, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 804, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 901, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 902, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 903, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 904, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 905, 24);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 701, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 702, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 703, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 704, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 901, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 902, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 903, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 904, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 905, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 1001, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 1002, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 1003, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 1004, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 1101, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 1102, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (11, 1103, 25);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 601, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 602, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 603, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 604, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 701, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 702, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 703, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 704, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 801, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 802, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 803, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 804, 26);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 901, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 902, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 903, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 904, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 905, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 1001, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 1002, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 1003, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 1004, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 1101, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 1102, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (12, 1103, 27);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 801, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 802, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 803, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 804, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 701, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 702, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 703, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 704, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 801, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 802, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 803, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 804, 28);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 901, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 902, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 903, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 904, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 905, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 901, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 902, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 903, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 904, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 905, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 1001, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 1002, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 1003, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 1004, 29);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 801, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 802, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 803, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 804, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 601, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 602, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 603, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 604, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 701, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 702, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 703, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 704, 30);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 901, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 902, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 903, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 904, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (7, 905, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 901, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 902, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 903, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 904, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 905, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 1101, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 1102, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (13, 1103, 31);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 601, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 602, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 603, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 604, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 701, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 702, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 703, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 704, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 801, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 802, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 803, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 804, 32);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 901, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 902, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 903, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 904, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 905, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 1001, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 1002, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 1003, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 1004, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 1101, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 1102, 33);
INSERT INTO pref_profesor_materia (id_materia, id_curso, id_profesor) VALUES (14, 1103, 33);


--
-- TOC entry 2087 (class 0 OID 91746)
-- Dependencies: 183
-- Data for Name: pref_profesor_periodo; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (12, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (28, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (17, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (22, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (26, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (2, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (6, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (23, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (31, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (19, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (21, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (13, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (11, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (3, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (25, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (14, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (16, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (4, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (10, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (20, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 1);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 2);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 3);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 4);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 5);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 6);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 7);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 8);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (8, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (27, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (30, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (15, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 9);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 10);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 11);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (29, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (33, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (9, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (32, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 12);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (7, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (18, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 23);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 24);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (24, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 15);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 17);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 18);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (5, 30);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 13);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 14);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 16);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 19);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 20);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 21);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 22);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 25);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 26);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 27);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 28);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 29);
INSERT INTO pref_profesor_periodo (profesor, periodo) VALUES (1, 30);


--
-- TOC entry 2090 (class 0 OID 91764)
-- Dependencies: 187
-- Data for Name: restriccion_tipo; Type: TABLE DATA; Schema: public; Owner: Administrador
--

INSERT INTO restriccion_tipo (inicial, nombre) VALUES ('D', 'Obligatoria');
INSERT INTO restriccion_tipo (inicial, nombre) VALUES ('S', 'Deseada');
