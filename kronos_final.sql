--
-- PostgreSQL database dump
--

\restrict H9arLjkWFDwxd1liEj3D7Ysd6HVliO2FT9DvWMJErKAJglpplcVm8g8Yfl99mt9

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-01-07 12:50:16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 276 (class 1255 OID 17047)
-- Name: num_centenas(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.num_centenas(n integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN CASE
        WHEN n < 100 THEN num_decenas(n)
        WHEN n = 100 THEN 'CIEN'
        ELSE
            CASE (n / 100)::INT
                WHEN 1 THEN 'CIENTO'
                WHEN 2 THEN 'DOSCIENTOS'
                WHEN 3 THEN 'TRESCIENTOS'
                WHEN 4 THEN 'CUATROCIENTOS'
                WHEN 5 THEN 'QUINIENTOS'
                WHEN 6 THEN 'SEISCIENTOS'
                WHEN 7 THEN 'SETECIENTOS'
                WHEN 8 THEN 'OCHOCIENTOS'
                WHEN 9 THEN 'NOVECIENTOS'
            END ||
            CASE WHEN n % 100 <> 0 THEN ' ' || num_decenas(n % 100) ELSE '' END
    END;
END;
$$;


ALTER FUNCTION public.num_centenas(n integer) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 17046)
-- Name: num_decenas(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.num_decenas(n integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN CASE
        WHEN n < 10 THEN num_unidades(n)
        WHEN n BETWEEN 10 AND 15 THEN
            CASE n
                WHEN 10 THEN 'DIEZ'
                WHEN 11 THEN 'ONCE'
                WHEN 12 THEN 'DOCE'
                WHEN 13 THEN 'TRECE'
                WHEN 14 THEN 'CATORCE'
                WHEN 15 THEN 'QUINCE'
            END
        WHEN n < 20 THEN 'DIECI' || num_unidades(n - 10)
        WHEN n = 20 THEN 'VEINTE'
        WHEN n < 30 THEN 'VEINTI' || num_unidades(n - 20)
        ELSE
            CASE (n / 10)::INT
                WHEN 3 THEN 'TREINTA'
                WHEN 4 THEN 'CUARENTA'
                WHEN 5 THEN 'CINCUENTA'
                WHEN 6 THEN 'SESENTA'
                WHEN 7 THEN 'SETENTA'
                WHEN 8 THEN 'OCHENTA'
                WHEN 9 THEN 'NOVENTA'
            END ||
            CASE WHEN n % 10 <> 0 THEN ' Y ' || num_unidades(n % 10) ELSE '' END
    END;
END;
$$;


ALTER FUNCTION public.num_decenas(n integer) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 17045)
-- Name: num_unidades(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.num_unidades(n integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN CASE n
        WHEN 1 THEN 'UNO'
        WHEN 2 THEN 'DOS'
        WHEN 3 THEN 'TRES'
        WHEN 4 THEN 'CUATRO'
        WHEN 5 THEN 'CINCO'
        WHEN 6 THEN 'SEIS'
        WHEN 7 THEN 'SIETE'
        WHEN 8 THEN 'OCHO'
        WHEN 9 THEN 'NUEVE'
        ELSE ''
    END;
END;
$$;


ALTER FUNCTION public.num_unidades(n integer) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 17048)
-- Name: numero_a_letras(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.numero_a_letras(num numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    entero BIGINT;
    decimal INT;
    resultado TEXT := '';
BEGIN
    entero := FLOOR(num);
    decimal := ROUND((num - entero) * 100);

    IF entero = 0 THEN
        resultado := 'CERO';
    ELSE
        IF entero >= 1000000 THEN
            resultado := num_centenas((entero / 1000000)::INT) || ' MILLONES';
            entero := entero % 1000000;
        END IF;

        IF entero >= 1000 THEN
            IF entero / 1000 = 1 THEN
                resultado := resultado || ' MIL';
            ELSE
                resultado := resultado || ' ' || num_centenas((entero / 1000)::INT) || ' MIL';
            END IF;
            entero := entero % 1000;
        END IF;

        IF entero > 0 THEN
            resultado := resultado || ' ' || num_centenas(entero::INT);
        END IF;
    END IF;

    resultado := TRIM(resultado) || ' CON ' || LPAD(decimal::TEXT, 2, '0') || '/100' || ' DÓLARES';

    RETURN resultado;
END;
$$;


ALTER FUNCTION public.numero_a_letras(num numeric) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 16390)
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
-- TOC entry 219 (class 1259 OID 16391)
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
-- TOC entry 220 (class 1259 OID 16400)
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
-- TOC entry 221 (class 1259 OID 16408)
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
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 221
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_id_seq OWNED BY public.caja.id;


--
-- TOC entry 222 (class 1259 OID 16409)
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
-- TOC entry 223 (class 1259 OID 16417)
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
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 223
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;


--
-- TOC entry 224 (class 1259 OID 16418)
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
-- TOC entry 225 (class 1259 OID 16423)
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
-- TOC entry 226 (class 1259 OID 16431)
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
-- TOC entry 227 (class 1259 OID 16437)
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
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 227
-- Name: contingencia_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contingencia_detalle_id_seq OWNED BY public.contingencia_detalle.id;


--
-- TOC entry 228 (class 1259 OID 16438)
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
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 228
-- Name: contingencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contingencia_id_seq OWNED BY public.contingencia.id;


--
-- TOC entry 229 (class 1259 OID 16439)
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
-- TOC entry 230 (class 1259 OID 16446)
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
-- TOC entry 231 (class 1259 OID 16454)
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
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 231
-- Name: empresa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.empresa_id_seq OWNED BY public.empresa.id;


--
-- TOC entry 232 (class 1259 OID 16455)
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
-- TOC entry 233 (class 1259 OID 16463)
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
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 233
-- Name: invalidacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invalidacion_id_seq OWNED BY public.invalidacion.id;


--
-- TOC entry 234 (class 1259 OID 16464)
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
-- TOC entry 235 (class 1259 OID 16471)
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
-- TOC entry 236 (class 1259 OID 16479)
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
    CONSTRAINT producto_tipo_check CHECK (((tipo)::text = ANY (ARRAY[('PRODUCTO'::character varying)::text, ('SERVICIO'::character varying)::text])))
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16491)
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
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 237
-- Name: producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;


--
-- TOC entry 260 (class 1259 OID 16873)
-- Name: respuestas_dte_mh; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.respuestas_dte_mh (
    id integer NOT NULL,
    venta_id bigint,
    estado character varying(255),
    respuesta text,
    json_enviado text,
    firma text,
    sello_mh character varying(255),
    fecha timestamp without time zone
);


ALTER TABLE public.respuestas_dte_mh OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 16872)
-- Name: respuestas_dte_mh_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.respuestas_dte_mh_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.respuestas_dte_mh_id_seq OWNER TO postgres;

--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 259
-- Name: respuestas_dte_mh_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.respuestas_dte_mh_id_seq OWNED BY public.respuestas_dte_mh.id;


--
-- TOC entry 238 (class 1259 OID 16492)
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
-- TOC entry 239 (class 1259 OID 16498)
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
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 239
-- Name: rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;


--
-- TOC entry 240 (class 1259 OID 16499)
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
-- TOC entry 241 (class 1259 OID 16507)
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
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 241
-- Name: sucursal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sucursal_id_seq OWNED BY public.sucursal.id;


--
-- TOC entry 242 (class 1259 OID 16508)
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
-- TOC entry 243 (class 1259 OID 16516)
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
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 243
-- Name: tipo_contingencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_contingencia_id_seq OWNED BY public.tipo_contingencia.id;


--
-- TOC entry 244 (class 1259 OID 16517)
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
-- TOC entry 245 (class 1259 OID 16524)
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
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 245
-- Name: tipo_contribuyente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_contribuyente_id_seq OWNED BY public.tipo_contribuyente.id;


--
-- TOC entry 246 (class 1259 OID 16525)
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
-- TOC entry 247 (class 1259 OID 16531)
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
-- TOC entry 248 (class 1259 OID 16539)
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
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 248
-- Name: tipo_invalidacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_invalidacion_id_seq OWNED BY public.tipo_invalidacion.id;


--
-- TOC entry 249 (class 1259 OID 16540)
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
-- TOC entry 250 (class 1259 OID 16547)
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
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 250
-- Name: tipo_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_pago_id_seq OWNED BY public.tipo_pago.id;


--
-- TOC entry 251 (class 1259 OID 16548)
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
-- TOC entry 252 (class 1259 OID 16554)
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
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 252
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- TOC entry 253 (class 1259 OID 16555)
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
    contingencia smallint DEFAULT 0
);


ALTER TABLE public.venta OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 16583)
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
-- TOC entry 255 (class 1259 OID 16600)
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
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 255
-- Name: venta_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.venta_detalle_id_seq OWNED BY public.venta_detalle.id;


--
-- TOC entry 256 (class 1259 OID 16601)
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
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 256
-- Name: venta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.venta_id_seq OWNED BY public.venta.id;


--
-- TOC entry 257 (class 1259 OID 16602)
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
-- TOC entry 258 (class 1259 OID 16610)
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
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 258
-- Name: venta_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.venta_pago_id_seq OWNED BY public.venta_pago.id;


--
-- TOC entry 261 (class 1259 OID 17070)
-- Name: vw_dte_reporte; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_dte_reporte AS
 SELECT 'FACTURA ELETRÓNICA'::text AS tipo_doc_string,
    v.id,
    v.codigo_generacion,
    v.numero_control,
    v.sello_mh,
        CASE
            WHEN (v.contingencia IS NOT NULL) THEN 'Modelo Facturación diferido'::text
            ELSE 'Modelo Facturación previo'::text
        END AS modelo_facturacion,
        CASE
            WHEN (v.contingencia IS NOT NULL) THEN 'Transmición por contingencia'::text
            ELSE 'Transmición normal'::text
        END AS tipo_transimicion,
    v.fecha AS fecha_transmicion,
    e.nombre_empresa AS nombre_emisor,
    e.no_registro AS nrc_emisor,
    e.nit AS nit_emisor,
    a.nombre_actividad_economica AS actividad_economica_emisor,
    e.direccion AS direccion_emisor,
    e.telefono AS telefono_emisor,
    e.correo AS correo_emisor,
    v.nombre_factura AS nombre_receptor,
    ''::character varying AS nrc_receptor,
    ''::character varying AS nit_receptor,
    v.doc_factura AS identificacion_receptor,
    ''::text AS actividad_economica_receptor,
    ''::text AS direccion_receptor,
    ''::character varying AS telefono_receptor,
    v.correo AS correo_receptor,
    vd.producto_id AS codigo_producto,
    vd.cantidad AS cantidad_producto,
    'Unidad'::text AS unidad_producto,
    p.descripcion AS descripcion_producto,
    vd.precio_unitario AS precio_producto,
    vd.descuento AS descuento_producto,
    vd.iva AS iva_producto,
    vd.sub_total AS sub_total_producto,
    vd.total_linea AS total_producto,
    v.subtotal AS subtotal_venta,
    v.descuento AS descuento_venta,
    v.iva AS iva_venta,
    v.retencion AS retencion_venta,
    v.percepcion AS percepcion_venta,
    v.total AS total_venta,
    ''::text AS nombre_doc_rel,
    ''::text AS cod_gen_rel,
    NULL::timestamp without time zone AS fecha_rel,
    public.numero_a_letras(v.total) AS numero_a_letras,
    v.codigo_generacion_anulacion
   FROM (((((((public.venta v
     JOIN public.venta_detalle vd ON ((vd.venta_id = v.id)))
     JOIN public.producto p ON ((p.id = vd.producto_id)))
     JOIN public.usuario u ON ((u.id = v.usuario_id)))
     JOIN public.caja c ON ((c.id = u.caja_id)))
     JOIN public.sucursal s ON ((s.id = c.sucursal_id)))
     JOIN public.empresa e ON ((e.id = s.empresa_id)))
     JOIN public.actividad_economica a ON (((a.id)::text = (e.codigo_actividad_id)::text)))
  WHERE ((v.tipo_documento_id)::text = '01'::text)
UNION ALL
 SELECT 'COMPROBANTE DE CRÉDITO FISCAL'::text AS tipo_doc_string,
    v.id,
    v.codigo_generacion,
    v.numero_control,
    v.sello_mh,
        CASE
            WHEN (v.contingencia IS NOT NULL) THEN 'Modelo Facturación diferido'::text
            ELSE 'Modelo Facturación previo'::text
        END AS modelo_facturacion,
        CASE
            WHEN (v.contingencia IS NOT NULL) THEN 'Transmición por contingencia'::text
            ELSE 'Transmición normal'::text
        END AS tipo_transimicion,
    v.fecha AS fecha_transmicion,
    e.nombre_empresa AS nombre_emisor,
    e.no_registro AS nrc_emisor,
    e.nit AS nit_emisor,
    a.nombre_actividad_economica AS actividad_economica_emisor,
    e.direccion AS direccion_emisor,
    e.telefono AS telefono_emisor,
    e.correo AS correo_emisor,
    cli.nombre_cliente AS nombre_receptor,
    cli.no_registro AS nrc_receptor,
    cli.nit AS nit_receptor,
    ''::character varying AS identificacion_receptor,
    ac.nombre_actividad_economica AS actividad_economica_receptor,
    cli.direccion AS direccion_receptor,
    cli.telefono AS telefono_receptor,
    cli.correo AS correo_receptor,
    vd.producto_id AS codigo_producto,
    vd.cantidad AS cantidad_producto,
    'Unidad'::text AS unidad_producto,
    p.descripcion AS descripcion_producto,
    vd.precio_unitario AS precio_producto,
    vd.descuento AS descuento_producto,
    vd.iva AS iva_producto,
    vd.sub_total AS sub_total_producto,
    vd.total_linea AS total_producto,
    v.subtotal AS subtotal_venta,
    v.descuento AS descuento_venta,
    v.iva AS iva_venta,
    v.retencion AS retencion_venta,
    v.percepcion AS percepcion_venta,
    v.total AS total_venta,
    ''::text AS nombre_doc_rel,
    ''::text AS cod_gen_rel,
    NULL::timestamp without time zone AS fecha_rel,
    public.numero_a_letras(v.total) AS numero_a_letras,
    v.codigo_generacion_anulacion
   FROM (((((((((public.venta v
     JOIN public.venta_detalle vd ON ((vd.venta_id = v.id)))
     JOIN public.producto p ON ((p.id = vd.producto_id)))
     JOIN public.usuario u ON ((u.id = v.usuario_id)))
     JOIN public.caja c ON ((c.id = u.caja_id)))
     JOIN public.sucursal s ON ((s.id = c.sucursal_id)))
     JOIN public.empresa e ON ((e.id = s.empresa_id)))
     JOIN public.actividad_economica a ON (((a.id)::text = (e.codigo_actividad_id)::text)))
     JOIN public.cliente cli ON ((cli.id = v.cliente_id)))
     JOIN public.actividad_economica ac ON (((ac.id)::text = (cli.codigo_actividad_id)::text)))
  WHERE ((v.tipo_documento_id)::text = '03'::text)
UNION ALL
 SELECT 'NOTA DE CRÉDITO'::text AS tipo_doc_string,
    v.id,
    v.codigo_generacion,
    v.numero_control,
    v.sello_mh,
        CASE
            WHEN (v.contingencia IS NOT NULL) THEN 'Modelo Facturación diferido'::text
            ELSE 'Modelo Facturación previo'::text
        END AS modelo_facturacion,
        CASE
            WHEN (v.contingencia IS NOT NULL) THEN 'Transmición por contingencia'::text
            ELSE 'Transmición normal'::text
        END AS tipo_transimicion,
    v.fecha AS fecha_transmicion,
    e.nombre_empresa AS nombre_emisor,
    e.no_registro AS nrc_emisor,
    e.nit AS nit_emisor,
    a.nombre_actividad_economica AS actividad_economica_emisor,
    e.direccion AS direccion_emisor,
    e.telefono AS telefono_emisor,
    e.correo AS correo_emisor,
    cli.nombre_cliente AS nombre_receptor,
    cli.no_registro AS nrc_receptor,
    cli.nit AS nit_receptor,
    ''::character varying AS identificacion_receptor,
    ac.nombre_actividad_economica AS actividad_economica_receptor,
    cli.direccion AS direccion_receptor,
    cli.telefono AS telefono_receptor,
    cli.correo AS correo_receptor,
    vd.producto_id AS codigo_producto,
    vd.cantidad AS cantidad_producto,
    'Unidad'::text AS unidad_producto,
    p.descripcion AS descripcion_producto,
    vd.precio_unitario AS precio_producto,
    vd.descuento AS descuento_producto,
    vd.iva AS iva_producto,
    vd.sub_total AS sub_total_producto,
    vd.total_linea AS total_producto,
    v.subtotal AS subtotal_venta,
    v.descuento AS descuento_venta,
    v.iva AS iva_venta,
    v.retencion AS retencion_venta,
    v.percepcion AS percepcion_venta,
    v.total AS total_venta,
    td.nombre AS nombre_doc_rel,
    vr.codigo_generacion AS cod_gen_rel,
    vr.fecha AS fecha_rel,
    public.numero_a_letras(v.total) AS numero_a_letras,
    v.codigo_generacion_anulacion
   FROM (((((((((((public.venta v
     JOIN public.venta_detalle vd ON ((vd.venta_id = v.id)))
     JOIN public.producto p ON ((p.id = vd.producto_id)))
     JOIN public.usuario u ON ((u.id = v.usuario_id)))
     JOIN public.caja c ON ((c.id = u.caja_id)))
     JOIN public.sucursal s ON ((s.id = c.sucursal_id)))
     JOIN public.empresa e ON ((e.id = s.empresa_id)))
     JOIN public.actividad_economica a ON (((a.id)::text = (e.codigo_actividad_id)::text)))
     JOIN public.cliente cli ON ((cli.id = v.cliente_id)))
     JOIN public.actividad_economica ac ON (((ac.id)::text = (cli.codigo_actividad_id)::text)))
     JOIN public.venta vr ON ((vr.id = v.venta_id_nc)))
     JOIN public.tipo_documento td ON (((td.id)::text = (vr.tipo_documento_id)::text)))
  WHERE ((v.tipo_documento_id)::text = '05'::text);


ALTER VIEW public.vw_dte_reporte OWNER TO postgres;

--
-- TOC entry 4875 (class 2604 OID 16611)
-- Name: caja id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja ALTER COLUMN id SET DEFAULT nextval('public.caja_id_seq'::regclass);


--
-- TOC entry 4878 (class 2604 OID 16612)
-- Name: cliente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);


--
-- TOC entry 4883 (class 2604 OID 16613)
-- Name: contingencia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia ALTER COLUMN id SET DEFAULT nextval('public.contingencia_id_seq'::regclass);


--
-- TOC entry 4886 (class 2604 OID 16614)
-- Name: contingencia_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia_detalle ALTER COLUMN id SET DEFAULT nextval('public.contingencia_detalle_id_seq'::regclass);


--
-- TOC entry 4891 (class 2604 OID 16615)
-- Name: empresa id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa ALTER COLUMN id SET DEFAULT nextval('public.empresa_id_seq'::regclass);


--
-- TOC entry 4894 (class 2604 OID 16616)
-- Name: invalidacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion ALTER COLUMN id SET DEFAULT nextval('public.invalidacion_id_seq'::regclass);


--
-- TOC entry 4901 (class 2604 OID 16617)
-- Name: producto id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);


--
-- TOC entry 4956 (class 2604 OID 16876)
-- Name: respuestas_dte_mh id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas_dte_mh ALTER COLUMN id SET DEFAULT nextval('public.respuestas_dte_mh_id_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 16618)
-- Name: rol id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);


--
-- TOC entry 4909 (class 2604 OID 16619)
-- Name: sucursal id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal ALTER COLUMN id SET DEFAULT nextval('public.sucursal_id_seq'::regclass);


--
-- TOC entry 4912 (class 2604 OID 16620)
-- Name: tipo_contingencia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contingencia ALTER COLUMN id SET DEFAULT nextval('public.tipo_contingencia_id_seq'::regclass);


