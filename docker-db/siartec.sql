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
-- Name: transactions_type_movement_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transactions_type_movement_type_enum AS ENUM (
    'DEBIT',
    'CREDIT',
    'ND'
);


ALTER TYPE public.transactions_type_movement_type_enum OWNER TO postgres;

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
-- Name: verification_contributors_exempts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.verification_contributors_exempts() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  	UPDATE users
	SET contributor_exempt=true
	WHERE 
	(date_part('year', age(birthdate)) >=CAST((SELECT value FROM parameter WHERE code='FEMALE_AGE' AND "statusId"=1) AS INTEGER) and gender='F') or
	(date_part('year', age(birthdate)) >=CAST((SELECT value FROM parameter WHERE code='MALE_AGE' AND "statusId"=1)AS INTEGER) and gender='M') or
	(date_part('year', age(birthdate)) <=CAST((SELECT value FROM parameter WHERE code='MINORS_AGE' AND "statusId"=1)AS INTEGER))
	and contributor_exempt = false
	and "contributorTypeId" = (SELECT id FROM contributors_type WHERE code='NATURAL');

  	UPDATE users
	SET contributor_exempt=false
	WHERE 
	((date_part('year', age(birthdate)) <CAST((SELECT value FROM parameter WHERE code='FEMALE_AGE' AND "statusId"=1) AS INTEGER) and gender='F') or
	(date_part('year', age(birthdate)) <CAST((SELECT value FROM parameter WHERE code='MALE_AGE' AND "statusId"=1)AS INTEGER) and gender='M')) and
	(date_part('year', age(birthdate)) >CAST((SELECT value FROM parameter WHERE code='MINORS_AGE' AND "statusId"=1)AS INTEGER))
	and "contributorTypeId" = (SELECT id FROM contributors_type WHERE code='NATURAL');
END;
$$;


ALTER FUNCTION public.verification_contributors_exempts() OWNER TO postgres;

