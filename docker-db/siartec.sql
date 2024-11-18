--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

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
-- Name: status_apply_to_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_apply_to_enum AS ENUM (
    'all',
    'stamps',
    'payments',
    'transactions',
    'external_requests'
);


ALTER TYPE public.status_apply_to_enum OWNER TO postgres;

--
-- Name: users_gender_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.users_gender_enum AS ENUM (
    'M',
    'F',
    'O'
);


ALTER TYPE public.users_gender_enum OWNER TO postgres;

--
-- Name: reset_sequence(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reset_sequence(sequence_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  EXECUTE format('ALTER SEQUENCE %I RESTART WITH 1;', sequence_name);
END;
$$;


ALTER FUNCTION public.reset_sequence(sequence_name text) OWNER TO postgres;

--
-- Name: annual_correlative_tax_stamps; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.annual_correlative_tax_stamps
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.annual_correlative_tax_stamps OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "auditableProcessId" integer
);


ALTER TABLE public.audit OWNER TO postgres;

--
-- Name: audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_id_seq OWNER TO postgres;

--
-- Name: audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_id_seq OWNED BY public.audit.id;


--
-- Name: auditable_process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auditable_process (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "privilegeId" integer
);


ALTER TABLE public.auditable_process OWNER TO postgres;

--
-- Name: auditable_process_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auditable_process_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auditable_process_id_seq OWNER TO postgres;

--
-- Name: auditable_process_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auditable_process_id_seq OWNED BY public.auditable_process.id;


--
-- Name: audits_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audits_detail (
    id integer NOT NULL,
    "recordId" integer NOT NULL,
    at_table character varying NOT NULL,
    at_column character varying NOT NULL,
    old_value character varying NOT NULL,
    new_value character varying NOT NULL,
    data_type character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "auditId" integer
);


ALTER TABLE public.audits_detail OWNER TO postgres;

--
-- Name: audits_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audits_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audits_detail_id_seq OWNER TO postgres;

--
-- Name: audits_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audits_detail_id_seq OWNED BY public.audits_detail.id;


--
-- Name: bank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    code character varying(10) NOT NULL,
    description character varying(150) NOT NULL,
    code_bank character varying(10),
    description_bank character varying(150)
);


ALTER TABLE public.bank OWNER TO postgres;

--
-- Name: bank_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_account (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "bankId" integer NOT NULL,
    account_number character varying(20) NOT NULL
);


ALTER TABLE public.bank_account OWNER TO postgres;

--
-- Name: bank_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bank_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bank_account_id_seq OWNER TO postgres;

--
-- Name: bank_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bank_account_id_seq OWNED BY public.bank_account.id;


--
-- Name: bank_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bank_id_seq OWNER TO postgres;

--
-- Name: bank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bank_id_seq OWNED BY public.bank.id;


--
-- Name: branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.branch OWNER TO postgres;

--
-- Name: branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.branch_id_seq OWNER TO postgres;

--
-- Name: branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;