--
-- TOC entry 4915 (class 2604 OID 16621)
-- Name: tipo_contribuyente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contribuyente ALTER COLUMN id SET DEFAULT nextval('public.tipo_contribuyente_id_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 16622)
-- Name: tipo_invalidacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_invalidacion ALTER COLUMN id SET DEFAULT nextval('public.tipo_invalidacion_id_seq'::regclass);


--
-- TOC entry 4923 (class 2604 OID 16623)
-- Name: tipo_pago id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_pago ALTER COLUMN id SET DEFAULT nextval('public.tipo_pago_id_seq'::regclass);


--
-- TOC entry 4927 (class 2604 OID 16624)
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- TOC entry 4930 (class 2604 OID 16625)
-- Name: venta id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta ALTER COLUMN id SET DEFAULT nextval('public.venta_id_seq'::regclass);


--
-- TOC entry 4945 (class 2604 OID 16626)
-- Name: venta_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_detalle ALTER COLUMN id SET DEFAULT nextval('public.venta_detalle_id_seq'::regclass);


--
-- TOC entry 4952 (class 2604 OID 16627)
-- Name: venta_pago id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_pago ALTER COLUMN id SET DEFAULT nextval('public.venta_pago_id_seq'::regclass);


--
-- TOC entry 5202 (class 0 OID 16391)
-- Dependencies: 219
-- Data for Name: actividad_economica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actividad_economica (id, nombre_actividad_economica, created_at, updated_at) FROM stdin;
01111	Cultivo de cereales excepto arroz y para forrajes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01112	Cultivo de legumbres	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01113	Cultivo de semillas oleaginosas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01114	Cultivo de plantas para la preparación de semillas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01119	Cultivo de otros cereales excepto arroz y forrajeros n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01120	Cultivo de arroz	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01131	Cultivo de raíces y tubérculos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01132	Cultivo de brotes, bulbos, vegetales tubérculos y cultivos similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01133	Cultivo horticola de fruto	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01134	Cultivo de hortalizas de hoja y otras hortalizas ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01140	Cultivo de caña de azucar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01150	Cultivo de tabaco	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01161	Cultivo de algodón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01162	Cultivo de fibras vegetales excepto algodón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01191	Cultivo de plantas no perennes para la producción de semillas y flores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01192	Cultivo de cereales y pastos para la alimentación animal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01199	Producción de cultivos no estacionales ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01220	Cultivo de frutas tropicales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01230	Cultivo de cítricos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01240	Cultivo de frutas de pepita y hueso	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01251	Cultivo de frutas ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01252	Cultivo de otros frutos y nueces de árboles y arbustos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01260	Cultivo de frutos oleaginosos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01271	Cultivo de café	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01272	Cultivo de plantas para la elaboración de bebidas excepto café	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01281	Cultivo de especias y aromáticas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01282	Cultivo de plantas para la obtención de productos medicinales y farmacéuticos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01291	Cultivo de árboles de hule (caucho) para la obtención de látex	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01292	Cultivo de plantas para la obtención de productos químicos y colorantes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01299	Producción de cultivos perennes ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01300	Propagación de plantas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01301	Cultivo de plantas y flores ornamentales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01410	Cría y engorde de ganado bovino	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01420	Cría de caballos y otros equinos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01440	Cría de ovejas y cabras	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01450	Cría de cerdos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01460	Cría de aves de corral y producción de huevos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01491	Cría de abejas apicultura para la obtención de miel y otros productos apícolas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01492	Cría de conejos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01493	Cría de iguanas y garrobos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01494	Cría de mariposas y otros insectos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01499	Cría y obtención de productos animales n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01500	Cultivo de productos agrícolas en combinación con la cría de animales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01611	Servicios de maquinaria agrícola	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01612	Control de plagas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01613	Servicios de riego	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01614	Servicios de contratación de mano de obra para la agricultura	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01619	Servicios agrícolas ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01621	Actividades para mejorar la reproducción, el crecimiento y el rendimiento de los animales y sus productos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01622	Servicios de mano de obra pecuaria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01629	Servicios pecuarios ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01631	Labores post cosecha de preparación de los productos agrícolas para su comercialización o para la industria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01632	Servicio de beneficio de café	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01633	Servicio de beneficiado de plantas textiles (incluye el beneficiado cuando este es realizado en la misma explotación agropecuaria)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01640	Tratamiento de semillas para la propagación	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
01700	Caza ordinaria y mediante trampas, repoblación de animales de caza y servicios conexos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
02100	Silvicultura y otras actividades forestales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
02200	Extracción de madera	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
02300	Recolección de productos diferentes a la madera	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
02400	Servicios de apoyo a la silvicultura	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
03110	Pesca marítima de altura y costera	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
03120	Pesca de agua dulce	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
03210	Acuicultura marítima	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
03220	Acuicultura de agua dulce	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
03300	Servicios de apoyo a la pesca y acuicultura	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
05100	Extracción de hulla	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
05200	Extracción y aglomeración de lignito	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
06100	Extracción de petróleo crudo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
06200	Extracción de gas natural	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
07100	Extracción de minerales de hierro	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
07210	Extracción de minerales de uranio y torio	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
07290	Extracción de minerales metalíferos no ferrosos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
08100	Extracción de piedra, arena y arcilla	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
08910	Extracción de minerales para la fabricación de abonos y productos quimicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
08920	Extracción y aglomeración de turba	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
08930	Extracción de sal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
08990	Explotación de otras minas y canteras ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
09100	Actividades de apoyo a la extracción de petróleo y gas natural	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
09900	Actividades de apoyo a la explotación de minas y canteras	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10101	Servicio de rastros y mataderos de bovinos y porcinos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10102	Matanza y procesamiento de bovinos y porcinos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10103	Matanza y procesamientos de aves de corral	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10104	Elaboración y conservación de embutidos y tripas naturales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10105	Servicios de conservación y empaque de carnes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10106	Elaboración y conservación de grasas y aceites animales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10107	Servicios de molienda de carne	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10108	Elaboración de productos de carne ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10201	Procesamiento y conservación de pescado, crustáceos y moluscos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10209	Fabricación de productos de pescado ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10301	Elaboración de jugos de frutas y hortalizas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10302	Elaboración y envase de jaleas, mermeladas y frutas deshidratadas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10309	Elaboración de productos de frutas y hortalizas n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10401	Fabricación de aceites y grasas vegetales y animales comestibles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10402	Fabricación de aceites y grasas vegetales y animales no comestibles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10409	Servicio de maquilado de aceites	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10501	Fabricación de productos lácteos excepto sorbetes y quesos sustitutos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10502	Fabricación de sorbetes y helados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10503	Fabricación de quesos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10611	Molienda de cereales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10612	Elaboración de cereales para el desayuno y similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10613	Servicios de beneficiado de productos agrícolas ncp (excluye Beneficio de azúcar rama 1072 y beneficio de café rama 0163)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10621	Fabricación de almidón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10628	Servicio de molienda de maíz húmedo molino para nixtamal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10711	Elaboración de tortillas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10712	Fabricación de pan, galletas y barquillos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10713	Fabricación de repostería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10721	Ingenios azucareros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10722	Molienda de caña de azúcar para la elaboración de dulces	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10723	Elaboración de jarabes de azúcar y otros similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10724	Maquilado de azúcar de caña	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10730	Fabricación de cacao, chocolates y productos de confitería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10740	Elaboración de macarrones, fideos, y productos farináceos similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10750	Elaboración de comidas y platos preparados para la reventa en	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10791	Elaboración de productos de café	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10792	Elaboración de especies, sazonadores y condimentos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10793	Elaboración de sopas, cremas y consomé	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10794	Fabricación de bocadillos tostados y/o fritos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10799	Elaboración de productos alimenticios ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10800	Elaboración de alimentos preparados para animales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
11012	Fabricación de aguardiente y licores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
11020	Elaboración de vinos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
11030	Fabricacion de cerveza	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
11041	Fabricación de aguas gaseosas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
11042	Fabricación y envasado de agua	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
11043	Elaboración de refrescos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
11048	Maquilado de aguas gaseosas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
11049	Elaboración de bebidas no alcohólicas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
12000	Elaboración de productos de tabaco	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13111	Preparación de fibras textiles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13112	Fabricación de hilados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13120	Fabricación de telas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13130	Acabado de productos textiles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13910	Fabricación de tejidos de punto y ganchillo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13921	Fabricación de productos textiles para el hogar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13922	Sacos, bolsas y otros artículos textiles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13929	Fabricación de artículos confeccionados con materiales textiles, excepto prendas de vestir n.c.p	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13930	Fabricación de tapices y alfombras	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13941	Fabricación de cuerdas de henequén y otras fibras naturales (lazos, pitas)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13942	Fabricación de redes de diversos materiales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13948	Maquilado de productos trenzables de cualquier material (petates, sillas, etc.)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13991	Fabricación de adornos, etiquetas y otros artículos para prendas de vestir	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13992	Servicio de bordados en artículos y prendas de tela	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
13999	Fabricación de productos textiles ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14101	Fabricación de ropa interior, para dormir y similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14102	Fabricación de ropa para niños	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14103	Fabricación de prendas de vestir para ambos sexos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14104	Confección de prendas a medida	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14105	Fabricación de prendas de vestir para deportes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14106	Elaboración de artesanías de uso personal confeccionadas especialmente de materiales textiles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14108	Maquilado de prendas de vestir, accesorios y otros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14109	Fabricación de prendas y accesorios de vestir n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14200	Fabricación de artículos de piel	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14301	Fabricación de calcetines, calcetas, medias (panty house) y otros similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14302	Fabricación de ropa interior de tejido de punto	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
14309	Fabricación de prendas de vestir de tejido de punto ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
15110	Curtido y adobo de cueros; adobo y teñido de pieles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
15121	Fabricación de maletas, bolsos de mano y otros artículos de marroquinería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
15122	Fabricación de monturas, accesorios y vainas talabartería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
15123	Fabricación de artesanías principalmente de cuero natural y sintético	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
15128	Maquilado de artículos de cuero natural, sintético y de otros materiales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
15201	Fabricación de calzado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
15202	Fabricación de partes y accesorios de calzado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
15208	Maquilado de partes y accesorios de calzado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
16100	Aserradero y acepilladura de madera	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
16210	Fabricación de madera laminada, terciada, enchapada y contrachapada, paneles para la construcción	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
16220	Fabricación de partes y piezas de carpintería para edificios y construcciones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
16230	Fabricacion de envases y recipientes de madera	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
16292	Fabricación de artesanías de madera, semillas, materiales trenzables	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
16299	Fabricación de productos de madera, corcho, paja y materiales trenzables ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
17010	Fabricación de pasta de madera, papel y cartón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
17020	Fabricación de papel y cartón ondulado y envases de papel y cartón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
17091	Fabricación de artículos de papel y cartón de uso personal y doméstico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
17092	Fabricación de productos de papel ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
18110	Impresión	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
18120	Servicios relacionados con la impresión	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
18200	Reproducción de grabaciones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
19100	Fabricación de productos de hornos de coque	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
19201	Fabricación de combustible	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
19202	Fabricación de aceites y lubricantes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20111	Fabricación de materias primas para la fabricación de colorantes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20112	Fabricación de materiales curtientes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20113	Fabricación de gases industriales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20114	Fabricación de alcohol etilico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20119	Fabricación de sustancias químicas básicas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20120	Fabricación de abonos y fertilizantes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20130	Fabricación de plástico y caucho en formas primarias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20210	Fabricación de plaguicidas y otros productos químicos de uso agropecuario	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20220	Fabricación de pinturas, barnices y productos de revestimiento similares; tintas de imprenta y masillas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20231	Fabricación de jabones, detergentes y similares para limpieza	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20232	Fabricación de perfumes, cosméticos y productos de higiene y cuidado personal, incluyendo tintes, champú, etc.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20291	Fabricación de tintas y colores para escribir y pintar; fabricación de cintas para impresoras	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20292	Fabricación de productos pirotécnicos, explosivos y municiones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20299	Fabricación de productos químicos n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
20300	Fabricación de fibras artificiales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
21001	Manufactura de productos farmacéuticos, sustancias químicas y productos botánicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
21008	Maquilado de medicamentos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
22110	Fabricación de cubiertas y cámaras; renovación y recauchutado de cubiertas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
22190	Fabricacion de otros productos de caucho	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
22201	Fabricacion de envases plasticos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
22202	Fabricación de productos plasticos para uso personal o doméstico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
22208	Maquila de plásticos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
22209	Fabricación de productos plásticos n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23101	Fabricación de vidrio	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23102	Fabricación de recipientes y envases de vidrio	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23108	Servicio de maquilado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23109	Fabricación de productos de vidrio ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23910	Fabricacion de productos refractarios	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23920	Fabricación de productos de arcilla para la construcción	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23931	Fabricación de productos de cerámica y porcelana no refractaria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23932	Fabricación de productos de cerámica y porcelana ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23940	Fabricación de cemento, cal y yeso	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23950	Fabricación de artículos de hormigón, cemento y yeso	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23960	Corte, tallado y acabado de la piedra	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
23990	Fabricación de productos minerales no metálicos ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
24100	Industrias básicas de hierro y acero	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
24200	Fabricación de productos primarios de metales preciosos y metales no ferrosos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
24310	Fundición de hierro y acero	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
24320	Fundición de metales no ferrosos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25111	Fabricación de productos metálicos para uso estructural	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25118	Servicio de maquila para la fabricación de estructuras metálicas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25120	Fabricación de tanques, depósitos y recipientes de metal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25130	Fabricación de generadores de vapor, excepto calderas de agua caliente para calefacción central	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25200	Fabricación de armas y municiones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25910	Forjado, prensado, estampado y laminado de metales; pulvimetalurgia	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25920	Tratamiento y revestimiento de metales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25930	Fabricación de artículos de cuchillería, herramientas de mano y artículos de ferretería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25991	Fabricación de envases y artículos conexos de metal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25992	Fabricación de artículos metálicos de uso personal y/o doméstico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
25999	Fabricación de productos elaborados de metal ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
26100	Fabricación de componentes electrónicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
26200	Fabricación de computadoras y equipo conexo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
26300	Fabricación de equipo de comunicaciones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
26400	Fabricación de aparatos electrónicos de consumo para audio, video radio y televisión	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
26510	Fabricación de instrumentos y aparatos para medrr, verificar, ensayar, navegar y de control de procesos industriales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
26520	Fabricación de relojes y piezas de relojes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
26600	Fabricación de equipo médico de irradiación y equipo electrónico de uso médico y terapéutico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
26700	Fabricación de instrumentos de óptica y equipo fotográfico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
26800	Fabricación de medios magnéticos y ópticos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
27100	Fabricación de motores, generadores, transformadores eléctricos, aparatos de distribución y control de electricidad	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
27200	Fabricación de pilas, baterías y acumuladores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
27310	Fabricación de cables de fibra óptica	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
27320	Fabricación de otros hilos y cables eléctricos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
27330	Fabricación de dispositivos de cableados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
27400	Fabricación de equipo eléctrico de iluminación	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
27500	Fabricación de aparatos de uso doméstico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
27900	Fabricación de otros tipos de equipo eléctrico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28110	Fabricación de motores y turbinas, excepto motores para aeronaves, vehículos automotores y motocicletas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28120	Fabricación de equipo hidráulico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28130	Fabricación de otras bombas, compresores, grifos y válvulas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28140	Fabricación de cojinetes, engranajes, trenes de engranajes y piezas de transmisión	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28150	Fabricación de hornos y quemadores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28160	Fabricación de equipo de elevación y manipulación	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28170	Fabricación de maquinaria y equipo de oficina	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28180	Fabricación de herramientas manuales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28190	Fabricación de otros tipos de maquinaria de uso general	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28210	Fabricación de maquinaria agropecuaria y forestal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28220	Fabricación de máquinas para conformar metales y maquinaria herramienta	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28230	Fabricación de maquinaria metalúrgica	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28240	Fabricación de maquinaria para la explotación de minas y canteras y para obras de construcción	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28250	Fabricación de maquinaria para la elaboración de alimentos, bebidas y tabaco	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28260	Fabricación de maquinaria para la elaboración de productos textiles, prendas de vestir y cueros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28291	Fabricación de máquinas para imprenta	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
28299	Fabricación de maquinaria de uso especial ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
29100	Fabricación vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
29200	Fabricación de carrocerías para vehículos automotores; fabricación de remolques y semiremolques	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
29300	Fabricación de partes, piezas y accesorios para vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
30110	Fabricación de buques	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
30120	Construcción y reparación de embarcaciones de recreo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
30200	Fabricación de locomotoras y de material rodante	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
30300	Fabricación de aeronaves y naves espaciales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
30400	Fabricación de vehículos militares de combate	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
30910	Fabricación de motocicletas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
30920	Fabricación de bicicletas y sillones de ruedas para inválidos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
30990	Fabricación de equipo de transporte ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
31001	Fabricación de colchones y somier	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
31002	Fabricación de muebles y otros productos de madera a medida	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
31008	Servicios de maquilado de muebles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
31009	Fabricación de muebles ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32110	Fabricación de joyas platerías y joyerías	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32120	Fabricación de joyas de imitación (fantasía) y artículos conexos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32200	Fabricación de instrumentos musicales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32301	Fabricación de artículos de deporte	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32308	Servicio de maquila de productos deportivos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32401	Fabricación de juegos de mesa y de salón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32402	Servicio de maquilado de juguetes y juegos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32409	Fabricación de juegos y juguetes n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32500	Fabricación de instrumentos y materiales médicos y odontológicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32901	Fabricación de lápices, bolígrafos, sellos y artículos de librería en general	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32902	Fabricación de escobas, cepillos, pinceles y similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32903	Fabricación de artesanías de materiales diversos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32904	Fabricación de artículos de uso personal y domésticos n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32905	Fabricación de accesorios para las confecciones y la marroquinería n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32908	Servicios de maquila ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
32909	Fabricacion de productos manufacturados n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
33110	Reparación y mantenimiento de productos elaborados de metal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
33120	Reparación y mantenimiento de maquinaria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
33130	Reparación y mantenimiento de equipo electrónico y óptico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
33140	Reparación y mantenimiento de equipo eléctrico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
33150	Reparación y mantenimiento de equipo de transporte, excepto vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
33190	Reparación y mantenimiento de equipos n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
33200	Instalación de maquinaria y equipo industrial	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
35101	Generación de energía eléctrica	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
35102	Transmision de energía eléctrica	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
35103	Distribución de energía eléctrica	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
35200	Fabricación de gas, distribución de combustibles gaseosos por tuberías	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
35300	Suministro de vapor y agua caliente	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
36000	Captación, tratamiento y suministro de agua	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
37000	Evacuación de aguas residuales (alcantarillado)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38110	Recolección y transporte de desechos sólidos proveniente de hogares y sector urbano	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38120	Recolección de desechos peligrosos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38210	Tratamiento y eliminación de desechos inicuos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38220	Tratamiento y eliminación de desechos peligrosos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38301	Reciclaje de desperdicios y desechos textiles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38302	Reciclaje de desperdicios y desechos de plástico y caucho	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38303	Reciclaje de desperdicios y desechos de vidrio	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38304	Reciclaje de desperdicios y desechos de papel y cartón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38305	Reciclaje de desperdicios y desechos metálicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
38309	Reciclaje de desperdicios y desechos no metálicos n.c.p	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
39000	Actividades de Saneamiento y otros Servicios de Gestión de Desechos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
41001	Construcción de edificios residenciales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
41002	Construcción de edificios no residenciales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
42100	Construcción de carreteras, calles y caminos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
42200	Construcción de proyectos de servicio público	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
42900	Construcción de obras de ingeniería civil n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
43110	Demolición	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
43120	Preparación de terreno	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
43210	Instalaciones eléctricas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
43220	Instalación de fontanería, calefacción y aire acondicionado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
43290	Otras instalaciones para obras de construcción	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
43300	Terminacion y acabado de edificios	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
43900	Otras actividades especializadas de construcción	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
43901	Fabricación de techos y materiales diversos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45100	Venta de vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45201	Reparación mecánica de vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45202	Reparaciones eléctricas del automotor y recarga de baterías	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45203	Enderezado y pintura de vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45204	Reparaciones de radiadores, escapes y silenciadores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45205	Reparación y reconstrucción de vías, stop y otros artículos de fibra de vidrio	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45206	Reparación de llantas de vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45207	Polarizado de vehículos (mediante la adhesión de papel especial a los vidrios)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45208	Lavado y pasteado de vehículos (carwash)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45209	Reparaciones de vehículos n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45211	Remolque de vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45301	Venta de partes, piezas y accesorios nuevos para vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45302	Venta de partes, piezas y accesorios usados para vehículos automotores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45401	Venta de motocicletas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45402	Venta de repuestos, piezas y accesorios de motocicletas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
45403	Mantenimiento y reparación de motocicletas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46100	Venta al por mayor a cambio de retribución o por contrata	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46201	Venta al por mayor de materias primas agrícolas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46202	Venta al por mayor de productos de la silvicultura	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46203	Venta al por mayor de productos pecuarios y de granja	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46211	Venta de productos para uso agropecuario	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46291	Venta al por mayor de granos básicos (cereales, leguminosas)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46292	Venta al por mayor de semillas mejoradas para cultivo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46293	Venta al por mayor de café oro y uva	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46294	Venta al por mayor de caña de azúcar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46295	Venta al por mayor de flores, plantas y otros productos naturales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46296	Venta al por mayor de productos agrícolas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46297	Venta al por mayor de ganado bovino (vivo)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46298	Venta al por mayor de animales porcinos, ovinos, caprino, canículas, apícolas, avícolas vivos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46299	Venta de otras especies vivas del reino animal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46301	Venta al por mayor de alimentos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46302	Venta al por mayor de bebidas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46303	Venta al por mayor de tabaco	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46371	Venta al por mayor de frutas, hortalizas (verduras), legumbres y tubérculos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46372	Venta al por mayor de pollos, gallinas destazadas, pavos y otras aves	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46373	Venta al por mayor de carne bovina y porcina, productos de carne y embutidos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46374	Venta al por mayor de huevos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46375	Venta al por mayor de productos lácteos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46376	Venta al por mayor de productos farináceos de panadería (pan dulce, cakes, respostería, etc.)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46377	Venta al por mayor de pastas alimenticias, aceites y grasas comestibles vegetal y animal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46378	Venta al por mayor de sal comestible	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46379	Venta al por mayor de azúcar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46391	Venta al por mayor de abarrotes (vinos, licores, productos alimenticios envasados, etc.)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46392	Venta al por mayor de aguas gaseosas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46393	Venta al por mayor de agua purificada	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46394	Venta al por mayor de refrescos y otras bebidas, liquidas o en polvo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46395	Venta al por mayor de cerveza y licores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46396	Venta al por mayor de hielo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46411	Venta al por mayor de hilados, tejidos y productos textiles de mercería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46412	Venta al por mayor de articulos textiles excepto confecciones para el hogar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46413	Venta al por mayor de confecciones textiles para el hogar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46414	Venta al por mayor de prendas de vestir y accesorios de vestir	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46415	Venta al por mayor de ropa usada	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46416	Venta al por mayor de calzado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46417	Venta al por mayor de artículos de marroquinería y talabartería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46418	Venta al por mayor de articulos de peleteria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46419	Venta al por mayor de otros artículos textiles n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46471	Venta al por mayor de instrumentos musicales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46472	Venta al por mayor de colchones, almohadas, cojines, etc.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46473	Venta al por mayor de artículos de aluminio para el hogar y para otros usos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46474	Venta al por mayor de depósitos y otros artículos plásticos para el hogar y otros usos, incluyendo los desechables de durapax y no desechables	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46475	Venta al por mayor de cámaras fotográficas, accesorios y materiales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46482	Venta al por mayor de medicamentos, artículos y otros productos de uso veterinario	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46483	Venta al por mayor de productos y artículos de belleza y de uso personal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46484	Venta de productos farmacéuticos y medicinales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46491	Venta al por mayor de productos medicinales, cosméticos, perfumería y productos de limpieza	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46492	Venta al por mayor de relojes y artículos de joyería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46493	Venta al por mayor de electrodomésticos y artículos del hogar excepto bazar; artículos de iluminación	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46494	Venta al por mayor de artículos de bazar y similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46495	Venta al por mayor de artículos de óptica	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46496	Venta al por mayor de revistas, periódicos, libros, artículos de librería y artículos de papel y cartón en general	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46497	Venta de artículos deportivos, juguetes y rodados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46498	Venta al por mayor de productos usados para el hogar o el uso personal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46499	Venta al por mayor de enseres domésticos y de uso personal n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46500	Venta al por mayor de bicicletas, partes, accesorios y otros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46510	Venta al por mayor de computadoras, equipo periférico y programas informáticos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46520	Venta al por mayor de equipos de comunicación	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46530	Venta al por mayor de maquinaria y equipo agropecuario, accesorios, partes y suministros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46590	Venta de equipos e instrumentos de uso profesional y científico y aparatos de medida y control	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46591	Venta al por mayor de maquinaria equipo, accesorios y materiales para la industria de la madera y sus productos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46592	Venta al por mayor de maquinaria, equipo, accesorios y materiales para la industria gráfica y del papel, cartón y productos de papel y cartón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46593	Venta al por mayor de maquinaria, equipo, accesorios y materiales para la industria de productos químicos, plástico y caucho	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46594	Venta al por mayor de maquinaria, equipo, accesorios y materiales para la industria metálica y de sus productos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46595	Venta al por mayor de equipamiento para uso médico, odontológico, veterinario y servicios conexos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46596	Venta al por mayor de maquinaria, equipo, accesorios y partes para la industria de la alimentación	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46597	Venta al por mayor de maquinaria, equipo, accesorios y partes para la industria textil, confecciones y cuero	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46598	Venta al por mayor de maquinaria, equipo y accesorios para la construcción y explotación de minas y canteras	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46599	Venta al por mayor de otro tipo de maquinaria y equipo con sus accesorios y partes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46610	Venta al por mayor de otros combustibles sólidos, líquidos, gaseosos y de productos conexos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46612	Venta al por mayor de combustibles para automotores, aviones, barcos, maquinaria y otros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46613	Venta al por mayor de lubricantes, grasas y otros aceites para automotores, maquinaria industrial, etc.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46614	Venta al por mayor de gas propano	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46615	Venta al por mayor de leña y carbón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46620	Venta al por mayor de metales y minerales metaliferos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46631	Venta al por mayor de puertas, ventanas, vitrinas y similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46632	Venta al por mayor de artículos de ferretería y pinturerías	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46633	Vidrierías	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46634	Venta al por mayor de maderas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46639	Venta al por mayor de materiales para la construcción n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46691	Venta al por mayor de sal industrial sin yodar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46692	Venta al por mayor de productos intermedios y desechos de origen textil	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46693	Venta al por mayor de productos intermedios y desechos de origen metálico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46694	Venta al por mayor de productos intermedios y desechos de papel y cartón	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46695	Venta al por mayor fertilizantes, abonos, agroquímicos y productos similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46696	Venta al por mayor de productos intermedios y desechos de origen plástico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46697	Venta al por mayor de tintas para imprenta, productos curtientes y materias y productos colorantes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46698	Venta de productos intermedios y desechos de origen químico y de caucho	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46699	Venta al por mayor de productos intermedios y desechos ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46701	Venta de algodón en oro	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46900	Venta al por mayor de otros productos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46901	Venta al por mayor de cohetes y otros productos pirotécnicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46902	Venta al por mayor de artículos diversos para consumo humano	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46903	Venta al por mayor de armas de fuego, municiones y accesorios	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46904	Venta al por mayor de toldos y tiendas de campafia de cualquier material	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46905	Venta al por mayor de exhibidores publicitarios y rótulos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
46906	Venta al por mayor de artículos promocionales diversos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47111	Venta en supermercados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47112	Venta en tiendas de artículos de primera necesidad	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47119	Almacenes (venta de diversos artículos)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47190	Venta al por menor de otros productos en comercios no especializados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47199	Venta de establecimientos no especializados con surtido compuesto principalmente de alimentos, bebidas y tabaco	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47211	Venta al por menor de frutas y hortalizas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47212	Venta al por menor de carnes, embutidos y productos de granja	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47213	Venta al por menor de pescado y mariscos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47214	Venta al por menor de productos lácteos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47215	Venta al por menor de productos de panadería, repostería y galletas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47216	Venta al por menor de huevos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47217	Venta al por menor de carnes y productos cárnicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47218	Venta al por menor de granos básicos y otros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47219	Venta al por menor de alimentos n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47221	Venta al por menor de hielo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47223	Venta de bebidas no alcohólicas, para su consumo fuera del establecimiento	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47224	Venta de bebidas alcohólicas, para su consumo fuera del establecimiento	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47225	Venta de bebidas alcohólicas para su consumo dentro del establecimiento	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47230	Venta al por menor de tabaco	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47300	Venta de combustibles, lubricantes y otros (gasolineras)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47411	Venta al por menor de computadoras y equipo periférico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47412	Venta de equipo y accesorios de telecomunicación	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47420	Venta al por menor de equipo de audio y video	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47510	Venta al por menor de hilados, tejidos y productos textiles de mercería; confecciones para el hogar y textiles n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47521	Venta al por menor de productos de madera	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47522	Venta al por menor de artículos de ferretería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47523	Venta al por menor de productos de pinturerías	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47524	Venta al por menor en vidrierías	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47529	Venta al por menor de materiales de construcción y artículos conexos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47530	Venta al por menor de tapices, alfombras y revestimientos de paredes y pisos en comercios especializados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47591	Venta al por menor de muebles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47592	Venta al por menor de artículos de bazar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47593	Venta al por menor de aparatos electrodomésticos, repuestos y accesorios	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47594	Venta al por menor de artículos eléctricos y de iluminacion	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47598	Venta al por menor de instrumentos musicales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47610	Venta al por menor de libros, periódicos y artículos de papelería en comercios especializados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47620	Venta al por menor de discos láser, cassettes, cintas de video y otros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47630	Venta al por menor de productos y equipos de deporte	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47631	Venta al por menor de bicicletas, accesorios y repuestos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47640	Venta al por menor de juegos y juguetes en comercios especializados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47711	Venta al por menor de prendas de vestir y accesorios de vestir	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47712	Venta al por menor de calzado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47713	Venta al por menor de artículos de peletería, marroquinería y talabartería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47721	Venta al por menor de medicamentos farmacéuticos y otros materiales y artículos de uso médico, odontológico y veterinario	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47722	Venta al por menor de productos cosméticos y de tocador	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47731	Venta al por menor de productos de joyería, bisutería, óptica, relojería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47732	Venta al por menor de plantas, semillas, animales y artículos conexos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47733	Venta al por menor de combustibles de uso doméstico (gas propano y gas licuado)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47734	Venta al por menor de artesanías, artículos cerámicos y recuerdos en general	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47735	Venta al por menor de ataúdes, lápidas y cruces, trofeos, artículos religiosos en general	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47736	Venta al por menor de armas de fuego, municiones y accesorios	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47737	Venta al por menor de artículos de cohetería y pirotécnicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47738	Venta al por menor de artículos desechables de uso personal y domeéstico (servilletas, papel higiénico, pañales, toallas sanitarias, etc.)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47739	Venta al por menor de otros productos n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47741	Venta al por menor de artículos usados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47742	Venta al por menor de textiles y confecciones usados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47743	Venta al por menor de libros, revistas, papel y cartón usados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47749	Venta al por menor de productos usados n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47811	Venta al por menor de frutas, verduras y hortalizas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47814	Venta al por menor de productos lácteos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47815	Venta al por menor de productos de panadería, galletas y similares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47816	Venta al por menor de bebidas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47818	Venta al por menor en tiendas de mercado y puestos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47821	Venta al por menor de hilados, tejidos y productos textiles de mercería en puestos de mercados y ferias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47822	Venta al por menor de artículos textiles excepto confecciones para el hogar en puestos de mercados y ferias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47823	Venta al por menor de confecciones textiles para el hogar en puestos de mercados y ferias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47824	Venta al por menor de prendas de vestir, accesorios de vestir y similares en puestos de mercados y ferias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47825	Venta al por menor de ropa usada	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47826	Venta al por menor de calzado, artículos de marroquinería y talabartería en puestos de mercados y ferias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47827	Venta al por menor de artículos de marroquinería y talabartería en puestos de mercados y ferias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47829	Venta al por menor de artículos textiles ncp en puestos de mercados y ferias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47891	Venta al por menor de animales, flores y productos conexos en puestos de feria y mercados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47892	Venta al por menor de productos medicinales, cosméticos, de tocador y de limpieza en puestos de ferias y mercados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47893	Venta al por menor de artículos de bazar en puestos de ferias y mercados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47894	Venta al por menor de artículos de papel, envases, libros, revistas y conexos en puestos de feria y mercados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47895	Venta al por menor de materiales de construcción, electrodomésticos, accesorios para autos y similares en puestos de feria y mercados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47896	Venta al por menor de equipos accesorios para las comunicaciones en puestos de feria y mercados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47899	Venta al por menor en puestos de ferias y mercados n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47910	Venta al por menor por correo o Internet	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
47990	Otros tipos de venta al por menor no realizada, en almacenes, puestos de venta o mercado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49110	Transporte interurbano de pasajeros por ferrocarril	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49120	Transporte de carga por ferrocarril	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49211	Transporte de pasajeros urbanos e interurbano mediante buses	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49212	Transporte de pasajeros interdepartamental mediante microbuses	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49213	Transporte de pasajeros urbanos e interurbano mediante microbuses	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49214	Transporte de pasajeros interdepartamental mediante buses	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49221	Transporte internacional de pasajeros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49222	Transporte de pasajeros mediante taxis y autos con chofer	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49223	Transporte escolar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49225	Transporte de pasajeros para excursiones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49226	Servicios de transporte de personal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49229	Transporte de pasajeros por vía terrestre ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49231	Transporte de carga urbano	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49232	Transporte nacional de carga	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49233	Transporte de carga internacional	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49234	Servicios de mudanza	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49235	Alquiler de vehículos de carga con conductor	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
49300	Transporte por oleoducto o gasoducto	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
50110	Transporte de pasajeros maritime y de cabotaje	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
50120	Transporte de carga marítimo y de cabotaje	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
50211	Transporte de pasajeros por vías de navegación interiores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
50212	Alquiler de equipo de transporte de pasajeros por vías de navegación interior con conductor	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
50220	Transporte de carga por vías de navegación interiores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
51100	Transporte aéreo de pasajeros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
51201	Transporte de carga por vía aérea	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
51202	Alquiler de equipo de aerotransporte con operadores para el propósito de transportar carga	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52101	Alquiler de instalaciones de almacenamiento en zonas francas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52102	Alquiler de silos para conservación y almacenamiento de granos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52103	Alquiler de instalaciones con refrigeración para almacenamiento y conservación de alimentos y otros productos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52109	Alquiler de bodegas para almacenamiento y depósito n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52211	Servicio de garaje y estacionamiento	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52212	Servicios de terminales para el transporte por vía terrestre	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52219	Servicios para el transporte por vía terrestre n.c.p	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52220	Servicios para el transporte acuático	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52230	Servicios para el transporte aéreo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52240	Manipulación de carga	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52290	Servicios para el transporte ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
52291	Agencias de tramitaciones aduanales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
53100	Servicios de correo nacional	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
53200	Actividades de correo distintas a las actividades postales nacionales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
53201	Agencia privada de correo y encomiendas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
55101	Actividades de alojamiento para estancias cortas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
55102	Hoteles	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
55200	Actividades de campamentos, parques de vehículos de recreo y parques de caravanas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
55900	Alojamiento n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56101	Restaurantes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56106	Pupusería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56107	Actividades varias de restaurantes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56108	Comedores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56109	Merenderos ambulantes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56210	Preparación de comida para eventos especiales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56291	Servicios de provisión de comidas por contrato	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56292	Servicios de concesión de cafetines y chalet en empresas e	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56299	Servicios de preparación de comidas ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56301	Servicio de expendio de bebidas en salones y bares	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
56302	Servicio de expendio de bebidas en puestos callejeros, mercados y ferias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
58110	Edición de libros, folletos, partituras y otras ediciones distintas a estas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
58120	Edición de directorios y listas de correos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
58130	Edición de periódicos, revistas y otras publicaciones periódicas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
58190	Otras actividades de edición	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
59110	Actividades de producción cinematográfica	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
59120	Actividades de post producción de películas, videos y programas de televisión	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
59130	Actividades de distribución de películas cinematográficas, videos y programas de televisión	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
59140	Actividades de exhibición de películas cinematográficas y cintas de vídeo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
59200	Actividades de edición y grabación de música	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
60100	Servicios de difusiones de radio	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
60201	Actividades de programación y difusión de televisión abierta	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
60202	Actividades de suscripción y difusión de televisión por cable y/o suscripción	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
60299	Servicios de televisión, incluye televisión por cable	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
60900	Programación y transmisión de radio y televisión	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61101	Servicio de telefonia	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61102	Servicio de Internet	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61103	Servicio de telefonia fija	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61109	Servicio de Internet n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61201	Servicios de telefonía celular	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61202	Servicios de Internet inalámbrico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61209	Servicios de telecomunicaciones inalámbrico n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61301	Telecomunicaciones satelitales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61309	Comunicacion via satélite n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
61900	Actividades de telecomunicación n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
62010	Programación Informática	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
62020	Consultorías y gestión de servicios informáticos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
62090	Otras actividades de tecnología de información y servicios de computadora	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
63110	Procesamiento de datos y actividades relacionadas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
63120	Portales WEB	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
63910	Servicios de Agencias de Noticias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
63990	Otros servicios de información n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64110	Servicios provistos por el Banco Central de El salvador	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64190	Bancos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64192	Entidades dedicadas al envío de remesas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64199	Otras entidades financieras	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64200	Actividades de sociedades de cartera	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64300	Fideicomisos, fondos y otras fuentes de financiamiento	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64910	Arrendamientos financieros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64920	Asociaciones cooperativas de ahorro y crédito dedicadas a la intermediación financiera	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64921	Instituciones emisoras de tarjetas de crédito y otros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64922	Tipos de crédito ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64928	Prestamistas y casas de empeño	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
64990	Actividades de servicios financieros, excepto la financiacion de planes de seguros y de pensiones n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
65110	Planes de seguros de vida	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
65120	Planes de seguro excepto de vida	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
65199	Seguros generales de todo tipo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
65200	Planes se seguro	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
65300	Planes de pensiones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
66110	Administración de mercados financieros (Bolsa de Valores)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
66120	Actividades bursátiles (Corredores de Bolsa)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
66190	Actividades auxiliares de la intermediación financiera ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
66210	Evaluación de riesgos y daños	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
66220	Actividades de agentes y corredores de seguros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
66290	Otras actividades auxiliares de seguros y fondos de pensiones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
68101	Servicio de alquiler y venta de lotes en cementerios	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
68109	Actividades inmobiliarias realizadas con bienes propios o arrendados n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
68200	Actleidades Inmobiliarias Realizadas a Cambio de una Retribución o por Contrata	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
69100	Actividades jurídicas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
69200	Actividades de contabilidad, teneduría de libros y auditoría; asesoramiento en materia de impuestos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
70100	Actividades de oficinas centrales de sociedades de cartera	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
70200	Actividades de consultoría en gestión empresarial	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
71101	Servicios de arquitectura y planificación urbana y servicios conexos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
71102	Servicios de ingeniería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
71103	Servicios de agrimensura, topografía, cartografía, prospección y geofísica y servicios conexos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
71200	Ensayos y análisis técnicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
72100	Investigaciones y desarrollo experimental en el campo de las ciencias naturales y la ingeniería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
72199	Investigaciones científicas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
72200	Investigaciones y desarrollo experimental en el campo de las ciencias sociales y las humanidades científica y desarrollo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
73100	Publicidad	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
73200	Investigación de mercados y realización de encuestas de opinión pública	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
74100	Actividades de diseño especializado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
74200	Actividades de fotografía	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
74900	Servicios profesionales y científicos ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
75000	Actividades veterinarias	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
77101	Alquiler de equipo de transporte terrestre	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
77102	Alquiler de equipo de transporte acuático	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
77103	Alquiler de equipo de transporte por vía aérea	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
77210	Alquiler y arrendamiento de equipo de recreo y deportivo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
77220	Alquiler de cintas de video y discos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
77290	Alquiler de otros efectos personales y enseres domésticos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
77300	Alquiler de maquinaria y equipo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
77400	Arrendamiento de productos de propiedad intelectual	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
78100	Obtención y dotación de personal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
78200	Actividades de las agencias de trabajo temporal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
78300	Detación de recursos humanos y gestion; gestión de las funciones de recursos humanos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
79110	Actividades de agencias de viajes y organizadores de viajes; actividades de asistencia a turistas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
79120	Actividades de los operadores turísticos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
79900	Otros servicios de reservas y actividades relacionadas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
80100	Servicios de seguridad privados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
80201	Actividades de servicios de sistemas de seguridad	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
80202	Actividades para la prestación de sistemas de seguridad	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
80300	Actividades de investigación	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
81100	Actividades combinadas de mantenimiento de edificios e instalaciones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
81210	Limpieza general de edificios	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
81290	Otras actividades combinadas de mantenimiento de edificios e instalaciones ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
81300	Servicio de jardinería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
82110	Servicios administrativos de oficinas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
82190	Servicio de fotocopiado y similares, excepto en imprentas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
82200	Actividades de las centrales de llamadas (call center)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
82300	Organización de convenciones y ferias de negocios	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
82910	Actividades de agencias de cobro y oficinas de crédito	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
82921	Servicios de envase y empaque de productos alimenticios	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
82922	Servicios de envase y empaque de productos medicinales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
82929	Servicio de envase y empaque ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
82990	Actividades de apoyo empresariales ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
84110	Actividades de la Administración Pública en general	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
84111	Alcaldías Municipales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
84120	Regulación de las actividades de prestación de servicios sanitarios, educativos, culturales y otros servicios sociales, excepto seguridad social	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
84130	Regulación y facilitación de la actividad económica	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
84210	Actividades de administración y funcionamiento del Ministerio de Relaciones Exteriores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
84220	Actividades de defensa	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
84230	Actividades de mantenimiento del orden público y de seguridad	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
84300	Actividades de planes de seguridad social de afiliación obligatoria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85101	Guardería educativa	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85102	Enseñanza preescolar o parvularia	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85103	Enseñanza primaria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85104	Servicio de educación preescolar y primaria integrada	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85211	Enseñanza secundaria tercer ciclo (7°, 8* y 9°)	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85212	Enseñanza secundaria de formación general bachillerato	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85221	Enseñanza secundaria de formación técnica y profesional	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85222	Enseñanza secundaria de formación técnica y profesional integrada con enseñanza primaria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85301	Enseñanza superior universitaria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85302	Enseñanza superior no universitaria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85303	Enseñanza superior integrada a educación secundaria y/o primaria	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85410	Educación deportiva y recreativa	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85420	Educación cultural	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85490	Otros tipos de enseñanza n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85499	Enseñanza formal	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
85500	Servicios de apoyo a la enseñanza	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
86100	Actividades de hospitales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
86201	Clínicas médicas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
86202	Servicios de Odontología	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
86203	Servicios médicos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
86901	Servicios de análisis y estudios de diagnóstico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
86902	Actividades de atención de la salud humana	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
86909	Otros Servicio relacionados con la salud ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
87100	Residencias de ancianos con atención de enfermería	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
87200	Instituciones dedicadas al tratamiento del retraso mental, problemas de salud mental y el uso indebido de sustancias nocivas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
87300	Instituciones dedicadas al cuidado de ancianos y discapacitados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
87900	Actividades de asistencia a nifios y jóvenes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
87901	Otras actividades de atención en instituciones	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
88100	Actividades de asistencia sociales sin alojamiento para ancianos y discapacitados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
88900	servicios sociales sin alojamiento ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
90000	Actividades creativas artísticas y de esparcimiento	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
91010	Actividades de bibliotecas y archivos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
91020	Actividades de museos y preservación de lugares y edificios históricos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
91030	Actividades de jardines botánicos, zoológicos y de reservas naturales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
92000	Actividades de juegos y apuestas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
93110	Gestión de instalaciones deportivas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
93120	Actividades de clubes deportivos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
93190	Otras actividades deportivas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
93210	Actividades de parques de atracciones y parques temáticos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
93291	Discotecas y salas de baile	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
93298	Centros vacacionales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
93299	Actividades de esparcimiento ncp	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
94110	Actividades de organizaciones empresariales y de empleadores	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
94120	Actividades de organizaciones profesionales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
94200	Actividades de sindicatos	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
94910	Actividades de organizaciones religiosas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
94920	Actividades de organizaciones políticas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
94990	Actividades de asociaciones n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95110	Reparación de computadoras y equipo periférico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95120	Reparación de equipo de comunicación	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95210	Reparación de aparatos electrónicos de consumo	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95220	Reparación de aparatos doméstico y equipo de hogar y jardín	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95230	Reparación de calzado y artículos de cuero	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95240	Reparación de muebles y accesorios para el hogar	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95291	Reparación de Instrumentos musicales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95292	Servicios de cerrajería y copiado de llaves	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95293	Reparación de joyas y relojes	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95294	Reparación de bicicletas, sillas de ruedas y rodados n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
95299	Reparaciones de enseres personales n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
96010	Lavado y limpieza de prendas de tela y de piel, incluso la limpieza en SECO	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
96020	Peluquería y otros tratamientos de belleza	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
96030	Pompas fúnebres y actividades conexas	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
96091	Servicios de sauna y otros servicios para la estética corporal n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
96092	Servicios n.c.p.	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
97000	Actividad de los hogares en calidad de empleadores de personal doméstico	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
98100	Actividades indiferenciadas de producción de bienes de los hogares privados para uso propio	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
98200	Actividades indiferenciadas de producción de servicios de los hogares privados para uso propio	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
99000	Actividades de organizaciones y órganos extraterritoriales	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10001	Empleados	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10002	Pensionado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10003	Estudiante	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10004	Desempleado	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10005	Otros	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
10006	Comerciante	2025-09-27 17:23:09.981882	2025-09-27 17:23:09.981882
58200	Edición de programas informáticos (software)	2025-09-27 17:23:09.981882	2026-01-02 10:22:41.600629
\.


--
-- TOC entry 5203 (class 0 OID 16400)
-- Dependencies: 220
-- Data for Name: caja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja (id, descripcion, punto_venta_mh, sucursal_id, created_at, updated_at) FROM stdin;
1	CAJA 1 DE SUCURSAL MATRIZ	P001	1	2025-09-27 22:02:35.334635	2025-11-06 12:27:52.616942
\.


--
-- TOC entry 5205 (class 0 OID 16409)
-- Dependencies: 222
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (id, nombre_cliente, no_registro, nit, dui, telefono, correo, codigo_actividad_id, direccion, departamento_id, municipio_id, tipo_contribuyente_id, estado, created_at, updated_at) FROM stdin;
1	CONSUMIDOR FINAL	0-0	0000-000000-000-0	00000000-0	0000-0000		\N		\N	\N	2	0	2025-09-27 22:07:23.878807	2025-11-06 14:46:03.928653
3	dariouz orellana	2-7	2665-465465-465-4	06195149-2	7898-5327	dariouzorellanalopez@gmail.com	58200	10 av norte	02	0217	1	1	2025-11-05 09:51:37.497014	2026-01-07 10:31:36.170399
6	Usuario de prueba						\N		\N	\N	\N	1	2025-12-30 16:43:31.379134	2026-01-07 10:33:18.173179
\.


--
-- TOC entry 5207 (class 0 OID 16418)
-- Dependencies: 224
-- Data for Name: contador_dte; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contador_dte (tipo_documento_id, contador, anio, sucursal_id, created_at, updated_at) FROM stdin;
05	4	2025	1	2025-10-04 17:33:38.100124	2025-12-30 12:10:46.814544
03	4	2025	1	2025-10-04 17:33:23.011925	2025-12-30 12:52:21.706068
01	34	2025	1	2025-10-04 17:33:03.233254	2025-12-30 17:38:48.239285
05	1	2026	1	2026-01-06 12:55:38.329675	2026-01-06 12:55:38.329675
01	7	2026	1	2026-01-05 21:24:06.438879	2026-01-07 10:34:19.435591
03	5	2026	1	2026-01-06 10:16:37.518807	2026-01-07 11:25:46.863238
\.


--
-- TOC entry 5208 (class 0 OID 16423)
-- Dependencies: 225
-- Data for Name: contingencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contingencia (id, codigo_generacion, sello_contingencia, f_inicio, f_fin, tipo_contingencia_id, motivo_contingencia, created_at, updated_at) FROM stdin;
1	BCA9AAAC-3F63-4563-85CA-03CBFCA2008C	1123123	2025-10-29	2025-10-29	1	Se fue la internet	2025-10-29 20:26:33.885433	2025-11-20 17:20:20.103475
2	51A271AC-7641-4307-A33C-6B7C66290C3A	\N	2025-12-29	2025-12-29	3	qwewqe	2025-12-29 12:58:38.416606	2025-12-29 12:58:38.416606
3	7FE51A56-3734-4836-A958-6013874D8929	123	2025-12-29	2025-12-29	1	qweqwe	2025-12-29 13:05:52.285087	2025-12-30 09:23:13.121129
4	967448B2-AD90-4F73-AEFD-CC7DFAF47BF7	\N	2025-12-30	2025-12-30	1	qweqwewq	2025-12-30 17:49:17.356933	2025-12-30 17:49:17.356933
5	2C46722F-5DFA-47AD-8966-502D41BB6801	\N	2025-12-30	2025-12-30	2	qweqwewq	2025-12-30 17:53:33.746742	2025-12-30 17:53:33.746742
6	02E85D76-76A8-4DAF-B711-9BD62F81B654	\N	2025-12-30	2025-12-30	2	qweqwe	2025-12-30 17:54:02.425679	2025-12-30 17:54:02.425679
7	05466856-0626-443D-AAF5-26312F2A1152	\N	2025-12-30	2025-12-30	2	qwewqe	2025-12-30 18:01:12.804004	2025-12-30 18:01:12.804004
\.


--
-- TOC entry 5209 (class 0 OID 16431)
-- Dependencies: 226
-- Data for Name: contingencia_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contingencia_detalle (id, contingencia_id, venta_id, created_at, updated_at) FROM stdin;
1	1	5	2025-10-29 20:26:33.914992	2025-10-29 20:26:33.914992
2	2	40	2025-12-29 12:58:38.449434	2025-12-29 12:58:38.449434
3	3	40	2025-12-29 13:05:52.326408	2025-12-29 13:05:52.326408
4	4	40	2025-12-30 17:49:17.373795	2025-12-30 17:49:17.373795
5	5	40	2025-12-30 17:53:33.808226	2025-12-30 17:53:33.808226
6	6	40	2025-12-30 17:54:32.088445	2025-12-30 17:54:32.088445
7	7	40	2025-12-30 18:01:19.676611	2025-12-30 18:01:19.676611
\.


--
-- TOC entry 5212 (class 0 OID 16439)
-- Dependencies: 229
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departamento (id, nombre_departamento, created_at, updated_at) FROM stdin;
00	Otro (Para extranjeros)	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
01	Ahuachapán	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
02	Santa Ana	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
03	Sonsonate	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
04	Chalatenango	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
05	La Libertad	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
06	San Salvador	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
07	Cuscatlán	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
08	La  Paz	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
09	Cabañas	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
10	San Vicente	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
11	Usulután	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
12	San Miguel	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
13	Morazán	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
14	La Unión	2025-09-27 17:38:22.361741	2025-09-27 17:38:22.361741
\.


--
-- TOC entry 5213 (class 0 OID 16446)
-- Dependencies: 230
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empresa (id, nombre_empresa, telefono, correo, nombre_comercial, no_registro, nit, dui, codigo_actividad_id, direccion, departamento_id, municipio_id, tipo_contribuyente_id, estado, created_at, updated_at, representante_legal) FROM stdin;
1	CERRAJERÍA MASTER KEY	7086-7861	masterkeysv04@gmail.com	Cerrajería Master Key	1-1	0302-090266-101-0		95292	10 Av Norte y 3era Calle Poniente #2-12 Santa Tecla, La Libertad Sur, La Libertad	05	0528	1	1	2025-09-27 21:53:17.311716	2025-11-14 12:06:15.629251	CARLOS ALBERTO ORELLANA BARRIENTOS
\.


--
-- TOC entry 5215 (class 0 OID 16455)
-- Dependencies: 232
-- Data for Name: invalidacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invalidacion (id, codigo_generacion, sello_invalidacion, venta_id, tipo_anulacion_id, motivo_anulacion, nombre_responsable, tip_doc_responsable, num_doc_responsable, nombre_solicita, tip_doc_solicita, num_doc_solicita, fec_anula, created_at, updated_at) FROM stdin;
1	49B17E47-FE48-4D80-8603-26DA0E02AAE7	\N	15	1	qweqwewqewqe	CARLOS ALBERTO ORELLANA BARRIENTOS	36	0302-090266-101-0	qweqwewqe	36	1231-231231-312-3	2025-11-20	2025-11-20 17:49:26.047479	2025-11-20 17:49:26.047479
2	9590F2F9-3698-4166-9BA0-C09452EA2723	\N	40	2	qweqwe	CARLOS ALBERTO ORELLANA BARRIENTOS	36	0302-090266-101-0	qwe	13	06195149-2	2025-12-29	2025-12-29 11:49:39.478107	2025-12-29 12:55:15.890221
3	206F5049-E221-4C04-8233-D79E7AFB5771	123	61	1	qweqwe	CARLOS ALBERTO ORELLANA BARRIENTOS	36	0302-090266-101-0	qwewqe	13	06195149-2	2025-12-31	2025-12-31 08:48:38.783088	2025-12-31 09:58:15.57943
\.


--
-- TOC entry 5217 (class 0 OID 16464)
-- Dependencies: 234
-- Data for Name: municipio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.municipio (id, nombre_municipio, departamento_id, created_at, updated_at, municipio_id) FROM stdin;
0000	Otro (Para extranjeros)	00	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	00
0113	AHUACHAPAN NORTE	01	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	13
0114	AHUACHAPAN CENTRO	01	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	14
0115	AHUACHAPAN SUR	01	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	15
0214	SANTA ANA NORTE	02	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	14
0215	SANTA ANA CENTRO	02	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	15
0216	SANTA ANA ESTE	02	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	16
0217	SANTA ANA OESTE	02	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	17
0317	SONSONATE NORTE	03	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	17
0318	SONSONATE CENTRO	03	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	18
0319	SONSONATE ESTE	03	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	19
0320	SONSONATE OESTE	03	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	20
0434	CHALATENANGO NORTE	04	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	34
0435	CHALATENANGO CENTRO	04	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	35
0436	CHALATENANGO SUR	04	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	36
0523	LA LIBERTAD NORTE	05	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	23
0524	LA LIBERTAD CENTRO	05	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	24
0525	LA LIBERTAD OESTE	05	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	25
0526	LA LIBERTAD ESTE	05	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	26
0527	LA LIBERTAD COSTA	05	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	27
0528	LA LIBERTAD SUR	05	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	28
0620	SAN SALVADOR NORTE	06	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	20
0621	SAN SALVADOR OESTE	06	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	21
0622	SAN SALVADOR ESTE	06	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	22
0623	SAN SALVADOR CENTRO	06	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	23
0624	SAN SALVADOR SUR	06	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	24
0717	CUSCATLAN NORTE	07	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	17
0718	CUSCATLAN SUR	07	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	18
0823	LA PAZ OESTE	08	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	23
0824	LA PAZ CENTRO	08	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	24
0825	LA PAZ ESTE	08	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	25
0910	CABAÑAS OESTE	09	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	10
0911	CABAÑAS ESTE	09	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	11
1014	SAN VICENTE NORTE	10	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	14
1015	SAN VICENTE SUR	10	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	15
1124	USULUTAN NORTE	11	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	24
1125	USULUTAN ESTE	11	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	25
1126	USULUTAN OESTE	11	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	26
1221	SAN MIGUEL NORTE	12	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	21
1222	SAN MIGUEL CENTRO	12	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	22
1223	SAN MIGUEL OESTE	12	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	23
1327	MORAZAN NORTE	13	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	27
1328	MORAZAN SUR	13	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	28
1419	LA UNION NORTE	14	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	19
1420	LA UNION SUR	14	2025-09-27 21:38:18.192748	2025-09-27 21:38:18.192748	20
\.


--
-- TOC entry 5218 (class 0 OID 16471)
-- Dependencies: 235
-- Data for Name: parametro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parametro (nombre_parametro, valor, created_at, updated_at) FROM stdin;
IVA	0.13	2025-09-27 22:31:18.165482	2025-09-27 22:31:18.165482
RETENCION	0.01	2025-10-23 20:29:00.984737	2025-10-23 20:29:00.984737
MONTO_RETENCION	100	2025-10-23 20:31:46.275334	2025-10-23 20:32:06.828893
CONTRIBUYENTE	1	2025-10-23 20:31:46.275334	2025-10-23 22:40:22.613271
ID_FACTURA	01	2025-10-27 20:03:43.505841	2025-10-27 20:03:43.505841
tokenMH	PRUEBITAS	2025-10-11 15:34:31.237098	2026-01-06 21:01:08.983049
MH_AMBIENTE	00	2025-11-06 16:22:42.022616	2025-11-06 16:22:42.022616
MH_URL_TOKEN	https://apitest.dtes.mh.gob.sv/seguridad/auth	2025-11-18 10:14:38.638566	2025-11-18 10:14:38.638566
MH_USER	123456798132	2025-11-18 17:38:14.443401	2025-11-18 17:38:14.443401
MH_PASS	ASDA654QW3$	2025-11-18 17:38:28.828733	2025-11-18 17:38:28.828733
MH_URL_ENVIO_DTE	https://apitest.dtes.mh.gob.sv/fesv/recepciondte	2025-11-18 17:56:53.847569	2025-11-18 17:56:53.847569
ID_CCF	03	2025-11-20 14:44:09.034608	2025-11-20 14:44:09.034608
ID_NC	05	2025-11-20 14:44:26.417739	2025-11-20 14:44:26.417739
MH_ESTABLECIMIENTO	01	2025-11-20 16:26:43.1367	2025-11-20 16:26:43.1367
MH_ESTABLE_DEFAULT	M001	2025-11-20 16:26:43.1367	2025-11-20 16:26:43.1367
MH_PUNTO_DEFAULT	P001	2025-11-20 16:26:43.1367	2025-11-20 16:26:43.1367
MH_VERSION_CONTINGENCIA	3	2025-11-20 16:28:19.34416	2025-11-20 16:28:19.34416
MH_PASS_PRIV	QWEQW123123D	2025-11-20 17:30:44.992113	2025-11-20 17:30:44.992113
MH_URL_FIRMADOR	http://localhost/firmarDocumento	2025-11-20 17:31:20.551245	2025-11-20 17:31:20.551245
MH_VERSION_INVALIDACION	2	2025-11-20 17:28:56.28086	2025-11-27 21:25:49.901705
MH_TOKEN	QEQWEQEQWE	2025-11-27 21:36:38.862759	2025-11-27 21:36:38.862759
MH_URL_CONTINGENCIA	https://apitest.dtes.mh.gob.sv/fesv/contingencia	2025-11-20 17:28:18.887581	2025-11-27 21:38:12.819658
MH_URL_INVALIDACION	https://apitest.dtes.mh.gob.sv/fesv/anulardte	2025-11-20 17:38:30.575572	2025-11-27 21:39:15.418196
HTML_CORREO_TEMPLATE	<!DOCTYPE html>\n<html lang="es">\n<head>\n    <meta charset="UTF-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">\n    <title>MasterKey</title>\n    <style>\n        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }\n        .container { width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }\n        .header { background-color: #003366; padding: 30px 20px; text-align: center; border-bottom: 4px solid #D4AF37; }\n        \n        /* Estilos para el Logo */\n        .logo-container { margin-bottom: 15px; }\n        .logo-container img { \n            max-width: 150px; /* Ajusta el tamaño máximo de tu logo */\n            height: auto;\n            display: inline-block;\n        }\n\n        .header h1 { color: #D4AF37; margin: 0; font-size: 28px; text-transform: uppercase; letter-spacing: 2px; }\n        .content { padding: 30px; color: #333333; line-height: 1.6; }\n        .invoice-box { background-color: #f9f9f9; border-left: 4px solid #003366; padding: 20px; margin: 20px 0; }\n        .footer { background-color: #f4f4f4; padding: 20px; text-align: center; font-size: 12px; color: #777777; }\n    </style>\n</head>\n<body>\n    <div class="container">\n        <div class="header">\n            <div class="logo-container">\n                <img src='cid:logoEmpresa' alt="Logo Empresa">\n            </div>\n            <h1>{nombre_empresa}</h1>\n        </div>\n\n        <div class="content">\n            <p>Estimado/a <strong>{nombre_cliente}</strong>,</p>\n            <p>Esperamos que el servicio realizado haya sido de su entera satisfacción. Adjunto a este correo encontrará la documentación fiscal correspondiente a su reciente servicio:</p>\n            \n            <div class="invoice-box">\n                <strong>Detalles del comprobante:</strong><br>\n                • Código generación: {codigo_generacion}<br>\n                • Numero control: {numero_control}<br>\n                • Sello: {sello}<br>\n                • Fecha y hora de emisión: {fecha_hora_emision}<br>\n                • Monto total: {monto_total}<br>\n            </div>\n\n            <p>Hemos adjuntado los archivos en formato <strong>PDF</strong> (para su visualización e impresión) y <strong>JSON</strong> (para su registro contable).</p>\n            \n            <p>Si tiene alguna duda sobre su factura o necesita asistencia adicional con sus cerraduras o sistemas de seguridad, no dude en contactarnos por WhatsApp: {telefono_empresa}.</p>\n            \n            <p>Atentamente,<br>\n            <strong>El equipo de {nombre_empresa}</strong></p>\n        </div>\n\n        <div class="footer">\n            <p>© {anio_actual} {nombre_empresa}. Todos los derechos reservados.<br>\n            {direccion_empresa} | WhatsApp: {telefono_empresa}</p>\n        </div>\n    </div>\n</body>\n</html>	2026-01-06 08:56:35.252606	2026-01-06 12:48:45.092955
\.


--
-- TOC entry 5219 (class 0 OID 16479)
-- Dependencies: 236
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (id, descripcion, precio, tipo, veces_usado, created_at, updated_at) FROM stdin;
1	DESTORNILLADOR PHILLIPS	1.25	PRODUCTO	0	2025-09-27 22:16:15.213685	2025-09-27 22:16:25.990005
5	CAMBIO DE COMBINACIÓN	12.35	SERVICIO	1	2025-11-05 11:24:34.514707	2025-11-06 15:50:20.750555
\.


--
-- TOC entry 5243 (class 0 OID 16873)
-- Dependencies: 260
-- Data for Name: respuestas_dte_mh; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.respuestas_dte_mh (id, venta_id, estado, respuesta, json_enviado, firma, sello_mh, fecha) FROM stdin;
1	33	RECHAZADO	16882	16881	16880	\N	2025-12-27 17:56:31.372908
2	34	RECHAZADO	16885	16884	16883	\N	2025-12-27 18:00:27.681247
3	35	RECHAZADO	16888	16887	16886	\N	2025-12-27 18:03:05.788355
4	36	RECHAZADO	16891	16890	16889	\N	2025-12-29 08:27:54.548008
5	37	RECHAZADO	16894	16893	16892	\N	2025-12-29 09:37:11.883818
6	38	RECHAZADO	16897	16896	16895	\N	2025-12-29 09:38:03.940287
7	39	RECHAZADO	16900	16899	16898	\N	2025-12-29 09:50:47.989995
8	40	RECHAZADO	16903	16902	16901	\N	2025-12-29 10:51:17.98745
9	41	RECHAZADO	16906	16905	16904	\N	2025-12-30 10:03:40.287698
10	43	RECHAZADO	16909	16908	16907	\N	2025-12-30 10:32:44.29892
11	44	RECHAZADO	16912	16911	16910	\N	2025-12-30 10:59:31.315845
12	45	RECHAZADO	16915	16914	16913	\N	2025-12-30 12:10:47.789228
13	46	RECHAZADO	16918	16917	16916	\N	2025-12-30 12:29:10.901609
14	47	RECHAZADO	16921	16920	16919	\N	2025-12-30 12:31:17.533052
15	48	RECHAZADO	16924	16923	16922	\N	2025-12-30 12:52:22.814716
16	49	RECHAZADO	16927	16926	16925	\N	2025-12-30 12:54:21.623192
17	50	RECHAZADO	16930	16929	16928	\N	2025-12-30 12:57:19.108256
18	51	RECHAZADO	16933	16932	16931	\N	2025-12-30 12:57:31.063525
19	52	RECHAZADO	16936	16935	16934	\N	2025-12-30 12:58:23.295587
20	53	RECHAZADO	16939	16938	16937	\N	2025-12-30 16:35:25.581319
21	54	RECHAZADO	16942	16941	16940	\N	2025-12-30 16:40:06.711304
22	55	RECHAZADO	16945	16944	16943	\N	2025-12-30 16:40:26.092944
23	56	RECHAZADO	16948	16947	16946	\N	2025-12-30 16:40:39.726883
24	57	RECHAZADO	16951	16950	16949	\N	2025-12-30 16:45:43.689719
25	58	RECHAZADO	16954	16953	16952	\N	2025-12-30 17:03:05.316241
26	59	RECHAZADO	16957	16956	16955	\N	2025-12-30 17:05:21.413092
27	60	RECHAZADO	16960	16959	16958	\N	2025-12-30 17:06:22.439016
28	60	RECHAZADO	16963	16962	16961	\N	2025-12-30 17:16:35.343914
29	60	RECHAZADO	16966	16965	16964	\N	2025-12-30 17:18:01.078344
30	60	RECHAZADO	16969	16968	16967	\N	2025-12-30 17:22:24.953925
31	60	RECHAZADO	16972	16971	16970	\N	2025-12-30 17:23:35.543994
32	60	RECHAZADO	16975	16974	16973	\N	2025-12-30 17:25:25.215216
33	60	RECHAZADO	16978	16977	16976	\N	2025-12-30 17:36:07.569326
34	60	RECHAZADO	16981	16980	16979	\N	2025-12-30 17:36:10.785708
35	60	RECHAZADO	16984	16983	16982	\N	2025-12-30 17:37:18.770991
36	60	RECHAZADO	16987	16986	16985	\N	2025-12-30 17:37:21.533353
37	60	RECHAZADO	16990	16989	16988	\N	2025-12-30 17:38:11.262674
38	60	RECHAZADO	16993	16992	16991	\N	2025-12-30 17:38:15.825288
39	60	RECHAZADO	16996	16995	16994	\N	2025-12-30 17:38:17.755989
40	59	RECHAZADO	16999	16998	16997	\N	2025-12-30 17:38:19.386657
41	60	RECHAZADO	17002	17001	17000	\N	2025-12-30 17:38:20.963774
42	60	RECHAZADO	17005	17004	17003	\N	2025-12-30 17:38:22.922961
43	60	RECHAZADO	17008	17007	17006	\N	2025-12-30 17:38:24.905133
44	60	RECHAZADO	17011	17010	17009	\N	2025-12-30 17:38:39.405953
45	60	RECHAZADO	17014	17013	17012	\N	2025-12-30 17:38:40.95352
46	61	RECHAZADO	17017	17016	17015	\N	2025-12-30 17:38:48.432123
47	40	RECHAZADO	17021	17020	17019	\N	2025-12-30 17:47:47.954429
48	40	RECHAZADO	17024	17023	17022	\N	2025-12-30 17:47:54.268797
49	40	RECHAZADO	17027	17026	17025	\N	2025-12-30 17:47:55.984812
50	40	RECHAZADO	17030	17029	17028	\N	2025-12-31 08:41:26.969974
51	40	RECHAZADO	17033	17032	17031	\N	2025-12-31 10:25:07.957104
52	63	RECHAZADO	17077	17076	17075	\N	2026-01-05 21:24:07.383849
53	63	RECHAZADO	17080	17079	17078	\N	2026-01-05 21:51:42.653692
54	63	RECHAZADO	17083	17082	17081	\N	2026-01-05 21:51:45.591466
55	62	RECHAZADO	17086	17085	17084	\N	2026-01-05 21:51:48.14739
56	63	RECHAZADO	17089	17088	17087	\N	2026-01-05 21:51:50.174627
57	63	RECHAZADO	17092	17091	17090	\N	2026-01-05 21:52:04.415176
58	62	RECHAZADO	17095	17094	17093	\N	2026-01-05 21:52:06.332216
59	63	RECHAZADO	17098	17097	17096	\N	2026-01-05 21:52:08.47993
60	40	RECHAZADO	17101	17100	17099	\N	2026-01-05 21:52:48.218856
61	40	RECHAZADO	17104	17103	17102	\N	2026-01-05 21:52:50.358481
62	40	RECHAZADO	17107	17106	17105	\N	2026-01-05 21:52:54.045358
63	64	RECHAZADO	17110	17109	17108	\N	2026-01-06 10:16:38.609295
64	65	RECHAZADO	17113	17112	17111	\N	2026-01-06 12:55:39.044505
65	67	RECHAZADO	17117	17116	17115	\N	2026-01-06 23:31:57.664686
66	68	RECHAZADO	17120	17119	17118	\N	2026-01-06 23:33:59.25741
67	69	RECHAZADO	17124	17123	17122	\N	2026-01-07 09:16:58.62721
68	70	RECHAZADO	17127	17126	17125	\N	2026-01-07 09:17:12.789216
69	71	RECHAZADO	17130	17129	17128	\N	2026-01-07 09:18:00.915477
70	40	RECHAZADO	17133	17132	17131	\N	2026-01-07 09:31:05.485399
71	40	RECHAZADO	17136	17135	17134	\N	2026-01-07 09:31:10.457708
72	72	RECHAZADO	17139	17138	17137	\N	2026-01-07 10:08:22.878364
73	73	RECHAZADO	17142	17141	17140	\N	2026-01-07 10:34:19.827816
74	74	RECHAZADO	17145	17144	17143	\N	2026-01-07 11:25:47.269247
75	40	RECHAZADO	17148	17147	17146	\N	2026-01-07 11:27:26.188022
76	40	RECHAZADO	17151	17150	17149	\N	2026-01-07 11:27:29.860566
77	40	RECHAZADO	17154	17153	17152	\N	2026-01-07 11:27:31.398703
78	40	RECHAZADO	17157	17156	17155	\N	2026-01-07 11:27:33.193849
79	74	RECHAZADO	17160	17159	17158	\N	2026-01-07 11:42:36.071919
80	74	RECHAZADO	17163	17162	17161	\N	2026-01-07 11:48:00.974721
81	74	RECHAZADO	17166	17165	17164	\N	2026-01-07 11:48:04.165921
82	74	RECHAZADO	17169	17168	17167	\N	2026-01-07 11:48:06.171449
\.


--
-- TOC entry 5221 (class 0 OID 16492)
-- Dependencies: 238
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rol (id, nombre_rol, created_at, updated_at) FROM stdin;
1	ADMIN	2025-09-27 22:05:15.174403	2025-09-27 22:05:15.174403
2	USUARIO	2025-09-27 22:05:22.469979	2025-09-27 22:05:22.469979
\.


--
-- TOC entry 5223 (class 0 OID 16499)
-- Dependencies: 240
-- Data for Name: sucursal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sucursal (id, nombre_sucursal, direccion, telefono, correo, establecimiento_mh, estado, empresa_id, created_at, updated_at) FROM stdin;
1	SUCURSAL MATRIZ	10 Av Norte y 3era Calle Poniente #2-12 Santa Tecla, La Libertad Sur, La Libertad	7086-7861	masterkeysv04@gmail.com	M001	0	1	2025-09-27 22:01:15.902348	2025-11-06 12:59:06.899016
\.


--
-- TOC entry 5225 (class 0 OID 16508)
-- Dependencies: 242
-- Data for Name: tipo_contingencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_contingencia (id, nombre, created_at, updated_at) FROM stdin;
1	No disponibilidad del sistema MH	2025-10-28 21:46:37.609683	2025-10-28 21:46:37.609683
2	No disponibilidad del sistema emisor	2025-10-28 21:46:55.814858	2025-10-28 21:46:55.814858
3	Falla en el suministro de servicio de Internet del Emisor	2025-10-28 21:47:29.48824	2025-10-28 21:47:29.48824
4	Falla en el suministro de servicio de energía eléctrica del emisor\r\nque impida la transmisión de los DTE	2025-10-28 21:47:49.158953	2025-10-28 21:47:49.158953
5	Otro (deberá digitar un máximo de 500 caracteres explicando el\r\nmotivo)	2025-10-28 21:48:08.008401	2025-10-28 21:48:08.008401
\.


--
-- TOC entry 5227 (class 0 OID 16517)
-- Dependencies: 244
-- Data for Name: tipo_contribuyente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_contribuyente (id, nombre, created_at, updated_at) FROM stdin;
1	PEQUEÑO CONTRIBUYENTE	2025-09-27 11:11:12.180657	2025-09-27 11:11:12.180657
2	MEDIANO CONTRIBUYENTE	2025-09-27 11:11:25.371883	2025-09-27 11:11:25.371883
3	GRAN CONTRIBUYENTE	2025-09-27 11:11:40.204374	2025-09-27 11:12:35.5167
\.


--
-- TOC entry 5229 (class 0 OID 16525)
-- Dependencies: 246
-- Data for Name: tipo_documento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_documento (id, nombre, nombre_corto, version_dte, created_at, updated_at) FROM stdin;
01	FACTURA	FAC	1	2025-09-27 22:14:04.574258	2025-09-27 22:14:04.574258
03	CREDITO FISCAL	CCF	3	2025-09-27 22:14:29.929165	2025-09-27 22:14:29.929165
05	NOTA DE CRÉDITO	NC	3	2025-09-27 22:14:57.910569	2025-09-27 22:14:57.910569
\.


--
-- TOC entry 5230 (class 0 OID 16531)
-- Dependencies: 247
-- Data for Name: tipo_invalidacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_invalidacion (id, nombre, created_at, updated_at) FROM stdin;
3	Otro	2025-10-30 21:35:58.310212	2025-10-30 21:35:58.310212
2	Rescindir de la operación realizada.	2025-10-30 21:35:46.661993	2025-10-30 21:58:02.876486
1	Error en la Información del Documento.	2025-10-30 21:35:32.418877	2025-10-30 23:08:30.889845
\.


--
-- TOC entry 5232 (class 0 OID 16540)
-- Dependencies: 249
-- Data for Name: tipo_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_pago (id, nombre, estado, created_at, updated_at) FROM stdin;
1	EFECTIVO	1	2025-09-27 22:17:38.54473	2025-09-27 22:17:38.54473
\.


--
-- TOC entry 5234 (class 0 OID 16548)
-- Dependencies: 251
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, username, password, rol_id, caja_id, created_at, updated_at) FROM stdin;
1	ADMIN	123	1	1	2025-09-27 22:05:46.381613	2025-11-06 09:29:26.731893
4	USUARIO	123	2	1	2026-01-06 20:37:50.257132	2026-01-06 20:37:50.257132
\.