--
-- Name: verification_contributors_exempts(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.verification_contributors_exempts(sequence_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  	UPDATE users
	SET contributor_exempt=true
	WHERE 
	(date_part('year', age(u.birthdate)) >=CAST((SELECT value FROM parameter WHERE code='FEMALE_AGE' AND "statusId"=1) AS INTEGER) and u.gender='F') or
	(date_part('year', age(u.birthdate)) >=CAST((SELECT value FROM parameter WHERE code='MALE_AGE' AND "statusId"=1)AS INTEGER) and u.gender='M') or
	(date_part('year', age(u.birthdate)) <=CAST((SELECT value FROM parameter WHERE code='MINORS_AGE' AND "statusId"=1)AS INTEGER))
	and u.contributor_exempt = false;

  	UPDATE users
	SET contributor_exempt=false
	WHERE 
	((date_part('year', age(u.birthdate)) <CAST((SELECT value FROM parameter WHERE code='FEMALE_AGE' AND "statusId"=1) AS INTEGER) and u.gender='F') or
	(date_part('year', age(u.birthdate)) <CAST((SELECT value FROM parameter WHERE code='MALE_AGE' AND "statusId"=1)AS INTEGER) and u.gender='M')) and
	(date_part('year', age(u.birthdate)) >CAST((SELECT value FROM parameter WHERE code='MINORS_AGE' AND "statusId"=1)AS INTEGER));
END;
$$;


ALTER FUNCTION public.verification_contributors_exempts(sequence_name text) OWNER TO postgres;

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
    "branchId" integer,
    "userId" integer
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
-- Name: parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parameter (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    value character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "statusId" integer,
    "createdById" integer,
    "updatedById" integer,
    "deletedById" integer,
    type character varying(15) NOT NULL,
    description character varying(256) NOT NULL
);


ALTER TABLE public.parameter OWNER TO postgres;

--
-- Name: parameter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parameter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parameter_id_seq OWNER TO postgres;

--
-- Name: parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parameter_id_seq OWNED BY public.parameter.id;


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
    code character varying(4) NOT NULL,
    is_exempt boolean DEFAULT true NOT NULL
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
    "deletedById" integer,
    movement_type public.transactions_type_movement_type_enum NOT NULL,
    description_interface character varying NOT NULL
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
-- Name: parameter id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter ALTER COLUMN id SET DEFAULT nextval('public.parameter_id_seq'::regclass);


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
4	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0108	BANCO PROVINCIAL BBVA	108	PROVINCIAL
5	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0114	BANCO DEL CARIBE C.A.	114	BANCARIBE
1	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0102	BANCO DE VENEZUELA S.A.I.C.A.	102	VENEZUELA
3	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0105	BANCO MERCANTIL C.A.	105	MERCANTIL
6	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0115	BANCO EXTERIOR C.A.	115	EXTERIOR
7	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0128	BANCO CARONI, C.A. BANCO UNIVERSAL	128	CARONI
8	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0134	Banesco Banco Universal	134	BANESCO
9	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0137	SOFITASA	137	SOFITASA
10	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0138	BANCO PLAZA	138	PLAZA
11	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0151	FONDO COMUN	151	BFC BANCO FONDO COMUN
12	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0156	100%BANCO	156	100% BANCO, BANCO UNIVERSAL
13	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0157	DELSUR BANCO UNIVERSAL	157	DEL SUR
14	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0163	BANCO DEL TESORO	163	BANCO DEL TESORO
15	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0166	BANCO AGRICOLA	166	AGRICOLA DE VENEZUELA
16	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0168	BANCRECER S.A. BANCO DE DESARROLLO	168	BANCRECER
17	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0169	MIBANCO BANCO DE DESARROLLO, C.A.	169	MI BANCO
2	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0104	BANCO VENEZOLANO DE CREDITO S.A.	104	VZLANO DE CREDITO
19	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0172	BANCAMIGA BANCO MICROFINANCIERO, C.A.	172	BANCAMIGA
20	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0174	BANPLUS BANCO COMERCIAL C.A	174	BANPLUS BANCO COMERCIAL
21	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0175	BANCO BICENTENARIO	175	BICENTENARIO
22	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0177	BANFANB	177	BANCO FUERZA ARMADA NACIONAL
23	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0191	BANCO NACIONAL DE CREDITO	191	BANCO NACIONAL CREDITO
24	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0196	ABN AMRO BANK	\N	\N
25	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0001	BANCO CENTRAL DE VENEZUELA.	\N	\N
26	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0116	BANCO OCCIDENTAL DE DESCUENTO.	\N	\N
27	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0146	BANGENTE	\N	\N
28	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0149	BANCO DEL PUEBLO SOBERANO C.A.	\N	\N
29	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0164	BANCO DE DESARROLLO DEL MICROEMPRESARIO	\N	\N
30	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0173	BANCO INTERNACIONAL DE DESARROLLO, C.A.	\N	\N
31	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0176	BANCO ESPIRITO SANTO, S.A.	\N	\N
32	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0190	CITIBANK.	\N	\N
33	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0601	INSTITUTO MUNICIPAL DE CRÉDITO POPULAR	\N	\N
18	2024-10-15 14:08:35.472587	2024-10-15 14:08:35.472587	\N	1	1	1	\N	0171	BANCO ACTIVO BANCO COMERCIAL, C.A.	171	ACTIVO BANCO UNIVERSAL
\.


--
-- Data for Name: bank_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_account (id, code, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "bankId", account_number) FROM stdin;
1	01561234	2024-11-06 22:57:43.089708	2024-11-06 22:57:43.089708	\N	1	1	1	\N	12	01560000000000001234
2	01021234	2024-11-20 22:57:34.465125	2024-11-20 22:57:34.465125	\N	1	1	1	\N	1	01020000000000001234
\.


--
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branch (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	0001	SUCURSAL QUIZANSA	2024-11-21 23:24:37.38114	2024-11-21 23:24:37.38114	\N	1	1	1	\N
\.


--
-- Data for Name: calculation_factor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calculation_factor (id, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "coinId", amount, date) FROM stdin;
72	2024-12-02 10:24:43.986104	2024-12-02 10:24:43.986104	\N	\N	\N	\N	\N	3	50.2639	2024-12-02
73	2024-12-03 23:44:25.679476	2024-12-03 23:44:25.679476	\N	\N	\N	\N	\N	3	50.3341	2024-12-03
74	2024-12-05 20:45:45.107911	2024-12-05 20:45:45.107911	\N	\N	\N	\N	\N	3	51.0159	2024-12-05
75	2024-12-08 18:57:54.686574	2024-12-08 18:57:54.686574	\N	\N	\N	\N	\N	3	51.4918	2024-12-08
76	2024-12-09 21:10:02.059352	2024-12-09 21:10:02.059352	\N	\N	\N	\N	\N	3	51.6697	2024-12-09
77	2024-12-10 20:28:21.60156	2024-12-10 20:28:21.60156	\N	\N	\N	\N	\N	3	51.7091	2024-12-10
78	2024-12-11 00:15:13.833648	2024-12-11 00:15:13.833648	\N	\N	\N	\N	\N	3	51.7091	2024-12-11
79	2024-12-16 21:00:20.157861	2024-12-16 21:00:20.157861	\N	\N	\N	\N	\N	3	52.8321	2024-12-16
80	2024-12-18 17:51:13.544956	2024-12-18 17:51:13.544956	\N	\N	\N	\N	\N	3	0.2	2024-12-18
81	2024-12-29 14:05:06.409376	2024-12-29 14:05:06.409376	\N	\N	\N	\N	\N	3	54.1069	2024-12-29
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
6	GOBIERNO	Gobierno	5	2024-11-23 20:03:52.221548	2024-11-23 20:03:52.221548	\N	1	1	1	\N	1
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
1	GACETAS	Gaceta N 1 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
2	GACETAS	Gaceta N 2 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-2.pdf
3	GACETAS	Gaceta N 3 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-3.pdf
4	GACETAS	Gaceta N 4 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-4.pdf
5	GACETAS	Gaceta N 5 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-5.pdf
14	GACETAS	Gaceta N 14 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
15	GACETAS	Gaceta N 15 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
16	GACETAS	Gaceta N 16 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
17	GACETAS	Gaceta N 17 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
18	GACETAS	Gaceta N 18 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
19	GACETAS	Gaceta N 19 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
20	GACETAS	Gaceta N 20 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
21	GACETAS	Gaceta N 21 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
6	GACETAS	Gaceta N 6 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
7	GACETAS	Gaceta N 7 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
8	GACETAS	Gaceta N 8 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
9	GACETAS	Gaceta N 9 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
10	GACETAS	Gaceta N 10 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
11	GACETAS	Gaceta N 11 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
12	GACETAS	Gaceta N 12 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
13	GACETAS	Gaceta N 13 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
22	GACETAS	Gaceta N 22 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
23	GACETAS	Gaceta N 23 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
24	GACETAS	Gaceta N 24 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
25	GACETAS	Gaceta N 25 - Ejemplo de descripcion	2024-10-29 22:24:45.465	2024-10-29 22:24:45.465	\N	1	1	1	\N	010203	2024-10-29	gaceta-1.pdf
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
270	2024121000000246	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-10 21:41:39.448528	2024-12-10 21:41:39.448528	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000246","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":775.64,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		\N
271	2024121000000247	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-10 21:42:05.219746	2024-12-10 21:42:05.219746	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000247","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":775.64,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		253
272	2024121000000248	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-10 21:49:03.85397	2024-12-10 21:49:04.477595	\N	8	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000248","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":258.5455,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}	{"sMerchantId":"341433","sTrxType":"502","sTrxId":"2024121000000248","sReferenceNo":"000000000000","sAuthCode":"000000","sRespCode":"ACCP","sRespDesc":"Solicitud Aprobada","sTerminalId":"userc2p"}	254
273	2024121000000249	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-10 21:49:16.682092	2024-12-10 21:49:16.682092	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000249","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":258.55,"sAuthKey":"145632","sReferenceNo":"0","sTerminalId":"userc2p"}		254
274	2024121000000250	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-10 21:57:27.266239	2024-12-10 21:57:27.894811	\N	8	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000250","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":258.5455,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}	{"sMerchantId":"341433","sTrxType":"502","sTrxId":"2024121000000250","sReferenceNo":"000000000000","sAuthCode":"000000","sRespCode":"ACCP","sRespDesc":"Solicitud Aprobada","sTerminalId":"userc2p"}	255
275	2024121000000251	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-10 21:57:40.615411	2024-12-10 21:57:40.615411	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000251","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":258.55,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		255
276	2024121000000252	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-10 22:01:52.243928	2024-12-10 22:01:52.856242	\N	8	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000252","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":258.5455,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}	{"sMerchantId":"341433","sTrxType":"502","sTrxId":"2024121000000252","sReferenceNo":"000000000000","sAuthCode":"000000","sRespCode":"ACCP","sRespDesc":"Solicitud Aprobada","sTerminalId":"userc2p"}	256
277	2024121000000253	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-10 22:01:59.343758	2024-12-10 22:01:59.343758	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000253","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":258.55,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		256
278	2024121000000254	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-10 22:04:45.117735	2024-12-10 22:04:45.748367	\N	8	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000254","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V4196314","sPhoneNumber":"584144144196","nAmount":258.5455,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}	{"sMerchantId":"341433","sTrxType":"502","sTrxId":"2024121000000254","sReferenceNo":"000000000000","sAuthCode":"000000","sRespCode":"ACCP","sRespDesc":"Solicitud Aprobada","sTerminalId":"userc2p"}	257
279	2024121000000255	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-10 22:04:52.223337	2024-12-10 22:04:52.223337	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000255","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V4196314","sPhoneNumber":"584144144196","nAmount":258.55,"sAuthKey":"789654","sReferenceNo":"0","sTerminalId":"userc2p"}		257
280	2024121000000256	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-10 22:16:21.35859	2024-12-10 22:16:21.975265	\N	8	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000256","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584143544554","nAmount":258.5455,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}	{"sMerchantId":"341433","sTrxType":"502","sTrxId":"2024121000000256","sReferenceNo":"000000000000","sAuthCode":"000000","sRespCode":"ACCP","sRespDesc":"Solicitud Aprobada","sTerminalId":"userc2p"}	258
281	2024121000000257	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-10 22:16:27.360132	2024-12-10 22:16:27.360132	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121000000257","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584143544554","nAmount":258.55,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		258
282	2024121600000258	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-16 22:16:29.670127	2024-12-16 22:16:29.670127	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121600000258","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"01020000000000000000","nAmount":2113.28,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		269
283	2024121600000259	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-16 22:28:52.449267	2024-12-16 22:28:52.449267	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121600000259","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"01020000000000000000","nAmount":2113.28,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		270
284	2024121800000260	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 17:53:56.649162	2024-12-18 17:53:56.649162	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000260","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		271
285	2024121800000261	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 18:23:02.031044	2024-12-18 18:23:02.031044	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000261","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"default24297146","sPhoneNumber":"default1232222","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		272
286	2024121800000262	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 18:34:25.230184	2024-12-18 18:34:25.230184	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000262","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		273
287	2024121800000263	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 18:49:44.531934	2024-12-18 18:49:44.531934	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000263","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"4141963","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		274
288	2024121800000264	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 18:51:52.450837	2024-12-18 18:51:52.450837	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000264","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"24297146","sPhoneNumber":"4196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		275
289	2024121800000265	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 18:59:07.074311	2024-12-18 18:59:07.074311	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000265","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"24297146","sPhoneNumber":"4196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		276
290	2024121800000266	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:02:04.491	2024-12-18 19:02:04.491	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000266","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		277
291	2024121800000267	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:02:56.90882	2024-12-18 19:02:56.90882	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000267","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		278
292	2024121800000268	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:09:50.910469	2024-12-18 19:09:50.910469	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000268","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		279
293	2024121800000269	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:23:24.522176	2024-12-18 19:23:24.522176	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000269","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		280
294	2024121800000270	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:24:11.304371	2024-12-18 19:24:11.304371	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000270","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		281
295	2024121800000271	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:24:11.329506	2024-12-18 19:24:11.329506	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000271","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		282
296	2024121800000272	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:24:27.982389	2024-12-18 19:24:27.982389	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000272","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		283
297	2024121800000273	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:24:53.752681	2024-12-18 19:24:53.752681	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000273","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		284
298	2024121800000274	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:25:12.215755	2024-12-18 19:25:12.215755	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000274","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		285
299	2024121800000275	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:28:45.406224	2024-12-18 19:28:45.406224	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000275","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		286
300	2024121800000276	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:32:44.005304	2024-12-18 19:32:44.005304	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000276","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		287
301	2024121800000277	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:33:44.473905	2024-12-18 19:33:44.473905	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000277","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		288
302	2024121800000278	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:35:12.622473	2024-12-18 19:35:12.622473	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000278","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		289
303	2024121800000279	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:35:17.237492	2024-12-18 19:35:17.237492	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000279","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		290
304	2024121800000280	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:37:18.482955	2024-12-18 19:37:18.482955	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000280","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		291
305	2024121800000281	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:37:21.059286	2024-12-18 19:37:21.059286	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000281","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		292
306	2024121800000282	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:37:23.280997	2024-12-18 19:37:23.280997	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000282","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		293
307	2024121800000283	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:37:54.783795	2024-12-18 19:37:54.783795	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000283","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		294
308	2024121800000284	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:40:12.432008	2024-12-18 19:40:12.432008	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000284","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		295
309	2024121800000285	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:41:09.154461	2024-12-18 19:41:09.154461	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000285","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		296
310	2024121800000286	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:43:13.289483	2024-12-18 19:43:13.289483	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000286","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		297
311	2024121800000287	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:44:42.734604	2024-12-18 19:44:42.734604	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000287","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		298
312	2024121800000288	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:47:35.495486	2024-12-18 19:47:35.495486	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000288","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		299
313	2024121800000289	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 19:47:54.450763	2024-12-18 19:47:54.450763	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000289","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		299
314	2024121800000290	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:48:41.439199	2024-12-18 19:48:41.439199	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000290","sTrxType":"502","sCurrency":"VES","sBankId":"177","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		300
315	2024121800000291	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 19:48:48.714492	2024-12-18 19:48:48.714492	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000291","sTrxType":"202","sCurrency":"VES","sBankId":"177","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		300
316	2024121800000292	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:54:38.829912	2024-12-18 19:54:38.829912	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000292","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V151654154","sPhoneNumber":"584144146666","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		301
317	2024121800000293	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 19:54:48.458936	2024-12-18 19:54:48.458936	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000293","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V151654154","sPhoneNumber":"584144146666","nAmount":1068.8,"sAuthKey":"212212","sReferenceNo":"0","sTerminalId":"userc2p"}		301
318	2024121800000294	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:57:15.46286	2024-12-18 19:57:15.46286	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000294","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V4196314","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		302
319	2024121800000295	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 19:57:20.923555	2024-12-18 19:57:20.923555	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000295","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V4196314","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		302
320	2024121800000296	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 19:59:54.831894	2024-12-18 19:59:54.831894	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000296","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V1111111","sPhoneNumber":"0102010203020102dd","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		303
321	2024121800000297	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:00:24.975149	2024-12-18 20:00:24.975149	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000297","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V1111111","sPhoneNumber":"010203020102dd","nAmount":1068.8,"sAuthKey":"123598","sReferenceNo":"0","sTerminalId":"userc2p"}		303
322	2024121800000298	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 20:10:15.456381	2024-12-18 20:10:15.456381	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000298","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"01021515415155555d","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		304
323	2024121800000299	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:11:20.881194	2024-12-18 20:11:20.881194	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000299","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"1515415155555d","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		304
324	2024121800000300	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 20:13:19.707836	2024-12-18 20:13:19.707836	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000300","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V414419631","sPhoneNumber":"01025454545555kkkk","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		305
325	2024121800000301	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:13:38.901898	2024-12-18 20:13:38.901898	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000301","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V414419631","sPhoneNumber":"5454545555kkkk","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		305
326	2024121800000302	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 20:16:17.298287	2024-12-18 20:16:17.298287	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000302","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"010224297146ffffff","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		306
327	2024121800000303	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:16:45.395447	2024-12-18 20:16:45.395447	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000303","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"24297146ffffff","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		306
328	2024121800000304	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 20:44:48.389932	2024-12-18 20:44:48.389932	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000304","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V222222222","sPhoneNumber":"010222222222222222","nAmount":2137.6,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		307
329	2024121800000305	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:45:07.372737	2024-12-18 20:45:07.372737	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000305","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V222222222","sPhoneNumber":"22222222222222","nAmount":2137.6,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		307
330	2024121800000306	External Request - Solicitud de Clave DBI (Método de pago: Cuenta)	2024-12-18 20:50:58.433592	2024-12-18 20:50:58.433592	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000306","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V222222222","sPhoneNumber":"010222222222222222","nAmount":2137.6,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		307
331	2024121800000307	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:51:07.249032	2024-12-18 20:51:07.249032	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000307","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V222222222","sPhoneNumber":"22222222222222","nAmount":2137.6,"sAuthKey":"233445","sReferenceNo":"0","sTerminalId":"userc2p"}		307
332	2024121800000308	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 20:52:13.31876	2024-12-18 20:52:13.31876	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000308","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"010241963141111111","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		308
333	2024121800000309	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:52:48.697636	2024-12-18 20:52:48.697636	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000309","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"41963141111111","nAmount":1068.8,"sAuthKey":"234564","sReferenceNo":"0","sTerminalId":"userc2p"}		308
334	2024121800000310	External Request - Solicitud de Clave DBI (Método de pago: Cuenta)	2024-12-18 20:53:35.807678	2024-12-18 20:53:35.807678	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000310","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"010241963141111111","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		308
335	2024121800000311	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:53:39.24323	2024-12-18 20:53:39.24323	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000311","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"41963141111111","nAmount":1068.8,"sAuthKey":"234564","sReferenceNo":"0","sTerminalId":"userc2p"}		308
336	2024121800000312	External Request - Solicitud de Clave DBI (Método de pago: Cuenta)	2024-12-18 20:53:54.052621	2024-12-18 20:53:54.052621	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000312","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"010241963141111111","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		308
337	2024121800000313	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:53:57.212651	2024-12-18 20:53:57.212651	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000313","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"41963141111111","nAmount":1068.8,"sAuthKey":"234564","sReferenceNo":"0","sTerminalId":"userc2p"}		308
338	2024121800000314	External Request - Solicitud de Clave DBI (Método de pago: Cuenta)	2024-12-18 20:55:06.326912	2024-12-18 20:55:06.326912	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000314","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"010241963141111111","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		308
339	2024121800000315	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:55:08.536949	2024-12-18 20:55:08.536949	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000315","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"41963141111111","nAmount":1068.8,"sAuthKey":"234564","sReferenceNo":"0","sTerminalId":"userc2p"}		308
340	2024121800000316	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 20:55:12.245189	2024-12-18 20:55:12.245189	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000316","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"010241963141111111","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		309
341	2024121800000317	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:55:17.955553	2024-12-18 20:55:17.955553	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000317","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"41963141111111","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		309
342	2024121800000318	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 20:55:24.663182	2024-12-18 20:55:24.663182	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000318","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"010241963141111111","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		310
343	2024121800000319	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:55:32.002425	2024-12-18 20:55:32.002425	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000319","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"41963141111111","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		310
344	2024121800000320	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 20:55:34.76881	2024-12-18 20:55:34.76881	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000320","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"010241963141111111","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		311
345	2024121800000321	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:55:46.624255	2024-12-18 20:55:46.624255	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000321","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"41963141111111","nAmount":1068.8,"sAuthKey":"123445","sReferenceNo":"0","sTerminalId":"userc2p"}		311
346	2024121800000322	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 20:56:10.565979	2024-12-18 20:56:10.565979	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000322","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"010241963141111111","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		312
347	2024121800000323	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 20:56:18.504583	2024-12-18 20:56:18.504583	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000323","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"41963141111111","nAmount":1068.8,"sAuthKey":"134567","sReferenceNo":"0","sTerminalId":"userc2p"}		312
348	2024121800000324	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:00:46.121372	2024-12-18 21:00:46.121372	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000324","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"4744444","sPhoneNumber":"01021234567896578963","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		313
349	2024121800000325	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 21:01:04.007868	2024-12-18 21:01:04.007868	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000325","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"4744444","sPhoneNumber":"1234567896578963","nAmount":1068.8,"sAuthKey":"441554","sReferenceNo":"0","sTerminalId":"userc2p"}		313
350	2024121800000326	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:03:28.711774	2024-12-18 21:03:28.711774	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000326","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"132654789","sPhoneNumber":"584141234567","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		314
351	2024121800000327	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:07:07.296086	2024-12-18 21:07:07.296086	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000327","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"123456789","sPhoneNumber":"default1234567","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		315
352	2024121800000328	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:09:00.294373	2024-12-18 21:09:00.294373	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000328","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"154545454","sPhoneNumber":"584141234567","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		316
353	2024121800000329	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:15:10.762725	2024-12-18 21:15:10.762725	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000329","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"235432345","sPhoneNumber":"584142345678","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		317
354	2024121800000330	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:17:46.684374	2024-12-18 21:17:46.684374	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000330","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V1234567","sPhoneNumber":"584141234567","nAmount":12825.62,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		318
355	2024121800000331	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:17:53.542619	2024-12-18 21:17:53.542619	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000331","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V1234567","sPhoneNumber":"584141234567","nAmount":12825.62,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		318
356	2024121800000332	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:18:59.957465	2024-12-18 21:18:59.957465	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000332","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V1244567","sPhoneNumber":"01022345666666ggg555","nAmount":2137.6,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		319
357	2024121800000333	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 21:19:06.579871	2024-12-18 21:19:06.579871	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000333","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V1244567","sPhoneNumber":"2345666666ggg555","nAmount":2137.6,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		319
358	2024121800000334	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:19:26.754411	2024-12-18 21:19:26.754411	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000334","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V1244567","sPhoneNumber":"01020103040506070809","nAmount":2137.6,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		320
359	2024121800000335	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 21:19:33.269934	2024-12-18 21:19:33.269934	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000335","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V1244567","sPhoneNumber":"0103040506070809","nAmount":2137.6,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		320
360	2024121800000336	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:22:08.082789	2024-12-18 21:22:08.082789	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000336","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V414419631","sPhoneNumber":"584141234658","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		321
361	2024121800000337	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:22:14.2207	2024-12-18 21:22:14.2207	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000337","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V414419631","sPhoneNumber":"584141234658","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		321
362	2024121800000338	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:22:51.59821	2024-12-18 21:22:51.59821	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000338","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"01024123654789632145","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		322
363	2024121800000339	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 21:22:58.861028	2024-12-18 21:22:58.861028	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000339","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"01024123654789632145","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		322
364	2024121800000340	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:24:14.988977	2024-12-18 21:24:14.988977	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000340","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"0102242971422222222d","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		323
365	2024121800000341	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 21:24:21.91668	2024-12-18 21:24:21.91668	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000341","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"0102242971422222222d","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		323
366	2024121800000342	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:25:35.455273	2024-12-18 21:25:35.455273	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000342","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V2222222","sPhoneNumber":"584142222222","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		324
367	2024121800000343	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:32:58.066302	2024-12-18 21:32:58.066302	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000343","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V123456789","sPhoneNumber":"584144215632","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		325
368	2024121800000344	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:33:14.252581	2024-12-18 21:33:14.252581	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000344","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V123456789","sPhoneNumber":"584144215632","nAmount":1068.8,"sAuthKey":"123333","sReferenceNo":"0","sTerminalId":"userc2p"}		325
369	2024121800000345	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:34:14.636321	2024-12-18 21:34:14.636321	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000345","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		326
370	2024121800000346	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:34:21.907895	2024-12-18 21:34:21.907895	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000346","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"159876","sReferenceNo":"0","sTerminalId":"userc2p"}		326
371	2024121800000347	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:36:03.831586	2024-12-18 21:36:03.831586	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000347","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"159876","sReferenceNo":"0","sTerminalId":"userc2p"}		326
372	2024121800000348	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:36:10.017361	2024-12-18 21:36:10.017361	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000348","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		327
373	2024121800000349	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:36:15.524647	2024-12-18 21:36:15.524647	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000349","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		327
374	2024121800000350	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:36:51.60388	2024-12-18 21:36:51.60388	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000350","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		328
375	2024121800000351	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:36:56.394067	2024-12-18 21:36:56.394067	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000351","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"615555","sReferenceNo":"0","sTerminalId":"userc2p"}		328
376	2024121800000352	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:37:35.515264	2024-12-18 21:37:35.515264	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000352","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V66565656","sPhoneNumber":"584145545455","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		329
377	2024121800000353	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:37:40.914137	2024-12-18 21:37:40.914137	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000353","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V66565656","sPhoneNumber":"584145545455","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		329
378	2024121800000354	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:39:09.660856	2024-12-18 21:39:09.660856	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000354","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V66565656","sPhoneNumber":"584145545455","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		330
379	2024121800000355	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:39:14.273172	2024-12-18 21:39:14.273172	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000355","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V66565656","sPhoneNumber":"584145545455","nAmount":1068.8,"sAuthKey":"156332","sReferenceNo":"0","sTerminalId":"userc2p"}		330
380	2024121800000356	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:43:30.158558	2024-12-18 21:43:30.158558	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000356","sTrxType":"502","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		331
381	2024121800000357	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 21:43:35.671017	2024-12-18 21:43:35.671017	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000357","sTrxType":"202","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"584144196314","nAmount":1068.8,"sAuthKey":"151515","sReferenceNo":"0","sTerminalId":"userc2p"}		331
382	2024121800000358	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:44:25.002936	2024-12-18 21:44:25.002936	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000358","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"01022429714222222222","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		332
383	2024121800000359	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 21:44:32.864218	2024-12-18 21:44:32.864218	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000359","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"01022429714222222222","nAmount":1068.8,"sAuthKey":"151555","sReferenceNo":"0","sTerminalId":"userc2p"}		332
384	2024121800000360	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 21:44:46.46848	2024-12-18 21:44:46.46848	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000360","sTrxType":"522","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"01022429714222222222","nAmount":1068.8,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		333
385	2024121800000361	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 21:44:50.737876	2024-12-18 21:44:50.737876	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000361","sTrxType":"222","sCurrency":"VES","sBankId":"102","sDocumentId":"V24297146","sPhoneNumber":"01022429714222222222","nAmount":1068.8,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		333
386	2024121800000362	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 22:12:14.17941	2024-12-18 22:12:14.17941	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000362","sTrxType":"502","sCurrency":"VES","sBankId":"156","sDocumentId":"V8612413","sPhoneNumber":"584244196314","nAmount":1,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		334
387	2024121800000363	External Request - Cobro DBI (Método de pago: Teléfono)	2024-12-18 22:12:33.775041	2024-12-18 22:12:33.775041	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000363","sTrxType":"202","sCurrency":"VES","sBankId":"156","sDocumentId":"V8612413","sPhoneNumber":"584244196314","nAmount":1,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		334
388	2024121800000364	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 22:16:01.931759	2024-12-18 22:16:01.931759	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000364","sTrxType":"522","sCurrency":"VES","sBankId":"138","sDocumentId":"V8612413","sPhoneNumber":"01381234567891234567","nAmount":2,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		335
389	2024121800000365	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 22:16:10.528621	2024-12-18 22:16:10.528621	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000365","sTrxType":"222","sCurrency":"VES","sBankId":"138","sDocumentId":"V8612413","sPhoneNumber":"01381234567891234567","nAmount":2,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		335
390	2024121800000366	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 22:16:40.725139	2024-12-18 22:16:40.725139	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000366","sTrxType":"522","sCurrency":"VES","sBankId":"138","sDocumentId":"V8612413","sPhoneNumber":"01381234567891785489","nAmount":2,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		336
391	2024121800000367	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 22:16:50.003652	2024-12-18 22:16:50.003652	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000367","sTrxType":"222","sCurrency":"VES","sBankId":"138","sDocumentId":"V8612413","sPhoneNumber":"01381234567891785489","nAmount":2,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		336
392	2024121800000368	External Request - Solicitud de Clave DBI (Método de pago: Teléfono)	2024-12-18 22:17:29.335889	2024-12-18 22:17:29.335889	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000368","sTrxType":"522","sCurrency":"VES","sBankId":"138","sDocumentId":"V8612413","sPhoneNumber":"01381234567891785489","nAmount":2,"sAuthKey":"0","sReferenceNo":"0","sTerminalId":"userc2p"}		337
393	2024121800000369	External Request - Cobro DBI (Método de pago: Cuenta)	2024-12-18 22:17:38.651355	2024-12-18 22:17:38.651355	\N	7	\N	\N	\N	1	https://www8.100x100banco.com/100p2pCert/api/v1/PagoDBI	{"sMerchantId":"341433","sTrxId":"2024121800000369","sTrxType":"222","sCurrency":"VES","sBankId":"138","sDocumentId":"V8612413","sPhoneNumber":"01381234567891785489","nAmount":2,"sAuthKey":"123456","sReferenceNo":"0","sTerminalId":"userc2p"}		337
\.


