--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

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
-- Name: siartecapp; Type: USER;
--
  CREATE USER siartecapp WITH ENCRYPTED PASSWORD '514RT3C';
  GRANT ALL PRIVILEGES ON DATABASE siartec TO siartecapp;


--
-- Name: status_apply_to_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_apply_to_enum AS ENUM (
    'all',
    'stamps',
    'payments'
);


ALTER TYPE public.status_apply_to_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

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
    "deletedById" integer
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


ALTER TABLE public.contributors_type_id_seq OWNER TO postgres;

--
-- Name: contributors_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contributors_type_id_seq OWNED BY public.contributors_type.id;


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


ALTER TABLE public.privilege_id_seq OWNER TO postgres;

--
-- Name: privilege_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.privilege_id_seq OWNED BY public.privilege.id;


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


ALTER TABLE public.role_id_seq OWNER TO postgres;

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


ALTER TABLE public.roles_privilege_id_seq OWNER TO postgres;

--
-- Name: roles_privilege_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_privilege_id_seq OWNED BY public.roles_privilege.id;


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


ALTER TABLE public.status_id_seq OWNER TO postgres;

--
-- Name: status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.status_id_seq OWNED BY public.status.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    firstname character varying(30) NOT NULL,
    lastname character varying(30) NOT NULL,
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
    personal_signature boolean DEFAULT false NOT NULL
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


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: contributors_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type ALTER COLUMN id SET DEFAULT nextval('public.contributors_type_id_seq'::regclass);