--
-- TOC entry 5236 (class 0 OID 16555)
-- Dependencies: 253
-- Data for Name: venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venta (id, usuario_id, tipo_documento_id, cliente_id, fecha, codigo_generacion, numero_control, sello_mh, subtotal, descuento, iva, retencion, percepcion, total, codigo_generacion_contingencia, codigo_generacion_anulacion, intentos, estado, created_at, updated_at, nombre_factura, tipo_doc_factura, doc_factura, venta_id_nc, correo, contingencia) FROM stdin;
6	1	03	3	2025-11-06 14:58:37.284442	\N	\N	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-11-06 14:58:37.303004	2025-11-06 14:58:37.303004	dariouz orellana	DUI	06165149-2	\N	dariouzorellanalopez@gmail.com	\N
7	1	01	3	2025-11-06 15:51:50.180933	\N	\N	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-11-06 15:51:50.182959	2025-11-06 15:51:50.182959	dariouz orellana	DUI	06165149-2	\N	dariouzorellanalopez@gmail.com	\N
5	1	01	1	2025-10-27 21:36:46.74289	51423A71-FA56-1604-2778-282675454800	DTE-03-M001P002-000000000025415	51423A71-FA56-1604-2778-282675454800	1.11	0.00	0.14	0.00	0.00	1.25		\N	0	1	2025-10-27 21:36:46.777745	2025-11-06 17:52:10.192918	qweqwewqe	DUI	12312312-3	\N	qweqwe@qwec.om	\N
8	1	01	3	2025-11-10 15:07:31.797552	\N	\N	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-11-10 15:07:31.811908	2025-11-10 15:07:31.811908	dariouz orellana	DUI	06165149-2	\N	dariouzorellanalopez@gmail.com	\N
9	1	01	1	2025-11-14 14:25:38.99729	\N	\N	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-11-14 14:25:39.036159	2025-11-14 14:25:39.036159	QWEQWEWQE			\N		\N
13	1	05	3	2025-11-17 11:57:03.794977	A50338E0-E847-41A7-AE2F-B7D2BBB63A41	DTE-05-M001P001-000000000000002	\N	12.04	0.00	1.56	0.00	0.00	13.60		123	0	1	2025-11-17 11:57:03.812334	2026-01-02 16:48:04.629879	dariouz orellana	NRC	2-7	11	dariouzorellanalopez@gmail.com	\N
12	1	05	3	2025-11-14 16:56:17.909562	\N	\N	\N	12.04	0.00	1.56	0.00	0.00	13.60			0	1	2025-11-14 16:56:17.910784	2025-11-14 16:56:17.910784	dariouz orellana	NRC	2-7	11	dariouzorellanalopez@gmail.com	\N
14	1	01	1	2025-11-17 12:08:28.066408	\N	\N	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-11-17 12:08:28.09937	2025-11-17 12:08:28.09937	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
22	1	01	1	2025-12-26 19:04:51.472168	2D0FD5DE-7E58-4A8E-8032-322C465006F5	DTE-01-M001P001-000000000000003	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-12-26 19:05:02.121354	2025-12-26 19:06:10.696347	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
30	1	01	1	2025-12-27 16:32:22.966658	D9121985-6545-4776-9576-564E51A9AEC8	DTE-01-M001P001-000000000000011	\N	10.93	0.00	1.42	0.00	0.00	12.35			0	1	2025-12-27 16:32:22.958374	2025-12-27 16:32:22.958374	qweqwe	\N	\N	\N	\N	\N
23	1	01	1	2025-12-27 11:40:13.277895	95A33179-669E-4DF2-9328-BEBA42FBF84A	DTE-01-M001P001-000000000000004	\N	10.93	0.00	1.42	0.00	0.00	12.35			0	1	2025-12-27 11:40:13.2794	2025-12-27 11:40:35.439919	dariouz	\N	\N	\N	\N	\N
40	1	01	3	2025-12-29 10:51:17.053881	30381336-8800-42C4-816C-B0DD43D0BF37	DTE-01-M001P001-000000000000019	\N	10.93	0.00	1.42	0.00	0.00	12.35	05466856-0626-443D-AAF5-26312F2A1152		15	1	2025-12-29 10:51:17.051007	2026-01-07 11:27:33.204992	dariouz orellana	DUI	06195149-2	\N	dariouzorellanalopez@gmail.com	1
16	1	01	3	2025-11-27 20:47:05.734318	\N	\N	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-11-27 20:47:05.751752	2025-11-27 20:47:05.751752	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
17	1	03	3	2025-11-27 20:47:27.072075	\N	\N	\N	10.93	0.00	1.42	0.00	0.00	12.35			0	1	2025-11-27 20:47:27.074478	2025-11-27 20:47:27.074478	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
18	1	05	3	2025-11-27 20:47:56.550667	\N	\N	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-11-27 20:47:56.553004	2025-11-27 20:47:56.553004	dariouz orellana	NRC	2-7	15	dariouzorellanalopez@gmail.com	\N
19	1	01	1	2025-12-22 09:53:04.491216	\N	\N	\N	10.93	0.00	1.42	0.00	0.00	12.35			0	1	2025-12-22 09:53:04.5069	2025-12-22 09:59:07.136652	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
24	1	01	1	2025-12-27 11:42:39.497235	B3F8F400-CA80-4652-8AEC-2B4D863725DE	DTE-01-M001P001-000000000000005	\N	10.93	0.00	1.42	0.00	0.00	12.35			0	1	2025-12-27 11:42:39.498851	2025-12-27 11:42:41.558701	dariouz	\N	\N	\N	\N	\N
20	1	01	1	2025-12-26 19:03:53.607144	C04C7980-BB8A-4E11-8650-861FE1DD51C1	DTE-01-M001P001-000000000000001	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-12-26 19:03:53.626318	2025-12-26 19:03:53.706191	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
21	1	01	1	2025-12-26 19:04:12.394498	9B9FCAF8-1489-41F0-9F9F-4DABF5C48A97	DTE-01-M001P001-000000000000002	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-12-26 19:04:12.396028	2025-12-26 19:04:12.411751	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
25	1	01	1	2025-12-27 12:00:28.885716	64878338-FF5C-4BB6-9501-B420391004ED	DTE-01-M001P001-000000000000006	\N	10.93	0.00	1.42	0.00	0.00	12.35			0	1	2025-12-27 12:00:28.932471	2025-12-27 12:00:31.571242	qeqwe	\N	\N	\N	\N	\N
26	1	01	1	2025-12-27 12:07:12.747574	31A9EFBB-0D4B-48E7-A68B-FC209A044756	DTE-01-M001P001-000000000000007	\N	10.93	0.00	1.42	0.00	0.00	12.35			0	1	2025-12-27 12:07:12.785783	2025-12-27 12:07:15.578437	qweq	\N	\N	\N	\N	\N
27	1	01	1	2025-12-27 12:28:53.486517	A59C8011-2382-4841-862A-08992E32276D	DTE-01-M001P001-000000000000008	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-12-27 12:28:53.476765	2025-12-27 12:28:53.476765	rqweqwe	\N	\N	\N	\N	\N
28	1	01	1	2025-12-27 12:29:16.053642	F9D12E3F-E9C0-42A6-A96A-108E4E4D2225	DTE-01-M001P001-000000000000009	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-12-27 12:29:16.048032	2025-12-27 12:29:16.048032	rqweqwe	\N	\N	\N	\N	\N
29	1	01	1	2025-12-27 16:27:41.950564	02AAD769-1B21-4806-8217-6E676F3CDE72	DTE-01-M001P001-000000000000010	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-12-27 16:27:41.94234	2025-12-27 16:27:41.94234	qweqweqe	\N	\N	\N	\N	\N
33	1	01	1	2025-12-27 17:56:17.645476	0B629FC9-D532-42EA-9D44-DB79143429F3	DTE-01-M001P001-000000000000012	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-27 17:56:17.635352	2025-12-27 17:56:17.635352	qweqwe	\N	\N	\N	\N	\N
34	1	01	1	2025-12-27 17:59:42.202937	AB7B3C9D-1885-47BE-9739-C399430FD3CD	DTE-01-M001P001-000000000000013	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-27 17:59:42.198207	2025-12-27 17:59:42.198207	qweqwe	\N	\N	\N	\N	\N
35	1	01	1	2025-12-27 18:03:01.690782	8F1411DC-70CD-4746-825C-363EFD4122F0	DTE-01-M001P001-000000000000014	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-27 18:03:01.686534	2025-12-27 18:03:01.686534	qweqwe	\N	\N	\N	\N	\N
36	1	01	1	2025-12-29 08:27:45.836481	42BDEDF2-E4DD-4997-98DD-6A028424CB82	DTE-01-M001P001-000000000000015	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-29 08:27:45.81919	2025-12-29 08:27:45.81919	qwewq	\N	\N	\N	\N	\N
37	1	01	1	2025-12-29 09:36:54.561075	04AEB9F9-89A6-43CA-9074-E02A07905C6D	DTE-01-M001P001-000000000000016	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-29 09:36:54.555089	2025-12-29 09:36:54.555089	qweqwe	\N	\N	\N	\N	\N
38	1	01	1	2025-12-29 09:38:03.730065	A5448E6C-2CB2-4F2E-BF76-6972A2AE6668	DTE-01-M001P001-000000000000017	\N	10.93	0.00	1.42	0.00	0.00	12.35			1	1	2025-12-29 09:38:03.727019	2025-12-29 09:38:03.727019	qweqwe	\N	\N	\N	\N	\N
39	1	01	1	2025-12-29 09:50:47.185937	38A1C960-C5D9-4636-BB45-E7F569682E65	DTE-01-M001P001-000000000000018	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-29 09:50:47.181437	2025-12-29 09:50:47.181437	qqqq	\N	\N	\N	\N	\N
41	1	01	1	2025-12-30 10:03:39.388	E87B16C0-A0B8-4973-9E45-A2387EC0AC9D	DTE-01-M001P001-000000000000020	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 10:03:39.386046	2025-12-30 10:03:39.386046	CONSUMIDOR FINAL	NRC	2-7	\N	asdasdsad@qwe.com	\N
15	1	03	3	2025-11-20 17:45:15.094567	A50338E0-E847-41A7-AE2F-B7D2BBB63A41	DTE-05-M001P001-000000000000002	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-11-20 17:45:15.136019	2025-12-30 10:27:45.05803	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
11	1	03	3	2025-11-14 16:55:09.22427	51423A71-FA56-1604-2778-282675454800	DTE-03-M001P002-000000000025415	\N	12.04	0.00	1.56	0.00	0.00	13.60			0	1	2025-11-14 16:55:09.26046	2025-12-30 10:27:45.05803	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
10	1	03	1	2025-11-14 14:57:22.752361	51423A71-FA56-1604-2778-282675454800	DTE-03-M001P002-000000000025415	\N	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-11-14 14:57:22.785638	2025-12-30 10:27:45.05803	QWEQWEWQ	\N	\N	\N	\N	\N
55	1	01	1	2025-12-30 16:40:25.925461	6832BF03-39C3-4379-BEF9-84B8832E515D	DTE-01-M001P001-000000000000028	\N	10.93	0.00	1.42	0.00	0.00	12.35			1	1	2025-12-30 16:40:25.922065	2025-12-30 16:40:25.922065	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
43	1	03	3	2025-12-30 10:32:43.938742	57B2D0D2-C936-4495-A5DC-35C46B816B70	DTE-03-M001P001-000000000000002	123	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 10:32:43.940264	2025-12-30 10:33:11.499601	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
56	1	01	1	2025-12-30 16:40:39.584095	BA98AFA8-8DD0-4A24-A548-4076C954CB8D	DTE-01-M001P001-000000000000029	\N	10.93	0.00	1.42	0.00	0.00	12.35			1	1	2025-12-30 16:40:39.58284	2025-12-30 16:40:39.58284	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
44	1	05	3	2025-12-30 10:59:30.456041	9C714281-1227-4876-8B35-D80A22363A32	DTE-05-M001P001-000000000000003	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 10:59:30.450122	2025-12-30 11:35:29.825208	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
45	1	05	3	2025-12-30 12:10:46.821278	F92BA320-4A73-44C2-A5E9-EAD9D7C9143F	DTE-05-M001P001-000000000000004	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 12:10:46.814544	2025-12-30 12:10:46.814544	dariouz orellana	NRC	2-7	43	dariouzorellanalopez@gmail.com	\N
42	1	03	3	2025-12-30 10:29:04.42103	EE640309-5CBB-4BEE-87C0-CEECAD907141	DTE-03-M001P001-000000000000001	123	1.11	0.00	0.14	0.00	0.00	1.25			0	1	2025-12-30 10:29:04.417949	2025-12-30 12:24:28.283167	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
46	1	01	1	2025-12-30 12:29:10.681777	F5E32122-7925-48D2-971C-F4502E42B8DA	DTE-01-M001P001-000000000000021	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 12:29:10.679961	2025-12-30 12:29:10.679961	PRUEBA	\N	\N	\N	\N	\N
47	1	03	3	2025-12-30 12:31:17.304216	D452B27A-AE58-4B76-8EE8-140921721A9B	DTE-03-M001P001-000000000000003	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 12:31:17.302546	2025-12-30 12:31:17.302546	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
48	1	03	3	2025-12-30 12:52:21.707958	EE81F2EE-4310-406C-8C66-3409D390A142	DTE-03-M001P001-000000000000004	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 12:52:21.706068	2025-12-30 12:52:21.706068	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
49	1	01	1	2025-12-30 12:54:21.393379	08F6B331-95D8-4605-A62F-561E94571BAE	DTE-01-M001P001-000000000000022	\N	10.93	0.00	1.42	0.00	0.00	12.35			1	1	2025-12-30 12:54:21.392231	2025-12-30 12:54:21.392231	DARIOUZ	\N	\N	\N	dariouzorellanalopez@gmail.com	\N
50	1	01	1	2025-12-30 12:57:18.393065	FD87BCCB-3A6D-4559-9BF0-4209D99F3807	DTE-01-M001P001-000000000000023	\N	10.93	0.00	1.42	0.00	0.00	12.35			1	1	2025-12-30 12:57:18.383984	2025-12-30 12:57:18.383984	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
51	1	01	3	2025-12-30 12:57:30.903515	7688E755-7CB2-4B5F-817C-F07A4C29F3A8	DTE-01-M001P001-000000000000024	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 12:57:30.900841	2025-12-30 12:57:30.900841	dariouz orellana	\N	2-7	\N	dariouzorellanalopez@gmail.com	\N
52	1	01	3	2025-12-30 12:58:23.046145	CE575BDC-6639-4F18-B308-A2B2128007BD	DTE-01-M001P001-000000000000025	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 12:58:23.043015	2025-12-30 12:58:23.043015	dariouz orellana	\N	2-7	\N	dariouzorellanalopez@gmail.com	\N
53	1	01	1	2025-12-30 16:35:24.370383	1D388B3D-121C-4F93-B7B0-884233CCEA88	DTE-01-M001P001-000000000000026	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 16:35:24.355426	2025-12-30 16:35:24.355426	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
54	1	01	1	2025-12-30 16:40:06.46927	9629F9A3-B352-4994-837B-D53EF9464810	DTE-01-M001P001-000000000000027	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 16:40:06.465969	2025-12-30 16:40:06.465969	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
57	1	01	1	2025-12-30 16:45:43.46558	0FD80728-23FA-4A73-9149-208E0CD70E2A	DTE-01-M001P001-000000000000030	\N	10.93	0.00	1.42	0.00	0.00	12.35			1	1	2025-12-30 16:45:43.462646	2025-12-30 16:45:43.462646	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
58	1	01	1	2025-12-30 17:03:04.584142	3391FE38-C926-4C93-99DC-86D1B733491E	DTE-01-M001P001-000000000000031	\N	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2025-12-30 17:03:04.574555	2025-12-30 17:03:04.574555	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
62	1	01	3	2026-01-05 21:19:26.3869	8FA6E53E-B561-4FB4-ACB9-6FA5E57C7E0C	DTE-01-M001P001-000000000000002	\N	12.04	0.00	1.56	0.00	0.00	13.60			2	1	2026-01-05 21:19:26.375551	2026-01-05 21:52:06.345785	dariouz orellana	DUI	06195149-2	\N	dariouzorellanalopez@gmail.com	\N
60	1	01	1	2025-12-30 17:06:21.370872	05D53A3B-83C0-4EE8-81E7-C2684AD25B5E	DTE-01-M001P001-000000000000033	\N	1.11	0.00	0.14	0.00	0.00	1.25			18	1	2025-12-30 17:06:21.364584	2025-12-30 17:38:40.965428	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
63	1	01	1	2026-01-05 21:24:06.449173	1EE1F700-C1A4-4C10-99AA-D8B0CAE1387D	DTE-01-M001P001-000000000000001	\N	12.04	0.00	1.56	0.00	0.00	13.60			6	1	2026-01-05 21:24:06.438879	2026-01-05 21:52:08.494192	CONSUMIDOR FINAL	DUI	06195149-2	\N	dariouzorellanalopez@gmail.com	\N
65	1	05	3	2026-01-06 12:55:38.337889	CC790BB4-A970-4CEC-945E-08422BE7957B	DTE-05-M001P001-000000000000001	123	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2026-01-06 12:55:38.329675	2026-01-06 21:44:35.66217	dariouz orellana	NRC	2-7	42	dariouzorellanalopez@gmail.com	\N
61	1	01	1	2025-12-30 17:38:48.246901	B544030C-C2A4-4501-AD7B-3FCBE3F12292	DTE-01-M001P001-000000000000034	123	1.11	0.00	0.14	0.00	0.00	1.25		123	1	1	2025-12-30 17:38:48.239285	2026-01-02 17:04:36.814715	CONSUMIDOR FINAL	\N	\N	\N	\N	1
59	1	01	1	2025-12-30 17:05:20.746227	A14320AF-1782-4663-9B87-5EF78797620C	DTE-01-M001P001-000000000000032	\N	1.11	0.00	0.14	0.00	0.00	1.25			2	1	2025-12-30 17:05:20.736468	2025-12-30 17:38:19.395311	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
64	1	03	3	2026-01-06 10:16:37.529745	4112CA9F-18DA-499A-98B9-78F79BA971F0	DTE-03-M001P001-000000000000001	\N	12.04	0.00	1.56	0.00	0.00	13.60			1	1	2026-01-06 10:16:37.518807	2026-01-06 10:16:37.518807	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
68	4	03	3	2026-01-06 23:33:59.003358	0373228C-8539-4E5E-A125-CA517AFECEEC	DTE-03-M001P001-000000000000004	\N	12.04	0.00	1.56	0.00	0.00	13.60			1	1	2026-01-06 23:33:58.998977	2026-01-06 23:33:58.998977	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
69	1	01	1	2026-01-07 09:16:57.591027	26F90FB9-65F1-40C8-8DBE-9410CA2DA69B	DTE-01-M001P001-000000000000003	123	12.04	0.00	1.56	0.00	0.00	13.60			1	1	2026-01-07 09:16:57.581119	2026-01-07 12:33:53.031207	CONSUMIDOR FINAL222	\N	\N	\N	\N	\N
70	1	01	1	2026-01-07 09:17:12.60518	1157C3B9-31E9-4699-8CF5-EBE678CEB170	DTE-01-M001P001-000000000000004	123	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2026-01-07 09:17:12.598563	2026-01-07 12:33:42.100361	CONSUMIDOR FINAL3333333	\N	\N	\N	\N	\N
71	1	01	3	2026-01-07 09:18:00.668806	3E68F32F-8980-44EF-B473-1250127B94E6	DTE-01-M001P001-000000000000005	123	12.04	0.00	1.56	0.00	0.00	13.60			1	1	2026-01-07 09:18:00.672416	2026-01-07 12:33:35.285542	dariouz orellana	DUI	06195149-2	\N	dariouzorellanalopez@gmail.com	\N
72	4	01	1	2026-01-07 10:08:22.018964	4C2A8780-4C7C-400C-BFD8-519B843E60DA	DTE-01-M001P001-000000000000006	123	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2026-01-07 10:08:22.008919	2026-01-07 12:33:27.940217	CONSUMIDOR FINAL	\N	\N	\N	\N	\N
74	1	03	3	2026-01-07 11:25:46.878543	9F753B13-21CA-4A4F-963D-E9449FE63F5C	DTE-03-M001P001-000000000000005	123	12.04	0.00	1.56	0.00	0.00	13.60			5	1	2026-01-07 11:25:46.863238	2026-01-07 12:31:55.656751	dariouz orellana	NRC	2-7	\N	dariouzorellanalopez@gmail.com	\N
73	1	01	3	2026-01-07 10:34:19.437526	26EE9EE3-1567-4D70-A2D4-7B6416AB7315	DTE-01-M001P001-000000000000007	123	1.11	0.00	0.14	0.00	0.00	1.25			1	1	2026-01-07 10:34:19.435591	2026-01-07 12:33:16.79065	dariouz orellana	DUI	06195149-2	\N	dariouzorellanalopez@gmail.com	\N
\.


