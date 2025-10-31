--
-- PostgreSQL database dump
--

\restrict EXPl6pJgSGbg35LUwoC87ZvHI3LZPV4eq5zDZHpFag867XQtKqKZokTqe9aZHwj

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2025-10-30 23:40:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = on;

DROP DATABASE kronos;
--
-- TOC entry 5106 (class 1262 OID 25336)
-- Name: kronos; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE kronos WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_El Salvador.1252';


ALTER DATABASE kronos OWNER TO postgres;

\unrestrict EXPl6pJgSGbg35LUwoC87ZvHI3LZPV4eq5zDZHpFag867XQtKqKZokTqe9aZHwj
\connect kronos
\restrict EXPl6pJgSGbg35LUwoC87ZvHI3LZPV4eq5zDZHpFag867XQtKqKZokTqe9aZHwj

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = on;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 255 (class 1255 OID 25650)
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 25344)
-- Name: actividad_economica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actividad_economica (
    id character varying(25) NOT NULL,
    nombre_actividad_economica text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.actividad_economica OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25410)
-- Name: caja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja (
    id bigint NOT NULL,
    descripcion text,
    punto_venta_mh character varying(25),
    sucursal_id bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.caja OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25409)
-- Name: caja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_id_seq OWNER TO postgres;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 224
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_id_seq OWNED BY public.caja.id;


--
-- TOC entry 232 (class 1259 OID 25453)
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    id bigint NOT NULL,
    nombre_cliente character varying(255),
    no_registro character varying(25),
    nit character varying(25),
    dui character varying(25),
    telefono character varying(25),
    correo character varying(255),
    codigo_actividad_id character varying(25),
    direccion text,
    departamento_id character varying(4),
    municipio_id character varying(4),
    tipo_contribuyente_id bigint,
    estado integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 25452)
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_id_seq OWNER TO postgres;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 231
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;


--
-- TOC entry 226 (class 1259 OID 25423)
-- Name: contador_dte; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contador_dte (
    tipo_documento_id character varying(25),
    contador integer,
    anio integer,
    sucursal_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.contador_dte OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 25590)
-- Name: contingencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contingencia (
    id bigint NOT NULL,
    codigo_generacion character varying(255),
    sello_contingencia character varying(255),
    f_inicio date,
    f_fin date,
    tipo_contingencia_id bigint,
    motivo_contingencia text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.contingencia OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 25604)
-- Name: contingencia_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contingencia_detalle (
    id bigint NOT NULL,
    contingencia_id bigint,
    venta_id bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.contingencia_detalle OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 25603)
-- Name: contingencia_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contingencia_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contingencia_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 248
-- Name: contingencia_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contingencia_detalle_id_seq OWNED BY public.contingencia_detalle.id;


--
-- TOC entry 246 (class 1259 OID 25589)
-- Name: contingencia_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contingencia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contingencia_id_seq OWNER TO postgres;

--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 246
-- Name: contingencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contingencia_id_seq OWNED BY public.contingencia.id;


--
-- TOC entry 218 (class 1259 OID 25351)
-- Name: departamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departamento (
    id character varying(4) NOT NULL,
    nombre_departamento character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.departamento OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25367)
-- Name: empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empresa (
    id bigint NOT NULL,
    nombre_empresa character varying(255),
    telefono character varying(25),
    correo character varying(255),
    nombre_comercial character varying(255),
    no_registro character varying(25),
    nit character varying(25),
    dui character varying(25),
    codigo_actividad_id character varying(25),
    direccion text,
    departamento_id character varying(4),
    municipio_id character varying(4),
    tipo_contribuyente_id bigint,
    estado integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    representante_legal character varying(255)
);


ALTER TABLE public.empresa OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 25366)
-- Name: empresa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.empresa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.empresa_id_seq OWNER TO postgres;

--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 220
-- Name: empresa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.empresa_id_seq OWNED BY public.empresa.id;


--
-- TOC entry 253 (class 1259 OID 25630)
-- Name: invalidacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invalidacion (
    id bigint NOT NULL,
    codigo_generacion character varying(255),
    sello_invalidacion character varying(255),
    venta_id bigint,
    tipo_anulacion_id bigint,
    motivo_anulacion text,
    nombre_responsable character varying(250),
    tip_doc_responsable character varying(4),
    num_doc_responsable character varying(30),
    nombre_solicita character varying(250),
    tip_doc_solicita character varying(4),
    num_doc_solicita character varying(30),
    fec_anula date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.invalidacion OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 25629)
-- Name: invalidacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invalidacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invalidacion_id_seq OWNER TO postgres;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 252
-- Name: invalidacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invalidacion_id_seq OWNED BY public.invalidacion.id;


--
-- TOC entry 219 (class 1259 OID 25356)
-- Name: municipio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.municipio (
    id character varying(4) NOT NULL,
    nombre_municipio character varying(100) NOT NULL,
    departamento_id character varying(4),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    municipio_id character varying(4)
);


ALTER TABLE public.municipio OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 25719)
-- Name: parametro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parametro (
    nombre_parametro character varying(25) NOT NULL,
    valor text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.parametro OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 25487)
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    id bigint NOT NULL,
    descripcion text NOT NULL,
    precio numeric(12,2) DEFAULT 0,
    tipo character varying(20),
    veces_usado integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT producto_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['PRODUCTO'::character varying, 'SERVICIO'::character varying])::text[])))
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 25486)
-- Name: producto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_id_seq OWNER TO postgres;

--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 234
-- Name: producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;


--
-- TOC entry 228 (class 1259 OID 25427)
-- Name: rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol (
    id bigint NOT NULL,
    nombre_rol character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.rol OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25426)
-- Name: rol_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rol_id_seq OWNER TO postgres;

--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 227
-- Name: rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;


--
-- TOC entry 223 (class 1259 OID 25396)
-- Name: sucursal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sucursal (
    id bigint NOT NULL,
    nombre_sucursal character varying(25),
    direccion text,
    telefono character varying(25),
    correo character varying(255),
    establecimiento_mh character varying(25),
    estado integer,
    empresa_id bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sucursal OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25395)
-- Name: sucursal_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sucursal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sucursal_id_seq OWNER TO postgres;

--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 222
-- Name: sucursal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sucursal_id_seq OWNED BY public.sucursal.id;


--
-- TOC entry 245 (class 1259 OID 25581)
-- Name: tipo_contingencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_contingencia (
    id bigint NOT NULL,
    nombre text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tipo_contingencia OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 25580)
-- Name: tipo_contingencia_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_contingencia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_contingencia_id_seq OWNER TO postgres;

--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 244
-- Name: tipo_contingencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_contingencia_id_seq OWNED BY public.tipo_contingencia.id;


--
-- TOC entry 216 (class 1259 OID 25338)
-- Name: tipo_contribuyente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_contribuyente (
    id bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tipo_contribuyente OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 25337)
-- Name: tipo_contribuyente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_contribuyente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_contribuyente_id_seq OWNER TO postgres;

--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 215
-- Name: tipo_contribuyente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_contribuyente_id_seq OWNED BY public.tipo_contribuyente.id;


--
-- TOC entry 233 (class 1259 OID 25481)
-- Name: tipo_documento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_documento (
    id character varying(25) NOT NULL,
    nombre character varying(25),
    nombre_corto character varying(10),
    version_dte character varying(10),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tipo_documento OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 25621)
-- Name: tipo_invalidacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_invalidacion (
    id bigint NOT NULL,
    nombre text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tipo_invalidacion OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 25620)
-- Name: tipo_invalidacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_invalidacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_invalidacion_id_seq OWNER TO postgres;

--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 250
-- Name: tipo_invalidacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_invalidacion_id_seq OWNED BY public.tipo_invalidacion.id;


--
-- TOC entry 241 (class 1259 OID 25555)
-- Name: tipo_pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_pago (
    id bigint NOT NULL,
    nombre character varying(255),
    estado integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tipo_pago OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 25554)
-- Name: tipo_pago_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_pago_id_seq OWNER TO postgres;

--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 240
-- Name: tipo_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_pago_id_seq OWNED BY public.tipo_pago.id;


--
-- TOC entry 230 (class 1259 OID 25434)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id bigint NOT NULL,
    username character varying(25),
    password character varying(255),
    rol_id bigint,
    caja_id bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25433)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_seq OWNER TO postgres;

--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 229
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- TOC entry 237 (class 1259 OID 25499)
-- Name: venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta (
    id bigint NOT NULL,
    usuario_id bigint NOT NULL,
    tipo_documento_id character varying(25) NOT NULL,
    cliente_id bigint NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    codigo_generacion character varying(100),
    numero_control character varying(100),
    sello_mh character varying(100),
    subtotal numeric(12,2) DEFAULT 0 NOT NULL,
    descuento numeric(12,2) DEFAULT 0 NOT NULL,
    iva numeric(12,2) DEFAULT 0 NOT NULL,
    retencion numeric(12,2) DEFAULT 0 NOT NULL,
    percepcion numeric(12,2) DEFAULT 0 NOT NULL,
    total numeric(12,2) DEFAULT 0 NOT NULL,
    codigo_generacion_contingencia character varying(100) DEFAULT ''::character varying,
    codigo_generacion_anulacion character varying(100) DEFAULT ''::character varying,
    intentos integer DEFAULT 0,
    estado integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    nombre_factura character varying(255),
    tipo_doc_factura character varying(255),
    doc_factura character varying(255),
    venta_id_nc bigint,
    correo character varying(255),
    contingencia smallint
);


ALTER TABLE public.venta OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 25534)
-- Name: venta_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta_detalle (
    id bigint NOT NULL,
    venta_id bigint NOT NULL,
    producto_id bigint NOT NULL,
    cantidad numeric(12,2) DEFAULT 1 NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    descuento numeric(12,2) DEFAULT 0 NOT NULL,
    iva numeric(12,2) DEFAULT 0 NOT NULL,
    total_linea numeric(12,2) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    sub_total numeric(12,2)
);


ALTER TABLE public.venta_detalle OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 25533)
-- Name: venta_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.venta_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.venta_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 238
-- Name: venta_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.venta_detalle_id_seq OWNED BY public.venta_detalle.id;


--
-- TOC entry 236 (class 1259 OID 25498)
-- Name: venta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.venta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.venta_id_seq OWNER TO postgres;

--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 236
-- Name: venta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.venta_id_seq OWNED BY public.venta.id;


--
-- TOC entry 243 (class 1259 OID 25563)
-- Name: venta_pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta_pago (
    id bigint NOT NULL,
    venta_id bigint,
    tipo_pago_id bigint,
    estado integer DEFAULT 1,
    valor numeric(12,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.venta_pago OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 25562)
-- Name: venta_pago_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.venta_pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.venta_pago_id_seq OWNER TO postgres;

--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 242
-- Name: venta_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.venta_pago_id_seq OWNED BY public.venta_pago.id;


--
-- TOC entry 4754 (class 2604 OID 25729)
-- Name: caja id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja ALTER COLUMN id SET DEFAULT nextval('public.caja_id_seq'::regclass);


--
-- TOC entry 4765 (class 2604 OID 25754)
-- Name: cliente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);


--
-- TOC entry 4807 (class 2604 OID 25785)
-- Name: contingencia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia ALTER COLUMN id SET DEFAULT nextval('public.contingencia_id_seq'::regclass);


--
-- TOC entry 4810 (class 2604 OID 25810)
-- Name: contingencia_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia_detalle ALTER COLUMN id SET DEFAULT nextval('public.contingencia_detalle_id_seq'::regclass);