--
-- Name: privilege id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilege ALTER COLUMN id SET DEFAULT nextval('public.privilege_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: roles_privilege id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege ALTER COLUMN id SET DEFAULT nextval('public.roles_privilege_id_seq'::regclass);


--
-- Name: status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status ALTER COLUMN id SET DEFAULT nextval('public.status_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: contributors_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contributors_type (id, code, description, amount, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	NATURAL	Natural	5	2024-07-15 16:56:16.651399	2024-07-15 16:56:16.651399	\N	1	1	1	\N
2	COMMERCIAL	Comercial	20	2024-07-15 16:56:16.656944	2024-07-15 16:56:16.656944	\N	1	1	1	\N
3	INDUSTRIAL	Industrial	50	2024-07-15 16:56:16.657983	2024-07-15 16:56:16.657983	\N	1	1	1	\N
\.


--
-- Data for Name: privilege; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.privilege (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	R_PROFILE	Consult (read) user profile in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	1	1	\N
2	U_PASSWORD	Modify (update) user password in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	1	1	\N
3	R_TAX_STAMPS	Consult (read) user tax stamps in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	1	1	\N
4	C_TAX_STAMPS	Generate (create) user tax stamps in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	1	1	\N
5	C_PAYMENTS	Pay (create) user tax stamps in session	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	1	1	\N
6	C_PAYMENTS_OFFICE	Pay (create) at the box office	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	1	1	\N
7	R_TAX_STAMPS_OFFICE	Consult (read) tax stamps at the box office	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	1	1	\N
8	C_TAX_STAMPS_OFFICE	Generate (create) tax stamps at the box office	2024-07-15 16:34:53.536549	2024-07-15 16:34:53.536549	\N	1	1	1	\N
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id, code, description, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	SUPERADMIN	ROLE WITH ALL PRIVILEGES - ONLY FOR DEVELOPERS	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	1	1	\N
3	NATURAL	ROLE WITH THE PRIVILEGES REQUIRED FOR A NATURAL CONTRIBUTOR	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	1	1	\N
4	COMMERCIAL	ROLE WITH THE PRIVILEGES REQUIRED FOR A COMMERCIAL CONTRIBUTOR	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	1	1	\N
2	ADMINTRADOR	ROLE WITH THE PRIVILEGES REQUIRED FOR A ADMINISTRATOR OF COLLECTION	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	1	1	\N
5	INDUSTRIAL	ROLE WITH THE PRIVILEGES REQUIRED FOR A INDUSTRIAL TRIBUTOR	2024-07-15 15:07:29.546634	2024-07-15 15:07:29.546634	\N	1	1	1	\N
\.


--
-- Data for Name: roles_privilege; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles_privilege (id, "roleId", "privilegeId", created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
1	1	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
2	1	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
3	1	3	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
4	1	4	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
5	1	5	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
6	1	6	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
7	1	7	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
8	1	8	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
9	2	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
10	2	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
11	2	6	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
12	2	7	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
13	2	8	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
14	3	1	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
15	3	2	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
16	3	3	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
17	3	4	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
18	3	5	2024-07-15 16:46:22.606653	2024-07-15 16:46:22.606653	\N	1	1	1	\N
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status (id, code, description, apply_to, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById") FROM stdin;
2	INACTIVE	logical state of deleted registers	all	2024-07-15 13:44:30.197311	2024-07-15 13:44:30.197311	\N	\N	\N	\N	\N
1	ACTIVE	logical state of active registers	all	2024-07-15 13:42:34.889805	2024-07-15 13:42:34.889805	\N	\N	\N	\N	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, firstname, lastname, email, password, identity_document_letter, identity_document, birthdate, constitution_date, address, phone_number, last_connection, created_at, updated_at, deleted_at, "statusId", "createdById", "updatedById", "deletedById", "roleId", "contributorTypeId", personal_signature) FROM stdin;
1	SUPER	ADMIN	shyf.infosiartec@gmail.com	$2b$10$EnHiFgWDchGadUAoZDSFZepstWg//JTpdfAFrVus0uZZMrNZCRW5m	G	20000152-6	\N	1900-01-01	Av. Michelena a 100 Mts. del elevado La Quizanda detrás de las oficinas del IVEC Sede Sec. Hacienda y Finanzas – Valencia - Edo. Carabobo.	+58 241 8743470	\N	2024-06-25 21:49:14.690847	2024-06-26 22:11:38.979704	\N	1	1	1	\N	1	\N	f
2	Nelmer Alexander	Ayala Seijas	nelmerayala@gmail.com	$2b$10$A72NMmuYRUKqbNCspniXFu9tzHTdEv89/74wPNem0t3PSSfyvaYU.	V	24297146-5	1996-02-02	\N	Mariara	+58 414 4196314	\N	2024-06-26 23:02:27.391821	2024-06-26 23:05:28.29844	\N	1	1	1	\N	3	1	f
22	Nelmer A.	Ayala S.	nayala@intelix.biz	$2b$10$YErdV9Qh/ncwJ0WbdN1GTuvhfrmE/dlKaZg7Lm3QhvBnDvBIC4Hze	V	242971460	1996-02-02	\N	Valencia - Zona Industrial	+58 414 4196314	\N	2024-07-15 22:44:49.213396	2024-07-15 22:44:49.213396	\N	\N	\N	\N	\N	1	1	f
\.


--
-- Name: contributors_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contributors_type_id_seq', 3, true);


--
-- Name: privilege_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.privilege_id_seq', 8, true);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_seq', 5, true);


--
-- Name: roles_privilege_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_privilege_id_seq', 18, true);


--
-- Name: status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 22, true);


--
-- Name: roles_privilege PK_0f37c17581d6dc45e779269eee3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "PK_0f37c17581d6dc45e779269eee3" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


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
-- Name: contributors_type PK_c1506dfb5df21dbfab0e435fa26; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type
    ADD CONSTRAINT "PK_c1506dfb5df21dbfab0e435fa26" PRIMARY KEY (id);


--
-- Name: status PK_e12743a7086ec826733f54e1d95; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT "PK_e12743a7086ec826733f54e1d95" PRIMARY KEY (id);


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
-- Name: contributors_type FK_1af2cc2279196d5d89691e9f9f7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type
    ADD CONSTRAINT "FK_1af2cc2279196d5d89691e9f9f7" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


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
-- Name: users FK_368e146b785b574f42ae9e53d5e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_368e146b785b574f42ae9e53d5e" FOREIGN KEY ("roleId") REFERENCES public.role(id);


--
-- Name: role FK_3fc73ac1307382a3b92e79b4886; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_3fc73ac1307382a3b92e79b4886" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: status FK_4b0d46ac203bc2793a4b7ff4a9f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT "FK_4b0d46ac203bc2793a4b7ff4a9f" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: roles_privilege FK_4fc9aa331b52e64ec1a397a4e50; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_4fc9aa331b52e64ec1a397a4e50" FOREIGN KEY ("privilegeId") REFERENCES public.privilege(id);


--
-- Name: users FK_51d635f1d983d505fb5a2f44c52; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_51d635f1d983d505fb5a2f44c52" FOREIGN KEY ("createdById") REFERENCES public.users(id);


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
-- Name: users FK_5a42116cfd0ba58cc89c86eef6d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_5a42116cfd0ba58cc89c86eef6d" FOREIGN KEY ("contributorTypeId") REFERENCES public.contributors_type(id);


--
-- Name: roles_privilege FK_617f7d7845622373abbd809f3a0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_617f7d7845622373abbd809f3a0" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: role FK_686b8af82beeafa884598c4da41; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_686b8af82beeafa884598c4da41" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: privilege FK_88ab3554c9f8ee2383bc809c97e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilege
    ADD CONSTRAINT "FK_88ab3554c9f8ee2383bc809c97e" FOREIGN KEY ("statusId") REFERENCES public.status(id);


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
-- Name: role FK_c5d666dd8bf212b0d9ba353cb4f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_c5d666dd8bf212b0d9ba353cb4f" FOREIGN KEY ("deletedById") REFERENCES public.users(id);


--
-- Name: roles_privilege FK_ceb39649606ec7deebc5839723d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_ceb39649606ec7deebc5839723d" FOREIGN KEY ("roleId") REFERENCES public.role(id);


--
-- Name: roles_privilege FK_d0780d745c6a2ff3dc9a325c5f5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_d0780d745c6a2ff3dc9a325c5f5" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- Name: privilege FK_d246ef838089a51c6751b1fe6fd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilege
    ADD CONSTRAINT "FK_d246ef838089a51c6751b1fe6fd" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: contributors_type FK_d86acce51f75b3842f9627eea0b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors_type
    ADD CONSTRAINT "FK_d86acce51f75b3842f9627eea0b" FOREIGN KEY ("createdById") REFERENCES public.users(id);


--
-- Name: status FK_db87eda17c02b45b40985d0a68f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT "FK_db87eda17c02b45b40985d0a68f" FOREIGN KEY ("createdById") REFERENCES public.users(id);


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
-- Name: roles_privilege FK_f2c399597c1f8fae05e918d2c28; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_privilege
    ADD CONSTRAINT "FK_f2c399597c1f8fae05e918d2c28" FOREIGN KEY ("updatedById") REFERENCES public.users(id);


--
-- Name: users FK_fffa7945e50138103659f6326b7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_fffa7945e50138103659f6326b7" FOREIGN KEY ("statusId") REFERENCES public.status(id);


--
-- PostgreSQL database dump complete
--