--
-- TOC entry 5237 (class 0 OID 16583)
-- Dependencies: 254
-- Data for Name: venta_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venta_detalle (id, venta_id, producto_id, cantidad, precio_unitario, descuento, iva, total_linea, created_at, updated_at, sub_total) FROM stdin;
5	5	1	1.00	1.25	0.00	0.14	1.25	2025-10-27 21:36:46.814524	2025-10-27 21:36:46.814524	1.11
6	6	1	1.00	1.25	0.00	0.14	1.25	2025-11-06 14:58:37.343711	2025-11-06 14:58:37.343711	1.11
7	7	1	1.00	1.25	0.00	0.14	1.25	2025-11-06 15:51:50.190076	2025-11-06 15:51:50.190076	1.11
8	8	1	1.00	1.25	0.00	0.14	1.25	2025-11-10 15:07:31.852628	2025-11-10 15:07:31.852628	1.11
9	9	1	1.00	1.25	0.00	0.14	1.25	2025-11-14 14:25:39.077344	2025-11-14 14:25:39.077344	1.11
10	10	1	1.00	1.25	0.00	0.14	1.25	2025-11-14 14:57:22.815655	2025-11-14 14:57:22.815655	1.11
11	11	1	1.00	1.25	0.00	0.14	1.25	2025-11-14 16:55:09.308098	2025-11-14 16:55:09.308098	1.11
12	11	5	1.00	12.35	0.00	1.42	12.35	2025-11-14 16:55:09.308098	2025-11-14 16:55:09.308098	10.93
13	12	1	1.00	1.25	0.00	0.14	1.25	2025-11-14 16:56:17.915715	2025-11-14 16:56:17.915715	1.11
14	12	5	1.00	12.35	0.00	1.42	12.35	2025-11-14 16:56:17.915715	2025-11-14 16:56:17.915715	10.93
15	13	1	1.00	1.25	0.00	0.14	1.25	2025-11-17 11:57:03.847813	2025-11-17 11:57:03.847813	1.11
16	13	5	1.00	12.35	0.00	1.42	12.35	2025-11-17 11:57:03.847813	2025-11-17 11:57:03.847813	10.93
17	14	1	1.00	1.25	0.00	0.14	1.25	2025-11-17 12:08:28.131909	2025-11-17 12:08:28.131909	1.11
18	15	1	1.00	1.25	0.00	0.14	1.25	2025-11-20 17:45:15.179424	2025-11-20 17:45:15.179424	1.11
19	16	1	1.00	1.25	0.00	0.14	1.25	2025-11-27 20:47:05.796837	2025-11-27 20:47:05.796837	1.11
20	17	5	1.00	12.35	0.00	1.42	12.35	2025-11-27 20:47:27.078866	2025-11-27 20:47:27.078866	10.93
21	18	1	1.00	1.25	0.00	0.14	1.25	2025-11-27 20:47:56.56055	2025-11-27 20:47:56.56055	1.11
22	19	5	1.00	12.35	0.00	1.42	12.35	2025-12-22 09:53:04.544895	2025-12-22 09:53:04.544895	10.93
23	20	1	1.00	1.25	0.00	0.14	1.25	2025-12-26 19:03:53.665108	2025-12-26 19:03:53.665108	1.11
24	21	1	1.00	1.25	0.00	0.14	1.25	2025-12-26 19:04:12.400824	2025-12-26 19:04:12.400824	1.11
25	22	1	1.00	1.25	0.00	0.14	1.25	2025-12-26 19:06:09.11707	2025-12-26 19:06:09.11707	1.11
26	23	5	1.00	12.35	0.00	1.42	12.35	2025-12-27 11:40:13.288802	2025-12-27 11:40:13.288802	10.93
27	24	5	1.00	12.35	0.00	1.42	12.35	2025-12-27 11:42:39.504596	2025-12-27 11:42:39.504596	10.93
28	25	5	1.00	12.35	0.00	1.42	12.35	2025-12-27 12:00:28.984299	2025-12-27 12:00:28.984299	10.93
29	26	5	1.00	12.35	0.00	1.42	12.35	2025-12-27 12:07:12.835119	2025-12-27 12:07:12.835119	10.93
30	27	1	1.00	1.25	0.00	0.14	1.25	2025-12-27 12:28:53.476765	2025-12-27 12:28:53.476765	1.11
31	28	1	1.00	1.25	0.00	0.14	1.25	2025-12-27 12:29:16.048032	2025-12-27 12:29:16.048032	1.11
34	33	1	1.00	1.25	0.00	0.14	1.25	2025-12-27 17:56:17.635352	2025-12-27 17:56:17.635352	1.11
35	34	1	1.00	1.25	0.00	0.14	1.25	2025-12-27 17:59:42.198207	2025-12-27 17:59:42.198207	1.11
36	35	1	1.00	1.25	0.00	0.14	1.25	2025-12-27 18:03:01.686534	2025-12-27 18:03:01.686534	1.11
37	36	1	1.00	1.25	0.00	0.14	1.25	2025-12-29 08:27:45.81919	2025-12-29 08:27:45.81919	1.11
38	37	1	1.00	1.25	0.00	0.14	1.25	2025-12-29 09:36:54.555089	2025-12-29 09:36:54.555089	1.11
39	38	5	1.00	12.35	0.00	1.42	12.35	2025-12-29 09:38:03.727019	2025-12-29 09:38:03.727019	10.93
40	39	1	1.00	1.25	0.00	0.14	1.25	2025-12-29 09:50:47.181437	2025-12-29 09:50:47.181437	1.11
41	40	5	1.00	12.35	0.00	1.42	12.35	2025-12-29 10:51:17.051007	2025-12-29 10:51:17.051007	10.93
42	41	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 10:03:39.386046	2025-12-30 10:03:39.386046	1.11
43	42	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 10:29:04.417949	2025-12-30 10:29:04.417949	1.11
44	43	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 10:32:43.940264	2025-12-30 10:32:43.940264	1.11
45	44	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 10:59:30.450122	2025-12-30 10:59:30.450122	1.11
46	45	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 12:10:46.814544	2025-12-30 12:10:46.814544	1.11
47	46	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 12:29:10.679961	2025-12-30 12:29:10.679961	1.11
48	47	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 12:31:17.302546	2025-12-30 12:31:17.302546	1.11
49	48	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 12:52:21.706068	2025-12-30 12:52:21.706068	1.11
50	49	5	1.00	12.35	0.00	1.42	12.35	2025-12-30 12:54:21.392231	2025-12-30 12:54:21.392231	10.93
51	50	5	1.00	12.35	0.00	1.42	12.35	2025-12-30 12:57:18.383984	2025-12-30 12:57:18.383984	10.93
52	51	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 12:57:30.900841	2025-12-30 12:57:30.900841	1.11
53	52	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 12:58:23.043015	2025-12-30 12:58:23.043015	1.11
54	53	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 16:35:24.355426	2025-12-30 16:35:24.355426	1.11
55	54	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 16:40:06.465969	2025-12-30 16:40:06.465969	1.11
56	55	5	1.00	12.35	0.00	1.42	12.35	2025-12-30 16:40:25.922065	2025-12-30 16:40:25.922065	10.93
57	56	5	1.00	12.35	0.00	1.42	12.35	2025-12-30 16:40:39.58284	2025-12-30 16:40:39.58284	10.93
58	57	5	1.00	12.35	0.00	1.42	12.35	2025-12-30 16:45:43.462646	2025-12-30 16:45:43.462646	10.93
59	58	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 17:03:04.574555	2025-12-30 17:03:04.574555	1.11
60	59	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 17:05:20.736468	2025-12-30 17:05:20.736468	1.11
61	60	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 17:06:21.364584	2025-12-30 17:06:21.364584	1.11
62	61	1	1.00	1.25	0.00	0.14	1.25	2025-12-30 17:38:48.239285	2025-12-30 17:38:48.239285	1.11
63	62	1	1.00	1.25	0.00	0.14	1.25	2026-01-05 21:19:26.375551	2026-01-05 21:19:26.375551	1.11
64	62	5	1.00	12.35	0.00	1.42	12.35	2026-01-05 21:19:26.375551	2026-01-05 21:19:26.375551	10.93
65	63	1	1.00	1.25	0.00	0.14	1.25	2026-01-05 21:24:06.438879	2026-01-05 21:24:06.438879	1.11
66	63	5	1.00	12.35	0.00	1.42	12.35	2026-01-05 21:24:06.438879	2026-01-05 21:24:06.438879	10.93
67	64	1	1.00	1.25	0.00	0.14	1.25	2026-01-06 10:16:37.518807	2026-01-06 10:16:37.518807	1.11
68	64	5	1.00	12.35	0.00	1.42	12.35	2026-01-06 10:16:37.518807	2026-01-06 10:16:37.518807	10.93
69	65	1	1.00	1.25	0.00	0.14	1.25	2026-01-06 12:55:38.329675	2026-01-06 12:55:38.329675	1.11
74	68	1	1.00	1.25	0.00	0.14	1.25	2026-01-06 23:33:58.998977	2026-01-06 23:33:58.998977	1.11
75	68	5	1.00	12.35	0.00	1.42	12.35	2026-01-06 23:33:58.998977	2026-01-06 23:33:58.998977	10.93
76	69	1	1.00	1.25	0.00	0.14	1.25	2026-01-07 09:16:57.581119	2026-01-07 09:16:57.581119	1.11
77	69	5	1.00	12.35	0.00	1.42	12.35	2026-01-07 09:16:57.581119	2026-01-07 09:16:57.581119	10.93
78	70	1	1.00	1.25	0.00	0.14	1.25	2026-01-07 09:17:12.598563	2026-01-07 09:17:12.598563	1.11
79	71	1	1.00	1.25	0.00	0.14	1.25	2026-01-07 09:18:00.672416	2026-01-07 09:18:00.672416	1.11
80	71	5	1.00	12.35	0.00	1.42	12.35	2026-01-07 09:18:00.672416	2026-01-07 09:18:00.672416	10.93
81	72	1	1.00	1.25	0.00	0.14	1.25	2026-01-07 10:08:22.008919	2026-01-07 10:08:22.008919	1.11
82	73	1	1.00	1.25	0.00	0.14	1.25	2026-01-07 10:34:19.435591	2026-01-07 10:34:19.435591	1.11
83	74	5	1.00	12.35	0.00	1.42	12.35	2026-01-07 11:25:46.863238	2026-01-07 11:25:46.863238	10.93
84	74	1	1.00	1.25	0.00	0.14	1.25	2026-01-07 11:25:46.863238	2026-01-07 11:25:46.863238	1.11
\.