--
-- Data for Name: locker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locker (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "branchId", "userId") FROM stdin;
1	001	Taquilla 1 - Quizanda	2024-11-24 11:22:58.689296	2024-11-24 11:22:58.689296	\N	1	1	1	\N	1	2
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
-- Data for Name: parameter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parameter (id, code, value, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", type, description) FROM stdin;
1	MALE_AGE	60	2024-12-14 23:05:50.076677	2024-12-14 23:05:50.076677	\N	1	1	1	\N	number	Edad masculina - Adulto mayor
2	FEMALE_AGE	55	2024-12-14 23:05:50.076677	2024-12-14 23:05:50.076677	\N	1	1	1	\N	number	Edad femenina - Adulto mayor
3	MINORS_AGE	8	2024-12-14 23:05:50.076677	2024-12-14 23:05:50.076677	\N	1	1	1	\N	number	Edad niños - Menores
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
197	775.6365000000001	2024-12-10 21:40:22.017728	2024-12-10 21:42:06.079788	\N	4	\N	\N	\N	\N	1
198	258.5455	2024-12-10 21:49:03.777454	2024-12-10 21:49:17.171101	\N	4	\N	\N	\N	\N	1
199	258.5455	2024-12-10 21:57:27.187301	2024-12-10 21:57:41.096985	\N	4	\N	\N	\N	\N	1
200	258.5455	2024-12-10 22:01:52.165166	2024-12-10 22:01:59.824049	\N	4	\N	\N	\N	\N	1
201	258.5455	2024-12-10 22:04:45.051258	2024-12-10 22:04:52.690561	\N	4	\N	\N	\N	\N	1
202	258.5455	2024-12-10 22:16:21.27953	2024-12-10 22:16:27.847063	\N	4	\N	\N	\N	\N	1
203	258.5455	2024-12-10 23:36:10.727901	2024-12-10 23:36:10.727901	\N	4	\N	\N	\N	\N	2
205	517.091	2024-12-10 23:40:59.675692	2024-12-10 23:40:59.675692	\N	4	\N	\N	\N	\N	2
207	258.5455	2024-12-11 00:15:32.613576	2024-12-11 00:15:32.613576	\N	3	\N	\N	\N	\N	2
208	258.55	2024-12-11 00:17:05.190431	2024-12-11 00:17:05.190431	\N	3	\N	\N	\N	\N	2
209	258.55	2024-12-11 00:17:24.675706	2024-12-11 00:17:24.675706	\N	3	\N	\N	\N	\N	2
210	258.55	2024-12-11 00:17:54.0141	2024-12-11 00:17:54.0141	\N	3	\N	\N	\N	\N	2
211	258.55	2024-12-11 00:20:16.571048	2024-12-11 00:20:16.681109	\N	4	\N	\N	\N	\N	2
212	258.55	2024-12-11 00:25:34.239146	2024-12-11 00:25:34.310304	\N	4	\N	\N	\N	\N	2
213	258.55	2024-12-11 00:27:34.924484	2024-12-11 00:27:34.98201	\N	4	\N	\N	\N	\N	2
214	258.55	2024-12-11 00:31:00.653265	2024-12-11 00:31:00.735874	\N	4	\N	\N	\N	\N	2
215	258.55	2024-12-11 00:32:12.301363	2024-12-11 00:32:12.36482	\N	4	\N	\N	\N	\N	2
216	258.55	2024-12-11 00:32:48.742457	2024-12-11 00:32:48.805138	\N	4	\N	\N	\N	\N	2
217	258.55	2024-12-11 00:33:39.916966	2024-12-11 00:33:39.983813	\N	4	\N	\N	\N	\N	2
218	258.55	2024-12-11 00:35:08.799858	2024-12-11 00:35:08.935834	\N	4	\N	\N	\N	\N	2
220	517.09	2024-12-11 00:35:57.050772	2024-12-11 00:35:57.050772	\N	3	\N	\N	\N	\N	2
221	517.09	2024-12-11 00:36:48.497429	2024-12-11 00:36:48.590033	\N	4	\N	\N	\N	\N	2
222	2113.28	2024-12-16 22:16:29.450498	2024-12-16 22:16:29.450498	\N	3	\N	\N	\N	\N	1
223	2113.28	2024-12-16 22:28:52.297914	2024-12-16 22:28:52.297914	\N	3	\N	\N	\N	\N	1
224	1068.8	2024-12-18 17:53:56.552124	2024-12-18 17:53:56.552124	\N	3	\N	\N	\N	\N	1
225	1068.8	2024-12-18 18:23:01.848644	2024-12-18 18:23:01.848644	\N	3	\N	\N	\N	\N	1
226	1068.8	2024-12-18 18:34:25.146449	2024-12-18 18:34:25.146449	\N	3	\N	\N	\N	\N	1
227	1068.8	2024-12-18 18:49:44.421206	2024-12-18 18:49:44.421206	\N	3	\N	\N	\N	\N	1
228	1068.8	2024-12-18 18:51:52.373028	2024-12-18 18:51:52.373028	\N	3	\N	\N	\N	\N	1
229	1068.8	2024-12-18 18:59:07.023787	2024-12-18 18:59:07.023787	\N	3	\N	\N	\N	\N	1
230	1068.8	2024-12-18 19:02:04.420275	2024-12-18 19:02:04.420275	\N	3	\N	\N	\N	\N	1
231	1068.8	2024-12-18 19:02:56.794332	2024-12-18 19:02:56.794332	\N	3	\N	\N	\N	\N	1
232	1068.8	2024-12-18 19:09:50.838573	2024-12-18 19:09:50.838573	\N	3	\N	\N	\N	\N	1
233	1068.8	2024-12-18 19:23:24.464123	2024-12-18 19:23:24.464123	\N	3	\N	\N	\N	\N	1
234	1068.8	2024-12-18 19:24:11.234227	2024-12-18 19:24:11.234227	\N	3	\N	\N	\N	\N	1
235	1068.8	2024-12-18 19:24:11.23802	2024-12-18 19:24:11.23802	\N	3	\N	\N	\N	\N	1
236	1068.8	2024-12-18 19:24:27.929667	2024-12-18 19:24:27.929667	\N	3	\N	\N	\N	\N	1
237	1068.8	2024-12-18 19:24:53.697993	2024-12-18 19:24:53.697993	\N	3	\N	\N	\N	\N	1
238	1068.8	2024-12-18 19:25:12.168262	2024-12-18 19:25:12.168262	\N	3	\N	\N	\N	\N	1
239	1068.8	2024-12-18 19:28:45.368124	2024-12-18 19:28:45.368124	\N	3	\N	\N	\N	\N	1
240	1068.8	2024-12-18 19:32:43.960514	2024-12-18 19:32:43.960514	\N	3	\N	\N	\N	\N	1
241	1068.8	2024-12-18 19:33:44.430841	2024-12-18 19:33:44.430841	\N	3	\N	\N	\N	\N	1
242	1068.8	2024-12-18 19:35:12.578809	2024-12-18 19:35:12.578809	\N	3	\N	\N	\N	\N	1
243	1068.8	2024-12-18 19:35:17.170944	2024-12-18 19:35:17.170944	\N	3	\N	\N	\N	\N	1
244	1068.8	2024-12-18 19:37:18.431866	2024-12-18 19:37:18.431866	\N	3	\N	\N	\N	\N	1
245	1068.8	2024-12-18 19:37:20.995373	2024-12-18 19:37:20.995373	\N	3	\N	\N	\N	\N	1
246	1068.8	2024-12-18 19:37:23.222792	2024-12-18 19:37:23.222792	\N	3	\N	\N	\N	\N	1
247	1068.8	2024-12-18 19:37:54.712705	2024-12-18 19:37:54.712705	\N	3	\N	\N	\N	\N	1
248	1068.8	2024-12-18 19:40:12.388172	2024-12-18 19:40:12.388172	\N	3	\N	\N	\N	\N	1
249	1068.8	2024-12-18 19:41:09.103519	2024-12-18 19:41:09.103519	\N	3	\N	\N	\N	\N	1
250	1068.8	2024-12-18 19:43:13.20526	2024-12-18 19:43:13.20526	\N	3	\N	\N	\N	\N	1
251	1068.8	2024-12-18 19:44:42.688767	2024-12-18 19:44:42.688767	\N	3	\N	\N	\N	\N	1
252	1068.8	2024-12-18 19:47:35.408827	2024-12-18 19:47:55.338589	\N	4	\N	\N	\N	\N	1
253	1068.8	2024-12-18 19:48:41.37566	2024-12-18 19:48:49.229151	\N	4	\N	\N	\N	\N	1
254	1068.8	2024-12-18 19:54:38.756927	2024-12-18 19:54:48.900702	\N	4	\N	\N	\N	\N	1
255	1068.8	2024-12-18 19:57:15.404116	2024-12-18 19:57:21.401742	\N	4	\N	\N	\N	\N	1
256	1068.8	2024-12-18 19:59:54.761141	2024-12-18 19:59:54.761141	\N	3	\N	\N	\N	\N	1
257	1068.8	2024-12-18 20:10:15.410593	2024-12-18 20:10:15.410593	\N	3	\N	\N	\N	\N	1
258	1068.8	2024-12-18 20:13:19.625485	2024-12-18 20:13:19.625485	\N	3	\N	\N	\N	\N	1
259	1068.8	2024-12-18 20:16:17.235026	2024-12-18 20:16:17.235026	\N	3	\N	\N	\N	\N	1
260	2137.6	2024-12-18 20:44:48.268896	2024-12-18 20:44:48.268896	\N	3	\N	\N	\N	\N	1
261	1068.8	2024-12-18 20:52:13.225032	2024-12-18 20:52:13.225032	\N	3	\N	\N	\N	\N	1
262	1068.8	2024-12-18 20:55:12.192825	2024-12-18 20:55:12.192825	\N	3	\N	\N	\N	\N	1
263	1068.8	2024-12-18 20:55:24.598181	2024-12-18 20:55:24.598181	\N	3	\N	\N	\N	\N	1
264	1068.8	2024-12-18 20:55:34.697851	2024-12-18 20:55:34.697851	\N	3	\N	\N	\N	\N	1
265	1068.8	2024-12-18 20:56:10.468255	2024-12-18 20:56:10.468255	\N	3	\N	\N	\N	\N	1
266	1068.8	2024-12-18 21:00:46.028783	2024-12-18 21:00:46.028783	\N	3	\N	\N	\N	\N	1
267	1068.8	2024-12-18 21:03:28.637796	2024-12-18 21:03:28.637796	\N	3	\N	\N	\N	\N	1
268	1068.8	2024-12-18 21:07:07.236871	2024-12-18 21:07:07.236871	\N	3	\N	\N	\N	\N	1
269	1068.8	2024-12-18 21:09:00.209846	2024-12-18 21:09:00.209846	\N	3	\N	\N	\N	\N	1
270	1068.8	2024-12-18 21:15:10.688487	2024-12-18 21:15:10.688487	\N	3	\N	\N	\N	\N	1
271	12825.62	2024-12-18 21:17:46.468648	2024-12-18 21:17:54.320595	\N	4	\N	\N	\N	\N	1
272	2137.6	2024-12-18 21:18:59.824923	2024-12-18 21:18:59.824923	\N	3	\N	\N	\N	\N	1
273	2137.6	2024-12-18 21:19:26.639492	2024-12-18 21:19:26.639492	\N	3	\N	\N	\N	\N	1
274	1068.8	2024-12-18 21:22:07.999421	2024-12-18 21:22:14.68842	\N	4	\N	\N	\N	\N	1
275	1068.8	2024-12-18 21:22:51.534915	2024-12-18 21:22:59.308187	\N	4	\N	\N	\N	\N	1
276	1068.8	2024-12-18 21:24:14.902759	2024-12-18 21:24:22.379876	\N	4	\N	\N	\N	\N	1
277	1068.8	2024-12-18 21:25:35.35174	2024-12-18 21:25:35.35174	\N	3	\N	\N	\N	\N	1
278	1068.8	2024-12-18 21:32:57.977214	2024-12-18 21:33:14.723065	\N	4	\N	\N	\N	\N	1
285	1068.8	2024-12-18 21:44:24.917406	2024-12-18 21:44:33.333194	\N	4	\N	\N	\N	\N	1
279	1068.8	2024-12-18 21:34:14.554367	2024-12-18 21:36:04.370028	\N	4	\N	\N	\N	\N	1
280	1068.8	2024-12-18 21:36:09.939425	2024-12-18 21:36:16.107113	\N	4	\N	\N	\N	\N	1
281	1068.8	2024-12-18 21:36:51.556996	2024-12-18 21:36:56.599564	\N	4	\N	\N	\N	\N	1
282	1068.8	2024-12-18 21:37:35.430522	2024-12-18 21:37:41.115383	\N	4	\N	\N	\N	\N	1
283	1068.8	2024-12-18 21:39:09.612429	2024-12-18 21:39:14.463372	\N	4	\N	\N	\N	\N	1
284	1068.8	2024-12-18 21:43:30.069365	2024-12-18 21:43:36.096576	\N	4	\N	\N	\N	\N	1
286	1068.8	2024-12-18 21:44:46.419168	2024-12-18 21:44:50.924623	\N	4	\N	\N	\N	\N	1
287	1	2024-12-18 22:12:14.099728	2024-12-18 22:12:34.635714	\N	4	\N	\N	\N	\N	1
288	2	2024-12-18 22:16:01.842084	2024-12-18 22:16:10.977964	\N	4	\N	\N	\N	\N	1
289	2	2024-12-18 22:16:40.636172	2024-12-18 22:16:50.423347	\N	4	\N	\N	\N	\N	1
290	2	2024-12-18 22:17:29.198185	2024-12-18 22:17:39.080959	\N	4	\N	\N	\N	\N	1
291	270.53	2024-12-29 14:27:02.689207	2024-12-29 14:27:02.689207	\N	3	\N	\N	\N	1	2
292	270.53	2024-12-29 14:28:46.651148	2024-12-29 14:28:46.651148	\N	3	\N	\N	\N	1	2
293	270.53	2024-12-29 14:39:12.249476	2024-12-29 14:39:12.249476	\N	3	\N	\N	\N	1	2
294	270.53	2024-12-29 14:40:33.804175	2024-12-29 14:40:33.804175	\N	3	\N	\N	\N	1	2
295	270.53	2024-12-29 14:42:12.929884	2024-12-29 14:42:13.036158	\N	4	\N	\N	\N	1	2
296	270.53	2024-12-29 15:48:16.716262	2024-12-29 15:48:16.805855	\N	4	\N	\N	\N	1	2
\.


--
-- Data for Name: payments_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments_type (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	ONLINE	Boton de Pago 100% banco	2024-11-03 11:45:32.3193	2024-11-03 11:45:32.3193	\N	1	1	1	\N
2	LOCKER	Pago en Taquilla	2024-11-03 11:46:23.18	2024-11-03 11:46:23.180249	\N	1	1	1	\N
\.


--
-- Data for Name: point_of_sale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.point_of_sale (id, code, description, serial, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "bankAccountId") FROM stdin;
1	0001	Punto de Venta 1 - Sede Quizanda	123456	2024-11-20 22:59:47.154098	2024-11-20 22:59:47.154098	\N	1	1	1	\N	1
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

COPY public.procedure (id, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "subentityId", is_specific_value, value, code, is_exempt) FROM stdin;
2	Inscripcion de sentencia de separacion de cuerpos, donde no se adjudiquen bienes inmuebles	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0002	t
8	Inscripcion de ttulos o certificados  de profesionalizacion	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0008	t
9	Copias certificadas de documentos inscritos.	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0009	t
10	Copias o reproducciones simples de los documentos inscritos.	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0010	t
12	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0012	t
13	Actas de remate.	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0013	t
15	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0015	t
16	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0016	t
17	Certificacion de gravamenes	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0017	t
18	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0018	t
19	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0019	t
20	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0020	t
21	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0021	t
22	Documento de particiones de herencias	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0022	t
23	Cierre de titularidad.-	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0023	t
24	Documento de parcelamiento	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0024	t
25	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0025	t
26	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0026	t
27	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0027	t
28	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0012	t
29	Actas de remate.	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0013	t
30	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0014	t
31	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0015	t
32	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0016	t
33	Certificacion de gravamenes	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0017	t
34	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0018	t
35	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0019	t
36	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0020	t
37	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0021	t
38	Documento de particiones de herencias	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0022	t
39	Cierre de titularidad.-	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0023	t
40	Documento de parcelamiento	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0024	t
41	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0025	t
42	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0026	t
43	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:23:19.133	2024-11-04 14:23:19.133	\N	1	1	1	\N	3	f	\N	0027	t
44	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0012	t
45	Actas de remate.	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0013	t
46	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0014	t
3	Inscripcion de sentencia de  nulidad de matrimonio, donde no se adjudiquen bienes inmuebles	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0003	t
4	Estampar notas marginales de sentencias de divorcio, separaciones de cuerpos, nulidad de matrimono	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0004	t
5	Legalizacion de firmas. 	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0005	t
6	Declaraciones juradas de caracter academico permitidas por la Ley	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0006	t
7	Inscripcion de ttulos o certificados academicos de profesionalizacion	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0007	t
14	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:21:32.192	2024-11-04 14:21:32.192	\N	1	1	1	\N	2	f	\N	0014	t
49	Certificacion de gravamenes	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0017	t
50	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0018	t
51	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0019	t
52	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0020	t
53	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0021	t
54	Documento de particiones de herencias	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0022	t
55	Cierre de titularidad.-	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0023	t
56	Documento de parcelamiento	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0024	t
57	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0025	t
58	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0026	t
60	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0012	t
61	Actas de remate.	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0013	t
1	Inscripcion de sentencias de divorcio, donde no se adjudiquen bienes inmuebles	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	f	\N	0001	f
62	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0014	t
64	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0016	t
65	Certificacion de gravamenes	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0017	t
66	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0018	t
67	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0019	t
68	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0020	t
69	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0021	t
70	Documento de particiones de herencias	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0022	t
71	Cierre de titularidad.-	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0023	t
72	Documento de parcelamiento	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0024	t
73	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0025	t
74	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0026	t
75	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0027	t
76	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0012	t
77	Actas de remate.	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0013	t
78	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0014	t
80	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0016	t
81	Certificacion de gravamenes	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0017	t
82	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0018	t
83	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0019	t
84	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0020	t
85	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0021	t
86	Documento de particiones de herencias	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0022	t
87	Cierre de titularidad.-	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0023	t
88	Documento de parcelamiento	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0024	t
89	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0025	t
90	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0026	t
91	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0027	t
92	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0012	t
93	Actas de remate.	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0013	t
94	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0014	t
95	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0015	t
96	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0016	t
97	Certificacion de gravamenes	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0017	t
98	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0018	t
99	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0019	t
100	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0020	t
101	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0021	t
102	Documento de particiones de herencias	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0022	t
103	Cierre de titularidad.-	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0023	t
104	Documento de parcelamiento	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0024	t
105	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0025	t
106	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0026	t
48	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0016	t
111	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0015	t
112	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0016	t
113	Certificacion de gravamenes	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0017	t
114	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0018	t
115	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0019	t
116	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0020	t
117	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0021	t
118	Documento de particiones de herencias	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0022	t
119	Cierre de titularidad.-	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0023	t
120	Documento de parcelamiento	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0024	t
121	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0025	t
122	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0026	t
123	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0027	t
124	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0012	t
125	Actas de remate.	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0013	t
126	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0014	t
128	Decretos de interdiccion o inhabilitacion civil	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0016	t
129	Certificacion de gravamenes	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0017	t
130	Copias certificadas de actos o instrumentos  que reposen en los archivos de los Registros	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0018	t
131	Actos traslativos de la propiedad de  inmuebles	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0019	t
132	Inscripcion de capitulaciones matrimoniales	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0020	t
133	Inscripcion de asociaciones y sociedades civiles de caracter privado	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0021	t
134	Documento de particiones de herencias	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0022	t
135	Cierre de titularidad.-	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0023	t
136	Documento de parcelamiento	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0024	t
137	Documento de adjudicacion de bienes inmuebles en remate judicial	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0025	t
138	Inscripcion de mejoras en bienhechurias y sentencias de titulo supletorio	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0026	t
139	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0027	t
140	Inscripcion de cualquier tipo de sociedades, firmas personales y asociaciones de cuentas en participacion	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0028	t
142	Actas en las cuales se declare  disolucion, liquidacion, extincion o prorroga de  la duracion de cualquier tipo de sociedades	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0030	t
143	Inscripcion de sociedades extranjeras, domiciliaciones o establecimientos de agencias, representaciones, o sucursales de las mismas	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0031	t
144	Inscripcion de documentos de ventas de cuotas de participacion, de fondos de comercio, cesion de firmas personales	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0032	t
145	Inscripcion de poderes, factores mercantiles, sentencias emanada de cualquier organismo o autoridad.	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0033	t
146	Por agregar documentos y anexos a los expedientes	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0034	t
147	Por estampar cada nota marginal	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0035	t
148	Sellado de libros y cualquier tipo de papeles mercantiles.	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0036	t
149	Por cualquier otro tipo de documento no incluido anteriormente.	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0037	t
150	Inscripcion de cualquier tipo de sociedades, firmas personales y asociaciones de cuentas en participacion	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0028	t
152	Actas en las cuales se declare  disolucion, liquidacion, extincion o prorroga de  la duracion de cualquier tipo de sociedades	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0030	t
153	Inscripcion de sociedades extranjeras, domiciliaciones o establecimientos de agencias, representaciones, o sucursales de las mismas	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0031	t
154	Inscripcion de documentos de ventas de cuotas de participacion, de fondos de comercio, cesion de firmas personales	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0032	t
155	Inscripcion de poderes, factores mercantiles, sentencias emanada de cualquier organismo o autoridad.	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0033	t
156	Por agregar documentos y anexos a los expedientes	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0034	t
157	Por estampar cada nota marginal	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0035	t
158	Sellado de libros y cualquier tipo de papeles mercantiles.	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0036	t
159	Por cualquier otro tipo de documento no incluido anteriormente.	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0037	t
160	Inscripcion de cualquier tipo de sociedades, firmas personales y asociaciones de cuentas en participacion	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0028	t
161	Inscripcion de  Acta de asamblea o junta directiva; modificaciones al documento constitutivo de firmas personales o de cuentas de participacion y 	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0029	t
344	Solvencia Sucesoral	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0062	t
109	Actas de remate.	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0013	t
164	Inscripcion de documentos de ventas de cuotas de participacion, de fondos de comercio, cesion de firmas personales	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0032	t
165	Inscripcion de poderes, factores mercantiles, sentencias emanada de cualquier organismo o autoridad.	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0033	t
166	Por agregar documentos y anexos a los expedientes	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0034	t
167	Por estampar cada nota marginal	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0035	t
168	Sellado de libros y cualquier tipo de papeles mercantiles.	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0036	t
169	Por cualquier otro tipo de documento no incluido anteriormente.	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0037	t
170	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0038	t
171	Otorgamiento de autorizaciones	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0039	t
172	Otorgamiento de justificativo	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0040	t
173	Aprobacion de una particion	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0041	t
174	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0042	t
175	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0043	t
177	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0045	t
178	Por las copias certificadas de documentos autenticados	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0046	t
179	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0047	t
180	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0048	t
181	Actas notariales	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0049	t
182	Por estampar cada nota marginal.	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0050	t
183	Documentos autenticados,	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0051	t
184	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0052	t
185	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0038	t
186	Otorgamiento de autorizaciones	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0039	t
187	Otorgamiento de justificativo	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0040	t
188	Aprobacion de una particion	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0041	t
189	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0042	t
190	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0043	t
192	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0045	t
193	Por las copias certificadas de documentos autenticados	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0046	t
194	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0047	t
195	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0048	t
196	Actas notariales	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0049	t
197	Por estampar cada nota marginal.	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0050	t
198	Documentos autenticados,	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0051	t
199	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0052	t
200	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0038	t
201	Otorgamiento de autorizaciones	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0039	t
202	Otorgamiento de justificativo	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0040	t
203	Aprobacion de una particion	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0041	t
204	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0042	t
205	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0043	t
207	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0045	t
208	Por las copias certificadas de documentos autenticados	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0046	t
209	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0047	t
210	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0048	t
211	Actas notariales	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0049	t
212	Por estampar cada nota marginal.	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0050	t
213	Documentos autenticados,	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0051	t
214	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0052	t
215	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0038	t
216	Otorgamiento de autorizaciones	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0039	t
217	Otorgamiento de justificativo	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0040	t
218	Aprobacion de una particion	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0041	t
219	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0042	t
220	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0043	t
342	Inscripcion, anulacion de Registro Vivienda Principal	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0060	t
223	Por las copias certificadas de documentos autenticados	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0046	t
224	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0047	t
225	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0048	t
226	Actas notariales	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0049	t
227	Por estampar cada nota marginal.	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0050	t
228	Documentos autenticados,	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0051	t
229	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0052	t
230	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0038	t
231	Otorgamiento de autorizaciones	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0039	t
232	Otorgamiento de justificativo	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0040	t
233	Aprobacion de una particion	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0041	t
234	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0042	t
237	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0045	t
238	Por las copias certificadas de documentos autenticados	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0046	t
239	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0047	t
240	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0048	t
241	Actas notariales	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0049	t
242	Por estampar cada nota marginal.	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0050	t
243	Documentos autenticados,	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0051	t
244	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0052	t
245	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0038	t
236	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0044	t
246	Otorgamiento de autorizaciones	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0039	t
247	Otorgamiento de justificativo	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0040	t
248	Aprobacion de una particion	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0041	t
249	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0042	t
250	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0043	t
253	Por las copias certificadas de documentos autenticados	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0046	t
254	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0047	t
255	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0048	t
256	Actas notariales	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0049	t
257	Por estampar cada nota marginal.	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0050	t
258	Documentos autenticados,	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0051	t
259	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0052	t
260	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0038	t
261	Otorgamiento de autorizaciones	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0039	t
262	Otorgamiento de justificativo	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0040	t
263	Aprobacion de una particion	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0041	t
264	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0042	t
265	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0043	t
267	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0045	t
268	Por las copias certificadas de documentos autenticados	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0046	t
269	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0047	t
270	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0048	t
271	Actas notariales	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0049	t
272	Por estampar cada nota marginal.	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0050	t
273	Documentos autenticados,	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0051	t
274	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0052	t
276	Otorgamiento de autorizaciones	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0039	t
277	Otorgamiento de justificativo	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0040	t
278	Aprobacion de una particion	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0041	t
279	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0042	t
280	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0043	t
343	Escrito de prorroga (Declaracion Sucesoral)	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0061	t
222	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0045	t
283	Por las copias certificadas de documentos autenticados	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0046	t
284	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0047	t
285	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0048	t
286	Actas notariales	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0049	t
287	Por estampar cada nota marginal.	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0050	t
288	Documentos autenticados,	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0051	t
290	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0038	t
291	Otorgamiento de autorizaciones	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0039	t
292	Otorgamiento de justificativo	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0040	t
293	Aprobacion de una particion	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0041	t
294	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0042	t
295	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0043	t
297	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0045	t
298	Por las copias certificadas de documentos autenticados	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0046	t
299	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0047	t
300	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0048	t
301	Actas notariales	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0049	t
302	Por estampar cada nota marginal.	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0050	t
303	Documentos autenticados,	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0051	t
304	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0052	t
305	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0038	t
306	Otorgamiento de autorizaciones	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0039	t
307	Otorgamiento de justificativo	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0040	t
308	Aprobacion de una particion	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0041	t
309	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0042	t
311	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0044	t
312	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0045	t
313	Por las copias certificadas de documentos autenticados	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0046	t
314	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0047	t
315	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0048	t
316	Actas notariales	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0049	t
317	Por estampar cada nota marginal.	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0050	t
318	Documentos autenticados,	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0051	t
319	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0052	t
320	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0038	t
321	Otorgamiento de autorizaciones	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0039	t
322	Otorgamiento de justificativo	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0040	t
323	Aprobacion de una particion	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0041	t
324	Otorgamiento de poderes, revocatoria, renuncia y/o sustituciones	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0042	t
325	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0043	t
327	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0045	t
328	Por las copias certificadas de documentos autenticados	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0046	t
329	Por las copias o reproducciones simples de los documentos autenticados	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0047	t
330	Documentos anexos o complementarios a los que se autentiquen	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0048	t
331	Actas notariales	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0049	t
332	Por estampar cada nota marginal.	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0050	t
333	Documentos autenticados,	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0051	t
334	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0052	t
335	Consultas/solicitudes  sobre la aplicacion de las normas que integran el ordenamiento juridico vigente	2024-11-04 15:28:46.921	2024-11-04 15:28:46.921	\N	1	1	1	\N	24	f	\N	0053	t
336	Contratos relacionados con los ingresos publicos estadales	2024-11-04 15:28:46.921	2024-11-04 15:28:46.921	\N	1	1	1	\N	24	f	\N	0054	t
337	Contratos relativos a inmuebles propiedad del estado	2024-11-04 15:28:46.921	2024-11-04 15:28:46.921	\N	1	1	1	\N	24	f	\N	0055	t
338	Expedicion de copias certificadas sobre asuntos que cursen en sus archivos	2024-11-04 15:28:46.921	2024-11-04 15:28:46.921	\N	1	1	1	\N	24	f	\N	0056	t
339	Solicitudes, escritos 	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0057	t
340	Copias certificadas	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0058	t
341	Escritos para interposicion de recursos 	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0059	t
282	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0045	t
348	Remision por requerimiento (Correspondencia)	2024-11-05 09:15:18.972	2024-11-05 09:15:18.972	\N	1	1	1	\N	27	f	\N	0066	t
349	Solicitud de Tramite de Importacion	2024-11-05 09:15:53.47	2024-11-05 09:15:53.47	\N	1	1	1	\N	27	f	\N	0067	t
350	Solicitud de Tramite de Exportacion	2024-11-05 09:16:30.732	2024-11-05 09:16:30.732	\N	1	1	1	\N	27	f	\N	0068	t
351	Solicitud de Tramite de Transito Aduanero	2024-11-05 09:18:39.308	2024-11-05 09:18:39.308	\N	1	1	1	\N	27	f	\N	0069	t
352	Otras solicitudes dirigidas a las autoridades Aduaneras, Portuarias y de Navegacion	2024-11-05 09:23:04.759	2024-11-05 09:23:04.759	\N	1	1	1	\N	27	f	\N	0070	t
353	Solicitudes  sobre actividades de minerales no metalicos.	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0071	t
354	Autorizaciones eventuales o temporales sobre actividades de M.N.M.	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0072	t
355	Revocatoria del derecho minero otorgado	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0073	t
356	Solicitud de Ocupacion de Territorio	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0074	t
357	Otorgamiento de  Autorizacion para la Ocupacion del Territorio	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0075	t
358	Autorizacion para el desarrollo de actividades conexas 	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0076	t
359	Otras solicitudes y consultas emitidas en el ambito de competencia	2024-11-05 09:31:04.445	2024-11-05 09:31:04.445	\N	1	1	1	\N	28	f	\N	0077	t
360	Actos o documentos dirigido a Organos y Entes	2024-11-05 09:33:00.57	2024-11-05 09:33:00.57	\N	1	1	1	\N	29	f	\N	0078	t
361	Sellado Libro deL Control de Extraccion de Minerales No Metalicos	2024-11-05 09:33:00.57	2024-11-05 09:33:00.57	\N	1	1	1	\N	29	f	\N	0079	t
47	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0015	t
59	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:37:01.949	2024-11-04 14:37:01.949	\N	1	1	1	\N	4	f	\N	0027	t
63	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:55:34.393	2024-11-04 14:55:34.393	\N	1	1	1	\N	5	f	\N	0015	t
79	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:57:36.882	2024-11-04 14:57:36.882	\N	1	1	1	\N	6	f	\N	0015	t
107	Por cualquier otro tipo de documento que se presente para su protocolizacion.	2024-11-04 14:58:15.675	2024-11-04 14:58:15.675	\N	1	1	1	\N	7	f	\N	0027	t
108	Inscripcion de testamentos abiertos o cerrados	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0012	t
110	Otorgamiento de Poderes, sustituciones, renuncias y revocatorias de los mismos	2024-11-04 14:59:07.573	2024-11-04 14:59:07.573	\N	1	1	1	\N	8	f	\N	0014	t
127	Documentos que contengan declaraciones de limitaciones, transmisiones, derecho de retracto, renuncias o gravamenes de la propiedad.	2024-11-04 14:59:39.709	2024-11-04 14:59:39.709	\N	1	1	1	\N	9	f	\N	0015	t
141	Inscripcion de  Acta de asamblea o junta directiva; modificaciones al documento constitutivo de firmas personales o de cuentas de participacion y 	2024-11-04 15:12:28.958	2024-11-04 15:12:28.958	\N	1	1	1	\N	10	f	\N	0029	t
151	Inscripcion de  Acta de asamblea o junta directiva; modificaciones al documento constitutivo de firmas personales o de cuentas de participacion y 	2024-11-04 15:13:34.905	2024-11-04 15:13:34.905	\N	1	1	1	\N	11	f	\N	0029	t
162	Actas en las cuales se declare  disolucion, liquidacion, extincion o prorroga de  la duracion de cualquier tipo de sociedades	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0030	t
163	Inscripcion de sociedades extranjeras, domiciliaciones o establecimientos de agencias, representaciones, o sucursales de las mismas	2024-11-04 15:14:05.476	2024-11-04 15:14:05.476	\N	1	1	1	\N	12	f	\N	0031	t
235	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:20:45.457	2024-11-04 15:20:45.457	\N	1	1	1	\N	17	f	\N	0043	t
252	Por la trascripcion de un documento manuscrito al sistema computarizado o por su digitalizacion	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0045	t
275	Procesamiento de documento original presentado para su autenticacion	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0038	t
289	Por cualquier otro tipo de documento que se presente para su inscripcion.	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0052	t
310	Actuaciones para dar fecha cierta de cualquier tipo de documentos	2024-11-04 15:24:04.82	2024-11-04 15:24:04.82	\N	1	1	1	\N	22	f	\N	0043	t
345	Solicitud para prescripcion de Declaracion Sucesoral	2024-11-04 15:32:10.352	2024-11-04 15:32:10.352	\N	1	1	1	\N	25	f	\N	0063	t
346	Solicitudes, consultas, escritos y correspondencia	2024-11-05 09:01:12.799	2024-11-05 09:01:12.799	\N	1	1	1	\N	26	f	\N	0064	t
347	Bulto Postal	2024-11-05 09:01:54.096	2024-11-05 09:01:54.096	\N	1	1	1	\N	26	f	\N	0065	t
11	Inscripcion de asociaciones y sociedades civiles de caracter privado.	2024-11-04 14:15:36.846	2024-11-04 14:15:36.846	\N	1	1	1	\N	1	t	20	0011	t
206	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:19:28.475	2024-11-04 15:19:28.475	\N	1	1	1	\N	15	f	\N	0044	t
266	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:21:53.645	2024-11-04 15:21:53.645	\N	1	1	1	\N	19	f	\N	0044	t
176	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:18:08.162	2024-11-04 15:18:08.162	\N	1	1	1	\N	13	f	\N	0044	t
191	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:18:50.81	2024-11-04 15:18:50.81	\N	1	1	1	\N	14	f	\N	0044	t
221	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:20:03.118	2024-11-04 15:20:03.118	\N	1	1	1	\N	16	f	\N	0044	t
251	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:21:14.865	2024-11-04 15:21:14.865	\N	1	1	1	\N	18	f	\N	0044	t
281	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:22:39.824	2024-11-04 15:22:39.824	\N	1	1	1	\N	20	f	\N	0044	t
296	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:23:30.4	2024-11-04 15:23:30.4	\N	1	1	1	\N	21	f	\N	0044	t
326	Nombramiento de curadores, salvo en los casos previstos en la Ley Organica de Proteccion de Niños, Niñas y Adolescentes	2024-11-04 15:24:44.621	2024-11-04 15:24:44.621	\N	1	1	1	\N	23	f	\N	0044	t
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	SUPERADMIN	ROLE WITH ALL PRIVILEGES - ONLY FOR DEVELOPERS	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
3	NATURAL	ROLE WITH THE PRIVILEGES REQUIRED FOR A NATURAL CONTRIBUTOR	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
4	COMMERCIAL	ROLE WITH THE PRIVILEGES REQUIRED FOR A COMMERCIAL CONTRIBUTOR	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
5	INDUSTRIAL	ROLE WITH THE PRIVILEGES REQUIRED FOR A INDUSTRIAL CONTRIBUTOR	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
2	ADMINISTRATOR	ROLE WITH THE PRIVILEGES REQUIRED FOR A ADMINISTRATOR OF COLLECTION	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	\N	\N	\N
6	SIGNATURE	ROLE WITH THE PRIVILEGES REQUIRED FOR A PERSONAL SIGNATURE CONTRIBUTOR	2024-10-14 22:29:30.954244	2024-10-14 22:29:30.954244	\N	\N	\N	\N	\N
7	SUCCESSION	ROLE WITH THE PRIVILEGES REQUIRED FOR A LEGAL CONTRIBUTOR OF SUCCESSION	2024-10-14 22:31:59.348198	2024-10-14 22:31:59.348198	\N	\N	\N	\N	\N
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
22	4	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
23	4	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
24	4	3	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
25	4	4	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
26	4	5	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
27	5	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
28	5	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
29	5	3	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
30	5	4	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
31	5	5	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
32	6	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
33	6	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
34	6	3	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
35	6	4	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
36	6	5	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
37	7	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
38	7	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
39	7	3	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
40	7	4	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
41	7	5	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	\N	\N	\N
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
4	REGISTRO PUBLICO DE LOS MUNICIPIOS GUACARA, SAN JOAQUIN Y DIEGO IBARRA	2024-11-07 14:51:10.776857	2024-11-07 14:51:10.776857	\N	1	1	1	\N	1	0004
\.


--
-- Data for Name: tax_stamp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_stamp (id, code, amount, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "userId", "procedureId", "calculationFactorId", number_folios, year) FROM stdin;
728	20024005420240000276	258.5455	2024-12-11 22:35:07.94082	2024-12-11 22:35:07.94082	\N	11	\N	\N	\N	5	336	\N	1	2024
732	10001000120240000280	1056.6419999999998	2024-12-16 21:24:03.741277	2024-12-16 21:24:03.741277	\N	11	\N	\N	\N	2	1	79	1	2024
700	40029007820240000248	258.5455	2024-12-10 20:49:40.28	2024-12-10 21:42:06.043597	\N	11	\N	\N	\N	5	360	\N	1	2024
702	40029007920240000250	258.5455	2024-12-10 20:49:40.322	2024-12-10 21:42:06.110794	\N	11	\N	\N	\N	5	361	\N	1	2024
703	30026006520240000251	258.5455	2024-12-10 20:49:40.328	2024-12-10 21:42:06.112471	\N	11	\N	\N	\N	5	347	\N	1	2024
701	30026006520240000249	258.5455	2024-12-10 20:49:40.319	2024-12-10 21:49:17.134366	\N	11	\N	\N	\N	5	347	\N	1	2024
733	10001000420240000281	0	2024-12-16 21:24:03.785082	2024-12-16 21:24:03.785082	\N	13	\N	\N	\N	2	4	79	1	2024
704	30026006520240000252	258.5455	2024-12-10 20:49:40.333	2024-12-10 21:57:41.064619	\N	11	\N	\N	\N	5	347	\N	1	2024
734	10001000220240000282	0	2024-12-16 21:24:03.891602	2024-12-16 21:24:03.891602	\N	13	\N	\N	\N	2	2	79	1	2024
699	40029007820240000247	258.5455	2024-12-10 20:49:40.27	2024-12-10 22:01:59.786138	\N	11	\N	\N	\N	5	360	\N	1	2024
705	30026006420240000253	258.5455	2024-12-10 22:03:55.328	2024-12-10 22:04:52.65919	\N	11	\N	\N	\N	5	346	\N	1	2024
706	40028007520240000254	258.5455	2024-12-10 22:15:49.064	2024-12-10 22:16:27.814136	\N	11	\N	\N	\N	5	357	\N	1	2024
707	40029007820240000255	258.5455	2024-12-10 23:07:47.873	2024-12-10 23:07:47.873	\N	11	\N	\N	\N	5	360	\N	1	2024
708	40029007820240000256	258.5455	2024-12-10 23:39:51.611	2024-12-10 23:39:51.611	\N	11	\N	\N	\N	5	360	\N	1	2024
710	40028007220240000258	258.5455	2024-12-10 23:39:51.692	2024-12-10 23:39:51.692	\N	11	\N	\N	\N	5	354	\N	1	2024
737	10001000220240000285	0	2024-12-16 22:16:29.409387	2024-12-16 22:16:29.409387	\N	13	\N	\N	\N	2	2	\N	1	2024
738	10001000420240000286	0	2024-12-16 22:16:29.415097	2024-12-16 22:16:29.415097	\N	13	\N	\N	\N	2	4	\N	1	2024
739	10001000220240000287	0	2024-12-16 22:16:29.425738	2024-12-16 22:16:29.425738	\N	13	\N	\N	\N	2	2	\N	1	2024
740	10001000220240000288	0	2024-12-16 22:16:29.431677	2024-12-16 22:16:29.431677	\N	13	\N	\N	\N	2	2	\N	1	2024
743	10001000220240000291	0	2024-12-16 22:28:52.25218	2024-12-16 22:28:52.25218	\N	13	\N	\N	\N	2	2	\N	1	2024
744	10001000420240000292	0	2024-12-16 22:28:52.253384	2024-12-16 22:28:52.253384	\N	13	\N	\N	\N	2	4	\N	1	2024
745	10001000220240000293	0	2024-12-16 22:28:52.271263	2024-12-16 22:28:52.271263	\N	13	\N	\N	\N	2	2	\N	1	2024
746	10001000220240000294	0	2024-12-16 22:28:52.2783	2024-12-16 22:28:52.2783	\N	13	\N	\N	\N	2	2	\N	1	2024
712	40028007220240000260	258.5455	2024-12-10 23:39:51.704	2024-12-10 23:39:51.704	\N	11	\N	\N	\N	2	354	\N	1	2024
709	40029007920240000257	258.5455	2024-12-10 23:39:51.687	2024-12-10 23:39:51.687	\N	11	\N	\N	\N	5	361	\N	1	2024
711	40029007920240000259	258.5455	2024-12-10 23:39:51.699	2024-12-10 23:39:51.699	\N	11	\N	\N	\N	5	361	\N	1	2024
775	40029007820240000323	1068.802	2024-12-18 19:47:35.388675	2024-12-18 19:47:55.312277	\N	11	\N	\N	\N	2	360	\N	1	2024
776	40029007820240000324	1068.802	2024-12-18 19:48:41.355803	2024-12-18 19:48:49.204149	\N	11	\N	\N	\N	2	360	\N	1	2024
777	40029007820240000325	1068.802	2024-12-18 19:54:38.741172	2024-12-18 19:54:48.877642	\N	11	\N	\N	\N	2	360	\N	1	2024
778	40029007820240000326	1068.802	2024-12-18 19:57:15.389121	2024-12-18 19:57:21.375244	\N	11	\N	\N	\N	2	360	\N	1	2024
779	40029007820240000327	1068.802	2024-12-18 19:59:54.746994	2024-12-18 19:59:54.746994	\N	11	\N	\N	\N	2	360	\N	1	2024
735	10001000120240000283	1056.642	2024-12-16 22:16:29.346022	2024-12-16 22:16:29.346022	\N	11	\N	\N	\N	2	1	\N	1	2024
736	10001000120240000284	1056.642	2024-12-16 22:16:29.362349	2024-12-16 22:16:29.362349	\N	11	\N	\N	\N	2	1	\N	1	2024
741	10001000120240000289	1056.642	2024-12-16 22:28:52.178272	2024-12-16 22:28:52.178272	\N	11	\N	\N	\N	2	1	\N	1	2024
742	10001000120240000290	1056.642	2024-12-16 22:28:52.193735	2024-12-16 22:28:52.193735	\N	11	\N	\N	\N	2	1	\N	1	2024
747	40029007820240000295	1068.802	2024-12-18 17:53:56.532575	2024-12-18 17:53:56.532575	\N	11	\N	\N	\N	2	360	\N	1	2024
748	40029007820240000296	1068.802	2024-12-18 18:23:01.817191	2024-12-18 18:23:01.817191	\N	11	\N	\N	\N	2	360	\N	1	2024
749	40029007820240000297	1068.802	2024-12-18 18:34:25.129596	2024-12-18 18:34:25.129596	\N	11	\N	\N	\N	2	360	\N	1	2024
750	20024005320240000298	1068.802	2024-12-18 18:49:44.404254	2024-12-18 18:49:44.404254	\N	11	\N	\N	\N	2	335	\N	1	2024
751	40029007820240000299	1068.802	2024-12-18 18:51:52.352335	2024-12-18 18:51:52.352335	\N	11	\N	\N	\N	2	360	\N	1	2024
765	40029007820240000313	1068.802	2024-12-18 19:35:12.567217	2024-12-18 19:35:12.567217	\N	11	\N	\N	\N	2	360	\N	1	2024
714	40029007820240000262	258.5455	2024-12-11 22:25:49.796913	2024-12-11 22:25:49.796913	\N	11	\N	\N	\N	5	360	\N	1	2024
715	40029007820240000263	258.5455	2024-12-11 22:25:49.805169	2024-12-11 22:25:49.805169	\N	11	\N	\N	\N	5	360	\N	1	2024
716	40029007820240000264	258.5455	2024-12-11 22:25:49.813337	2024-12-11 22:25:49.813337	\N	11	\N	\N	\N	5	360	\N	1	2024
795	40029007820240000343	1068.802	2024-12-18 21:17:46.385257	2024-12-18 21:17:54.329438	\N	11	\N	\N	\N	2	360	\N	1	2024
796	40029007820240000344	1068.802	2024-12-18 21:17:46.398227	2024-12-18 21:17:54.330357	\N	11	\N	\N	\N	2	360	\N	1	2024
797	40029007820240000345	1068.802	2024-12-18 21:17:46.404112	2024-12-18 21:17:54.33229	\N	11	\N	\N	\N	2	360	\N	1	2024
798	40029007820240000346	1068.802	2024-12-18 21:17:46.411686	2024-12-18 21:17:54.334177	\N	11	\N	\N	\N	2	360	\N	1	2024
799	40029007820240000347	1068.802	2024-12-18 21:17:46.41743	2024-12-18 21:17:54.33592	\N	11	\N	\N	\N	2	360	\N	1	2024
800	40029007820240000348	1068.802	2024-12-18 21:17:46.421768	2024-12-18 21:17:54.336989	\N	11	\N	\N	\N	2	360	\N	1	2024
801	40029007820240000349	1068.802	2024-12-18 21:17:46.425536	2024-12-18 21:17:54.340053	\N	11	\N	\N	\N	2	360	\N	1	2024
802	40029007820240000350	1068.802	2024-12-18 21:17:46.430857	2024-12-18 21:17:54.341947	\N	11	\N	\N	\N	2	360	\N	1	2024
803	40029007820240000351	1068.802	2024-12-18 21:17:46.437183	2024-12-18 21:17:54.344342	\N	11	\N	\N	\N	2	360	\N	1	2024
804	40029007820240000352	1068.802	2024-12-18 21:17:46.442998	2024-12-18 21:17:54.34681	\N	11	\N	\N	\N	2	360	\N	1	2024
805	40029007820240000353	1068.802	2024-12-18 21:17:46.448739	2024-12-18 21:17:54.348194	\N	11	\N	\N	\N	2	360	\N	1	2024
806	40029007820240000354	1068.802	2024-12-18 21:17:46.453681	2024-12-18 21:17:54.350201	\N	11	\N	\N	\N	2	360	\N	1	2024
717	40029007820240000265	258.5455	2024-12-11 22:25:49.819318	2024-12-11 22:25:49.819318	\N	11	\N	\N	\N	5	360	\N	1	2024
718	40029007820240000266	258.5455	2024-12-11 22:25:49.825884	2024-12-11 22:25:49.825884	\N	11	\N	\N	\N	5	360	\N	1	2024
780	40029007820240000328	1068.802	2024-12-18 20:10:15.397807	2024-12-18 20:10:15.397807	\N	11	\N	\N	\N	2	360	\N	1	2024
811	40029007820240000359	1068.802	2024-12-18 21:22:07.983485	2024-12-18 21:22:14.657029	\N	11	\N	\N	\N	2	360	\N	1	2024
812	40029007820240000360	1068.802	2024-12-18 21:22:51.512589	2024-12-18 21:22:59.276208	\N	11	\N	\N	\N	2	360	\N	1	2024
813	40029007820240000361	1068.802	2024-12-18 21:24:14.87991	2024-12-18 21:24:22.344735	\N	11	\N	\N	\N	2	360	\N	1	2024
815	40029007820240000363	1068.802	2024-12-18 21:32:57.959509	2024-12-18 21:33:14.691722	\N	11	\N	\N	\N	2	360	\N	1	2024
820	40029007820240000368	1068.802	2024-12-18 21:39:09.598968	2024-12-18 21:39:14.427977	\N	11	\N	\N	\N	2	360	\N	1	2024
816	40029007820240000364	1068.802	2024-12-18 21:34:14.53542	2024-12-18 21:36:04.340236	\N	11	\N	\N	\N	2	360	\N	1	2024
817	40029007820240000365	1068.802	2024-12-18 21:36:09.923758	2024-12-18 21:36:16.07714	\N	11	\N	\N	\N	2	360	\N	1	2024
818	40029007820240000366	1068.802	2024-12-18 21:36:51.541224	2024-12-18 21:36:56.562714	\N	11	\N	\N	\N	2	360	\N	1	2024
819	40029007820240000367	1068.802	2024-12-18 21:37:35.410952	2024-12-18 21:37:41.081014	\N	11	\N	\N	\N	2	360	\N	1	2024
821	40029007820240000369	1068.802	2024-12-18 21:43:30.056398	2024-12-18 21:43:36.06395	\N	11	\N	\N	\N	2	360	\N	1	2024
822	40029007820240000370	1068.802	2024-12-18 21:44:24.898113	2024-12-18 21:44:33.302806	\N	11	\N	\N	\N	2	360	\N	1	2024
823	40029007820240000371	1068.802	2024-12-18 21:44:46.408545	2024-12-18 21:44:50.893793	\N	11	\N	\N	\N	2	360	\N	1	2024
824	40029007820240000372	1	2024-12-18 22:12:14.076445	2024-12-18 22:12:34.607637	\N	11	\N	\N	\N	11	360	\N	1	2024
825	40029007820240000373	1	2024-12-18 22:16:01.824055	2024-12-18 22:16:10.982403	\N	11	\N	\N	\N	11	360	\N	1	2024
826	40029007820240000374	1	2024-12-18 22:16:01.831326	2024-12-18 22:16:11.020732	\N	11	\N	\N	\N	11	360	\N	1	2024
827	40029007820240000375	1	2024-12-18 22:16:40.617521	2024-12-18 22:16:50.426645	\N	11	\N	\N	\N	11	360	\N	1	2024
828	40029007820240000376	1	2024-12-18 22:16:40.625522	2024-12-18 22:16:50.463604	\N	11	\N	\N	\N	11	360	\N	1	2024
829	40029007820240000377	1	2024-12-18 22:17:29.167274	2024-12-18 22:17:39.08544	\N	11	\N	\N	\N	11	360	\N	1	2024
830	40029007820240000378	1	2024-12-18 22:17:29.180625	2024-12-18 22:17:39.122156	\N	11	\N	\N	\N	11	360	\N	1	2024
831	40029007820240000379	270.53450000000004	2024-12-29 14:06:47.389	2024-12-29 14:06:47.389	\N	11	\N	\N	\N	2	360	81	1	2024
719	40029007820240000267	258.5455	2024-12-11 22:28:45.795287	2024-12-11 22:28:45.795287	\N	11	\N	\N	\N	5	360	\N	1	2024
720	40029007820240000268	258.5455	2024-12-11 22:28:45.80634	2024-12-11 22:28:45.80634	\N	11	\N	\N	\N	5	360	\N	1	2024
721	40029007820240000269	258.5455	2024-12-11 22:28:45.813297	2024-12-11 22:28:45.813297	\N	11	\N	\N	\N	5	360	\N	1	2024
722	40029007820240000270	258.5455	2024-12-11 22:28:45.821007	2024-12-11 22:28:45.821007	\N	11	\N	\N	\N	5	360	\N	1	2024
723	40029007820240000271	258.5455	2024-12-11 22:28:45.8274	2024-12-11 22:28:45.8274	\N	11	\N	\N	\N	5	360	\N	1	2024
724	40029007920240000272	258.5455	2024-12-11 22:32:57.706616	2024-12-11 22:32:57.706616	\N	11	\N	\N	\N	5	361	\N	1	2024
725	40029007920240000273	258.5455	2024-12-11 22:32:57.714833	2024-12-11 22:32:57.714833	\N	11	\N	\N	\N	5	361	\N	1	2024
726	40029007820240000274	258.5455	2024-12-11 22:34:09.719339	2024-12-11 22:34:09.719339	\N	11	\N	\N	\N	5	360	\N	1	2024
727	40029007820240000275	258.5455	2024-12-11 22:34:09.81972	2024-12-11 22:34:09.81972	\N	11	\N	\N	\N	5	360	\N	1	2024
752	40029007820240000300	1068.802	2024-12-18 18:59:07.0134	2024-12-18 18:59:07.0134	\N	11	\N	\N	\N	2	360	\N	1	2024
753	40029007820240000301	1068.802	2024-12-18 19:02:04.405248	2024-12-18 19:02:04.405248	\N	11	\N	\N	\N	2	360	\N	1	2024
754	40029007820240000302	1068.802	2024-12-18 19:02:56.764503	2024-12-18 19:02:56.764503	\N	11	\N	\N	\N	2	360	\N	1	2024
755	40029007820240000303	1068.802	2024-12-18 19:09:50.823512	2024-12-18 19:09:50.823512	\N	11	\N	\N	\N	2	360	\N	1	2024
756	40029007820240000304	1068.802	2024-12-18 19:23:24.451724	2024-12-18 19:23:24.451724	\N	11	\N	\N	\N	2	360	\N	1	2024
757	40029007820240000305	1068.802	2024-12-18 19:24:11.218972	2024-12-18 19:24:11.218972	\N	11	\N	\N	\N	2	360	\N	1	2024
758	40029007820240000306	1068.802	2024-12-18 19:24:11.221682	2024-12-18 19:24:11.221682	\N	11	\N	\N	\N	2	360	\N	1	2024
759	40029007820240000307	1068.802	2024-12-18 19:24:27.911602	2024-12-18 19:24:27.911602	\N	11	\N	\N	\N	2	360	\N	1	2024
760	40029007820240000308	1068.802	2024-12-18 19:24:53.685872	2024-12-18 19:24:53.685872	\N	11	\N	\N	\N	2	360	\N	1	2024
761	40029007820240000309	1068.802	2024-12-18 19:25:12.15642	2024-12-18 19:25:12.15642	\N	11	\N	\N	\N	2	360	\N	1	2024
762	40029007820240000310	1068.802	2024-12-18 19:28:45.357096	2024-12-18 19:28:45.357096	\N	11	\N	\N	\N	2	360	\N	1	2024
763	40029007820240000311	1068.802	2024-12-18 19:32:43.949058	2024-12-18 19:32:43.949058	\N	11	\N	\N	\N	2	360	\N	1	2024
764	40029007820240000312	1068.802	2024-12-18 19:33:44.418535	2024-12-18 19:33:44.418535	\N	11	\N	\N	\N	2	360	\N	1	2024
766	40029007820240000314	1068.802	2024-12-18 19:35:17.152912	2024-12-18 19:35:17.152912	\N	11	\N	\N	\N	2	360	\N	1	2024
767	40029007820240000315	1068.802	2024-12-18 19:37:18.419418	2024-12-18 19:37:18.419418	\N	11	\N	\N	\N	2	360	\N	1	2024
768	40029007820240000316	1068.802	2024-12-18 19:37:20.979345	2024-12-18 19:37:20.979345	\N	11	\N	\N	\N	2	360	\N	1	2024
769	40029007820240000317	1068.802	2024-12-18 19:37:23.209947	2024-12-18 19:37:23.209947	\N	11	\N	\N	\N	2	360	\N	1	2024
770	40029007820240000318	1068.802	2024-12-18 19:37:54.696282	2024-12-18 19:37:54.696282	\N	11	\N	\N	\N	2	360	\N	1	2024
771	40029007820240000319	1068.802	2024-12-18 19:40:12.378196	2024-12-18 19:40:12.378196	\N	11	\N	\N	\N	2	360	\N	1	2024
772	40029007820240000320	1068.802	2024-12-18 19:41:09.091119	2024-12-18 19:41:09.091119	\N	11	\N	\N	\N	2	360	\N	1	2024
773	40029007820240000321	1068.802	2024-12-18 19:43:13.188774	2024-12-18 19:43:13.188774	\N	11	\N	\N	\N	2	360	\N	1	2024
774	40029007820240000322	1068.802	2024-12-18 19:44:42.678139	2024-12-18 19:44:42.678139	\N	11	\N	\N	\N	2	360	\N	1	2024
713	40029007820240000261	270.53450000000004	2024-12-11 22:23:20.273	2024-12-11 22:23:20.273	\N	11	\N	\N	\N	5	360	\N	1	2024
781	40029007820240000329	1068.802	2024-12-18 20:13:19.609251	2024-12-18 20:13:19.609251	\N	11	\N	\N	\N	2	360	\N	1	2024
782	40029007820240000330	1068.802	2024-12-18 20:16:17.215473	2024-12-18 20:16:17.215473	\N	11	\N	\N	\N	2	360	\N	1	2024
783	40029007920240000331	1068.802	2024-12-18 20:44:48.238707	2024-12-18 20:44:48.238707	\N	11	\N	\N	\N	2	361	\N	1	2024
784	40029007920240000332	1068.802	2024-12-18 20:44:48.250757	2024-12-18 20:44:48.250757	\N	11	\N	\N	\N	2	361	\N	1	2024
785	40029007820240000333	1068.802	2024-12-18 20:52:13.190695	2024-12-18 20:52:13.190695	\N	11	\N	\N	\N	2	360	\N	1	2024
786	40029007820240000334	1068.802	2024-12-18 20:55:12.178658	2024-12-18 20:55:12.178658	\N	11	\N	\N	\N	2	360	\N	1	2024
787	40029007820240000335	1068.802	2024-12-18 20:55:24.584834	2024-12-18 20:55:24.584834	\N	11	\N	\N	\N	2	360	\N	1	2024
788	40029007820240000336	1068.802	2024-12-18 20:55:34.679674	2024-12-18 20:55:34.679674	\N	11	\N	\N	\N	2	360	\N	1	2024
789	40029007820240000337	1068.802	2024-12-18 20:56:10.444784	2024-12-18 20:56:10.444784	\N	11	\N	\N	\N	2	360	\N	1	2024
790	40029007820240000338	1068.802	2024-12-18 21:00:46.014401	2024-12-18 21:00:46.014401	\N	11	\N	\N	\N	2	360	\N	1	2024
791	40029007820240000339	1068.802	2024-12-18 21:03:28.620406	2024-12-18 21:03:28.620406	\N	11	\N	\N	\N	2	360	\N	1	2024
792	40029007820240000340	1068.802	2024-12-18 21:07:07.219992	2024-12-18 21:07:07.219992	\N	11	\N	\N	\N	2	360	\N	1	2024
793	40029007820240000341	1068.802	2024-12-18 21:09:00.190894	2024-12-18 21:09:00.190894	\N	11	\N	\N	\N	2	360	\N	1	2024
794	40029007820240000342	1068.802	2024-12-18 21:15:10.67279	2024-12-18 21:15:10.67279	\N	11	\N	\N	\N	2	360	\N	1	2024
807	20024005320240000355	1068.802	2024-12-18 21:18:59.795242	2024-12-18 21:18:59.795242	\N	11	\N	\N	\N	2	335	\N	1	2024
808	20024005320240000356	1068.802	2024-12-18 21:18:59.807482	2024-12-18 21:18:59.807482	\N	11	\N	\N	\N	2	335	\N	1	2024
809	20024005320240000357	1068.802	2024-12-18 21:19:26.613237	2024-12-18 21:19:26.613237	\N	11	\N	\N	\N	2	335	\N	1	2024
810	20024005320240000358	1068.802	2024-12-18 21:19:26.625028	2024-12-18 21:19:26.625028	\N	11	\N	\N	\N	2	335	\N	1	2024
814	40029007820240000362	1068.802	2024-12-18 21:25:35.335027	2024-12-18 21:25:35.335027	\N	11	\N	\N	\N	2	360	\N	1	2024
\.


--
-- Data for Name: tax_stamps_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_stamps_payment (id, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "taxStampId", "paymentId") FROM stdin;
562	2024-12-10 21:40:22.033719	2024-12-10 21:40:22.033719	\N	1	\N	\N	\N	700	197
563	2024-12-10 21:40:22.034343	2024-12-10 21:40:22.034343	\N	1	\N	\N	\N	702	197
564	2024-12-10 21:40:22.034922	2024-12-10 21:40:22.034922	\N	1	\N	\N	\N	703	197
565	2024-12-10 21:49:03.794199	2024-12-10 21:49:03.794199	\N	1	\N	\N	\N	701	198
566	2024-12-10 21:57:27.204566	2024-12-10 21:57:27.204566	\N	1	\N	\N	\N	704	199
567	2024-12-10 22:01:52.181111	2024-12-10 22:01:52.181111	\N	1	\N	\N	\N	699	200
568	2024-12-10 22:04:45.063503	2024-12-10 22:04:45.063503	\N	1	\N	\N	\N	705	201
569	2024-12-10 22:16:21.290828	2024-12-10 22:16:21.290828	\N	1	\N	\N	\N	706	202
570	2024-12-10 23:36:10.743094	2024-12-10 23:36:10.743094	\N	1	\N	\N	\N	707	203
584	2024-12-11 00:35:08.824123	2024-12-11 00:35:08.824123	\N	1	\N	\N	\N	709	218
587	2024-12-11 00:36:48.507466	2024-12-11 00:36:48.507466	\N	1	\N	\N	\N	711	221
588	2024-12-11 00:36:48.507793	2024-12-11 00:36:48.507793	\N	1	\N	\N	\N	712	221
589	2024-12-16 22:16:29.469566	2024-12-16 22:16:29.469566	\N	1	\N	\N	\N	735	222
590	2024-12-16 22:16:29.470203	2024-12-16 22:16:29.470203	\N	1	\N	\N	\N	736	222
591	2024-12-16 22:16:29.470672	2024-12-16 22:16:29.470672	\N	1	\N	\N	\N	737	222
592	2024-12-16 22:16:29.517476	2024-12-16 22:16:29.517476	\N	1	\N	\N	\N	738	222
593	2024-12-16 22:16:29.520567	2024-12-16 22:16:29.520567	\N	1	\N	\N	\N	739	222
594	2024-12-16 22:16:29.526097	2024-12-16 22:16:29.526097	\N	1	\N	\N	\N	740	222
595	2024-12-16 22:28:52.316317	2024-12-16 22:28:52.316317	\N	1	\N	\N	\N	741	223
596	2024-12-16 22:28:52.317061	2024-12-16 22:28:52.317061	\N	1	\N	\N	\N	742	223
597	2024-12-18 17:53:56.564939	2024-12-18 17:53:56.564939	\N	1	\N	\N	\N	747	224
598	2024-12-18 18:23:01.864058	2024-12-18 18:23:01.864058	\N	1	\N	\N	\N	748	225
599	2024-12-18 18:34:25.159214	2024-12-18 18:34:25.159214	\N	1	\N	\N	\N	749	226
600	2024-12-18 18:49:44.437632	2024-12-18 18:49:44.437632	\N	1	\N	\N	\N	750	227
601	2024-12-18 18:51:52.387794	2024-12-18 18:51:52.387794	\N	1	\N	\N	\N	751	228
602	2024-12-18 18:59:07.031932	2024-12-18 18:59:07.031932	\N	1	\N	\N	\N	752	229
603	2024-12-18 19:02:04.432533	2024-12-18 19:02:04.432533	\N	1	\N	\N	\N	753	230
604	2024-12-18 19:02:56.812337	2024-12-18 19:02:56.812337	\N	1	\N	\N	\N	754	231
605	2024-12-18 19:09:50.85185	2024-12-18 19:09:50.85185	\N	1	\N	\N	\N	755	232
606	2024-12-18 19:23:24.473564	2024-12-18 19:23:24.473564	\N	1	\N	\N	\N	756	233
607	2024-12-18 19:24:11.244609	2024-12-18 19:24:11.244609	\N	1	\N	\N	\N	757	234
608	2024-12-18 19:24:11.250234	2024-12-18 19:24:11.250234	\N	1	\N	\N	\N	758	235
609	2024-12-18 19:24:27.937354	2024-12-18 19:24:27.937354	\N	1	\N	\N	\N	759	236
610	2024-12-18 19:24:53.70716	2024-12-18 19:24:53.70716	\N	1	\N	\N	\N	760	237
611	2024-12-18 19:25:12.174698	2024-12-18 19:25:12.174698	\N	1	\N	\N	\N	761	238
612	2024-12-18 19:28:45.373964	2024-12-18 19:28:45.373964	\N	1	\N	\N	\N	762	239
613	2024-12-18 19:32:43.966728	2024-12-18 19:32:43.966728	\N	1	\N	\N	\N	763	240
614	2024-12-18 19:33:44.437385	2024-12-18 19:33:44.437385	\N	1	\N	\N	\N	764	241
615	2024-12-18 19:35:12.586087	2024-12-18 19:35:12.586087	\N	1	\N	\N	\N	765	242
616	2024-12-18 19:35:17.183657	2024-12-18 19:35:17.183657	\N	1	\N	\N	\N	766	243
617	2024-12-18 19:37:18.439	2024-12-18 19:37:18.439	\N	1	\N	\N	\N	767	244
618	2024-12-18 19:37:21.006454	2024-12-18 19:37:21.006454	\N	1	\N	\N	\N	768	245
619	2024-12-18 19:37:23.233422	2024-12-18 19:37:23.233422	\N	1	\N	\N	\N	769	246
620	2024-12-18 19:37:54.725005	2024-12-18 19:37:54.725005	\N	1	\N	\N	\N	770	247
621	2024-12-18 19:40:12.395425	2024-12-18 19:40:12.395425	\N	1	\N	\N	\N	771	248
622	2024-12-18 19:41:09.11003	2024-12-18 19:41:09.11003	\N	1	\N	\N	\N	772	249
623	2024-12-18 19:43:13.21581	2024-12-18 19:43:13.21581	\N	1	\N	\N	\N	773	250
624	2024-12-18 19:44:42.695662	2024-12-18 19:44:42.695662	\N	1	\N	\N	\N	774	251
625	2024-12-18 19:47:35.420872	2024-12-18 19:47:35.420872	\N	1	\N	\N	\N	775	252
626	2024-12-18 19:48:41.388045	2024-12-18 19:48:41.388045	\N	1	\N	\N	\N	776	253
627	2024-12-18 19:54:38.769564	2024-12-18 19:54:38.769564	\N	1	\N	\N	\N	777	254
628	2024-12-18 19:57:15.412305	2024-12-18 19:57:15.412305	\N	1	\N	\N	\N	778	255
629	2024-12-18 19:59:54.770483	2024-12-18 19:59:54.770483	\N	1	\N	\N	\N	779	256
630	2024-12-18 20:10:15.420007	2024-12-18 20:10:15.420007	\N	1	\N	\N	\N	780	257
631	2024-12-18 20:13:19.637315	2024-12-18 20:13:19.637315	\N	1	\N	\N	\N	781	258
632	2024-12-18 20:16:17.248276	2024-12-18 20:16:17.248276	\N	1	\N	\N	\N	782	259
633	2024-12-18 20:44:48.283286	2024-12-18 20:44:48.283286	\N	1	\N	\N	\N	783	260
634	2024-12-18 20:44:48.315027	2024-12-18 20:44:48.315027	\N	1	\N	\N	\N	784	260
635	2024-12-18 20:52:13.248356	2024-12-18 20:52:13.248356	\N	1	\N	\N	\N	785	261
636	2024-12-18 20:55:12.201277	2024-12-18 20:55:12.201277	\N	1	\N	\N	\N	786	262
637	2024-12-18 20:55:24.608675	2024-12-18 20:55:24.608675	\N	1	\N	\N	\N	787	263
638	2024-12-18 20:55:34.709064	2024-12-18 20:55:34.709064	\N	1	\N	\N	\N	788	264
639	2024-12-18 20:56:10.482578	2024-12-18 20:56:10.482578	\N	1	\N	\N	\N	789	265
640	2024-12-18 21:00:46.03955	2024-12-18 21:00:46.03955	\N	1	\N	\N	\N	790	266
641	2024-12-18 21:03:28.649211	2024-12-18 21:03:28.649211	\N	1	\N	\N	\N	791	267
642	2024-12-18 21:07:07.248632	2024-12-18 21:07:07.248632	\N	1	\N	\N	\N	792	268
643	2024-12-18 21:09:00.220718	2024-12-18 21:09:00.220718	\N	1	\N	\N	\N	793	269
644	2024-12-18 21:15:10.69988	2024-12-18 21:15:10.69988	\N	1	\N	\N	\N	794	270
645	2024-12-18 21:17:46.485338	2024-12-18 21:17:46.485338	\N	1	\N	\N	\N	795	271
646	2024-12-18 21:17:46.497495	2024-12-18 21:17:46.497495	\N	1	\N	\N	\N	805	271
647	2024-12-18 21:17:46.503027	2024-12-18 21:17:46.503027	\N	1	\N	\N	\N	806	271
648	2024-12-18 21:17:46.535543	2024-12-18 21:17:46.535543	\N	1	\N	\N	\N	796	271
649	2024-12-18 21:17:46.565914	2024-12-18 21:17:46.565914	\N	1	\N	\N	\N	799	271
650	2024-12-18 21:17:46.566568	2024-12-18 21:17:46.566568	\N	1	\N	\N	\N	797	271
651	2024-12-18 21:17:46.582958	2024-12-18 21:17:46.582958	\N	1	\N	\N	\N	798	271
652	2024-12-18 21:17:46.583888	2024-12-18 21:17:46.583888	\N	1	\N	\N	\N	800	271
653	2024-12-18 21:17:46.584426	2024-12-18 21:17:46.584426	\N	1	\N	\N	\N	804	271
654	2024-12-18 21:17:46.587163	2024-12-18 21:17:46.587163	\N	1	\N	\N	\N	802	271
655	2024-12-18 21:17:46.591594	2024-12-18 21:17:46.591594	\N	1	\N	\N	\N	801	271
656	2024-12-18 21:17:46.60529	2024-12-18 21:17:46.60529	\N	1	\N	\N	\N	803	271
657	2024-12-18 21:18:59.838653	2024-12-18 21:18:59.838653	\N	1	\N	\N	\N	807	272
658	2024-12-18 21:18:59.87635	2024-12-18 21:18:59.87635	\N	1	\N	\N	\N	808	272
659	2024-12-18 21:19:26.653159	2024-12-18 21:19:26.653159	\N	1	\N	\N	\N	809	273
660	2024-12-18 21:19:26.686351	2024-12-18 21:19:26.686351	\N	1	\N	\N	\N	810	273
661	2024-12-18 21:22:08.009845	2024-12-18 21:22:08.009845	\N	1	\N	\N	\N	811	274
662	2024-12-18 21:22:51.546693	2024-12-18 21:22:51.546693	\N	1	\N	\N	\N	812	275
663	2024-12-18 21:24:14.916892	2024-12-18 21:24:14.916892	\N	1	\N	\N	\N	813	276
664	2024-12-18 21:25:35.365242	2024-12-18 21:25:35.365242	\N	1	\N	\N	\N	814	277
665	2024-12-18 21:32:57.99168	2024-12-18 21:32:57.99168	\N	1	\N	\N	\N	815	278
666	2024-12-18 21:34:14.567248	2024-12-18 21:34:14.567248	\N	1	\N	\N	\N	816	279
667	2024-12-18 21:36:09.951686	2024-12-18 21:36:09.951686	\N	1	\N	\N	\N	817	280
668	2024-12-18 21:36:51.564796	2024-12-18 21:36:51.564796	\N	1	\N	\N	\N	818	281
669	2024-12-18 21:37:35.440676	2024-12-18 21:37:35.440676	\N	1	\N	\N	\N	819	282
670	2024-12-18 21:39:09.619939	2024-12-18 21:39:09.619939	\N	1	\N	\N	\N	820	283
671	2024-12-18 21:43:30.080735	2024-12-18 21:43:30.080735	\N	1	\N	\N	\N	821	284
672	2024-12-18 21:44:24.929627	2024-12-18 21:44:24.929627	\N	1	\N	\N	\N	822	285
673	2024-12-18 21:44:46.426642	2024-12-18 21:44:46.426642	\N	1	\N	\N	\N	823	286
674	2024-12-18 22:12:14.114244	2024-12-18 22:12:14.114244	\N	1	\N	\N	\N	824	287
675	2024-12-18 22:16:01.851787	2024-12-18 22:16:01.851787	\N	1	\N	\N	\N	825	288
676	2024-12-18 22:16:01.883491	2024-12-18 22:16:01.883491	\N	1	\N	\N	\N	826	288
677	2024-12-18 22:16:40.644137	2024-12-18 22:16:40.644137	\N	1	\N	\N	\N	827	289
678	2024-12-18 22:16:40.677146	2024-12-18 22:16:40.677146	\N	1	\N	\N	\N	828	289
679	2024-12-18 22:17:29.218621	2024-12-18 22:17:29.218621	\N	1	\N	\N	\N	829	290
680	2024-12-18 22:17:29.254577	2024-12-18 22:17:29.254577	\N	1	\N	\N	\N	830	290
681	2024-12-29 14:27:02.704095	2024-12-29 14:27:02.704095	\N	1	\N	\N	\N	713	291
682	2024-12-29 14:28:46.65757	2024-12-29 14:28:46.65757	\N	1	\N	\N	\N	713	292
683	2024-12-29 14:39:12.256315	2024-12-29 14:39:12.256315	\N	1	\N	\N	\N	713	293
684	2024-12-29 14:40:33.809265	2024-12-29 14:40:33.809265	\N	1	\N	\N	\N	713	294
685	2024-12-29 14:42:12.94159	2024-12-29 14:42:12.94159	\N	1	\N	\N	\N	831	295
686	2024-12-29 15:48:16.72781	2024-12-29 15:48:16.72781	\N	1	\N	\N	\N	831	296
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction (id, reference, amount, date, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "transactionTypeId", "bankAccountId", "paymentId") FROM stdin;
283	2024121800000272	1068.8	2024-12-18 19:24:27.941-04	2024-12-18 19:24:27.95308	2024-12-18 19:24:27.95308	\N	5	\N	\N	\N	1	1	236
284	2024121800000273	1068.8	2024-12-18 19:24:53.711-04	2024-12-18 19:24:53.723397	2024-12-18 19:24:53.723397	\N	5	\N	\N	\N	1	1	237
285	2024121800000274	1068.8	2024-12-18 19:25:12.179-04	2024-12-18 19:25:12.189962	2024-12-18 19:25:12.189962	\N	5	\N	\N	\N	1	1	238
286	2024121800000275	1068.8	2024-12-18 19:28:45.376-04	2024-12-18 19:28:45.385367	2024-12-18 19:28:45.385367	\N	5	\N	\N	\N	1	1	239
287	2024121800000276	1068.8	2024-12-18 19:32:43.971-04	2024-12-18 19:32:43.98073	2024-12-18 19:32:43.98073	\N	5	\N	\N	\N	1	1	240
288	2024121800000277	1068.8	2024-12-18 19:33:44.441-04	2024-12-18 19:33:44.450155	2024-12-18 19:33:44.450155	\N	5	\N	\N	\N	1	1	241
289	2024121800000278	1068.8	2024-12-18 19:35:12.589-04	2024-12-18 19:35:12.59977	2024-12-18 19:35:12.59977	\N	5	\N	\N	\N	1	1	242
290	2024121800000279	1068.8	2024-12-18 19:35:17.189-04	2024-12-18 19:35:17.206018	2024-12-18 19:35:17.206018	\N	5	\N	\N	\N	1	1	243
291	2024121800000280	1068.8	2024-12-18 19:37:18.442-04	2024-12-18 19:37:18.454162	2024-12-18 19:37:18.454162	\N	5	\N	\N	\N	1	1	244
292	2024121800000281	1068.8	2024-12-18 19:37:21.01-04	2024-12-18 19:37:21.028176	2024-12-18 19:37:21.028176	\N	5	\N	\N	\N	1	1	245
293	2024121800000282	1068.8	2024-12-18 19:37:23.237-04	2024-12-18 19:37:23.253508	2024-12-18 19:37:23.253508	\N	5	\N	\N	\N	1	1	246
294	2024121800000283	1068.8	2024-12-18 19:37:54.731-04	2024-12-18 19:37:54.747273	2024-12-18 19:37:54.747273	\N	5	\N	\N	\N	1	1	247
295	2024121800000284	1068.8	2024-12-18 19:40:12.398-04	2024-12-18 19:40:12.408286	2024-12-18 19:40:12.408286	\N	5	\N	\N	\N	1	1	248
296	2024121800000285	1068.8	2024-12-18 19:41:09.114-04	2024-12-18 19:41:09.125204	2024-12-18 19:41:09.125204	\N	5	\N	\N	\N	1	1	249
253	2024121000000245	775.6365000000001	2024-12-10 21:40:22.045-04	2024-12-10 21:40:22.064279	2024-12-10 21:42:06.10905	\N	6	\N	\N	\N	1	1	197
297	2024121800000286	1068.8	2024-12-18 19:43:13.219-04	2024-12-18 19:43:13.238253	2024-12-18 19:43:13.238253	\N	5	\N	\N	\N	1	1	250
254	2024121000000248	258.5455	2024-12-10 21:49:03.799-04	2024-12-10 21:49:03.816955	2024-12-10 21:49:17.177882	\N	6	\N	\N	\N	1	1	198
298	2024121800000287	1068.8	2024-12-18 19:44:42.697-04	2024-12-18 19:44:42.710435	2024-12-18 19:44:42.710435	\N	5	\N	\N	\N	1	1	251
255	2024121000000250	258.5455	2024-12-10 21:57:27.21-04	2024-12-10 21:57:27.22872	2024-12-10 21:57:41.108276	\N	6	\N	\N	\N	1	1	199
256	2024121000000252	258.5455	2024-12-10 22:01:52.188-04	2024-12-10 22:01:52.207446	2024-12-10 22:01:59.831208	\N	6	\N	\N	\N	1	1	200
257	2024121000000254	258.5455	2024-12-10 22:04:45.069-04	2024-12-10 22:04:45.085813	2024-12-10 22:04:52.790431	\N	6	\N	\N	\N	1	1	201
258	34501177	258.5455	2024-12-10 22:16:21.296-04	2024-12-10 22:16:21.317229	2024-12-10 22:16:27.850771	\N	6	\N	\N	\N	1	1	202
259	123456987	258.5455	2024-12-10 00:00:00-04	2024-12-10 23:36:10.771396	2024-12-10 23:36:10.771396	\N	5	\N	\N	\N	2	2	203
260	123434	258.5455	2024-12-11 00:00:00-04	2024-12-11 00:20:16.661524	2024-12-11 00:20:16.661524	\N	5	\N	\N	\N	2	2	211
261	123434	258.5455	2024-12-11 00:00:00-04	2024-12-11 00:25:34.289194	2024-12-11 00:25:34.289194	\N	5	\N	\N	\N	2	2	212
262	123434	258.5455	2024-12-11 00:00:00-04	2024-12-11 00:27:34.968093	2024-12-11 00:27:34.968093	\N	5	\N	\N	\N	2	2	213
263	123434	258.5455	2024-12-11 00:00:00-04	2024-12-11 00:31:00.718884	2024-12-11 00:31:00.718884	\N	5	\N	\N	\N	2	2	214
264	123434	258.5455	2024-12-11 00:00:00-04	2024-12-11 00:32:12.34768	2024-12-11 00:32:12.34768	\N	5	\N	\N	\N	2	2	215
265	123434	258.5455	2024-12-11 00:00:00-04	2024-12-11 00:32:48.791252	2024-12-11 00:32:48.791252	\N	5	\N	\N	\N	2	2	216
266	123434	258.5455	2024-12-11 00:00:00-04	2024-12-11 00:33:39.966555	2024-12-11 00:33:39.966555	\N	5	\N	\N	\N	2	2	217
267	123434	258.5455	2024-12-11 00:00:00-04	2024-12-11 00:35:08.869367	2024-12-11 00:35:08.869367	\N	5	\N	\N	\N	2	2	218
268	22222	517.091	2024-12-11 00:00:00-04	2024-12-11 00:36:48.534059	2024-12-11 00:36:48.534059	\N	5	\N	\N	\N	3	2	221
269	2024121600000258	2113.28	2024-12-16 22:16:29.534-04	2024-12-16 22:16:29.551791	2024-12-16 22:16:29.551791	\N	5	\N	\N	\N	1	1	222
270	2024121600000259	2113.28	2024-12-16 22:28:52.326-04	2024-12-16 22:28:52.346365	2024-12-16 22:28:52.346365	\N	5	\N	\N	\N	1	1	223
271	2024121800000260	1068.8	2024-12-18 17:53:56.573-04	2024-12-18 17:53:56.596106	2024-12-18 17:53:56.596106	\N	5	\N	\N	\N	1	1	224
272	2024121800000261	1068.8	2024-12-18 18:23:01.87-04	2024-12-18 18:23:01.894273	2024-12-18 18:23:01.894273	\N	5	\N	\N	\N	1	1	225
273	2024121800000262	1068.8	2024-12-18 18:34:25.164-04	2024-12-18 18:34:25.184264	2024-12-18 18:34:25.184264	\N	5	\N	\N	\N	1	1	226
274	2024121800000263	1068.8	2024-12-18 18:49:44.445-04	2024-12-18 18:49:44.470173	2024-12-18 18:49:44.470173	\N	5	\N	\N	\N	1	1	227
275	2024121800000264	1068.8	2024-12-18 18:51:52.392-04	2024-12-18 18:51:52.410014	2024-12-18 18:51:52.410014	\N	5	\N	\N	\N	1	1	228
276	2024121800000265	1068.8	2024-12-18 18:59:07.035-04	2024-12-18 18:59:07.046989	2024-12-18 18:59:07.046989	\N	5	\N	\N	\N	1	1	229
277	2024121800000266	1068.8	2024-12-18 19:02:04.436-04	2024-12-18 19:02:04.454306	2024-12-18 19:02:04.454306	\N	5	\N	\N	\N	1	1	230
278	2024121800000267	1068.8	2024-12-18 19:02:56.818-04	2024-12-18 19:02:56.851132	2024-12-18 19:02:56.851132	\N	5	\N	\N	\N	1	1	231
279	2024121800000268	1068.8	2024-12-18 19:09:50.856-04	2024-12-18 19:09:50.875622	2024-12-18 19:09:50.875622	\N	5	\N	\N	\N	1	1	232
280	2024121800000269	1068.8	2024-12-18 19:23:24.478-04	2024-12-18 19:23:24.491398	2024-12-18 19:23:24.491398	\N	5	\N	\N	\N	1	1	233
281	2024121800000270	1068.8	2024-12-18 19:24:11.251-04	2024-12-18 19:24:11.267575	2024-12-18 19:24:11.267575	\N	5	\N	\N	\N	1	1	234
282	2024121800000271	1068.8	2024-12-18 19:24:11.254-04	2024-12-18 19:24:11.271739	2024-12-18 19:24:11.271739	\N	5	\N	\N	\N	1	1	235
299	35301257	1068.8	2024-12-18 19:47:35.424-04	2024-12-18 19:47:35.44283	2024-12-18 19:47:55.34236	\N	6	\N	\N	\N	1	1	252
300	35301258	1068.8	2024-12-18 19:48:41.392-04	2024-12-18 19:48:41.407871	2024-12-18 19:48:49.23294	\N	6	\N	\N	\N	1	1	253
301	35301259	1068.8	2024-12-18 19:54:38.774-04	2024-12-18 19:54:38.788054	2024-12-18 19:54:48.906514	\N	6	\N	\N	\N	1	1	254
302	35301260	1068.8	2024-12-18 19:57:15.416-04	2024-12-18 19:57:15.430952	2024-12-18 19:57:21.406592	\N	6	\N	\N	\N	1	1	255
303	2024121800000296	1068.8	2024-12-18 19:59:54.774-04	2024-12-18 19:59:54.790901	2024-12-18 19:59:54.790901	\N	5	\N	\N	\N	1	1	256
304	2024121800000298	1068.8	2024-12-18 20:10:15.422-04	2024-12-18 20:10:15.433677	2024-12-18 20:10:15.433677	\N	5	\N	\N	\N	1	1	257
305	2024121800000300	1068.8	2024-12-18 20:13:19.64-04	2024-12-18 20:13:19.661621	2024-12-18 20:13:19.661621	\N	5	\N	\N	\N	1	1	258
306	2024121800000302	1068.8	2024-12-18 20:16:17.256-04	2024-12-18 20:16:17.269131	2024-12-18 20:16:17.269131	\N	5	\N	\N	\N	1	1	259
307	2024121800000304	2137.6	2024-12-18 20:44:48.324-04	2024-12-18 20:44:48.342623	2024-12-18 20:44:48.342623	\N	5	\N	\N	\N	1	1	260
308	2024121800000308	1068.8	2024-12-18 20:52:13.254-04	2024-12-18 20:52:13.274589	2024-12-18 20:52:13.274589	\N	5	\N	\N	\N	1	1	261
309	2024121800000316	1068.8	2024-12-18 20:55:12.205-04	2024-12-18 20:55:12.218597	2024-12-18 20:55:12.218597	\N	5	\N	\N	\N	1	1	262
310	2024121800000318	1068.8	2024-12-18 20:55:24.612-04	2024-12-18 20:55:24.627144	2024-12-18 20:55:24.627144	\N	5	\N	\N	\N	1	1	263
311	2024121800000320	1068.8	2024-12-18 20:55:34.713-04	2024-12-18 20:55:34.731346	2024-12-18 20:55:34.731346	\N	5	\N	\N	\N	1	1	264
312	2024121800000322	1068.8	2024-12-18 20:56:10.49-04	2024-12-18 20:56:10.514323	2024-12-18 20:56:10.514323	\N	5	\N	\N	\N	1	1	265
313	2024121800000324	1068.8	2024-12-18 21:00:46.045-04	2024-12-18 21:00:46.070347	2024-12-18 21:00:46.070347	\N	5	\N	\N	\N	1	1	266
314	2024121800000326	1068.8	2024-12-18 21:03:28.655-04	2024-12-18 21:03:28.672688	2024-12-18 21:03:28.672688	\N	5	\N	\N	\N	1	1	267
315	2024121800000327	1068.8	2024-12-18 21:07:07.253-04	2024-12-18 21:07:07.267472	2024-12-18 21:07:07.267472	\N	5	\N	\N	\N	1	1	268
316	2024121800000328	1068.8	2024-12-18 21:09:00.226-04	2024-12-18 21:09:00.245095	2024-12-18 21:09:00.245095	\N	5	\N	\N	\N	1	1	269
317	2024121800000329	1068.8	2024-12-18 21:15:10.707-04	2024-12-18 21:15:10.726398	2024-12-18 21:15:10.726398	\N	5	\N	\N	\N	1	1	270
318	35301261	12825.62	2024-12-18 21:17:46.613-04	2024-12-18 21:17:46.629779	2024-12-18 21:17:54.352188	\N	6	\N	\N	\N	1	1	271
319	2024121800000332	2137.6	2024-12-18 21:18:59.886-04	2024-12-18 21:18:59.90529	2024-12-18 21:18:59.90529	\N	5	\N	\N	\N	1	1	272
320	2024121800000334	2137.6	2024-12-18 21:19:26.696-04	2024-12-18 21:19:26.71171	2024-12-18 21:19:26.71171	\N	5	\N	\N	\N	1	1	273
321	35301262	1068.8	2024-12-18 21:22:08.016-04	2024-12-18 21:22:08.037581	2024-12-18 21:22:14.693951	\N	6	\N	\N	\N	1	1	274
322	35301263	1068.8	2024-12-18 21:22:51.553-04	2024-12-18 21:22:51.56959	2024-12-18 21:22:59.314	\N	6	\N	\N	\N	1	1	275
323	35301264	1068.8	2024-12-18 21:24:14.922-04	2024-12-18 21:24:14.94107	2024-12-18 21:24:22.385998	\N	6	\N	\N	\N	1	1	276
324	2024121800000342	1068.8	2024-12-18 21:25:35.373-04	2024-12-18 21:25:35.398264	2024-12-18 21:25:35.398264	\N	5	\N	\N	\N	1	1	277
325	35301265	1068.8	2024-12-18 21:32:58-04	2024-12-18 21:32:58.023428	2024-12-18 21:33:14.728091	\N	6	\N	\N	\N	1	1	278
326	35301267	1068.8	2024-12-18 21:34:14.573-04	2024-12-18 21:34:14.590744	2024-12-18 21:36:04.374986	\N	6	\N	\N	\N	1	1	279
327	35301268	1068.8	2024-12-18 21:36:09.958-04	2024-12-18 21:36:09.976864	2024-12-18 21:36:16.112899	\N	6	\N	\N	\N	1	1	280
328	35301269	1068.8	2024-12-18 21:36:51.569-04	2024-12-18 21:36:51.580255	2024-12-18 21:36:56.604357	\N	6	\N	\N	\N	1	1	281
329	35301270	1068.8	2024-12-18 21:37:35.446-04	2024-12-18 21:37:35.466331	2024-12-18 21:37:41.118068	\N	6	\N	\N	\N	1	1	282
330	35301271	1068.8	2024-12-18 21:39:09.624-04	2024-12-18 21:39:09.634357	2024-12-18 21:39:14.466063	\N	6	\N	\N	\N	1	1	283
331	35301272	1068.8	2024-12-18 21:43:30.085-04	2024-12-18 21:43:30.108372	2024-12-18 21:43:36.214581	\N	6	\N	\N	\N	1	1	284
332	35301273	1068.8	2024-12-18 21:44:24.934-04	2024-12-18 21:44:24.954181	2024-12-18 21:44:33.339133	\N	6	\N	\N	\N	1	1	285
333	35301274	1068.8	2024-12-18 21:44:46.43-04	2024-12-18 21:44:46.441812	2024-12-18 21:44:50.929783	\N	6	\N	\N	\N	1	1	286
334	35301275	1	2024-12-18 22:12:14.121-04	2024-12-18 22:12:14.141154	2024-12-18 22:12:34.647027	\N	6	\N	\N	\N	1	1	287
335	35301276	2	2024-12-18 22:16:01.889-04	2024-12-18 22:16:01.903662	2024-12-18 22:16:11.021961	\N	6	\N	\N	\N	1	1	288
336	35301277	2	2024-12-18 22:16:40.686-04	2024-12-18 22:16:40.698513	2024-12-18 22:16:50.465618	\N	6	\N	\N	\N	1	1	289
337	35301278	2	2024-12-18 22:17:29.263-04	2024-12-18 22:17:29.282565	2024-12-18 22:17:39.12457	\N	6	\N	\N	\N	1	1	290
338	1234	270.53	2024-12-29 00:00:00-04	2024-12-29 14:42:12.974707	2024-12-29 14:42:12.974707	\N	6	\N	\N	\N	2	2	295
339	4125	270.53	2024-12-29 00:00:00-04	2024-12-29 15:48:16.749781	2024-12-29 15:48:16.749781	\N	6	\N	\N	\N	2	2	296
\.


--
-- Data for Name: transactions_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_type (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", movement_type, description_interface) FROM stdin;
1	ONLINE	type of online transactions	2024-11-20 20:58:20.779	2024-11-20 20:58:20.779	\N	1	1	1	\N	CREDIT	EN LINEA
2	MOBILE_PAYMENT	type of mobile payment transactions	2024-11-20 20:58:20.779	2024-11-20 20:58:20.779	\N	1	1	1	\N	CREDIT	PAGO MÓVIL
3	BANK_TRANSFER	type of bank transfer transactions	2024-11-20 21:05:17.895381	2024-11-20 21:05:17.895381	\N	1	1	1	\N	CREDIT	TRANSFERENCIA
4	POINT_OF_SALES	type of transactions by point of sale	2024-11-20 21:18:38.266893	2024-11-20 21:18:38.266893	\N	1	1	1	\N	CREDIT	PUNTO DE VENTA
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
11	ljml69@gmail.com	$2a$10$nMX0Lc0X4M7lZD0kxYAYrei34eQRgOz9ErhfU.qKvwrXvToW1KlVW	V	8612413	1996-01-19	\N	El refugio	+58 424 4431006	\N	2024-12-18 22:05:24.607124	2024-12-18 22:07:42.866688	\N	1	\N	\N	\N	3	1	274	Lisbeth Martinez	$argon2id$v=19$m=65536,t=3,p=4$pMSTFOApWRSl3uFNKt9gag$X5KcbNQuVGXvoEy84HrUpe/GkkyS4lgk5hF5INpEwW8	f	F
4	broook.hum04@gmail.com	$2a$10$eWZ/hA/9iz/V0wnymAiyoub4x5XfpDxZ6k1WSdxatl.n1/ov5.7dm	V	28465203	1964-02-02	\N	Guigue, barrio Rosendo Torres 2, casa nro. 41, calle del cementerio	+58 414 4085730	\N	2024-10-14 14:54:09.9	2024-11-19 20:30:30.133539	\N	1	1	1	\N	3	1	285	Carlos Arnaldo Cárdenas Sosa		f	F
1	shyf.infosiartec@gmail.com	$2a$10$nXtUPsWyqglYlPp0ehUOQu.hrUCB0CIv/K51AW21ZDLcBUxsnZwTS	G	20000152-6	\N	1900-01-01	Av. Michelena a 100 Mts. del elevado La Quizanda detrás de las oficinas del IVEC Sede Sec. Hacienda y Finanzas – Valencia - Edo. Carabobo.	+58 241 8743470	\N	2024-06-25 21:49:14.69	2024-11-23 21:02:53.729682	\N	1	1	1	\N	1	6	285	SUPER ADMIN		f	O
5	sebastian.gamboalima@gmail.com	$2a$10$wpHmJMkJYYAOWQ/OkaY02.A4BupEFscr.OosU59uwd/xqw/6BAetC	V	28465204	1953-12-15	\N	Guigue, barrio Rosendo Torres 2, casa nro. 41, calle del cementerio	+58 414 4085731	\N	2024-10-14 14:54:09.9	2024-12-29 14:06:23.710022	\N	1	1	1	\N	3	1	285	Carlos Arnaldo Cárdenas Sosa	$argon2id$v=19$m=65536,t=3,p=4$WCjE3BYZffw+Ue+QdoJAwQ$s5CROegvL1ZHM26IMU+yeXcz6w55x8l6JMoJ5Snx1RY	f	M
2	nelmerayala@gmail.com	$2a$10$wpHmJMkJYYAOWQ/OkaY02.A4BupEFscr.OosU59uwd/xqw/6BAetC	V	24297146	1965-02-02	\N	Los tamarindos	+58 414 4196316	\N	2024-06-26 23:02:27.391	2024-12-29 14:10:10.241581	\N	1	1	1	\N	2	2	269	Ayala Seijas Nelmer Alexander	$argon2id$v=19$m=65536,t=3,p=4$kljZIKbPBWpVaQOwrs3d3g$oyzzi6yZ+XzSAzf7+AWf06Q8e7Yq03aphfkNkSYVZLI	f	M
3	jennyaray98@gmail.com	$2a$10$OQsz9Gj2Xw4J.hsWbUo2gOtcA.FdXXHtPMgyYp1cCA9gjSiYFKxN.	V	26306715	1965-02-02	\N	San Judas Tadeo I	+58 424 4571298	\N	2024-10-17 19:17:42.11	2024-10-17 19:17:42.11	\N	1	1	1	\N	4	1	285	Jennyreth Cristina Aray Andrade		t	F
\.


--
-- Name: annual_correlative_tax_stamps; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.annual_correlative_tax_stamps', 379, true);


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

SELECT pg_catalog.setval('public.bank_account_id_seq', 2, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bank_id_seq', 33, true);


--
-- Name: branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_id_seq', 1, true);


--
-- Name: calculation_factor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.calculation_factor_id_seq', 81, true);


--
-- Name: coin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coin_id_seq', 3, true);


--
-- Name: contributors_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contributors_type_id_seq', 6, true);


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.country_id_seq', 240, true);


--
-- Name: daily_correlative_request_bank; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daily_correlative_request_bank', 369, true);


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

SELECT pg_catalog.setval('public.external_request_id_seq', 393, true);


--
-- Name: locker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locker_id_seq', 1, true);


--
-- Name: lockers_point_of_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lockers_point_of_sale_id_seq', 1, false);


--
-- Name: municipalities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.municipalities_id_seq', 335, true);


--
-- Name: parameter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parameter_id_seq', 3, true);


--
-- Name: parishes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parishes_id_seq', 1134, true);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_id_seq', 296, true);


--
-- Name: payments_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_type_id_seq', 3, true);


--
-- Name: point_of_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.point_of_sale_id_seq', 1, true);


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

SELECT pg_catalog.setval('public.roles_privilege_id_seq', 41, true);


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

SELECT pg_catalog.setval('public.tax_stamp_id_seq', 831, true);


--
-- Name: tax_stamps_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tax_stamps_payment_id_seq', 686, true);


--
-- Name: transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_id_seq', 339, true);


--
-- Name: transactions_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_type_id_seq', 4, true);


--
-- Name: types_external_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.types_external_request_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 11, true);


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
-- Name: parameter PK_cc5c047040f9c69f0e0d6a844a0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT "PK_cc5c047040f9c69f0e0d6a844a0" PRIMARY KEY (id);


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
-- Name: parameter UQ_739d1ad76dacab8e0a73da54e59; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT "UQ_739d1ad76dacab8e0a73da54e59" UNIQUE (code);


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
-- Name: parameter FK_1e5aeaf99f4b174e380a2061242; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT "FK_1e5aeaf99f4b174e380a2061242" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


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
-- Name: locker FK_c43f3fa70bc3812a81bc0d88b26; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locker
    ADD CONSTRAINT "FK_c43f3fa70bc3812a81bc0d88b26" FOREIGN KEY ("userId") REFERENCES public.users(id);


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
-- Name: parameter FK_cd7369492c2ff3ff0510f58f7bf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT "FK_cd7369492c2ff3ff0510f58f7bf" FOREIGN KEY ("createdById") REFERENCES public.users(id);


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
-- Name: parameter FK_dff4dc5b724ff8a4a6433b8b12b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT "FK_dff4dc5b724ff8a4a6433b8b12b" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


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
-- Name: parameter FK_f5242ee8a7aa8c490eeb7f7bf29; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT "FK_f5242ee8a7aa8c490eeb7f7bf29" FOREIGN KEY ("statusId") REFERENCES public.status(id);


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