--
-- Name: calculation_factor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calculation_factor (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "coinId" integer,
    amount numeric NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.calculation_factor OWNER TO postgres;

--
-- Name: calculation_factor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.calculation_factor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.calculation_factor_id_seq OWNER TO postgres;

--
-- Name: calculation_factor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.calculation_factor_id_seq OWNED BY public.calculation_factor.id;


--
-- Name: coin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coin (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.coin OWNER TO postgres;

--
-- Name: coin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.coin_id_seq OWNER TO postgres;

--
-- Name: coin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coin_id_seq OWNED BY public.coin.id;


--
-- Name: contributors_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contributors_type (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    amount numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "roleId" integer
);


ALTER TABLE public.contributors_type OWNER TO postgres;

--
-- Name: contributors_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contributors_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contributors_type_id_seq OWNER TO postgres;

--
-- Name: contributors_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contributors_type_id_seq OWNED BY public.contributors_type.id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.country (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.country OWNER TO postgres;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.country_id_seq OWNER TO postgres;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.country_id_seq OWNED BY public.country.id;


--
-- Name: daily_correlative_request_bank; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.daily_correlative_request_bank
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.daily_correlative_request_bank OWNER TO postgres;

--
-- Name: daily_correlative_tax_stamps; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.daily_correlative_tax_stamps
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.daily_correlative_tax_stamps OWNER TO postgres;

--
-- Name: document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document (
    id integer NOT NULL,
    path character varying(150) NOT NULL,
    description character varying(256) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    number character varying(100) NOT NULL,
    publication_date date NOT NULL,
    file_name character varying(256) NOT NULL
);


ALTER TABLE public.document OWNER TO postgres;

--
-- Name: document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.document_id_seq OWNER TO postgres;

--
-- Name: document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.document_id_seq OWNED BY public.document.id;


--
-- Name: entities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entities (
    id integer NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    code character varying(4) NOT NULL
);


ALTER TABLE public.entities OWNER TO postgres;

--
-- Name: entities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.entities_id_seq OWNER TO postgres;

--
-- Name: entities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entities_id_seq OWNED BY public.entities.id;


--
-- Name: external_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.external_request (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "typeExternalRequestId" integer,
    request_url character varying NOT NULL,
    request_json text NOT NULL,
    response_json text NOT NULL,
    "transactionId" integer
);


ALTER TABLE public.external_request OWNER TO postgres;

--
-- Name: external_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.external_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.external_request_id_seq OWNER TO postgres;

--
-- Name: external_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.external_request_id_seq OWNED BY public.external_request.id;


--
-- Name: locker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locker (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "branchId" integer
);


ALTER TABLE public.locker OWNER TO postgres;

--
-- Name: locker_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locker_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locker_id_seq OWNER TO postgres;

--
-- Name: locker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locker_id_seq OWNED BY public.locker.id;


--
-- Name: lockers_point_of_sale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lockers_point_of_sale (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "lockerId" integer,
    "pointOfSaleId" integer
);


ALTER TABLE public.lockers_point_of_sale OWNER TO postgres;

--
-- Name: lockers_point_of_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lockers_point_of_sale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lockers_point_of_sale_id_seq OWNER TO postgres;

--
-- Name: lockers_point_of_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lockers_point_of_sale_id_seq OWNED BY public.lockers_point_of_sale.id;


--
-- Name: municipalities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.municipalities (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "stateId" integer
);


ALTER TABLE public.municipalities OWNER TO postgres;

--
-- Name: municipalities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.municipalities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.municipalities_id_seq OWNER TO postgres;

--
-- Name: municipalities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.municipalities_id_seq OWNED BY public.municipalities.id;


--
-- Name: parishes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parishes (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "municipalityId" integer
);


ALTER TABLE public.parishes OWNER TO postgres;

--
-- Name: parishes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parishes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parishes_id_seq OWNER TO postgres;

--
-- Name: parishes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parishes_id_seq OWNED BY public.parishes.id;


--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id integer NOT NULL,
    amount numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "lockerId" integer,
    "paymentTypeId" integer
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_id_seq OWNER TO postgres;

--
-- Name: payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_id_seq OWNED BY public.payment.id;


--
-- Name: payments_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments_type (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.payments_type OWNER TO postgres;

--
-- Name: payments_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_type_id_seq OWNER TO postgres;

--
-- Name: payments_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_type_id_seq OWNED BY public.payments_type.id;


--
-- Name: point_of_sale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.point_of_sale (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    serial character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "bankAccountId" integer
);


ALTER TABLE public.point_of_sale OWNER TO postgres;

--
-- Name: point_of_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.point_of_sale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.point_of_sale_id_seq OWNER TO postgres;

--
-- Name: point_of_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.point_of_sale_id_seq OWNED BY public.point_of_sale.id;


--
-- Name: privilege; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.privilege (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.privilege OWNER TO postgres;

--
-- Name: privilege_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.privilege_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.privilege_id_seq OWNER TO postgres;

--
-- Name: privilege_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.privilege_id_seq OWNED BY public.privilege.id;


--
-- Name: procedure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procedure (
    id integer NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "subentityId" integer,
    is_specific_value boolean DEFAULT false NOT NULL,
    value numeric,
    code character varying(4) NOT NULL
);


ALTER TABLE public.procedure OWNER TO postgres;

--
-- Name: procedure_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.procedure_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.procedure_id_seq OWNER TO postgres;

--
-- Name: procedure_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.procedure_id_seq OWNED BY public.procedure.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.role OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_id_seq OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- Name: roles_privilege; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles_privilege (
    id integer NOT NULL,
    "roleId" integer NOT NULL,
    "privilegeId" integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.roles_privilege OWNER TO postgres;

--
-- Name: roles_privilege_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_privilege_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_privilege_id_seq OWNER TO postgres;

--
-- Name: roles_privilege_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_privilege_id_seq OWNED BY public.roles_privilege.id;


--
-- Name: state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.state (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "countryId" integer
);


ALTER TABLE public.state OWNER TO postgres;

--
-- Name: state_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.state_id_seq OWNER TO postgres;

--
-- Name: state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.state_id_seq OWNED BY public.state.id;


--
-- Name: status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    apply_to public.status_apply_to_enum NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.status OWNER TO postgres;

--
-- Name: status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.status_id_seq OWNER TO postgres;

--
-- Name: status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.status_id_seq OWNED BY public.status.id;


--
-- Name: subentity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subentity (
    id integer NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "entityId" integer,
    code character varying(4) NOT NULL
);


ALTER TABLE public.subentity OWNER TO postgres;

--
-- Name: subentity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subentity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subentity_id_seq OWNER TO postgres;

--
-- Name: subentity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subentity_id_seq OWNED BY public.subentity.id;


--
-- Name: tax_stamp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_stamp (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    amount numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "userId" integer,
    "procedureId" integer,
    "calculationFactorId" integer,
    number_folios integer NOT NULL,
    year character varying(4) NOT NULL
);


ALTER TABLE public.tax_stamp OWNER TO postgres;

--
-- Name: tax_stamp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tax_stamp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tax_stamp_id_seq OWNER TO postgres;

--
-- Name: tax_stamp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tax_stamp_id_seq OWNED BY public.tax_stamp.id;


--
-- Name: tax_stamps_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_stamps_payment (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "taxStampId" integer,
    "paymentId" integer
);


ALTER TABLE public.tax_stamps_payment OWNER TO postgres;

--
-- Name: tax_stamps_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tax_stamps_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tax_stamps_payment_id_seq OWNER TO postgres;

--
-- Name: tax_stamps_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tax_stamps_payment_id_seq OWNED BY public.tax_stamps_payment.id;


--
-- Name: transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction (
    id integer NOT NULL,
    reference character varying(20) NOT NULL,
    amount numeric NOT NULL,
    date timestamp with time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "transactionTypeId" integer,
    "bankAccountId" integer,
    "paymentId" integer
);


ALTER TABLE public.transaction OWNER TO postgres;

--
-- Name: transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaction_id_seq OWNER TO postgres;

--
-- Name: transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_id_seq OWNED BY public.transaction.id;


--
-- Name: transactions_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions_type (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.transactions_type OWNER TO postgres;

--
-- Name: transactions_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_type_id_seq OWNER TO postgres;

--
-- Name: transactions_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_type_id_seq OWNED BY public.transactions_type.id;


--
-- Name: types_external_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types_external_request (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer
);


ALTER TABLE public.types_external_request OWNER TO postgres;

--
-- Name: types_external_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.types_external_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.types_external_request_id_seq OWNER TO postgres;

--
-- Name: types_external_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.types_external_request_id_seq OWNED BY public.types_external_request.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(40) NOT NULL,
    password character varying NOT NULL,
    identity_document_letter character(1) NOT NULL,
    identity_document character varying(12) NOT NULL,
    birthdate date,
    constitution_date date,
    address text NOT NULL,
    phone_number character varying(15) NOT NULL,
    last_connection timestamp with time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    "roleId" integer,
    "contributorTypeId" integer,
    "parishId" integer,
    fullname character varying(256) NOT NULL,
    "refreshToken" character varying,
    contributor_exempt boolean DEFAULT false NOT NULL,
    gender public.users_gender_enum DEFAULT 'O'::public.users_gender_enum NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: audit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit ALTER COLUMN id SET DEFAULT nextval('public.audit_id_seq'::regclass);


--
-- Name: auditable_process id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditable_process ALTER COLUMN id SET DEFAULT nextval('public.auditable_process_id_seq'::regclass);


--
-- Name: audits_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits_detail ALTER COLUMN id SET DEFAULT nextval('public.audits_detail_id_seq'::regclass);


--
-- Name: bank id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank ALTER COLUMN id SET DEFAULT nextval('public.bank_id_seq'::regclass);


--
-- Name: bank_account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account ALTER COLUMN id SET DEFAULT nextval('public.bank_account_id_seq'::regclass);


--
-- Name: branch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);


--
-- Name: calculation_factor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calculation_factor ALTER COLUMN id SET DEFAULT nextval('public.calculation_factor_id_seq'::regclass);


--
-- Name: coin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coin ALTER COLUMN id SET DEFAULT nextval('public.coin_id_seq'::regclass);


--
-- Name: contributors_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type ALTER COLUMN id SET DEFAULT nextval('public.contributors_type_id_seq'::regclass);


--
-- Name: country id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country ALTER COLUMN id SET DEFAULT nextval('public.country_id_seq'::regclass);


--
-- Name: document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document ALTER COLUMN id SET DEFAULT nextval('public.document_id_seq'::regclass);


--
-- Name: entities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities ALTER COLUMN id SET DEFAULT nextval('public.entities_id_seq'::regclass);


--
-- Name: external_request id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_request ALTER COLUMN id SET DEFAULT nextval('public.external_request_id_seq'::regclass);


--
-- Name: locker id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locker ALTER COLUMN id SET DEFAULT nextval('public.locker_id_seq'::regclass);


--
-- Name: lockers_point_of_sale id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lockers_point_of_sale ALTER COLUMN id SET DEFAULT nextval('public.lockers_point_of_sale_id_seq'::regclass);


--
-- Name: municipalities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipalities ALTER COLUMN id SET DEFAULT nextval('public.municipalities_id_seq'::regclass);


--
-- Name: parishes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parishes ALTER COLUMN id SET DEFAULT nextval('public.parishes_id_seq'::regclass);


--
-- Name: payment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment ALTER COLUMN id SET DEFAULT nextval('public.payment_id_seq'::regclass);


--
-- Name: payments_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments_type ALTER COLUMN id SET DEFAULT nextval('public.payments_type_id_seq'::regclass);


--
-- Name: point_of_sale id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_of_sale ALTER COLUMN id SET DEFAULT nextval('public.point_of_sale_id_seq'::regclass);


--
-- Name: privilege id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilege ALTER COLUMN id SET DEFAULT nextval('public.privilege_id_seq'::regclass);


--
-- Name: procedure id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure ALTER COLUMN id SET DEFAULT nextval('public.procedure_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: roles_privilege id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege ALTER COLUMN id SET DEFAULT nextval('public.roles_privilege_id_seq'::regclass);


--
-- Name: state id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state ALTER COLUMN id SET DEFAULT nextval('public.state_id_seq'::regclass);


--
-- Name: status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status ALTER COLUMN id SET DEFAULT nextval('public.status_id_seq'::regclass);


--
-- Name: subentity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subentity ALTER COLUMN id SET DEFAULT nextval('public.subentity_id_seq'::regclass);


--
-- Name: tax_stamp id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamp ALTER COLUMN id SET DEFAULT nextval('public.tax_stamp_id_seq'::regclass);


--
-- Name: tax_stamps_payment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamps_payment ALTER COLUMN id SET DEFAULT nextval('public.tax_stamps_payment_id_seq'::regclass);


--
-- Name: transaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction ALTER COLUMN id SET DEFAULT nextval('public.transaction_id_seq'::regclass);


--
-- Name: transactions_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_type ALTER COLUMN id SET DEFAULT nextval('public.transactions_type_id_seq'::regclass);


--
-- Name: types_external_request id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_external_request ALTER COLUMN id SET DEFAULT nextval('public.types_external_request_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: audit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit (id, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "auditableProcessId") FROM stdin;
\.


--
-- Data for Name: auditable_process; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auditable_process (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "privilegeId") FROM stdin;
\.


--
-- Data for Name: audits_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audits_detail (id, "recordId", at_table, at_column, old_value, new_value, data_type, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "auditId") FROM stdin;
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank (id, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", code, description, code_bank, description_bank) FROM stdin;
1	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0102	BANCO DE VENEZUELA S.A.I.C.A.	102	VENEZUELA
2	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0104	BANCO VENEZOLANO DE CREDITO S.A.	104	VZLANO DE CREDITO
3	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0105	BANCO MERCANTIL C.A.	105	MERCANTIL
4	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0108	BANCO PROVINCIAL BBVA	108	PROVINCIAL
5	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0114	BANCO DEL CARIBE C.A.	114	BANCARIBE
6	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0115	BANCO EXTERIOR C.A.	115	EXTERIOR
7	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0128	BANCO CARONI, C.A. BANCO UNIVERSAL	128	CARONI
8	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0134	Banesco Banco Universal	134	BANESCO
9	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0137	SOFITASA	137	SOFITASA
10	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0138	BANCO PLAZA	138	PLAZA
11	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0151	FONDO COMUN	151	BFC BANCO FONDO COMUN
12	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0156	100%BANCO	156	100% BANCO, BANCO UNIVERSAL
13	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0157	DELSUR BANCO UNIVERSAL	157	DEL SUR
14	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0163	BANCO DEL TESORO	163	BANCO DEL TESORO
15	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0166	BANCO AGRICOLA	166	AGRICOLA DE VENEZUELA
16	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0168	BANCRECER S.A. BANCO DE DESARROLLO	168	BANCRECER
17	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0169	MIBANCO BANCO DE DESARROLLO, C.A.	169	MI BANCO
18	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0171	BANCO ACTIVO BANCO COMERCIAL, C.A.	171	ACTIVO BANCO UNIVERSAL
19	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0172	BANCAMIGA BANCO MICROFINANCIERO, C.A.	172	BANCAMIGA
20	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0174	BANPLUS BANCO COMERCIAL C.A	174	BANPLUS BANCO COMERCIAL
21	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0175	BANCO BICENTENARIO	175	BICENTENARIO
22	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0177	BANFANB	177	BANCO FUERZA ARMADA NACIONAL
23	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0191	BANCO NACIONAL DE CREDITO	191	BANCO NACIONAL CREDITO
24	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0196	ABN AMRO BANK	\N	\N
25	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0001	BANCO CENTRAL DE VENEZUELA.	\N	\N
26	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0116	BANCO OCCIDENTAL DE DESCUENTO.	\N	\N
27	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0146	BANGENTE	\N	\N
28	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0149	BANCO DEL PUEBLO SOBERANO C.A.	\N	\N
29	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0164	BANCO DE DESARROLLO DEL MICROEMPRESARIO	\N	\N
30	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0173	BANCO INTERNACIONAL DE DESARROLLO, C.A.	\N	\N
31	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0176	BANCO ESPIRITO SANTO, S.A.	\N	\N
32	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0190	CITIBANK.	\N	\N
33	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	\N	\N	\N	\N	0601	INSTITUTO MUNICIPAL DE CRÉDITO POPULAR	\N	\N
\.


--
-- Data for Name: bank_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_account (id, code, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "bankId", account_number) FROM stdin;
1	01561234	2024-11-06 22:57:43.089708	2024-11-06 22:57:43.089708	\N	\N	1	1	\N	12	01560000000000001234
\.


--
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branch (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
\.


--
-- Data for Name: calculation_factor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calculation_factor (id, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "coinId", amount, date) FROM stdin;
45	2024-10-26 22:54:18.663568	2024-10-26 22:54:18.663568	\N	\N	\N	\N	\N	3	44.42319324	2024-10-26
46	2024-10-28 20:58:50.11217	2024-10-28 20:58:50.11217	\N	\N	\N	\N	\N	3	45.17849352	2024-10-28
47	2024-10-29 00:00:36.156533	2024-10-29 00:00:36.156533	\N	\N	\N	\N	\N	3	45.17849352	2024-10-29
50	2024-11-05 20:54:42.442276	2024-11-05 20:54:42.442276	\N	\N	\N	\N	\N	3	47.4013772	2024-11-05
51	2024-11-05 20:54:42.442276	2024-11-05 20:54:42.442276	\N	\N	\N	\N	\N	3	47.4013772	2024-11-06
53	2024-11-05 20:54:42.442276	2024-11-05 20:54:42.442276	\N	\N	\N	\N	\N	3	47.4013772	2024-11-07
55	2024-11-09 21:04:53.958772	2024-11-09 21:04:53.958772	\N	\N	\N	\N	\N	3	48.05536843	2024-11-09
56	2024-11-10 16:51:51.79932	2024-11-10 16:51:51.79932	\N	\N	\N	\N	\N	3	48.05536843	2024-11-10
57	2024-11-13 21:28:59.678183	2024-11-13 21:28:59.678183	\N	\N	\N	\N	\N	3	47.60795563	2024-11-13
58	2024-11-14 21:25:28.226941	2024-11-14 21:25:28.226941	\N	\N	\N	\N	\N	3	48.07177452	2024-11-14
59	2024-11-16 14:11:07.473644	2024-11-16 14:11:07.473644	\N	\N	\N	\N	\N	3	48.25699076	2024-11-16
60	2024-11-17 13:55:17.379546	2024-11-17 13:55:17.379546	\N	\N	\N	\N	\N	3	48.25699076	2024-11-17
\.


--
-- Data for Name: coin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coin (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	VES	Bolivares Soberanos	2024-10-24 14:34:04.553321	2024-10-24 14:34:04.553321	\N	1	1	1	\N
2	USD	Dolares	2024-10-24 22:31:54.92722	2024-10-24 22:31:54.92722	\N	1	1	1	\N
3	EUR	Euros	2024-10-24 22:31:54.931116	2024-10-24 22:31:54.931116	\N	1	1	1	\N
\.


--
-- Data for Name: contributors_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contributors_type (id, code, description, amount, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "roleId") FROM stdin;
1	NATURAL	Natural	5	2024-07-15 16:56:16.651399	2024-07-15 16:56:16.651399	\N	1	\N	\N	\N	3
2	COMMERCIAL	Comercial	20	2024-07-15 16:56:16.656944	2024-07-15 16:56:16.656944	\N	1	\N	\N	\N	4
3	INDUSTRIAL	Industrial	50	2024-07-15 16:56:16.657983	2024-07-15 16:56:16.657983	\N	1	\N	\N	\N	5
4	FIRMA	Firma Personal	20	2024-10-12 12:38:22.943652	2024-10-12 12:38:22.943652	\N	\N	\N	\N	\N	6
5	SUCESION	Sucesión	5	2024-10-12 12:40:37.344079	2024-10-12 12:40:37.344079	\N	\N	\N	\N	\N	7
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.country (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	AF	Afganistán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
2	AX	Islas Gland	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
3	AL	Albania	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
4	DE	Alemania	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
5	AD	Andorra	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
6	AO	Angola	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
7	AI	Anguilla	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
8	AQ	Antártida	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
9	AG	Antigua y Barbuda	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
10	AN	Antillas Holandesas	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
11	SA	Arabia Saudí	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
12	DZ	Argelia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
13	AR	Argentina	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
14	AM	Armenia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
15	AW	Aruba	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
16	AU	Australia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
17	AT	Austria	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
18	AZ	Azerbaiyán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
19	BS	Bahamas	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
20	BH	Bahréin	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
21	BD	Bangladesh	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
22	BB	Barbados	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
23	BY	Bielorrusia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
24	BE	Bélgica	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
25	BZ	Belice	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
26	BJ	Benin	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
27	BM	Bermudas	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
28	BT	Bhután	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
29	BO	Bolivia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
30	BA	Bosnia y Herzegovina	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
31	BW	Botsuana	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
32	BV	Isla Bouvet	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
33	BR	Brasil	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
34	BN	Brunéi	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
35	BG	Bulgaria	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
36	BF	Burkina Faso	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
37	BI	Burundi	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
38	CV	Cabo Verde	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
39	KY	Islas Caimán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
40	KH	Camboya	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
41	CM	Camerún	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
42	CA	Canadá	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
43	CF	República Centroafricana	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
44	TD	Chad	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
45	CZ	República Checa	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
46	CL	Chile	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
47	CN	China	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
48	CY	Chipre	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
49	CX	Isla de Navidad	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
50	VA	Ciudad del Vaticano	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
51	CC	Islas Cocos	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
52	CO	Colombia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
53	KM	Comoras	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
54	CD	República Democrática del Congo	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
55	CG	Congo	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
56	CK	Islas Cook	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
57	KP	Corea del Norte	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
58	KR	Corea del Sur	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
59	CI	Costa de Marfil	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
60	CR	Costa Rica	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
61	HR	Croacia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
62	CU	Cuba	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
63	DK	Dinamarca	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
64	DM	Dominica	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
65	DO	República Dominicana	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
66	EC	Ecuador	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
67	EG	Egipto	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
68	SV	El Salvador	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
69	AE	Emiratos Árabes Unidos	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
70	ER	Eritrea	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
71	SK	Eslovaquia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
72	SI	Eslovenia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
73	ES	España	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
74	UM	Islas ultramarinas de Estados Unidos	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
75	US	Estados Unidos	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
76	EE	Estonia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
77	ET	Etiopía	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
78	FO	Islas Feroe	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
79	PH	Filipinas	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
80	FI	Finlandia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
81	FJ	Fiyi	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
82	FR	Francia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
83	GA	Gabón	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
84	GM	Gambia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
85	GE	Georgia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
86	GS	Islas Georgias del Sur y Sandwich del Sur	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
87	GH	Ghana	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
88	GI	Gibraltar	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
89	GD	Granada	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
90	GR	Grecia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
91	GL	Groenlandia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
92	GP	Guadalupe	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
93	GU	Guam	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
94	GT	Guatemala	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
95	GF	Guayana Francesa	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
96	GN	Guinea	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
97	GQ	Guinea Ecuatorial	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
98	GW	Guinea-Bissau	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
99	GY	Guyana	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
100	HT	Haití	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
101	HM	Islas Heard y McDonald	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
102	HN	Honduras	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
103	HK	Hong Kong	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
104	HU	Hungría	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
105	IN	India	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
106	ID	Indonesia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
107	IR	Irán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
108	IQ	Iraq	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
109	IE	Irlanda	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
110	IS	Islandia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
111	IL	Israel	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
112	IT	Italia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
113	JM	Jamaica	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
114	JP	Japón	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
115	JO	Jordania	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
116	KZ	Kazajstán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
117	KE	Kenia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
118	KG	Kirguistán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
119	KI	Kiribati	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
120	KW	Kuwait	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
121	LA	Laos	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
122	LS	Lesotho	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
123	LV	Letonia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
124	LB	Líbano	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
125	LR	Liberia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
126	LY	Libia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
127	LI	Liechtenstein	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
128	LT	Lituania	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
129	LU	Luxemburgo	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
130	MO	Macao	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
131	MK	ARY Macedonia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
132	MG	Madagascar	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
133	MY	Malasia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
134	MW	Malawi	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
135	MV	Maldivas	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
136	ML	Malí	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
137	MT	Malta	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
138	FK	Islas Malvinas	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
139	MP	Islas Marianas del Norte	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
140	MA	Marruecos	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
141	MH	Islas Marshall	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
142	MQ	Martinica	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
143	MU	Mauricio	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
144	MR	Mauritania	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
145	YT	Mayotte	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
146	MX	México	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
147	FM	Micronesia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
148	MD	Moldavia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
149	MC	Mónaco	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
150	MN	Mongolia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
151	MS	Montserrat	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
152	MZ	Mozambique	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
153	MM	Myanmar	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
154	NA	Namibia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
155	NR	Nauru	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
156	NP	Nepal	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
157	NI	Nicaragua	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
158	NE	Níger	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
159	NG	Nigeria	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
160	NU	Niue	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
161	NF	Isla Norfolk	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
162	NO	Noruega	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
163	NC	Nueva Caledonia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
164	NZ	Nueva Zelanda	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
165	OM	Omán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
166	NL	Países Bajos	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
167	PK	Pakistán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
168	PW	Palau	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
169	PS	Palestina	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
170	PA	Panamá	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
171	PG	Papúa Nueva Guinea	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
172	PY	Paraguay	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
173	PE	Perú	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
174	PN	Islas Pitcairn	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
175	PF	Polinesia Francesa	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
176	PL	Polonia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
177	PT	Portugal	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
178	PR	Puerto Rico	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
179	QA	Qatar	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
180	GB	Reino Unido	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
181	RE	Reunión	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
182	RW	Ruanda	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
183	RO	Rumania	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
184	RU	Rusia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
185	EH	Sahara Occidental	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
186	SB	Islas Salomón	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
187	WS	Samoa	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
188	AS	Samoa Americana	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
189	KN	San Cristóbal y Nevis	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
190	SM	San Marino	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
191	PM	San Pedro y Miquelón	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
192	VC	San Vicente y las Granadinas	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
193	SH	Santa Helena	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
194	LC	Santa Lucía	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
195	ST	Santo Tomé y Príncipe	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
196	SN	Senegal	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
197	CS	Serbia y Montenegro	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
198	SC	Seychelles	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
199	SL	Sierra Leona	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
200	SG	Singapur	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
201	SY	Siria	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
202	SO	Somalia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
203	LK	Sri Lanka	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
204	SZ	Suazilandia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
205	ZA	Sudáfrica	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
206	SD	Sudán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
207	SE	Suecia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
208	CH	Suiza	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
209	SR	Surinam	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
210	SJ	Svalbard y Jan Mayen	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
211	TH	Tailandia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
212	TW	Taiwán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
213	TZ	Tanzania	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
214	TJ	Tayikistán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
215	IO	Territorio Británico del Océano Índico	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
216	TF	Territorios Australes Franceses	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
217	TL	Timor Oriental	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
218	TG	Togo	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
219	TK	Tokelau	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
220	TO	Tonga	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
221	TT	Trinidad y Tobago	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
222	TN	Túnez	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
223	TC	Islas Turcas y Caicos	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
224	TM	Turkmenistán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
225	TR	Turquía	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
226	TV	Tuvalu	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
227	UA	Ucrania	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
228	UG	Uganda	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
229	UY	Uruguay	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
230	UZ	Uzbekistán	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
231	VU	Vanuatu	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
232	VE	Venezuela	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
233	VN	Vietnam	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
234	VG	Islas Vírgenes Británicas	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
235	VI	Islas Vírgenes de los Estados Unidos	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
236	WF	Wallis y Futuna	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
237	YE	Yemen	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
238	DJ	Yibuti	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
239	ZM	Zambia	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
240	ZW	Zimbabue	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N
\.


--
-- Data for Name: document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document (id, path, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", number, publication_date, file_name) FROM stdin;
6	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
7	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
8	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
9	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
10	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
11	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
12	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
13	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
14	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
15	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
16	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
17	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
18	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
19	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
20	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
21	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
22	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
23	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
24	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
25	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-n1.pdf
1	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
2	GACETAS	Gaceta N 2 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-2.pdf
3	GACETAS	Gaceta N 3 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-3.pdf
4	GACETAS	Gaceta N 4 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-4.pdf
5	GACETAS	Gaceta N 5 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-5.pdf
\.


--
-- Data for Name: entities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entities (id, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", code) FROM stdin;
1	SERVICIO AUTONOMO DE REGISTROS Y NOTARIAS	2024-11-07 14:49:53.595993	2024-11-07 14:49:53.595993	\N	1	1	1	\N	1
2	PROCURADURIA DEL ESTADO CARABOBO	2024-11-07 14:49:53.595993	2024-11-07 14:49:53.595993	\N	1	1	1	\N	2
3	SENIAT	2024-11-07 14:49:53.595993	2024-11-07 14:49:53.595993	\N	1	1	1	\N	3
4	GOBIERNO DE CARABOBO	2024-11-07 14:49:53.595993	2024-11-07 14:49:53.595993	\N	1	1	1	\N	4
\.


--
-- Data for Name: external_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.external_request (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "typeExternalRequestId", request_url, request_json, response_json, "transactionId") FROM stdin;
3	2024110900000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-09 21:08:21.256083	2024-11-09 21:08:21.256083	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024110900000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14416.610529000001,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		5
4	2024111000000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-10 16:52:03.384875	2024-11-10 16:52:03.384875	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111000000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14416.610529,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		6
5	2024111000000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-10 16:52:57.94058	2024-11-10 16:52:57.94058	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111000000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14416.610529000001,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		7
6	2024111300000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-13 21:29:07.102847	2024-11-13 21:29:07.102847	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.386688999999,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		8
7	2024111300000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-13 21:36:48.268001	2024-11-13 21:36:48.268001	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.386688999999,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		9
8	2024111300000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-13 21:37:14.725646	2024-11-13 21:37:14.725646	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.386688999999,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		10
9	2024111300000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-13 21:38:13.764262	2024-11-13 21:38:13.764262	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.386688999999,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		11
10	2024111300000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-13 21:39:00.705219	2024-11-13 21:39:00.705219	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.386688999999,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		12
11	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 22:45:41.59487	2024-11-13 22:45:41.59487	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":0,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
12	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 22:50:53.048153	2024-11-13 22:50:53.048153	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282.386688999999","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
13	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 22:52:37.325502	2024-11-13 22:52:37.325502	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282.386688999999","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
14	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 22:57:42.737023	2024-11-13 22:57:42.737023	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282.386688999999","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
15	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 22:58:04.796961	2024-11-13 22:58:04.796961	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282.386688999999","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
16	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 22:59:13.402923	2024-11-13 22:59:13.402923	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282.386688999999","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
17	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 22:59:46.813374	2024-11-13 22:59:46.813374	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"1.00","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
18	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:00:44.050955	2024-11-13 23:00:44.050955	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"1.00","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
19	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:02:27.216194	2024-11-13 23:02:27.216194	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"1.00","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
20	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:03:49.288722	2024-11-13 23:03:49.288722	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"1.00","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
21	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:05:22.213194	2024-11-13 23:05:22.213194	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
22	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:08:46.361911	2024-11-13 23:08:46.361911	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282.39","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
23	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:10:12.179405	2024-11-13 23:10:12.179405	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282.39","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
24	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:10:23.143747	2024-11-13 23:10:23.143747	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282,39","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
25	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:10:36.137953	2024-11-13 23:10:36.137953	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
26	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:11:54.705323	2024-11-13 23:11:54.705323	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282.39","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
27	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:12:31.57865	2024-11-13 23:12:31.57865	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":"14282.39","sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
28	2024111300000001	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:14:45.672445	2024-11-13 23:14:45.672445	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000001","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
29	2024111300000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:15:28.91684	2024-11-13 23:15:28.91684	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
30	2024111300000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:43:42.17112	2024-11-13 23:43:42.17112	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
31	2024111300000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:52:23.561433	2024-11-13 23:52:23.561433	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
32	2024111300000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-13 23:55:01.229213	2024-11-13 23:55:01.229213	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111300000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
33	2024111400000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 00:01:08.286133	2024-11-14 00:01:08.286133	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
34	2024111400000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 00:01:33.944477	2024-11-14 00:01:33.944477	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
35	2024111400000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 00:01:51.790013	2024-11-14 00:01:51.790013	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
36	2024111400000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 00:02:49.516368	2024-11-14 00:02:49.516368	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14282.39,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		12
37	2024111400000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-14 21:25:37.216143	2024-11-14 21:25:37.216143	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.532356,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		13
38	2024111400000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:26:51.505187	2024-11-14 21:26:51.505187	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
39	20241114undefined	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:41:36.061306	2024-11-14 21:41:36.061306	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"20241114undefined","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
40	2024111400000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:43:27.217177	2024-11-14 21:43:27.217177	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
41	2024111400000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:43:56.252638	2024-11-14 21:43:56.252638	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
42	2024111400000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:44:45.335891	2024-11-14 21:44:45.335891	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
43	2024111400000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:45:52.390369	2024-11-14 21:45:52.390369	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111400000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
44	202411148	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:46:26.757214	2024-11-14 21:46:26.757214	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"202411148","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
45	202411149	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:46:29.999027	2024-11-14 21:46:29.999027	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"202411149","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
46	2024111410	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:46:32.167034	2024-11-14 21:46:32.167034	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111410","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
47	2024111411	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:46:33.850987	2024-11-14 21:46:33.850987	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111411","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
48	2024111412	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-14 21:46:35.545965	2024-11-14 21:46:35.545965	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111412","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14421.53,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		13
49	2024111600000001	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:07:44.795947	2024-11-16 17:07:44.795947	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000001","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097227999999,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		14
50	2024111600000002	External Request - Cobro DBI (Método de pago: Teléfono)	2024-11-16 17:08:46.412424	2024-11-16 17:08:46.412424	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000002","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.1,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		14
51	2024111600000003	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:10:32.38478	2024-11-16 17:10:32.38478	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000003","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":0,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		15
52	2024111600000004	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:22:31.971687	2024-11-16 17:22:31.971687	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000004","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":0,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		16
53	2024111600000005	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:23:42.890792	2024-11-16 17:23:42.890792	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000005","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":0,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		17
54	2024111600000006	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:27:48.966859	2024-11-16 17:27:48.966859	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000006","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		18
55	2024111600000007	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:36:07.354515	2024-11-16 17:36:07.354515	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000007","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		19
56	2024111600000008	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:37:05.867995	2024-11-16 17:37:05.867995	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000008","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		20
57	2024111600000009	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:37:45.262678	2024-11-16 17:37:45.262678	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000009","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		21
58	2024111600000010	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:38:11.512725	2024-11-16 17:38:11.512725	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000010","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		22
59	2024111600000011	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:39:16.844663	2024-11-16 17:39:16.844663	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000011","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		23
60	2024111600000012	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:42:37.376599	2024-11-16 17:42:37.376599	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000012","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		24
61	2024111600000013	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:46:25.772675	2024-11-16 17:46:25.772675	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000013","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		25
62	2024111600000014	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:47:48.47779	2024-11-16 17:47:48.47779	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000014","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		26
63	2024111600000015	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:49:08.216196	2024-11-16 17:49:08.216196	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000015","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		27
64	2024111600000016	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:54:06.703393	2024-11-16 17:54:06.703393	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000016","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		28
65	2024111600000017	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:55:04.967906	2024-11-16 17:55:04.967906	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000017","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		29
66	2024111600000018	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:56:21.553717	2024-11-16 17:56:21.553717	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000018","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		30
67	2024111600000019	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 17:59:28.964282	2024-11-16 17:59:28.964282	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000019","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		31
68	2024111600000020	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 18:01:46.361202	2024-11-16 18:01:46.361202	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000020","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		32
69	2024111600000021	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 18:05:35.150272	2024-11-16 18:05:35.150272	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000021","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		33
70	2024111600000022	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 18:06:32.503106	2024-11-16 18:06:32.503106	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000022","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		34
71	2024111600000023	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 18:07:47.712307	2024-11-16 18:07:47.712307	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000023","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		35
72	2024111600000024	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-16 18:08:22.680301	2024-11-16 18:08:23.659834	\N	8	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111600000024","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}	{"sMerchantId":"341433","sTrxType":"502","sTrxId":"2024111600000024","sReferenceNo":"000000000000","sAuthCode":"000000","sRespCode":"ACCP","sRespDesc":"Solicitud Aprobada","sTerminalId":"userc2p"}	36
73	2024111700000025	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-11-17 14:39:15.309239	2024-11-17 14:39:22.298388	\N	8	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024111700000025","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":14477.097228,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}	{"sMerchantId":"341433","sTrxType":"502","sTrxId":"2024111700000025","sReferenceNo":"000000000000","sAuthCode":"000000","sRespCode":"ACCP","sRespDesc":"Solicitud Aprobada","sTerminalId":"userc2p"}	37
\.


--
-- Data for Name: locker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locker (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "branchId") FROM stdin;
\.


--
-- Data for Name: lockers_point_of_sale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lockers_point_of_sale (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "lockerId", "pointOfSaleId") FROM stdin;
\.


--
-- Data for Name: municipalities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.municipalities (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "stateId") FROM stdin;
1	1	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
2	2	ANACO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
3	3	ARAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
4	4	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
5	5	BRUZUAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
6	6	CAJIGAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
7	7	FREITES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
8	8	INDEPENDENCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
9	9	LIBERTAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
10	10	MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
11	11	MONAGAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
12	12	PEÑALVER	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
13	13	SIMON RODRIGUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
14	14	SOTILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
15	15	GUANIPA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
16	16	GUANTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
17	17	PIRITU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
18	18	M.L/DIEGO BAUTISTA U	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
19	19	CARVAJAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
20	20	SANTA ANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
21	21	MC GREGOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
22	22	S JUAN CAPISTRANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
23	23	ACHAGUAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	3
24	24	MUÑOZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	3
25	25	PAEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	3
26	26	PEDRO CAMEJO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	3
27	27	ROMULO GALLEGOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	3
28	28	SAN FERNANDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	3
29	29	BIRUACA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	3
30	30	GIRARDOT	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
31	31	SANTIAGO MARIÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
32	32	JOSE FELIX RIVAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
33	33	SAN CASIMIRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
34	34	SAN SEBASTIAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
35	35	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
36	36	URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
37	37	ZAMORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
38	38	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
39	39	JOSE ANGEL LAMAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
40	40	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
41	41	SANTOS MICHELENA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
42	42	MARIO B IRAGORRY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
43	43	TOVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
44	44	CAMATAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
45	45	JOSE R REVENGA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
46	46	FRANCISCO LINARES A.	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
47	47	M.OCUMARE D LA COSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
48	48	ARISMENDI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
49	49	BARINAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
50	50	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
51	51	EZEQUIEL ZAMORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
52	52	OBISPOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
53	53	PEDRAZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
54	54	ROJAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
55	55	SOSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
56	56	ALBERTO ARVELO T	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
57	57	A JOSE DE SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
58	58	CRUZ PAREDES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
59	59	ANDRES E. BLANCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
60	60	CARONI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
61	61	CEDEÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
62	62	HERES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
63	63	PIAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
64	64	ROSCIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
65	65	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
66	66	SIFONTES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
67	67	RAUL LEONI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
68	68	GRAN SABANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
69	69	EL CALLAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
70	70	PADRE PEDRO CHIEN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
71	71	BEJUMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
72	72	CARLOS ARVELO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
73	73	DIEGO IBARRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
74	74	GUACARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
75	75	MONTALBAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
76	76	JUAN JOSE MORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
77	77	PUERTO CABELLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
78	78	SAN JOAQUIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
79	79	VALENCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
80	80	MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
81	81	LOS GUAYOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
82	82	NAGUANAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
83	83	SAN DIEGO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
84	84	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
85	85	ANZOATEGUI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
86	86	FALCON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
87	87	GIRARDOT	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
88	88	MP PAO SN J BAUTISTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
89	89	RICAURTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
90	90	SAN CARLOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
91	91	TINACO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
92	92	LIMA BLANCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
93	93	ROMULO GALLEGOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
94	94	ACOSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
95	95	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
96	96	BUCHIVACOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
97	97	CARIRUBANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
98	98	COLINA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
99	99	DEMOCRACIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
100	100	FALCON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
101	101	FEDERACION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
102	102	MAUROA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
103	103	MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
104	104	PETIT	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
105	105	SILVA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
106	106	ZAMORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
107	107	DABAJURO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
108	108	MONS. ITURRIZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
109	109	LOS TAQUES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
110	110	PIRITU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
111	111	UNION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
112	112	SAN FRANCISCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
113	113	JACURA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
114	114	CACIQUE MANAURE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
115	115	PALMA SOLA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
116	116	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
117	117	URUMACO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
118	118	TOCOPERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
119	119	INFANTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
120	120	MELLADO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
121	121	MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
122	122	MONAGAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
123	123	RIBAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
124	124	ROSCIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
125	125	ZARAZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
126	126	CAMAGUAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
127	127	S JOSE DE GUARIBE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
128	128	LAS MERCEDES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
129	129	EL SOCORRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
130	130	ORTIZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
131	131	S MARIA DE IPIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
132	132	CHAGUARAMAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
133	133	SAN GERONIMO DE G	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
134	134	CRESPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
135	135	IRIBARREN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
136	136	JIMENEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
137	137	MORAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
138	138	PALAVECINO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
139	139	TORRES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
140	140	URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
141	141	ANDRES E BLANCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
142	142	SIMON PLANAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
143	143	ALBERTO ADRIANI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
144	144	ANDRES BELLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
145	145	ARZOBISPO CHACON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
146	146	CAMPO ELIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
147	147	GUARAQUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
148	148	JULIO CESAR SALAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
149	149	JUSTO BRICEÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
150	150	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
151	151	SANTOS MARQUINA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
152	152	MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
153	153	ANTONIO PINTO S.	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
154	154	OB. RAMOS DE LORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
155	155	CARACCIOLO PARRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
156	156	CARDENAL QUINTERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
157	157	PUEBLO LLANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
158	158	RANGEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
159	159	RIVAS DAVILA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
160	160	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
161	161	TOVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
162	162	TULIO F CORDERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
163	163	PADRE NOGUERA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
164	164	ARICAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
165	165	ZEA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
166	166	ACEVEDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
167	167	BRION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
168	168	GUAICAIPURO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
169	169	INDEPENDENCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
170	170	LANDER	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
171	171	PAEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
172	172	PAZ CASTILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
173	173	PLAZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
174	174	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
175	175	URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
176	176	ZAMORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
177	177	CRISTOBAL ROJAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
178	178	LOS SALIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
179	179	ANDRES BELLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
180	180	SIMON BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
181	181	BARUTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
182	182	CARRIZAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
183	183	CHACAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
184	184	EL HATILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
185	185	BUROZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
186	186	PEDRO GUAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
187	187	ACOSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
188	188	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
189	189	CARIPE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
190	190	CEDEÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
191	191	EZEQUIEL ZAMORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
192	192	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
193	193	MATURIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
194	194	PIAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
195	195	PUNCERES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
196	196	SOTILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
197	197	AGUASAY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
198	198	SANTA BARBARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
199	199	URACOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
200	200	ARISMENDI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
201	201	DIAZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
202	202	GOMEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
203	203	MANEIRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
204	204	MARCANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
205	205	MARIÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
206	206	PENIN. DE MACANAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
207	207	VILLALBA(I.COCHE)	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
208	208	TUBORES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
209	209	ANTOLIN DEL CAMPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
210	210	GARCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
211	211	ARAURE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
212	212	ESTELLER	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
213	213	GUANARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
214	214	GUANARITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
215	215	OSPINO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
216	216	PAEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
217	217	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
218	218	TUREN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
219	219	M.JOSE V DE UNDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
220	220	AGUA BLANCA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
221	221	PAPELON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
222	222	GENARO BOCONOITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
223	223	S RAFAEL DE ONOTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
224	224	SANTA ROSALIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
225	225	ARISMENDI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
226	226	BENITEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
227	227	BERMUDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
228	228	CAJIGAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
229	229	MARIÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
230	230	MEJIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
231	231	MONTES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
232	232	RIBERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
233	233	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
234	234	VALDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
235	235	ANDRES E BLANCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
236	236	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
237	237	ANDRES MATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
238	238	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
239	239	CRUZ S ACOSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
240	240	AYACUCHO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
241	241	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
242	242	INDEPENDENCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
243	243	CARDENAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
244	244	JAUREGUI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
245	245	JUNIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
246	246	LOBATERA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
247	247	SAN CRISTOBAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
248	248	URIBANTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
249	249	CORDOBA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
250	250	GARCIA DE HEVIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
251	251	GUASIMOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
252	252	MICHELENA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
253	253	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
254	254	PANAMERICANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
255	255	PEDRO MARIA UREÑA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
256	256	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
257	257	ANDRES BELLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
258	258	FERNANDEZ FEO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
259	259	LIBERTAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
260	260	SAMUEL MALDONADO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
261	261	SEBORUCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
262	262	ANTONIO ROMULO C	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
263	263	FCO DE MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
264	264	JOSE MARIA VARGA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
265	265	RAFAEL URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
266	266	SIMON RODRIGUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
267	267	TORBES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
268	268	SAN JUDAS TADEO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
269	269	RAFAEL RANGEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
270	270	BOCONO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
271	271	CARACHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
272	272	ESCUQUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
273	273	TRUJILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
274	274	URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
275	275	VALERA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
276	276	CANDELARIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
277	277	MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
278	278	MONTE CARMELO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
279	279	MOTATAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
280	280	PAMPAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
281	281	S RAFAEL CARVAJAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
282	282	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
283	283	ANDRES BELLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
284	284	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
285	285	JOSE F M CAÑIZAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
286	286	JUAN V CAMPO ELI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
287	287	LA CEIBA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
288	288	PAMPANITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
289	289	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
290	290	BRUZUAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
291	291	NIRGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
292	292	SAN FELIPE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
293	293	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
294	294	URACHICHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
295	295	PEÑA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
296	296	JOSE ANTONIO PAEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
297	297	LA TRINIDAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
298	298	COCOROTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
299	299	INDEPENDENCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
300	300	ARISTIDES BASTID	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
301	301	MANUEL MONGE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
302	302	VEROES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
303	303	BARALT	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
304	304	SANTA RITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
305	305	COLON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
306	306	MARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
307	307	MARACAIBO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
308	308	MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
309	309	PAEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
310	310	MACHIQUES DE P	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
311	311	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
312	312	LA CAÑADA DE U.	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
313	313	LAGUNILLAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
314	314	CATATUMBO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
315	315	M/ROSARIO DE PERIJA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
316	316	CABIMAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
317	317	VALMORE RODRIGUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
318	318	JESUS E LOSSADA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
319	319	ALMIRANTE P	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
320	320	SAN FRANCISCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
321	321	JESUS M SEMPRUN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
322	322	FRANCISCO J PULG	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
323	323	SIMON BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
324	324	ATURES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	22
325	325	ATABAPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	22
326	326	MAROA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	22
327	327	RIO NEGRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	22
328	328	AUTANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	22
329	329	MANAPIARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	22
330	330	ALTO ORINOCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	22
331	331	TUCUPITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
332	332	PEDERNALES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
333	333	ANTONIO DIAZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
334	334	CASACOIMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
335	335	VARGAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	24
\.


--
-- Data for Name: parishes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parishes (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "municipalityId") FROM stdin;
268	268	GOAIGOAZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	77
1058	1058	MARIANO PARRA LEON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	318
1059	1059	MONAGAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	319
1060	1060	ISLA DE TOAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	319
1061	1061	MARCIAL HERNANDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	320
1062	1062	FRANCISCO OCHOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	320
1063	1063	SAN FRANCISCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	320
1064	1064	EL BAJO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	320
1065	1065	DOMITILA FLORES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	320
1066	1066	LOS CORTIJOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	320
1067	1067	BARI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	321
1	1	ALTAGRACIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
2	2	CANDELARIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
3	3	CATEDRAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
4	4	LA PASTORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
5	5	SAN AGUSTIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
6	6	SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
7	7	SAN JUAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
8	8	SANTA ROSALIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
9	9	SANTA TERESA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
10	10	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
11	11	23 DE ENERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
12	12	ANTIMANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
13	13	EL RECREO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
14	14	EL VALLE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
15	15	LA VEGA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
16	16	MACARAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
17	17	CARICUAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
18	18	EL JUNQUITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
19	19	COCHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
20	20	SAN PEDRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
21	21	SAN BERNARDINO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
22	22	EL PARAISO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	1
23	23	ANACO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
24	24	SAN JOAQUIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	2
25	25	CM. ARAGUA DE BARCELONA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	3
26	26	CACHIPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	3
27	27	EL CARMEN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
28	28	SAN CRISTOBAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
29	29	BERGANTIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
30	30	CAIGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
31	31	EL PILAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
32	32	NARICUAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	4
33	33	CM. CLARINES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
34	34	GUANAPE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
35	35	SABANA DE UCHIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	5
36	36	CM. ONOTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
37	37	SAN PABLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	6
38	38	CM. CANTAURA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
39	39	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
40	40	SANTA ROSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
41	41	URICA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	7
42	42	CM. SOLEDAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
43	43	MAMO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	8
44	44	CM. SAN MATEO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
45	45	EL CARITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
46	46	SANTA INES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	9
47	47	CM. PARIAGUAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
48	48	ATAPIRIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
49	49	BOCA DEL PAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
50	50	EL PAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	10
51	51	CM. MAPIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
52	52	PIAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
53	53	SN DIEGO DE CABRUTICA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
54	54	SANTA CLARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
55	55	UVERITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
56	56	ZUATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	11
57	57	CM. PUERTO PIRITU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
58	58	SAN MIGUEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
59	59	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	12
60	60	CM. EL TIGRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	13
61	61	POZUELOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
62	62	CM PTO. LA CRUZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	14
63	63	CM. SAN JOSE DE GUANIPA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	15
64	64	GUANTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
65	65	CHORRERON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	16
66	66	PIRITU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
67	67	SAN FRANCISCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	17
68	68	LECHERIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
69	69	EL MORRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	18
70	70	VALLE GUANAPE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
71	71	SANTA BARBARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	19
72	72	SANTA ANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
73	73	PUEBLO NUEVO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	20
74	74	EL CHAPARRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
75	75	TOMAS ALFARO CALATRAVA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	21
76	76	BOCA UCHIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	22
77	77	BOCA DE CHAVEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	22
78	78	ACHAGUAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
79	79	APURITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
80	80	EL YAGUAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
81	81	GUACHARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
82	82	MUCURITAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
83	83	QUESERAS DEL MEDIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	23
84	84	BRUZUAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	24
85	85	MANTECAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	24
86	86	QUINTERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	24
87	87	SAN VICENTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	24
88	88	RINCON HONDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	24
89	89	GUASDUALITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	25
90	90	ARAMENDI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	25
91	91	EL AMPARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	25
92	92	SAN CAMILO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	25
93	93	URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	25
94	94	SAN JUAN DE PAYARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	26
95	95	CODAZZI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	26
96	96	CUNAVICHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	26
97	97	ELORZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	27
98	98	LA TRINIDAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	27
99	99	SAN FERNANDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	28
100	100	PEÑALVER	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	28
101	101	EL RECREO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	28
102	102	SN RAFAEL DE ATAMAICA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	28
103	103	BIRUACA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	29
104	104	CM. LAS DELICIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	30
105	105	CHORONI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	30
106	106	MADRE MA DE SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	30
107	107	JOAQUIN CRESPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	30
108	108	PEDRO JOSE OVALLES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	30
109	109	JOSE CASANOVA GODOY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	30
110	110	ANDRES ELOY BLANCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	30
111	111	LOS TACARIGUAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	30
112	112	CM. TURMERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	31
113	113	SAMAN DE GUERE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	31
114	114	ALFREDO PACHECO M	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	31
115	115	CHUAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	31
116	116	AREVALO APONTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	31
117	117	CM. LA VICTORIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	32
118	118	ZUATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	32
119	119	PAO DE ZARATE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	32
120	120	CASTOR NIEVES RIOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	32
121	121	LAS GUACAMAYAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	32
122	122	CM. SAN CASIMIRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	33
123	123	VALLE MORIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	33
124	124	GUIRIPA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	33
125	125	OLLAS DE CARAMACATE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	33
126	126	CM. SAN SEBASTIAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	34
127	127	CM. CAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	35
128	128	BELLA VISTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	35
129	129	CM. BARBACOAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	36
130	130	SAN FRANCISCO DE CARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	36
131	131	TAGUAY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	36
132	132	LAS PEÑITAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	36
133	133	CM. VILLA DE CURA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	37
134	134	MAGDALENO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	37
135	135	SAN FRANCISCO DE ASIS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	37
136	136	VALLES DE TUCUTUNEMO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	37
137	137	PQ AUGUSTO MIJARES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	37
138	138	CM. PALO NEGRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	38
139	139	SAN MARTIN DE PORRES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	38
140	140	CM. SANTA CRUZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	39
141	141	CM. SAN MATEO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	40
142	142	CM. LAS TEJERIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	41
143	143	TIARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	41
144	144	CM. EL LIMON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	42
145	145	CA A DE AZUCAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	42
146	146	CM. COLONIA TOVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	43
147	147	CM. CAMATAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	44
148	148	CARMEN DE CURA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	44
149	149	CM. EL CONSEJO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	45
150	150	CM. SANTA RITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	46
151	151	FRANCISCO DE MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	46
152	152	MONS FELICIANO G	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	46
153	153	OCUMARE DE LA COSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	47
154	154	ARISMENDI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	48
155	155	GUADARRAMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	48
156	156	LA UNION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	48
157	157	SAN ANTONIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	48
158	158	ALFREDO A LARRIVA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
159	159	BARINAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
160	160	SAN SILVESTRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
161	161	SANTA INES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
162	162	SANTA LUCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
163	163	TORUNOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
164	164	EL CARMEN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
165	165	ROMULO BETANCOURT	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
166	166	CORAZON DE JESUS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
167	167	RAMON I MENDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
168	168	ALTO BARINAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
169	169	MANUEL P FAJARDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
170	170	JUAN A RODRIGUEZ D	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
171	171	DOMINGA ORTIZ P	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	49
172	172	ALTAMIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	50
173	173	BARINITAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	50
174	174	CALDERAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	50
175	175	SANTA BARBARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	51
176	176	JOSE IGNACIO DEL PUMAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	51
177	177	RAMON IGNACIO MENDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	51
178	178	PEDRO BRICEÑO MENDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	51
179	179	EL REAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	52
180	180	LA LUZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	52
181	181	OBISPOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	52
182	182	LOS GUASIMITOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	52
183	183	CIUDAD BOLIVIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	53
184	184	IGNACIO BRICEÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	53
185	185	PAEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	53
186	186	JOSE FELIX RIBAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	53
187	187	DOLORES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	54
188	188	LIBERTAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	54
189	189	PALACIO FAJARDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	54
190	190	SANTA ROSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	54
191	191	CIUDAD DE NUTRIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	55
192	192	EL REGALO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	55
193	193	PUERTO DE NUTRIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	55
194	194	SANTA CATALINA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	55
195	195	RODRIGUEZ DOMINGUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	56
196	196	SABANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	56
197	197	TICOPORO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	57
198	198	NICOLAS PULIDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	57
199	199	ANDRES BELLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	57
200	200	BARRANCAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	58
201	201	EL SOCORRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	58
202	202	MASPARRITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	58
203	203	EL CANTON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	59
204	204	SANTA CRUZ DE GUACAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	59
205	205	PUERTO VIVAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	59
206	206	SIMON BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
207	207	ONCE DE ABRIL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
208	208	VISTA AL SOL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
209	209	CHIRICA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
210	210	DALLA COSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
211	211	CACHAMAY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
212	212	UNIVERSIDAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
213	213	UNARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
214	214	YOCOIMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
215	215	POZO VERDE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	60
216	216	CM. CAICARA DEL ORINOCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	61
217	217	ASCENSION FARRERAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	61
218	218	ALTAGRACIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	61
219	219	LA URBANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	61
220	220	GUANIAMO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	61
221	221	PIJIGUAOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	61
222	222	CATEDRAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	62
223	223	AGUA SALADA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	62
224	224	LA SABANITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	62
225	225	VISTA HERMOSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	62
226	226	MARHUANTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	62
227	227	JOSE ANTONIO PAEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	62
228	228	ORINOCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	62
229	229	PANAPANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	62
230	230	ZEA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	62
231	231	CM. UPATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	63
232	232	ANDRES ELOY BLANCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	63
233	233	PEDRO COVA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	63
234	234	CM. GUASIPATI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	64
235	235	SALOM	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	64
236	236	CM. MARIPA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	65
237	237	ARIPAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	65
238	238	LAS MAJADAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	65
239	239	MOITACO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	65
240	240	GUARATARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	65
241	241	CM. TUMEREMO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	66
242	242	DALLA COSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	66
243	243	SAN ISIDRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	66
244	244	CM. CIUDAD PIAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	67
245	245	SAN FRANCISCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	67
246	246	BARCELONETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	67
247	247	SANTA BARBARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	67
248	248	CM. SANTA ELENA DE UAIREN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	68
249	249	IKABARU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	68
250	250	CM. EL CALLAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	69
251	251	CM. EL PALMAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	70
252	252	BEJUMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	71
253	253	CANOABO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	71
254	254	SIMON BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	71
255	255	GUIGUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	72
256	256	BELEN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	72
257	257	TACARIGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	72
258	258	MARIARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	73
259	259	AGUAS CALIENTES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	73
260	260	GUACARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	74
261	261	CIUDAD ALIANZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	74
262	262	YAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	74
263	263	MONTALBAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	75
264	264	MORON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	76
265	265	URAMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	76
266	266	DEMOCRACIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	77
267	267	FRATERNIDAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	77
269	269	JUAN JOSE FLORES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	77
270	270	BARTOLOME SALOM	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	77
271	271	UNION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	77
272	272	BORBURATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	77
273	273	PATANEMO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	77
274	274	SAN JOAQUIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	78
275	275	CANDELARIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	79
276	276	CATEDRAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	79
277	277	EL SOCORRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	79
278	278	MIGUEL PEÑA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	79
279	279	SAN BLAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	79
280	280	SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	79
281	281	SANTA ROSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	79
282	282	RAFAEL URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	79
283	283	NEGRO PRIMERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	79
284	284	MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	80
285	285	U LOS GUAYOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	81
286	286	NAGUANAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	82
287	287	URB SAN DIEGO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	83
288	288	U TOCUYITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	84
289	289	U INDEPENDENCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	84
290	290	COJEDES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	85
291	291	JUAN DE MATA SUAREZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	85
292	292	TINAQUILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	86
293	293	EL BAUL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	87
294	294	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	87
295	295	EL PAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	88
296	296	LIBERTAD DE COJEDES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	89
297	297	EL AMPARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	89
298	298	SAN CARLOS DE AUSTRIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	90
299	299	JUAN ANGEL BRAVO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	90
300	300	MANUEL MANRIQUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	90
301	301	GRL/JEFE JOSE L SILVA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	91
302	302	MACAPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	92
303	303	LA AGUADITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	92
304	304	ROMULO GALLEGOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	93
305	305	SAN JUAN DE LOS CAYOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	94
306	306	CAPADARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	94
307	307	LA PASTORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	94
308	308	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	94
309	309	SAN LUIS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	95
310	310	ARACUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	95
311	311	LA PEÑA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	95
312	312	CAPATARIDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	96
313	313	BOROJO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	96
314	314	SEQUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	96
315	315	ZAZARIDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	96
316	316	BARIRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	96
317	317	GUAJIRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	96
318	318	NORTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	97
319	319	CARIRUBANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	97
320	320	PUNTA CARDON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	97
321	321	SANTA ANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	97
322	322	LA VELA DE CORO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	98
323	323	ACURIGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	98
324	324	GUAIBACOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	98
325	325	MACORUCA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	98
326	326	LAS CALDERAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	98
327	327	PEDREGAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	99
328	328	AGUA CLARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	99
329	329	AVARIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	99
330	330	PIEDRA GRANDE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	99
331	331	PURURECHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	99
332	332	PUEBLO NUEVO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	100
333	333	ADICORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	100
334	334	BARAIVED	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	100
335	335	BUENA VISTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	100
336	336	JADACAQUIVA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	100
337	337	MORUY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	100
338	338	EL VINCULO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	100
339	339	EL HATO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	100
340	340	ADAURE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	100
341	341	CHURUGUARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	101
342	342	AGUA LARGA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	101
343	343	INDEPENDENCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	101
344	344	MAPARARI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	101
345	345	EL PAUJI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	101
346	346	MENE DE MAUROA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	102
347	347	CASIGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	102
348	348	SAN FELIX	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	102
349	349	SAN ANTONIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	103
350	350	SAN GABRIEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	103
351	351	SANTA ANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	103
352	352	GUZMAN GUILLERMO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	103
353	353	MITARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	103
354	354	SABANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	103
355	355	RIO SECO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	103
356	356	CABURE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	104
357	357	CURIMAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	104
358	358	COLINA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	104
359	359	TUCACAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	105
360	360	BOCA DE AROA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	105
361	361	PUERTO CUMAREBO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	106
362	362	LA CIENAGA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	106
363	363	LA SOLEDAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	106
364	364	PUEBLO CUMAREBO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	106
365	365	ZAZARIDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	106
366	366	CM. DABAJURO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	107
367	367	CHICHIRIVICHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	108
368	368	BOCA DE TOCUYO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	108
369	369	TOCUYO DE LA COSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	108
370	370	LOS TAQUES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	109
371	371	JUDIBANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	109
372	372	PIRITU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	110
373	373	SAN JOSE DE LA COSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	110
374	374	STA.CRUZ DE BUCARAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	111
375	375	EL CHARAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	111
376	376	LAS VEGAS DEL TUY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	111
377	377	CM. MIRIMIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	112
378	378	JACURA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	113
379	379	AGUA LINDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	113
380	380	ARAURIMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	113
381	381	CM. YARACAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	114
382	382	CM. PALMA SOLA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	115
383	383	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	116
384	384	PECAYA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	116
385	385	URUMACO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	117
386	386	BRUZUAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	117
387	387	CM. TOCOPERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	118
388	388	VALLE DE LA PASCUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	119
389	389	ESPINO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	119
390	390	EL SOMBRERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	120
391	391	SOSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	120
392	392	CALABOZO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	121
393	393	EL CALVARIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	121
394	394	EL RASTRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	121
395	395	GUARDATINAJAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	121
396	396	ALTAGRACIA DE ORITUCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	122
397	397	LEZAMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	122
398	398	LIBERTAD DE ORITUCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	122
399	399	SAN FCO DE MACAIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	122
400	400	SAN RAFAEL DE ORITUCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	122
401	401	SOUBLETTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	122
402	402	PASO REAL DE MACAIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	122
403	403	TUCUPIDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	123
404	404	SAN RAFAEL DE LAYA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	123
405	405	SAN JUAN DE LOS MORROS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	124
406	406	PARAPARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	124
407	407	CANTAGALLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	124
408	408	ZARAZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	125
409	409	SAN JOSE DE UNARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	125
410	410	CAMAGUAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	126
411	411	PUERTO MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	126
412	412	UVERITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	126
413	413	SAN JOSE DE GUARIBE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	127
414	414	LAS MERCEDES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	128
415	415	STA RITA DE MANAPIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	128
416	416	CABRUTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	128
417	417	EL SOCORRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	129
418	418	ORTIZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	130
419	419	SAN FCO. DE TIZNADOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	130
420	420	SAN JOSE DE TIZNADOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	130
421	421	S LORENZO DE TIZNADOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	130
422	422	SANTA MARIA DE IPIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	131
423	423	ALTAMIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	131
424	424	CHAGUARAMAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	132
425	425	GUAYABAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	133
426	426	CAZORLA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	133
427	427	FREITEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	134
428	428	JOSE MARIA BLANCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	134
429	429	CATEDRAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
430	430	LA CONCEPCION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
431	431	SANTA ROSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
432	432	UNION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
433	433	EL CUJI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
434	434	TAMACA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
435	435	JUAN DE VILLEGAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
436	436	AGUEDO F. ALVARADO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
437	437	BUENA VISTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
438	438	JUAREZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	135
439	439	JUAN B RODRIGUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	136
440	440	DIEGO DE LOZADA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	136
441	441	SAN MIGUEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	136
442	442	CUARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	136
443	443	PARAISO DE SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	136
444	444	TINTORERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	136
445	445	JOSE BERNARDO DORANTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	136
446	446	CRNEL. MARIANO PERAZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	136
447	447	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	137
448	448	ANZOATEGUI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	137
449	449	GUARICO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	137
450	450	HUMOCARO ALTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	137
451	451	HUMOCARO BAJO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	137
452	452	MORAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	137
453	453	HILARIO LUNA Y LUNA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	137
454	454	LA CANDELARIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	137
455	455	CABUDARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	138
456	456	JOSE G. BASTIDAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	138
457	457	AGUA VIVA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	138
458	458	TRINIDAD SAMUEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
459	459	ANTONIO DIAZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
460	460	CAMACARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
461	461	CASTAÑEDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
462	462	CHIQUINQUIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
463	463	ESPINOZA LOS MONTEROS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
464	464	LARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
465	465	MANUEL MORILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
466	466	MONTES DE OCA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
467	467	TORRES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
468	468	EL BLANCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
469	469	MONTA A VERDE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
470	470	HERIBERTO ARROYO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
471	471	LAS MERCEDES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
472	472	CECILIO ZUBILLAGA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
473	473	REYES VARGAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
474	474	ALTAGRACIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	139
475	475	SIQUISIQUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	140
476	476	SAN MIGUEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	140
477	477	XAGUAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	140
478	478	MOROTURO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	140
479	479	PIO TAMAYO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	141
480	480	YACAMBU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	141
481	481	QBDA. HONDA DE GUACHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	141
482	482	SARARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	142
483	483	GUSTAVO VEGAS LEON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	142
484	484	BURIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	142
485	485	GABRIEL PICON G.	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	143
486	486	HECTOR AMABLE MORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	143
487	487	JOSE NUCETE SARDI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	143
488	488	PULIDO MENDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	143
489	489	PTE. ROMULO GALLEGOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	143
490	490	PRESIDENTE BETANCOURT	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	143
491	491	PRESIDENTE PAEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	143
492	492	CM. LA AZULITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	144
493	493	CM. CANAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	145
494	494	CAPURI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	145
495	495	CHACANTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	145
496	496	EL MOLINO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	145
497	497	GUAIMARAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	145
498	498	MUCUTUY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	145
499	499	MUCUCHACHI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	145
500	500	ACEQUIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	146
501	501	JAJI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	146
502	502	LA MESA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	146
503	503	SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	146
504	504	MONTALBAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	146
505	505	MATRIZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	146
506	506	FERNANDEZ PEÑA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	146
507	507	CM. GUARAQUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	147
508	508	MESA DE QUINTERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	147
509	509	RIO NEGRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	147
510	510	CM. ARAPUEY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	148
511	511	PALMIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	148
512	512	CM. TORONDOY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	149
513	513	SAN CRISTOBAL DE T	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	149
514	514	ARIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
515	515	SAGRARIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
516	516	MILLA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
517	517	EL LLANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
518	518	JUAN RODRIGUEZ SUAREZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
519	519	JACINTO PLAZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
520	520	DOMINGO PEÑA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
521	521	GONZALO PICON FEBRES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
522	522	OSUNA RODRIGUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
523	523	LASSO DE LA VEGA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
524	524	CARACCIOLO PARRA P	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
525	525	MARIANO PICON SALAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
526	526	ANTONIO SPINETTI DINI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
527	527	EL MORRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
528	528	LOS NEVADOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	150
529	529	CM. TABAY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	151
530	530	CM. TIMOTES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	152
531	531	ANDRES ELOY BLANCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	152
532	532	PIÑANGO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	152
533	533	LA VENTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	152
534	534	CM. STA CRUZ DE MORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	153
535	535	MESA BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	153
536	536	MESA DE LAS PALMAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	153
537	537	CM. STA ELENA DE ARENALES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	154
538	538	ELOY PAREDES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	154
539	539	PQ R DE ALCAZAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	154
540	540	CM. TUCANI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	155
541	541	FLORENCIO RAMIREZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	155
542	542	CM. SANTO DOMINGO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	156
543	543	LAS PIEDRAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	156
544	544	CM. PUEBLO LLANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	157
545	545	CM. MUCUCHIES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	158
546	546	MUCURUBA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	158
547	547	SAN RAFAEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	158
548	548	CACUTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	158
549	549	LA TOMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	158
550	550	CM. BAILADORES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	159
551	551	GERONIMO MALDONADO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	159
552	552	CM. LAGUNILLAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	160
553	553	CHIGUARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	160
554	554	ESTANQUES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	160
555	555	SAN JUAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	160
556	556	PUEBLO NUEVO DEL SUR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	160
557	557	LA TRAMPA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	160
558	558	EL LLANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	161
559	559	TOVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	161
560	560	EL AMPARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	161
561	561	SAN FRANCISCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	161
562	562	CM. NUEVA BOLIVIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	162
563	563	INDEPENDENCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	162
564	564	MARIA C PALACIOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	162
565	565	SANTA APOLONIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	162
566	566	CM. STA MARIA DE CAPARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	163
567	567	CM. ARICAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	164
568	568	SAN ANTONIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	164
569	569	CM. ZEA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	165
570	570	CAÑO EL TIGRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	165
571	571	CAUCAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	166
572	572	ARAGUITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	166
573	573	AREVALO GONZALEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	166
574	574	CAPAYA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	166
575	575	PANAQUIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	166
576	576	RIBAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	166
577	577	EL CAFE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	166
578	578	MARIZAPA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	166
579	579	HIGUEROTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	167
580	580	CURIEPE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	167
581	581	TACARIGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	167
582	582	LOS TEQUES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	168
583	583	CECILIO ACOSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	168
584	584	PARACOTOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	168
585	585	SAN PEDRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	168
586	586	TACATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	168
587	587	EL JARILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	168
588	588	ALTAGRACIA DE LA M	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	168
589	589	STA TERESA DEL TUY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	169
590	590	EL CARTANAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	169
591	591	OCUMARE DEL TUY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	170
592	592	LA DEMOCRACIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	170
593	593	SANTA BARBARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	170
594	594	RIO CHICO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	171
595	595	EL GUAPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	171
596	596	TACARIGUA DE LA LAGUNA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	171
597	597	PAPARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	171
598	598	SN FERNANDO DEL GUAPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	171
599	599	SANTA LUCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	172
600	600	GUARENAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	173
601	601	PETARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	174
602	602	LEONCIO MARTINEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	174
603	603	CAUCAGUITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	174
604	604	FILAS DE MARICHES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	174
605	605	LA DOLORITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	174
606	606	CUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	175
607	607	NUEVA CUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	175
608	608	GUATIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	176
609	609	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	176
610	610	CHARALLAVE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	177
611	611	LAS BRISAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	177
612	612	SAN ANTONIO LOS ALTOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	178
613	613	SAN JOSE DE BARLOVENTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	179
614	614	CUMBO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	179
615	615	SAN FCO DE YARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	180
616	616	S ANTONIO DE YARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	180
617	617	BARUTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	181
618	618	EL CAFETAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	181
619	619	LAS MINAS DE BARUTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	181
620	620	CARRIZAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	182
621	621	CHACAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	183
622	622	EL HATILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	184
623	623	MAMPORAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	185
624	624	CUPIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	186
625	625	MACHURUCUTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	186
626	626	CM. SAN ANTONIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	187
627	627	SAN FRANCISCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	187
628	628	CM. CARIPITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	188
629	629	CM. CARIPE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	189
630	630	TERESEN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	189
631	631	EL GUACHARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	189
632	632	SAN AGUSTIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	189
633	633	LA GUANOTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	189
634	634	SABANA DE PIEDRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	189
635	635	CM. CAICARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	190
636	636	AREO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	190
637	637	SAN FELIX	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	190
638	638	VIENTO FRESCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	190
639	639	CM. PUNTA DE MATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	191
640	640	EL TEJERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	191
641	641	CM. TEMBLADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	192
642	642	TABASCA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	192
643	643	LAS ALHUACAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	192
644	644	CHAGUARAMAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	192
645	645	EL FURRIAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
646	646	JUSEPIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
647	647	EL COROZO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
648	648	SAN VICENTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
649	649	LA PICA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
650	650	ALTO DE LOS GODOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
651	651	BOQUERON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
652	652	LAS COCUIZAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
653	653	SANTA CRUZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
654	654	SAN SIMON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	193
655	655	CM. ARAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	194
656	656	CHAGUARAMAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	194
657	657	GUANAGUANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	194
658	658	APARICIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	194
659	659	TAGUAYA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	194
660	660	EL PINTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	194
661	661	LA TOSCANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	194
662	662	CM. QUIRIQUIRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	195
663	663	CACHIPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	195
664	664	CM. BARRANCAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	196
665	665	LOS BARRANCOS DE FAJARDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	196
666	666	CM. AGUASAY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	197
667	667	CM. SANTA BARBARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	198
668	668	CM. URACOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	199
669	669	CM. LA ASUNCION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	200
670	670	CM. SAN JUAN BAUTISTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	201
671	671	ZABALA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	201
672	672	CM. SANTA ANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	202
673	673	GUEVARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	202
674	674	MATASIETE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	202
675	675	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	202
676	676	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	202
677	677	CM. PAMPATAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	203
678	678	AGUIRRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	203
679	679	CM. JUAN GRIEGO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	204
680	680	ADRIAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	204
681	681	CM. PORLAMAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	205
682	682	CM. BOCA DEL RIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	206
683	683	SAN FRANCISCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	206
684	684	CM. SAN PEDRO DE COCHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	207
685	685	VICENTE FUENTES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	207
686	686	CM. PUNTA DE PIEDRAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	208
687	687	LOS BARALES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	208
688	688	CM.LA PLAZA DE PARAGUACHI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	209
689	689	CM. VALLE ESP SANTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	210
690	690	FRANCISCO FAJARDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	210
691	691	CM. ARAURE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	211
692	692	RIO ACARIGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	211
693	693	CM. PIRITU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	212
694	694	UVERAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	212
695	695	CM. GUANARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	213
696	696	CORDOBA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	213
697	697	SAN JUAN GUANAGUANARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	213
698	698	VIRGEN DE LA COROMOTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	213
699	699	SAN JOSE DE LA MONTAÑA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	213
700	700	CM. GUANARITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	214
701	701	TRINIDAD DE LA CAPILLA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	214
702	702	DIVINA PASTORA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	214
703	703	CM. OSPINO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	215
704	704	APARICION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	215
705	705	LA ESTACION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	215
706	706	CM. ACARIGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	216
707	707	PAYARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	216
708	708	PIMPINELA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	216
709	709	RAMON PERAZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	216
710	710	CM. BISCUCUY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	217
711	711	CONCEPCION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	217
712	712	SAN RAFAEL PALO ALZADO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	217
713	713	UVENCIO A VELASQUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	217
714	714	SAN JOSE DE SAGUAZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	217
715	715	VILLA ROSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	217
716	716	CM. VILLA BRUZUAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	218
717	717	CANELONES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	218
718	718	SANTA CRUZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	218
719	719	SAN ISIDRO LABRADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	218
720	720	CM. CHABASQUEN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	219
721	721	PEÑA BLANCA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	219
722	722	CM. AGUA BLANCA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	220
723	723	CM. PAPELON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	221
724	724	CAÑO DELGADITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	221
725	725	CM. BOCONOITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	222
726	726	ANTOLIN TOVAR AQUINO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	222
727	727	CM. SAN RAFAEL DE ONOTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	223
728	728	SANTA FE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	223
729	729	THERMO MORLES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	223
730	730	CM. EL PLAYON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	224
731	731	FLORIDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	224
732	732	RIO CARIBE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	225
733	733	SAN JUAN GALDONAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	225
734	734	PUERTO SANTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	225
735	735	EL MORRO DE PTO SANTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	225
736	736	ANTONIO JOSE DE SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	225
737	737	EL PILAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	226
738	738	EL RINCON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	226
739	739	GUARAUNOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	226
740	740	TUNAPUICITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	226
741	741	UNION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	226
742	742	GRAL FCO. A VASQUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	226
743	743	SANTA CATALINA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	227
744	744	SANTA ROSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	227
745	745	SANTA TERESA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	227
746	746	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	227
747	747	MACARAPANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	227
748	748	YAGUARAPARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	228
749	749	LIBERTAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	228
750	750	PAUJIL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	228
751	751	IRAPA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	229
752	752	CAMPO CLARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	229
753	753	SORO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	229
754	754	SAN ANTONIO DE IRAPA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	229
755	755	MARABAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	229
756	756	CM. SAN ANT DEL GOLFO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	230
757	757	CUMANACOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	231
758	758	ARENAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	231
759	759	ARICAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	231
760	760	COCOLLAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	231
761	761	SAN FERNANDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	231
762	762	SAN LORENZO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	231
763	763	CARIACO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
764	764	CATUARO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
765	765	RENDON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
766	766	SANTA CRUZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
767	767	SANTA MARIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
768	768	ALTAGRACIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	233
769	769	AYACUCHO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	233
770	770	SANTA INES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	233
771	771	VALENTIN VALIENTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	233
772	772	SAN JUAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	233
773	773	GRAN MARISCAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	233
774	774	RAUL LEONI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	233
775	775	GUIRIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	234
776	776	CRISTOBAL COLON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	234
777	777	PUNTA DE PIEDRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	234
778	778	BIDEAU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	234
779	779	MARIÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	235
780	780	ROMULO GALLEGOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	235
781	781	TUNAPUY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	236
782	782	CAMPO ELIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	236
783	783	SAN JOSE DE AREOCUAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	237
784	784	TAVERA ACOSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	237
785	785	CM. MARIGUITAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	238
786	786	ARAYA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	239
787	787	MANICUARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	239
788	788	CHACOPATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	239
789	789	CM. COLON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	240
790	790	RIVAS BERTI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	240
791	791	SAN PEDRO DEL RIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	240
792	792	CM. SAN ANT DEL TACHIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	241
793	793	PALOTAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	241
794	794	JUAN VICENTE GOMEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	241
795	795	ISAIAS MEDINA ANGARIT	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	241
796	796	CM. CAPACHO NUEVO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	242
797	797	JUAN GERMAN ROSCIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	242
798	798	ROMAN CARDENAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	242
799	799	CM. TARIBA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	243
800	800	LA FLORIDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	243
801	801	AMENODORO RANGEL LAMU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	243
802	802	CM. LA GRITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	244
803	803	EMILIO C. GUERRERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	244
804	804	MONS. MIGUEL A SALAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	244
805	805	CM. RUBIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	245
806	806	BRAMON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	245
807	807	LA PETROLEA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	245
808	808	QUINIMARI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	245
809	809	CM. LOBATERA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	246
810	810	CONSTITUCION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	246
811	811	LA CONCORDIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	247
812	812	PEDRO MARIA MORANTES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	247
813	813	SN JUAN BAUTISTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	247
814	814	SAN SEBASTIAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	247
815	815	DR. FCO. ROMERO LOBO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	247
816	816	CM. PREGONERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	248
817	817	CARDENAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	248
818	818	POTOSI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	248
819	819	JUAN PABLO PEÑALOZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	248
820	820	CM. STA. ANA  DEL TACHIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	249
821	821	CM. LA FRIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	250
822	822	BOCA DE GRITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	250
823	823	JOSE ANTONIO PAEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	250
824	824	CM. PALMIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	251
825	825	CM. MICHELENA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	252
826	826	CM. ABEJALES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	253
827	827	SAN JOAQUIN DE NAVAY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	253
828	828	DORADAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	253
829	829	EMETERIO OCHOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	253
830	830	CM. COLONCITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	254
831	831	LA PALMITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	254
832	832	CM. UREÑA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	255
833	833	NUEVA ARCADIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	255
834	834	CM. QUENIQUEA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	256
835	835	SAN PABLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	256
836	836	ELEAZAR LOPEZ CONTRERA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	256
837	837	CM. CORDERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	257
838	838	CM.SAN RAFAEL DEL PINAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	258
839	839	SANTO DOMINGO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	258
840	840	ALBERTO ADRIANI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	258
841	841	CM. CAPACHO VIEJO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	259
842	842	CIPRIANO CASTRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	259
843	843	MANUEL FELIPE RUGELES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	259
844	844	CM. LA TENDIDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	260
845	845	BOCONO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	260
846	846	HERNANDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	260
847	847	CM. SEBORUCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	261
848	848	CM. LAS MESAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	262
849	849	CM. SAN JOSE DE BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	263
850	850	CM. EL COBRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	264
851	851	CM. DELICIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	265
852	852	CM. SAN SIMON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	266
853	853	CM. SAN JOSECITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	267
854	854	CM. UMUQUENA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	268
855	855	BETIJOQUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	269
856	856	JOSE G HERNANDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	269
857	857	LA PUEBLITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	269
858	858	EL CEDRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	269
859	859	BOCONO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
860	860	EL CARMEN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
861	861	MOSQUEY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
862	862	AYACUCHO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
863	863	BURBUSAY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
864	864	GENERAL RIVAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
865	865	MONSEÑOR JAUREGUI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
866	866	RAFAEL RANGEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
867	867	SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
868	868	SAN MIGUEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
869	869	GUARAMACAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
870	870	LA VEGA DE GUARAMACAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	270
871	871	CARACHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	271
872	872	LA CONCEPCION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	271
873	873	CUICAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	271
874	874	PANAMERICANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	271
875	875	SANTA CRUZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	271
876	876	ESCUQUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	272
877	877	SABANA LIBRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	272
878	878	LA UNION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	272
879	879	SANTA RITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	272
880	880	CRISTOBAL MENDOZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	273
881	881	CHIQUINQUIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	273
882	882	MATRIZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	273
883	883	MONSEÑOR CARRILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	273
884	884	CRUZ CARRILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	273
885	885	ANDRES LINARES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	273
886	886	TRES ESQUINAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	273
887	887	LA QUEBRADA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	274
888	888	JAJO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	274
889	889	LA MESA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	274
890	890	SANTIAGO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	274
891	891	CABIMBU	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	274
892	892	TUÑAME	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	274
893	893	MERCEDES DIAZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	275
894	894	JUAN IGNACIO MONTILLA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	275
895	895	LA BEATRIZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	275
896	896	MENDOZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	275
897	897	LA PUERTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	275
898	898	SAN LUIS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	275
899	899	CHEJENDE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	276
900	900	CARRILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	276
901	901	CEGARRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	276
902	902	BOLIVIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	276
903	903	MANUEL SALVADOR ULLOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	276
904	904	SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	276
905	905	ARNOLDO GABALDON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	276
906	906	EL DIVIDIVE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	277
907	907	AGUA CALIENTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	277
908	908	EL CENIZO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	277
909	909	AGUA SANTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	277
910	910	VALERITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	277
911	911	MONTE CARMELO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	278
912	912	BUENA VISTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	278
913	913	STA MARIA DEL HORCON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	278
914	914	MOTATAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	279
915	915	EL BAÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	279
916	916	JALISCO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	279
917	917	PAMPAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	280
918	918	SANTA ANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	280
919	919	LA PAZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	280
920	920	FLOR DE PATRIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	280
921	921	CARVAJAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	281
922	922	ANTONIO N BRICEÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	281
923	923	CAMPO ALEGRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	281
924	924	JOSE LEONARDO SUAREZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	281
925	925	SABANA DE MENDOZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	282
926	926	JUNIN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	282
927	927	VALMORE RODRIGUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	282
928	928	EL PARAISO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	282
929	929	SANTA ISABEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	283
930	930	ARAGUANEY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	283
931	931	EL JAGUITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	283
932	932	LA ESPERANZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	283
933	933	SABANA GRANDE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	284
934	934	CHEREGUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	284
935	935	GRANADOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	284
936	936	EL SOCORRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	285
937	937	LOS CAPRICHOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	285
938	938	ANTONIO JOSE DE SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	285
939	939	CAMPO ELIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	286
940	940	ARNOLDO GABALDON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	286
941	941	SANTA APOLONIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	287
942	942	LA CEIBA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	287
943	943	EL PROGRESO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	287
944	944	TRES DE FEBRERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	287
945	945	PAMPANITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	288
946	946	PAMPANITO II	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	288
947	947	LA CONCEPCION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	288
948	948	CM. AROA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	289
949	949	CM. CHIVACOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	290
950	950	CAMPO ELIAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	290
951	951	CM. NIRGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	291
952	952	SALOM	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	291
953	953	TEMERLA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	291
954	954	CM. SAN FELIPE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	292
955	955	ALBARICO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	292
956	956	SAN JAVIER	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	292
957	957	CM. GUAMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	293
958	958	CM. URACHICHE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	294
959	959	CM. YARITAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	295
960	960	SAN ANDRES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	295
961	961	CM. SABANA DE PARRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	296
962	962	CM. BORAURE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	297
963	963	CM. COCOROTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	298
964	964	CM. INDEPENDENCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	299
965	965	CM. SAN PABLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	300
966	966	CM. YUMARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	301
967	967	CM. FARRIAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	302
968	968	EL GUAYABO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	302
969	969	GENERAL URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	303
970	970	LIBERTADOR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	303
971	971	MANUEL GUANIPA MATOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	303
972	972	MARCELINO BRICEÑO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	303
973	973	SAN TIMOTEO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	303
974	974	PUEBLO NUEVO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	303
975	975	PEDRO LUCAS URRIBARRI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	304
976	976	SANTA RITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	304
977	977	JOSE CENOVIO URRIBARR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	304
978	978	EL MENE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	304
979	979	SANTA CRUZ DEL ZULIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	305
980	980	URRIBARRI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	305
981	981	MORALITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	305
982	982	SAN CARLOS DEL ZULIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	305
983	983	SANTA BARBARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	305
984	984	LUIS DE VICENTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	306
985	985	RICAURTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	306
986	986	MONS.MARCOS SERGIO G	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	306
987	987	SAN RAFAEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	306
988	988	LAS PARCELAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	306
989	989	TAMARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	306
990	990	LA SIERRITA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	306
991	991	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
992	992	COQUIVACOA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
993	993	CRISTO DE ARANZA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
994	994	CHIQUINQUIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
995	995	SANTA LUCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
996	996	OLEGARIO VILLALOBOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
997	997	JUANA DE AVILA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
998	998	CARACCIOLO PARRA PEREZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
999	999	IDELFONZO VASQUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1000	1000	CACIQUE MARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1001	1001	CECILIO ACOSTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1002	1002	RAUL LEONI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1003	1003	FRANCISCO EUGENIO B	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1004	1004	MANUEL DAGNINO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1005	1005	LUIS HURTADO HIGUERA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1006	1006	VENANCIO PULGAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1007	1007	ANTONIO BORJAS ROMERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1008	1008	SAN ISIDRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	307
1009	1009	FARIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	308
1010	1010	SAN ANTONIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	308
1011	1011	ANA MARIA CAMPOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	308
1012	1012	SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	308
1013	1013	ALTAGRACIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	308
1014	1014	GOAJIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	309
1015	1015	ELIAS SANCHEZ RUBIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	309
1016	1016	SINAMAICA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	309
1017	1017	ALTA GUAJIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	309
1018	1018	SAN JOSE DE PERIJA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	310
1019	1019	BARTOLOME DE LAS CASAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	310
1020	1020	LIBERTAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	310
1021	1021	RIO NEGRO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	310
1022	1022	GIBRALTAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	311
1023	1023	HERAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	311
1024	1024	M.ARTURO CELESTINO A	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	311
1025	1025	ROMULO GALLEGOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	311
1026	1026	BOBURES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	311
1027	1027	EL BATEY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	311
1028	1028	ANDRES BELLO (KM 48)	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	312
1029	1029	POTRERITOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	312
1030	1030	EL CARMELO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	312
1031	1031	CHIQUINQUIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	312
1032	1032	CONCEPCION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	312
1033	1033	ELEAZAR LOPEZ C	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	313
1034	1034	ALONSO DE OJEDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	313
1035	1035	VENEZUELA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	313
1036	1036	CAMPO LARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	313
1037	1037	LIBERTAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	313
1038	1038	UDON PEREZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	314
1039	1039	ENCONTRADOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	314
1040	1040	DONALDO GARCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	315
1041	1041	SIXTO ZAMBRANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	315
1042	1042	EL ROSARIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	315
1043	1043	AMBROSIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	316
1044	1044	GERMAN RIOS LINARES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	316
1045	1045	JORGE HERNANDEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	316
1046	1046	LA ROSA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	316
1047	1047	PUNTA GORDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	316
1048	1048	CARMEN HERRERA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	316
1049	1049	SAN BENITO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	316
1050	1050	ROMULO BETANCOURT	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	316
1051	1051	ARISTIDES CALVANI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	316
1052	1052	RAUL CUENCA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	317
1053	1053	LA VICTORIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	317
1054	1054	RAFAEL URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	317
1055	1055	JOSE RAMON YEPEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	318
1056	1056	LA CONCEPCION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	318
1057	1057	SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	318
1068	1068	JESUS M SEMPRUN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	321
1069	1069	SIMON RODRIGUEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	322
1070	1070	CARLOS QUEVEDO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	322
1071	1071	FRANCISCO J PULGAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	322
1072	1072	RAFAEL MARIA BARALT	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	323
1073	1073	MANUEL MANRIQUE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	323
1074	1074	RAFAEL URDANETA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	323
1075	1075	FERNANDO GIRON TOVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	324
1076	1076	LUIS ALBERTO GOMEZ	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	324
1077	1077	PARHUEÑA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	324
1078	1078	PLATANILLAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	324
1079	1079	CM. SAN FERNANDO DE ATABA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	325
1080	1080	UCATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	325
1081	1081	YAPACANA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	325
1082	1082	CANAME	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	325
1083	1083	CM. MAROA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	326
1084	1084	VICTORINO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	326
1085	1085	COMUNIDAD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	326
1086	1086	CM. SAN CARLOS DE RIO NEG	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	327
1087	1087	SOLANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	327
1088	1088	COCUY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	327
1089	1089	CM. ISLA DE RATON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	328
1090	1090	SAMARIAPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	328
1091	1091	SIPAPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	328
1092	1092	MUNDUAPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	328
1093	1093	GUAYAPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	328
1094	1094	CM. SAN JUAN DE MANAPIARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	329
1095	1095	ALTO VENTUARI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	329
1096	1096	MEDIO VENTUARI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	329
1097	1097	BAJO VENTUARI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	329
1098	1098	CM. LA ESMERALDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	330
1099	1099	HUACHAMACARE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	330
1100	1100	MARAWAKA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	330
1101	1101	MAVACA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	330
1102	1102	SIERRA PARIMA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	330
1103	1103	SAN JOSE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	331
1104	1104	VIRGEN DEL VALLE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	331
1105	1105	SAN RAFAEL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	331
1106	1106	JOSE VIDAL MARCANO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	331
1107	1107	LEONARDO RUIZ PINEDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	331
1108	1108	MONS. ARGIMIRO GARCIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	331
1109	1109	MCL.ANTONIO J DE SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	331
1110	1110	JUAN MILLAN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	331
1111	1111	PEDERNALES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	332
1112	1112	LUIS B PRIETO FIGUERO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	332
1113	1113	CURIAPO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	333
1114	1114	SANTOS DE ABELGAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	333
1115	1115	MANUEL RENAUD	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	333
1116	1116	PADRE BARRAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	333
1117	1117	ANICETO LUGO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	333
1118	1118	ALMIRANTE LUIS BRION	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	333
1119	1119	IMATACA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	334
1120	1120	ROMULO GALLEGOS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	334
1121	1121	JUAN BAUTISTA ARISMEN	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	334
1122	1122	MANUEL PIAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	334
1123	1123	5 DE JULIO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	334
1124	1124	CARABALLEDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1125	1125	CARAYACA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1126	1126	CARUAO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1127	1127	CATIA LA MAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1128	1128	LA GUAIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1129	1129	MACUTO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1130	1130	MAIQUETIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1131	1131	NAIGUATA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1132	1132	EL JUNKO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1133	1133	PQ RAUL LEONI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
1134	1134	PQ CARLOS SOUBLETTE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	335
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, amount, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "lockerId", "paymentTypeId") FROM stdin;
12	14416.610529000001	2024-11-09 21:05:15.83213	2024-11-09 21:05:15.83213	\N	3	\N	\N	\N	\N	1
13	14416.610529000001	2024-11-09 21:08:21.070214	2024-11-09 21:08:21.070214	\N	3	\N	\N	\N	\N	1
14	14416.610529	2024-11-10 16:52:03.249341	2024-11-10 16:52:03.249341	\N	3	\N	\N	\N	\N	1
15	14416.610529000001	2024-11-10 16:52:57.772787	2024-11-10 16:52:57.772787	\N	3	\N	\N	\N	\N	1
16	14282.386688999999	2024-11-13 21:29:06.977692	2024-11-13 21:29:06.977692	\N	3	\N	\N	\N	\N	1
17	14282.386688999999	2024-11-13 21:36:48.030529	2024-11-13 21:36:48.030529	\N	3	\N	\N	\N	\N	1
18	14282.386688999999	2024-11-13 21:37:14.533902	2024-11-13 21:37:14.533902	\N	3	\N	\N	\N	\N	1
19	14282.386688999999	2024-11-13 21:38:13.582624	2024-11-13 21:38:13.582624	\N	3	\N	\N	\N	\N	1
20	14282.386688999999	2024-11-13 21:39:00.585434	2024-11-14 00:02:50.187179	\N	4	\N	\N	\N	\N	1
21	14421.532356	2024-11-14 21:25:36.985307	2024-11-14 21:46:35.723464	\N	4	\N	\N	\N	\N	1
22	14477.097227999999	2024-11-16 17:07:44.623232	2024-11-16 17:08:48.168814	\N	4	\N	\N	\N	\N	1
23	0	2024-11-16 17:10:32.143375	2024-11-16 17:10:32.143375	\N	3	\N	\N	\N	\N	1
24	0	2024-11-16 17:22:31.744408	2024-11-16 17:22:31.744408	\N	3	\N	\N	\N	\N	1
25	0	2024-11-16 17:23:42.759532	2024-11-16 17:23:42.759532	\N	3	\N	\N	\N	\N	1
26	14477.097228	2024-11-16 17:27:48.864926	2024-11-16 17:27:48.864926	\N	3	\N	\N	\N	\N	1
27	14477.097228	2024-11-16 17:36:07.198679	2024-11-16 17:36:07.198679	\N	3	\N	\N	\N	\N	1
28	14477.097228	2024-11-16 17:37:05.750844	2024-11-16 17:37:05.750844	\N	3	\N	\N	\N	\N	1
29	14477.097228	2024-11-16 17:37:45.14191	2024-11-16 17:37:45.14191	\N	3	\N	\N	\N	\N	1
30	14477.097228	2024-11-16 17:38:11.383879	2024-11-16 17:38:11.383879	\N	3	\N	\N	\N	\N	1
31	14477.097228	2024-11-16 17:39:16.733321	2024-11-16 17:39:16.733321	\N	3	\N	\N	\N	\N	1
32	14477.097228	2024-11-16 17:42:37.268327	2024-11-16 17:42:37.268327	\N	3	\N	\N	\N	\N	1
33	14477.097228	2024-11-16 17:46:25.636272	2024-11-16 17:46:25.636272	\N	3	\N	\N	\N	\N	1
34	14477.097228	2024-11-16 17:47:48.367548	2024-11-16 17:47:48.367548	\N	3	\N	\N	\N	\N	1
35	14477.097228	2024-11-16 17:49:08.109144	2024-11-16 17:49:08.109144	\N	3	\N	\N	\N	\N	1
36	14477.097228	2024-11-16 17:54:06.575394	2024-11-16 17:54:06.575394	\N	3	\N	\N	\N	\N	1
37	14477.097228	2024-11-16 17:55:04.855434	2024-11-16 17:55:04.855434	\N	3	\N	\N	\N	\N	1
38	14477.097228	2024-11-16 17:56:21.427149	2024-11-16 17:56:21.427149	\N	3	\N	\N	\N	\N	1
39	14477.097228	2024-11-16 17:59:28.807257	2024-11-16 17:59:28.807257	\N	3	\N	\N	\N	\N	1
40	14477.097228	2024-11-16 18:01:46.246215	2024-11-16 18:01:46.246215	\N	3	\N	\N	\N	\N	1
41	14477.097228	2024-11-16 18:05:35.012102	2024-11-16 18:05:35.012102	\N	3	\N	\N	\N	\N	1
42	14477.097228	2024-11-16 18:06:32.384058	2024-11-16 18:06:32.384058	\N	3	\N	\N	\N	\N	1
43	14477.097228	2024-11-16 18:07:47.596315	2024-11-16 18:07:47.596315	\N	3	\N	\N	\N	\N	1
44	14477.097228	2024-11-16 18:08:22.591073	2024-11-16 18:08:22.591073	\N	3	\N	\N	\N	\N	1
45	14477.097228	2024-11-17 14:39:15.244033	2024-11-17 14:39:15.244033	\N	3	\N	\N	\N	\N	1
\.


--
-- Data for Name: payments_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments_type (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	ONLINE	Boton de Pago 100% banco	2024-11-03 11:45:32.3193	2024-11-03 11:45:32.3193	\N	1	1	1	\N
2	TRANFERENCIA	Transferencia Bancaria	2024-11-03 11:46:23.180249	2024-11-03 11:46:23.180249	\N	1	1	1	\N
3	PAGOMOVIL	Pago Móvil	2024-11-03 11:46:23.18436	2024-11-03 11:46:23.18436	\N	1	1	1	\N
\.


--
-- Data for Name: point_of_sale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.point_of_sale (id, code, description, serial, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "bankAccountId") FROM stdin;
\.


--
-- Data for Name: privilege; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.privilege (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	R_PROFILE	Consult (read) user profile in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	\N	\N	\N
2	U_PASSWORD	Modify (update) user password in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	\N	\N	\N
3	R_TAX_STAMPS	Consult (read) user tax stamps in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	\N	\N	\N
4	C_TAX_STAMPS	Generate (create) user tax stamps in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	\N	\N	\N
5	C_PAYMENTS	Pay (create) user tax stamps in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	\N	\N	\N
6	C_PAYMENTS_OFFICE	Pay (create) at the box office	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	\N	\N	\N
7	R_TAX_STAMPS_OFFICE	Consult (read) tax stamps at the box office	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	\N	\N	\N
8	C_TAX_STAMPS_OFFICE	Generate (create) tax stamps at the box office	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	\N	\N	\N
9	C_GAZETTE	Gazette (create)	2024-11-11 16:34:53.536	2024-11-11 16:34:53.536	\N	1	\N	\N	\N
10	U_USER	Modify (update) users	2024-11-11 16:34:53.536	2024-11-11 16:34:53.536	\N	1	\N	\N	\N
11	R_REPORTS	Consult (read) reports at the box office	2024-11-11 16:34:53.536	2024-11-11 16:34:53.536	\N	1	\N	\N	\N
\.


--
-- Data for Name: procedure; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.procedure (id, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "subentityId", is_specific_value, value, code) FROM stdin;
2	Inscripcion de sentencia de separacion de cuerpos, donde no se adjudiquen bienes inmuebles	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0002
8	Inscripcion de ttulos o certificados  de profesionalizacion	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0008
9	Copias certificadas de documentos inscritos.	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0009
10	Copias o reproducciones simples de los documentos inscritos.	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0010
12	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0012
13	Actas de remate.	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0013
15	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0015
16	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0016
17	Certificacion de gravamenes	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0017
18	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0018
19	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0019
20	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0020
21	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0021
22	Documento de particiones de herencias	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0022
23	Cierre de titularidad.-	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0023
24	Documento de parcelamiento	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0024
25	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0025
26	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0026
27	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0027
28	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0012
29	Actas de remate.	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0013
30	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0014
31	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0015
32	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0016
33	Certificacion de gravamenes	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0017
34	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0018
35	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0019
36	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0020
37	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0021
38	Documento de particiones de herencias	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0022
39	Cierre de titularidad.-	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0023
40	Documento de parcelamiento	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0024
41	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0025
42	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0026
43	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0027
44	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0012
45	Actas de remate.	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0013
46	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0014
1	Inscripcion de sentencias de divorcio, donde no se adjudiquen bienes inmuebles	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0001
3	Inscripcion de sentencia de  nulidad de matrimonio, donde no se adjudiquen bienes inmuebles	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0003
4	Estampar notas marginales de sentencias de divorcio, separaciones de cuerpos, nulidad de matrimono	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0004
5	Legalizacion de firmas. 	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0005
6	Declaraciones juradas de caracter academico permitidas por la Ley	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0006
7	Inscripcion de ttulos o certificados academicos de profesionalizacion	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0007
14	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0014
49	Certificacion de gravamenes	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0017
50	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0018
51	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0019
52	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0020
53	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0021
54	Documento de particiones de herencias	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0022
55	Cierre de titularidad.-	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0023
56	Documento de parcelamiento	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0024
57	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0025
58	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0026
60	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0012
61	Actas de remate.	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0013
62	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0014
64	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0016
65	Certificacion de gravamenes	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0017
66	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0018
67	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0019
68	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0020
69	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0021
70	Documento de particiones de herencias	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0022
71	Cierre de titularidad.-	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0023
72	Documento de parcelamiento	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0024
73	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0025
74	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0026
75	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0027
76	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0012
77	Actas de remate.	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0013
78	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0014
80	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0016
81	Certificacion de gravamenes	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0017
82	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0018
83	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0019
84	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0020
85	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0021
86	Documento de particiones de herencias	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0022
87	Cierre de titularidad.-	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0023
88	Documento de parcelamiento	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0024
89	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0025
90	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0026
91	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0027
92	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0012
93	Actas de remate.	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0013
94	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0014
95	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0015
96	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0016
97	Certificacion de gravamenes	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0017
98	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0018
99	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0019
100	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0020
101	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0021
102	Documento de particiones de herencias	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0022
103	Cierre de titularidad.-	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0023
104	Documento de parcelamiento	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0024
105	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0025
106	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0026
48	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0016
111	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0015
112	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0016
113	Certificacion de gravamenes	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0017
114	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0018
115	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0019
116	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0020
117	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0021
118	Documento de particiones de herencias	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0022
119	Cierre de titularidad.-	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0023
120	Documento de parcelamiento	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0024
121	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0025
122	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0026
123	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0027
124	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0012
125	Actas de remate.	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0013
126	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0014
128	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0016
129	Certificacion de gravamenes	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0017
130	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0018
131	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0019
132	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0020
133	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0021
134	Documento de particiones de herencias	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0022
135	Cierre de titularidad.-	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0023
136	Documento de parcelamiento	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0024
137	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0025
138	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0026
139	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0027
140	Inscripcion de cualquier tipo de sociedades, firmas personales y asociaciones de cuentas en participacion	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0028
142	Actas en las cuales se declare  disolucion, liquidacion, extincion o prorroga de  la duracion de cualquier tipo de sociedades	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0030
143	Inscripcion de sociedades extranjeras, domiciliaciones o establecimientos de agencias, representaciones, o sucursales de las mismas	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0031
144	Inscripcion de documentos de ventas de cuotas de participacion, de fondos de comercio, cesion de firmas personales	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0032
145	Inscripcion de poderes, factores mercantiles, sentencias emanada de cualquier organismo o autoridad.	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0033
146	Por agregar documentos y anexos a los expedientes	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0034
147	Por estampar cada nota marginal	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0035
148	Sellado de libros y cualquier tipo de papeles mercantiles.	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0036
149	Por cualquier otro tipo de documento no incluido anteriormente.	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0037
150	Inscripcion de cualquier tipo de sociedades, firmas personales y asociaciones de cuentas en participacion	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0028
152	Actas en las cuales se declare  disolucion, liquidacion, extincion o prorroga de  la duracion de cualquier tipo de sociedades	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0030
153	Inscripcion de sociedades extranjeras, domiciliaciones o establecimientos de agencias, representaciones, o sucursales de las mismas	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0031
154	Inscripcion de documentos de ventas de cuotas de participacion, de fondos de comercio, cesion de firmas personales	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0032
155	Inscripcion de poderes, factores mercantiles, sentencias emanada de cualquier organismo o autoridad.	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0033
156	Por agregar documentos y anexos a los expedientes	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0034
157	Por estampar cada nota marginal	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0035
158	Sellado de libros y cualquier tipo de papeles mercantiles.	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0036
159	Por cualquier otro tipo de documento no incluido anteriormente.	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0037
160	Inscripcion de cualquier tipo de sociedades, firmas personales y asociaciones de cuentas en participacion	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0028
161	Inscripcion de  Acta de asamblea o junta directiva; modificaciones al documento constitutivo de firmas personales o de cuentas de participacion y 	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0029
344	Solvencia Sucesoral	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0062
109	Actas de remate.	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0013
164	Inscripcion de documentos de ventas de cuotas de participacion, de fondos de comercio, cesion de firmas personales	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0032
165	Inscripcion de poderes, factores mercantiles, sentencias emanada de cualquier organismo o autoridad.	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0033
166	Por agregar documentos y anexos a los expedientes	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0034
167	Por estampar cada nota marginal	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0035
168	Sellado de libros y cualquier tipo de papeles mercantiles.	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0036
169	Por cualquier otro tipo de documento no incluido anteriormente.	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0037
170	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0038
171	Otorgamiento de autorizaciones	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0039
172	Otorgamiento de justificativo	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0040
173	Aprobacion de una particion	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0041
174	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0042
175	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0043
177	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0045
178	Por las copias certificadas de documentos autenticados	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0046
179	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0047
180	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0048
181	Actas notariales	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0049
182	Por estampar cada nota marginal.	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0050
183	Documentos autenticados,	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0051
184	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0052
185	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0038
186	Otorgamiento de autorizaciones	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0039
187	Otorgamiento de justificativo	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0040
188	Aprobacion de una particion	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0041
189	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0042
190	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0043
192	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0045
193	Por las copias certificadas de documentos autenticados	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0046
194	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0047
195	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0048
196	Actas notariales	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0049
197	Por estampar cada nota marginal.	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0050
198	Documentos autenticados,	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0051
199	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0052
200	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0038
201	Otorgamiento de autorizaciones	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0039
202	Otorgamiento de justificativo	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0040
203	Aprobacion de una particion	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0041
204	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0042
205	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0043
206	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0044
207	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0045
208	Por las copias certificadas de documentos autenticados	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0046
209	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0047
210	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0048
211	Actas notariales	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0049
212	Por estampar cada nota marginal.	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0050
213	Documentos autenticados,	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0051
214	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0052
215	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0038
216	Otorgamiento de autorizaciones	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0039
217	Otorgamiento de justificativo	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0040
218	Aprobacion de una particion	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0041
219	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0042
220	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0043
342	Inscripcion, anulacion de Registro Vivienda Principal	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0060
223	Por las copias certificadas de documentos autenticados	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0046
224	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0047
225	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0048
226	Actas notariales	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0049
227	Por estampar cada nota marginal.	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0050
228	Documentos autenticados,	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0051
229	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0052
230	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0038
231	Otorgamiento de autorizaciones	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0039
232	Otorgamiento de justificativo	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0040
233	Aprobacion de una particion	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0041
234	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0042
236	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0044
237	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0045
238	Por las copias certificadas de documentos autenticados	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0046
239	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0047
240	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0048
241	Actas notariales	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0049
242	Por estampar cada nota marginal.	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0050
243	Documentos autenticados,	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0051
244	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0052
245	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0038
246	Otorgamiento de autorizaciones	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0039
247	Otorgamiento de justificativo	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0040
248	Aprobacion de una particion	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0041
249	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0042
250	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0043
253	Por las copias certificadas de documentos autenticados	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0046
254	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0047
255	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0048
256	Actas notariales	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0049
257	Por estampar cada nota marginal.	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0050
258	Documentos autenticados,	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0051
259	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0052
260	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0038
261	Otorgamiento de autorizaciones	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0039
262	Otorgamiento de justificativo	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0040
263	Aprobacion de una particion	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0041
264	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0042
265	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0043
266	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0044
267	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0045
268	Por las copias certificadas de documentos autenticados	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0046
269	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0047
270	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0048
271	Actas notariales	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0049
272	Por estampar cada nota marginal.	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0050
273	Documentos autenticados,	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0051
274	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0052
276	Otorgamiento de autorizaciones	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0039
277	Otorgamiento de justificativo	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0040
278	Aprobacion de una particion	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0041
279	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0042
280	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0043
343	Escrito de prorroga (Declaracion Sucesoral)	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0061
222	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0045
283	Por las copias certificadas de documentos autenticados	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0046
284	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0047
285	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0048
286	Actas notariales	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0049
287	Por estampar cada nota marginal.	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0050
288	Documentos autenticados,	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0051
290	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0038
291	Otorgamiento de autorizaciones	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0039
292	Otorgamiento de justificativo	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0040
293	Aprobacion de una particion	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0041
294	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0042
295	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0043
297	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0045
298	Por las copias certificadas de documentos autenticados	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0046
299	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0047
300	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0048
301	Actas notariales	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0049
302	Por estampar cada nota marginal.	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0050
303	Documentos autenticados,	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0051
304	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0052
305	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0038
306	Otorgamiento de autorizaciones	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0039
307	Otorgamiento de justificativo	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0040
308	Aprobacion de una particion	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0041
309	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0042
311	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0044
312	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0045
313	Por las copias certificadas de documentos autenticados	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0046
314	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0047
315	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0048
316	Actas notariales	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0049
317	Por estampar cada nota marginal.	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0050
318	Documentos autenticados,	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0051
319	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0052
320	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0038
321	Otorgamiento de autorizaciones	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0039
322	Otorgamiento de justificativo	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0040
323	Aprobacion de una particion	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0041
324	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0042
325	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0043
327	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0045
328	Por las copias certificadas de documentos autenticados	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0046
329	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0047
330	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0048
331	Actas notariales	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0049
332	Por estampar cada nota marginal.	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0050
333	Documentos autenticados,	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0051
334	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0052
335	Consultas/solicitudes  sobre la aplicacion de las normas que integran el ordenamiento juridico vigente	2024-11-04 15:28:46.921	2024-11-04 15:28:46.921	\N	1	1	1	\N	24	f	\N	0053
336	Contratos relacionados con los ingresos publicos estadales	2024-11-04 15:28:46.921	2024-11-04 15:28:46.921	\N	1	1	1	\N	24	f	\N	0054
337	Contratos relativos a inmuebles propiedad del estado	2024-11-04 15:28:46.921	2024-11-04 15:28:46.921	\N	1	1	1	\N	24	f	\N	0055
338	Expedicion de copias certificadas sobre asuntos que cursen en sus archivos	2024-11-04 15:28:46.921	2024-11-04 15:28:46.921	\N	1	1	1	\N	24	f	\N	0056
339	Solicitudes, escritos 	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0057
340	Copias certificadas	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0058
341	Escritos para interposicion de recursos 	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0059
282	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0045
348	Remision por requerimiento (Correspondencia)	2024-11-05 09:15:18.972	2024-11-05 09:15:18.972	\N	1	1	1	\N	27	f	\N	0066
349	Solicitud de Tramite de Importacion	2024-11-05 09:15:53.47	2024-11-05 09:15:53.47	\N	1	1	1	\N	27	f	\N	0067
350	Solicitud de Tramite de Exportacion	2024-11-05 09:16:30.732	2024-11-05 09:16:30.732	\N	1	1	1	\N	27	f	\N	0068
351	Solicitud de Tramite de Transito Aduanero	2024-11-05 09:18:39.308	2024-11-05 09:18:39.308	\N	1	1	1	\N	27	f	\N	0069
352	Otras solicitudes dirigidas a las autoridades Aduaneras, Portuarias y de Navegacion	2024-11-05 09:23:04.759	2024-11-05 09:23:04.759	\N	1	1	1	\N	27	f	\N	0070
353	Solicitudes  sobre actividades de minerales no metalicos.	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0071
354	Autorizaciones eventuales o temporales sobre actividades de M.N.M.	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0072
355	Revocatoria del derecho minero otorgado	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0073
356	Solicitud de Ocupacion de Territorio	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0074
357	Otorgamiento de  Autorizacion para la Ocupacion del Territorio	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0075
358	Autorizacion para el desarrollo de actividades conexas 	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0076
359	Otras solicitudes y consultas emitidas en el ambito de competencia	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0077
360	Actos o documentos dirigido a Organos y Entes	2024-11-05 09:33:00.57	2024-11-05 09:33:00.57	\N	1	1	1	\N	29	f	\N	0078
361	Sellado Libro deL Control de Extraccion de Minerales No Metalicos	2024-11-05 09:33:00.57	2024-11-05 09:33:00.57	\N	1	1	1	\N	29	f	\N	0079
47	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0015
59	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0027
63	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0015
79	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0015
107	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0027
108	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0012
110	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0014
127	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0015
141	Inscripcion de  Acta de asamblea o junta directiva; modificaciones al documento constitutivo de firmas personales o de cuentas de participacion y 	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0029
151	Inscripcion de  Acta de asamblea o junta directiva; modificaciones al documento constitutivo de firmas personales o de cuentas de participacion y 	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0029
162	Actas en las cuales se declare  disolucion, liquidacion, extincion o prorroga de  la duracion de cualquier tipo de sociedades	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0030
163	Inscripcion de sociedades extranjeras, domiciliaciones o establecimientos de agencias, representaciones, o sucursales de las mismas	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0031
176	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0044
191	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0044
221	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0044
235	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0043
251	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0044
252	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0045
275	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0038
281	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0044
289	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0052
296	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0044
310	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0043
326	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Ni���os, Ni���as y Adolescentes	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0044
345	Solicitud para prescripcion de Declaracion Sucesoral	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0063
346	Solicitudes, consultas, escritos y correspondencia	2024-11-05 09:01:12.799	2024-11-05 09:01:12.799	\N	1	1	1	\N	26	f	\N	0064
347	Bulto Postal	2024-11-05 09:01:54.096	2024-11-05 09:01:54.096	\N	1	1	1	\N	26	f	\N	0065
11	Inscripcion de asociaciones y sociedades civiles de caracter privado.	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	t	20	0011
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	SUPERADMIN	ROLE WITH ALL PRIVILEGES - ONLY FOR DEVELOPERS	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
3	NATURAL	ROLE WITH THE PRIVILEGES REQUIRED FOR A NATURAL CONTRIBUTOR	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
4	COMMERCIAL	ROLE WITH THE PRIVILEGES REQUIRED FOR A COMMERCIAL CONTRIBUTOR	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
2	ADMINTRADOR	ROLE WITH THE PRIVILEGES REQUIRED FOR A ADMINISTRATOR OF COLLECTION	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
6	FIRMA	ROLE WITH THE PRIVILEGES REQUIRED FOR A PERSONAL SIGNATURE CONTRIBUTOR	2024-10-14 22:29:30.954244	2024-10-14 22:29:30.954244	\N	\N	\N	\N	\N
5	INDUSTRIAL	ROLE WITH THE PRIVILEGES REQUIRED FOR A INDUSTRIAL CONTRIBUTOR	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
7	SUCESION	ROLE WITH THE PRIVILEGES REQUIRED FOR A LEGAL CONTRIBUTOR OF SECESSION	2024-10-14 22:31:59.348198	2024-10-14 22:31:59.348198	\N	\N	\N	\N	\N
\.


--
-- Data for Name: roles_privilege; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles_privilege (id, "roleId", "privilegeId", created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	1	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
2	1	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
3	1	3	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
4	1	4	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
5	1	5	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
6	1	6	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
7	1	7	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
8	1	8	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
9	2	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
10	2	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
11	2	6	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
12	2	7	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
13	2	8	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
14	3	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
15	3	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
16	3	3	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
17	3	4	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
18	3	5	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
19	2	9	2024-11-11 16:34:53.536	2024-11-11 16:34:53.536	\N	1	\N	\N	\N
20	2	10	2024-11-11 16:34:53.536	2024-11-11 16:34:53.536	\N	1	\N	\N	\N
21	2	11	2024-11-11 16:34:53.536	2024-11-11 16:34:53.536	\N	1	\N	\N	\N
\.


--
-- Data for Name: state; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.state (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "countryId") FROM stdin;
1	DTTO_CAPITAL	DTTO. CAPITAL	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
2	ANZOATEGUI	ANZOATEGUI	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
3	APURE	APURE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
4	ARAGUA	ARAGUA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
5	BARINAS	BARINAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
6	BOLIVAR	BOLIVAR	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
7	CARABOBO	CARABOBO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
8	COJEDES	COJEDES	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
9	FALCON	FALCON	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
10	GUARICO	GUARICO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
11	LARA	LARA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
12	MERIDA	MERIDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
13	MIRANDA	MIRANDA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
14	MONAGAS	MONAGAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
15	NUEVA_ESPARTA	NUEVA ESPARTA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
16	PORTUGUESA	PORTUGUESA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
17	SUCRE	SUCRE	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
18	TACHIRA	TACHIRA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
19	TRUJILLO	TRUJILLO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
20	YARACUY	YARACUY	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
21	ZULIA	ZULIA	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
22	AMAZONAS	AMAZONAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
23	DELTA_AMACURO	DELTA AMACURO	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
24	VARGAS	VARGAS	2024-06-26 23:02:27.391	2024-06-26 23:05:28.298	\N	1	\N	\N	\N	232
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status (id, code, description, apply_to, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
2	INACTIVE	logical state of deleted registers	all	2024-07-15 13:44:30.197311	2024-07-15 13:44:30.197311	\N	1	1	1	\N
1	ACTIVE	logical state of active registers	all	2024-07-15 13:42:34.889805	2024-07-15 13:42:34.889805	\N	1	1	1	\N
6	VERIFIED	verified transaction status	transactions	2024-11-06 22:41:12.316804	2024-11-06 22:41:12.316804	\N	1	1	1	\N
8	SUCCESS_REQUEST	status of external requests with successful response.	external_requests	2024-11-07 00:07:40.062805	2024-11-07 00:07:40.062805	\N	1	1	1	\N
9	ERROR_REQUEST	Status of external requests with error in response.	external_requests	2024-11-07 00:07:40.062805	2024-11-07 00:07:40.062805	\N	1	1	1	\N
7	WAITING_RESPONSE	status of external requests waiting for a response	external_requests	2024-11-07 00:07:40.062805	2024-11-07 00:07:40.062805	\N	1	1	1	\N
10	GENERATED	status of tax stamps generated pending payment	stamps	2024-11-07 00:07:40.062805	2024-11-07 00:07:40.062805	\N	1	1	1	\N
3	UNCONFIRMED	status for unconfirmed payments	payments	2024-11-05 21:19:06.172716	2024-11-05 21:19:06.172716	\N	1	1	1	\N
4	CONFIRMED	status for confirmed payments	payments	2024-11-05 21:19:54.240486	2024-11-05 21:19:54.240486	\N	1	1	1	\N
5	REQUESTED	status of requested transactions	transactions	2024-11-06 22:41:12.312778	2024-11-06 22:41:12.312778	\N	1	1	1	\N
11	PAID	status of tax stamps paid	stamps	2024-11-07 00:07:40.062805	2024-11-07 00:07:40.062805	\N	1	1	1	\N
12	CANCELED	status of tax stamps canceled	stamps	2024-11-07 00:07:40.062805	2024-11-07 00:07:40.062805	\N	1	1	1	\N
13	EXEMPT	Status of tax stamps exempted due to special conditions of the type of contributor	stamps	2024-11-07 00:07:40.062805	2024-11-07 00:07:40.062805	\N	1	1	1	\N
14	RECEIVED	Status of tax stamps received by the corresponding entity	stamps	2024-11-07 00:07:40.062805	2024-11-07 00:07:40.062805	\N	1	1	1	\N
\.


--
-- Data for Name: subentity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subentity (id, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "entityId", code) FROM stdin;
25	REGION CENTRAL	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	3	0025
26	ADUANA PRINCIPAL AEREA DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	3	0026
27	ADUANA PRINCIPAL PUERTO CABELLO	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	3	0027
28	SOTARN	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	4	0028
29	SECRETARIA DE HACIENDA Y FINANZAS	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	4	0029
1	REGISTRO PRINCIPAL CIVIL 	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0001
2	REGISTRO PUBLICO PRIMER CIRCUITO DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0002
3	REGISTRO PUBLICO SEGUNDO CIRCUITO DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0003
4	REGISTRO PUBLICO DE LOS MUNICIPIOS GUACARA, SAN JOAQUIN Y DIEGO�IBARRA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0004
5	REGISTRO PUBLICO DE LOS MUNICIPIOS NAGUANAGUA Y SAN DIEGO	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0005
6	REGISTRO PUBLICO DEL MUNICIPIO MONTALBAN	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0006
7	REGISTRO PUBLICO CON FUNCIONES NOTARIALES DEL MUNICIPIO CARLOS ARVELO	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0007
8	REGISTRO PUBLICO DEL MUNICIPIO BEJUMA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0008
9	REGISTRO PUBLICO DEL MUNICIPIO PUERTO CABELLO	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0009
10	REGISTRO MERCANTIL PRIMERO DE LA CIRCUNSCRIPCION JUDICIAL DEL ESTADO CARABOBO	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0010
11	REGISTRO MERCANTIL  SEGUNDO DE LA CIRCUNSCRIPCION JUDICIAL DEL ESTADO CARABOBO	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0011
12	REGISTRO MERCANTIL   TERCERO DE LA CIRCUNSCRIPCION JUDICIAL DEL ESTADO CARABOBO	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0012
13	NOTARIA PRIMERA DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0013
14	NOTARIA SEGUNDA DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0014
15	NOTARIA TERCERA DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0015
16	NOTARIA CUARTA DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0016
17	NOTARIA  QUINTA DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0017
18	NOTARIA SEXTA DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0018
19	NOTARIA SEPTIMA DE VALENCIA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0019
20	NOTARIA PUBLICA PRIMERA DE PUERTO CABELLO	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0020
21	NOTARIA PUBLICA  SEGUNDA DE PUERTO CABELLO	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0021
22	NOTARIA PUBLICA DE GUACARA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0022
23	NOTARIA PUBLICA DE BEJUMA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0023
24	URB. GUAPARO,  AV. LOS COLEGIOS	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	2	0024
\.


--
-- Data for Name: tax_stamp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_stamp (id, code, amount, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "userId", "procedureId", "calculationFactorId", number_folios, year) FROM stdin;
206	10001000320240000001	2402.7684215	2024-11-09 21:05:15.631787	2024-11-09 21:05:15.631787	\N	\N	\N	\N	\N	2	3	\N	1	2024
207	10001000320240000002	2402.7684215	2024-11-09 21:05:15.655115	2024-11-09 21:05:15.655115	\N	\N	\N	\N	\N	2	3	\N	1	2024
208	10001000220240000003	2402.7684215	2024-11-09 21:05:15.722721	2024-11-09 21:05:15.722721	\N	\N	\N	\N	\N	2	2	\N	1	2024
209	10001000420240000003	2402.7684215	2024-11-09 21:05:15.738898	2024-11-09 21:05:15.738898	\N	\N	\N	\N	\N	2	4	\N	1	2024
210	10001000220240000004	2402.7684215	2024-11-09 21:05:15.76181	2024-11-09 21:05:15.76181	\N	\N	\N	\N	\N	2	2	\N	1	2024
211	10001000220240000006	2402.7684215	2024-11-09 21:05:15.785377	2024-11-09 21:05:15.785377	\N	\N	\N	\N	\N	2	2	\N	1	2024
212	10001000320240000007	2402.7684215	2024-11-09 21:08:20.983082	2024-11-09 21:08:20.983082	\N	\N	\N	\N	\N	2	3	\N	1	2024
213	10001000320240000008	2402.7684215	2024-11-09 21:08:21.000918	2024-11-09 21:08:21.000918	\N	\N	\N	\N	\N	2	3	\N	1	2024
214	10001000220240000009	2402.7684215	2024-11-09 21:08:21.033686	2024-11-09 21:08:21.033686	\N	\N	\N	\N	\N	2	2	\N	1	2024
215	10001000420240000009	2402.7684215	2024-11-09 21:08:21.038895	2024-11-09 21:08:21.038895	\N	\N	\N	\N	\N	2	4	\N	1	2024
216	10001000220240000010	2402.7684215	2024-11-09 21:08:21.047409	2024-11-09 21:08:21.047409	\N	\N	\N	\N	\N	2	2	\N	1	2024
217	10001000220240000012	2402.7684215	2024-11-09 21:08:21.055745	2024-11-09 21:08:21.055745	\N	\N	\N	\N	\N	2	2	\N	1	2024
218	10001000320240000013	2402.7684215	2024-11-10 16:52:03.150987	2024-11-10 16:52:03.150987	\N	\N	\N	\N	\N	2	3	\N	1	2024
219	10001000320240000014	2402.7684215	2024-11-10 16:52:03.164285	2024-11-10 16:52:03.164285	\N	\N	\N	\N	\N	2	3	\N	1	2024
220	10001000420240000015	2402.7684215	2024-11-10 16:52:03.203737	2024-11-10 16:52:03.203737	\N	\N	\N	\N	\N	2	4	\N	1	2024
221	10001000220240000015	2402.7684215	2024-11-10 16:52:03.209111	2024-11-10 16:52:03.209111	\N	\N	\N	\N	\N	2	2	\N	1	2024
222	10001000220240000017	2402.7684215	2024-11-10 16:52:03.221523	2024-11-10 16:52:03.221523	\N	\N	\N	\N	\N	2	2	\N	1	2024
223	10001000220240000018	2402.7684215	2024-11-10 16:52:03.231715	2024-11-10 16:52:03.231715	\N	\N	\N	\N	\N	2	2	\N	1	2024
224	10001000320240000019	2402.7684215	2024-11-10 16:52:57.694048	2024-11-10 16:52:57.694048	\N	\N	\N	\N	\N	2	3	\N	1	2024
225	10001000320240000020	2402.7684215	2024-11-10 16:52:57.710556	2024-11-10 16:52:57.710556	\N	\N	\N	\N	\N	2	3	\N	1	2024
226	10001000220240000021	2402.7684215	2024-11-10 16:52:57.743055	2024-11-10 16:52:57.743055	\N	\N	\N	\N	\N	2	2	\N	1	2024
227	10001000420240000021	2402.7684215	2024-11-10 16:52:57.746447	2024-11-10 16:52:57.746447	\N	\N	\N	\N	\N	2	4	\N	1	2024
228	10001000220240000022	2402.7684215	2024-11-10 16:52:57.754358	2024-11-10 16:52:57.754358	\N	\N	\N	\N	\N	2	2	\N	1	2024
229	10001000220240000024	2402.7684215	2024-11-10 16:52:57.761144	2024-11-10 16:52:57.761144	\N	\N	\N	\N	\N	2	2	\N	1	2024
230	10001000320240000025	2380.3977815	2024-11-13 21:29:06.882417	2024-11-13 21:29:06.882417	\N	\N	\N	\N	\N	2	3	\N	1	2024
231	10001000320240000026	2380.3977815	2024-11-13 21:29:06.898927	2024-11-13 21:29:06.898927	\N	\N	\N	\N	\N	2	3	\N	1	2024
232	10001000220240000027	2380.3977815	2024-11-13 21:29:06.939364	2024-11-13 21:29:06.939364	\N	\N	\N	\N	\N	2	2	\N	1	2024
233	10001000420240000027	2380.3977815	2024-11-13 21:29:06.947726	2024-11-13 21:29:06.947726	\N	\N	\N	\N	\N	2	4	\N	1	2024
234	10001000220240000028	2380.3977815	2024-11-13 21:29:06.955526	2024-11-13 21:29:06.955526	\N	\N	\N	\N	\N	2	2	\N	1	2024
235	10001000220240000030	2380.3977815	2024-11-13 21:29:06.962677	2024-11-13 21:29:06.962677	\N	\N	\N	\N	\N	2	2	\N	1	2024
236	10001000320240000031	2380.3977815	2024-11-13 21:36:47.933557	2024-11-13 21:36:47.933557	\N	\N	\N	\N	\N	2	3	\N	1	2024
237	10001000320240000032	2380.3977815	2024-11-13 21:36:47.957222	2024-11-13 21:36:47.957222	\N	\N	\N	\N	\N	2	3	\N	1	2024
238	10001000220240000033	2380.3977815	2024-11-13 21:36:47.988734	2024-11-13 21:36:47.988734	\N	\N	\N	\N	\N	2	2	\N	1	2024
239	10001000420240000033	2380.3977815	2024-11-13 21:36:47.996735	2024-11-13 21:36:47.996735	\N	\N	\N	\N	\N	2	4	\N	1	2024
240	10001000220240000034	2380.3977815	2024-11-13 21:36:48.006584	2024-11-13 21:36:48.006584	\N	\N	\N	\N	\N	2	2	\N	1	2024
241	10001000220240000036	2380.3977815	2024-11-13 21:36:48.016107	2024-11-13 21:36:48.016107	\N	\N	\N	\N	\N	2	2	\N	1	2024
242	10001000320240000037	2380.3977815	2024-11-13 21:37:14.43391	2024-11-13 21:37:14.43391	\N	\N	\N	\N	\N	2	3	\N	1	2024
243	10001000320240000038	2380.3977815	2024-11-13 21:37:14.452957	2024-11-13 21:37:14.452957	\N	\N	\N	\N	\N	2	3	\N	1	2024
244	10001000420240000039	2380.3977815	2024-11-13 21:37:14.4887	2024-11-13 21:37:14.4887	\N	\N	\N	\N	\N	2	4	\N	1	2024
245	10001000220240000039	2380.3977815	2024-11-13 21:37:14.489445	2024-11-13 21:37:14.489445	\N	\N	\N	\N	\N	2	2	\N	1	2024
246	10001000220240000041	2380.3977815	2024-11-13 21:37:14.506019	2024-11-13 21:37:14.506019	\N	\N	\N	\N	\N	2	2	\N	1	2024
247	10001000220240000042	2380.3977815	2024-11-13 21:37:14.51768	2024-11-13 21:37:14.51768	\N	\N	\N	\N	\N	2	2	\N	1	2024
248	10001000320240000043	2380.3977815	2024-11-13 21:38:13.500815	2024-11-13 21:38:13.500815	\N	\N	\N	\N	\N	2	3	\N	1	2024
249	10001000320240000044	2380.3977815	2024-11-13 21:38:13.517436	2024-11-13 21:38:13.517436	\N	\N	\N	\N	\N	2	3	\N	1	2024
250	10001000220240000045	2380.3977815	2024-11-13 21:38:13.549556	2024-11-13 21:38:13.549556	\N	\N	\N	\N	\N	2	2	\N	1	2024
251	10001000420240000045	2380.3977815	2024-11-13 21:38:13.553092	2024-11-13 21:38:13.553092	\N	\N	\N	\N	\N	2	4	\N	1	2024
252	10001000220240000046	2380.3977815	2024-11-13 21:38:13.562024	2024-11-13 21:38:13.562024	\N	\N	\N	\N	\N	2	2	\N	1	2024
253	10001000220240000048	2380.3977815	2024-11-13 21:38:13.567997	2024-11-13 21:38:13.567997	\N	\N	\N	\N	\N	2	2	\N	1	2024
260	10001000320240000055	2380.3977815	2024-11-13 21:40:24.565224	2024-11-13 21:40:24.565224	\N	\N	\N	\N	\N	2	3	\N	1	2024
261	10001000320240000056	2380.3977815	2024-11-13 21:40:24.582598	2024-11-13 21:40:24.582598	\N	\N	\N	\N	\N	2	3	\N	1	2024
262	10001000220240000057	2380.3977815	2024-11-13 21:40:24.648859	2024-11-13 21:40:24.648859	\N	\N	\N	\N	\N	2	2	\N	1	2024
263	10001000420240000057	2380.3977815	2024-11-13 21:40:24.664271	2024-11-13 21:40:24.664271	\N	\N	\N	\N	\N	2	4	\N	1	2024
264	10001000220240000058	2380.3977815	2024-11-13 21:40:24.681833	2024-11-13 21:40:24.681833	\N	\N	\N	\N	\N	2	2	\N	1	2024
265	10001000220240000060	2380.3977815	2024-11-13 21:40:24.69239	2024-11-13 21:40:24.69239	\N	\N	\N	\N	\N	2	2	\N	1	2024
266	10001000320240000061	2380.3977815	2024-11-13 21:41:45.164451	2024-11-13 21:41:45.164451	\N	\N	\N	\N	\N	2	3	\N	1	2024
267	10001000320240000062	2380.3977815	2024-11-13 21:41:45.185563	2024-11-13 21:41:45.185563	\N	\N	\N	\N	\N	2	3	\N	1	2024
268	10001000420240000063	2380.3977815	2024-11-13 21:41:45.221582	2024-11-13 21:41:45.221582	\N	\N	\N	\N	\N	2	4	\N	1	2024
269	10001000220240000063	2380.3977815	2024-11-13 21:41:45.225513	2024-11-13 21:41:45.225513	\N	\N	\N	\N	\N	2	2	\N	1	2024
270	10001000220240000065	2380.3977815	2024-11-13 21:41:45.238928	2024-11-13 21:41:45.238928	\N	\N	\N	\N	\N	2	2	\N	1	2024
271	10001000220240000066	2380.3977815	2024-11-13 21:41:45.250522	2024-11-13 21:41:45.250522	\N	\N	\N	\N	\N	2	2	\N	1	2024
272	10001000320240000067	2380.3977815	2024-11-13 21:42:35.935829	2024-11-13 21:42:35.935829	\N	\N	\N	\N	\N	2	3	\N	1	2024
273	10001000320240000068	2380.3977815	2024-11-13 21:42:35.960566	2024-11-13 21:42:35.960566	\N	\N	\N	\N	\N	2	3	\N	1	2024
274	10001000220240000069	2380.3977815	2024-11-13 21:42:36.00456	2024-11-13 21:42:36.00456	\N	\N	\N	\N	\N	2	2	\N	1	2024
275	10001000420240000069	2380.3977815	2024-11-13 21:42:36.005269	2024-11-13 21:42:36.005269	\N	\N	\N	\N	\N	2	4	\N	1	2024
255	10001000320240000050	2380.3977815	2024-11-13 21:39:00.509779	2024-11-14 00:02:50.138604	\N	11	\N	\N	\N	2	3	\N	1	2024
256	10001000220240000051	2380.3977815	2024-11-13 21:39:00.553829	2024-11-14 00:02:50.150723	\N	11	\N	\N	\N	2	2	\N	1	2024
259	10001000220240000054	2380.3977815	2024-11-13 21:39:00.571822	2024-11-14 00:02:50.1571	\N	11	\N	\N	\N	2	2	\N	1	2024
276	10001000220240000070	2380.3977815	2024-11-13 21:42:36.020467	2024-11-13 21:42:36.020467	\N	\N	\N	\N	\N	2	2	\N	1	2024
277	10001000220240000072	2380.3977815	2024-11-13 21:42:36.032445	2024-11-13 21:42:36.032445	\N	\N	\N	\N	\N	2	2	\N	1	2024
278	10001000320240000073	2380.3977815	2024-11-13 21:46:36.668711	2024-11-13 21:46:36.668711	\N	\N	\N	\N	\N	2	3	\N	1	2024
279	10001000320240000074	2380.3977815	2024-11-13 21:46:36.687882	2024-11-13 21:46:36.687882	\N	\N	\N	\N	\N	2	3	\N	1	2024
280	10001000220240000075	2380.3977815	2024-11-13 21:46:36.723172	2024-11-13 21:46:36.723172	\N	\N	\N	\N	\N	2	2	\N	1	2024
281	10001000420240000075	2380.3977815	2024-11-13 21:46:36.723991	2024-11-13 21:46:36.723991	\N	\N	\N	\N	\N	2	4	\N	1	2024
282	10001000220240000076	2380.3977815	2024-11-13 21:46:36.736462	2024-11-13 21:46:36.736462	\N	\N	\N	\N	\N	2	2	\N	1	2024
283	10001000220240000078	2380.3977815	2024-11-13 21:46:36.747261	2024-11-13 21:46:36.747261	\N	\N	\N	\N	\N	2	2	\N	1	2024
254	10001000320240000049	2380.3977815	2024-11-13 21:39:00.496452	2024-11-14 00:02:50.068924	\N	11	\N	\N	\N	2	3	\N	1	2024
258	10001000220240000052	2380.3977815	2024-11-13 21:39:00.565423	2024-11-14 00:02:50.158838	\N	11	\N	\N	\N	2	2	\N	1	2024
257	10001000420240000051	2380.3977815	2024-11-13 21:39:00.557852	2024-11-14 00:02:50.160105	\N	11	\N	\N	\N	2	4	\N	1	2024
316	10001000320240000002	2412.849538	2024-11-16 17:36:07.051862	2024-11-16 17:36:07.051862	\N	10	\N	\N	\N	\N	3	\N	1	2024
317	10001000320240000004	2412.849538	2024-11-16 17:36:07.163361	2024-11-16 17:36:07.163361	\N	10	\N	\N	\N	\N	3	\N	1	2024
318	10001000320240000005	2412.849538	2024-11-16 17:36:07.164755	2024-11-16 17:36:07.164755	\N	10	\N	\N	\N	\N	3	\N	1	2024
319	10001000320240000006	2412.849538	2024-11-16 17:36:07.166424	2024-11-16 17:36:07.166424	\N	10	\N	\N	\N	\N	3	\N	1	2024
320	10001000320240000003	2412.849538	2024-11-16 17:36:07.168804	2024-11-16 17:36:07.168804	\N	10	\N	\N	\N	\N	3	\N	1	2024
321	10001000320240000007	2412.849538	2024-11-16 17:36:07.170686	2024-11-16 17:36:07.170686	\N	10	\N	\N	\N	\N	3	\N	1	2024
322	10001000320240000002	2412.849538	2024-11-16 17:37:05.607985	2024-11-16 17:37:05.607985	\N	10	\N	\N	\N	\N	3	\N	1	2024
323	10001000320240000003	2412.849538	2024-11-16 17:37:05.679304	2024-11-16 17:37:05.679304	\N	10	\N	\N	\N	\N	3	\N	1	2024
324	10001000320240000004	2412.849538	2024-11-16 17:37:05.676954	2024-11-16 17:37:05.676954	\N	10	\N	\N	\N	\N	3	\N	1	2024
325	10001000320240000007	2412.849538	2024-11-16 17:37:05.725252	2024-11-16 17:37:05.725252	\N	10	\N	\N	\N	\N	3	\N	1	2024
326	10001000320240000006	2412.849538	2024-11-16 17:37:05.727313	2024-11-16 17:37:05.727313	\N	10	\N	\N	\N	\N	3	\N	1	2024
327	10001000320240000005	2412.849538	2024-11-16 17:37:05.729057	2024-11-16 17:37:05.729057	\N	10	\N	\N	\N	\N	3	\N	1	2024
328	10001000320240000002	2412.849538	2024-11-16 17:37:44.99237	2024-11-16 17:37:44.99237	\N	10	\N	\N	\N	\N	3	\N	1	2024
285	10001000320240000080	2403.588726	2024-11-14 21:25:36.858615	2024-11-14 21:46:35.743744	\N	11	\N	\N	\N	2	3	\N	1	2024
284	10001000320240000079	2403.588726	2024-11-14 21:25:36.844037	2024-11-14 21:46:35.746473	\N	11	\N	\N	\N	2	3	\N	1	2024
288	10001000220240000083	2403.588726	2024-11-14 21:25:36.948362	2024-11-14 21:46:35.748632	\N	11	\N	\N	\N	2	2	\N	1	2024
286	10001000420240000081	2403.588726	2024-11-14 21:25:36.918055	2024-11-14 21:46:35.750813	\N	11	\N	\N	\N	2	4	\N	1	2024
287	10001000220240000081	2403.588726	2024-11-14 21:25:36.929701	2024-11-14 21:46:35.752984	\N	11	\N	\N	\N	2	2	\N	1	2024
289	10001000220240000084	2403.588726	2024-11-14 21:25:36.961079	2024-11-14 21:46:35.755195	\N	11	\N	\N	\N	2	2	\N	1	2024
290	10001000320240000001	2403.588726	2024-11-14 22:45:02.563215	2024-11-14 22:45:02.563215	\N	\N	\N	\N	\N	2	3	\N	1	2024
291	10001000320240000002	2403.588726	2024-11-14 22:45:02.597917	2024-11-14 22:45:02.597917	\N	\N	\N	\N	\N	2	3	\N	1	2024
292	10001000220240000003	2403.588726	2024-11-14 22:45:02.673756	2024-11-14 22:45:02.673756	\N	\N	\N	\N	\N	2	2	\N	1	2024
293	10001000420240000004	2403.588726	2024-11-14 22:45:02.6757	2024-11-14 22:45:02.6757	\N	\N	\N	\N	\N	2	4	\N	1	2024
294	10001000220240000005	2403.588726	2024-11-14 22:45:02.702493	2024-11-14 22:45:02.702493	\N	\N	\N	\N	\N	2	2	\N	1	2024
295	10001000220240000006	2403.588726	2024-11-14 22:45:02.718721	2024-11-14 22:45:02.718721	\N	\N	\N	\N	\N	2	2	\N	1	2024
298	10001000320240000002	2403.588726	2024-11-14 23:10:49.173404	2024-11-14 23:10:49.173404	\N	10	\N	\N	\N	2	3	\N	1	2024
299	10001000320240000003	2403.588726	2024-11-14 23:11:03.491816	2024-11-14 23:11:03.491816	\N	10	\N	\N	\N	2	3	\N	1	2024
300	10001000320240000004	2403.588726	2024-11-14 23:11:12.184967	2024-11-14 23:11:12.184967	\N	10	\N	\N	\N	2	3	\N	1	2024
301	10001000320240000005	2403.588726	2024-11-14 23:11:14.006876	2024-11-14 23:11:14.006876	\N	10	\N	\N	\N	2	3	\N	1	2024
302	10001000320240000006	2403.588726	2024-11-14 23:11:15.750581	2024-11-14 23:11:15.750581	\N	10	\N	\N	\N	2	3	\N	1	2024
303	10001000320240000007	2403.588726	2024-11-14 23:11:17.105947	2024-11-14 23:11:17.105947	\N	10	\N	\N	\N	2	3	\N	1	2024
304	10001000320240000008	2412.849538	2024-11-16 17:07:44.517529	2024-11-16 17:08:48.139158	\N	11	\N	\N	\N	2	3	\N	1	2024
305	10001000320240000009	2412.849538	2024-11-16 17:07:44.53509	2024-11-16 17:08:48.21361	\N	11	\N	\N	\N	2	3	\N	1	2024
306	10001000420240000010	2412.849538	2024-11-16 17:07:44.583284	2024-11-16 17:08:48.214971	\N	11	\N	\N	\N	2	4	\N	1	2024
329	10001000320240000003	2412.849538	2024-11-16 17:37:45.052408	2024-11-16 17:37:45.052408	\N	10	\N	\N	\N	\N	3	\N	1	2024
330	10001000320240000005	2412.849538	2024-11-16 17:37:45.111546	2024-11-16 17:37:45.111546	\N	10	\N	\N	\N	\N	3	\N	1	2024
331	10001000320240000006	2412.849538	2024-11-16 17:37:45.112849	2024-11-16 17:37:45.112849	\N	10	\N	\N	\N	\N	3	\N	1	2024
332	10001000320240000004	2412.849538	2024-11-16 17:37:45.114372	2024-11-16 17:37:45.114372	\N	10	\N	\N	\N	\N	3	\N	1	2024
333	10001000320240000007	2412.849538	2024-11-16 17:37:45.115871	2024-11-16 17:37:45.115871	\N	10	\N	\N	\N	\N	3	\N	1	2024
334	10001000320240000002	2412.849538	2024-11-16 17:38:11.225904	2024-11-16 17:38:11.225904	\N	10	\N	\N	\N	\N	3	\N	1	2024
307	10001000220240000011	2412.849538	2024-11-16 17:07:44.584281	2024-11-16 17:08:48.221841	\N	11	\N	\N	\N	2	2	\N	1	2024
309	10001000220240000013	2412.849538	2024-11-16 17:07:44.608142	2024-11-16 17:08:48.229166	\N	11	\N	\N	\N	2	2	\N	1	2024
308	10001000220240000012	2412.849538	2024-11-16 17:07:44.599887	2024-11-16 17:08:48.230716	\N	11	\N	\N	\N	2	2	\N	1	2024
310	10001000320240000002	2412.849538	2024-11-16 17:27:48.707514	2024-11-16 17:27:48.707514	\N	10	\N	\N	\N	\N	3	\N	1	2024
311	10001000320240000005	2412.849538	2024-11-16 17:27:48.805331	2024-11-16 17:27:48.805331	\N	10	\N	\N	\N	\N	3	\N	1	2024
312	10001000320240000004	2412.849538	2024-11-16 17:27:48.807812	2024-11-16 17:27:48.807812	\N	10	\N	\N	\N	\N	3	\N	1	2024
313	10001000320240000006	2412.849538	2024-11-16 17:27:48.814233	2024-11-16 17:27:48.814233	\N	10	\N	\N	\N	\N	3	\N	1	2024
314	10001000320240000007	2412.849538	2024-11-16 17:27:48.816486	2024-11-16 17:27:48.816486	\N	10	\N	\N	\N	\N	3	\N	1	2024
315	10001000320240000003	2412.849538	2024-11-16 17:27:48.849932	2024-11-16 17:27:48.849932	\N	10	\N	\N	\N	\N	3	\N	1	2024
335	10001000320240000004	2412.849538	2024-11-16 17:38:11.314044	2024-11-16 17:38:11.314044	\N	10	\N	\N	\N	\N	3	\N	1	2024
336	10001000320240000003	2412.849538	2024-11-16 17:38:11.345607	2024-11-16 17:38:11.345607	\N	10	\N	\N	\N	\N	3	\N	1	2024
337	10001000320240000005	2412.849538	2024-11-16 17:38:11.349653	2024-11-16 17:38:11.349653	\N	10	\N	\N	\N	\N	3	\N	1	2024
338	10001000320240000007	2412.849538	2024-11-16 17:38:11.358622	2024-11-16 17:38:11.358622	\N	10	\N	\N	\N	\N	3	\N	1	2024
339	10001000320240000006	2412.849538	2024-11-16 17:38:11.365138	2024-11-16 17:38:11.365138	\N	10	\N	\N	\N	\N	3	\N	1	2024
340	10001000320240000002	2412.849538	2024-11-16 17:39:16.586803	2024-11-16 17:39:16.586803	\N	10	\N	\N	\N	\N	3	\N	1	2024
341	10001000320240000003	2412.849538	2024-11-16 17:39:16.651192	2024-11-16 17:39:16.651192	\N	10	\N	\N	\N	\N	3	\N	1	2024
342	10001000320240000004	2412.849538	2024-11-16 17:39:16.665172	2024-11-16 17:39:16.665172	\N	10	\N	\N	\N	\N	3	\N	1	2024
343	10001000320240000007	2412.849538	2024-11-16 17:39:16.707949	2024-11-16 17:39:16.707949	\N	10	\N	\N	\N	\N	3	\N	1	2024
344	10001000320240000006	2412.849538	2024-11-16 17:39:16.709378	2024-11-16 17:39:16.709378	\N	10	\N	\N	\N	\N	3	\N	1	2024
345	10001000320240000005	2412.849538	2024-11-16 17:39:16.711273	2024-11-16 17:39:16.711273	\N	10	\N	\N	\N	\N	3	\N	1	2024
346	10001000320240000002	2412.849538	2024-11-16 17:42:37.121331	2024-11-16 17:42:37.121331	\N	10	\N	\N	\N	\N	3	\N	1	2024
347	10001000320240000003	2412.849538	2024-11-16 17:42:37.174215	2024-11-16 17:42:37.174215	\N	10	\N	\N	\N	\N	3	\N	1	2024
348	10001000320240000004	2412.849538	2024-11-16 17:42:37.237085	2024-11-16 17:42:37.237085	\N	10	\N	\N	\N	\N	3	\N	1	2024
349	10001000320240000005	2412.849538	2024-11-16 17:42:37.238602	2024-11-16 17:42:37.238602	\N	10	\N	\N	\N	\N	3	\N	1	2024
350	10001000320240000007	2412.849538	2024-11-16 17:42:37.240227	2024-11-16 17:42:37.240227	\N	10	\N	\N	\N	\N	3	\N	1	2024
351	10001000320240000006	2412.849538	2024-11-16 17:42:37.241886	2024-11-16 17:42:37.241886	\N	10	\N	\N	\N	\N	3	\N	1	2024
352	10001000320240000002	2412.849538	2024-11-16 17:46:25.46778	2024-11-16 17:46:25.46778	\N	10	\N	\N	\N	\N	3	\N	1	2024
353	10001000320240000003	2412.849538	2024-11-16 17:46:25.556589	2024-11-16 17:46:25.556589	\N	10	\N	\N	\N	\N	3	\N	1	2024
354	10001000320240000007	2412.849538	2024-11-16 17:46:25.580633	2024-11-16 17:46:25.580633	\N	10	\N	\N	\N	\N	3	\N	1	2024
355	10001000320240000004	2412.849538	2024-11-16 17:46:25.582781	2024-11-16 17:46:25.582781	\N	10	\N	\N	\N	\N	3	\N	1	2024
356	10001000320240000006	2412.849538	2024-11-16 17:46:25.585943	2024-11-16 17:46:25.585943	\N	10	\N	\N	\N	\N	3	\N	1	2024
357	10001000320240000005	2412.849538	2024-11-16 17:46:25.616344	2024-11-16 17:46:25.616344	\N	10	\N	\N	\N	\N	3	\N	1	2024
358	10001000320240000002	2412.849538	2024-11-16 17:47:48.219754	2024-11-16 17:47:48.219754	\N	10	\N	\N	\N	\N	3	\N	1	2024
359	10001000320240000005	2412.849538	2024-11-16 17:47:48.33256	2024-11-16 17:47:48.33256	\N	10	\N	\N	\N	\N	3	\N	1	2024
360	10001000320240000006	2412.849538	2024-11-16 17:47:48.334407	2024-11-16 17:47:48.334407	\N	10	\N	\N	\N	\N	3	\N	1	2024
361	10001000320240000003	2412.849538	2024-11-16 17:47:48.336204	2024-11-16 17:47:48.336204	\N	10	\N	\N	\N	\N	3	\N	1	2024
362	10001000320240000007	2412.849538	2024-11-16 17:47:48.337754	2024-11-16 17:47:48.337754	\N	10	\N	\N	\N	\N	3	\N	1	2024
363	10001000320240000004	2412.849538	2024-11-16 17:47:48.339573	2024-11-16 17:47:48.339573	\N	10	\N	\N	\N	\N	3	\N	1	2024
364	10001000320240000002	2412.849538	2024-11-16 17:49:07.960825	2024-11-16 17:49:07.960825	\N	10	\N	\N	\N	\N	3	\N	1	2024
365	10001000320240000003	2412.849538	2024-11-16 17:49:08.034514	2024-11-16 17:49:08.034514	\N	10	\N	\N	\N	\N	3	\N	1	2024
366	10001000320240000005	2412.849538	2024-11-16 17:49:08.051618	2024-11-16 17:49:08.051618	\N	10	\N	\N	\N	\N	3	\N	1	2024
367	10001000320240000004	2412.849538	2024-11-16 17:49:08.055411	2024-11-16 17:49:08.055411	\N	10	\N	\N	\N	\N	3	\N	1	2024
368	10001000320240000007	2412.849538	2024-11-16 17:49:08.088604	2024-11-16 17:49:08.088604	\N	10	\N	\N	\N	\N	3	\N	1	2024
369	10001000320240000006	2412.849538	2024-11-16 17:49:08.090774	2024-11-16 17:49:08.090774	\N	10	\N	\N	\N	\N	3	\N	1	2024
370	10001000320240000002	2412.849538	2024-11-16 17:54:06.427477	2024-11-16 17:54:06.427477	\N	10	\N	\N	\N	\N	3	\N	1	2024
371	10001000320240000003	2412.849538	2024-11-16 17:54:06.50863	2024-11-16 17:54:06.50863	\N	10	\N	\N	\N	\N	3	\N	1	2024
372	10001000320240000004	2412.849538	2024-11-16 17:54:06.531552	2024-11-16 17:54:06.531552	\N	10	\N	\N	\N	\N	3	\N	1	2024
373	10001000320240000007	2412.849538	2024-11-16 17:54:06.533837	2024-11-16 17:54:06.533837	\N	10	\N	\N	\N	\N	3	\N	1	2024
374	10001000320240000005	2412.849538	2024-11-16 17:54:06.536659	2024-11-16 17:54:06.536659	\N	10	\N	\N	\N	\N	3	\N	1	2024
375	10001000320240000006	2412.849538	2024-11-16 17:54:06.561463	2024-11-16 17:54:06.561463	\N	10	\N	\N	\N	\N	3	\N	1	2024
376	10001000320240000002	2412.849538	2024-11-16 17:55:04.694448	2024-11-16 17:55:04.694448	\N	10	\N	\N	\N	\N	3	\N	1	2024
377	10001000320240000003	2412.849538	2024-11-16 17:55:04.765471	2024-11-16 17:55:04.765471	\N	10	\N	\N	\N	\N	3	\N	1	2024
378	10001000320240000005	2412.849538	2024-11-16 17:55:04.786427	2024-11-16 17:55:04.786427	\N	10	\N	\N	\N	\N	3	\N	1	2024
379	10001000320240000004	2412.849538	2024-11-16 17:55:04.813958	2024-11-16 17:55:04.813958	\N	10	\N	\N	\N	\N	3	\N	1	2024
380	10001000320240000006	2412.849538	2024-11-16 17:55:04.832646	2024-11-16 17:55:04.832646	\N	10	\N	\N	\N	\N	3	\N	1	2024
381	10001000320240000007	2412.849538	2024-11-16 17:55:04.835671	2024-11-16 17:55:04.835671	\N	10	\N	\N	\N	\N	3	\N	1	2024
382	10001000320240000002	2412.849538	2024-11-16 17:56:21.26524	2024-11-16 17:56:21.26524	\N	10	\N	\N	\N	\N	3	\N	1	2024
383	10001000320240000003	2412.849538	2024-11-16 17:56:21.316566	2024-11-16 17:56:21.316566	\N	10	\N	\N	\N	\N	3	\N	1	2024
384	10001000320240000005	2412.849538	2024-11-16 17:56:21.368265	2024-11-16 17:56:21.368265	\N	10	\N	\N	\N	\N	3	\N	1	2024
385	10001000320240000007	2412.849538	2024-11-16 17:56:21.370883	2024-11-16 17:56:21.370883	\N	10	\N	\N	\N	\N	3	\N	1	2024
386	10001000320240000006	2412.849538	2024-11-16 17:56:21.373122	2024-11-16 17:56:21.373122	\N	10	\N	\N	\N	\N	3	\N	1	2024
387	10001000320240000004	2412.849538	2024-11-16 17:56:21.411019	2024-11-16 17:56:21.411019	\N	10	\N	\N	\N	\N	3	\N	1	2024
388	10001000320240000002	2412.849538	2024-11-16 17:59:28.651378	2024-11-16 17:59:28.651378	\N	10	\N	\N	\N	\N	3	\N	1	2024
389	10001000320240000003	2412.849538	2024-11-16 17:59:28.72912	2024-11-16 17:59:28.72912	\N	10	\N	\N	\N	\N	3	\N	1	2024
390	10001000320240000004	2412.849538	2024-11-16 17:59:28.73151	2024-11-16 17:59:28.73151	\N	10	\N	\N	\N	\N	3	\N	1	2024
391	10001000320240000007	2412.849538	2024-11-16 17:59:28.769618	2024-11-16 17:59:28.769618	\N	10	\N	\N	\N	\N	3	\N	1	2024
392	10001000320240000005	2412.849538	2024-11-16 17:59:28.785692	2024-11-16 17:59:28.785692	\N	10	\N	\N	\N	\N	3	\N	1	2024
393	10001000320240000006	2412.849538	2024-11-16 17:59:28.788938	2024-11-16 17:59:28.788938	\N	10	\N	\N	\N	\N	3	\N	1	2024
394	10001000320240000002	2412.849538	2024-11-16 18:01:46.095087	2024-11-16 18:01:46.095087	\N	10	\N	\N	\N	\N	3	\N	1	2024
395	10001000320240000003	2412.849538	2024-11-16 18:01:46.146766	2024-11-16 18:01:46.146766	\N	10	\N	\N	\N	\N	3	\N	1	2024
396	10001000320240000005	2412.849538	2024-11-16 18:01:46.213663	2024-11-16 18:01:46.213663	\N	10	\N	\N	\N	\N	3	\N	1	2024
397	10001000320240000004	2412.849538	2024-11-16 18:01:46.214964	2024-11-16 18:01:46.214964	\N	10	\N	\N	\N	\N	3	\N	1	2024
398	10001000320240000007	2412.849538	2024-11-16 18:01:46.216249	2024-11-16 18:01:46.216249	\N	10	\N	\N	\N	\N	3	\N	1	2024
399	10001000320240000006	2412.849538	2024-11-16 18:01:46.217968	2024-11-16 18:01:46.217968	\N	10	\N	\N	\N	\N	3	\N	1	2024
400	10001000320240000002	2412.849538	2024-11-16 18:05:34.856708	2024-11-16 18:05:34.856708	\N	10	\N	\N	\N	\N	3	\N	1	2024
401	10001000320240000004	2412.849538	2024-11-16 18:05:34.926959	2024-11-16 18:05:34.926959	\N	10	\N	\N	\N	\N	3	\N	1	2024
402	10001000320240000003	2412.849538	2024-11-16 18:05:34.929644	2024-11-16 18:05:34.929644	\N	10	\N	\N	\N	\N	3	\N	1	2024
403	10001000320240000007	2412.849538	2024-11-16 18:05:34.982761	2024-11-16 18:05:34.982761	\N	10	\N	\N	\N	\N	3	\N	1	2024
404	10001000320240000006	2412.849538	2024-11-16 18:05:34.984579	2024-11-16 18:05:34.984579	\N	10	\N	\N	\N	\N	3	\N	1	2024
405	10001000320240000005	2412.849538	2024-11-16 18:05:34.986281	2024-11-16 18:05:34.986281	\N	10	\N	\N	\N	\N	3	\N	1	2024
406	10001000320240000002	2412.849538	2024-11-16 18:06:32.210603	2024-11-16 18:06:32.210603	\N	10	\N	\N	\N	\N	3	\N	1	2024
407	10001000320240000004	2412.849538	2024-11-16 18:06:32.312106	2024-11-16 18:06:32.312106	\N	10	\N	\N	\N	\N	3	\N	1	2024
408	10001000320240000006	2412.849538	2024-11-16 18:06:32.336194	2024-11-16 18:06:32.336194	\N	10	\N	\N	\N	\N	3	\N	1	2024
409	10001000320240000007	2412.849538	2024-11-16 18:06:32.337709	2024-11-16 18:06:32.337709	\N	10	\N	\N	\N	\N	3	\N	1	2024
410	10001000320240000005	2412.849538	2024-11-16 18:06:32.340242	2024-11-16 18:06:32.340242	\N	10	\N	\N	\N	\N	3	\N	1	2024
411	10001000320240000003	2412.849538	2024-11-16 18:06:32.368149	2024-11-16 18:06:32.368149	\N	10	\N	\N	\N	\N	3	\N	1	2024
412	10001000320240000002	2412.849538	2024-11-16 18:07:47.450433	2024-11-16 18:07:47.450433	\N	10	\N	\N	\N	\N	3	\N	1	2024
413	10001000320240000003	2412.849538	2024-11-16 18:07:47.522969	2024-11-16 18:07:47.522969	\N	10	\N	\N	\N	\N	3	\N	1	2024
414	10001000320240000006	2412.849538	2024-11-16 18:07:47.525178	2024-11-16 18:07:47.525178	\N	10	\N	\N	\N	\N	3	\N	1	2024
415	10001000320240000005	2412.849538	2024-11-16 18:07:47.5719	2024-11-16 18:07:47.5719	\N	10	\N	\N	\N	\N	3	\N	1	2024
416	10001000320240000007	2412.849538	2024-11-16 18:07:47.573766	2024-11-16 18:07:47.573766	\N	10	\N	\N	\N	\N	3	\N	1	2024
417	10001000320240000004	2412.849538	2024-11-16 18:07:47.575878	2024-11-16 18:07:47.575878	\N	10	\N	\N	\N	\N	3	\N	1	2024
418	10001000320240000002	2412.849538	2024-11-16 18:08:22.401124	2024-11-16 18:08:22.401124	\N	10	\N	\N	\N	\N	3	\N	1	2024
419	10001000320240000004	2412.849538	2024-11-16 18:08:22.472723	2024-11-16 18:08:22.472723	\N	10	\N	\N	\N	\N	3	\N	1	2024
420	10001000320240000005	2412.849538	2024-11-16 18:08:22.508519	2024-11-16 18:08:22.508519	\N	10	\N	\N	\N	\N	3	\N	1	2024
421	10001000320240000006	2412.849538	2024-11-16 18:08:22.562834	2024-11-16 18:08:22.562834	\N	10	\N	\N	\N	\N	3	\N	1	2024
422	10001000320240000007	2412.849538	2024-11-16 18:08:22.564769	2024-11-16 18:08:22.564769	\N	10	\N	\N	\N	\N	3	\N	1	2024
423	10001000320240000003	2412.849538	2024-11-16 18:08:22.566607	2024-11-16 18:08:22.566607	\N	10	\N	\N	\N	\N	3	\N	1	2024
424	10001000320240000002	2412.849538	2024-11-17 14:39:15.112568	2024-11-17 14:39:15.112568	\N	10	\N	\N	\N	\N	3	\N	1	2024
425	10001000320240000003	2412.849538	2024-11-17 14:39:15.193012	2024-11-17 14:39:15.193012	\N	10	\N	\N	\N	\N	3	\N	1	2024
426	10001000320240000004	2412.849538	2024-11-17 14:39:15.194224	2024-11-17 14:39:15.194224	\N	10	\N	\N	\N	\N	3	\N	1	2024
427	10001000320240000005	2412.849538	2024-11-17 14:39:15.19594	2024-11-17 14:39:15.19594	\N	10	\N	\N	\N	\N	3	\N	1	2024
428	10001000320240000007	2412.849538	2024-11-17 14:39:15.228396	2024-11-17 14:39:15.228396	\N	10	\N	\N	\N	\N	3	\N	1	2024
429	10001000320240000006	2412.849538	2024-11-17 14:39:15.229526	2024-11-17 14:39:15.229526	\N	10	\N	\N	\N	\N	3	\N	1	2024
297	123435	2403.588726	2024-11-14 23:07:40.589385	2024-11-14 23:07:40.589385	\N	10	\N	\N	\N	2	4	\N	1	2024
\.


--
-- Data for Name: tax_stamps_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_stamps_payment (id, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "taxStampId", "paymentId") FROM stdin;
49	2024-11-09 21:05:15.853781	2024-11-09 21:05:15.853781	\N	\N	\N	\N	\N	206	12
50	2024-11-09 21:05:15.854799	2024-11-09 21:05:15.854799	\N	\N	\N	\N	\N	207	12
51	2024-11-09 21:05:15.855814	2024-11-09 21:05:15.855814	\N	\N	\N	\N	\N	208	12
52	2024-11-09 21:05:15.934376	2024-11-09 21:05:15.934376	\N	\N	\N	\N	\N	210	12
53	2024-11-09 21:05:15.939267	2024-11-09 21:05:15.939267	\N	\N	\N	\N	\N	209	12
54	2024-11-09 21:05:15.950952	2024-11-09 21:05:15.950952	\N	\N	\N	\N	\N	211	12
55	2024-11-09 21:08:21.080804	2024-11-09 21:08:21.080804	\N	\N	\N	\N	\N	212	13
56	2024-11-09 21:08:21.081699	2024-11-09 21:08:21.081699	\N	\N	\N	\N	\N	213	13
57	2024-11-09 21:08:21.082746	2024-11-09 21:08:21.082746	\N	\N	\N	\N	\N	214	13
58	2024-11-09 21:08:21.133332	2024-11-09 21:08:21.133332	\N	\N	\N	\N	\N	215	13
59	2024-11-09 21:08:21.140288	2024-11-09 21:08:21.140288	\N	\N	\N	\N	\N	216	13
60	2024-11-09 21:08:21.144011	2024-11-09 21:08:21.144011	\N	\N	\N	\N	\N	217	13
61	2024-11-10 16:52:03.260276	2024-11-10 16:52:03.260276	\N	\N	\N	\N	\N	218	14
62	2024-11-10 16:52:03.261623	2024-11-10 16:52:03.261623	\N	\N	\N	\N	\N	219	14
63	2024-11-10 16:52:03.262688	2024-11-10 16:52:03.262688	\N	\N	\N	\N	\N	220	14
64	2024-11-10 16:52:03.312731	2024-11-10 16:52:03.312731	\N	\N	\N	\N	\N	221	14
65	2024-11-10 16:52:03.32072	2024-11-10 16:52:03.32072	\N	\N	\N	\N	\N	222	14
66	2024-11-10 16:52:03.321655	2024-11-10 16:52:03.321655	\N	\N	\N	\N	\N	223	14
67	2024-11-10 16:52:57.782561	2024-11-10 16:52:57.782561	\N	\N	\N	\N	\N	224	15
68	2024-11-10 16:52:57.783	2024-11-10 16:52:57.783	\N	\N	\N	\N	\N	225	15
69	2024-11-10 16:52:57.783454	2024-11-10 16:52:57.783454	\N	\N	\N	\N	\N	226	15
70	2024-11-10 16:52:57.827231	2024-11-10 16:52:57.827231	\N	\N	\N	\N	\N	227	15
71	2024-11-10 16:52:57.833878	2024-11-10 16:52:57.833878	\N	\N	\N	\N	\N	228	15
72	2024-11-10 16:52:57.834619	2024-11-10 16:52:57.834619	\N	\N	\N	\N	\N	229	15
73	2024-11-13 21:29:06.986443	2024-11-13 21:29:06.986443	\N	\N	\N	\N	\N	230	16
74	2024-11-13 21:29:06.986899	2024-11-13 21:29:06.986899	\N	\N	\N	\N	\N	231	16
75	2024-11-13 21:29:06.98728	2024-11-13 21:29:06.98728	\N	\N	\N	\N	\N	232	16
76	2024-11-13 21:29:07.035029	2024-11-13 21:29:07.035029	\N	\N	\N	\N	\N	233	16
77	2024-11-13 21:29:07.040953	2024-11-13 21:29:07.040953	\N	\N	\N	\N	\N	234	16
78	2024-11-13 21:29:07.042872	2024-11-13 21:29:07.042872	\N	\N	\N	\N	\N	235	16
79	2024-11-13 21:36:48.040048	2024-11-13 21:36:48.040048	\N	\N	\N	\N	\N	236	17
80	2024-11-13 21:36:48.040898	2024-11-13 21:36:48.040898	\N	\N	\N	\N	\N	237	17
81	2024-11-13 21:36:48.041419	2024-11-13 21:36:48.041419	\N	\N	\N	\N	\N	238	17
82	2024-11-13 21:36:48.119035	2024-11-13 21:36:48.119035	\N	\N	\N	\N	\N	239	17
83	2024-11-13 21:36:48.139459	2024-11-13 21:36:48.139459	\N	\N	\N	\N	\N	241	17
84	2024-11-13 21:36:48.145205	2024-11-13 21:36:48.145205	\N	\N	\N	\N	\N	240	17
85	2024-11-13 21:37:14.545677	2024-11-13 21:37:14.545677	\N	\N	\N	\N	\N	242	18
86	2024-11-13 21:37:14.546309	2024-11-13 21:37:14.546309	\N	\N	\N	\N	\N	243	18
87	2024-11-13 21:37:14.546673	2024-11-13 21:37:14.546673	\N	\N	\N	\N	\N	244	18
88	2024-11-13 21:37:14.592928	2024-11-13 21:37:14.592928	\N	\N	\N	\N	\N	245	18
89	2024-11-13 21:37:14.600374	2024-11-13 21:37:14.600374	\N	\N	\N	\N	\N	247	18
90	2024-11-13 21:37:14.602948	2024-11-13 21:37:14.602948	\N	\N	\N	\N	\N	246	18
91	2024-11-13 21:38:13.592472	2024-11-13 21:38:13.592472	\N	\N	\N	\N	\N	248	19
92	2024-11-13 21:38:13.593056	2024-11-13 21:38:13.593056	\N	\N	\N	\N	\N	249	19
93	2024-11-13 21:38:13.593342	2024-11-13 21:38:13.593342	\N	\N	\N	\N	\N	250	19
94	2024-11-13 21:38:13.642408	2024-11-13 21:38:13.642408	\N	\N	\N	\N	\N	251	19
95	2024-11-13 21:38:13.649163	2024-11-13 21:38:13.649163	\N	\N	\N	\N	\N	252	19
96	2024-11-13 21:38:13.656273	2024-11-13 21:38:13.656273	\N	\N	\N	\N	\N	253	19
97	2024-11-13 21:39:00.597101	2024-11-13 21:39:00.597101	\N	\N	\N	\N	\N	254	20
98	2024-11-13 21:39:00.59758	2024-11-13 21:39:00.59758	\N	\N	\N	\N	\N	255	20
99	2024-11-13 21:39:00.59804	2024-11-13 21:39:00.59804	\N	\N	\N	\N	\N	256	20
100	2024-11-13 21:39:00.646678	2024-11-13 21:39:00.646678	\N	\N	\N	\N	\N	258	20
101	2024-11-13 21:39:00.647503	2024-11-13 21:39:00.647503	\N	\N	\N	\N	\N	257	20
102	2024-11-13 21:39:00.657162	2024-11-13 21:39:00.657162	\N	\N	\N	\N	\N	259	20
103	2024-11-14 21:25:37.015631	2024-11-14 21:25:37.015631	\N	1	\N	\N	\N	284	21
104	2024-11-14 21:25:37.017033	2024-11-14 21:25:37.017033	\N	1	\N	\N	\N	285	21
105	2024-11-14 21:25:37.018177	2024-11-14 21:25:37.018177	\N	1	\N	\N	\N	286	21
106	2024-11-14 21:25:37.092995	2024-11-14 21:25:37.092995	\N	1	\N	\N	\N	287	21
107	2024-11-14 21:25:37.104029	2024-11-14 21:25:37.104029	\N	1	\N	\N	\N	288	21
108	2024-11-14 21:25:37.105686	2024-11-14 21:25:37.105686	\N	1	\N	\N	\N	289	21
109	2024-11-16 17:07:44.641856	2024-11-16 17:07:44.641856	\N	1	\N	\N	\N	304	22
110	2024-11-16 17:07:44.642444	2024-11-16 17:07:44.642444	\N	1	\N	\N	\N	305	22
111	2024-11-16 17:07:44.643055	2024-11-16 17:07:44.643055	\N	1	\N	\N	\N	306	22
112	2024-11-16 17:07:44.685963	2024-11-16 17:07:44.685963	\N	1	\N	\N	\N	307	22
113	2024-11-16 17:07:44.696719	2024-11-16 17:07:44.696719	\N	1	\N	\N	\N	308	22
114	2024-11-16 17:07:44.697359	2024-11-16 17:07:44.697359	\N	1	\N	\N	\N	309	22
115	2024-11-16 17:27:48.874264	2024-11-16 17:27:48.874264	\N	1	\N	\N	\N	310	26
116	2024-11-16 17:27:48.874772	2024-11-16 17:27:48.874772	\N	1	\N	\N	\N	311	26
117	2024-11-16 17:27:48.875117	2024-11-16 17:27:48.875117	\N	1	\N	\N	\N	312	26
118	2024-11-16 17:27:48.875446	2024-11-16 17:27:48.875446	\N	1	\N	\N	\N	313	26
119	2024-11-16 17:27:48.875731	2024-11-16 17:27:48.875731	\N	1	\N	\N	\N	314	26
120	2024-11-16 17:27:48.876047	2024-11-16 17:27:48.876047	\N	1	\N	\N	\N	315	26
121	2024-11-16 17:36:07.218287	2024-11-16 17:36:07.218287	\N	1	\N	\N	\N	316	27
122	2024-11-16 17:36:07.218888	2024-11-16 17:36:07.218888	\N	1	\N	\N	\N	317	27
123	2024-11-16 17:36:07.219407	2024-11-16 17:36:07.219407	\N	1	\N	\N	\N	318	27
124	2024-11-16 17:36:07.219832	2024-11-16 17:36:07.219832	\N	1	\N	\N	\N	319	27
125	2024-11-16 17:36:07.220247	2024-11-16 17:36:07.220247	\N	1	\N	\N	\N	320	27
126	2024-11-16 17:36:07.220634	2024-11-16 17:36:07.220634	\N	1	\N	\N	\N	321	27
127	2024-11-16 17:37:05.75952	2024-11-16 17:37:05.75952	\N	1	\N	\N	\N	322	28
128	2024-11-16 17:37:05.760111	2024-11-16 17:37:05.760111	\N	1	\N	\N	\N	323	28
129	2024-11-16 17:37:05.760517	2024-11-16 17:37:05.760517	\N	1	\N	\N	\N	324	28
130	2024-11-16 17:37:05.7608	2024-11-16 17:37:05.7608	\N	1	\N	\N	\N	325	28
131	2024-11-16 17:37:05.761214	2024-11-16 17:37:05.761214	\N	1	\N	\N	\N	326	28
132	2024-11-16 17:37:05.761727	2024-11-16 17:37:05.761727	\N	1	\N	\N	\N	327	28
133	2024-11-16 17:37:45.150743	2024-11-16 17:37:45.150743	\N	1	\N	\N	\N	328	29
134	2024-11-16 17:37:45.151247	2024-11-16 17:37:45.151247	\N	1	\N	\N	\N	329	29
135	2024-11-16 17:37:45.151749	2024-11-16 17:37:45.151749	\N	1	\N	\N	\N	330	29
136	2024-11-16 17:37:45.152204	2024-11-16 17:37:45.152204	\N	1	\N	\N	\N	331	29
137	2024-11-16 17:37:45.152531	2024-11-16 17:37:45.152531	\N	1	\N	\N	\N	332	29
138	2024-11-16 17:37:45.152834	2024-11-16 17:37:45.152834	\N	1	\N	\N	\N	333	29
139	2024-11-16 17:38:11.394182	2024-11-16 17:38:11.394182	\N	1	\N	\N	\N	334	30
140	2024-11-16 17:38:11.394524	2024-11-16 17:38:11.394524	\N	1	\N	\N	\N	335	30
141	2024-11-16 17:38:11.394866	2024-11-16 17:38:11.394866	\N	1	\N	\N	\N	336	30
142	2024-11-16 17:38:11.395223	2024-11-16 17:38:11.395223	\N	1	\N	\N	\N	337	30
143	2024-11-16 17:38:11.395643	2024-11-16 17:38:11.395643	\N	1	\N	\N	\N	338	30
144	2024-11-16 17:38:11.395962	2024-11-16 17:38:11.395962	\N	1	\N	\N	\N	339	30
145	2024-11-16 17:39:16.741994	2024-11-16 17:39:16.741994	\N	1	\N	\N	\N	340	31
146	2024-11-16 17:39:16.742378	2024-11-16 17:39:16.742378	\N	1	\N	\N	\N	341	31
147	2024-11-16 17:39:16.742765	2024-11-16 17:39:16.742765	\N	1	\N	\N	\N	342	31
148	2024-11-16 17:39:16.743133	2024-11-16 17:39:16.743133	\N	1	\N	\N	\N	343	31
149	2024-11-16 17:39:16.743451	2024-11-16 17:39:16.743451	\N	1	\N	\N	\N	344	31
150	2024-11-16 17:39:16.743737	2024-11-16 17:39:16.743737	\N	1	\N	\N	\N	345	31
151	2024-11-16 17:42:37.278687	2024-11-16 17:42:37.278687	\N	1	\N	\N	\N	346	32
152	2024-11-16 17:42:37.279016	2024-11-16 17:42:37.279016	\N	1	\N	\N	\N	347	32
153	2024-11-16 17:42:37.279401	2024-11-16 17:42:37.279401	\N	1	\N	\N	\N	348	32
154	2024-11-16 17:42:37.279892	2024-11-16 17:42:37.279892	\N	1	\N	\N	\N	349	32
155	2024-11-16 17:42:37.280415	2024-11-16 17:42:37.280415	\N	1	\N	\N	\N	350	32
156	2024-11-16 17:42:37.280844	2024-11-16 17:42:37.280844	\N	1	\N	\N	\N	351	32
157	2024-11-16 17:46:25.652091	2024-11-16 17:46:25.652091	\N	1	\N	\N	\N	352	33
158	2024-11-16 17:46:25.6531	2024-11-16 17:46:25.6531	\N	1	\N	\N	\N	353	33
159	2024-11-16 17:46:25.653954	2024-11-16 17:46:25.653954	\N	1	\N	\N	\N	354	33
160	2024-11-16 17:46:25.65481	2024-11-16 17:46:25.65481	\N	1	\N	\N	\N	355	33
161	2024-11-16 17:46:25.655426	2024-11-16 17:46:25.655426	\N	1	\N	\N	\N	356	33
162	2024-11-16 17:46:25.656182	2024-11-16 17:46:25.656182	\N	1	\N	\N	\N	357	33
163	2024-11-16 17:47:48.376981	2024-11-16 17:47:48.376981	\N	1	\N	\N	\N	358	34
164	2024-11-16 17:47:48.37757	2024-11-16 17:47:48.37757	\N	1	\N	\N	\N	359	34
165	2024-11-16 17:47:48.377969	2024-11-16 17:47:48.377969	\N	1	\N	\N	\N	360	34
166	2024-11-16 17:47:48.378278	2024-11-16 17:47:48.378278	\N	1	\N	\N	\N	361	34
167	2024-11-16 17:47:48.378586	2024-11-16 17:47:48.378586	\N	1	\N	\N	\N	362	34
168	2024-11-16 17:47:48.378917	2024-11-16 17:47:48.378917	\N	1	\N	\N	\N	363	34
169	2024-11-16 17:49:08.118461	2024-11-16 17:49:08.118461	\N	1	\N	\N	\N	364	35
170	2024-11-16 17:49:08.118969	2024-11-16 17:49:08.118969	\N	1	\N	\N	\N	365	35
171	2024-11-16 17:49:08.11939	2024-11-16 17:49:08.11939	\N	1	\N	\N	\N	366	35
172	2024-11-16 17:49:08.119748	2024-11-16 17:49:08.119748	\N	1	\N	\N	\N	367	35
173	2024-11-16 17:49:08.120149	2024-11-16 17:49:08.120149	\N	1	\N	\N	\N	368	35
174	2024-11-16 17:49:08.12053	2024-11-16 17:49:08.12053	\N	1	\N	\N	\N	369	35
175	2024-11-16 17:54:06.586897	2024-11-16 17:54:06.586897	\N	1	\N	\N	\N	370	36
176	2024-11-16 17:54:06.587441	2024-11-16 17:54:06.587441	\N	1	\N	\N	\N	371	36
177	2024-11-16 17:54:06.58794	2024-11-16 17:54:06.58794	\N	1	\N	\N	\N	372	36
178	2024-11-16 17:54:06.588418	2024-11-16 17:54:06.588418	\N	1	\N	\N	\N	373	36
179	2024-11-16 17:54:06.588838	2024-11-16 17:54:06.588838	\N	1	\N	\N	\N	374	36
180	2024-11-16 17:54:06.589374	2024-11-16 17:54:06.589374	\N	1	\N	\N	\N	375	36
181	2024-11-16 17:55:04.866632	2024-11-16 17:55:04.866632	\N	1	\N	\N	\N	376	37
182	2024-11-16 17:55:04.867162	2024-11-16 17:55:04.867162	\N	1	\N	\N	\N	377	37
183	2024-11-16 17:55:04.867684	2024-11-16 17:55:04.867684	\N	1	\N	\N	\N	378	37
184	2024-11-16 17:55:04.868118	2024-11-16 17:55:04.868118	\N	1	\N	\N	\N	379	37
185	2024-11-16 17:55:04.868549	2024-11-16 17:55:04.868549	\N	1	\N	\N	\N	380	37
186	2024-11-16 17:55:04.868949	2024-11-16 17:55:04.868949	\N	1	\N	\N	\N	381	37
187	2024-11-16 17:56:21.436522	2024-11-16 17:56:21.436522	\N	1	\N	\N	\N	382	38
188	2024-11-16 17:56:21.437138	2024-11-16 17:56:21.437138	\N	1	\N	\N	\N	383	38
189	2024-11-16 17:56:21.437568	2024-11-16 17:56:21.437568	\N	1	\N	\N	\N	384	38
190	2024-11-16 17:56:21.437912	2024-11-16 17:56:21.437912	\N	1	\N	\N	\N	385	38
191	2024-11-16 17:56:21.438228	2024-11-16 17:56:21.438228	\N	1	\N	\N	\N	386	38
192	2024-11-16 17:56:21.43864	2024-11-16 17:56:21.43864	\N	1	\N	\N	\N	387	38
193	2024-11-16 17:59:28.818918	2024-11-16 17:59:28.818918	\N	1	\N	\N	\N	388	39
194	2024-11-16 17:59:28.819375	2024-11-16 17:59:28.819375	\N	1	\N	\N	\N	389	39
195	2024-11-16 17:59:28.819845	2024-11-16 17:59:28.819845	\N	1	\N	\N	\N	390	39
196	2024-11-16 17:59:28.820267	2024-11-16 17:59:28.820267	\N	1	\N	\N	\N	391	39
197	2024-11-16 17:59:28.820671	2024-11-16 17:59:28.820671	\N	1	\N	\N	\N	392	39
198	2024-11-16 17:59:28.821104	2024-11-16 17:59:28.821104	\N	1	\N	\N	\N	393	39
199	2024-11-16 18:01:46.255552	2024-11-16 18:01:46.255552	\N	1	\N	\N	\N	394	40
200	2024-11-16 18:01:46.256153	2024-11-16 18:01:46.256153	\N	1	\N	\N	\N	395	40
201	2024-11-16 18:01:46.256648	2024-11-16 18:01:46.256648	\N	1	\N	\N	\N	396	40
202	2024-11-16 18:01:46.257031	2024-11-16 18:01:46.257031	\N	1	\N	\N	\N	399	40
203	2024-11-16 18:01:46.257336	2024-11-16 18:01:46.257336	\N	1	\N	\N	\N	397	40
204	2024-11-16 18:01:46.257642	2024-11-16 18:01:46.257642	\N	1	\N	\N	\N	398	40
205	2024-11-16 18:05:35.025507	2024-11-16 18:05:35.025507	\N	1	\N	\N	\N	400	41
206	2024-11-16 18:05:35.025979	2024-11-16 18:05:35.025979	\N	1	\N	\N	\N	401	41
207	2024-11-16 18:05:35.026479	2024-11-16 18:05:35.026479	\N	1	\N	\N	\N	402	41
208	2024-11-16 18:05:35.027323	2024-11-16 18:05:35.027323	\N	1	\N	\N	\N	403	41
209	2024-11-16 18:05:35.028181	2024-11-16 18:05:35.028181	\N	1	\N	\N	\N	404	41
210	2024-11-16 18:05:35.028808	2024-11-16 18:05:35.028808	\N	1	\N	\N	\N	405	41
211	2024-11-16 18:06:32.393837	2024-11-16 18:06:32.393837	\N	1	\N	\N	\N	406	42
212	2024-11-16 18:06:32.394354	2024-11-16 18:06:32.394354	\N	1	\N	\N	\N	407	42
213	2024-11-16 18:06:32.394907	2024-11-16 18:06:32.394907	\N	1	\N	\N	\N	408	42
214	2024-11-16 18:06:32.395378	2024-11-16 18:06:32.395378	\N	1	\N	\N	\N	409	42
215	2024-11-16 18:06:32.395853	2024-11-16 18:06:32.395853	\N	1	\N	\N	\N	410	42
216	2024-11-16 18:06:32.396362	2024-11-16 18:06:32.396362	\N	1	\N	\N	\N	411	42
217	2024-11-16 18:07:47.605089	2024-11-16 18:07:47.605089	\N	1	\N	\N	\N	412	43
218	2024-11-16 18:07:47.605572	2024-11-16 18:07:47.605572	\N	1	\N	\N	\N	413	43
219	2024-11-16 18:07:47.60605	2024-11-16 18:07:47.60605	\N	1	\N	\N	\N	414	43
220	2024-11-16 18:07:47.606513	2024-11-16 18:07:47.606513	\N	1	\N	\N	\N	415	43
221	2024-11-16 18:07:47.606962	2024-11-16 18:07:47.606962	\N	1	\N	\N	\N	416	43
222	2024-11-16 18:07:47.607376	2024-11-16 18:07:47.607376	\N	1	\N	\N	\N	417	43
223	2024-11-16 18:08:22.605562	2024-11-16 18:08:22.605562	\N	1	\N	\N	\N	418	44
224	2024-11-16 18:08:22.607074	2024-11-16 18:08:22.607074	\N	1	\N	\N	\N	419	44
225	2024-11-16 18:08:22.607726	2024-11-16 18:08:22.607726	\N	1	\N	\N	\N	420	44
226	2024-11-16 18:08:22.608275	2024-11-16 18:08:22.608275	\N	1	\N	\N	\N	421	44
227	2024-11-16 18:08:22.60876	2024-11-16 18:08:22.60876	\N	1	\N	\N	\N	422	44
228	2024-11-16 18:08:22.609209	2024-11-16 18:08:22.609209	\N	1	\N	\N	\N	423	44
229	2024-11-17 14:39:15.253125	2024-11-17 14:39:15.253125	\N	1	\N	\N	\N	424	45
230	2024-11-17 14:39:15.253468	2024-11-17 14:39:15.253468	\N	1	\N	\N	\N	425	45
231	2024-11-17 14:39:15.253719	2024-11-17 14:39:15.253719	\N	1	\N	\N	\N	426	45
232	2024-11-17 14:39:15.253961	2024-11-17 14:39:15.253961	\N	1	\N	\N	\N	427	45
233	2024-11-17 14:39:15.254294	2024-11-17 14:39:15.254294	\N	1	\N	\N	\N	428	45
234	2024-11-17 14:39:15.254579	2024-11-17 14:39:15.254579	\N	1	\N	\N	\N	429	45
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction (id, reference, amount, date, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "transactionTypeId", "bankAccountId", "paymentId") FROM stdin;
4	2024110900000001	14416.610529000001	2024-11-09 21:05:15.963-04	2024-11-09 21:05:15.995389	2024-11-09 21:05:15.995389	\N	5	\N	\N	\N	1	1	12
5	2024110900000001	14416.610529000001	2024-11-09 21:08:21.152-04	2024-11-09 21:08:21.168024	2024-11-09 21:08:21.168024	\N	5	\N	\N	\N	1	1	13
6	2024111000000001	14416.610529	2024-11-10 16:52:03.332-04	2024-11-10 16:52:03.350889	2024-11-10 16:52:03.350889	\N	5	\N	\N	\N	1	1	14
7	2024111000000001	14416.610529000001	2024-11-10 16:52:57.842-04	2024-11-10 16:52:57.856866	2024-11-10 16:52:57.856866	\N	5	\N	\N	\N	1	1	15
8	2024111300000001	14282.386688999999	2024-11-13 21:29:07.051-04	2024-11-13 21:29:07.069619	2024-11-13 21:29:07.069619	\N	5	\N	\N	\N	1	1	16
9	2024111300000001	14282.386688999999	2024-11-13 21:36:48.153-04	2024-11-13 21:36:48.171282	2024-11-13 21:36:48.171282	\N	5	\N	\N	\N	1	1	17
10	2024111300000001	14282.386688999999	2024-11-13 21:37:14.613-04	2024-11-13 21:37:14.631665	2024-11-13 21:37:14.631665	\N	5	\N	\N	\N	1	1	18
11	2024111300000001	14282.386688999999	2024-11-13 21:38:13.662-04	2024-11-13 21:38:13.677698	2024-11-13 21:38:13.677698	\N	5	\N	\N	\N	1	1	19
12	2024111300000001	14282.386688999999	2024-11-13 21:39:00.664-04	2024-11-13 21:39:00.678569	2024-11-14 00:02:50.149094	\N	6	\N	\N	\N	1	1	20
13	2024111400000001	14421.532356	2024-11-14 21:25:37.122-04	2024-11-14 21:25:37.14953	2024-11-14 21:46:35.757502	\N	6	\N	\N	\N	1	1	21
14	2024111600000001	14477.097227999999	2024-11-16 17:07:44.712-04	2024-11-16 17:07:44.721433	2024-11-16 17:08:48.234877	\N	6	\N	\N	\N	1	1	22
15	2024111600000003	0	2024-11-16 17:10:32.174-04	2024-11-16 17:10:32.204991	2024-11-16 17:10:32.204991	\N	5	\N	\N	\N	1	1	23
16	2024111600000004	0	2024-11-16 17:22:31.781-04	2024-11-16 17:22:31.808622	2024-11-16 17:22:31.808622	\N	5	\N	\N	\N	1	1	24
17	2024111600000005	0	2024-11-16 17:23:42.78-04	2024-11-16 17:23:42.800677	2024-11-16 17:23:42.800677	\N	5	\N	\N	\N	1	1	25
18	2024111600000006	14477.097228	2024-11-16 17:27:48.891-04	2024-11-16 17:27:48.902729	2024-11-16 17:27:48.902729	\N	5	\N	\N	\N	1	1	26
19	2024111600000007	14477.097228	2024-11-16 17:36:07.256-04	2024-11-16 17:36:07.271857	2024-11-16 17:36:07.271857	\N	5	\N	\N	\N	1	1	27
20	2024111600000008	14477.097228	2024-11-16 17:37:05.777-04	2024-11-16 17:37:05.789376	2024-11-16 17:37:05.789376	\N	5	\N	\N	\N	1	1	28
21	2024111600000009	14477.097228	2024-11-16 17:37:45.169-04	2024-11-16 17:37:45.182173	2024-11-16 17:37:45.182173	\N	5	\N	\N	\N	1	1	29
22	2024111600000010	14477.097228	2024-11-16 17:38:11.414-04	2024-11-16 17:38:11.427814	2024-11-16 17:38:11.427814	\N	5	\N	\N	\N	1	1	30
23	2024111600000011	14477.097228	2024-11-16 17:39:16.758-04	2024-11-16 17:39:16.771521	2024-11-16 17:39:16.771521	\N	5	\N	\N	\N	1	1	31
24	2024111600000012	14477.097228	2024-11-16 17:42:37.296-04	2024-11-16 17:42:37.3085	2024-11-16 17:42:37.3085	\N	5	\N	\N	\N	1	1	32
25	2024111600000013	14477.097228	2024-11-16 17:46:25.682-04	2024-11-16 17:46:25.70952	2024-11-16 17:46:25.70952	\N	5	\N	\N	\N	1	1	33
26	2024111600000014	14477.097228	2024-11-16 17:47:48.394-04	2024-11-16 17:47:48.405624	2024-11-16 17:47:48.405624	\N	5	\N	\N	\N	1	1	34
27	2024111600000015	14477.097228	2024-11-16 17:49:08.136-04	2024-11-16 17:49:08.147775	2024-11-16 17:49:08.147775	\N	5	\N	\N	\N	1	1	35
28	2024111600000016	14477.097228	2024-11-16 17:54:06.608-04	2024-11-16 17:54:06.621971	2024-11-16 17:54:06.621971	\N	5	\N	\N	\N	1	1	36
29	2024111600000017	14477.097228	2024-11-16 17:55:04.886-04	2024-11-16 17:55:04.899267	2024-11-16 17:55:04.899267	\N	5	\N	\N	\N	1	1	37
30	2024111600000018	14477.097228	2024-11-16 17:56:21.458-04	2024-11-16 17:56:21.471282	2024-11-16 17:56:21.471282	\N	5	\N	\N	\N	1	1	38
31	2024111600000019	14477.097228	2024-11-16 17:59:28.841-04	2024-11-16 17:59:28.860062	2024-11-16 17:59:28.860062	\N	5	\N	\N	\N	1	1	39
32	2024111600000020	14477.097228	2024-11-16 18:01:46.275-04	2024-11-16 18:01:46.28656	2024-11-16 18:01:46.28656	\N	5	\N	\N	\N	1	1	40
33	2024111600000021	14477.097228	2024-11-16 18:05:35.055-04	2024-11-16 18:05:35.070034	2024-11-16 18:05:35.070034	\N	5	\N	\N	\N	1	1	41
34	2024111600000022	14477.097228	2024-11-16 18:06:32.412-04	2024-11-16 18:06:32.422993	2024-11-16 18:06:32.422993	\N	5	\N	\N	\N	1	1	42
35	2024111600000023	14477.097228	2024-11-16 18:07:47.623-04	2024-11-16 18:07:47.634746	2024-11-16 18:07:47.634746	\N	5	\N	\N	\N	1	1	43
36	2024111600000024	14477.097228	2024-11-16 18:08:22.635-04	2024-11-16 18:08:22.651968	2024-11-16 18:08:22.651968	\N	5	\N	\N	\N	1	1	44
37	2024111700000025	14477.097228	2024-11-17 14:39:15.269-04	2024-11-17 14:39:15.283491	2024-11-17 14:39:15.283491	\N	5	\N	\N	\N	1	1	45
\.


--
-- Data for Name: transactions_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_type (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
2	DEBIT	Type of debit banking transactions	2024-11-06 22:48:24.089182	2024-11-06 22:48:24.089182	\N	1	1	1	\N
1	CREDIT	Type of credit banking transactions	2024-11-06 22:48:24.089182	2024-11-06 22:48:24.089182	\N	1	1	1	\N
\.


--
-- Data for Name: types_external_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types_external_request (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	INTERFACE_BANK	INTERFACE WITH BANK (100% BANK) FOR ONLINE PAYMENT PROCESSING	2024-10-21 15:27:09.311258	2024-10-21 15:27:09.311258	\N	1	1	1	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, identity_document_letter, identity_document, birthdate, constitution_date, address, phone_number, last_connection, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "roleId", "contributorTypeId", "parishId", fullname, "refreshToken", contributor_exempt, gender) FROM stdin;
1	shyf.infosiartec@gmail.com	$2b$10$EnHiFgWDchGadUAoZDSFZepstWg//JTpdfAFrVus0uZZMrNZCRW5m	G	20000152-6	\N	1900-01-01	Av. Michelena a 100 Mts. del elevado La Quizanda detrás de las oficinas del IVEC Sede Sec. Hacienda y Finanzas – Valencia - Edo. Carabobo.	+58 241 8743470	\N	2024-06-25 21:49:14.69	2024-06-26 22:11:38.979	\N	1	\N	\N	\N	1	\N	\N	SUPER ADMIN	\N	f	O
5	sebastian.gamboalima@gmail.com	$2a$10$eWZ/hA/9iz/V0wnymAiyoub4x5XfpDxZ6k1WSdxatl.n1/ov5.7dm	V	28465204	1999-08-04	\N	Guigue, barrio Rosendo Torres 2, casa nro. 41, calle del cementerio	+58 414 4085731	\N	2024-10-14 14:54:09.9	2024-11-15 11:35:39.869	\N	1	\N	\N	\N	3	1	285	Carlos Arnaldo Cárdenas Sosa	$argon2id$v=19$m=65536,t=3,p=4$atmS9u0ZTjbxYfgxb2lh1w$T9iM9d77pxMCC8RVxQG78uZ6EXr5/4mMemyD6Z8mnLI	f	O
2	nelmerayala@gmail.com	$2a$10$PG1UH3TyqY9pS1c972/vSOM3w.Hj/N3D0XxpaNJ3ereTA4CnADY2K	V	24297146	1996-02-02	\N	Los tamarindos manzana a-9	+58 414 4196316	\N	2024-06-26 23:02:27.391	2024-11-17 17:14:41.941026	\N	1	1	1	\N	3	1	269	Ayala Seijas Nelmer Alexander	$argon2id$v=19$m=65536,t=3,p=4$/VTszGGZ9KxbYEK7OBCEvw$PNhWRniWl8YoBYEK3eTUbduXUMwJGaqyVIpEK2pJE94	f	M
3	jennyaray98@gmail.com	$2a$10$OQsz9Gj2Xw4J.hsWbUo2gOtcA.FdXXHtPMgyYp1cCA9gjSiYFKxN.	V	26306715	1998-01-22	\N	San Judas Tadeo I	+58 424 4571298	\N	2024-10-17 19:17:42.11	2024-10-17 19:17:42.11	\N	1	\N	\N	\N	3	1	285	Jennyreth Cristina Aray Andrade	\N	f	O
4	broook.hum04@gmail.com	$2a$10$eWZ/hA/9iz/V0wnymAiyoub4x5XfpDxZ6k1WSdxatl.n1/ov5.7dm	V	28465203	1999-08-04	\N	Guigue, barrio Rosendo Torres 2, casa nro. 41, calle del cementerio	+58 414 4085730	\N	2024-10-14 14:54:09.9	2024-10-22 19:55:40.223	\N	1	\N	\N	\N	3	1	285	Carlos Arnaldo Cárdenas Sosa	\N	f	O
9	nelmer2@gmail.com	$2a$10$ctw5zN/YG3gETvIWpBuA1ukYJoEFAIC5r5NmW.7FEsGvcdW3lfWcu	V	24297146	\N	\N	mariar	+58 414 4196314	\N	2024-11-17 17:27:20.188627	2024-11-17 17:27:20.188627	\N	1	\N	\N	\N	3	1	261	Ejemplo	\N	f	F
\.


--
-- Name: annual_correlative_tax_stamps; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.annual_correlative_tax_stamps', 1, true);


--
-- Name: audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_id_seq', 1, false);


--
-- Name: auditable_process_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auditable_process_id_seq', 1, false);


--
-- Name: audits_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audits_detail_id_seq', 1, false);


--
-- Name: bank_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bank_account_id_seq', 1, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bank_id_seq', 33, true);


--
-- Name: branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_id_seq', 1, false);


--
-- Name: calculation_factor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.calculation_factor_id_seq', 60, true);


--
-- Name: coin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coin_id_seq', 3, true);


--
-- Name: contributors_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contributors_type_id_seq', 5, true);


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.country_id_seq', 240, true);


--
-- Name: daily_correlative_request_bank; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daily_correlative_request_bank', 25, true);


--
-- Name: daily_correlative_tax_stamps; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daily_correlative_tax_stamps', 13, true);


--
-- Name: document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_id_seq', 25, false);


--
-- Name: entities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.entities_id_seq', 4, true);


--
-- Name: external_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.external_request_id_seq', 73, true);


--
-- Name: locker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locker_id_seq', 1, false);


--
-- Name: lockers_point_of_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lockers_point_of_sale_id_seq', 1, false);


--
-- Name: municipalities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.municipalities_id_seq', 335, true);


--
-- Name: parishes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parishes_id_seq', 1134, true);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_id_seq', 45, true);


--
-- Name: payments_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_type_id_seq', 3, true);


--
-- Name: point_of_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.point_of_sale_id_seq', 1, false);


--
-- Name: privilege_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.privilege_id_seq', 11, true);


--
-- Name: procedure_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.procedure_id_seq', 1, false);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_seq', 7, true);


--
-- Name: roles_privilege_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_privilege_id_seq', 21, true);


--
-- Name: state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.state_id_seq', 24, true);


--
-- Name: status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_id_seq', 14, true);


--
-- Name: subentity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subentity_id_seq', 29, true);


--
-- Name: tax_stamp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tax_stamp_id_seq', 429, true);


--
-- Name: tax_stamps_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tax_stamps_payment_id_seq', 234, true);


--
-- Name: transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_id_seq', 37, true);


--
-- Name: transactions_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_type_id_seq', 2, true);


--
-- Name: types_external_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.types_external_request_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 9, true);


--
-- Name: audits_detail PK_0d1bc01ff0498158edefaa84279; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits_detail
    ADD CONSTRAINT "PK_0d1bc01ff0498158edefaa84279" PRIMARY KEY (id);


--
-- Name: roles_privilege PK_0f37c17581d6dc45e779269eee3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "PK_0f37c17581d6dc45e779269eee3" PRIMARY KEY (id);


--
-- Name: tax_stamp PK_12b15940bde6b3875074d969fbd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamp
    ADD CONSTRAINT "PK_12b15940bde6b3875074d969fbd" PRIMARY KEY (id);


--
-- Name: audit PK_1d3d120ddaf7bc9b1ed68ed463a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit
    ADD CONSTRAINT "PK_1d3d120ddaf7bc9b1ed68ed463a" PRIMARY KEY (id);


--
-- Name: locker PK_295c0898cceea20ac8ee103d98d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locker
    ADD CONSTRAINT "PK_295c0898cceea20ac8ee103d98d" PRIMARY KEY (id);


--
-- Name: branch PK_2e39f426e2faefdaa93c5961976; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT "PK_2e39f426e2faefdaa93c5961976" PRIMARY KEY (id);


--
-- Name: types_external_request PK_3a666b1e155f18b79a393c5ed15; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_external_request
    ADD CONSTRAINT "PK_3a666b1e155f18b79a393c5ed15" PRIMARY KEY (id);


--
-- Name: point_of_sale PK_3de93e7aa9f52c9da5874e4f197; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_of_sale
    ADD CONSTRAINT "PK_3de93e7aa9f52c9da5874e4f197" PRIMARY KEY (id);


--
-- Name: calculation_factor PK_4ce48dd3976c6dde9cfaff12f6e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calculation_factor
    ADD CONSTRAINT "PK_4ce48dd3976c6dde9cfaff12f6e" PRIMARY KEY (id);


--
-- Name: state PK_549ffd046ebab1336c3a8030a12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT "PK_549ffd046ebab1336c3a8030a12" PRIMARY KEY (id);


--
-- Name: coin PK_650993fc71b789e4793b62fbcac; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coin
    ADD CONSTRAINT "PK_650993fc71b789e4793b62fbcac" PRIMARY KEY (id);


--
-- Name: bank PK_7651eaf705126155142947926e8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT "PK_7651eaf705126155142947926e8" PRIMARY KEY (id);


--
-- Name: subentity PK_7ea4ded3743bb8beff83f0fb869; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subentity
    ADD CONSTRAINT "PK_7ea4ded3743bb8beff83f0fb869" PRIMARY KEY (id);


--
-- Name: payments_type PK_80b6adf73186fa5164199b890cd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments_type
    ADD CONSTRAINT "PK_80b6adf73186fa5164199b890cd" PRIMARY KEY (id);


--
-- Name: tax_stamps_payment PK_83574b67d1636a0af899ca3414c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamps_payment
    ADD CONSTRAINT "PK_83574b67d1636a0af899ca3414c" PRIMARY KEY (id);


--
-- Name: entities PK_8640855ae82083455cbb806173d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT "PK_8640855ae82083455cbb806173d" PRIMARY KEY (id);


--
-- Name: transaction PK_89eadb93a89810556e1cbcd6ab9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT "PK_89eadb93a89810556e1cbcd6ab9" PRIMARY KEY (id);


--
-- Name: procedure PK_9888785b528492e7539d96e3894; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT "PK_9888785b528492e7539d96e3894" PRIMARY KEY (id);


--
-- Name: municipalities PK_9c4573349577306f221dda4d924; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT "PK_9c4573349577306f221dda4d924" PRIMARY KEY (id);


--
-- Name: auditable_process PK_a27931526791447746469e20a80; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditable_process
    ADD CONSTRAINT "PK_a27931526791447746469e20a80" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: lockers_point_of_sale PK_a807ab2557078bbae7f317af93b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lockers_point_of_sale
    ADD CONSTRAINT "PK_a807ab2557078bbae7f317af93b" PRIMARY KEY (id);


--
-- Name: privilege PK_b1691196ff9c996998bab2e406e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilege
    ADD CONSTRAINT "PK_b1691196ff9c996998bab2e406e" PRIMARY KEY (id);


--
-- Name: role PK_b36bcfe02fc8de3c57a8b2391c2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "PK_b36bcfe02fc8de3c57a8b2391c2" PRIMARY KEY (id);


--
-- Name: transactions_type PK_bf1cb034a93b703e528b926a75d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_type
    ADD CONSTRAINT "PK_bf1cb034a93b703e528b926a75d" PRIMARY KEY (id);


--
-- Name: country PK_bf6e37c231c4f4ea56dcd887269; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT "PK_bf6e37c231c4f4ea56dcd887269" PRIMARY KEY (id);


--
-- Name: contributors_type PK_c1506dfb5df21dbfab0e435fa26; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type
    ADD CONSTRAINT "PK_c1506dfb5df21dbfab0e435fa26" PRIMARY KEY (id);


--
-- Name: parishes PK_c306a10bc35df0e4ec2ee66363d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parishes
    ADD CONSTRAINT "PK_c306a10bc35df0e4ec2ee66363d" PRIMARY KEY (id);


--
-- Name: external_request PK_df9a673903e91dd7d055dee49b5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_request
    ADD CONSTRAINT "PK_df9a673903e91dd7d055dee49b5" PRIMARY KEY (id);


--
-- Name: status PK_e12743a7086ec826733f54e1d95; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT "PK_e12743a7086ec826733f54e1d95" PRIMARY KEY (id);


--
-- Name: document PK_e57d3357f83f3cdc0acffc3d777; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT "PK_e57d3357f83f3cdc0acffc3d777" PRIMARY KEY (id);


--
-- Name: bank_account PK_f3246deb6b79123482c6adb9745; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT "PK_f3246deb6b79123482c6adb9745" PRIMARY KEY (id);


--
-- Name: payment PK_fcaec7df5adf9cac408c686b2ab; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "PK_fcaec7df5adf9cac408c686b2ab" PRIMARY KEY (id);


--
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- Name: roles_privilege UQ_ae5402ebbb5a0318cba955fa3f4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "UQ_ae5402ebbb5a0318cba955fa3f4" UNIQUE ("roleId", "privilegeId");


--
-- Name: point_of_sale FK_002d1c1991dde290a8b807aad4b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_of_sale
    ADD CONSTRAINT "FK_002d1c1991dde290a8b807aad4b" FOREIGN KEY ("bankAccountId") REFERENCES public.bank_account(id);


--
-- Name: payment FK_002d402a5f8beaa4321194fb5a4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "FK_002d402a5f8beaa4321194fb5a4" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: coin FK_00b52e939a44db2800624702050; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coin
    ADD CONSTRAINT "FK_00b52e939a44db2800624702050" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: entities FK_01e966bd2ef171c37c811bb4efb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT "FK_01e966bd2ef171c37c811bb4efb" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: external_request FK_025101983970c1c7e8fb5cdff63; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_request
    ADD CONSTRAINT "FK_025101983970c1c7e8fb5cdff63" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: transaction FK_0296ec1d5fe49c069124494378a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT "FK_0296ec1d5fe49c069124494378a" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: external_request FK_067c02fe4839a0da1250724a991; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_request
    ADD CONSTRAINT "FK_067c02fe4839a0da1250724a991" FOREIGN KEY ("transactionId") REFERENCES public.transaction(id);


--
-- Name: tax_stamps_payment FK_06ef2a40f29ec0a3bbc9f5b1827; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamps_payment
    ADD CONSTRAINT "FK_06ef2a40f29ec0a3bbc9f5b1827" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: transaction FK_07540dda5970c29494e0f70f89e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT "FK_07540dda5970c29494e0f70f89e" FOREIGN KEY ("bankAccountId") REFERENCES public.bank_account(id);


--
-- Name: tax_stamps_payment FK_07674b5e9614f1e9ab37f7993f9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamps_payment
    ADD CONSTRAINT "FK_07674b5e9614f1e9ab37f7993f9" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: lockers_point_of_sale FK_0774c05519f7d2f8b69da5b3304; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lockers_point_of_sale
    ADD CONSTRAINT "FK_0774c05519f7d2f8b69da5b3304" FOREIGN KEY ("pointOfSaleId") REFERENCES public.point_of_sale(id);


--
-- Name: parishes FK_08e86dfdc3fdc94ff5cfeda4711; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parishes
    ADD CONSTRAINT "FK_08e86dfdc3fdc94ff5cfeda4711" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: audits_detail FK_08e9538fdb07768483e7b49c954; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits_detail
    ADD CONSTRAINT "FK_08e9538fdb07768483e7b49c954" FOREIGN KEY ("auditId") REFERENCES public.audit(id);


--
-- Name: tax_stamps_payment FK_0ab9a023a3e90be060d973d7138; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamps_payment
    ADD CONSTRAINT "FK_0ab9a023a3e90be060d973d7138" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: privilege FK_0b70c938c19d6cf6e7396a80b44; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilege
    ADD CONSTRAINT "FK_0b70c938c19d6cf6e7396a80b44" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: contributors_type FK_0b7417ed8fe53af2c05f692d28c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type
    ADD CONSTRAINT "FK_0b7417ed8fe53af2c05f692d28c" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: transactions_type FK_0d038fa43f480e89cf5b478a4e5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_type
    ADD CONSTRAINT "FK_0d038fa43f480e89cf5b478a4e5" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: transaction FK_0e57c323890648df9aa92e57a34; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT "FK_0e57c323890648df9aa92e57a34" FOREIGN KEY ("transactionTypeId") REFERENCES public.transactions_type(id);


--
-- Name: payments_type FK_0e849b4c5cf0d707e3623c61a89; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments_type
    ADD CONSTRAINT "FK_0e849b4c5cf0d707e3623c61a89" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: calculation_factor FK_0f129a044f25bbfa21b54494eb2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calculation_factor
    ADD CONSTRAINT "FK_0f129a044f25bbfa21b54494eb2" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: bank FK_135d122bb95f800df14992915d4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT "FK_135d122bb95f800df14992915d4" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: bank FK_13856596982ef082b4fc84fbe0f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT "FK_13856596982ef082b4fc84fbe0f" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: municipalities FK_161e8a326660c426728204ed8e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT "FK_161e8a326660c426728204ed8e8" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: parishes FK_169dba658436e72c6259eea01c2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parishes
    ADD CONSTRAINT "FK_169dba658436e72c6259eea01c2" FOREIGN KEY ("municipalityId") REFERENCES public.municipalities(id);


--
-- Name: payments_type FK_16dd4efb0c89e300bced8b7a1a1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments_type
    ADD CONSTRAINT "FK_16dd4efb0c89e300bced8b7a1a1" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: contributors_type FK_1af2cc2279196d5d89691e9f9f7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type
    ADD CONSTRAINT "FK_1af2cc2279196d5d89691e9f9f7" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: state FK_1c5a1a7d9dcdcd9944a6db9be76; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT "FK_1c5a1a7d9dcdcd9944a6db9be76" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: document FK_1d567174352a451d458eb9ebd46; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT "FK_1d567174352a451d458eb9ebd46" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: country FK_1e58299162002560831eba42907; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT "FK_1e58299162002560831eba42907" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: contributors_type FK_20919004eda6ea593e7e891f2ff; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type
    ADD CONSTRAINT "FK_20919004eda6ea593e7e891f2ff" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: roles_privilege FK_244750cde952ebfbad166128f1d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_244750cde952ebfbad166128f1d" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: lockers_point_of_sale FK_24b0b984f638beac345232c47d2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lockers_point_of_sale
    ADD CONSTRAINT "FK_24b0b984f638beac345232c47d2" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: transaction FK_26ba3b75368b99964d6dea5cc2c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT "FK_26ba3b75368b99964d6dea5cc2c" FOREIGN KEY ("paymentId") REFERENCES public.payment(id);


--
-- Name: state FK_2a78c0831744c8ad063fbd65c4e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT "FK_2a78c0831744c8ad063fbd65c4e" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: entities FK_2c28609e0b9c7c9ded2d565e256; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT "FK_2c28609e0b9c7c9ded2d565e256" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: municipalities FK_2d64e8a6bac48f74c0ace2f2344; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT "FK_2d64e8a6bac48f74c0ace2f2344" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: bank FK_2df2759d0eaccbec9220748cb04; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT "FK_2df2759d0eaccbec9220748cb04" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: municipalities FK_30371446c974ac9c51666da7403; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT "FK_30371446c974ac9c51666da7403" FOREIGN KEY ("stateId") REFERENCES public.state(id);


--
-- Name: procedure FK_30c8f817aea6ad5fb22f78a044d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT "FK_30c8f817aea6ad5fb22f78a044d" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: country FK_315759167f081b94b1c5781bbef; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT "FK_315759167f081b94b1c5781bbef" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: subentity FK_34eb6541dcecdf47f51ccfc835f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subentity
    ADD CONSTRAINT "FK_34eb6541dcecdf47f51ccfc835f" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: branch FK_34f2d5f869b9d1270083058d601; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT "FK_34f2d5f869b9d1270083058d601" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: users FK_368e146b785b574f42ae9e53d5e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_368e146b785b574f42ae9e53d5e" FOREIGN KEY ("roleId") REFERENCES public.role(id);


--
-- Name: coin FK_375011e703fe5fe626411d96b1b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coin
    ADD CONSTRAINT "FK_375011e703fe5fe626411d96b1b" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: lockers_point_of_sale FK_3795258688c61894a57036ef8ae; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lockers_point_of_sale
    ADD CONSTRAINT "FK_3795258688c61894a57036ef8ae" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: subentity FK_3cae16563f3a467a93ffbd5753b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subentity
    ADD CONSTRAINT "FK_3cae16563f3a467a93ffbd5753b" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: document FK_3d0038df8ca900f5fda2ff896a7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT "FK_3d0038df8ca900f5fda2ff896a7" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: point_of_sale FK_3e564f042558b523ce0a6d1cf12; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_of_sale
    ADD CONSTRAINT "FK_3e564f042558b523ce0a6d1cf12" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: tax_stamp FK_3ec6fa850cd56f4fbb31e5a23b5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamp
    ADD CONSTRAINT "FK_3ec6fa850cd56f4fbb31e5a23b5" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: role FK_3fc73ac1307382a3b92e79b4886; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_3fc73ac1307382a3b92e79b4886" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: external_request FK_4648e4d911a3c31e262adfee828; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_request
    ADD CONSTRAINT "FK_4648e4d911a3c31e262adfee828" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: procedure FK_4738ff7fe67e00124e53d8c6c98; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT "FK_4738ff7fe67e00124e53d8c6c98" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: bank_account FK_4764b8e246c4d7e7ed23b90f7a1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT "FK_4764b8e246c4d7e7ed23b90f7a1" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: external_request FK_478a4c7ee14c20b525650a138e4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_request
    ADD CONSTRAINT "FK_478a4c7ee14c20b525650a138e4" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: point_of_sale FK_47ada94f26039bc2f2fe907b367; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_of_sale
    ADD CONSTRAINT "FK_47ada94f26039bc2f2fe907b367" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: point_of_sale FK_48cb2a33a5e183937a992ab12a5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_of_sale
    ADD CONSTRAINT "FK_48cb2a33a5e183937a992ab12a5" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: status FK_4b0d46ac203bc2793a4b7ff4a9f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT "FK_4b0d46ac203bc2793a4b7ff4a9f" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: types_external_request FK_4f8d651946e054d0d81f77a6b51; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_external_request
    ADD CONSTRAINT "FK_4f8d651946e054d0d81f77a6b51" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: point_of_sale FK_4f9c1814f54eb1513e903a48fbc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_of_sale
    ADD CONSTRAINT "FK_4f9c1814f54eb1513e903a48fbc" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: roles_privilege FK_4fc9aa331b52e64ec1a397a4e50; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_4fc9aa331b52e64ec1a397a4e50" FOREIGN KEY ("privilegeId") REFERENCES public.privilege(id);


--
-- Name: calculation_factor FK_50ef7ef9e3a9071ddb22e3a7b2e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calculation_factor
    ADD CONSTRAINT "FK_50ef7ef9e3a9071ddb22e3a7b2e" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: users FK_51d635f1d983d505fb5a2f44c52; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_51d635f1d983d505fb5a2f44c52" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: lockers_point_of_sale FK_52875968c183ae18518e0e69e13; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lockers_point_of_sale
    ADD CONSTRAINT "FK_52875968c183ae18518e0e69e13" FOREIGN KEY ("lockerId") REFERENCES public.locker(id);


--
-- Name: role FK_528f294633a808293425ae2ab56; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_528f294633a808293425ae2ab56" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: users FK_52e97c477859f8019f3705abd21; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_52e97c477859f8019f3705abd21" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: branch FK_543fa3f5ab7f0d5d85671f10907; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT "FK_543fa3f5ab7f0d5d85671f10907" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: tax_stamp FK_552800377aab509c1d21e40ba43; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamp
    ADD CONSTRAINT "FK_552800377aab509c1d21e40ba43" FOREIGN KEY ("calculationFactorId") REFERENCES public.calculation_factor(id);


--
-- Name: locker FK_5680ca2de542a065a3059039ed7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locker
    ADD CONSTRAINT "FK_5680ca2de542a065a3059039ed7" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: bank_account FK_57fe4146ab12f9f7d581a42962f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT "FK_57fe4146ab12f9f7d581a42962f" FOREIGN KEY ("bankId") REFERENCES public.bank(id);


--
-- Name: users FK_5a42116cfd0ba58cc89c86eef6d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_5a42116cfd0ba58cc89c86eef6d" FOREIGN KEY ("contributorTypeId") REFERENCES public.contributors_type(id);


--
-- Name: transactions_type FK_5e2be54bde6af50cc1f7f798f20; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_type
    ADD CONSTRAINT "FK_5e2be54bde6af50cc1f7f798f20" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: calculation_factor FK_60bb305fc2b915b16e1dcf2bcd5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calculation_factor
    ADD CONSTRAINT "FK_60bb305fc2b915b16e1dcf2bcd5" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: procedure FK_6103bf68519719deb6948932d31; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT "FK_6103bf68519719deb6948932d31" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: types_external_request FK_617e6549dd96dab963e393be05f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_external_request
    ADD CONSTRAINT "FK_617e6549dd96dab963e393be05f" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: roles_privilege FK_617f7d7845622373abbd809f3a0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_617f7d7845622373abbd809f3a0" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: parishes FK_655f3eca39e2b7ca697bf046545; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parishes
    ADD CONSTRAINT "FK_655f3eca39e2b7ca697bf046545" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: payment FK_666eebb9d199f2255a2d8cbdff0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "FK_666eebb9d199f2255a2d8cbdff0" FOREIGN KEY ("lockerId") REFERENCES public.locker(id);


--
-- Name: role FK_686b8af82beeafa884598c4da41; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_686b8af82beeafa884598c4da41" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: payments_type FK_69a73824c342592ec40c667784b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments_type
    ADD CONSTRAINT "FK_69a73824c342592ec40c667784b" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: audit FK_6e25d726a45f53f3563a34586a4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit
    ADD CONSTRAINT "FK_6e25d726a45f53f3563a34586a4" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: audits_detail FK_6eb8acc427a27643348f536c535; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits_detail
    ADD CONSTRAINT "FK_6eb8acc427a27643348f536c535" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: types_external_request FK_6f0e1bdb064bc21b1d643f12f61; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_external_request
    ADD CONSTRAINT "FK_6f0e1bdb064bc21b1d643f12f61" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: payment FK_7275d1212ed427833ef3630adfb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "FK_7275d1212ed427833ef3630adfb" FOREIGN KEY ("paymentTypeId") REFERENCES public.payments_type(id);


--
-- Name: coin FK_76304370bcb1ad42a791b9597b7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coin
    ADD CONSTRAINT "FK_76304370bcb1ad42a791b9597b7" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: auditable_process FK_766c9b0558c54148302843257aa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditable_process
    ADD CONSTRAINT "FK_766c9b0558c54148302843257aa" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: state FK_7bbf47a2614a90fbc94c6524c57; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT "FK_7bbf47a2614a90fbc94c6524c57" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: auditable_process FK_7f5a20e0eec60bed7d2c191ab61; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditable_process
    ADD CONSTRAINT "FK_7f5a20e0eec60bed7d2c191ab61" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: entities FK_808f124614dc35298f5f32c55cf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT "FK_808f124614dc35298f5f32c55cf" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: calculation_factor FK_812c643917d538c3dd40875bcee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calculation_factor
    ADD CONSTRAINT "FK_812c643917d538c3dd40875bcee" FOREIGN KEY ("coinId") REFERENCES public.coin(id);


--
-- Name: tax_stamps_payment FK_8212585cc90bf0103cb8ffb265f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamps_payment
    ADD CONSTRAINT "FK_8212585cc90bf0103cb8ffb265f" FOREIGN KEY ("paymentId") REFERENCES public.payment(id);


--
-- Name: auditable_process FK_822268a984943bf94f4ba144488; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditable_process
    ADD CONSTRAINT "FK_822268a984943bf94f4ba144488" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: tax_stamps_payment FK_82847235f9c11b1be5cab53b819; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamps_payment
    ADD CONSTRAINT "FK_82847235f9c11b1be5cab53b819" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: audit FK_830f801314368987e40b25f44e5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit
    ADD CONSTRAINT "FK_830f801314368987e40b25f44e5" FOREIGN KEY ("auditableProcessId") REFERENCES public.auditable_process(id);


--
-- Name: transactions_type FK_8347861210537b14cea71ae5fe0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_type
    ADD CONSTRAINT "FK_8347861210537b14cea71ae5fe0" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: audits_detail FK_8540825d57848892c26a041f951; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits_detail
    ADD CONSTRAINT "FK_8540825d57848892c26a041f951" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: audits_detail FK_85e6955a5048dddada2884c9d05; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits_detail
    ADD CONSTRAINT "FK_85e6955a5048dddada2884c9d05" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: municipalities FK_88741d6b4c2926c207812ae4458; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT "FK_88741d6b4c2926c207812ae4458" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: privilege FK_88ab3554c9f8ee2383bc809c97e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilege
    ADD CONSTRAINT "FK_88ab3554c9f8ee2383bc809c97e" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: bank_account FK_927b04075356e6ac1f684bcffdc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT "FK_927b04075356e6ac1f684bcffdc" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: auditable_process FK_93af645f01bbb1953f1e6265e2d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditable_process
    ADD CONSTRAINT "FK_93af645f01bbb1953f1e6265e2d" FOREIGN KEY ("privilegeId") REFERENCES public.privilege(id);


--
-- Name: lockers_point_of_sale FK_953294cbdcb2ddb0cb53a0eb6c9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lockers_point_of_sale
    ADD CONSTRAINT "FK_953294cbdcb2ddb0cb53a0eb6c9" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: payment FK_96605f6105703f10a1a00158d53; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "FK_96605f6105703f10a1a00158d53" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: bank_account FK_9b1311b17da1c804379156a294b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT "FK_9b1311b17da1c804379156a294b" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: auditable_process FK_9d197abc995b74bb8d71ca4641c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditable_process
    ADD CONSTRAINT "FK_9d197abc995b74bb8d71ca4641c" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: document FK_9eac3612452020c976207f37b03; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT "FK_9eac3612452020c976207f37b03" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: contributors_type FK_a0155936de3ab846e5a4f6cb399; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type
    ADD CONSTRAINT "FK_a0155936de3ab846e5a4f6cb399" FOREIGN KEY ("roleId") REFERENCES public.role(id);


--
-- Name: parishes FK_a648a2291bd909abb5b71c6276c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parishes
    ADD CONSTRAINT "FK_a648a2291bd909abb5b71c6276c" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: transaction FK_a6c02973b42994798ae4f305993; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT "FK_a6c02973b42994798ae4f305993" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: document FK_a7783cf6b7037a607846dc80f67; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT "FK_a7783cf6b7037a607846dc80f67" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: coin FK_a92c2ffda108f5a8f91418c3df7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coin
    ADD CONSTRAINT "FK_a92c2ffda108f5a8f91418c3df7" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: transactions_type FK_aa720ca1f14a8bfe5994ede930e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_type
    ADD CONSTRAINT "FK_aa720ca1f14a8bfe5994ede930e" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: state FK_aa7f82e099df2ab39308d3e4d6d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT "FK_aa7f82e099df2ab39308d3e4d6d" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: country FK_ab0c5ad827c6e3ec3909fea3143; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT "FK_ab0c5ad827c6e3ec3909fea3143" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: municipalities FK_ae9cffdcb8612032b577f6da278; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT "FK_ae9cffdcb8612032b577f6da278" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: calculation_factor FK_af8152e057805ad94bc665030a4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calculation_factor
    ADD CONSTRAINT "FK_af8152e057805ad94bc665030a4" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: subentity FK_b210494021066e63a74df7a7c55; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subentity
    ADD CONSTRAINT "FK_b210494021066e63a74df7a7c55" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: procedure FK_b35e4e03781c286f23a1542c6bc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT "FK_b35e4e03781c286f23a1542c6bc" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: status FK_b6557455bcd7afc09587122ee98; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT "FK_b6557455bcd7afc09587122ee98" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: status FK_b8d5d13b5df15255ee77aba6eee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT "FK_b8d5d13b5df15255ee77aba6eee" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: locker FK_bca57560da7bc5c3c09f5086b38; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locker
    ADD CONSTRAINT "FK_bca57560da7bc5c3c09f5086b38" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: locker FK_bd45c7013a09b46ff8fa291e557; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locker
    ADD CONSTRAINT "FK_bd45c7013a09b46ff8fa291e557" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: subentity FK_c1fd68f6289f5e18ea4237135de; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subentity
    ADD CONSTRAINT "FK_c1fd68f6289f5e18ea4237135de" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: payment FK_c2704326ac03123ea970d31e8ca; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "FK_c2704326ac03123ea970d31e8ca" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: branch FK_c3254ff11158f942a808f3ba344; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT "FK_c3254ff11158f942a808f3ba344" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: role FK_c5d666dd8bf212b0d9ba353cb4f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_c5d666dd8bf212b0d9ba353cb4f" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: audit FK_c772ccf8b47f8c94e7737e20495; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit
    ADD CONSTRAINT "FK_c772ccf8b47f8c94e7737e20495" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: tax_stamp FK_c7b08645515e2d94cbc4c452292; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamp
    ADD CONSTRAINT "FK_c7b08645515e2d94cbc4c452292" FOREIGN KEY ("procedureId") REFERENCES public.procedure(id);


--
-- Name: branch FK_c8b6e72ddfdd41e7ff256b21658; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT "FK_c8b6e72ddfdd41e7ff256b21658" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: audit FK_c96897812a2d81e7fe8d5daa3dc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit
    ADD CONSTRAINT "FK_c96897812a2d81e7fe8d5daa3dc" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: external_request FK_ca069ef691b4741a75c30a2842d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_request
    ADD CONSTRAINT "FK_ca069ef691b4741a75c30a2842d" FOREIGN KEY ("typeExternalRequestId") REFERENCES public.types_external_request(id);


--
-- Name: users FK_cbc2509e57e67206f0791ff2b31; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_cbc2509e57e67206f0791ff2b31" FOREIGN KEY ("parishId") REFERENCES public.parishes(id);


--
-- Name: audit FK_cd7c3eded9d5466c4cfe77a853a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit
    ADD CONSTRAINT "FK_cd7c3eded9d5466c4cfe77a853a" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: roles_privilege FK_ceb39649606ec7deebc5839723d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_ceb39649606ec7deebc5839723d" FOREIGN KEY ("roleId") REFERENCES public.role(id);


--
-- Name: procedure FK_cf3b640867d866c2cd09375a95d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT "FK_cf3b640867d866c2cd09375a95d" FOREIGN KEY ("subentityId") REFERENCES public.subentity(id);


--
-- Name: roles_privilege FK_d0780d745c6a2ff3dc9a325c5f5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_d0780d745c6a2ff3dc9a325c5f5" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: locker FK_d1ee721af5a35de9cd6d0c05a66; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locker
    ADD CONSTRAINT "FK_d1ee721af5a35de9cd6d0c05a66" FOREIGN KEY ("branchId") REFERENCES public.branch(id);


--
-- Name: privilege FK_d246ef838089a51c6751b1fe6fd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilege
    ADD CONSTRAINT "FK_d246ef838089a51c6751b1fe6fd" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: transaction FK_d2c2c2e40cf2e32e72bb111f6a0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT "FK_d2c2c2e40cf2e32e72bb111f6a0" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: audits_detail FK_d3312f9ecf5d9f1783a6471fcfc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits_detail
    ADD CONSTRAINT "FK_d3312f9ecf5d9f1783a6471fcfc" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: entities FK_d39aad63a7bf13d34f9e204351e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT "FK_d39aad63a7bf13d34f9e204351e" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: bank FK_d43a923d1ad7105992a5954a594; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT "FK_d43a923d1ad7105992a5954a594" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: locker FK_d60149938995e520e36e4a9a569; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locker
    ADD CONSTRAINT "FK_d60149938995e520e36e4a9a569" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: contributors_type FK_d86acce51f75b3842f9627eea0b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type
    ADD CONSTRAINT "FK_d86acce51f75b3842f9627eea0b" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: types_external_request FK_db7150ebcfce5122737dd0f25b2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_external_request
    ADD CONSTRAINT "FK_db7150ebcfce5122737dd0f25b2" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: status FK_db87eda17c02b45b40985d0a68f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT "FK_db87eda17c02b45b40985d0a68f" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: tax_stamps_payment FK_dfe7410762ea615945bfee54e5d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamps_payment
    ADD CONSTRAINT "FK_dfe7410762ea615945bfee54e5d" FOREIGN KEY ("taxStampId") REFERENCES public.tax_stamp(id);


--
-- Name: external_request FK_e15239771e284fe10e5c0d9abee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.external_request
    ADD CONSTRAINT "FK_e15239771e284fe10e5c0d9abee" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: tax_stamp FK_e29c78c7c33f097b726b76d41e3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamp
    ADD CONSTRAINT "FK_e29c78c7c33f097b726b76d41e3" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: parishes FK_e3dbc3fc8f54b0f08a338a4c29e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parishes
    ADD CONSTRAINT "FK_e3dbc3fc8f54b0f08a338a4c29e" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: tax_stamp FK_e5ddc10b2006abbfe2ca2417ab1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamp
    ADD CONSTRAINT "FK_e5ddc10b2006abbfe2ca2417ab1" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: state FK_e81c86ceadca8731f5fca8e06f5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT "FK_e81c86ceadca8731f5fca8e06f5" FOREIGN KEY ("countryId") REFERENCES public.country(id);


--
-- Name: subentity FK_e92668ba98f866561006762a243; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subentity
    ADD CONSTRAINT "FK_e92668ba98f866561006762a243" FOREIGN KEY ("entityId") REFERENCES public.entities(id);


--
-- Name: users FK_e9d50c91bd84f566ce0ac1acf44; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_e9d50c91bd84f566ce0ac1acf44" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: privilege FK_eb5500a662448e2d52234c02f49; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilege
    ADD CONSTRAINT "FK_eb5500a662448e2d52234c02f49" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: country FK_f12d99ca36c6ade575a9ea4a14c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT "FK_f12d99ca36c6ade575a9ea4a14c" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: roles_privilege FK_f2c399597c1f8fae05e918d2c28; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_f2c399597c1f8fae05e918d2c28" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: tax_stamp FK_f4286785d364f39e97a220c7aab; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamp
    ADD CONSTRAINT "FK_f4286785d364f39e97a220c7aab" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: payments_type FK_f70b724ff4a783aabc03dfcbfec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments_type
    ADD CONSTRAINT "FK_f70b724ff4a783aabc03dfcbfec" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: transaction FK_f7e7207db0362bbc3b786c9ed16; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT "FK_f7e7207db0362bbc3b786c9ed16" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: payment FK_fa4a6e31bcb86ab9446a13a2351; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "FK_fa4a6e31bcb86ab9446a13a2351" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: tax_stamp FK_fa4f5bd3e9d41fe341cc5b9ab68; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_stamp
    ADD CONSTRAINT "FK_fa4f5bd3e9d41fe341cc5b9ab68" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: lockers_point_of_sale FK_faf5104071137c09838a5b2e433; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lockers_point_of_sale
    ADD CONSTRAINT "FK_faf5104071137c09838a5b2e433" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: bank_account FK_ffa5e5a4385ca9aeb0147fbf8f8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT "FK_ffa5e5a4385ca9aeb0147fbf8f8" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: users FK_fffa7945e50138103659f6326b7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_fffa7945e50138103659f6326b7" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- PostgreSQL database dump complete
--