--
-- TOC entry 5240 (class 0 OID 16602)
-- Dependencies: 257
-- Data for Name: venta_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venta_pago (id, venta_id, tipo_pago_id, estado, valor, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 221
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_id_seq', 4, true);


--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 223
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_id_seq', 6, true);


--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 227
-- Name: contingencia_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contingencia_detalle_id_seq', 7, true);


--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 228
-- Name: contingencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contingencia_id_seq', 7, true);


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 231
-- Name: empresa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empresa_id_seq', 1, false);


--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 233
-- Name: invalidacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invalidacion_id_seq', 3, true);


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 237
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_id_seq', 5, true);


--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 259
-- Name: respuestas_dte_mh_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.respuestas_dte_mh_id_seq', 82, true);


--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 239
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rol_id_seq', 2, true);


--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 241
-- Name: sucursal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sucursal_id_seq', 4, true);


--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 243
-- Name: tipo_contingencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_contingencia_id_seq', 1, false);


--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 245
-- Name: tipo_contribuyente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_contribuyente_id_seq', 3, true);


--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 248
-- Name: tipo_invalidacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_invalidacion_id_seq', 1, false);


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 250
-- Name: tipo_pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_pago_id_seq', 1, false);


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 252
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 4, true);


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 255
-- Name: venta_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_detalle_id_seq', 84, true);


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 256
-- Name: venta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_id_seq', 74, true);


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 258
-- Name: venta_pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_pago_id_seq', 1, false);