--
-- TOC entry 4748 (class 2604 OID 25835)
-- Name: empresa id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa ALTER COLUMN id SET DEFAULT nextval('public.empresa_id_seq'::regclass);


--
-- TOC entry 4816 (class 2604 OID 25866)
-- Name: invalidacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion ALTER COLUMN id SET DEFAULT nextval('public.invalidacion_id_seq'::regclass);


--
-- TOC entry 4770 (class 2604 OID 25902)
-- Name: producto id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);


--
-- TOC entry 4759 (class 2604 OID 25923)
-- Name: rol id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);


--
-- TOC entry 4751 (class 2604 OID 25935)
-- Name: sucursal id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal ALTER COLUMN id SET DEFAULT nextval('public.sucursal_id_seq'::regclass);


--
-- TOC entry 4804 (class 2604 OID 25966)
-- Name: tipo_contingencia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contingencia ALTER COLUMN id SET DEFAULT nextval('public.tipo_contingencia_id_seq'::regclass);


--
-- TOC entry 4739 (class 2604 OID 25980)
-- Name: tipo_contribuyente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contribuyente ALTER COLUMN id SET DEFAULT nextval('public.tipo_contribuyente_id_seq'::regclass);


--
-- TOC entry 4813 (class 2604 OID 25997)
-- Name: tipo_invalidacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_invalidacion ALTER COLUMN id SET DEFAULT nextval('public.tipo_invalidacion_id_seq'::regclass);


--
-- TOC entry 4796 (class 2604 OID 26011)
-- Name: tipo_pago id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_pago ALTER COLUMN id SET DEFAULT nextval('public.tipo_pago_id_seq'::regclass);


--
-- TOC entry 4762 (class 2604 OID 26028)
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- TOC entry 4775 (class 2604 OID 26061)
-- Name: venta id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta ALTER COLUMN id SET DEFAULT nextval('public.venta_id_seq'::regclass);


--
-- TOC entry 4789 (class 2604 OID 26126)
-- Name: venta_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_detalle ALTER COLUMN id SET DEFAULT nextval('public.venta_detalle_id_seq'::regclass);


--
-- TOC entry 4800 (class 2604 OID 26151)
-- Name: venta_pago id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_pago ALTER COLUMN id SET DEFAULT nextval('public.venta_pago_id_seq'::regclass);