--
-- TOC entry 5244 (class 2613 OID 16880)
-- Name: 16880..17169; Type: BLOB METADATA; Schema: -; Owner: postgres
--

SELECT pg_catalog.lo_create('16880');
SELECT pg_catalog.lo_create('16881');
SELECT pg_catalog.lo_create('16882');
SELECT pg_catalog.lo_create('16883');
SELECT pg_catalog.lo_create('16884');
SELECT pg_catalog.lo_create('16885');
SELECT pg_catalog.lo_create('16886');
SELECT pg_catalog.lo_create('16887');
SELECT pg_catalog.lo_create('16888');
SELECT pg_catalog.lo_create('16889');
SELECT pg_catalog.lo_create('16890');
SELECT pg_catalog.lo_create('16891');
SELECT pg_catalog.lo_create('16892');
SELECT pg_catalog.lo_create('16893');
SELECT pg_catalog.lo_create('16894');
SELECT pg_catalog.lo_create('16895');
SELECT pg_catalog.lo_create('16896');
SELECT pg_catalog.lo_create('16897');
SELECT pg_catalog.lo_create('16898');
SELECT pg_catalog.lo_create('16899');
SELECT pg_catalog.lo_create('16900');
SELECT pg_catalog.lo_create('16901');
SELECT pg_catalog.lo_create('16902');
SELECT pg_catalog.lo_create('16903');
SELECT pg_catalog.lo_create('16904');
SELECT pg_catalog.lo_create('16905');
SELECT pg_catalog.lo_create('16906');
SELECT pg_catalog.lo_create('16907');
SELECT pg_catalog.lo_create('16908');
SELECT pg_catalog.lo_create('16909');
SELECT pg_catalog.lo_create('16910');
SELECT pg_catalog.lo_create('16911');
SELECT pg_catalog.lo_create('16912');
SELECT pg_catalog.lo_create('16913');
SELECT pg_catalog.lo_create('16914');
SELECT pg_catalog.lo_create('16915');
SELECT pg_catalog.lo_create('16916');
SELECT pg_catalog.lo_create('16917');
SELECT pg_catalog.lo_create('16918');
SELECT pg_catalog.lo_create('16919');
SELECT pg_catalog.lo_create('16920');
SELECT pg_catalog.lo_create('16921');
SELECT pg_catalog.lo_create('16922');
SELECT pg_catalog.lo_create('16923');
SELECT pg_catalog.lo_create('16924');
SELECT pg_catalog.lo_create('16925');
SELECT pg_catalog.lo_create('16926');
SELECT pg_catalog.lo_create('16927');
SELECT pg_catalog.lo_create('16928');
SELECT pg_catalog.lo_create('16929');
SELECT pg_catalog.lo_create('16930');
SELECT pg_catalog.lo_create('16931');
SELECT pg_catalog.lo_create('16932');
SELECT pg_catalog.lo_create('16933');
SELECT pg_catalog.lo_create('16934');
SELECT pg_catalog.lo_create('16935');
SELECT pg_catalog.lo_create('16936');
SELECT pg_catalog.lo_create('16937');
SELECT pg_catalog.lo_create('16938');
SELECT pg_catalog.lo_create('16939');
SELECT pg_catalog.lo_create('16940');
SELECT pg_catalog.lo_create('16941');
SELECT pg_catalog.lo_create('16942');
SELECT pg_catalog.lo_create('16943');
SELECT pg_catalog.lo_create('16944');
SELECT pg_catalog.lo_create('16945');
SELECT pg_catalog.lo_create('16946');
SELECT pg_catalog.lo_create('16947');
SELECT pg_catalog.lo_create('16948');
SELECT pg_catalog.lo_create('16949');
SELECT pg_catalog.lo_create('16950');
SELECT pg_catalog.lo_create('16951');
SELECT pg_catalog.lo_create('16952');
SELECT pg_catalog.lo_create('16953');
SELECT pg_catalog.lo_create('16954');
SELECT pg_catalog.lo_create('16955');
SELECT pg_catalog.lo_create('16956');
SELECT pg_catalog.lo_create('16957');
SELECT pg_catalog.lo_create('16958');
SELECT pg_catalog.lo_create('16959');
SELECT pg_catalog.lo_create('16960');
SELECT pg_catalog.lo_create('16961');
SELECT pg_catalog.lo_create('16962');
SELECT pg_catalog.lo_create('16963');
SELECT pg_catalog.lo_create('16964');
SELECT pg_catalog.lo_create('16965');
SELECT pg_catalog.lo_create('16966');
SELECT pg_catalog.lo_create('16967');
SELECT pg_catalog.lo_create('16968');
SELECT pg_catalog.lo_create('16969');
SELECT pg_catalog.lo_create('16970');
SELECT pg_catalog.lo_create('16971');
SELECT pg_catalog.lo_create('16972');
SELECT pg_catalog.lo_create('16973');
SELECT pg_catalog.lo_create('16974');
SELECT pg_catalog.lo_create('16975');
SELECT pg_catalog.lo_create('16976');
SELECT pg_catalog.lo_create('16977');
SELECT pg_catalog.lo_create('16978');
SELECT pg_catalog.lo_create('16979');
SELECT pg_catalog.lo_create('16980');
SELECT pg_catalog.lo_create('16981');
SELECT pg_catalog.lo_create('16982');
SELECT pg_catalog.lo_create('16983');
SELECT pg_catalog.lo_create('16984');
SELECT pg_catalog.lo_create('16985');
SELECT pg_catalog.lo_create('16986');
SELECT pg_catalog.lo_create('16987');
SELECT pg_catalog.lo_create('16988');
SELECT pg_catalog.lo_create('16989');
SELECT pg_catalog.lo_create('16990');
SELECT pg_catalog.lo_create('16991');
SELECT pg_catalog.lo_create('16992');
SELECT pg_catalog.lo_create('16993');
SELECT pg_catalog.lo_create('16994');
SELECT pg_catalog.lo_create('16995');
SELECT pg_catalog.lo_create('16996');
SELECT pg_catalog.lo_create('16997');
SELECT pg_catalog.lo_create('16998');
SELECT pg_catalog.lo_create('16999');
SELECT pg_catalog.lo_create('17000');
SELECT pg_catalog.lo_create('17001');
SELECT pg_catalog.lo_create('17002');
SELECT pg_catalog.lo_create('17003');
SELECT pg_catalog.lo_create('17004');
SELECT pg_catalog.lo_create('17005');
SELECT pg_catalog.lo_create('17006');
SELECT pg_catalog.lo_create('17007');
SELECT pg_catalog.lo_create('17008');
SELECT pg_catalog.lo_create('17009');
SELECT pg_catalog.lo_create('17010');
SELECT pg_catalog.lo_create('17011');
SELECT pg_catalog.lo_create('17012');
SELECT pg_catalog.lo_create('17013');
SELECT pg_catalog.lo_create('17014');
SELECT pg_catalog.lo_create('17015');
SELECT pg_catalog.lo_create('17016');
SELECT pg_catalog.lo_create('17017');
SELECT pg_catalog.lo_create('17019');
SELECT pg_catalog.lo_create('17020');
SELECT pg_catalog.lo_create('17021');
SELECT pg_catalog.lo_create('17022');
SELECT pg_catalog.lo_create('17023');
SELECT pg_catalog.lo_create('17024');
SELECT pg_catalog.lo_create('17025');
SELECT pg_catalog.lo_create('17026');
SELECT pg_catalog.lo_create('17027');
SELECT pg_catalog.lo_create('17028');
SELECT pg_catalog.lo_create('17029');
SELECT pg_catalog.lo_create('17030');
SELECT pg_catalog.lo_create('17031');
SELECT pg_catalog.lo_create('17032');
SELECT pg_catalog.lo_create('17033');
SELECT pg_catalog.lo_create('17075');
SELECT pg_catalog.lo_create('17076');
SELECT pg_catalog.lo_create('17077');
SELECT pg_catalog.lo_create('17078');
SELECT pg_catalog.lo_create('17079');
SELECT pg_catalog.lo_create('17080');
SELECT pg_catalog.lo_create('17081');
SELECT pg_catalog.lo_create('17082');
SELECT pg_catalog.lo_create('17083');
SELECT pg_catalog.lo_create('17084');
SELECT pg_catalog.lo_create('17085');
SELECT pg_catalog.lo_create('17086');
SELECT pg_catalog.lo_create('17087');
SELECT pg_catalog.lo_create('17088');
SELECT pg_catalog.lo_create('17089');
SELECT pg_catalog.lo_create('17090');
SELECT pg_catalog.lo_create('17091');
SELECT pg_catalog.lo_create('17092');
SELECT pg_catalog.lo_create('17093');
SELECT pg_catalog.lo_create('17094');
SELECT pg_catalog.lo_create('17095');
SELECT pg_catalog.lo_create('17096');
SELECT pg_catalog.lo_create('17097');
SELECT pg_catalog.lo_create('17098');
SELECT pg_catalog.lo_create('17099');
SELECT pg_catalog.lo_create('17100');
SELECT pg_catalog.lo_create('17101');
SELECT pg_catalog.lo_create('17102');
SELECT pg_catalog.lo_create('17103');
SELECT pg_catalog.lo_create('17104');
SELECT pg_catalog.lo_create('17105');
SELECT pg_catalog.lo_create('17106');
SELECT pg_catalog.lo_create('17107');
SELECT pg_catalog.lo_create('17108');
SELECT pg_catalog.lo_create('17109');
SELECT pg_catalog.lo_create('17110');
SELECT pg_catalog.lo_create('17111');
SELECT pg_catalog.lo_create('17112');
SELECT pg_catalog.lo_create('17113');
SELECT pg_catalog.lo_create('17115');
SELECT pg_catalog.lo_create('17116');
SELECT pg_catalog.lo_create('17117');
SELECT pg_catalog.lo_create('17118');
SELECT pg_catalog.lo_create('17119');
SELECT pg_catalog.lo_create('17120');
SELECT pg_catalog.lo_create('17122');
SELECT pg_catalog.lo_create('17123');
SELECT pg_catalog.lo_create('17124');
SELECT pg_catalog.lo_create('17125');
SELECT pg_catalog.lo_create('17126');
SELECT pg_catalog.lo_create('17127');
SELECT pg_catalog.lo_create('17128');
SELECT pg_catalog.lo_create('17129');
SELECT pg_catalog.lo_create('17130');
SELECT pg_catalog.lo_create('17131');
SELECT pg_catalog.lo_create('17132');
SELECT pg_catalog.lo_create('17133');
SELECT pg_catalog.lo_create('17134');
SELECT pg_catalog.lo_create('17135');
SELECT pg_catalog.lo_create('17136');
SELECT pg_catalog.lo_create('17137');
SELECT pg_catalog.lo_create('17138');
SELECT pg_catalog.lo_create('17139');
SELECT pg_catalog.lo_create('17140');
SELECT pg_catalog.lo_create('17141');
SELECT pg_catalog.lo_create('17142');
SELECT pg_catalog.lo_create('17143');
SELECT pg_catalog.lo_create('17144');
SELECT pg_catalog.lo_create('17145');
SELECT pg_catalog.lo_create('17146');
SELECT pg_catalog.lo_create('17147');
SELECT pg_catalog.lo_create('17148');
SELECT pg_catalog.lo_create('17149');
SELECT pg_catalog.lo_create('17150');
SELECT pg_catalog.lo_create('17151');
SELECT pg_catalog.lo_create('17152');
SELECT pg_catalog.lo_create('17153');
SELECT pg_catalog.lo_create('17154');
SELECT pg_catalog.lo_create('17155');
SELECT pg_catalog.lo_create('17156');
SELECT pg_catalog.lo_create('17157');
SELECT pg_catalog.lo_create('17158');
SELECT pg_catalog.lo_create('17159');
SELECT pg_catalog.lo_create('17160');
SELECT pg_catalog.lo_create('17161');
SELECT pg_catalog.lo_create('17162');
SELECT pg_catalog.lo_create('17163');
SELECT pg_catalog.lo_create('17164');
SELECT pg_catalog.lo_create('17165');
SELECT pg_catalog.lo_create('17166');
SELECT pg_catalog.lo_create('17167');
SELECT pg_catalog.lo_create('17168');
SELECT pg_catalog.lo_create('17169');

ALTER LARGE OBJECT 16880 OWNER TO postgres;
ALTER LARGE OBJECT 16881 OWNER TO postgres;
ALTER LARGE OBJECT 16882 OWNER TO postgres;
ALTER LARGE OBJECT 16883 OWNER TO postgres;
ALTER LARGE OBJECT 16884 OWNER TO postgres;
ALTER LARGE OBJECT 16885 OWNER TO postgres;
ALTER LARGE OBJECT 16886 OWNER TO postgres;
ALTER LARGE OBJECT 16887 OWNER TO postgres;
ALTER LARGE OBJECT 16888 OWNER TO postgres;
ALTER LARGE OBJECT 16889 OWNER TO postgres;
ALTER LARGE OBJECT 16890 OWNER TO postgres;
ALTER LARGE OBJECT 16891 OWNER TO postgres;
ALTER LARGE OBJECT 16892 OWNER TO postgres;
ALTER LARGE OBJECT 16893 OWNER TO postgres;
ALTER LARGE OBJECT 16894 OWNER TO postgres;
ALTER LARGE OBJECT 16895 OWNER TO postgres;
ALTER LARGE OBJECT 16896 OWNER TO postgres;
ALTER LARGE OBJECT 16897 OWNER TO postgres;
ALTER LARGE OBJECT 16898 OWNER TO postgres;
ALTER LARGE OBJECT 16899 OWNER TO postgres;
ALTER LARGE OBJECT 16900 OWNER TO postgres;
ALTER LARGE OBJECT 16901 OWNER TO postgres;
ALTER LARGE OBJECT 16902 OWNER TO postgres;
ALTER LARGE OBJECT 16903 OWNER TO postgres;
ALTER LARGE OBJECT 16904 OWNER TO postgres;
ALTER LARGE OBJECT 16905 OWNER TO postgres;
ALTER LARGE OBJECT 16906 OWNER TO postgres;
ALTER LARGE OBJECT 16907 OWNER TO postgres;
ALTER LARGE OBJECT 16908 OWNER TO postgres;
ALTER LARGE OBJECT 16909 OWNER TO postgres;
ALTER LARGE OBJECT 16910 OWNER TO postgres;
ALTER LARGE OBJECT 16911 OWNER TO postgres;
ALTER LARGE OBJECT 16912 OWNER TO postgres;
ALTER LARGE OBJECT 16913 OWNER TO postgres;
ALTER LARGE OBJECT 16914 OWNER TO postgres;
ALTER LARGE OBJECT 16915 OWNER TO postgres;
ALTER LARGE OBJECT 16916 OWNER TO postgres;
ALTER LARGE OBJECT 16917 OWNER TO postgres;
ALTER LARGE OBJECT 16918 OWNER TO postgres;
ALTER LARGE OBJECT 16919 OWNER TO postgres;
ALTER LARGE OBJECT 16920 OWNER TO postgres;
ALTER LARGE OBJECT 16921 OWNER TO postgres;
ALTER LARGE OBJECT 16922 OWNER TO postgres;
ALTER LARGE OBJECT 16923 OWNER TO postgres;
ALTER LARGE OBJECT 16924 OWNER TO postgres;
ALTER LARGE OBJECT 16925 OWNER TO postgres;
ALTER LARGE OBJECT 16926 OWNER TO postgres;
ALTER LARGE OBJECT 16927 OWNER TO postgres;
ALTER LARGE OBJECT 16928 OWNER TO postgres;
ALTER LARGE OBJECT 16929 OWNER TO postgres;
ALTER LARGE OBJECT 16930 OWNER TO postgres;
ALTER LARGE OBJECT 16931 OWNER TO postgres;
ALTER LARGE OBJECT 16932 OWNER TO postgres;
ALTER LARGE OBJECT 16933 OWNER TO postgres;
ALTER LARGE OBJECT 16934 OWNER TO postgres;
ALTER LARGE OBJECT 16935 OWNER TO postgres;
ALTER LARGE OBJECT 16936 OWNER TO postgres;
ALTER LARGE OBJECT 16937 OWNER TO postgres;
ALTER LARGE OBJECT 16938 OWNER TO postgres;
ALTER LARGE OBJECT 16939 OWNER TO postgres;
ALTER LARGE OBJECT 16940 OWNER TO postgres;
ALTER LARGE OBJECT 16941 OWNER TO postgres;
ALTER LARGE OBJECT 16942 OWNER TO postgres;
ALTER LARGE OBJECT 16943 OWNER TO postgres;
ALTER LARGE OBJECT 16944 OWNER TO postgres;
ALTER LARGE OBJECT 16945 OWNER TO postgres;
ALTER LARGE OBJECT 16946 OWNER TO postgres;
ALTER LARGE OBJECT 16947 OWNER TO postgres;
ALTER LARGE OBJECT 16948 OWNER TO postgres;
ALTER LARGE OBJECT 16949 OWNER TO postgres;
ALTER LARGE OBJECT 16950 OWNER TO postgres;
ALTER LARGE OBJECT 16951 OWNER TO postgres;
ALTER LARGE OBJECT 16952 OWNER TO postgres;
ALTER LARGE OBJECT 16953 OWNER TO postgres;
ALTER LARGE OBJECT 16954 OWNER TO postgres;
ALTER LARGE OBJECT 16955 OWNER TO postgres;
ALTER LARGE OBJECT 16956 OWNER TO postgres;
ALTER LARGE OBJECT 16957 OWNER TO postgres;
ALTER LARGE OBJECT 16958 OWNER TO postgres;
ALTER LARGE OBJECT 16959 OWNER TO postgres;
ALTER LARGE OBJECT 16960 OWNER TO postgres;
ALTER LARGE OBJECT 16961 OWNER TO postgres;
ALTER LARGE OBJECT 16962 OWNER TO postgres;
ALTER LARGE OBJECT 16963 OWNER TO postgres;
ALTER LARGE OBJECT 16964 OWNER TO postgres;
ALTER LARGE OBJECT 16965 OWNER TO postgres;
ALTER LARGE OBJECT 16966 OWNER TO postgres;
ALTER LARGE OBJECT 16967 OWNER TO postgres;
ALTER LARGE OBJECT 16968 OWNER TO postgres;
ALTER LARGE OBJECT 16969 OWNER TO postgres;
ALTER LARGE OBJECT 16970 OWNER TO postgres;
ALTER LARGE OBJECT 16971 OWNER TO postgres;
ALTER LARGE OBJECT 16972 OWNER TO postgres;
ALTER LARGE OBJECT 16973 OWNER TO postgres;
ALTER LARGE OBJECT 16974 OWNER TO postgres;
ALTER LARGE OBJECT 16975 OWNER TO postgres;
ALTER LARGE OBJECT 16976 OWNER TO postgres;
ALTER LARGE OBJECT 16977 OWNER TO postgres;
ALTER LARGE OBJECT 16978 OWNER TO postgres;
ALTER LARGE OBJECT 16979 OWNER TO postgres;
ALTER LARGE OBJECT 16980 OWNER TO postgres;
ALTER LARGE OBJECT 16981 OWNER TO postgres;
ALTER LARGE OBJECT 16982 OWNER TO postgres;
ALTER LARGE OBJECT 16983 OWNER TO postgres;
ALTER LARGE OBJECT 16984 OWNER TO postgres;
ALTER LARGE OBJECT 16985 OWNER TO postgres;
ALTER LARGE OBJECT 16986 OWNER TO postgres;
ALTER LARGE OBJECT 16987 OWNER TO postgres;
ALTER LARGE OBJECT 16988 OWNER TO postgres;
ALTER LARGE OBJECT 16989 OWNER TO postgres;
ALTER LARGE OBJECT 16990 OWNER TO postgres;
ALTER LARGE OBJECT 16991 OWNER TO postgres;
ALTER LARGE OBJECT 16992 OWNER TO postgres;
ALTER LARGE OBJECT 16993 OWNER TO postgres;
ALTER LARGE OBJECT 16994 OWNER TO postgres;
ALTER LARGE OBJECT 16995 OWNER TO postgres;
ALTER LARGE OBJECT 16996 OWNER TO postgres;
ALTER LARGE OBJECT 16997 OWNER TO postgres;
ALTER LARGE OBJECT 16998 OWNER TO postgres;
ALTER LARGE OBJECT 16999 OWNER TO postgres;
ALTER LARGE OBJECT 17000 OWNER TO postgres;
ALTER LARGE OBJECT 17001 OWNER TO postgres;
ALTER LARGE OBJECT 17002 OWNER TO postgres;
ALTER LARGE OBJECT 17003 OWNER TO postgres;
ALTER LARGE OBJECT 17004 OWNER TO postgres;
ALTER LARGE OBJECT 17005 OWNER TO postgres;
ALTER LARGE OBJECT 17006 OWNER TO postgres;
ALTER LARGE OBJECT 17007 OWNER TO postgres;
ALTER LARGE OBJECT 17008 OWNER TO postgres;
ALTER LARGE OBJECT 17009 OWNER TO postgres;
ALTER LARGE OBJECT 17010 OWNER TO postgres;
ALTER LARGE OBJECT 17011 OWNER TO postgres;
ALTER LARGE OBJECT 17012 OWNER TO postgres;
ALTER LARGE OBJECT 17013 OWNER TO postgres;
ALTER LARGE OBJECT 17014 OWNER TO postgres;
ALTER LARGE OBJECT 17015 OWNER TO postgres;
ALTER LARGE OBJECT 17016 OWNER TO postgres;
ALTER LARGE OBJECT 17017 OWNER TO postgres;
ALTER LARGE OBJECT 17019 OWNER TO postgres;
ALTER LARGE OBJECT 17020 OWNER TO postgres;
ALTER LARGE OBJECT 17021 OWNER TO postgres;
ALTER LARGE OBJECT 17022 OWNER TO postgres;
ALTER LARGE OBJECT 17023 OWNER TO postgres;
ALTER LARGE OBJECT 17024 OWNER TO postgres;
ALTER LARGE OBJECT 17025 OWNER TO postgres;
ALTER LARGE OBJECT 17026 OWNER TO postgres;
ALTER LARGE OBJECT 17027 OWNER TO postgres;
ALTER LARGE OBJECT 17028 OWNER TO postgres;
ALTER LARGE OBJECT 17029 OWNER TO postgres;
ALTER LARGE OBJECT 17030 OWNER TO postgres;
ALTER LARGE OBJECT 17031 OWNER TO postgres;
ALTER LARGE OBJECT 17032 OWNER TO postgres;
ALTER LARGE OBJECT 17033 OWNER TO postgres;
ALTER LARGE OBJECT 17075 OWNER TO postgres;
ALTER LARGE OBJECT 17076 OWNER TO postgres;
ALTER LARGE OBJECT 17077 OWNER TO postgres;
ALTER LARGE OBJECT 17078 OWNER TO postgres;
ALTER LARGE OBJECT 17079 OWNER TO postgres;
ALTER LARGE OBJECT 17080 OWNER TO postgres;
ALTER LARGE OBJECT 17081 OWNER TO postgres;
ALTER LARGE OBJECT 17082 OWNER TO postgres;
ALTER LARGE OBJECT 17083 OWNER TO postgres;
ALTER LARGE OBJECT 17084 OWNER TO postgres;
ALTER LARGE OBJECT 17085 OWNER TO postgres;
ALTER LARGE OBJECT 17086 OWNER TO postgres;
ALTER LARGE OBJECT 17087 OWNER TO postgres;
ALTER LARGE OBJECT 17088 OWNER TO postgres;
ALTER LARGE OBJECT 17089 OWNER TO postgres;
ALTER LARGE OBJECT 17090 OWNER TO postgres;
ALTER LARGE OBJECT 17091 OWNER TO postgres;
ALTER LARGE OBJECT 17092 OWNER TO postgres;
ALTER LARGE OBJECT 17093 OWNER TO postgres;
ALTER LARGE OBJECT 17094 OWNER TO postgres;
ALTER LARGE OBJECT 17095 OWNER TO postgres;
ALTER LARGE OBJECT 17096 OWNER TO postgres;
ALTER LARGE OBJECT 17097 OWNER TO postgres;
ALTER LARGE OBJECT 17098 OWNER TO postgres;
ALTER LARGE OBJECT 17099 OWNER TO postgres;
ALTER LARGE OBJECT 17100 OWNER TO postgres;
ALTER LARGE OBJECT 17101 OWNER TO postgres;
ALTER LARGE OBJECT 17102 OWNER TO postgres;
ALTER LARGE OBJECT 17103 OWNER TO postgres;
ALTER LARGE OBJECT 17104 OWNER TO postgres;
ALTER LARGE OBJECT 17105 OWNER TO postgres;
ALTER LARGE OBJECT 17106 OWNER TO postgres;
ALTER LARGE OBJECT 17107 OWNER TO postgres;
ALTER LARGE OBJECT 17108 OWNER TO postgres;
ALTER LARGE OBJECT 17109 OWNER TO postgres;
ALTER LARGE OBJECT 17110 OWNER TO postgres;
ALTER LARGE OBJECT 17111 OWNER TO postgres;
ALTER LARGE OBJECT 17112 OWNER TO postgres;
ALTER LARGE OBJECT 17113 OWNER TO postgres;
ALTER LARGE OBJECT 17115 OWNER TO postgres;
ALTER LARGE OBJECT 17116 OWNER TO postgres;
ALTER LARGE OBJECT 17117 OWNER TO postgres;
ALTER LARGE OBJECT 17118 OWNER TO postgres;
ALTER LARGE OBJECT 17119 OWNER TO postgres;
ALTER LARGE OBJECT 17120 OWNER TO postgres;
ALTER LARGE OBJECT 17122 OWNER TO postgres;
ALTER LARGE OBJECT 17123 OWNER TO postgres;
ALTER LARGE OBJECT 17124 OWNER TO postgres;
ALTER LARGE OBJECT 17125 OWNER TO postgres;
ALTER LARGE OBJECT 17126 OWNER TO postgres;
ALTER LARGE OBJECT 17127 OWNER TO postgres;
ALTER LARGE OBJECT 17128 OWNER TO postgres;
ALTER LARGE OBJECT 17129 OWNER TO postgres;
ALTER LARGE OBJECT 17130 OWNER TO postgres;
ALTER LARGE OBJECT 17131 OWNER TO postgres;
ALTER LARGE OBJECT 17132 OWNER TO postgres;
ALTER LARGE OBJECT 17133 OWNER TO postgres;
ALTER LARGE OBJECT 17134 OWNER TO postgres;
ALTER LARGE OBJECT 17135 OWNER TO postgres;
ALTER LARGE OBJECT 17136 OWNER TO postgres;
ALTER LARGE OBJECT 17137 OWNER TO postgres;
ALTER LARGE OBJECT 17138 OWNER TO postgres;
ALTER LARGE OBJECT 17139 OWNER TO postgres;
ALTER LARGE OBJECT 17140 OWNER TO postgres;
ALTER LARGE OBJECT 17141 OWNER TO postgres;
ALTER LARGE OBJECT 17142 OWNER TO postgres;
ALTER LARGE OBJECT 17143 OWNER TO postgres;
ALTER LARGE OBJECT 17144 OWNER TO postgres;
ALTER LARGE OBJECT 17145 OWNER TO postgres;
ALTER LARGE OBJECT 17146 OWNER TO postgres;
ALTER LARGE OBJECT 17147 OWNER TO postgres;
ALTER LARGE OBJECT 17148 OWNER TO postgres;
ALTER LARGE OBJECT 17149 OWNER TO postgres;
ALTER LARGE OBJECT 17150 OWNER TO postgres;
ALTER LARGE OBJECT 17151 OWNER TO postgres;
ALTER LARGE OBJECT 17152 OWNER TO postgres;
ALTER LARGE OBJECT 17153 OWNER TO postgres;
ALTER LARGE OBJECT 17154 OWNER TO postgres;
ALTER LARGE OBJECT 17155 OWNER TO postgres;
ALTER LARGE OBJECT 17156 OWNER TO postgres;
ALTER LARGE OBJECT 17157 OWNER TO postgres;
ALTER LARGE OBJECT 17158 OWNER TO postgres;
ALTER LARGE OBJECT 17159 OWNER TO postgres;
ALTER LARGE OBJECT 17160 OWNER TO postgres;
ALTER LARGE OBJECT 17161 OWNER TO postgres;
ALTER LARGE OBJECT 17162 OWNER TO postgres;
ALTER LARGE OBJECT 17163 OWNER TO postgres;
ALTER LARGE OBJECT 17164 OWNER TO postgres;
ALTER LARGE OBJECT 17165 OWNER TO postgres;
ALTER LARGE OBJECT 17166 OWNER TO postgres;
ALTER LARGE OBJECT 17167 OWNER TO postgres;
ALTER LARGE OBJECT 17168 OWNER TO postgres;
ALTER LARGE OBJECT 17169 OWNER TO postgres;

--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 5244 5246
-- Data for Name: 16880..17169; Type: BLOBS; Schema: -; Owner: postgres
--

BEGIN;