--
-- TOC entry 5063 (class 0 OID 25344)
-- Dependencies: 217
-- Data for Name: actividad_economica; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01111', 'Cultivo de cereales excepto arroz y para forrajes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01112', 'Cultivo de legumbres', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01113', 'Cultivo de semillas oleaginosas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01114', 'Cultivo de plantas para la preparación de semillas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01119', 'Cultivo de otros cereales excepto arroz y forrajeros n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01120', 'Cultivo de arroz', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01131', 'Cultivo de raíces y tubérculos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01132', 'Cultivo de brotes, bulbos, vegetales tubérculos y cultivos similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01133', 'Cultivo horticola de fruto', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01134', 'Cultivo de hortalizas de hoja y otras hortalizas ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01140', 'Cultivo de caña de azucar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01150', 'Cultivo de tabaco', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01161', 'Cultivo de algodón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01162', 'Cultivo de fibras vegetales excepto algodón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01191', 'Cultivo de plantas no perennes para la producción de semillas y flores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01192', 'Cultivo de cereales y pastos para la alimentación animal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01199', 'Producción de cultivos no estacionales ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01220', 'Cultivo de frutas tropicales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01230', 'Cultivo de cítricos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01240', 'Cultivo de frutas de pepita y hueso', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01251', 'Cultivo de frutas ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01252', 'Cultivo de otros frutos y nueces de árboles y arbustos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01260', 'Cultivo de frutos oleaginosos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01271', 'Cultivo de café', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01272', 'Cultivo de plantas para la elaboración de bebidas excepto café', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01281', 'Cultivo de especias y aromáticas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01282', 'Cultivo de plantas para la obtención de productos medicinales y farmacéuticos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01291', 'Cultivo de árboles de hule (caucho) para la obtención de látex', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01292', 'Cultivo de plantas para la obtención de productos químicos y colorantes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01299', 'Producción de cultivos perennes ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01300', 'Propagación de plantas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01301', 'Cultivo de plantas y flores ornamentales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01410', 'Cría y engorde de ganado bovino', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01420', 'Cría de caballos y otros equinos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01440', 'Cría de ovejas y cabras', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01450', 'Cría de cerdos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01460', 'Cría de aves de corral y producción de huevos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01491', 'Cría de abejas apicultura para la obtención de miel y otros productos apícolas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01492', 'Cría de conejos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01493', 'Cría de iguanas y garrobos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01494', 'Cría de mariposas y otros insectos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01499', 'Cría y obtención de productos animales n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01500', 'Cultivo de productos agrícolas en combinación con la cría de animales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01611', 'Servicios de maquinaria agrícola', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01612', 'Control de plagas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01613', 'Servicios de riego', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01614', 'Servicios de contratación de mano de obra para la agricultura', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01619', 'Servicios agrícolas ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01621', 'Actividades para mejorar la reproducción, el crecimiento y el rendimiento de los animales y sus productos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01622', 'Servicios de mano de obra pecuaria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01629', 'Servicios pecuarios ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01631', 'Labores post cosecha de preparación de los productos agrícolas para su comercialización o para la industria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01632', 'Servicio de beneficio de café', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01633', 'Servicio de beneficiado de plantas textiles (incluye el beneficiado cuando este es realizado en la misma explotación agropecuaria)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01640', 'Tratamiento de semillas para la propagación', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('01700', 'Caza ordinaria y mediante trampas, repoblación de animales de caza y servicios conexos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('02100', 'Silvicultura y otras actividades forestales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('02200', 'Extracción de madera', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('02300', 'Recolección de productos diferentes a la madera', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('02400', 'Servicios de apoyo a la silvicultura', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('03110', 'Pesca marítima de altura y costera', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('03120', 'Pesca de agua dulce', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('03210', 'Acuicultura marítima', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('03220', 'Acuicultura de agua dulce', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('03300', 'Servicios de apoyo a la pesca y acuicultura', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('05100', 'Extracción de hulla', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('05200', 'Extracción y aglomeración de lignito', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('06100', 'Extracción de petróleo crudo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('06200', 'Extracción de gas natural', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('07100', 'Extracción de minerales de hierro', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('07210', 'Extracción de minerales de uranio y torio', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('07290', 'Extracción de minerales metalíferos no ferrosos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('08100', 'Extracción de piedra, arena y arcilla', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('08910', 'Extracción de minerales para la fabricación de abonos y productos quimicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('08920', 'Extracción y aglomeración de turba', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('08930', 'Extracción de sal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('08990', 'Explotación de otras minas y canteras ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('09100', 'Actividades de apoyo a la extracción de petróleo y gas natural', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('09900', 'Actividades de apoyo a la explotación de minas y canteras', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10101', 'Servicio de rastros y mataderos de bovinos y porcinos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10102', 'Matanza y procesamiento de bovinos y porcinos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10103', 'Matanza y procesamientos de aves de corral', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10104', 'Elaboración y conservación de embutidos y tripas naturales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10105', 'Servicios de conservación y empaque de carnes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10106', 'Elaboración y conservación de grasas y aceites animales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10107', 'Servicios de molienda de carne', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10108', 'Elaboración de productos de carne ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10201', 'Procesamiento y conservación de pescado, crustáceos y moluscos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10209', 'Fabricación de productos de pescado ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10301', 'Elaboración de jugos de frutas y hortalizas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10302', 'Elaboración y envase de jaleas, mermeladas y frutas deshidratadas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10309', 'Elaboración de productos de frutas y hortalizas n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10401', 'Fabricación de aceites y grasas vegetales y animales comestibles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10402', 'Fabricación de aceites y grasas vegetales y animales no comestibles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10409', 'Servicio de maquilado de aceites', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10501', 'Fabricación de productos lácteos excepto sorbetes y quesos sustitutos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10502', 'Fabricación de sorbetes y helados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10503', 'Fabricación de quesos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10611', 'Molienda de cereales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10612', 'Elaboración de cereales para el desayuno y similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10613', 'Servicios de beneficiado de productos agrícolas ncp (excluye Beneficio de azúcar rama 1072 y beneficio de café rama 0163)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10621', 'Fabricación de almidón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10628', 'Servicio de molienda de maíz húmedo molino para nixtamal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10711', 'Elaboración de tortillas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10712', 'Fabricación de pan, galletas y barquillos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10713', 'Fabricación de repostería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10721', 'Ingenios azucareros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10722', 'Molienda de caña de azúcar para la elaboración de dulces', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10723', 'Elaboración de jarabes de azúcar y otros similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10724', 'Maquilado de azúcar de caña', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10730', 'Fabricación de cacao, chocolates y productos de confitería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10740', 'Elaboración de macarrones, fideos, y productos farináceos similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10750', 'Elaboración de comidas y platos preparados para la reventa en', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10791', 'Elaboración de productos de café', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10792', 'Elaboración de especies, sazonadores y condimentos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10793', 'Elaboración de sopas, cremas y consomé', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10794', 'Fabricación de bocadillos tostados y/o fritos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10799', 'Elaboración de productos alimenticios ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10800', 'Elaboración de alimentos preparados para animales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('11012', 'Fabricación de aguardiente y licores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('11020', 'Elaboración de vinos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('11030', 'Fabricacion de cerveza', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('11041', 'Fabricación de aguas gaseosas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('11042', 'Fabricación y envasado de agua', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('11043', 'Elaboración de refrescos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('11048', 'Maquilado de aguas gaseosas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('11049', 'Elaboración de bebidas no alcohólicas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('12000', 'Elaboración de productos de tabaco', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13111', 'Preparación de fibras textiles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13112', 'Fabricación de hilados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13120', 'Fabricación de telas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13130', 'Acabado de productos textiles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13910', 'Fabricación de tejidos de punto y ganchillo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13921', 'Fabricación de productos textiles para el hogar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13922', 'Sacos, bolsas y otros artículos textiles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13929', 'Fabricación de artículos confeccionados con materiales textiles, excepto prendas de vestir n.c.p', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13930', 'Fabricación de tapices y alfombras', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13941', 'Fabricación de cuerdas de henequén y otras fibras naturales (lazos, pitas)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13942', 'Fabricación de redes de diversos materiales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13948', 'Maquilado de productos trenzables de cualquier material (petates, sillas, etc.)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13991', 'Fabricación de adornos, etiquetas y otros artículos para prendas de vestir', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13992', 'Servicio de bordados en artículos y prendas de tela', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('13999', 'Fabricación de productos textiles ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14101', 'Fabricación de ropa interior, para dormir y similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14102', 'Fabricación de ropa para niños', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14103', 'Fabricación de prendas de vestir para ambos sexos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14104', 'Confección de prendas a medida', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14105', 'Fabricación de prendas de vestir para deportes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14106', 'Elaboración de artesanías de uso personal confeccionadas especialmente de materiales textiles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14108', 'Maquilado de prendas de vestir, accesorios y otros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14109', 'Fabricación de prendas y accesorios de vestir n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14200', 'Fabricación de artículos de piel', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14301', 'Fabricación de calcetines, calcetas, medias (panty house) y otros similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14302', 'Fabricación de ropa interior de tejido de punto', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('14309', 'Fabricación de prendas de vestir de tejido de punto ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('15110', 'Curtido y adobo de cueros; adobo y teñido de pieles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('15121', 'Fabricación de maletas, bolsos de mano y otros artículos de marroquinería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('15122', 'Fabricación de monturas, accesorios y vainas talabartería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('15123', 'Fabricación de artesanías principalmente de cuero natural y sintético', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('15128', 'Maquilado de artículos de cuero natural, sintético y de otros materiales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('15201', 'Fabricación de calzado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('15202', 'Fabricación de partes y accesorios de calzado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('15208', 'Maquilado de partes y accesorios de calzado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('16100', 'Aserradero y acepilladura de madera', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('16210', 'Fabricación de madera laminada, terciada, enchapada y contrachapada, paneles para la construcción', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('16220', 'Fabricación de partes y piezas de carpintería para edificios y construcciones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('16230', 'Fabricacion de envases y recipientes de madera', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('16292', 'Fabricación de artesanías de madera, semillas, materiales trenzables', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('16299', 'Fabricación de productos de madera, corcho, paja y materiales trenzables ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('17010', 'Fabricación de pasta de madera, papel y cartón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('17020', 'Fabricación de papel y cartón ondulado y envases de papel y cartón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('17091', 'Fabricación de artículos de papel y cartón de uso personal y doméstico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('17092', 'Fabricación de productos de papel ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('18110', 'Impresión', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('18120', 'Servicios relacionados con la impresión', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('18200', 'Reproducción de grabaciones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('19100', 'Fabricación de productos de hornos de coque', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('19201', 'Fabricación de combustible', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('19202', 'Fabricación de aceites y lubricantes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20111', 'Fabricación de materias primas para la fabricación de colorantes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20112', 'Fabricación de materiales curtientes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20113', 'Fabricación de gases industriales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20114', 'Fabricación de alcohol etilico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20119', 'Fabricación de sustancias químicas básicas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20120', 'Fabricación de abonos y fertilizantes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20130', 'Fabricación de plástico y caucho en formas primarias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20210', 'Fabricación de plaguicidas y otros productos químicos de uso agropecuario', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20220', 'Fabricación de pinturas, barnices y productos de revestimiento similares; tintas de imprenta y masillas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20231', 'Fabricación de jabones, detergentes y similares para limpieza', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20232', 'Fabricación de perfumes, cosméticos y productos de higiene y cuidado personal, incluyendo tintes, champú, etc.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20291', 'Fabricación de tintas y colores para escribir y pintar; fabricación de cintas para impresoras', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20292', 'Fabricación de productos pirotécnicos, explosivos y municiones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20299', 'Fabricación de productos químicos n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('20300', 'Fabricación de fibras artificiales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('21001', 'Manufactura de productos farmacéuticos, sustancias químicas y productos botánicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('21008', 'Maquilado de medicamentos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('22110', 'Fabricación de cubiertas y cámaras; renovación y recauchutado de cubiertas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('22190', 'Fabricacion de otros productos de caucho', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('22201', 'Fabricacion de envases plasticos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('22202', 'Fabricación de productos plasticos para uso personal o doméstico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('22208', 'Maquila de plásticos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('22209', 'Fabricación de productos plásticos n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23101', 'Fabricación de vidrio', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23102', 'Fabricación de recipientes y envases de vidrio', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23108', 'Servicio de maquilado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23109', 'Fabricación de productos de vidrio ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23910', 'Fabricacion de productos refractarios', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23920', 'Fabricación de productos de arcilla para la construcción', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23931', 'Fabricación de productos de cerámica y porcelana no refractaria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23932', 'Fabricación de productos de cerámica y porcelana ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23940', 'Fabricación de cemento, cal y yeso', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23950', 'Fabricación de artículos de hormigón, cemento y yeso', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23960', 'Corte, tallado y acabado de la piedra', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('23990', 'Fabricación de productos minerales no metálicos ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('24100', 'Industrias básicas de hierro y acero', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('24200', 'Fabricación de productos primarios de metales preciosos y metales no ferrosos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('24310', 'Fundición de hierro y acero', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('24320', 'Fundición de metales no ferrosos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25111', 'Fabricación de productos metálicos para uso estructural', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25118', 'Servicio de maquila para la fabricación de estructuras metálicas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25120', 'Fabricación de tanques, depósitos y recipientes de metal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25130', 'Fabricación de generadores de vapor, excepto calderas de agua caliente para calefacción central', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25200', 'Fabricación de armas y municiones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25910', 'Forjado, prensado, estampado y laminado de metales; pulvimetalurgia', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25920', 'Tratamiento y revestimiento de metales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25930', 'Fabricación de artículos de cuchillería, herramientas de mano y artículos de ferretería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25991', 'Fabricación de envases y artículos conexos de metal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25992', 'Fabricación de artículos metálicos de uso personal y/o doméstico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('25999', 'Fabricación de productos elaborados de metal ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('26100', 'Fabricación de componentes electrónicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('26200', 'Fabricación de computadoras y equipo conexo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('26300', 'Fabricación de equipo de comunicaciones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('26400', 'Fabricación de aparatos electrónicos de consumo para audio, video radio y televisión', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('26510', 'Fabricación de instrumentos y aparatos para medrr, verificar, ensayar, navegar y de control de procesos industriales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('26520', 'Fabricación de relojes y piezas de relojes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('26600', 'Fabricación de equipo médico de irradiación y equipo electrónico de uso médico y terapéutico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('26700', 'Fabricación de instrumentos de óptica y equipo fotográfico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('26800', 'Fabricación de medios magnéticos y ópticos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('27100', 'Fabricación de motores, generadores, transformadores eléctricos, aparatos de distribución y control de electricidad', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('27200', 'Fabricación de pilas, baterías y acumuladores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('27310', 'Fabricación de cables de fibra óptica', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('27320', 'Fabricación de otros hilos y cables eléctricos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('27330', 'Fabricación de dispositivos de cableados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('27400', 'Fabricación de equipo eléctrico de iluminación', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('27500', 'Fabricación de aparatos de uso doméstico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('27900', 'Fabricación de otros tipos de equipo eléctrico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28110', 'Fabricación de motores y turbinas, excepto motores para aeronaves, vehículos automotores y motocicletas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28120', 'Fabricación de equipo hidráulico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28130', 'Fabricación de otras bombas, compresores, grifos y válvulas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28140', 'Fabricación de cojinetes, engranajes, trenes de engranajes y piezas de transmisión', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28150', 'Fabricación de hornos y quemadores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28160', 'Fabricación de equipo de elevación y manipulación', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28170', 'Fabricación de maquinaria y equipo de oficina', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28180', 'Fabricación de herramientas manuales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28190', 'Fabricación de otros tipos de maquinaria de uso general', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28210', 'Fabricación de maquinaria agropecuaria y forestal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28220', 'Fabricación de máquinas para conformar metales y maquinaria herramienta', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28230', 'Fabricación de maquinaria metalúrgica', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28240', 'Fabricación de maquinaria para la explotación de minas y canteras y para obras de construcción', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28250', 'Fabricación de maquinaria para la elaboración de alimentos, bebidas y tabaco', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28260', 'Fabricación de maquinaria para la elaboración de productos textiles, prendas de vestir y cueros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28291', 'Fabricación de máquinas para imprenta', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('28299', 'Fabricación de maquinaria de uso especial ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('29100', 'Fabricación vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('29200', 'Fabricación de carrocerías para vehículos automotores; fabricación de remolques y semiremolques', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('29300', 'Fabricación de partes, piezas y accesorios para vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('30110', 'Fabricación de buques', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('30120', 'Construcción y reparación de embarcaciones de recreo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('30200', 'Fabricación de locomotoras y de material rodante', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('30300', 'Fabricación de aeronaves y naves espaciales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('30400', 'Fabricación de vehículos militares de combate', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('30910', 'Fabricación de motocicletas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('30920', 'Fabricación de bicicletas y sillones de ruedas para inválidos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('30990', 'Fabricación de equipo de transporte ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('31001', 'Fabricación de colchones y somier', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('31002', 'Fabricación de muebles y otros productos de madera a medida', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('31008', 'Servicios de maquilado de muebles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('31009', 'Fabricación de muebles ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32110', 'Fabricación de joyas platerías y joyerías', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32120', 'Fabricación de joyas de imitación (fantasía) y artículos conexos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32200', 'Fabricación de instrumentos musicales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32301', 'Fabricación de artículos de deporte', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32308', 'Servicio de maquila de productos deportivos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32401', 'Fabricación de juegos de mesa y de salón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32402', 'Servicio de maquilado de juguetes y juegos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32409', 'Fabricación de juegos y juguetes n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32500', 'Fabricación de instrumentos y materiales médicos y odontológicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32901', 'Fabricación de lápices, bolígrafos, sellos y artículos de librería en general', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32902', 'Fabricación de escobas, cepillos, pinceles y similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32903', 'Fabricación de artesanías de materiales diversos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32904', 'Fabricación de artículos de uso personal y domésticos n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32905', 'Fabricación de accesorios para las confecciones y la marroquinería n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32908', 'Servicios de maquila ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('32909', 'Fabricacion de productos manufacturados n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('33110', 'Reparación y mantenimiento de productos elaborados de metal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('33120', 'Reparación y mantenimiento de maquinaria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('33130', 'Reparación y mantenimiento de equipo electrónico y óptico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('33140', 'Reparación y mantenimiento de equipo eléctrico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('33150', 'Reparación y mantenimiento de equipo de transporte, excepto vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('33190', 'Reparación y mantenimiento de equipos n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('33200', 'Instalación de maquinaria y equipo industrial', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('35101', 'Generación de energía eléctrica', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('35102', 'Transmision de energía eléctrica', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('35103', 'Distribución de energía eléctrica', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('35200', 'Fabricación de gas, distribución de combustibles gaseosos por tuberías', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('35300', 'Suministro de vapor y agua caliente', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('36000', 'Captación, tratamiento y suministro de agua', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('37000', 'Evacuación de aguas residuales (alcantarillado)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38110', 'Recolección y transporte de desechos sólidos proveniente de hogares y sector urbano', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38120', 'Recolección de desechos peligrosos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38210', 'Tratamiento y eliminación de desechos inicuos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38220', 'Tratamiento y eliminación de desechos peligrosos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38301', 'Reciclaje de desperdicios y desechos textiles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38302', 'Reciclaje de desperdicios y desechos de plástico y caucho', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38303', 'Reciclaje de desperdicios y desechos de vidrio', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38304', 'Reciclaje de desperdicios y desechos de papel y cartón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38305', 'Reciclaje de desperdicios y desechos metálicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('38309', 'Reciclaje de desperdicios y desechos no metálicos n.c.p', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('39000', 'Actividades de Saneamiento y otros Servicios de Gestión de Desechos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('41001', 'Construcción de edificios residenciales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('41002', 'Construcción de edificios no residenciales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('42100', 'Construcción de carreteras, calles y caminos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('42200', 'Construcción de proyectos de servicio público', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('42900', 'Construcción de obras de ingeniería civil n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('43110', 'Demolición', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('43120', 'Preparación de terreno', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('43210', 'Instalaciones eléctricas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('43220', 'Instalación de fontanería, calefacción y aire acondicionado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('43290', 'Otras instalaciones para obras de construcción', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('43300', 'Terminacion y acabado de edificios', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('43900', 'Otras actividades especializadas de construcción', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('43901', 'Fabricación de techos y materiales diversos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45100', 'Venta de vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45201', 'Reparación mecánica de vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45202', 'Reparaciones eléctricas del automotor y recarga de baterías', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45203', 'Enderezado y pintura de vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45204', 'Reparaciones de radiadores, escapes y silenciadores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45205', 'Reparación y reconstrucción de vías, stop y otros artículos de fibra de vidrio', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45206', 'Reparación de llantas de vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45207', 'Polarizado de vehículos (mediante la adhesión de papel especial a los vidrios)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45208', 'Lavado y pasteado de vehículos (carwash)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45209', 'Reparaciones de vehículos n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45211', 'Remolque de vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45301', 'Venta de partes, piezas y accesorios nuevos para vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45302', 'Venta de partes, piezas y accesorios usados para vehículos automotores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45401', 'Venta de motocicletas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45402', 'Venta de repuestos, piezas y accesorios de motocicletas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('45403', 'Mantenimiento y reparación de motocicletas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46100', 'Venta al por mayor a cambio de retribución o por contrata', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46201', 'Venta al por mayor de materias primas agrícolas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46202', 'Venta al por mayor de productos de la silvicultura', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46203', 'Venta al por mayor de productos pecuarios y de granja', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46211', 'Venta de productos para uso agropecuario', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46291', 'Venta al por mayor de granos básicos (cereales, leguminosas)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46292', 'Venta al por mayor de semillas mejoradas para cultivo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46293', 'Venta al por mayor de café oro y uva', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46294', 'Venta al por mayor de caña de azúcar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46295', 'Venta al por mayor de flores, plantas y otros productos naturales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46296', 'Venta al por mayor de productos agrícolas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46297', 'Venta al por mayor de ganado bovino (vivo)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46298', 'Venta al por mayor de animales porcinos, ovinos, caprino, canículas, apícolas, avícolas vivos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46299', 'Venta de otras especies vivas del reino animal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46301', 'Venta al por mayor de alimentos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46302', 'Venta al por mayor de bebidas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46303', 'Venta al por mayor de tabaco', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46371', 'Venta al por mayor de frutas, hortalizas (verduras), legumbres y tubérculos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46372', 'Venta al por mayor de pollos, gallinas destazadas, pavos y otras aves', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46373', 'Venta al por mayor de carne bovina y porcina, productos de carne y embutidos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46374', 'Venta al por mayor de huevos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46375', 'Venta al por mayor de productos lácteos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46376', 'Venta al por mayor de productos farináceos de panadería (pan dulce, cakes, respostería, etc.)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46377', 'Venta al por mayor de pastas alimenticias, aceites y grasas comestibles vegetal y animal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46378', 'Venta al por mayor de sal comestible', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46379', 'Venta al por mayor de azúcar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46391', 'Venta al por mayor de abarrotes (vinos, licores, productos alimenticios envasados, etc.)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46392', 'Venta al por mayor de aguas gaseosas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46393', 'Venta al por mayor de agua purificada', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46394', 'Venta al por mayor de refrescos y otras bebidas, liquidas o en polvo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46395', 'Venta al por mayor de cerveza y licores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46396', 'Venta al por mayor de hielo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46411', 'Venta al por mayor de hilados, tejidos y productos textiles de mercería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46412', 'Venta al por mayor de articulos textiles excepto confecciones para el hogar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46413', 'Venta al por mayor de confecciones textiles para el hogar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46414', 'Venta al por mayor de prendas de vestir y accesorios de vestir', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46415', 'Venta al por mayor de ropa usada', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46416', 'Venta al por mayor de calzado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46417', 'Venta al por mayor de artículos de marroquinería y talabartería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46418', 'Venta al por mayor de articulos de peleteria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46419', 'Venta al por mayor de otros artículos textiles n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46471', 'Venta al por mayor de instrumentos musicales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46472', 'Venta al por mayor de colchones, almohadas, cojines, etc.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46473', 'Venta al por mayor de artículos de aluminio para el hogar y para otros usos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46474', 'Venta al por mayor de depósitos y otros artículos plásticos para el hogar y otros usos, incluyendo los desechables de durapax y no desechables', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46475', 'Venta al por mayor de cámaras fotográficas, accesorios y materiales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46482', 'Venta al por mayor de medicamentos, artículos y otros productos de uso veterinario', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46483', 'Venta al por mayor de productos y artículos de belleza y de uso personal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46484', 'Venta de productos farmacéuticos y medicinales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46491', 'Venta al por mayor de productos medicinales, cosméticos, perfumería y productos de limpieza', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46492', 'Venta al por mayor de relojes y artículos de joyería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46493', 'Venta al por mayor de electrodomésticos y artículos del hogar excepto bazar; artículos de iluminación', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46494', 'Venta al por mayor de artículos de bazar y similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46495', 'Venta al por mayor de artículos de óptica', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46496', 'Venta al por mayor de revistas, periódicos, libros, artículos de librería y artículos de papel y cartón en general', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46497', 'Venta de artículos deportivos, juguetes y rodados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46498', 'Venta al por mayor de productos usados para el hogar o el uso personal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46499', 'Venta al por mayor de enseres domésticos y de uso personal n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46500', 'Venta al por mayor de bicicletas, partes, accesorios y otros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46510', 'Venta al por mayor de computadoras, equipo periférico y programas informáticos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46520', 'Venta al por mayor de equipos de comunicación', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46530', 'Venta al por mayor de maquinaria y equipo agropecuario, accesorios, partes y suministros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46590', 'Venta de equipos e instrumentos de uso profesional y científico y aparatos de medida y control', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46591', 'Venta al por mayor de maquinaria equipo, accesorios y materiales para la industria de la madera y sus productos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46592', 'Venta al por mayor de maquinaria, equipo, accesorios y materiales para la industria gráfica y del papel, cartón y productos de papel y cartón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46593', 'Venta al por mayor de maquinaria, equipo, accesorios y materiales para la industria de productos químicos, plástico y caucho', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46594', 'Venta al por mayor de maquinaria, equipo, accesorios y materiales para la industria metálica y de sus productos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46595', 'Venta al por mayor de equipamiento para uso médico, odontológico, veterinario y servicios conexos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46596', 'Venta al por mayor de maquinaria, equipo, accesorios y partes para la industria de la alimentación', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46597', 'Venta al por mayor de maquinaria, equipo, accesorios y partes para la industria textil, confecciones y cuero', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46598', 'Venta al por mayor de maquinaria, equipo y accesorios para la construcción y explotación de minas y canteras', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46599', 'Venta al por mayor de otro tipo de maquinaria y equipo con sus accesorios y partes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46610', 'Venta al por mayor de otros combustibles sólidos, líquidos, gaseosos y de productos conexos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46612', 'Venta al por mayor de combustibles para automotores, aviones, barcos, maquinaria y otros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46613', 'Venta al por mayor de lubricantes, grasas y otros aceites para automotores, maquinaria industrial, etc.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46614', 'Venta al por mayor de gas propano', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46615', 'Venta al por mayor de leña y carbón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46620', 'Venta al por mayor de metales y minerales metaliferos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46631', 'Venta al por mayor de puertas, ventanas, vitrinas y similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46632', 'Venta al por mayor de artículos de ferretería y pinturerías', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46633', 'Vidrierías', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46634', 'Venta al por mayor de maderas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46639', 'Venta al por mayor de materiales para la construcción n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46691', 'Venta al por mayor de sal industrial sin yodar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46692', 'Venta al por mayor de productos intermedios y desechos de origen textil', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46693', 'Venta al por mayor de productos intermedios y desechos de origen metálico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46694', 'Venta al por mayor de productos intermedios y desechos de papel y cartón', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46695', 'Venta al por mayor fertilizantes, abonos, agroquímicos y productos similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46696', 'Venta al por mayor de productos intermedios y desechos de origen plástico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46697', 'Venta al por mayor de tintas para imprenta, productos curtientes y materias y productos colorantes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46698', 'Venta de productos intermedios y desechos de origen químico y de caucho', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46699', 'Venta al por mayor de productos intermedios y desechos ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46701', 'Venta de algodón en oro', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46900', 'Venta al por mayor de otros productos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46901', 'Venta al por mayor de cohetes y otros productos pirotécnicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46902', 'Venta al por mayor de artículos diversos para consumo humano', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46903', 'Venta al por mayor de armas de fuego, municiones y accesorios', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46904', 'Venta al por mayor de toldos y tiendas de campafia de cualquier material', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46905', 'Venta al por mayor de exhibidores publicitarios y rótulos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('46906', 'Venta al por mayor de artículos promocionales diversos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47111', 'Venta en supermercados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47112', 'Venta en tiendas de artículos de primera necesidad', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47119', 'Almacenes (venta de diversos artículos)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47190', 'Venta al por menor de otros productos en comercios no especializados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47199', 'Venta de establecimientos no especializados con surtido compuesto principalmente de alimentos, bebidas y tabaco', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47211', 'Venta al por menor de frutas y hortalizas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47212', 'Venta al por menor de carnes, embutidos y productos de granja', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47213', 'Venta al por menor de pescado y mariscos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47214', 'Venta al por menor de productos lácteos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47215', 'Venta al por menor de productos de panadería, repostería y galletas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47216', 'Venta al por menor de huevos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47217', 'Venta al por menor de carnes y productos cárnicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47218', 'Venta al por menor de granos básicos y otros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47219', 'Venta al por menor de alimentos n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47221', 'Venta al por menor de hielo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47223', 'Venta de bebidas no alcohólicas, para su consumo fuera del establecimiento', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47224', 'Venta de bebidas alcohólicas, para su consumo fuera del establecimiento', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47225', 'Venta de bebidas alcohólicas para su consumo dentro del establecimiento', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47230', 'Venta al por menor de tabaco', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47300', 'Venta de combustibles, lubricantes y otros (gasolineras)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47411', 'Venta al por menor de computadoras y equipo periférico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47412', 'Venta de equipo y accesorios de telecomunicación', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47420', 'Venta al por menor de equipo de audio y video', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47510', 'Venta al por menor de hilados, tejidos y productos textiles de mercería; confecciones para el hogar y textiles n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47521', 'Venta al por menor de productos de madera', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47522', 'Venta al por menor de artículos de ferretería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47523', 'Venta al por menor de productos de pinturerías', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47524', 'Venta al por menor en vidrierías', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47529', 'Venta al por menor de materiales de construcción y artículos conexos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47530', 'Venta al por menor de tapices, alfombras y revestimientos de paredes y pisos en comercios especializados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47591', 'Venta al por menor de muebles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47592', 'Venta al por menor de artículos de bazar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47593', 'Venta al por menor de aparatos electrodomésticos, repuestos y accesorios', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47594', 'Venta al por menor de artículos eléctricos y de iluminacion', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47598', 'Venta al por menor de instrumentos musicales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47610', 'Venta al por menor de libros, periódicos y artículos de papelería en comercios especializados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47620', 'Venta al por menor de discos láser, cassettes, cintas de video y otros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47630', 'Venta al por menor de productos y equipos de deporte', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47631', 'Venta al por menor de bicicletas, accesorios y repuestos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47640', 'Venta al por menor de juegos y juguetes en comercios especializados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47711', 'Venta al por menor de prendas de vestir y accesorios de vestir', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47712', 'Venta al por menor de calzado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47713', 'Venta al por menor de artículos de peletería, marroquinería y talabartería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47721', 'Venta al por menor de medicamentos farmacéuticos y otros materiales y artículos de uso médico, odontológico y veterinario', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47722', 'Venta al por menor de productos cosméticos y de tocador', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47731', 'Venta al por menor de productos de joyería, bisutería, óptica, relojería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47732', 'Venta al por menor de plantas, semillas, animales y artículos conexos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47733', 'Venta al por menor de combustibles de uso doméstico (gas propano y gas licuado)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47734', 'Venta al por menor de artesanías, artículos cerámicos y recuerdos en general', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47735', 'Venta al por menor de ataúdes, lápidas y cruces, trofeos, artículos religiosos en general', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47736', 'Venta al por menor de armas de fuego, municiones y accesorios', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47737', 'Venta al por menor de artículos de cohetería y pirotécnicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47738', 'Venta al por menor de artículos desechables de uso personal y domeéstico (servilletas, papel higiénico, pañales, toallas sanitarias, etc.)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47739', 'Venta al por menor de otros productos n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47741', 'Venta al por menor de artículos usados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47742', 'Venta al por menor de textiles y confecciones usados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47743', 'Venta al por menor de libros, revistas, papel y cartón usados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47749', 'Venta al por menor de productos usados n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47811', 'Venta al por menor de frutas, verduras y hortalizas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47814', 'Venta al por menor de productos lácteos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47815', 'Venta al por menor de productos de panadería, galletas y similares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47816', 'Venta al por menor de bebidas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47818', 'Venta al por menor en tiendas de mercado y puestos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47821', 'Venta al por menor de hilados, tejidos y productos textiles de mercería en puestos de mercados y ferias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47822', 'Venta al por menor de artículos textiles excepto confecciones para el hogar en puestos de mercados y ferias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47823', 'Venta al por menor de confecciones textiles para el hogar en puestos de mercados y ferias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47824', 'Venta al por menor de prendas de vestir, accesorios de vestir y similares en puestos de mercados y ferias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47825', 'Venta al por menor de ropa usada', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47826', 'Venta al por menor de calzado, artículos de marroquinería y talabartería en puestos de mercados y ferias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47827', 'Venta al por menor de artículos de marroquinería y talabartería en puestos de mercados y ferias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47829', 'Venta al por menor de artículos textiles ncp en puestos de mercados y ferias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47891', 'Venta al por menor de animales, flores y productos conexos en puestos de feria y mercados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47892', 'Venta al por menor de productos medicinales, cosméticos, de tocador y de limpieza en puestos de ferias y mercados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47893', 'Venta al por menor de artículos de bazar en puestos de ferias y mercados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47894', 'Venta al por menor de artículos de papel, envases, libros, revistas y conexos en puestos de feria y mercados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47895', 'Venta al por menor de materiales de construcción, electrodomésticos, accesorios para autos y similares en puestos de feria y mercados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47896', 'Venta al por menor de equipos accesorios para las comunicaciones en puestos de feria y mercados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47899', 'Venta al por menor en puestos de ferias y mercados n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47910', 'Venta al por menor por correo o Internet', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('47990', 'Otros tipos de venta al por menor no realizada, en almacenes, puestos de venta o mercado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49110', 'Transporte interurbano de pasajeros por ferrocarril', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49120', 'Transporte de carga por ferrocarril', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49211', 'Transporte de pasajeros urbanos e interurbano mediante buses', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49212', 'Transporte de pasajeros interdepartamental mediante microbuses', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49213', 'Transporte de pasajeros urbanos e interurbano mediante microbuses', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49214', 'Transporte de pasajeros interdepartamental mediante buses', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49221', 'Transporte internacional de pasajeros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49222', 'Transporte de pasajeros mediante taxis y autos con chofer', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49223', 'Transporte escolar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49225', 'Transporte de pasajeros para excursiones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49226', 'Servicios de transporte de personal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49229', 'Transporte de pasajeros por vía terrestre ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49231', 'Transporte de carga urbano', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49232', 'Transporte nacional de carga', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49233', 'Transporte de carga internacional', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49234', 'Servicios de mudanza', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49235', 'Alquiler de vehículos de carga con conductor', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('49300', 'Transporte por oleoducto o gasoducto', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('50110', 'Transporte de pasajeros maritime y de cabotaje', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('50120', 'Transporte de carga marítimo y de cabotaje', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('50211', 'Transporte de pasajeros por vías de navegación interiores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('50212', 'Alquiler de equipo de transporte de pasajeros por vías de navegación interior con conductor', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('50220', 'Transporte de carga por vías de navegación interiores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('51100', 'Transporte aéreo de pasajeros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('51201', 'Transporte de carga por vía aérea', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('51202', 'Alquiler de equipo de aerotransporte con operadores para el propósito de transportar carga', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52101', 'Alquiler de instalaciones de almacenamiento en zonas francas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52102', 'Alquiler de silos para conservación y almacenamiento de granos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52103', 'Alquiler de instalaciones con refrigeración para almacenamiento y conservación de alimentos y otros productos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52109', 'Alquiler de bodegas para almacenamiento y depósito n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52211', 'Servicio de garaje y estacionamiento', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52212', 'Servicios de terminales para el transporte por vía terrestre', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52219', 'Servicios para el transporte por vía terrestre n.c.p', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52220', 'Servicios para el transporte acuático', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52230', 'Servicios para el transporte aéreo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52240', 'Manipulación de carga', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52290', 'Servicios para el transporte ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('52291', 'Agencias de tramitaciones aduanales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('53100', 'Servicios de correo nacional', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('53200', 'Actividades de correo distintas a las actividades postales nacionales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('53201', 'Agencia privada de correo y encomiendas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('55101', 'Actividades de alojamiento para estancias cortas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('55102', 'Hoteles', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('55200', 'Actividades de campamentos, parques de vehículos de recreo y parques de caravanas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('55900', 'Alojamiento n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56101', 'Restaurantes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56106', 'Pupusería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56107', 'Actividades varias de restaurantes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56108', 'Comedores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56109', 'Merenderos ambulantes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56210', 'Preparación de comida para eventos especiales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56291', 'Servicios de provisión de comidas por contrato', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56292', 'Servicios de concesión de cafetines y chalet en empresas e', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56299', 'Servicios de preparación de comidas ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56301', 'Servicio de expendio de bebidas en salones y bares', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('56302', 'Servicio de expendio de bebidas en puestos callejeros, mercados y ferias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('58110', 'Edición de libros, folletos, partituras y otras ediciones distintas a estas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('58120', 'Edición de directorios y listas de correos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('58130', 'Edición de periódicos, revistas y otras publicaciones periódicas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('58190', 'Otras actividades de edición', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('58200', 'Edición de programas informáticos (software)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('59110', 'Actividades de producción cinematográfica', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('59120', 'Actividades de post producción de películas, videos y programas de televisión', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('59130', 'Actividades de distribución de películas cinematográficas, videos y programas de televisión', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('59140', 'Actividades de exhibición de películas cinematográficas y cintas de vídeo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('59200', 'Actividades de edición y grabación de música', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('60100', 'Servicios de difusiones de radio', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('60201', 'Actividades de programación y difusión de televisión abierta', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('60202', 'Actividades de suscripción y difusión de televisión por cable y/o suscripción', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('60299', 'Servicios de televisión, incluye televisión por cable', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('60900', 'Programación y transmisión de radio y televisión', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61101', 'Servicio de telefonia', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61102', 'Servicio de Internet', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61103', 'Servicio de telefonia fija', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61109', 'Servicio de Internet n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61201', 'Servicios de telefonía celular', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61202', 'Servicios de Internet inalámbrico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61209', 'Servicios de telecomunicaciones inalámbrico n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61301', 'Telecomunicaciones satelitales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61309', 'Comunicacion via satélite n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('61900', 'Actividades de telecomunicación n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('62010', 'Programación Informática', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('62020', 'Consultorías y gestión de servicios informáticos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('62090', 'Otras actividades de tecnología de información y servicios de computadora', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('63110', 'Procesamiento de datos y actividades relacionadas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('63120', 'Portales WEB', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('63910', 'Servicios de Agencias de Noticias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('63990', 'Otros servicios de información n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64110', 'Servicios provistos por el Banco Central de El salvador', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64190', 'Bancos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64192', 'Entidades dedicadas al envío de remesas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64199', 'Otras entidades financieras', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64200', 'Actividades de sociedades de cartera', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64300', 'Fideicomisos, fondos y otras fuentes de financiamiento', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64910', 'Arrendamientos financieros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64920', 'Asociaciones cooperativas de ahorro y crédito dedicadas a la intermediación financiera', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64921', 'Instituciones emisoras de tarjetas de crédito y otros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64922', 'Tipos de crédito ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64928', 'Prestamistas y casas de empeño', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('64990', 'Actividades de servicios financieros, excepto la financiacion de planes de seguros y de pensiones n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('65110', 'Planes de seguros de vida', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('65120', 'Planes de seguro excepto de vida', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('65199', 'Seguros generales de todo tipo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('65200', 'Planes se seguro', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('65300', 'Planes de pensiones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('66110', 'Administración de mercados financieros (Bolsa de Valores)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('66120', 'Actividades bursátiles (Corredores de Bolsa)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('66190', 'Actividades auxiliares de la intermediación financiera ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('66210', 'Evaluación de riesgos y daños', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('66220', 'Actividades de agentes y corredores de seguros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('66290', 'Otras actividades auxiliares de seguros y fondos de pensiones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('68101', 'Servicio de alquiler y venta de lotes en cementerios', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('68109', 'Actividades inmobiliarias realizadas con bienes propios o arrendados n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('68200', 'Actleidades Inmobiliarias Realizadas a Cambio de una Retribución o por Contrata', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('69100', 'Actividades jurídicas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('69200', 'Actividades de contabilidad, teneduría de libros y auditoría; asesoramiento en materia de impuestos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('70100', 'Actividades de oficinas centrales de sociedades de cartera', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('70200', 'Actividades de consultoría en gestión empresarial', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('71101', 'Servicios de arquitectura y planificación urbana y servicios conexos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('71102', 'Servicios de ingeniería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('71103', 'Servicios de agrimensura, topografía, cartografía, prospección y geofísica y servicios conexos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('71200', 'Ensayos y análisis técnicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('72100', 'Investigaciones y desarrollo experimental en el campo de las ciencias naturales y la ingeniería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('72199', 'Investigaciones científicas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('72200', 'Investigaciones y desarrollo experimental en el campo de las ciencias sociales y las humanidades científica y desarrollo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('73100', 'Publicidad', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('73200', 'Investigación de mercados y realización de encuestas de opinión pública', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('74100', 'Actividades de diseño especializado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('74200', 'Actividades de fotografía', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('74900', 'Servicios profesionales y científicos ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('75000', 'Actividades veterinarias', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('77101', 'Alquiler de equipo de transporte terrestre', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('77102', 'Alquiler de equipo de transporte acuático', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('77103', 'Alquiler de equipo de transporte por vía aérea', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('77210', 'Alquiler y arrendamiento de equipo de recreo y deportivo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('77220', 'Alquiler de cintas de video y discos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('77290', 'Alquiler de otros efectos personales y enseres domésticos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('77300', 'Alquiler de maquinaria y equipo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('77400', 'Arrendamiento de productos de propiedad intelectual', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('78100', 'Obtención y dotación de personal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('78200', 'Actividades de las agencias de trabajo temporal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('78300', 'Detación de recursos humanos y gestion; gestión de las funciones de recursos humanos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('79110', 'Actividades de agencias de viajes y organizadores de viajes; actividades de asistencia a turistas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('79120', 'Actividades de los operadores turísticos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('79900', 'Otros servicios de reservas y actividades relacionadas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('80100', 'Servicios de seguridad privados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('80201', 'Actividades de servicios de sistemas de seguridad', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('80202', 'Actividades para la prestación de sistemas de seguridad', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('80300', 'Actividades de investigación', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('81100', 'Actividades combinadas de mantenimiento de edificios e instalaciones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('81210', 'Limpieza general de edificios', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('81290', 'Otras actividades combinadas de mantenimiento de edificios e instalaciones ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('81300', 'Servicio de jardinería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('82110', 'Servicios administrativos de oficinas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('82190', 'Servicio de fotocopiado y similares, excepto en imprentas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('82200', 'Actividades de las centrales de llamadas (call center)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('82300', 'Organización de convenciones y ferias de negocios', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('82910', 'Actividades de agencias de cobro y oficinas de crédito', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('82921', 'Servicios de envase y empaque de productos alimenticios', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('82922', 'Servicios de envase y empaque de productos medicinales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('82929', 'Servicio de envase y empaque ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('82990', 'Actividades de apoyo empresariales ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('84110', 'Actividades de la Administración Pública en general', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('84111', 'Alcaldías Municipales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('84120', 'Regulación de las actividades de prestación de servicios sanitarios, educativos, culturales y otros servicios sociales, excepto seguridad social', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('84130', 'Regulación y facilitación de la actividad económica', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('84210', 'Actividades de administración y funcionamiento del Ministerio de Relaciones Exteriores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('84220', 'Actividades de defensa', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('84230', 'Actividades de mantenimiento del orden público y de seguridad', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('84300', 'Actividades de planes de seguridad social de afiliación obligatoria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85101', 'Guardería educativa', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85102', 'Enseñanza preescolar o parvularia', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85103', 'Enseñanza primaria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85104', 'Servicio de educación preescolar y primaria integrada', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85211', 'Enseñanza secundaria tercer ciclo (7°, 8* y 9°)', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85212', 'Enseñanza secundaria de formación general bachillerato', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85221', 'Enseñanza secundaria de formación técnica y profesional', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85222', 'Enseñanza secundaria de formación técnica y profesional integrada con enseñanza primaria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85301', 'Enseñanza superior universitaria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85302', 'Enseñanza superior no universitaria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85303', 'Enseñanza superior integrada a educación secundaria y/o primaria', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85410', 'Educación deportiva y recreativa', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85420', 'Educación cultural', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85490', 'Otros tipos de enseñanza n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85499', 'Enseñanza formal', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('85500', 'Servicios de apoyo a la enseñanza', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('86100', 'Actividades de hospitales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('86201', 'Clínicas médicas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('86202', 'Servicios de Odontología', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('86203', 'Servicios médicos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('86901', 'Servicios de análisis y estudios de diagnóstico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('86902', 'Actividades de atención de la salud humana', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('86909', 'Otros Servicio relacionados con la salud ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('87100', 'Residencias de ancianos con atención de enfermería', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('87200', 'Instituciones dedicadas al tratamiento del retraso mental, problemas de salud mental y el uso indebido de sustancias nocivas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('87300', 'Instituciones dedicadas al cuidado de ancianos y discapacitados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('87900', 'Actividades de asistencia a nifios y jóvenes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('87901', 'Otras actividades de atención en instituciones', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('88100', 'Actividades de asistencia sociales sin alojamiento para ancianos y discapacitados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('88900', 'servicios sociales sin alojamiento ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('90000', 'Actividades creativas artísticas y de esparcimiento', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('91010', 'Actividades de bibliotecas y archivos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('91020', 'Actividades de museos y preservación de lugares y edificios históricos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('91030', 'Actividades de jardines botánicos, zoológicos y de reservas naturales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('92000', 'Actividades de juegos y apuestas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('93110', 'Gestión de instalaciones deportivas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('93120', 'Actividades de clubes deportivos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('93190', 'Otras actividades deportivas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('93210', 'Actividades de parques de atracciones y parques temáticos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('93291', 'Discotecas y salas de baile', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('93298', 'Centros vacacionales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('93299', 'Actividades de esparcimiento ncp', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('94110', 'Actividades de organizaciones empresariales y de empleadores', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('94120', 'Actividades de organizaciones profesionales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('94200', 'Actividades de sindicatos', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('94910', 'Actividades de organizaciones religiosas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('94920', 'Actividades de organizaciones políticas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('94990', 'Actividades de asociaciones n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95110', 'Reparación de computadoras y equipo periférico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95120', 'Reparación de equipo de comunicación', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95210', 'Reparación de aparatos electrónicos de consumo', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95220', 'Reparación de aparatos doméstico y equipo de hogar y jardín', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95230', 'Reparación de calzado y artículos de cuero', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95240', 'Reparación de muebles y accesorios para el hogar', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95291', 'Reparación de Instrumentos musicales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95292', 'Servicios de cerrajería y copiado de llaves', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95293', 'Reparación de joyas y relojes', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95294', 'Reparación de bicicletas, sillas de ruedas y rodados n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('95299', 'Reparaciones de enseres personales n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('96010', 'Lavado y limpieza de prendas de tela y de piel, incluso la limpieza en SECO', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('96020', 'Peluquería y otros tratamientos de belleza', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('96030', 'Pompas fúnebres y actividades conexas', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('96091', 'Servicios de sauna y otros servicios para la estética corporal n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('96092', 'Servicios n.c.p.', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('97000', 'Actividad de los hogares en calidad de empleadores de personal doméstico', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('98100', 'Actividades indiferenciadas de producción de bienes de los hogares privados para uso propio', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('98200', 'Actividades indiferenciadas de producción de servicios de los hogares privados para uso propio', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('99000', 'Actividades de organizaciones y órganos extraterritoriales', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10001', 'Empleados', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10002', 'Pensionado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10003', 'Estudiante', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10004', 'Desempleado', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10005', 'Otros', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');
INSERT INTO public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) VALUES ('10006', 'Comerciante', '2025-09-27 17:23:09.981882', '2025-09-27 17:23:09.981882');


--
-- TOC entry 5071 (class 0 OID 25410)
-- Dependencies: 225
-- Data for Name: caja; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.caja (id, descripcion, punto_venta_mh, sucursal_id, created_at, updated_at) VALUES (1, 'CAJA DE CASA MATRIZ', 'P001', 1, '2025-09-27 22:02:35.334635', '2025-09-27 22:02:35.334635');


--
-- TOC entry 5078 (class 0 OID 25453)
-- Dependencies: 232
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cliente (id, nombre_cliente, no_registro, nit, dui, telefono, correo, codigo_actividad_id, direccion, departamento_id, municipio_id, tipo_contribuyente_id, estado, created_at, updated_at) VALUES (1, 'CONSUMIDOR FINAL', 'A', 'A', 'A', '-', NULL, NULL, NULL, NULL, NULL, NULL, 1, '2025-09-27 22:07:23.878807', '2025-10-27 20:10:12.052556');


--
-- TOC entry 5072 (class 0 OID 25423)
-- Dependencies: 226
-- Data for Name: contador_dte; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contador_dte (tipo_documento_id, contador, anio, sucursal_id, created_at, updated_at) VALUES ('01', 0, 2025, 1, '2025-10-04 17:33:03.233254', '2025-10-04 17:33:03.233254');
INSERT INTO public.contador_dte (tipo_documento_id, contador, anio, sucursal_id, created_at, updated_at) VALUES ('03', 0, 2025, 1, '2025-10-04 17:33:23.011925', '2025-10-04 17:33:23.011925');
INSERT INTO public.contador_dte (tipo_documento_id, contador, anio, sucursal_id, created_at, updated_at) VALUES ('05', 0, 2025, 1, '2025-10-04 17:33:38.100124', '2025-10-04 17:33:38.100124');


--
-- TOC entry 5093 (class 0 OID 25590)
-- Dependencies: 247
-- Data for Name: contingencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contingencia (id, codigo_generacion, sello_contingencia, f_inicio, f_fin, tipo_contingencia_id, motivo_contingencia, created_at, updated_at) VALUES (1, NULL, '1123123', '2025-10-29', '2025-10-29', 1, 'qweqweqe2222', '2025-10-29 20:26:33.885433', '2025-10-29 21:21:09.703288');


--
-- TOC entry 5095 (class 0 OID 25604)
-- Dependencies: 249
-- Data for Name: contingencia_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contingencia_detalle (id, contingencia_id, venta_id, created_at, updated_at) VALUES (1, 1, 5, '2025-10-29 20:26:33.914992', '2025-10-29 20:26:33.914992');


--
-- TOC entry 5064 (class 0 OID 25351)
-- Dependencies: 218
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('00', 'Otro (Para extranjeros)', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('01', 'Ahuachapán', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('02', 'Santa Ana', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('03', 'Sonsonate', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('04', 'Chalatenango', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('05', 'La Libertad', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('06', 'San Salvador', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('07', 'Cuscatlán', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('08', 'La  Paz', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('09', 'Cabañas', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('10', 'San Vicente', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('11', 'Usulután', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('12', 'San Miguel', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('13', 'Morazán', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');
INSERT INTO public.departamento (id, nombre_departamento, created_at, updated_at) VALUES ('14', 'La Unión', '2025-09-27 17:38:22.361741', '2025-09-27 17:38:22.361741');


--
-- TOC entry 5067 (class 0 OID 25367)
-- Dependencies: 221
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.empresa (id, nombre_empresa, telefono, correo, nombre_comercial, no_registro, nit, dui, codigo_actividad_id, direccion, departamento_id, municipio_id, tipo_contribuyente_id, estado, created_at, updated_at, representante_legal) VALUES (1, 'MASTER KEY', '1122-3344', 'masterkey@gmail.com', 'MASTER KEY', NULL, '123-1234-123456-123-3', '16514595-9', '95292', '10 AV NORTE', '05', '0528', 1, 1, '2025-09-27 21:53:17.311716', '2025-09-27 21:59:46.150905', 'CARLOS ALBERTO ORELLANA BARRIENTOS');


--
-- TOC entry 5099 (class 0 OID 25630)
-- Dependencies: 253
-- Data for Name: invalidacion; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5065 (class 0 OID 25356)
-- Dependencies: 219
-- Data for Name: municipio; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0000', 'Otro (Para extranjeros)', '00', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '00');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0113', 'AHUACHAPAN NORTE', '01', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '13');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0114', 'AHUACHAPAN CENTRO', '01', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '14');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0115', 'AHUACHAPAN SUR', '01', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '15');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0214', 'SANTA ANA NORTE', '02', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '14');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0215', 'SANTA ANA CENTRO', '02', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '15');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0216', 'SANTA ANA ESTE', '02', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '16');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0217', 'SANTA ANA OESTE', '02', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '17');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0317', 'SONSONATE NORTE', '03', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '17');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0318', 'SONSONATE CENTRO', '03', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '18');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0319', 'SONSONATE ESTE', '03', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '19');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0320', 'SONSONATE OESTE', '03', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '20');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0434', 'CHALATENANGO NORTE', '04', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '34');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0435', 'CHALATENANGO CENTRO', '04', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '35');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0436', 'CHALATENANGO SUR', '04', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '36');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0523', 'LA LIBERTAD NORTE', '05', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '23');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0524', 'LA LIBERTAD CENTRO', '05', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '24');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0525', 'LA LIBERTAD OESTE', '05', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '25');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0526', 'LA LIBERTAD ESTE', '05', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '26');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0527', 'LA LIBERTAD COSTA', '05', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '27');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0528', 'LA LIBERTAD SUR', '05', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '28');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0620', 'SAN SALVADOR NORTE', '06', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '20');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0621', 'SAN SALVADOR OESTE', '06', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '21');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0622', 'SAN SALVADOR ESTE', '06', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '22');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0623', 'SAN SALVADOR CENTRO', '06', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '23');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0624', 'SAN SALVADOR SUR', '06', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '24');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0717', 'CUSCATLAN NORTE', '07', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '17');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0718', 'CUSCATLAN SUR', '07', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '18');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0823', 'LA PAZ OESTE', '08', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '23');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0824', 'LA PAZ CENTRO', '08', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '24');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0825', 'LA PAZ ESTE', '08', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '25');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0910', 'CABAÑAS OESTE', '09', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '10');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('0911', 'CABAÑAS ESTE', '09', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '11');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1014', 'SAN VICENTE NORTE', '10', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '14');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1015', 'SAN VICENTE SUR', '10', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '15');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1124', 'USULUTAN NORTE', '11', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '24');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1125', 'USULUTAN ESTE', '11', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '25');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1126', 'USULUTAN OESTE', '11', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '26');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1221', 'SAN MIGUEL NORTE', '12', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '21');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1222', 'SAN MIGUEL CENTRO', '12', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '22');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1223', 'SAN MIGUEL OESTE', '12', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '23');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1327', 'MORAZAN NORTE', '13', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '27');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1328', 'MORAZAN SUR', '13', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '28');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1419', 'LA UNION NORTE', '14', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '19');
INSERT INTO public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) VALUES ('1420', 'LA UNION SUR', '14', '2025-09-27 21:38:18.192748', '2025-09-27 21:38:18.192748', '20');


--
-- TOC entry 5100 (class 0 OID 25719)
-- Dependencies: 254
-- Data for Name: parametro; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.parametro (nombre_parametro, valor, created_at, updated_at) VALUES ('IVA', '0.13', '2025-09-27 22:31:18.165482', '2025-09-27 22:31:18.165482');
INSERT INTO public.parametro (nombre_parametro, valor, created_at, updated_at) VALUES ('RETENCION', '0.01', '2025-10-23 20:29:00.984737', '2025-10-23 20:29:00.984737');
INSERT INTO public.parametro (nombre_parametro, valor, created_at, updated_at) VALUES ('MONTO_RETENCION', '100', '2025-10-23 20:31:46.275334', '2025-10-23 20:32:06.828893');
INSERT INTO public.parametro (nombre_parametro, valor, created_at, updated_at) VALUES ('CONTRIBUYENTE', '1', '2025-10-23 20:31:46.275334', '2025-10-23 22:40:22.613271');
INSERT INTO public.parametro (nombre_parametro, valor, created_at, updated_at) VALUES ('ID_FACTURA', '01', '2025-10-27 20:03:43.505841', '2025-10-27 20:03:43.505841');
INSERT INTO public.parametro (nombre_parametro, valor, created_at, updated_at) VALUES ('tokenMH', 'PRUEBITAS', '2025-10-11 15:34:31.237098', '2025-10-30 20:50:15.089021');


--
-- TOC entry 5081 (class 0 OID 25487)
-- Dependencies: 235
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.producto (id, descripcion, precio, tipo, veces_usado, created_at, updated_at) VALUES (1, 'DESTORNILLADOR PHILLIPS', 1.25, 'PRODUCTO', 0, '2025-09-27 22:16:15.213685', '2025-09-27 22:16:25.990005');
INSERT INTO public.producto (id, descripcion, precio, tipo, veces_usado, created_at, updated_at) VALUES (2, 'COPIA DE LLAVE CASA', 1.50, 'SERVICIO', 0, '2025-09-27 22:17:04.021289', '2025-09-27 22:17:04.021289');


--
-- TOC entry 5074 (class 0 OID 25427)
-- Dependencies: 228
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rol (id, nombre_rol, created_at, updated_at) VALUES (1, 'ADMIN', '2025-09-27 22:05:15.174403', '2025-09-27 22:05:15.174403');
INSERT INTO public.rol (id, nombre_rol, created_at, updated_at) VALUES (2, 'USUARIO', '2025-09-27 22:05:22.469979', '2025-09-27 22:05:22.469979');


--
-- TOC entry 5069 (class 0 OID 25396)
-- Dependencies: 223
-- Data for Name: sucursal; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sucursal (id, nombre_sucursal, direccion, telefono, correo, establecimiento_mh, estado, empresa_id, created_at, updated_at) VALUES (1, 'CASA MATRIZ', '10 AV NORTE', '1122-4455', 'masterkey@gmail.com', 'M001', 1, 1, '2025-09-27 22:01:15.902348', '2025-09-27 22:01:15.902348');


--
-- TOC entry 5091 (class 0 OID 25581)
-- Dependencies: 245
-- Data for Name: tipo_contingencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_contingencia (id, nombre, created_at, updated_at) VALUES (1, 'No disponibilidad del sistema MH', '2025-10-28 21:46:37.609683', '2025-10-28 21:46:37.609683');
INSERT INTO public.tipo_contingencia (id, nombre, created_at, updated_at) VALUES (2, 'No disponibilidad del sistema emisor', '2025-10-28 21:46:55.814858', '2025-10-28 21:46:55.814858');
INSERT INTO public.tipo_contingencia (id, nombre, created_at, updated_at) VALUES (3, 'Falla en el suministro de servicio de Internet del Emisor', '2025-10-28 21:47:29.48824', '2025-10-28 21:47:29.48824');
INSERT INTO public.tipo_contingencia (id, nombre, created_at, updated_at) VALUES (4, 'Falla en el suministro de servicio de energía eléctrica del emisor
que impida la transmisión de los DTE', '2025-10-28 21:47:49.158953', '2025-10-28 21:47:49.158953');
INSERT INTO public.tipo_contingencia (id, nombre, created_at, updated_at) VALUES (5, 'Otro (deberá digitar un máximo de 500 caracteres explicando el
motivo)', '2025-10-28 21:48:08.008401', '2025-10-28 21:48:08.008401');


--
-- TOC entry 5062 (class 0 OID 25338)
-- Dependencies: 216
-- Data for Name: tipo_contribuyente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_contribuyente (id, nombre, created_at, updated_at) VALUES (1, 'PEQUEÑO CONTRIBUYENTE', '2025-09-27 11:11:12.180657', '2025-09-27 11:11:12.180657');
INSERT INTO public.tipo_contribuyente (id, nombre, created_at, updated_at) VALUES (2, 'MEDIANO CONTRIBUYENTE', '2025-09-27 11:11:25.371883', '2025-09-27 11:11:25.371883');
INSERT INTO public.tipo_contribuyente (id, nombre, created_at, updated_at) VALUES (3, 'GRAN CONTRIBUYENTE', '2025-09-27 11:11:40.204374', '2025-09-27 11:12:35.5167');


--
-- TOC entry 5079 (class 0 OID 25481)
-- Dependencies: 233
-- Data for Name: tipo_documento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_documento (id, nombre, nombre_corto, version_dte, created_at, updated_at) VALUES ('01', 'FACTURA', 'FAC', '1', '2025-09-27 22:14:04.574258', '2025-09-27 22:14:04.574258');
INSERT INTO public.tipo_documento (id, nombre, nombre_corto, version_dte, created_at, updated_at) VALUES ('03', 'CREDITO FISCAL', 'CCF', '3', '2025-09-27 22:14:29.929165', '2025-09-27 22:14:29.929165');
INSERT INTO public.tipo_documento (id, nombre, nombre_corto, version_dte, created_at, updated_at) VALUES ('05', 'NOTA DE CRÉDITO', 'NC', '3', '2025-09-27 22:14:57.910569', '2025-09-27 22:14:57.910569');


--
-- TOC entry 5097 (class 0 OID 25621)
-- Dependencies: 251
-- Data for Name: tipo_invalidacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_invalidacion (id, nombre, created_at, updated_at) VALUES (3, 'Otro', '2025-10-30 21:35:58.310212', '2025-10-30 21:35:58.310212');
INSERT INTO public.tipo_invalidacion (id, nombre, created_at, updated_at) VALUES (2, 'Rescindir de la operación realizada.', '2025-10-30 21:35:46.661993', '2025-10-30 21:58:02.876486');
INSERT INTO public.tipo_invalidacion (id, nombre, created_at, updated_at) VALUES (1, 'Error en la Información del Documento.', '2025-10-30 21:35:32.418877', '2025-10-30 23:08:30.889845');


--
-- TOC entry 5087 (class 0 OID 25555)
-- Dependencies: 241
-- Data for Name: tipo_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_pago (id, nombre, estado, created_at, updated_at) VALUES (1, 'EFECTIVO', 1, '2025-09-27 22:17:38.54473', '2025-09-27 22:17:38.54473');


--
-- TOC entry 5076 (class 0 OID 25434)
-- Dependencies: 230
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuario (id, username, password, rol_id, caja_id, created_at, updated_at) VALUES (1, 'ADMIN', '123', 1, 1, '2025-09-27 22:05:46.381613', '2025-10-04 12:18:16.821838');
INSERT INTO public.usuario (id, username, password, rol_id, caja_id, created_at, updated_at) VALUES (2, 'DORELLANA', '123', 2, 1, '2025-09-28 13:11:27.105102', '2025-10-04 12:18:16.821838');


--
-- TOC entry 5083 (class 0 OID 25499)
-- Dependencies: 237
-- Data for Name: venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.venta (id, usuario_id, tipo_documento_id, cliente_id, fecha, codigo_generacion, numero_control, sello_mh, subtotal, descuento, iva, retencion, percepcion, total, codigo_generacion_contingencia, codigo_generacion_anulacion, intentos, estado, created_at, updated_at, nombre_factura, tipo_doc_factura, doc_factura, venta_id_nc, correo, contingencia) VALUES (5, 1, '01', 1, '2025-10-27 21:36:46.74289', '51423A71-FA56-1604-2778-282675454800', 'DTE-03-M001P002-000000000025415', '51423A71-FA56-1604-2778-282675454800', 1.11, 0.00, 0.14, 0.00, 0.00, 1.25, '', NULL, 0, 1, '2025-10-27 21:36:46.777745', '2025-10-30 21:07:47.108081', 'qweqwewqe', 'DUI', '12312312-3', NULL, 'qweqwe@qwec.om', 0);


--
-- TOC entry 5085 (class 0 OID 25534)
-- Dependencies: 239
-- Data for Name: venta_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.venta_detalle (id, venta_id, producto_id, cantidad, precio_unitario, descuento, iva, total_linea, created_at, updated_at, sub_total) VALUES (5, 5, 1, 1.00, 1.25, 0.00, 0.14, 1.25, '2025-10-27 21:36:46.814524', '2025-10-27 21:36:46.814524', 1.11);


--
-- TOC entry 5089 (class 0 OID 25563)
-- Dependencies: 243
-- Data for Name: venta_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 224
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_id_seq', 1, true);


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 231
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_id_seq', 2, true);


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 248
-- Name: contingencia_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contingencia_detalle_id_seq', 1, true);


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 246
-- Name: contingencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contingencia_id_seq', 1, true);


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 220
-- Name: empresa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empresa_id_seq', 1, false);


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 252
-- Name: invalidacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invalidacion_id_seq', 1, false);


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 234
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_id_seq', 1, false);


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 227
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rol_id_seq', 2, true);


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 222
-- Name: sucursal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sucursal_id_seq', 1, true);


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 244
-- Name: tipo_contingencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_contingencia_id_seq', 1, false);


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 215
-- Name: tipo_contribuyente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_contribuyente_id_seq', 3, true);


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 250
-- Name: tipo_invalidacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_invalidacion_id_seq', 1, false);


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 240
-- Name: tipo_pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_pago_id_seq', 1, false);


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 229
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 1, true);


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 238
-- Name: venta_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_detalle_id_seq', 5, true);


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 236
-- Name: venta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_id_seq', 5, true);


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 242
-- Name: venta_pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_pago_id_seq', 1, false);


--
-- TOC entry 4825 (class 2606 OID 25350)
-- Name: actividad_economica actividad_economica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_economica
    ADD CONSTRAINT actividad_economica_pkey PRIMARY KEY (id);


--
-- TOC entry 4835 (class 2606 OID 25731)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 4843 (class 2606 OID 25756)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);


--
-- TOC entry 4861 (class 2606 OID 25812)
-- Name: contingencia_detalle contingencia_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia_detalle
    ADD CONSTRAINT contingencia_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4859 (class 2606 OID 25787)
-- Name: contingencia contingencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia
    ADD CONSTRAINT contingencia_pkey PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 25355)
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (id);


--
-- TOC entry 4831 (class 2606 OID 25837)
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id);


--
-- TOC entry 4865 (class 2606 OID 25868)
-- Name: invalidacion invalidacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion
    ADD CONSTRAINT invalidacion_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 25889)
-- Name: invalidacion invalidacion_venta_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion
    ADD CONSTRAINT invalidacion_venta_id_key UNIQUE (venta_id);


--
-- TOC entry 4829 (class 2606 OID 25360)
-- Name: municipio municipio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT municipio_pkey PRIMARY KEY (id);


--
-- TOC entry 4869 (class 2606 OID 25725)
-- Name: parametro parametro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametro
    ADD CONSTRAINT parametro_pkey PRIMARY KEY (nombre_parametro);


--
-- TOC entry 4847 (class 2606 OID 25904)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 25925)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 25937)
-- Name: sucursal sucursal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT sucursal_pkey PRIMARY KEY (id);


--
-- TOC entry 4857 (class 2606 OID 25968)
-- Name: tipo_contingencia tipo_contingencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contingencia
    ADD CONSTRAINT tipo_contingencia_pkey PRIMARY KEY (id);


--
-- TOC entry 4823 (class 2606 OID 25982)
-- Name: tipo_contribuyente tipo_contribuyente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contribuyente
    ADD CONSTRAINT tipo_contribuyente_pkey PRIMARY KEY (id);


--
-- TOC entry 4845 (class 2606 OID 25485)
-- Name: tipo_documento tipo_documento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_documento
    ADD CONSTRAINT tipo_documento_pkey PRIMARY KEY (id);


--
-- TOC entry 4863 (class 2606 OID 25999)
-- Name: tipo_invalidacion tipo_invalidacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_invalidacion
    ADD CONSTRAINT tipo_invalidacion_pkey PRIMARY KEY (id);


--
-- TOC entry 4853 (class 2606 OID 26013)
-- Name: tipo_pago tipo_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_pago
    ADD CONSTRAINT tipo_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 4839 (class 2606 OID 26030)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 4841 (class 2606 OID 25441)
-- Name: usuario usuario_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_username_key UNIQUE (username);


--
-- TOC entry 4851 (class 2606 OID 26128)
-- Name: venta_detalle venta_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_detalle
    ADD CONSTRAINT venta_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 26153)
-- Name: venta_pago venta_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_pago
    ADD CONSTRAINT venta_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 4849 (class 2606 OID 26063)
-- Name: venta venta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (id);


--
-- TOC entry 4896 (class 2620 OID 25696)
-- Name: actividad_economica trg_actividad_economica_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_actividad_economica_updated BEFORE UPDATE ON public.actividad_economica FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4901 (class 2620 OID 25701)
-- Name: caja trg_caja_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_caja_updated BEFORE UPDATE ON public.caja FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4905 (class 2620 OID 25704)
-- Name: cliente trg_cliente_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_cliente_updated BEFORE UPDATE ON public.cliente FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4914 (class 2620 OID 25713)
-- Name: contingencia_detalle trg_contingencia_detalle_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_contingencia_detalle_updated BEFORE UPDATE ON public.contingencia_detalle FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4913 (class 2620 OID 25712)
-- Name: contingencia trg_contingencia_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_contingencia_updated BEFORE UPDATE ON public.contingencia FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4897 (class 2620 OID 25697)
-- Name: departamento trg_departamento_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_departamento_updated BEFORE UPDATE ON public.departamento FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4899 (class 2620 OID 25699)
-- Name: empresa trg_empresa_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_empresa_updated BEFORE UPDATE ON public.empresa FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4902 (class 2620 OID 25716)
-- Name: contador_dte trg_invalidacion_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_invalidacion_updated BEFORE UPDATE ON public.contador_dte FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4916 (class 2620 OID 25715)
-- Name: invalidacion trg_invalidacion_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_invalidacion_updated BEFORE UPDATE ON public.invalidacion FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4917 (class 2620 OID 25726)
-- Name: parametro trg_invalidacion_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_invalidacion_updated BEFORE UPDATE ON public.parametro FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4898 (class 2620 OID 25698)
-- Name: municipio trg_municipio_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_municipio_updated BEFORE UPDATE ON public.municipio FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4907 (class 2620 OID 25706)
-- Name: producto trg_producto_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_producto_updated BEFORE UPDATE ON public.producto FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4903 (class 2620 OID 25702)
-- Name: rol trg_rol_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rol_updated BEFORE UPDATE ON public.rol FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4900 (class 2620 OID 25700)
-- Name: sucursal trg_sucursal_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sucursal_updated BEFORE UPDATE ON public.sucursal FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4912 (class 2620 OID 25711)
-- Name: tipo_contingencia trg_tipo_contingencia_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_contingencia_updated BEFORE UPDATE ON public.tipo_contingencia FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4895 (class 2620 OID 25695)
-- Name: tipo_contribuyente trg_tipo_contribuyente_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_contribuyente_updated BEFORE UPDATE ON public.tipo_contribuyente FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4906 (class 2620 OID 25705)
-- Name: tipo_documento trg_tipo_documento_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_documento_updated BEFORE UPDATE ON public.tipo_documento FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4915 (class 2620 OID 25714)
-- Name: tipo_invalidacion trg_tipo_invalidacion_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_invalidacion_updated BEFORE UPDATE ON public.tipo_invalidacion FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4910 (class 2620 OID 25709)
-- Name: tipo_pago trg_tipo_pago_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_pago_updated BEFORE UPDATE ON public.tipo_pago FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4904 (class 2620 OID 25703)
-- Name: usuario trg_usuario_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_usuario_updated BEFORE UPDATE ON public.usuario FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4909 (class 2620 OID 25708)
-- Name: venta_detalle trg_venta_detalle_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_venta_detalle_updated BEFORE UPDATE ON public.venta_detalle FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4911 (class 2620 OID 25710)
-- Name: venta_pago trg_venta_pago_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_venta_pago_updated BEFORE UPDATE ON public.venta_pago FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4908 (class 2620 OID 25707)
-- Name: venta trg_venta_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_venta_updated BEFORE UPDATE ON public.venta FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4876 (class 2606 OID 25938)
-- Name: caja caja_sucursal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(id);


--
-- TOC entry 4879 (class 2606 OID 25461)
-- Name: cliente cliente_codigo_actividad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_codigo_actividad_id_fkey FOREIGN KEY (codigo_actividad_id) REFERENCES public.actividad_economica(id);


--
-- TOC entry 4880 (class 2606 OID 25466)
-- Name: cliente cliente_departamento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_departamento_id_fkey FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 4881 (class 2606 OID 25471)
-- Name: cliente cliente_municipio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_municipio_id_fkey FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 4882 (class 2606 OID 25983)
-- Name: cliente cliente_tipo_contribuyente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_tipo_contribuyente_id_fkey FOREIGN KEY (tipo_contribuyente_id) REFERENCES public.tipo_contribuyente(id);


--
-- TOC entry 4891 (class 2606 OID 25817)
-- Name: contingencia_detalle contingencia_detalle_contingencia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia_detalle
    ADD CONSTRAINT contingencia_detalle_contingencia_id_fkey FOREIGN KEY (contingencia_id) REFERENCES public.contingencia(id);


--
-- TOC entry 4892 (class 2606 OID 26074)
-- Name: contingencia_detalle contingencia_detalle_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia_detalle
    ADD CONSTRAINT contingencia_detalle_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.venta(id);


--
-- TOC entry 4890 (class 2606 OID 25969)
-- Name: contingencia contingencia_tipo_contingencia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia
    ADD CONSTRAINT contingencia_tipo_contingencia_id_fkey FOREIGN KEY (tipo_contingencia_id) REFERENCES public.tipo_contingencia(id);


--
-- TOC entry 4871 (class 2606 OID 25375)
-- Name: empresa empresa_codigo_actividad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_codigo_actividad_id_fkey FOREIGN KEY (codigo_actividad_id) REFERENCES public.actividad_economica(id);


--
-- TOC entry 4872 (class 2606 OID 25380)
-- Name: empresa empresa_departamento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_departamento_id_fkey FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 4873 (class 2606 OID 25385)
-- Name: empresa empresa_municipio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_municipio_id_fkey FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 4874 (class 2606 OID 25988)
-- Name: empresa empresa_tipo_contribuyente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_tipo_contribuyente_id_fkey FOREIGN KEY (tipo_contribuyente_id) REFERENCES public.tipo_contribuyente(id);


--
-- TOC entry 4893 (class 2606 OID 26000)
-- Name: invalidacion invalidacion_tipo_anulacion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion
    ADD CONSTRAINT invalidacion_tipo_anulacion_id_fkey FOREIGN KEY (tipo_anulacion_id) REFERENCES public.tipo_invalidacion(id);


--
-- TOC entry 4894 (class 2606 OID 26079)
-- Name: invalidacion invalidacion_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion
    ADD CONSTRAINT invalidacion_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.venta(id);


--
-- TOC entry 4870 (class 2606 OID 25361)
-- Name: municipio municipio_departamento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT municipio_departamento_id_fkey FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 4875 (class 2606 OID 25955)
-- Name: sucursal sucursal_empresa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT sucursal_empresa_id_fkey FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 4877 (class 2606 OID 26041)
-- Name: usuario usuario_caja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_caja_id_fkey FOREIGN KEY (caja_id) REFERENCES public.caja(id);


--
-- TOC entry 4878 (class 2606 OID 26051)
-- Name: usuario usuario_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.rol(id);


--
-- TOC entry 4883 (class 2606 OID 26104)
-- Name: venta venta_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(id);


--
-- TOC entry 4886 (class 2606 OID 26133)
-- Name: venta_detalle venta_detalle_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_detalle
    ADD CONSTRAINT venta_detalle_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id);


--
-- TOC entry 4887 (class 2606 OID 26142)
-- Name: venta_detalle venta_detalle_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_detalle
    ADD CONSTRAINT venta_detalle_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.venta(id);


--
-- TOC entry 4888 (class 2606 OID 26163)
-- Name: venta_pago venta_pago_tipo_pago_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_pago
    ADD CONSTRAINT venta_pago_tipo_pago_id_fkey FOREIGN KEY (tipo_pago_id) REFERENCES public.tipo_pago(id);


--
-- TOC entry 4889 (class 2606 OID 26172)
-- Name: venta_pago venta_pago_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_pago
    ADD CONSTRAINT venta_pago_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.venta(id);


--
-- TOC entry 4884 (class 2606 OID 25523)
-- Name: venta venta_tipo_documento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_tipo_documento_id_fkey FOREIGN KEY (tipo_documento_id) REFERENCES public.tipo_documento(id);


--
-- TOC entry 4885 (class 2606 OID 26115)
-- Name: venta venta_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


-- Completed on 2025-10-30 23:40:34

--
-- PostgreSQL database dump complete
--

\unrestrict EXPl6pJgSGbg35LUwoC87ZvHI3LZPV4eq5zDZHpFag867XQtKqKZokTqe9aZHwj