SELECT pg_catalog.lo_open('16880', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16881', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303132222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230423632394643392d443533322d343245412d394434342d444237393134333432394633222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3237222c0d0a2020202022686f72456d6922203a202231373a35363a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022717765717765222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223333220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16882', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233333204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16883', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16884', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303133222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202241423742334339442d313838352d343742452d393733392d433339393433304644334344222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3237222c0d0a2020202022686f72456d6922203a202231373a35393a3432222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022717765717765222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223334220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16885', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233334204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16886', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16887', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303134222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202238463134313144432d373043442d343734362d383235432d333633454644343132324630222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3237222c0d0a2020202022686f72456d6922203a202231383a30333a3031222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022717765717765222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223335220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16888', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233335204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16889', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16890', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303135222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202234324244454446322d453444442d343939372d393844442d364130323834323443423832222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202230383a32373a3435222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a20227177657771222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223336220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16891', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233336204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16892', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16893', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303136222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230344145423946392d383941362d343343412d393037342d453032413037393035433644222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202230393a33363a3534222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022717765717765222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223337220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16894', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233337204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16895', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16896', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303137222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202241353434384536432d324342322d344632452d424637362d363937324132414536363638222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202230393a33383a3033222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022717765717765222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223338220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16897', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233338204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16898', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16899', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303138222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233384131433936302d433544392d343633362d424234352d453746353639363832453635222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202230393a35303a3437222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a202271717171222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223339220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16900', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233339204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16901', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16902', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16903', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233430204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16904', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16905', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303230222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202245383742313643302d413042382d343937332d394534352d413233383745433041433944222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231303a30333a3339222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223336222c0d0a20202020226e756d446f63756d656e746f22203a20223030303030303030303030303030222c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a2022617364617364736164407177652e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223431220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16906', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233431204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16907', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16908', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303032222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202235374232443044322d433933362d343439352d413544432d333543343642383136423730222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231303a33323a3433222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20302e31340d0a202020207d205d2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223433220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16909', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233433204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16910', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16911', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223035222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30352d4d303031503030312d303030303030303030303030303033222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202239433731343238312d313232372d343837362d384233352d443830413232333633413332222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231303a35393a3330222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a205b207b0d0a20202020227469706f446f63756d656e746f22203a20223033222c0d0a20202020227469706f47656e65726163696f6e22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a202235374232443044322d433933362d343439352d413544432d333543343642383136423730222c0d0a20202020226665636861456d6973696f6e22203a2022323032352d31322d3330220d0a20207d205d2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a202235374232443044322d433933362d343439352d413544432d333543343642383136423730222c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d0d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20302e31340d0a202020207d205d2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20310d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223434220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16912', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233434204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16913', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16914', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223035222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30352d4d303031503030312d303030303030303030303030303034222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202246393242413332302d344137332d343443322d413545392d454144394437433931343346222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231323a31303a3436222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a205b207b0d0a20202020227469706f446f63756d656e746f22203a20223033222c0d0a20202020227469706f47656e65726163696f6e22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a202235374232443044322d433933362d343439352d413544432d333543343642383136423730222c0d0a20202020226665636861456d6973696f6e22203a2022323032352d31322d3330220d0a20207d205d2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a202235374232443044322d433933362d343439352d413544432d333543343642383136423730222c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d0d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20302e31340d0a202020207d205d2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20310d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223435220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16915', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233435204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16916', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16917', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303231222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202246354533323132322d373932352d343844322d393731432d463435303245343242384441222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231323a32393a3130222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022505255454241222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223436220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16918', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233436204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16919', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16920', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303033222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202244343532423237412d414535382d344237362d384545382d313430393231373231413942222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231323a33313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20302e31340d0a202020207d205d2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223437220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16921', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233437204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16922', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16923', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303034222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202245453831463245452d343331302d343036432d384336362d333430394433393041313432222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231323a35323a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20302e31340d0a202020207d205d2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223438220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16924', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233438204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16925', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16926', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303232222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230384636423333312d393544382d343630352d413632462d353631453934353731424145222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231323a35343a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022444152494f555a222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223439220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16927', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233439204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16928', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16929', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303233222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202246443837424343422d334136442d343535392d394246302d343230394439394633383037222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231323a35373a3138222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223530220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16930', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233530204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16931', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16932', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303234222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202237363838453735352d374342322d344235462d383137432d463037413443323946334138222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231323a35373a3330222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223531220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16933', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233531204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16934', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16935', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303235222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202243453537354244432d363633392d344631382d423330382d413242323132383030374244222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231323a35383a3233222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223532220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16936', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233532204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16937', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16938', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303236222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202231443338384233442d313231432d344639332d423742302d383834323333434345413838222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231363a33353a3234222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223533220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16939', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233533204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16940', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16941', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303237222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202239363239463941332d423335322d343939342d383337422d443533454639343634383130222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231363a34303a3036222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223534220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16942', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233534204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16943', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16944', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303238222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202236383332424630332d333943332d343337392d424546392d383442383833324535313544222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231363a34303a3235222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223535220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16945', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233535204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16946', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16947', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303239222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202242413938414641382d384444302d344132342d413534382d343037364339353443423844222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231363a34303a3339222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223536220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16948', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233536204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16949', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16950', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303330222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230464438303732382d323346412d344137332d393134392d323038453043443730453241222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231363a34353a3433222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223537220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16951', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233537204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16952', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16953', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303331222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233333931464533382d433932362d344339332d393944432d383644314237333334393145222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30333a3034222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223538220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16954', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233538204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16955', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16956', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303332222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202241313433323041462d313738322d343636332d394238372d354546373837393736323043222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30353a3230222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223539220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16957', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233539204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16958', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16959', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16960', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233630204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16961', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16962', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16963', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233630204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16964', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16965', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16966', 131072);
SELECT pg_catalog.lowrite(0, '\x7b2265737461646f223a2252454348415a41444f222c226465736372697063696f6e4d7367223a224c412056454e544120233630204e4f20524543494249c393205245535055455354412044452048414349454e44412e222c226f62736572766163696f6e6573223a224c412056454e5441204e4f20524543494249c393205245535055455354412044452048414349454e44412e227d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16967', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16968', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16969', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226d656e73616a6522203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16970', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16971', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16972', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226d656e73616a6522203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16973', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16974', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16975', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16976', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16977', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16978', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16979', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16980', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16981', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16982', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16983', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16984', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16985', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16986', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16987', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16988', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16989', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16990', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16991', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16992', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16993', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16994', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16995', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16996', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16997', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16998', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303332222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202241313433323041462d313738322d343636332d394238372d354546373837393736323043222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30353a3230222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223539220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('16999', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2035390d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17000', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17001', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17002', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17003', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17004', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17005', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17006', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17007', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17008', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17009', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17010', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17011', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17012', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17013', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303333222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230354435334133422d383343302d344545382d383145372d433236383441443235423545222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a30363a3231222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223630220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17014', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17015', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17016', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303334222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202242353434303330432d433241342d343530312d414437422d334643424533463132323932222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032352d31322d3330222c0d0a2020202022686f72456d6922203a202231373a33383a3438222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223631220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17017', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036310d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17019', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17020', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17021', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17022', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17023', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17024', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17025', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17026', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17027', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17028', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17029', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17030', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17031', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17032', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17033', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17075', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17076', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303031222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202231454531463730302d433141342d344331302d393941412d443842304341453133383744222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3035222c0d0a2020202022686f72456d6922203a202232313a32343a3036222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e362c0d0a2020202022746f74616c506167617222203a2031332e362c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e362c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223633220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17077', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036330d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17078', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17079', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303031222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202231454531463730302d433141342d344331302d393941412d443842304341453133383744222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3035222c0d0a2020202022686f72456d6922203a202232313a32343a3036222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223633220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17080', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036330d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17081', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17082', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303031222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202231454531463730302d433141342d344331302d393941412d443842304341453133383744222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3035222c0d0a2020202022686f72456d6922203a202232313a32343a3036222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223633220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17083', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036330d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17084', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17085', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303032222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202238464136453533452d423536312d344642342d414342392d364641354535374337453043222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3035222c0d0a2020202022686f72456d6922203a202232313a31393a3236222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223632220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17086', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036320d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17087', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17088', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303031222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202231454531463730302d433141342d344331302d393941412d443842304341453133383744222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3035222c0d0a2020202022686f72456d6922203a202232313a32343a3036222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223633220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17089', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036330d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17090', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17091', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303031222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202231454531463730302d433141342d344331302d393941412d443842304341453133383744222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3035222c0d0a2020202022686f72456d6922203a202232313a32343a3036222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223633220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17092', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036330d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17093', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17094', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303032222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202238464136453533452d423536312d344642342d414342392d364641354535374337453043222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3035222c0d0a2020202022686f72456d6922203a202232313a31393a3236222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223632220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17095', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036320d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17096', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17097', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303031222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202231454531463730302d433141342d344331302d393941412d443842304341453133383744222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3035222c0d0a2020202022686f72456d6922203a202232313a32343a3036222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e31342c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223633220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17098', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036330d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17099', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17100', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17101', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17102', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17103', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17104', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17105', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17106', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17107', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17108', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17109', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303031222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202234313132434139462d313844412d343939412d393842392d373846373942413937314630222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3036222c0d0a2020202022686f72456d6922203a202231303a31363a3337222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20312e35360d0a202020207d205d2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e362c0d0a2020202022746f74616c506167617222203a2031332e362c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e362c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223634220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17110', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036340d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17111', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17112', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223035222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30352d4d303031503030312d303030303030303030303030303031222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202243433739304242342d413937302d344345432d393435452d303834323242453739353742222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3036222c0d0a2020202022686f72456d6922203a202231323a35353a3338222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a205b207b0d0a20202020227469706f446f63756d656e746f22203a20223033222c0d0a20202020227469706f47656e65726163696f6e22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a202245453634303330392d354342422d344245452d383743302d434545434144393037313431222c0d0a20202020226665636861456d6973696f6e22203a2022323032352d31322d3330220d0a20207d205d2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a202245453634303330392d354342422d344245452d383743302d434545434144393037313431222c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d0d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20302e31340d0a202020207d205d2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20310d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223635220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17113', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036350d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17115', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17116', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303033222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202246333037343832422d453230462d344641442d383034312d353237413839423036384233222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3036222c0d0a2020202022686f72456d6922203a202232333a33313a3536222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20312e35360d0a202020207d205d2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e362c0d0a2020202022746f74616c506167617222203a2031332e362c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e362c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223637220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17117', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036370d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17118', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17119', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303034222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202230333733323238432d383533392d344535452d413132352d434135313741464543454543222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3036222c0d0a2020202022686f72456d6922203a202232333a33333a3539222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20312e35360d0a202020207d205d2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e362c0d0a2020202022746f74616c506167617222203a2031332e362c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e362c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223638220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17120', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036380d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17122', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17123', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303033222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202232364639304642392d363546312d343043382d384442452d393431304341324441363942222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202230393a31363a3537222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c323232222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e362c0d0a2020202022746f74616c506167617222203a2031332e362c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e362c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223639220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17124', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2036390d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17125', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17126', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303034222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202231313537433342392d333145392d343639392d384346352d454245363738434542313730222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202230393a31373a3132222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c33333333333333222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223730220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17127', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2037300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17128', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17129', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303035222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233453638463332462d383938302d343445462d423437332d313235303132374239344536222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202230393a3138222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e343230392c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a2020202022746f74616c49766122203a20312e35362c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e362c0d0a2020202022746f74616c506167617222203a2031332e362c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e362c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223731220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17130', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2037310d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17131', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17132', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17133', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17134', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17135', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17136', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17137', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17138', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303036222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202234433241383738302d344337432d343030432d424644382d353139423834334536304441222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202231303a30383a3232222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a206e756c6c2c0d0a20202020226e756d446f63756d656e746f22203a206e756c6c2c0d0a20202020226e6f6d62726522203a2022434f4e53554d49444f522046494e414c222c0d0a2020202022636f7272656f22203a206e756c6c2c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223732220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17139', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2037320d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17140', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17141', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303037222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202232364545394545332d313536372d344437302d413244342d374236343136414237333135222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202231303a33343a3139222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20302e313434332c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a20312e31312c0d0a2020202022737562546f74616c56656e74617322203a20312e31312c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a20312e31312c0d0a2020202022746f74616c49766122203a20302e31342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a20312e32352c0d0a2020202022746f74616c506167617222203a20312e32352c0d0a2020202022746f74616c4c657472617322203a2022554e4f20434f4e2032352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a20312e32352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223733220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17142', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2037330d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17143', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17144', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303035222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202239463735334231332d323143412d344134462d393633442d453934343946453633463543222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202231313a32353a3436222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e302c0d0a202020202269766150657263693122203a20302e302c0d0a2020202022697661526574653122203a20302e302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20312e35360d0a202020207d205d2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e362c0d0a2020202022746f74616c506167617222203a2031332e362c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e362c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223734220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17145', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2037340d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17146', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17147', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17148', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17149', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17150', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17151', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17152', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17153', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17154', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17155', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17156', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20312c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223031222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30312d4d303031503030312d303030303030303030303030303139222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202233303338313333362d383830302d343243342d383136432d423044443433443042463337222c0d0a20202020227469706f4d6f64656c6f22203a20322c0d0a20202020227469706f4f7065726163696f6e22203a20322c0d0a20202020227469706f436f6e74696e67656e63696122203a20312c0d0a20202020226d6f7469766f436f6e74696e22203a2022536520667565206c6120696e7465726e6574222c0d0a2020202022666563456d6922203a2022323032352d31322d3239222c0d0a2020202022686f72456d6922203a202231303a35313a3137222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e726322203a206e756c6c2c0d0a20202020227469706f446f63756d656e746f22203a20223133222c0d0a20202020226e756d446f63756d656e746f22203a2022303631393531343932222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d222c0d0a2020202022636f6441637469766964616422203a206e756c6c2c0d0a20202020226465736341637469766964616422203a206e756c6c2c0d0a2020202022646972656363696f6e22203a206e756c6c2c0d0a202020202274656c65666f6e6f22203a206e756c6c0d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a20202020226976614974656d22203a20312e34322c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031302e39332c0d0a2020202022737562546f74616c56656e74617322203a2031302e39332c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a206e756c6c2c0d0a2020202022737562546f74616c22203a2031302e39332c0d0a2020202022746f74616c49766122203a20312e34322c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031322e33352c0d0a2020202022746f74616c506167617222203a2031322e33352c0d0a2020202022746f74616c4c657472617322203a2022444f434520434f4e2033352f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031322e33352c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223430220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17157', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2034300d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17158', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17159', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303035222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202239463735334231332d323143412d344134462d393633442d453934343946453633463543222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202231313a32353a3436222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a202020202269766150657263693122203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20312e35360d0a202020207d205d2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223734220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17160', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2037340d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17161', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17162', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303035222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202239463735334231332d323143412d344134462d393633442d453934343946453633463543222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202231313a32353a3436222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a202020202269766150657263693122203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20312e35360d0a202020207d205d2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223734220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17163', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2037340d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17164', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17165', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303035222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202239463735334231332d323143412d344134462d393633442d453934343946453633463543222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202231313a32353a3436222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a202020202269766150657263693122203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20312e35360d0a202020207d205d2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223734220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17166', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2037340d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17167', 131072);
SELECT pg_catalog.lowrite(0, '\x4552524f52');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17168', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a2020226964656e74696669636163696f6e22203a207b0d0a202020202276657273696f6e22203a20332c0d0a2020202022616d6269656e746522203a20223030222c0d0a20202020227469706f44746522203a20223033222c0d0a20202020226e756d65726f436f6e74726f6c22203a20224454452d30332d4d303031503030312d303030303030303030303030303035222c0d0a2020202022636f6469676f47656e65726163696f6e22203a202239463735334231332d323143412d344134462d393633442d453934343946453633463543222c0d0a20202020227469706f4d6f64656c6f22203a20312c0d0a20202020227469706f4f7065726163696f6e22203a20312c0d0a20202020227469706f436f6e74696e67656e63696122203a206e756c6c2c0d0a20202020226d6f7469766f436f6e74696e22203a206e756c6c2c0d0a2020202022666563456d6922203a2022323032362d30312d3037222c0d0a2020202022686f72456d6922203a202231313a32353a3436222c0d0a20202020227469706f4d6f6e65646122203a2022555344220d0a20207d2c0d0a202022656d69736f7222203a207b0d0a20202020226e697422203a20223033303230393032363631303130222c0d0a20202020226e726322203a20223131222c0d0a20202020226e6f6d62726522203a20224341524c4f5320414c424552544f204f52454c4c414e41204241525249454e544f53222c0d0a2020202022636f6441637469766964616422203a20223935323932222c0d0a20202020226465736341637469766964616422203a2022536572766963696f732064652063657272616a6572c3ad61207920636f706961646f206465206c6c61766573222c0d0a20202020226e6f6d627265436f6d65726369616c22203a202243657272616a6572c3ad61204d6173746572204b6579222c0d0a20202020227469706f45737461626c6563696d69656e746f22203a20223031222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223035222c0d0a202020202020226d756e69636970696f22203a20223238222c0d0a20202020202022636f6d706c656d656e746f22203a20223130204176204e6f727465207920336572612043616c6c6520506f6e69656e74652023322d31322053616e7461205465636c612c204c61204c69626572746164205375722c204c61204c69626572746164220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223730383637383631222c0d0a2020202022636f7272656f22203a20226d61737465726b65797376303440676d61696c2e636f6d222c0d0a2020202022636f6445737461626c654d4822203a20224d303031222c0d0a2020202022636f6445737461626c6522203a202250303031222c0d0a2020202022636f6450756e746f56656e74614d4822203a202250303031222c0d0a2020202022636f6450756e746f56656e746122203a202250303031220d0a20207d2c0d0a2020227265636570746f7222203a207b0d0a20202020226e697422203a20223236363534363534363534363534222c0d0a20202020226e726322203a20223237222c0d0a20202020226e6f6d62726522203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022636f6441637469766964616422203a20223538323030222c0d0a20202020226465736341637469766964616422203a20224564696369c3b36e2064652070726f6772616d617320696e666f726dc3a17469636f732028736f66747761726529222c0d0a20202020226e6f6d627265436f6d65726369616c22203a2022646172696f757a206f72656c6c616e61222c0d0a2020202022646972656363696f6e22203a207b0d0a20202020202022646570617274616d656e746f22203a20223032222c0d0a202020202020226d756e69636970696f22203a20223137222c0d0a20202020202022636f6d706c656d656e746f22203a20223130206176206e6f727465220d0a202020207d2c0d0a202020202274656c65666f6e6f22203a20223738393835333237222c0d0a2020202022636f7272656f22203a2022646172696f757a6f72656c6c616e616c6f70657a40676d61696c2e636f6d220d0a20207d2c0d0a202022646f63756d656e746f52656c6163696f6e61646f22203a206e756c6c2c0d0a2020226f74726f73446f63756d656e746f7322203a206e756c6c2c0d0a20202276656e74615465726365726f22203a206e756c6c2c0d0a202022657874656e73696f6e22203a206e756c6c2c0d0a20202263756572706f446f63756d656e746f22203a205b207b0d0a20202020226e756d4974656d22203a20312c0d0a20202020227469706f4974656d22203a20322c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202235222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a202243414d42494f20444520434f4d42494e414349c3934e222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a2031322e33352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a2031302e39332c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d2c207b0d0a20202020226e756d4974656d22203a20322c0d0a20202020227469706f4974656d22203a20312c0d0a20202020226e756d65726f446f63756d656e746f22203a206e756c6c2c0d0a2020202022636f6469676f22203a202231222c0d0a2020202022636f645472696275746f22203a206e756c6c2c0d0a20202020226465736372697063696f6e22203a2022444553544f524e494c4c41444f52205048494c4c495053222c0d0a202020202263616e746964616422203a20312e30302c0d0a2020202022756e694d656469646122203a2035392c0d0a202020202270726563696f556e6922203a20312e32352c0d0a20202020226d6f6e746f446573637522203a20302e30302c0d0a202020202276656e74614e6f53756a22203a20302e302c0d0a202020202276656e74614578656e746122203a20302e302c0d0a202020202276656e74614772617661646122203a20312e31312c0d0a20202020227472696275746f7322203a205b2022323022205d2c0d0a202020202270737622203a20302e302c0d0a20202020226e6f4772617661646f22203a20302e300d0a20207d205d2c0d0a202022726573756d656e22203a207b0d0a2020202022746f74616c4e6f53756a22203a20302e302c0d0a2020202022746f74616c4578656e746122203a20302e302c0d0a2020202022746f74616c4772617661646122203a2031322e30342c0d0a2020202022737562546f74616c56656e74617322203a2031322e30342c0d0a202020202264657363754e6f53756a22203a20302e302c0d0a202020202264657363754578656e746122203a20302e302c0d0a202020202264657363754772617661646122203a20302e30302c0d0a2020202022706f7263656e74616a654465736375656e746f22203a20302e302c0d0a2020202022746f74616c446573637522203a20302e30302c0d0a202020202269766150657263693122203a20302e30302c0d0a2020202022697661526574653122203a20302e30302c0d0a20202020227265746552656e746122203a20302c0d0a2020202022746f74616c4e6f4772617661646f22203a20302c0d0a202020202273616c646f4661766f7222203a20302c0d0a20202020227472696275746f7322203a205b207b0d0a20202020202022636f6469676f22203a20223230222c0d0a202020202020226465736372697063696f6e22203a2022496d70756573746f20616c2056616c6f7220416772656761646f20313325222c0d0a2020202020202276616c6f7222203a20312e35360d0a202020207d205d2c0d0a2020202022737562546f74616c22203a2031322e30342c0d0a20202020226d6f6e746f546f74616c4f7065726163696f6e22203a2031332e36302c0d0a2020202022746f74616c506167617222203a2031332e36302c0d0a2020202022746f74616c4c657472617322203a2022545245434520434f4e2036302f313030222c0d0a2020202022636f6e646963696f6e4f7065726163696f6e22203a20312c0d0a20202020227061676f7322203a205b207b0d0a20202020202022636f6469676f22203a20223031222c0d0a202020202020226d6f6e746f5061676f22203a2031332e36302c0d0a202020202020227265666572656e63696122203a206e756c6c2c0d0a20202020202022706c617a6f22203a206e756c6c2c0d0a20202020202022706572696f646f22203a206e756c6c0d0a202020207d205d2c0d0a20202020226e756d5061676f456c656374726f6e69636f22203a206e756c6c0d0a20207d2c0d0a2020226170656e6469636522203a205b207b0d0a202020202263616d706f22203a2022434f44222c0d0a2020202022657469717565746122203a2022434f4449474f2056454e5441222c0d0a202020202276616c6f7222203a20223734220d0a20207d205d0d0a7d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('17169', 131072);
SELECT pg_catalog.lowrite(0, '\x7b0d0a20202265737461646f22203a202252454348415a41444f222c0d0a202022636f6469676f22203a203430312c0d0a2020226465736372697063696f6e4d736722203a2022546f6b656e204d4820696e76c3a16c69646f206f20657870697261646f222c0d0a20202276656e746122203a2037340d0a7d');
SELECT pg_catalog.lo_close(0);

COMMIT;

--
-- TOC entry 4959 (class 2606 OID 16629)
-- Name: actividad_economica actividad_economica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_economica
    ADD CONSTRAINT actividad_economica_pkey PRIMARY KEY (id);


--
-- TOC entry 4961 (class 2606 OID 16631)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 4963 (class 2606 OID 16633)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);


--
-- TOC entry 4967 (class 2606 OID 16635)
-- Name: contingencia_detalle contingencia_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia_detalle
    ADD CONSTRAINT contingencia_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4965 (class 2606 OID 16637)
-- Name: contingencia contingencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia
    ADD CONSTRAINT contingencia_pkey PRIMARY KEY (id);


--
-- TOC entry 4969 (class 2606 OID 16639)
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (id);


--
-- TOC entry 4971 (class 2606 OID 16641)
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id);


--
-- TOC entry 4973 (class 2606 OID 16643)
-- Name: invalidacion invalidacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion
    ADD CONSTRAINT invalidacion_pkey PRIMARY KEY (id);


--
-- TOC entry 4975 (class 2606 OID 16645)
-- Name: invalidacion invalidacion_venta_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion
    ADD CONSTRAINT invalidacion_venta_id_key UNIQUE (venta_id);


--
-- TOC entry 4977 (class 2606 OID 16647)
-- Name: municipio municipio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT municipio_pkey PRIMARY KEY (id);


--
-- TOC entry 4979 (class 2606 OID 16649)
-- Name: parametro parametro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parametro
    ADD CONSTRAINT parametro_pkey PRIMARY KEY (nombre_parametro);


--
-- TOC entry 4981 (class 2606 OID 16651)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id);


--
-- TOC entry 4983 (class 2606 OID 16653)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- TOC entry 4985 (class 2606 OID 16655)
-- Name: sucursal sucursal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT sucursal_pkey PRIMARY KEY (id);


--
-- TOC entry 4987 (class 2606 OID 16657)
-- Name: tipo_contingencia tipo_contingencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contingencia
    ADD CONSTRAINT tipo_contingencia_pkey PRIMARY KEY (id);


--
-- TOC entry 4989 (class 2606 OID 16659)
-- Name: tipo_contribuyente tipo_contribuyente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_contribuyente
    ADD CONSTRAINT tipo_contribuyente_pkey PRIMARY KEY (id);


--
-- TOC entry 4991 (class 2606 OID 16661)
-- Name: tipo_documento tipo_documento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_documento
    ADD CONSTRAINT tipo_documento_pkey PRIMARY KEY (id);


--
-- TOC entry 4993 (class 2606 OID 16663)
-- Name: tipo_invalidacion tipo_invalidacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_invalidacion
    ADD CONSTRAINT tipo_invalidacion_pkey PRIMARY KEY (id);


--
-- TOC entry 4995 (class 2606 OID 16665)
-- Name: tipo_pago tipo_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_pago
    ADD CONSTRAINT tipo_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 4997 (class 2606 OID 16667)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 4999 (class 2606 OID 16669)
-- Name: usuario usuario_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_username_key UNIQUE (username);


--
-- TOC entry 5003 (class 2606 OID 16671)
-- Name: venta_detalle venta_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_detalle
    ADD CONSTRAINT venta_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 5005 (class 2606 OID 16673)
-- Name: venta_pago venta_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_pago
    ADD CONSTRAINT venta_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 5001 (class 2606 OID 16675)
-- Name: venta venta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (id);


--
-- TOC entry 5031 (class 2620 OID 16676)
-- Name: actividad_economica trg_actividad_economica_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_actividad_economica_updated BEFORE UPDATE ON public.actividad_economica FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5032 (class 2620 OID 16677)
-- Name: caja trg_caja_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_caja_updated BEFORE UPDATE ON public.caja FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5033 (class 2620 OID 16678)
-- Name: cliente trg_cliente_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_cliente_updated BEFORE UPDATE ON public.cliente FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5036 (class 2620 OID 16679)
-- Name: contingencia_detalle trg_contingencia_detalle_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_contingencia_detalle_updated BEFORE UPDATE ON public.contingencia_detalle FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5035 (class 2620 OID 16680)
-- Name: contingencia trg_contingencia_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_contingencia_updated BEFORE UPDATE ON public.contingencia FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5037 (class 2620 OID 16681)
-- Name: departamento trg_departamento_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_departamento_updated BEFORE UPDATE ON public.departamento FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5038 (class 2620 OID 16682)
-- Name: empresa trg_empresa_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_empresa_updated BEFORE UPDATE ON public.empresa FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5034 (class 2620 OID 16683)
-- Name: contador_dte trg_invalidacion_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_invalidacion_updated BEFORE UPDATE ON public.contador_dte FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5039 (class 2620 OID 16684)
-- Name: invalidacion trg_invalidacion_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_invalidacion_updated BEFORE UPDATE ON public.invalidacion FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5041 (class 2620 OID 16685)
-- Name: parametro trg_invalidacion_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_invalidacion_updated BEFORE UPDATE ON public.parametro FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5040 (class 2620 OID 16686)
-- Name: municipio trg_municipio_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_municipio_updated BEFORE UPDATE ON public.municipio FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5042 (class 2620 OID 16687)
-- Name: producto trg_producto_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_producto_updated BEFORE UPDATE ON public.producto FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5043 (class 2620 OID 16688)
-- Name: rol trg_rol_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rol_updated BEFORE UPDATE ON public.rol FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5044 (class 2620 OID 16689)
-- Name: sucursal trg_sucursal_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sucursal_updated BEFORE UPDATE ON public.sucursal FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5045 (class 2620 OID 16690)
-- Name: tipo_contingencia trg_tipo_contingencia_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_contingencia_updated BEFORE UPDATE ON public.tipo_contingencia FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5046 (class 2620 OID 16691)
-- Name: tipo_contribuyente trg_tipo_contribuyente_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_contribuyente_updated BEFORE UPDATE ON public.tipo_contribuyente FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5047 (class 2620 OID 16692)
-- Name: tipo_documento trg_tipo_documento_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_documento_updated BEFORE UPDATE ON public.tipo_documento FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5048 (class 2620 OID 16693)
-- Name: tipo_invalidacion trg_tipo_invalidacion_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_invalidacion_updated BEFORE UPDATE ON public.tipo_invalidacion FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5049 (class 2620 OID 16694)
-- Name: tipo_pago trg_tipo_pago_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tipo_pago_updated BEFORE UPDATE ON public.tipo_pago FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5050 (class 2620 OID 16695)
-- Name: usuario trg_usuario_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_usuario_updated BEFORE UPDATE ON public.usuario FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5052 (class 2620 OID 16696)
-- Name: venta_detalle trg_venta_detalle_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_venta_detalle_updated BEFORE UPDATE ON public.venta_detalle FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5053 (class 2620 OID 16697)
-- Name: venta_pago trg_venta_pago_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_venta_pago_updated BEFORE UPDATE ON public.venta_pago FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5051 (class 2620 OID 16698)
-- Name: venta trg_venta_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_venta_updated BEFORE UPDATE ON public.venta FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5006 (class 2606 OID 16699)
-- Name: caja caja_sucursal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(id);


--
-- TOC entry 5007 (class 2606 OID 16704)
-- Name: cliente cliente_codigo_actividad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_codigo_actividad_id_fkey FOREIGN KEY (codigo_actividad_id) REFERENCES public.actividad_economica(id);


--
-- TOC entry 5008 (class 2606 OID 16709)
-- Name: cliente cliente_departamento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_departamento_id_fkey FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 5009 (class 2606 OID 16714)
-- Name: cliente cliente_municipio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_municipio_id_fkey FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 5010 (class 2606 OID 16719)
-- Name: cliente cliente_tipo_contribuyente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_tipo_contribuyente_id_fkey FOREIGN KEY (tipo_contribuyente_id) REFERENCES public.tipo_contribuyente(id);


--
-- TOC entry 5012 (class 2606 OID 16724)
-- Name: contingencia_detalle contingencia_detalle_contingencia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia_detalle
    ADD CONSTRAINT contingencia_detalle_contingencia_id_fkey FOREIGN KEY (contingencia_id) REFERENCES public.contingencia(id);


--
-- TOC entry 5013 (class 2606 OID 16729)
-- Name: contingencia_detalle contingencia_detalle_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia_detalle
    ADD CONSTRAINT contingencia_detalle_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.venta(id);


--
-- TOC entry 5011 (class 2606 OID 16734)
-- Name: contingencia contingencia_tipo_contingencia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contingencia
    ADD CONSTRAINT contingencia_tipo_contingencia_id_fkey FOREIGN KEY (tipo_contingencia_id) REFERENCES public.tipo_contingencia(id);


--
-- TOC entry 5014 (class 2606 OID 16739)
-- Name: empresa empresa_codigo_actividad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_codigo_actividad_id_fkey FOREIGN KEY (codigo_actividad_id) REFERENCES public.actividad_economica(id);


--
-- TOC entry 5015 (class 2606 OID 16744)
-- Name: empresa empresa_departamento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_departamento_id_fkey FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 5016 (class 2606 OID 16749)
-- Name: empresa empresa_municipio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_municipio_id_fkey FOREIGN KEY (municipio_id) REFERENCES public.municipio(id);


--
-- TOC entry 5017 (class 2606 OID 16754)
-- Name: empresa empresa_tipo_contribuyente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_tipo_contribuyente_id_fkey FOREIGN KEY (tipo_contribuyente_id) REFERENCES public.tipo_contribuyente(id);


--
-- TOC entry 5018 (class 2606 OID 16759)
-- Name: invalidacion invalidacion_tipo_anulacion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion
    ADD CONSTRAINT invalidacion_tipo_anulacion_id_fkey FOREIGN KEY (tipo_anulacion_id) REFERENCES public.tipo_invalidacion(id);


--
-- TOC entry 5019 (class 2606 OID 16764)
-- Name: invalidacion invalidacion_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalidacion
    ADD CONSTRAINT invalidacion_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.venta(id);


--
-- TOC entry 5020 (class 2606 OID 16769)
-- Name: municipio municipio_departamento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT municipio_departamento_id_fkey FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- TOC entry 5021 (class 2606 OID 16774)
-- Name: sucursal sucursal_empresa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT sucursal_empresa_id_fkey FOREIGN KEY (empresa_id) REFERENCES public.empresa(id);


--
-- TOC entry 5022 (class 2606 OID 16779)
-- Name: usuario usuario_caja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_caja_id_fkey FOREIGN KEY (caja_id) REFERENCES public.caja(id);


--
-- TOC entry 5023 (class 2606 OID 16784)
-- Name: usuario usuario_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.rol(id);


--
-- TOC entry 5024 (class 2606 OID 16789)
-- Name: venta venta_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(id);


--
-- TOC entry 5027 (class 2606 OID 16794)
-- Name: venta_detalle venta_detalle_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_detalle
    ADD CONSTRAINT venta_detalle_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id);


--
-- TOC entry 5028 (class 2606 OID 16799)
-- Name: venta_detalle venta_detalle_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_detalle
    ADD CONSTRAINT venta_detalle_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.venta(id);


--
-- TOC entry 5029 (class 2606 OID 16804)
-- Name: venta_pago venta_pago_tipo_pago_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_pago
    ADD CONSTRAINT venta_pago_tipo_pago_id_fkey FOREIGN KEY (tipo_pago_id) REFERENCES public.tipo_pago(id);


--
-- TOC entry 5030 (class 2606 OID 16809)
-- Name: venta_pago venta_pago_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_pago
    ADD CONSTRAINT venta_pago_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.venta(id);


--
-- TOC entry 5025 (class 2606 OID 16814)
-- Name: venta venta_tipo_documento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_tipo_documento_id_fkey FOREIGN KEY (tipo_documento_id) REFERENCES public.tipo_documento(id);


--
-- TOC entry 5026 (class 2606 OID 16819)
-- Name: venta venta_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


-- Completed on 2026-01-07 12:50:17

--
-- PostgreSQL database dump complete
--

\unrestrict H9arLjkWFDwxd1liEj3D7Ysd6HVliO2FT9DvWMJErKAJglpplcVm8g8Yfl99mt9

