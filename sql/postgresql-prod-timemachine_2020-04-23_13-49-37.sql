--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.10
-- Dumped by pg_dump version 10.12

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "clientNo" text,
    "responsibilityCenter" text,
    "serviceCenter" text,
    stob text,
    "projectCode" text,
    "orgDivision" text,
    email text,
    "addressLine1" text NOT NULL,
    "addressLine2" text,
    city text NOT NULL,
    province text,
    country text,
    "postalCode" text NOT NULL,
    "dateCreated" timestamp without time zone,
    "dateModified" timestamp without time zone,
    "isNonMinistry" boolean,
    "nonMinistryName" text,
    "ministryId" uuid
);


ALTER TABLE public.client OWNER TO postgres;

--
-- Name: contact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "contactType" text,
    "fullName" text,
    "orgName" text,
    "orgPosition" text,
    email text,
    "phoneNumber" text,
    "addressLine1" text,
    "addressLine2" text,
    city text,
    province text,
    country text,
    "postalCode" text,
    "roleName" text,
    "dateCreated" timestamp without time zone,
    "dateModified" timestamp without time zone,
    "hourlyRate" integer
);


ALTER TABLE public.contact OWNER TO postgres;

--
-- Name: finance_export; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.finance_export (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "documentNo" text NOT NULL,
    "lineDesc" text,
    sap text,
    reference text,
    contact text,
    organisation text,
    fees double precision NOT NULL,
    expenses double precision NOT NULL,
    "totalAmount" double precision NOT NULL,
    "clientNo" text,
    "responsibilityCenter" text,
    "serviceCenter" text,
    stob text,
    "projectCode" text,
    "projectId" uuid,
    "projectName" text,
    "dateCreated" timestamp without time zone,
    "createdUserId" uuid
);


ALTER TABLE public.finance_export OWNER TO postgres;

--
-- Name: finance_export_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.finance_export_detail (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "entryDate" date NOT NULL,
    description text,
    type text NOT NULL,
    resource text NOT NULL,
    "user" uuid NOT NULL,
    hours double precision NOT NULL,
    rate double precision NOT NULL,
    amount double precision NOT NULL,
    "dateCreated" timestamp without time zone,
    "financeExportId" uuid
);


ALTER TABLE public.finance_export_detail OWNER TO postgres;

--
-- Name: ministry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ministry (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "ministryName" text,
    is_archived boolean
);


ALTER TABLE public.ministry OWNER TO postgres;

--
-- Name: mou; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mou (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.mou OWNER TO postgres;

--
-- Name: mou_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mou_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mou_id_seq OWNER TO postgres;

--
-- Name: mou_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mou_id_seq OWNED BY public.mou.id;


--
-- Name: procurement_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procurement_log (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "riskOwner" text,
    "descriptionOfIssue" text,
    "logType" text,
    "notificationMethod" text,
    "phaseImpactName" text,
    "projectId" text,
    "clientDecision" text,
    "dateToClient" timestamp without time zone,
    "followUpDate" timestamp without time zone,
    "isResolved" boolean,
    "userId" text
);


ALTER TABLE public.procurement_log OWNER TO postgres;

--
-- Name: project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "projectName" text NOT NULL,
    "commodityCode" text,
    "dueDate" date,
    "completionDate" date,
    "contractValue" double precision,
    "mouAmount" double precision,
    "leadUserId" uuid,
    "backupUserId" uuid,
    description text,
    "dateCreated" timestamp without time zone,
    "dateModified" timestamp without time zone,
    "createdUserId" uuid,
    "modifiedUserId" uuid,
    is_archived boolean,
    "isReprocurement" boolean,
    "isMinistry" boolean,
    "dateOfReprocurement" date,
    "previousContractBackground" text,
    "projectFailImpact" text,
    "projectSuccess" text,
    "teamWideProject" boolean,
    "otherProjectSectorName" text,
    "clientId" uuid,
    "projectSectorId" uuid,
    "mouId" integer
);


ALTER TABLE public.project OWNER TO postgres;

--
-- Name: project_contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_contacts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "projectId" uuid,
    "contactId" uuid
);


ALTER TABLE public.project_contacts OWNER TO postgres;

--
-- Name: project_intake; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_intake (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "projectName" text NOT NULL,
    "commodityCode" text,
    "estimatedCompletionDate" date,
    "estimatedContractValue" double precision,
    "mouAmount" double precision,
    description text,
    status text,
    "projectId" uuid,
    "createdUserId" uuid,
    "approverUserId" uuid,
    "riskScore" double precision,
    "psbRiskScore" double precision,
    "IntakeriskScore" double precision,
    "isSPOEngagement" boolean,
    "intakeRiskLevel" integer,
    "dateCreated" timestamp without time zone,
    "dateModified" timestamp without time zone,
    "isReprocurement" boolean,
    "isMinistry" boolean,
    "dateOfReprocurement" date,
    "serviceId" uuid,
    "categoryId" uuid,
    "previousContractBackground" text,
    "projectFailImpact" text,
    "projectSuccess" text,
    "otherProjectSectorName" text,
    "clientId" uuid,
    "projectSectorId" uuid,
    "mouId" integer
);


ALTER TABLE public.project_intake OWNER TO postgres;

--
-- Name: project_intake_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_intake_category (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "projectIntakeCategoryName" text NOT NULL
);


ALTER TABLE public.project_intake_category OWNER TO postgres;

--
-- Name: project_intake_contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_intake_contacts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "projectIntakeId" uuid,
    "contactId" uuid
);


ALTER TABLE public.project_intake_contacts OWNER TO postgres;

--
-- Name: project_intake_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_intake_services (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "ProjectIntakeServiceName" text NOT NULL
);


ALTER TABLE public.project_intake_services OWNER TO postgres;

--
-- Name: project_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_note (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    note text,
    "projectId" text,
    "userId" uuid,
    "parentId" text,
    "noteTime" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.project_note OWNER TO postgres;

--
-- Name: project_rfx; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_rfx (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "rfxName" text,
    "rfxOverview" text,
    "clientResponsibilities" text,
    "psdResponsibilities" text,
    "dateCreated" timestamp without time zone,
    "dateModified" timestamp without time zone,
    "projectId" uuid,
    "rfxTypeId" uuid,
    "rfxPhaseId" uuid
);


ALTER TABLE public.project_rfx OWNER TO postgres;

--
-- Name: project_risk_analysis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_risk_analysis (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    score integer NOT NULL,
    "dateCreated" timestamp without time zone,
    "dateModified" timestamp without time zone,
    "questionId" uuid,
    "answerId" uuid,
    "intakeId" uuid
);


ALTER TABLE public.project_risk_analysis OWNER TO postgres;

--
-- Name: project_sector; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_sector (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "projectSectorName" text NOT NULL
);


ALTER TABLE public.project_sector OWNER TO postgres;

--
-- Name: rfx_phase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rfx_phase (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "rfxPhaseName" text
);


ALTER TABLE public.rfx_phase OWNER TO postgres;

--
-- Name: rfx_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rfx_type (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "rfxTypeName" text
);


ALTER TABLE public.rfx_type OWNER TO postgres;

--
-- Name: risk_answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.risk_answers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    answer text NOT NULL,
    score integer NOT NULL,
    order_id integer NOT NULL,
    "questionId" uuid
);


ALTER TABLE public.risk_answers OWNER TO postgres;

--
-- Name: risk_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.risk_questions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    question text NOT NULL,
    category integer,
    "riskLevel" integer,
    "questionNo" integer NOT NULL,
    "is_PSB" boolean NOT NULL,
    "isStrategicContact" boolean
);


ALTER TABLE public.risk_questions OWNER TO postgres;

--
-- Name: timesheet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.timesheet (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "startDate" date,
    "endDate" date,
    "userId" uuid,
    "dateCreated" timestamp without time zone,
    "dateModified" timestamp without time zone,
    "createdUserId" uuid,
    "modifiedUserId" uuid,
    "hoursAccured" double precision,
    "batchEntryComments" text,
    "projectRfxId" uuid,
    "projectId" uuid,
    "mouId" integer
);


ALTER TABLE public.timesheet OWNER TO postgres;

--
-- Name: timesheet_entry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.timesheet_entry (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "hoursBillable" double precision,
    "commentsBillable" text,
    "hoursUnBillable" double precision,
    "commentsUnBillable" text,
    "expenseCategory" text,
    "expenseAmount" double precision,
    "expenseComment" text,
    "revenueAmount" double precision,
    "revenueComment" text,
    "entryDate" date,
    "dateCreated" timestamp without time zone,
    "dateModified" timestamp without time zone,
    "timesheetId" uuid
);


ALTER TABLE public.timesheet_entry OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "referenceId" text NOT NULL,
    role text,
    "contactId" uuid
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: mou id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mou ALTER COLUMN id SET DEFAULT nextval('public.mou_id_seq'::regclass);


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (id, "clientNo", "responsibilityCenter", "serviceCenter", stob, "projectCode", "orgDivision", email, "addressLine1", "addressLine2", city, province, country, "postalCode", "dateCreated", "dateModified", "isNonMinistry", "nonMinistryName", "ministryId") FROM stdin;
7d78cd6c-d7e1-45ac-b987-d98ac879c9e9	112	32m06	25004	8585	3200000	WDS		.		.			.	2020-04-22 16:57:57.442	2020-04-22 16:57:57.442	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
67c8fc33-db70-4d84-a971-9476d35ce67b	128	7124B	30146	6001	7100000	IM/IT Investment Governance and Business Strategy		PO Box 9364 Stn Prov Govt		Victoria			V8W9M3	2020-04-22 17:19:28.156	2020-04-22 17:27:30.503	f	\N	2d1d2bef-f635-4e6c-98ae-ad643066b867
bd036bdb-8c83-45bd-979a-13763c5d592b	067	32p01	35102	3104	3200000	Asset Investment Recovery		.		.			.	2020-04-22 17:07:58.242	2020-04-22 18:13:08.875	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
9c539e7c-de5a-49eb-92e7-c28b8c9838ff	112	32683	20052	6101	3200000	Workplace Technology Solutions		4000 Seymour Place 		Victoria 			V8X 4S7	2020-04-22 18:28:30.526	2020-04-22 19:10:12.457	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
1f71980e-7616-4412-a11b-1347ce43f37f	111	11111	11111	1111	1111111	TI Corp		Suite 1750 – 401 West Georgia 		Vancouver  			V6B 5A1	2020-04-22 17:20:34.531	2020-04-22 19:19:05.947	f	\N	6cd580b7-6d9a-492b-96b3-43a0cffd1e5a
90c9c475-cf6d-429f-a8a5-7da8e3b58db1	105	15163	10740	6912	1500000	BC Sheriffs Service		6th Floor, 850 Burdett Avenue		Victoria			V8W 9J7	2020-04-22 18:22:19.532	2020-04-22 20:23:44.265	f	\N	a068619a-3cde-4530-ba60-c76ebf105ee4
26d63cf2-b2f4-41ea-810d-64e67fc969ce	128	71602	30660	6300	7100000	Wildlife and Habitat		.		Victoria			.	2020-04-22 20:41:07.765	2020-04-22 20:41:07.765	f	\N	9c7bfdf2-abea-4874-af40-4a6c30d3f38e
2f0f69cc-06cd-448f-b325-c0f63edbb856	067	32p01	35018	6101	3200000	DCV		724 Vanalman Ave		Victoria			V8Z 3B5	2020-04-22 21:16:30.587	2020-04-22 21:19:35.77	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
e217c260-02cc-4ffc-aedd-9257c055519e	048	29008	30533	6001	2900000	Climate Action Secretariate		.		.			.	2020-04-22 21:27:41.233	2020-04-22 21:35:08.641	f	\N	2d1d2bef-f635-4e6c-98ae-ad643066b867
fd54eb6c-3aaa-47be-9c65-678a8c6a3aa8	067	32p01	20434	6501	3200000	Protocol		.		.			.	2020-04-22 21:47:22.919	2020-04-22 21:49:10.163	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
441d079e-79a2-4bee-9bed-5599631761d1	067	32p01	35102	6101	3200000	Asset investment recovery		.		.			.	2020-04-22 21:54:03.55	2020-04-22 21:55:22.803	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
a14b3e69-8422-4069-a20f-84b2db82a7f5	067	32p01	35046	6101	3200000	BC Mail Plus		1150 McKenzie Ave		Victoria			v8W 9V7	2020-04-22 21:59:58.354	2020-04-22 22:01:06.461	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
5a9c55de-0566-41ba-b28f-eacabe351135	068	2941r	47234	6071	2913203	Environmental Sustainability & Strategy Policy Div		PO Box 9335 Stn Pov Govt		Victoria			V8w9m1	2020-04-22 22:14:14.503	2020-04-23 18:57:41.699	f	\N	bbb34129-f7c2-4b17-ab63-218f920fbd04
6f5521be-ca24-4c99-a308-da66eee67993	048	296B2	31200	6910	2950442	BC Parks		Ministry of Environment and Climate Change Strategy	BC Parks 525 Superior St, Victoria, BC	Victoria			V8V 1T7 	2020-04-23 19:18:19.021	2020-04-23 19:18:19.021	f	\N	2d1d2bef-f635-4e6c-98ae-ad643066b867
ebff8e7a-322e-4879-983c-88cba8b50e5e	128	71479	42000	6001	71WBW00	BC Wildfire Services		Jutland 		Victoria			V2N 6R7	2020-04-23 01:29:49.314	2020-04-23 19:36:49.385	f	\N	9c7bfdf2-abea-4874-af40-4a6c30d3f38e
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact (id, "contactType", "fullName", "orgName", "orgPosition", email, "phoneNumber", "addressLine1", "addressLine2", city, province, country, "postalCode", "roleName", "dateCreated", "dateModified", "hourlyRate") FROM stdin;
8707dc87-dc37-499c-8b45-95f9ced0697e	user	Adam Coard	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 21:19:56.237	2020-04-21 21:19:56.237	\N
3d968515-bdbc-457f-bfc9-a350ff99527b	clientlead	Varous	WDS	.	jerry.gauthier@gov.bc.ca	2501111111							\N	2020-04-22 16:57:58.616	2020-04-22 16:57:58.616	\N
846bfd99-259e-4f09-b97f-861f413d134a	clientsponsor	Sunny Daliwal	WDS	ADM	jerry.gauthier@gov.bc.ca	2501111111							\N	2020-04-22 16:57:58.631	2020-04-22 16:57:58.631	\N
c42a2098-4559-4e9a-867c-4d865d961610	clientfinance												\N	2020-04-22 16:57:58.634	2020-04-22 16:57:58.634	\N
ea526c93-bfe2-4b46-b337-1d10bb59a4a9	clientlead	Jacoba Corrigal	Information, Innovation and Technology Division	Senior Procurement/Contract Specialist	jacoba.corrigal@gov.bc.ca	7786983112							\N	2020-04-22 17:19:28.215	2020-04-22 17:19:28.215	\N
ff35de9f-9b3b-4c4f-8bf8-1d72a550485f	clientsponsor	Jacoba Corrigal	Information, Innovation and Technology Division	Senior Procurement/Contract Specialist	jacoba.corrigal@gov.bc.ca	7786983112							\N	2020-04-22 17:19:28.222	2020-04-22 17:19:28.222	\N
69e14066-dfe5-48d5-93c7-243fba7b85b3	clientfinance												\N	2020-04-22 17:19:28.291	2020-04-22 17:19:28.291	\N
81ca2106-9562-49f3-9224-99c4dd54e827	clientlead	Geoff Rice	Finance And Management Services Department	Project Manager	Geoff.Rice@gov.bc.ca	6132030840							\N	2020-04-22 17:20:34.565	2020-04-22 17:20:34.565	\N
077dd07e-5d01-4268-973f-94ed86a37121	clientsponsor	Dave Stewart	Finance And Management Services Department	CFO	dave.stewart@ticorp.ca	7789745414							\N	2020-04-22 17:20:34.571	2020-04-22 17:20:34.571	\N
23c5ca18-cee6-4b87-bb4a-66460aee5ca4	clientfinance												\N	2020-04-22 17:20:34.576	2020-04-22 17:20:34.576	\N
a3a9928e-561d-4b71-9744-398d98692366	clientlead	Melissa Strain	BC Sheriffs Service	Manager	Melissa.Strain@gov.bc.ca	2505896861							\N	2020-04-22 18:22:19.709	2020-04-22 18:22:19.709	\N
76849d01-3fee-4204-88df-3d026c3de8c8	clientsponsor	Ross McKenna	BC Sheriffs Service	Director of Provincial Programs	Ross.McKenna@gov.bc.ca	6046605583							\N	2020-04-22 18:22:19.723	2020-04-22 18:22:19.723	\N
53393e30-7a21-40d8-89c3-91f1c65aab6f	clientfinance												\N	2020-04-22 18:22:19.728	2020-04-22 18:22:19.728	\N
e45fae38-c5de-44b9-9240-7323d310c1f0	user	Arlin Friesen	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 17:10:39.019	2020-04-22 18:23:39.222	120
176e34c7-281b-4212-883c-840bfa02def5	user	Bryn Johns	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 16:58:52.68	2020-04-22 18:23:42.678	100
23b536a6-d4af-4f5f-89e2-8a32fd56df2f	user	Gajanan Pujar	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 21:19:16.076	2020-04-22 18:23:45.125	100
f3ae9b70-5a2c-49c5-bcb2-44283a5aeca3	user	Gord Rogers	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 17:59:57.822	2020-04-22 18:23:47.34	100
b344cac4-c500-4f3e-9b26-51a49deba756	user	James Ragan	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 16:13:28.353	2020-04-22 18:23:49.658	100
09842e3d-ecd7-4735-95cd-507804f9bd37	user	Jason George	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 16:11:51.57	2020-04-22 18:23:51.732	120
52a3c168-0668-4032-9ec9-026ec0c466cb	user	Kathy Jack	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 22:20:37.986	2020-04-22 18:23:53.921	100
4643b61c-c9cc-4e42-b341-caa8eb4f5ba5	user	Michael Mulder	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 18:09:37.761	2020-04-22 18:23:56.219	120
ea6879e9-0a31-4a8b-bea3-405490ea2018	user	Michelle McKinnon	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 15:58:30.873	2020-04-22 18:23:58.122	120
1f2d62d4-10ec-4d69-a99b-f380652e7340	user	Ruth-Ann Webster	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 16:04:03.74	2020-04-22 18:24:00.221	100
f584063c-c046-43b6-a13f-ed601e10c079	user	Sandeep Sahota	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 18:04:55.659	2020-04-22 18:24:02.118	120
6ab675ef-1a35-47af-876b-66930b60ea44	user	Tracy Harris	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 21:19:50.094	2020-04-22 18:24:08.778	120
a344759c-34c4-4f86-a866-ebdbda1542c8	user	Zachary Woodward	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 21:19:00.731	2020-04-22 18:24:10.746	120
d6cfc8af-0a67-4095-8d99-057228d16f1e	clientlead	Stu Hackett	Ministry of Citizens' Services	Executive Director	Stuart.Hackett@gov.bc.ca	2505142779							\N	2020-04-22 18:28:30.621	2020-04-22 18:28:30.621	\N
46afe217-22b8-48b6-8142-508512f80018	clientsponsor	Bobbi Sadler	Ministry of Citizens' Services	Assistant Deputy Minister	bobbi.sadler@gov.bc.ca	2508865062							\N	2020-04-22 18:28:30.634	2020-04-22 18:28:30.634	\N
b6808d7a-97b6-4ec4-b3f9-16555d46f1ed	clientfinance												\N	2020-04-22 18:28:30.64	2020-04-22 18:28:30.64	\N
bab69975-a938-4d52-97d2-6c378d346b9e	clientlead	Mark McKamey	FLNROD - Habitat and Wildlife Branch	Senior Policy Analyst	Mark.McKamey@gov.bc.ca	7789742742							\N	2020-04-22 20:41:07.793	2020-04-22 20:41:07.793	\N
0bf18159-89ab-4593-a5c2-defbe6dc51ee	clientsponsor	.	FLNROD - Habitat and Wildlife Branch	.	Mark.McKamey@gov.bc.ca	7789742742							\N	2020-04-22 20:41:07.799	2020-04-22 20:41:07.799	\N
015ab727-e4f2-4402-aaf8-cbc30827a949	clientfinance												\N	2020-04-22 20:41:07.854	2020-04-22 20:41:07.854	\N
8e76b806-ced5-474e-a51b-239cd43a2cfe	clientlead	Darryl Hansen	AIR	Operations Manger	Darryl.hansen@gov.bc.ca	7786989912							\N	2020-04-22 17:07:58.263	2020-04-22 20:56:01.379	\N
a85184f1-c079-40e3-b3b1-d0be77abf233	clientsponsor	Greg Lamb	AIR, DCV	Assistant Director	greg.lamb@gov.bc.ca	7786989851							\N	2020-04-22 17:07:58.27	2020-04-22 20:56:01.393	\N
b793367b-c15e-4376-8f3b-4a34605e7400	clientfinance												\N	2020-04-22 17:07:58.275	2020-04-22 20:56:01.404	\N
1fec9b37-843d-4fe0-ab25-86728a0a0fae	clientlead	Cory Bate	DCV	Operations Manager	cory.bate@gov.bc.ca	2509524462							\N	2020-04-22 21:16:30.929	2020-04-22 21:16:30.929	\N
b9f14763-733a-491d-8764-88475d17ecbc	clientsponsor	.	.	.	no.one@gov.bc.ca	2501111111							\N	2020-04-22 21:16:30.963	2020-04-22 21:16:30.963	\N
634418ee-7e13-474b-b702-88a309dc1103	clientfinance												\N	2020-04-22 21:16:30.975	2020-04-22 21:16:30.975	\N
0ff81989-e9d2-4a1d-baee-b6d10d22ae39	clientlead	Kim Tiffin	.	.	kim.tiffin@gov.bc.ca	7789743919							\N	2020-04-22 21:27:41.253	2020-04-22 21:27:41.253	\N
b8b46117-65cb-4591-9604-495422427320	clientsponsor	Kim Tiffin	CAS	manager	kim.tiffin@gov.bc.ca	7789743919							\N	2020-04-22 21:27:41.26	2020-04-22 21:27:41.26	\N
71d1d3d1-24a0-434f-ba55-06eab2a76b66	clientfinance												\N	2020-04-22 21:27:41.264	2020-04-22 21:27:41.264	\N
0cdc5dad-cffd-4663-9903-00590eaa71be	clientlead	Jacquie Driesen	Citizens Services	Administrator	jacquie.driesen@gov.bc.ca	2503656183							\N	2020-04-22 21:47:22.935	2020-04-22 21:47:22.935	\N
499b37a4-b05a-4d6d-8161-c58266a25155	clientsponsor	Jacquie Driesen	Citizens' services	Administrator	jacquie.driesen@gov.bc.ca	2503656183							\N	2020-04-22 21:47:22.94	2020-04-22 21:47:22.94	\N
9cfc5a3c-919d-4307-b9e3-54f0f850bdf8	clientfinance												\N	2020-04-22 21:47:22.943	2020-04-22 21:47:22.943	\N
0e7cb963-26b7-4d32-a9c5-054b2f0aff68	clientlead	Darryl Hansen	.	.	darryl.hansen@gov.bc.ca	7786989912							\N	2020-04-22 21:54:03.574	2020-04-22 21:54:03.574	\N
59c4d2e0-99a3-462e-afbf-6b815fc18500	clientsponsor	Darryl Hansen	.	.	darryl.hansen@gov.bc.ca	2501111111							\N	2020-04-22 21:54:03.583	2020-04-22 21:54:03.583	\N
a3bbc881-2635-413b-b393-87c830f0c11c	clientfinance												\N	2020-04-22 21:54:03.587	2020-04-22 21:54:03.587	\N
f36adf1c-6dc1-4769-9a46-19dd0a6b75cf	clientlead	Sean Johnson	.	.	sean.johnson@gov.bc.ca	2509525130							\N	2020-04-22 21:59:58.375	2020-04-22 21:59:58.375	\N
b8b2bf6f-c50c-4774-bd4d-2045d1a2bc64	clientsponsor	Sean Johnson	.	.	sean.johnson@gov.bc.ca	2509525130							\N	2020-04-22 21:59:58.389	2020-04-22 21:59:58.389	\N
72ebbd26-e4a2-495e-abda-5413f2c92e83	clientfinance												\N	2020-04-22 21:59:58.393	2020-04-22 21:59:58.393	\N
d95bc8be-deb9-4bbe-a12a-1eb964497872	clientlead	Joyce Austin	.	.	joyce.austin@gov.bc.ca	2501111111							\N	2020-04-22 22:14:14.525	2020-04-22 22:14:14.525	\N
467b9a1f-6e80-4390-82bc-b7ab1a5f460a	clientsponsor	Joyce Austin	.	.	joyce.austin@gov.bc.ca	2501111111							\N	2020-04-22 22:14:14.531	2020-04-22 22:14:14.531	\N
008d9c46-9f4a-4582-91f0-6c08cbf2459b	clientfinance												\N	2020-04-22 22:14:14.535	2020-04-22 22:14:14.535	\N
13ed96d7-f082-4745-81e9-31b4d895c0bf	clientlead	Neil Arreza	BCWS	Procurement Lead	neil.arreza@gov.bc.ca	7789745716							\N	2020-04-23 01:29:49.347	2020-04-23 01:29:49.347	\N
4c3d402f-f970-4e21-8120-e7411ae8d9d5	clientsponsor	Diane Ross	BCWS	Director, Finance	diane.ross@gov.bc.ca	7789745725							\N	2020-04-23 01:29:49.352	2020-04-23 01:29:49.352	\N
5e6d47db-ee28-4416-9283-f1d2ab641747	clientfinance	Diane Ross											\N	2020-04-23 01:29:49.356	2020-04-23 01:29:49.356	\N
0517039e-6ab3-4343-838f-6d5d9f272ff6	user	Prince Varghese	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-23 16:30:30.816	2020-04-23 16:30:30.816	\N
d9276c4d-48bf-4d5d-84f4-6b46fd267e9e	user	Collin Lord	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 23:01:15.068	2020-04-23 18:30:23.743	100
d0d7d1c5-e037-403d-837c-13c13a07ecfa	user	Jerry Gauthier	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-23 18:41:38.519	2020-04-23 18:41:38.519	\N
23e3cd97-345a-40bf-b698-02fce7b0c1e5	clientlead	Elyse Guzek	BC Parks Regional Operations	Student Ranger Program Coordinator	Elyse.Guzek@gov.bc.ca	7786981599							\N	2020-04-23 19:18:19.087	2020-04-23 19:18:19.087	\N
73d93e32-6d7e-4552-b4a1-6a8225a20a69	clientsponsor	Bob Austad	BC Parks and Conservation Officer Service Division	Executive Director, Regional Operations Branch, BC Parks	Bob.Austad@gov.bc.ca	7786984281							\N	2020-04-23 19:18:19.102	2020-04-23 19:18:19.102	\N
99a23a1b-4a2b-4ade-a5ae-fec518edb751	clientfinance												\N	2020-04-23 19:18:19.131	2020-04-23 19:18:19.131	\N
88368389-6c97-49d4-a97b-7b24dcbb8c38	user	Kiah Sethi	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-23 20:28:37.741	2020-04-23 20:28:37.741	\N
\.


--
-- Data for Name: finance_export; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.finance_export (id, "documentNo", "lineDesc", sap, reference, contact, organisation, fees, expenses, "totalAmount", "clientNo", "responsibilityCenter", "serviceCenter", stob, "projectCode", "projectId", "projectName", "dateCreated", "createdUserId") FROM stdin;
\.


--
-- Data for Name: finance_export_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.finance_export_detail (id, "entryDate", description, type, resource, "user", hours, rate, amount, "dateCreated", "financeExportId") FROM stdin;
\.


--
-- Data for Name: ministry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ministry (id, "ministryName", is_archived) FROM stdin;
13f75c7d-5b2b-4078-ab7a-41a3a7953c86	Education	\N
bbb34129-f7c2-4b17-ab63-218f920fbd04	Energy, Mines & Petroleum Resources	\N
2d1d2bef-f635-4e6c-98ae-ad643066b867	Environment & Climate Change Strategy	\N
4ec3bf77-1da6-4b86-b830-7e590e9b8924	Finance	\N
9c7bfdf2-abea-4874-af40-4a6c30d3f38e	Forests, Lands, Natural Resource Operations & Rural Development	\N
126d6a38-c9ba-4220-bb91-6dbf54bdce2a	Health	\N
53ab42dc-2087-4a24-84f0-6c452afe66d1	Indigenous Relations & Reconciliation	\N
93e74355-96fc-4a12-bcd8-fbf0e2190461	Labour	\N
f8183351-6b12-489a-bc47-ca65b892ae0b	Mental Health & Addictions	\N
3244ce1e-ea16-4c29-b417-0100a8bb5098	Municipal Affairs & Housing	\N
0b983c7e-cce9-442f-bd3a-8e8e3afb12fb	Public Safety & Solicitor General & Emergency B.C.	\N
d4975e8a-d359-4e29-9b4a-8b0211dc5e7d	Social Development & Poverty Reduction	\N
da9652e3-16c5-4df4-ae85-aabc8a123e69	Tourism, Arts & Culture	\N
3c626277-3298-4bed-ae08-ceca3039362f	Citizens' Services	\N
a068619a-3cde-4530-ba60-c76ebf105ee4	Attorney General	\N
785d6467-90f2-4e07-a102-59ced3d9fd51	Advanced Education, Skills & Training	\N
2e24504f-04f3-4389-afd9-a3f3d76877a6	Agriculture	\N
775eff79-8080-4fce-bb9f-6fd08f6e0fa4	Children & Family Development	\N
57fa770b-8b65-40fd-8e99-9132af9440b0	Jobs, Trade & Technology	t
57bd2392-1fb5-44d7-ae94-7bf150d6be74	Jobs, Economic Development & Competitiveness	\N
6cd580b7-6d9a-492b-96b3-43a0cffd1e5a	Transportation & Infrastructure	\N
\.


--
-- Data for Name: mou; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mou (id, name) FROM stdin;
1	GR-211-1
2	AF201-1 TI Corp SMS
3	CL-206
4	AF201-1 TI Corp SMS
5	AF201-1 TI Corp SMS
6	MM2018WTSPP
7	MM2018WTSPP
8	MM2018WTSPP
9	JRAG-2019
10	GR-208-2
11	GR-209-2
12	GR-212-1
13	GR-213-1
14	GR-214-1
15	JDG-232
16	JDG-232
17	JDG-232
18	JDG-232
19	MMC-BCWS 2019/20
20	MMC-BCWS 2019/20
\.


--
-- Data for Name: procurement_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.procurement_log (id, "riskOwner", "descriptionOfIssue", "logType", "notificationMethod", "phaseImpactName", "projectId", "clientDecision", "dateToClient", "followUpDate", "isResolved", "userId") FROM stdin;
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project (id, "projectName", "commodityCode", "dueDate", "completionDate", "contractValue", "mouAmount", "leadUserId", "backupUserId", description, "dateCreated", "dateModified", "createdUserId", "modifiedUserId", is_archived, "isReprocurement", "isMinistry", "dateOfReprocurement", "previousContractBackground", "projectFailImpact", "projectSuccess", "teamWideProject", "otherProjectSectorName", "clientId", "projectSectorId", "mouId") FROM stdin;
2d2796cc-4950-4811-abf9-cebd2d9d7f01	TI Corp SMS		\N	2020-08-31	450000	15000	3e9a3591-d6b2-4b46-a426-5e0872553673	13669c48-73ee-492e-b1b5-6a168f213d8a		2020-04-22 17:20:49.655	2020-04-22 19:19:05.934	3e9a3591-d6b2-4b46-a426-5e0872553673	13669c48-73ee-492e-b1b5-6a168f213d8a	\N	f	\N	\N	\N	Continue to manage communication via excel spreadsheets\nPotential of missing key communication to stakeholders	Completed SMS that will assist with the communication for the three major TI Corp projects	f	\N	1f71980e-7616-4412-a11b-1347ce43f37f	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	2
3e06c426-422c-4bf0-923f-94e0aed5c43b	Soft Body Armour		\N	2020-08-31	500000	15000	228e25cb-a091-4c40-9c60-751c784d8852	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a		2020-04-22 18:30:28.894	2020-04-22 20:23:44.255	3e9a3591-d6b2-4b46-a426-5e0872553673	228e25cb-a091-4c40-9c60-751c784d8852	\N	t	\N	2020-04-01	There is a contract currently in place with an incumbent supplier. The contract term has ended and BC Sheriff's Service requires a new contract to secure a supply of soft body armor. NOTE: The contract has already expired.	No supply of soft body armor to BC Sheriff's Service employees.	Contracting with a supplier who delivers products in a timely manner with strong service supports. 	f	\N	90c9c475-cf6d-429f-a8a5-7da8e3b58db1	d1636622-a025-4736-969f-8e5536f6512e	9
3401c829-c6f5-4cef-86e6-ad39d8c54aee	Workplace Development Services		\N	2021-12-30	1	0	\N	\N		2020-04-22 16:58:09.523	2020-04-22 21:09:24.055	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	t	f	\N	\N	\N	Services not provided	services are provided	f	\N	7d78cd6c-d7e1-45ac-b987-d98ac879c9e9	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
4c70dd71-1938-4a01-a86b-ced42b12c11e	Procurement and Contracting Advisory Services		\N	2020-12-31	1000000	24882.2999999999993	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N		2020-04-22 17:19:47.549	2020-04-22 17:27:30.496	f6b65221-f597-488b-aaa8-bed90aacfaf8	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	f	\N	\N	\N	Various risks to ongoing and planned procurement of information systems support for several "dirt" ministries.	Timely and sufficient support of ongoing and planned procurements.	f	\N	67c8fc33-db70-4d84-a971-9476d35ce67b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	3
c76b3ba0-bd37-4ff2-b659-67ebb8a768e8	Advisory and Procurement Services		\N	2021-12-30	1	2575.90000000000009	5a86fbb4-7707-43b7-88ce-ad77599652ef	\N		2020-04-22 21:16:50.703	2020-04-22 21:19:35.759	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	services not provided	services are provided	f	\N	2f0f69cc-06cd-448f-b325-c0f63edbb856	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	10
2c933486-0a9b-40de-adc9-eaa9319a16f2	Workplace Technology Services Procurement Project		\N	2022-09-30	300000000	205091	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	228e25cb-a091-4c40-9c60-751c784d8852		2020-04-22 18:30:38.738	2020-04-22 19:10:12.425	3e9a3591-d6b2-4b46-a426-5e0872553673	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	\N	t	\N	2022-09-29	WTSPP is the procurement of device services (computer hardware, deployment & decommissioning, service desk, field services and managed workplace technology services). Current term expires September 30, 2020. Approval obtained, and negotiations underway to extend this term for 24 months plus six months, plus six months (the two 6 month possible extensions are built in to allow for transition).	Ceasing of services and services continuity with risk of another direct award to extend and maintain service. 	Contract(s) are executed and best value is obtained from the marketplace. 	f	\N	9c539e7c-de5a-49eb-92e7-c28b8c9838ff	15b3f630-3c1f-4402-8e08-6591f3d8ba13	8
a0a72451-9577-4ab4-bec9-f1a236243805	AIR Victoria Moving Services		\N	2021-12-30	1	3325	5a86fbb4-7707-43b7-88ce-ad77599652ef	\N		2020-04-22 21:54:10.184	2020-04-22 21:55:22.788	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	Services not provided	services are provided	f	\N	441d079e-79a2-4bee-9bed-5599631761d1	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	13
92e963f3-70a4-4f95-b6e0-b86c062aba6d	Ongoing Contract work		\N	2021-12-30	1	4450	5a86fbb4-7707-43b7-88ce-ad77599652ef	\N		2020-04-22 22:00:06.933	2020-04-22 22:01:06.44	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	services not provided	services are provided	f	\N	a14b3e69-8422-4069-a20f-84b2db82a7f5	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	14
d930683b-68e0-44f5-a31d-398815e32909	AIR Warehousing Services		\N	2021-12-30	1	8000	5a86fbb4-7707-43b7-88ce-ad77599652ef	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-04-22 17:08:04.53	2020-04-22 18:13:08.863	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	Services are not provided	Services are provided	f	\N	bd036bdb-8c83-45bd-979a-13763c5d592b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	1
02c89fe1-3496-46f1-b833-db0fe0d08e12	Soft Body Armour		\N	2020-08-31	500000	0	\N	\N		2020-04-22 18:30:28.894	2020-04-22 18:30:28.894	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	\N	t	\N	2020-04-01	There is a contract currently in place with an incumbent supplier. The contract term has ended and BC Sheriff's Service requires a new contract to secure a supply of soft body armor. NOTE: The contract has already expired.	No supply of soft body armor to BC Sheriff's Service employees.	Contracting with a supplier who delivers products in a timely manner with strong service supports. 	f	\N	90c9c475-cf6d-429f-a8a5-7da8e3b58db1	d1636622-a025-4736-969f-8e5536f6512e	\N
6680eec1-85c6-446c-86ef-677db7908c1a	Renewable Energy Studies		\N	2021-12-30	1	503	5a86fbb4-7707-43b7-88ce-ad77599652ef	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-04-22 21:27:49.046	2020-04-22 21:35:08.628	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	Services not provided	services are provided	f	\N	e217c260-02cc-4ffc-aedd-9257c055519e	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	11
99543d57-26fd-4ba4-8f31-668bab5f7773	Procurement and Contract Advisory		\N	2021-12-30	1	2809	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-04-22 22:14:21.816	2020-04-23 18:57:41.685	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	Services not provided	services are provided	f	\N	5a9c55de-0566-41ba-b28f-eacabe351135	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	18
80f44db4-8489-4144-bd99-25734ee64bae	Picture Framing CSA		\N	2021-12-30	1	3900	5a86fbb4-7707-43b7-88ce-ad77599652ef	\N		2020-04-22 21:47:31.407	2020-04-22 21:49:10.147	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	Services not provided	services are provided	f	\N	fd54eb6c-3aaa-47be-9c65-678a8c6a3aa8	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	12
0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	BCWS 2020 Procurements-Various		\N	2020-04-30	8	5853	b9a782bd-39b5-4697-9a4a-9b62737876e2	c246f349-bb5e-4309-861b-706bc6b232c1		2020-04-23 01:30:15.484	2020-04-23 19:36:49.324	b9a782bd-39b5-4697-9a4a-9b62737876e2	b9a782bd-39b5-4697-9a4a-9b62737876e2	\N	f	\N	\N	\N	don't have contracts in place for 2020 fire season	Contracts in place by April 30, 2020	f	\N	ebff8e7a-322e-4879-983c-88cba8b50e5e	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	19
\.


--
-- Data for Name: project_contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_contacts (id, "projectId", "contactId") FROM stdin;
a90fbcbe-093e-4d97-b38f-f9f08bb7e4bd	3401c829-c6f5-4cef-86e6-ad39d8c54aee	c42a2098-4559-4e9a-867c-4d865d961610
8e8c46ce-b5d9-40d4-8b37-b6119ff817ae	3401c829-c6f5-4cef-86e6-ad39d8c54aee	3d968515-bdbc-457f-bfc9-a350ff99527b
35360271-07e5-42ff-a3ea-6d967ead13c3	d930683b-68e0-44f5-a31d-398815e32909	a85184f1-c079-40e3-b3b1-d0be77abf233
b56ace27-77f9-4f12-8db6-772b9ee4d95b	80f44db4-8489-4144-bd99-25734ee64bae	0cdc5dad-cffd-4663-9903-00590eaa71be
7934a156-f2f4-4ab7-b332-553313ca4dd5	80f44db4-8489-4144-bd99-25734ee64bae	9cfc5a3c-919d-4307-b9e3-54f0f850bdf8
638f936c-4e8d-4df8-95c4-b54e549d10c5	d930683b-68e0-44f5-a31d-398815e32909	b793367b-c15e-4376-8f3b-4a34605e7400
202fc1ac-268e-4b1e-9f9e-25e60d772ccc	80f44db4-8489-4144-bd99-25734ee64bae	499b37a4-b05a-4d6d-8161-c58266a25155
955e6716-ba99-4aaa-946a-bf8824337921	d930683b-68e0-44f5-a31d-398815e32909	8e76b806-ced5-474e-a51b-239cd43a2cfe
79f41721-5e99-47de-a031-07ea475f0bba	a0a72451-9577-4ab4-bec9-f1a236243805	0e7cb963-26b7-4d32-a9c5-054b2f0aff68
4ef70cce-db24-4d37-bba4-a0be1e3ced7f	4c70dd71-1938-4a01-a86b-ced42b12c11e	ff35de9f-9b3b-4c4f-8bf8-1d72a550485f
2f0e212c-b88d-4eb5-88a4-a590ebc9ac61	4c70dd71-1938-4a01-a86b-ced42b12c11e	69e14066-dfe5-48d5-93c7-243fba7b85b3
b39da071-31e3-4bc2-99f5-6f753614d0c9	a0a72451-9577-4ab4-bec9-f1a236243805	a3bbc881-2635-413b-b393-87c830f0c11c
bf6cbfb2-07a0-4fd3-acb6-dff7333a24dc	4c70dd71-1938-4a01-a86b-ced42b12c11e	ea526c93-bfe2-4b46-b337-1d10bb59a4a9
a3b1fa2f-b070-48bf-9705-4de82b9bca5c	a0a72451-9577-4ab4-bec9-f1a236243805	59c4d2e0-99a3-462e-afbf-6b815fc18500
5efa288f-f963-47d6-a4c9-3269ddc1f616	2d2796cc-4950-4811-abf9-cebd2d9d7f01	81ca2106-9562-49f3-9224-99c4dd54e827
ba219d8e-a127-4bd4-91fb-60ce7ac543ba	92e963f3-70a4-4f95-b6e0-b86c062aba6d	f36adf1c-6dc1-4769-9a46-19dd0a6b75cf
f32c17aa-dd86-4d3b-bb1e-1e9c3f627dd2	92e963f3-70a4-4f95-b6e0-b86c062aba6d	b8b2bf6f-c50c-4774-bd4d-2045d1a2bc64
fe514f6e-2007-4bf3-bfc0-c6adf8d4dd4e	2d2796cc-4950-4811-abf9-cebd2d9d7f01	23c5ca18-cee6-4b87-bb4a-66460aee5ca4
bf8e0c38-7ec4-4114-a623-b54cafbe37dc	92e963f3-70a4-4f95-b6e0-b86c062aba6d	72ebbd26-e4a2-495e-abda-5413f2c92e83
f9a6a3bd-0d10-47bd-8c42-5578e434998e	2d2796cc-4950-4811-abf9-cebd2d9d7f01	077dd07e-5d01-4268-973f-94ed86a37121
3f1b85f5-0fb6-4e02-9817-f61913c51711	99543d57-26fd-4ba4-8f31-668bab5f7773	467b9a1f-6e80-4390-82bc-b7ab1a5f460a
f2f27c33-ee17-48a6-8c75-8899882bd81b	99543d57-26fd-4ba4-8f31-668bab5f7773	008d9c46-9f4a-4582-91f0-6c08cbf2459b
ac94a811-4722-46b4-b14f-135b268884ee	3e06c426-422c-4bf0-923f-94e0aed5c43b	a3a9928e-561d-4b71-9744-398d98692366
5bd8e1f7-e717-41e5-acee-1952160a3031	99543d57-26fd-4ba4-8f31-668bab5f7773	d95bc8be-deb9-4bbe-a12a-1eb964497872
1206d59a-b8db-4196-b671-825be5d563a7	02c89fe1-3496-46f1-b833-db0fe0d08e12	a3a9928e-561d-4b71-9744-398d98692366
973ab06b-c03b-4f51-8eb9-1437916e5375	2c933486-0a9b-40de-adc9-eaa9319a16f2	46afe217-22b8-48b6-8142-508512f80018
284c12c9-a40b-44c4-9d77-3ca0841d0db4	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	4c3d402f-f970-4e21-8120-e7411ae8d9d5
76e335cf-fd17-4b7a-98fb-1d4dcac60fc1	02c89fe1-3496-46f1-b833-db0fe0d08e12	76849d01-3fee-4204-88df-3d026c3de8c8
9d4fc99f-cb8f-4d50-a154-4d16ab6ba1e5	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	13ed96d7-f082-4745-81e9-31b4d895c0bf
8f68af5c-dea9-49f0-97a4-917323d3ccb8	02c89fe1-3496-46f1-b833-db0fe0d08e12	53393e30-7a21-40d8-89c3-91f1c65aab6f
99a5f613-bfcb-4ae6-8e57-3bd2fe967a51	2c933486-0a9b-40de-adc9-eaa9319a16f2	d6cfc8af-0a67-4095-8d99-057228d16f1e
88661065-792e-4cae-ba27-1e17805cdd59	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	5e6d47db-ee28-4416-9283-f1d2ab641747
373e0387-a2af-480e-8d61-5a796b424186	3e06c426-422c-4bf0-923f-94e0aed5c43b	53393e30-7a21-40d8-89c3-91f1c65aab6f
670ebeaf-efa7-4ea3-afd1-435d133c120a	3e06c426-422c-4bf0-923f-94e0aed5c43b	76849d01-3fee-4204-88df-3d026c3de8c8
4639b96f-b75d-424b-88f0-2690ef68038f	2c933486-0a9b-40de-adc9-eaa9319a16f2	b6808d7a-97b6-4ec4-b3f9-16555d46f1ed
948869a4-b29e-4681-a1da-929056eaa195	c76b3ba0-bd37-4ff2-b659-67ebb8a768e8	1fec9b37-843d-4fe0-ab25-86728a0a0fae
8e95c1f0-45cd-4f39-8ed8-5105ec36dd8d	c76b3ba0-bd37-4ff2-b659-67ebb8a768e8	b9f14763-733a-491d-8764-88475d17ecbc
3b81e84a-2639-467b-962e-6d972aa82f8b	c76b3ba0-bd37-4ff2-b659-67ebb8a768e8	634418ee-7e13-474b-b702-88a309dc1103
16e8781e-d107-49ea-94f0-1dea719ca7ed	6680eec1-85c6-446c-86ef-677db7908c1a	b8b46117-65cb-4591-9604-495422427320
6a910a4f-b88c-494c-9aba-faecbed7dc7a	6680eec1-85c6-446c-86ef-677db7908c1a	0ff81989-e9d2-4a1d-baee-b6d10d22ae39
339844d4-72ae-46b9-8994-bb22b0f12547	6680eec1-85c6-446c-86ef-677db7908c1a	71d1d3d1-24a0-434f-ba55-06eab2a76b66
0ccc0c0b-f8bc-4357-aeeb-9c3d7efd27a9	3401c829-c6f5-4cef-86e6-ad39d8c54aee	846bfd99-259e-4f09-b97f-861f413d134a
\.


--
-- Data for Name: project_intake; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_intake (id, "projectName", "commodityCode", "estimatedCompletionDate", "estimatedContractValue", "mouAmount", description, status, "projectId", "createdUserId", "approverUserId", "riskScore", "psbRiskScore", "IntakeriskScore", "isSPOEngagement", "intakeRiskLevel", "dateCreated", "dateModified", "isReprocurement", "isMinistry", "dateOfReprocurement", "serviceId", "categoryId", "previousContractBackground", "projectFailImpact", "projectSuccess", "otherProjectSectorName", "clientId", "projectSectorId", "mouId") FROM stdin;
f691ca03-7a57-4cd4-98a1-e6385b293322	Fish, Wildlife and Ecosystems Project Management and Implementation		2020-08-31	20000000	0		submitted	\N	228e25cb-a091-4c40-9c60-751c784d8852	\N	51.8500000000000014	0	51.8500000000000014	f	1	2020-04-22 20:41:07.782	2020-04-22 20:41:07.782	t	\N	2020-06-30	\N	\N	Expires June 30, 2020	Critical environmental services not being completed	A service provider with strong project management and implementation practices	\N	26d63cf2-b2f4-41ea-810d-64e67fc969ce	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
291ac6ba-64d7-491b-b838-c2441ca199c1	AIR Warehousing Services		2021-12-30	1	0		approved	d930683b-68e0-44f5-a31d-398815e32909	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-04-22 17:07:58.254	2020-04-22 17:08:04.554	f	\N	\N	\N	\N	\N	Services are not provided	Services are provided	\N	bd036bdb-8c83-45bd-979a-13763c5d592b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
91786f9c-1ec0-48f5-8155-1c71c8c0c996	Procurement and Contracting Advisory Services		2020-12-31	1000000	0		approved	4c70dd71-1938-4a01-a86b-ced42b12c11e	f6b65221-f597-488b-aaa8-bed90aacfaf8	f6b65221-f597-488b-aaa8-bed90aacfaf8	42.5900000000000034	0	42.5900000000000034	f	2	2020-04-22 17:19:28.203	2020-04-22 17:19:47.569	f	\N	\N	\N	\N	\N	Various risks to ongoing and planned procurement of information systems support for several "dirt" ministries.	Timely and sufficient support of ongoing and planned procurements.	\N	67c8fc33-db70-4d84-a971-9476d35ce67b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
93430175-358e-4a38-8daf-e22e4f2dedec	TI Corp SMS		2020-08-31	450000	0		approved	2d2796cc-4950-4811-abf9-cebd2d9d7f01	3e9a3591-d6b2-4b46-a426-5e0872553673	3e9a3591-d6b2-4b46-a426-5e0872553673	35.509999999999998	26.4200000000000017	44.4399999999999977	f	2	2020-04-22 17:20:34.54	2020-04-22 17:20:49.671	f	\N	\N	\N	\N	\N	Continue to manage communication via excel spreadsheets\nPotential of missing key communication to stakeholders	Completed SMS that will assist with the communication for the three major TI Corp projects	\N	1f71980e-7616-4412-a11b-1347ce43f37f	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
f7f40c7b-a42e-43aa-a14d-305d5b8338e0	Advisory and Procurement Services		2021-12-30	1	0		approved	c76b3ba0-bd37-4ff2-b659-67ebb8a768e8	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-04-22 21:16:30.69	2020-04-22 21:16:52.027	f	\N	\N	\N	\N	\N	services not provided	services are provided	\N	2f0f69cc-06cd-448f-b325-c0f63edbb856	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
b11d8270-b2df-417c-aa7d-9bb8321433cd	Soft Body Armour		2020-08-31	500000	0		approved	3e06c426-422c-4bf0-923f-94e0aed5c43b	228e25cb-a091-4c40-9c60-751c784d8852	3e9a3591-d6b2-4b46-a426-5e0872553673	42.5900000000000034	0	42.5900000000000034	f	2	2020-04-22 18:22:19.599	2020-04-22 18:30:29.111	t	\N	2020-04-01	\N	\N	There is a contract currently in place with an incumbent supplier. The contract term has ended and BC Sheriff's Service requires a new contract to secure a supply of soft body armor. NOTE: The contract has already expired.	No supply of soft body armor to BC Sheriff's Service employees.	Contracting with a supplier who delivers products in a timely manner with strong service supports. 	\N	90c9c475-cf6d-429f-a8a5-7da8e3b58db1	d1636622-a025-4736-969f-8e5536f6512e	\N
0ec95b57-9fa6-4a40-8c86-b033e6cdad50	Workplace Technology Services Procurement Project		2022-09-30	300000000	0		approved	2c933486-0a9b-40de-adc9-eaa9319a16f2	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	3e9a3591-d6b2-4b46-a426-5e0872553673	66.3599999999999994	69.8100000000000023	62.9600000000000009	t	1	2020-04-22 18:28:30.59	2020-04-22 18:30:38.891	t	\N	2022-09-29	\N	\N	WTSPP is the procurement of device services (computer hardware, deployment & decommissioning, service desk, field services and managed workplace technology services). Current term expires September 30, 2020. Approval obtained, and negotiations underway to extend this term for 24 months plus six months, plus six months (the two 6 month possible extensions are built in to allow for transition).	Ceasing of services and services continuity with risk of another direct award to extend and maintain service. 	Contract(s) are executed and best value is obtained from the marketplace. 	\N	9c539e7c-de5a-49eb-92e7-c28b8c9838ff	15b3f630-3c1f-4402-8e08-6591f3d8ba13	\N
bde564d3-c6ff-417b-a755-eaedeafd35c3	Renewable Energy Studies		2021-12-30	1	0		approved	6680eec1-85c6-446c-86ef-677db7908c1a	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-04-22 21:27:41.245	2020-04-22 21:27:49.066	f	\N	\N	\N	\N	\N	Services not provided	services are provided	\N	e217c260-02cc-4ffc-aedd-9257c055519e	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
9e8f3255-6d3e-41a8-8cc5-d2d621e6e36e	Picture Framing CSA		2021-12-30	1	0		approved	80f44db4-8489-4144-bd99-25734ee64bae	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-04-22 21:47:22.928	2020-04-22 21:47:31.422	f	\N	\N	\N	\N	\N	Services not provided	services are provided	\N	fd54eb6c-3aaa-47be-9c65-678a8c6a3aa8	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
479df50c-b47c-47d1-9d19-5103e899dc5e	AIR Victoria Moving Services		2021-12-30	1	0		approved	a0a72451-9577-4ab4-bec9-f1a236243805	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-04-22 21:54:03.561	2020-04-22 21:54:10.203	f	\N	\N	\N	\N	\N	Services not provided	services are provided	\N	441d079e-79a2-4bee-9bed-5599631761d1	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
8e8306dc-ac63-4f70-aeb0-97f9b11ad8ce	Ongoing Contract work		2021-12-30	1	0		approved	92e963f3-70a4-4f95-b6e0-b86c062aba6d	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-04-22 21:59:58.366	2020-04-22 22:00:06.948	f	\N	\N	\N	\N	\N	services not provided	services are provided	\N	a14b3e69-8422-4069-a20f-84b2db82a7f5	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
9ada8310-36cb-463d-a35f-f3d5a2facea9	Procurement and Contract Advisory		2021-12-30	1	0		approved	99543d57-26fd-4ba4-8f31-668bab5f7773	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-04-22 22:14:14.514	2020-04-22 22:14:21.928	f	\N	\N	\N	\N	\N	Services not provided	services are provided	\N	5a9c55de-0566-41ba-b28f-eacabe351135	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
3e9de746-7184-4bd2-9e26-489aa1b37c98	BCWS 2020 Procurements-Various		2020-04-30	10	0		approved	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	b9a782bd-39b5-4697-9a4a-9b62737876e2	b9a782bd-39b5-4697-9a4a-9b62737876e2	62.9600000000000009	0	62.9600000000000009	f	1	2020-04-23 01:29:49.333	2020-04-23 01:30:15.524	f	\N	\N	\N	\N	\N	don't have contracts in place for 2020 fire season	Contracts in place by April 30, 2020	\N	ebff8e7a-322e-4879-983c-88cba8b50e5e	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
55b2c1aa-a96b-4a07-8b94-55ab95263d23	BC Parks Uniforms and Jackets Procurement		2020-12-31	500000	0		submitted	\N	8b436459-b4c6-424b-ad53-ebd55d2e5483	\N	42.5900000000000034	0	42.5900000000000034	f	2	2020-04-23 19:18:19.062	2020-04-23 19:18:19.062	f	\N	\N	\N	\N	\N	None identified for this project.	Continued supply of Uniforms and Jackets for BC Parks without any interruptions.	\N	6f5521be-ca24-4c99-a308-da66eee67993	5afee492-cea2-4360-8e6f-e66c17baaaf5	\N
\.


--
-- Data for Name: project_intake_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_intake_category (id, "projectIntakeCategoryName") FROM stdin;
\.


--
-- Data for Name: project_intake_contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_intake_contacts (id, "projectIntakeId", "contactId") FROM stdin;
bf5a3c7c-1b38-4e55-898c-892c4971352e	291ac6ba-64d7-491b-b838-c2441ca199c1	8e76b806-ced5-474e-a51b-239cd43a2cfe
cebe1ac8-656b-40cc-a1a0-040f5947de2f	291ac6ba-64d7-491b-b838-c2441ca199c1	a85184f1-c079-40e3-b3b1-d0be77abf233
73fc8061-3032-4f48-9528-c060865b003a	291ac6ba-64d7-491b-b838-c2441ca199c1	b793367b-c15e-4376-8f3b-4a34605e7400
eaff2f3c-9266-4930-b179-3f02ab54adf6	91786f9c-1ec0-48f5-8155-1c71c8c0c996	ea526c93-bfe2-4b46-b337-1d10bb59a4a9
3c27a707-6d57-4588-9b53-b33c8225994f	91786f9c-1ec0-48f5-8155-1c71c8c0c996	ff35de9f-9b3b-4c4f-8bf8-1d72a550485f
6397acfb-2e03-4a45-aaca-79ffe3b9331a	91786f9c-1ec0-48f5-8155-1c71c8c0c996	69e14066-dfe5-48d5-93c7-243fba7b85b3
e9acd97d-e921-4d2c-b8a1-9b213086248f	93430175-358e-4a38-8daf-e22e4f2dedec	81ca2106-9562-49f3-9224-99c4dd54e827
0db34bb3-c97b-4538-b0f1-7253080b050b	93430175-358e-4a38-8daf-e22e4f2dedec	077dd07e-5d01-4268-973f-94ed86a37121
bebe9bb9-cea6-4957-926a-57f4a4f05500	93430175-358e-4a38-8daf-e22e4f2dedec	23c5ca18-cee6-4b87-bb4a-66460aee5ca4
5e4f58fb-e6bf-484e-adfd-ae8a570916fc	b11d8270-b2df-417c-aa7d-9bb8321433cd	a3a9928e-561d-4b71-9744-398d98692366
240a7ab9-28c9-456d-b9c8-1965c0cc53c0	b11d8270-b2df-417c-aa7d-9bb8321433cd	76849d01-3fee-4204-88df-3d026c3de8c8
02f285c7-2461-44a8-94d4-93e90f963b2c	b11d8270-b2df-417c-aa7d-9bb8321433cd	53393e30-7a21-40d8-89c3-91f1c65aab6f
e002d209-ef88-4a96-9227-cd13ea187249	0ec95b57-9fa6-4a40-8c86-b033e6cdad50	d6cfc8af-0a67-4095-8d99-057228d16f1e
8b0fb728-51d5-48e2-a3d6-907b5a2a5cad	0ec95b57-9fa6-4a40-8c86-b033e6cdad50	46afe217-22b8-48b6-8142-508512f80018
04a03be2-e3d4-4713-864d-cd36db8a1dc1	0ec95b57-9fa6-4a40-8c86-b033e6cdad50	b6808d7a-97b6-4ec4-b3f9-16555d46f1ed
72e67681-89d2-4b8d-b1af-4d81ba705ee8	f691ca03-7a57-4cd4-98a1-e6385b293322	bab69975-a938-4d52-97d2-6c378d346b9e
e1662b14-c78f-4adf-8179-5d92e674445d	f691ca03-7a57-4cd4-98a1-e6385b293322	0bf18159-89ab-4593-a5c2-defbe6dc51ee
52a60537-6742-485e-8a93-f7e9da3a18bc	f691ca03-7a57-4cd4-98a1-e6385b293322	015ab727-e4f2-4402-aaf8-cbc30827a949
7462d069-d40d-4cc3-acdd-f89f9e8f4b3c	f7f40c7b-a42e-43aa-a14d-305d5b8338e0	1fec9b37-843d-4fe0-ab25-86728a0a0fae
7f30f37d-6f1c-48de-92ec-572c27202cdd	f7f40c7b-a42e-43aa-a14d-305d5b8338e0	b9f14763-733a-491d-8764-88475d17ecbc
71b2bf49-3b30-4b8d-82f6-77a7a770fe69	f7f40c7b-a42e-43aa-a14d-305d5b8338e0	634418ee-7e13-474b-b702-88a309dc1103
aab5e411-3542-4134-916c-15b765419eb9	bde564d3-c6ff-417b-a755-eaedeafd35c3	0ff81989-e9d2-4a1d-baee-b6d10d22ae39
f200a15f-23d7-48fa-958f-18a35b1b5452	bde564d3-c6ff-417b-a755-eaedeafd35c3	b8b46117-65cb-4591-9604-495422427320
503d08cd-078b-4a66-91e6-d635b9b552d8	bde564d3-c6ff-417b-a755-eaedeafd35c3	71d1d3d1-24a0-434f-ba55-06eab2a76b66
b0b7cd9c-bd37-497e-ada6-d0367530987c	9e8f3255-6d3e-41a8-8cc5-d2d621e6e36e	0cdc5dad-cffd-4663-9903-00590eaa71be
b2ac6a84-aa91-491d-a36f-c20f717f65fa	9e8f3255-6d3e-41a8-8cc5-d2d621e6e36e	499b37a4-b05a-4d6d-8161-c58266a25155
a49a0897-f837-488e-90c3-82411213e3a0	9e8f3255-6d3e-41a8-8cc5-d2d621e6e36e	9cfc5a3c-919d-4307-b9e3-54f0f850bdf8
87c56155-a1a1-4273-8b15-64dcf6178dab	479df50c-b47c-47d1-9d19-5103e899dc5e	0e7cb963-26b7-4d32-a9c5-054b2f0aff68
bd7e7c2a-8f54-47b5-a80d-e06c56f04909	479df50c-b47c-47d1-9d19-5103e899dc5e	59c4d2e0-99a3-462e-afbf-6b815fc18500
43c56b83-e315-472c-b807-76598e008b44	479df50c-b47c-47d1-9d19-5103e899dc5e	a3bbc881-2635-413b-b393-87c830f0c11c
af95371e-9672-422f-ae0b-454b2e5370e8	8e8306dc-ac63-4f70-aeb0-97f9b11ad8ce	f36adf1c-6dc1-4769-9a46-19dd0a6b75cf
5041ddb2-e589-4e5e-87e3-731c6ffbe2d8	8e8306dc-ac63-4f70-aeb0-97f9b11ad8ce	b8b2bf6f-c50c-4774-bd4d-2045d1a2bc64
2ecd121f-563c-4933-87e2-3020aa80bc43	8e8306dc-ac63-4f70-aeb0-97f9b11ad8ce	72ebbd26-e4a2-495e-abda-5413f2c92e83
c7354373-11ab-4543-8803-affc5345d278	9ada8310-36cb-463d-a35f-f3d5a2facea9	d95bc8be-deb9-4bbe-a12a-1eb964497872
6ce070df-7c03-4fc3-9861-61ebcb109130	9ada8310-36cb-463d-a35f-f3d5a2facea9	467b9a1f-6e80-4390-82bc-b7ab1a5f460a
b639f224-f79c-4208-8ae2-cfe888486f31	9ada8310-36cb-463d-a35f-f3d5a2facea9	008d9c46-9f4a-4582-91f0-6c08cbf2459b
54fec4c5-4b5b-4d55-a663-59c3cc6710b3	3e9de746-7184-4bd2-9e26-489aa1b37c98	13ed96d7-f082-4745-81e9-31b4d895c0bf
d36fb9f6-9fb5-40d7-8b04-37e652669789	3e9de746-7184-4bd2-9e26-489aa1b37c98	4c3d402f-f970-4e21-8120-e7411ae8d9d5
ba1a05f0-d8cf-456f-a9f0-a6d38a705a16	3e9de746-7184-4bd2-9e26-489aa1b37c98	5e6d47db-ee28-4416-9283-f1d2ab641747
82bc9d01-1aa0-40b1-b0e5-d6c3abf8769f	55b2c1aa-a96b-4a07-8b94-55ab95263d23	23e3cd97-345a-40bf-b698-02fce7b0c1e5
62005d39-1067-48fb-9f13-9b24a01002fe	55b2c1aa-a96b-4a07-8b94-55ab95263d23	73d93e32-6d7e-4552-b4a1-6a8225a20a69
55bc939f-8af5-4f23-9969-ee3b02a26308	55b2c1aa-a96b-4a07-8b94-55ab95263d23	99a23a1b-4a2b-4ade-a5ae-fec518edb751
\.


--
-- Data for Name: project_intake_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_intake_services (id, "ProjectIntakeServiceName") FROM stdin;
\.


--
-- Data for Name: project_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_note (id, note, "projectId", "userId", "parentId", "noteTime") FROM stdin;
\.


--
-- Data for Name: project_rfx; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_rfx (id, "rfxName", "rfxOverview", "clientResponsibilities", "psdResponsibilities", "dateCreated", "dateModified", "projectId", "rfxTypeId", "rfxPhaseId") FROM stdin;
21868485-7af3-48c1-bc8d-1a146e052b0d	Vehicle Storage	require numerous places around the province in order to keep vehicles secured.	unknown yet	unknown yet	2020-04-22 17:24:17.735	2020-04-22 17:26:01.744	d930683b-68e0-44f5-a31d-398815e32909	1e5def8d-c2b2-4231-a602-09a80967d2dc	828e8637-1699-4dc1-805a-b4333270d4f0
4562f639-7012-4b1c-ab3d-a740c8dea828	TI Corp SMS	SaaS to manage the communication for TI Corps three major projects	Draft RFP	Review RFP	2020-04-22 17:34:21.463	2020-04-22 17:34:21.463	2d2796cc-4950-4811-abf9-cebd2d9d7f01	6095c8e0-5569-4263-b835-ac75c13d7d26	828e8637-1699-4dc1-805a-b4333270d4f0
95f6585d-d840-49e3-95db-5d4d1b86ab40	EnWQS	Information system for Water Quality System.	Draft documents, lead procurement.	Review provided documents only.	2020-04-22 17:22:59.255	2020-04-22 17:47:02.245	4c70dd71-1938-4a01-a86b-ced42b12c11e	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
fb408cd3-05dd-4977-a1e7-47cee6034c09	Workplace Technology Services Procurement Project	Project team is presently evaluating options for bundling of the services which could result in one, two, or three separate procurement projects. The summary and details, as well as the solicitation vehicles are to be determined. 	Planning:\nperform needs assessment, develop business\ncase, perform risk assessment;\nassist with development of terms of reference\ndocumentation for ministry approval;\nContracts:\ncontract negotiations; \nreview and comment on contract;\ndraft contract documents;	Lead procurement functions, including:\nidentify and develop procurement strategy; \nresearch, edit, create, review, comment and\nprovide input into solicitation documents;\nchair vendor/proponent meetings; \nrespond to vendor/proponent inquiries, in\nconsultation with Ministry staff;\ncreate, edit, review and provide input into the\nevaluation plan and booklets;\nprovide advice during evaluations; \nevaluate submissions (only when necessary);\nchair evaluation consensus meetings; Lead Support\nreview and provide input into scoring overviews\nand synopsis of evaluation notes;\nnotify proponents of evaluation results/short-listed\nresults;\ncreate, review and provide input into the\npresentation plan and booklet;\nchair short-listed presentation meeting(s); Lead Support\npost and close solicitation; Lead Support\nassist with preparation of briefing\nassist with preparation of briefing notes and\nsummary of the procurement process;\nparticipate in proponent debriefings;\nprovide support/advice for any vendor conflict\nresolution and/or vendor complaint processes;	2020-04-22 19:01:58.32	2020-04-22 19:07:55.365	2c933486-0a9b-40de-adc9-eaa9319a16f2	4a726944-a454-4eda-aab9-ebb5db9744ac	828e8637-1699-4dc1-805a-b4333270d4f0
dd22c4d9-bc44-4dcd-93de-d148a26e686c	Soft Body Armor	Procurement of soft body armor on an if, when and as needed basis.	Supporting the drafting and they will be handling the finalized document once complete (posting of the document onwards)	Supporting the RMSA drafting process and providing ad-hoc advice as needed. 	2020-04-22 20:23:09.089	2020-04-22 20:23:09.089	3e06c426-422c-4bf0-923f-94e0aed5c43b	caa352ac-224c-4684-b3c2-3169dcf6c784	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
defede2e-0492-468f-9da8-af187cfc8f22	Energy Study and Related Services	suppliers to provide Renewable Energy Study, Strategic Energy Management Plan or Energy Efficiency Feasibility Study.	unknown\n	management of CSAs	2020-04-22 21:34:11.782	2020-04-22 21:34:11.782	6680eec1-85c6-446c-86ef-677db7908c1a	1715e865-c294-44e7-a0d8-37a4950f720b	5a488660-8969-4a58-8d47-85a9bb03c3e0
50c157bb-1ee4-40f5-9f01-d2758195757a	ON-003267 Analysis of Environmental Samples	JDG-232-1 summary	unknown	unknown	2020-04-22 22:21:08.43	2020-04-22 22:21:32.585	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	7a66f09f-9252-4768-8434-324d8d23dd88
d2b11e76-6892-4e49-b147-bdb5fa02b57c	ON-003423 Gravimetric Analysis	 JDG-232-2 summary	unknown	unknown	2020-04-22 22:23:51.192	2020-04-22 22:24:10.799	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
3ff077b0-440b-481e-a234-cb89deabb169	ON-003427 Taxonomic Macroinvertebrates	JDG-232-3 summary	unknown	unknown	2020-04-23 19:47:46.377	2020-04-23 19:47:46.377	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
348cdfae-a503-4b68-9cc2-e06a7e34cac0	ON-003440 Taxonomic Analysis	JDG-232-4 Summary	unknown	unknown	2020-04-23 19:50:01.354	2020-04-23 19:50:01.354	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	828e8637-1699-4dc1-805a-b4333270d4f0
bb8dff51-ac8d-433a-9023-d9d61d549911	On-003483 Taxonomic analysis-Reissue	JDG-232-5 Summary	unknown	unknown	2020-04-23 19:51:40.425	2020-04-23 19:51:40.425	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
\.


--
-- Data for Name: project_risk_analysis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_risk_analysis (id, score, "dateCreated", "dateModified", "questionId", "answerId", "intakeId") FROM stdin;
acba9273-0928-4a0e-955c-6e06c96720e1	6	2020-04-22 17:19:28.309	2020-04-22 17:19:28.309	e969a6eb-2819-445f-a3f5-1aad40ad75b4	f24e1de4-824b-4eec-aac0-5dade4d3c2b9	91786f9c-1ec0-48f5-8155-1c71c8c0c996
dc984ab3-9c21-4942-a688-462ecb244606	2	2020-04-22 17:19:28.321	2020-04-22 17:19:28.321	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	91786f9c-1ec0-48f5-8155-1c71c8c0c996
56951235-f8ee-48bf-ad15-a38030ca24ff	2	2020-04-22 17:19:28.325	2020-04-22 17:19:28.325	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	91786f9c-1ec0-48f5-8155-1c71c8c0c996
0de4a6d5-b52f-4cee-98a7-8831de1a247c	3	2020-04-22 17:19:28.33	2020-04-22 17:19:28.33	94ec86da-f955-4e3d-b0ba-932b3044abdb	0c8e249f-bc3a-4b7c-ab30-bebc1b95d0d0	91786f9c-1ec0-48f5-8155-1c71c8c0c996
861c5e44-23f7-4ebf-b134-059fe869ac58	1	2020-04-22 17:19:28.334	2020-04-22 17:19:28.334	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	91786f9c-1ec0-48f5-8155-1c71c8c0c996
ee4eae61-7f23-4081-989c-eddcde7efb36	2	2020-04-22 17:19:28.34	2020-04-22 17:19:28.34	ec300240-d516-40d4-b9b3-8a23d8f4e951	5641fe2c-a6d2-4434-9d0b-15a1c99bbb22	91786f9c-1ec0-48f5-8155-1c71c8c0c996
48c498de-5f59-4373-bc17-3420c3693bc4	2	2020-04-22 17:19:28.344	2020-04-22 17:19:28.344	c81159f4-42bb-48b1-8338-592df3b43eff	19dc1942-b79f-447b-9004-29f0a299ac6a	91786f9c-1ec0-48f5-8155-1c71c8c0c996
cdceb684-f2ff-4a3e-a727-80880c59111e	3	2020-04-22 17:19:28.349	2020-04-22 17:19:28.349	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	91786f9c-1ec0-48f5-8155-1c71c8c0c996
59c4d0dc-362b-41fb-b46e-d4d031dbc702	1	2020-04-22 17:19:28.353	2020-04-22 17:19:28.353	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	91786f9c-1ec0-48f5-8155-1c71c8c0c996
9448c5b3-4487-4dbb-8de8-69145ad7362e	1	2020-04-22 17:19:28.356	2020-04-22 17:19:28.356	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	91786f9c-1ec0-48f5-8155-1c71c8c0c996
1f3bfcec-2111-4cc8-9ce0-d277746b3fb7	4	2020-04-22 17:20:34.595	2020-04-22 17:20:34.595	e969a6eb-2819-445f-a3f5-1aad40ad75b4	41a02614-dae7-4c48-b1d6-b4c241e2d62f	93430175-358e-4a38-8daf-e22e4f2dedec
d61de5f2-19fe-4951-a517-9846cb6298ef	2	2020-04-22 17:20:34.606	2020-04-22 17:20:34.606	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	93430175-358e-4a38-8daf-e22e4f2dedec
9d8befa0-84d3-4d42-8157-4ce0c569df32	2	2020-04-22 17:20:34.613	2020-04-22 17:20:34.613	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	93430175-358e-4a38-8daf-e22e4f2dedec
5418afee-c5d3-4737-a5f0-ce1d00f2cc19	2	2020-04-22 17:26:27.911	2020-04-22 17:26:27.911	ef0491c5-4715-4f97-a314-21c26164a5d2	23815f9c-c74e-4ea6-bade-0da084a3833e	93430175-358e-4a38-8daf-e22e4f2dedec
7fdd2e89-1c10-43f4-8a16-e86276cc19bc	2	2020-04-22 17:20:34.616	2020-04-22 17:20:34.616	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	93430175-358e-4a38-8daf-e22e4f2dedec
50a3cc0f-6311-4e69-8dd1-8ba246b53715	1	2020-04-22 17:20:34.62	2020-04-22 17:20:34.62	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	93430175-358e-4a38-8daf-e22e4f2dedec
ce543dba-fbae-49d3-bbf9-cf7c3b759ec2	3	2020-04-22 17:20:34.625	2020-04-22 17:20:34.625	ec300240-d516-40d4-b9b3-8a23d8f4e951	6c175262-5a0e-4120-b1ac-1fd3d65943ba	93430175-358e-4a38-8daf-e22e4f2dedec
9a3b36c8-98bd-4fab-97e1-d50c3d04cd09	4	2020-04-22 17:20:34.63	2020-04-22 17:20:34.63	c81159f4-42bb-48b1-8338-592df3b43eff	77cb51a1-66e4-4f5e-a2ce-5b8e6600753c	93430175-358e-4a38-8daf-e22e4f2dedec
19aeba61-7ff6-4b57-b9a5-f88de88bb660	1	2020-04-22 17:26:27.949	2020-04-22 17:26:27.949	7f7cb3f0-7668-438d-97bc-db053ed2e767	169b59d2-c2ba-4e70-90f2-bead560abd6e	93430175-358e-4a38-8daf-e22e4f2dedec
048d18d3-6818-45aa-92c3-098271110931	6	2020-04-22 17:26:27.954	2020-04-22 17:26:27.954	4b667ac6-0015-46ce-bb49-4b19a8d3c3b3	147aefa0-34c5-4777-809e-dfcfec232759	93430175-358e-4a38-8daf-e22e4f2dedec
87c36ceb-f442-4796-9274-40a7ad518214	2	2020-04-22 17:26:27.958	2020-04-22 17:26:27.958	ee895822-a724-4fe7-9792-4f1f61c7dd95	db3d0033-406f-4e86-91f5-4a974649d806	93430175-358e-4a38-8daf-e22e4f2dedec
138d5d1a-a5cb-405e-8c0b-370775ca8843	1	2020-04-22 17:26:27.962	2020-04-22 17:26:27.962	2cf75e3a-fba2-4202-84f3-f025c47c7f19	6e87e312-d7be-4e53-bcf7-c88fb3418a2e	93430175-358e-4a38-8daf-e22e4f2dedec
99ca66d3-752a-44a1-9028-542e879da382	1	2020-04-22 17:26:27.966	2020-04-22 17:26:27.966	1c0b9190-ccf9-4239-9209-11d737933a8b	cc7e4067-8ede-4e29-bc97-b2403c5ab720	93430175-358e-4a38-8daf-e22e4f2dedec
40e4d971-5574-4a02-99b2-9136af4d7a60	1	2020-04-22 17:20:34.634	2020-04-22 17:20:34.634	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	93430175-358e-4a38-8daf-e22e4f2dedec
90d6b24a-d464-4758-be1d-38dfe62de373	2	2020-04-22 17:20:34.637	2020-04-22 17:20:34.637	a19f05bd-8172-4994-b991-fc717b0e46f2	1836784b-ed08-44b7-a898-8cf3f5119fe4	93430175-358e-4a38-8daf-e22e4f2dedec
0b76b4a0-a302-4bfc-8a8b-7c580a0eca81	3	2020-04-22 17:26:27.985	2020-04-22 17:26:27.985	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	cb3d0fec-11c3-467e-a688-0307910225f7	93430175-358e-4a38-8daf-e22e4f2dedec
d4e29c62-7e77-4a2f-acc2-fa7a6e6dbd75	1	2020-04-22 17:26:27.989	2020-04-22 17:26:27.989	ba44a355-b2dc-4c86-b9d0-5a0a68fb55bc	c63862fb-45a1-4553-bc2d-00a596295fd2	93430175-358e-4a38-8daf-e22e4f2dedec
e5df5dbb-fbbb-47a6-8ab7-3057be6718df	6	2020-04-22 18:22:19.797	2020-04-22 18:22:19.797	e969a6eb-2819-445f-a3f5-1aad40ad75b4	f24e1de4-824b-4eec-aac0-5dade4d3c2b9	b11d8270-b2df-417c-aa7d-9bb8321433cd
d509be30-4bcf-431e-aa07-95f5476fa426	2	2020-04-22 18:22:19.807	2020-04-22 18:22:19.807	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	b11d8270-b2df-417c-aa7d-9bb8321433cd
61288896-d77b-4ca5-b8b9-4c19d360e326	2	2020-04-22 18:22:19.817	2020-04-22 18:22:19.817	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	b11d8270-b2df-417c-aa7d-9bb8321433cd
9fcf69b9-6951-4d0d-a7f6-0cd29d449f00	2	2020-04-22 18:22:19.838	2020-04-22 18:22:19.838	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	b11d8270-b2df-417c-aa7d-9bb8321433cd
087c81f7-86d5-401a-8571-1417c9af5dd9	1	2020-04-22 18:22:19.85	2020-04-22 18:22:19.85	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	b11d8270-b2df-417c-aa7d-9bb8321433cd
77534c52-1bab-4e8d-a8df-2ae14a33ab6b	2	2020-04-22 18:22:19.854	2020-04-22 18:22:19.854	ec300240-d516-40d4-b9b3-8a23d8f4e951	5641fe2c-a6d2-4434-9d0b-15a1c99bbb22	b11d8270-b2df-417c-aa7d-9bb8321433cd
4706d795-ebf3-4249-a491-04209f74b8a2	3	2020-04-22 18:22:19.858	2020-04-22 18:22:19.858	c81159f4-42bb-48b1-8338-592df3b43eff	087c00f6-9541-413b-b300-a8f3f6e5bd69	b11d8270-b2df-417c-aa7d-9bb8321433cd
c64af5fe-a23b-4d8d-ae6f-bb3fa2c50310	3	2020-04-22 18:22:19.863	2020-04-22 18:22:19.863	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	b11d8270-b2df-417c-aa7d-9bb8321433cd
c844b6f9-dcd9-422b-a120-8d57dd3b57f5	1	2020-04-22 18:22:19.866	2020-04-22 18:22:19.866	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	b11d8270-b2df-417c-aa7d-9bb8321433cd
eb8ec32f-0216-4f10-868e-d4c128c03756	1	2020-04-22 18:22:19.872	2020-04-22 18:22:19.872	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	b11d8270-b2df-417c-aa7d-9bb8321433cd
416fd2e0-b3c9-42d1-bb9d-1a614e90fbf9	10	2020-04-22 18:28:30.678	2020-04-22 18:28:30.678	e969a6eb-2819-445f-a3f5-1aad40ad75b4	af07c63d-4c96-40ad-83e5-a9e06ab64fb6	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
c46b1b9d-4c24-4336-afd8-25890b51aad3	4	2020-04-22 18:28:30.761	2020-04-22 18:28:30.761	7867249a-657a-489a-9203-1754ed8885cc	e6379225-7cd4-48e9-9d3b-7fee086dd006	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
cd00a574-9a97-49b2-9954-2518265b99de	1	2020-04-22 18:28:30.769	2020-04-22 18:28:30.769	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
0b7b47d5-f3bf-4437-84c2-8a3add36fc49	10	2020-04-22 19:04:43.41	2020-04-22 19:04:43.41	ef0491c5-4715-4f97-a314-21c26164a5d2	a7cecc23-7b00-4497-911d-3dffb14498aa	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
1fecea00-19d6-455a-89f2-6bb516430854	5	2020-04-22 18:28:30.8	2020-04-22 18:28:30.8	94ec86da-f955-4e3d-b0ba-932b3044abdb	d0abe350-e32f-427d-b6cc-b22ad1fc9893	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
41d5a9f7-ba2c-4b1f-8a96-91da0c58fef6	4	2020-04-22 18:28:30.806	2020-04-22 18:28:30.806	1f71e8bc-5b88-40c3-ab99-553368ebf685	7e5e6063-6e37-415e-9367-b2f9ab1c7f5f	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
324fa6f5-c44e-469d-ac9a-f9ac67cc0d0e	4	2020-04-22 18:28:30.81	2020-04-22 18:28:30.81	ec300240-d516-40d4-b9b3-8a23d8f4e951	e047e857-e7d8-468e-8380-d2990f3bc384	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
54c98bf2-3b0f-43f5-b980-18fe7607e783	1	2020-04-22 18:28:30.813	2020-04-22 18:28:30.813	c81159f4-42bb-48b1-8338-592df3b43eff	f6319753-11fe-4e28-8ed4-6195a6b9bbb7	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
44fae3cf-2546-4657-99c3-555c8a4154c2	3	2020-04-22 19:04:43.508	2020-04-22 19:04:43.508	7f7cb3f0-7668-438d-97bc-db053ed2e767	bbb4fc0f-a7e8-453e-a9e7-5c0ded9f0f19	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
f1083fd0-f12e-47ce-802e-d93b73e315d8	10	2020-04-22 19:04:43.516	2020-04-22 19:04:43.516	4b667ac6-0015-46ce-bb49-4b19a8d3c3b3	c28e4b9d-8f45-489e-83af-72c288f4b8d4	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
0d153db4-d595-4da9-9110-443a531a6b9f	10	2020-04-22 19:04:43.521	2020-04-22 19:04:43.521	ee895822-a724-4fe7-9792-4f1f61c7dd95	9d8f6078-99c6-480f-bb31-c7240121c42d	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
d5ffdeea-06c1-46bc-a4a6-27ca582f40f0	1	2020-04-22 19:04:43.529	2020-04-22 19:04:43.529	2cf75e3a-fba2-4202-84f3-f025c47c7f19	6e87e312-d7be-4e53-bcf7-c88fb3418a2e	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
266f0331-89a3-40da-bfb6-c1f21181b6ea	1	2020-04-22 19:04:43.532	2020-04-22 19:04:43.532	1c0b9190-ccf9-4239-9209-11d737933a8b	cc7e4067-8ede-4e29-bc97-b2403c5ab720	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
bee4b903-ad72-4191-8624-6bac84482ff1	1	2020-04-22 18:28:30.819	2020-04-22 18:28:30.819	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
a200b866-669d-4149-8d6f-f5fbac944ccf	2	2020-04-22 18:28:30.823	2020-04-22 18:28:30.823	a19f05bd-8172-4994-b991-fc717b0e46f2	1836784b-ed08-44b7-a898-8cf3f5119fe4	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
d2e299b6-ab47-44f0-97c7-3febd56bf82c	2	2020-04-22 18:28:30.828	2020-04-22 18:28:30.828	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	4ddd151e-751c-43e3-9f07-794b1003de70	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
efc96577-b8af-4da2-b95b-d015a53d5e1b	2	2020-04-22 19:04:43.568	2020-04-22 19:04:43.568	ba44a355-b2dc-4c86-b9d0-5a0a68fb55bc	6e423de0-3f4b-4bd2-8b63-b646c0d4e8ba	0ec95b57-9fa6-4a40-8c86-b033e6cdad50
232c3dfe-ff47-4dfd-9a2b-7fe3b4b0ea40	10	2020-04-22 20:41:07.956	2020-04-22 20:41:07.956	e969a6eb-2819-445f-a3f5-1aad40ad75b4	af07c63d-4c96-40ad-83e5-a9e06ab64fb6	f691ca03-7a57-4cd4-98a1-e6385b293322
13bfcbbe-3d62-4866-816b-c3ff04c1761e	2	2020-04-22 20:41:07.977	2020-04-22 20:41:07.977	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	f691ca03-7a57-4cd4-98a1-e6385b293322
f8d78dd0-3c1f-42d9-98c4-1d7462a3a632	2	2020-04-22 20:41:07.982	2020-04-22 20:41:07.982	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	f691ca03-7a57-4cd4-98a1-e6385b293322
d39fca34-899c-4a0f-ba14-9d47e9bdebaf	2	2020-04-22 20:41:07.986	2020-04-22 20:41:07.986	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	f691ca03-7a57-4cd4-98a1-e6385b293322
5a866f5f-8093-4ec6-b844-bb9fc15a93f1	2	2020-04-22 20:41:07.99	2020-04-22 20:41:07.99	1f71e8bc-5b88-40c3-ab99-553368ebf685	ff3978b8-3025-4e2e-aac3-7873b6cc74d9	f691ca03-7a57-4cd4-98a1-e6385b293322
86c05831-b449-450d-8e54-5849c77d6de5	2	2020-04-22 20:41:07.994	2020-04-22 20:41:07.994	ec300240-d516-40d4-b9b3-8a23d8f4e951	5641fe2c-a6d2-4434-9d0b-15a1c99bbb22	f691ca03-7a57-4cd4-98a1-e6385b293322
c2379e7d-d6ae-4f27-bde0-dbb87a49f5fb	3	2020-04-22 20:41:08.001	2020-04-22 20:41:08.001	c81159f4-42bb-48b1-8338-592df3b43eff	087c00f6-9541-413b-b300-a8f3f6e5bd69	f691ca03-7a57-4cd4-98a1-e6385b293322
636fc79e-778e-4548-a8de-d315fff06ee3	3	2020-04-22 20:41:08.006	2020-04-22 20:41:08.006	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	f691ca03-7a57-4cd4-98a1-e6385b293322
f4f12db5-63b4-4276-896a-70f0ec110255	1	2020-04-22 20:41:08.009	2020-04-22 20:41:08.009	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	f691ca03-7a57-4cd4-98a1-e6385b293322
363534b4-056d-460c-a139-9ce2710abd12	1	2020-04-22 20:41:08.048	2020-04-22 20:41:08.048	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	f691ca03-7a57-4cd4-98a1-e6385b293322
f2765540-0a3c-489b-b1ed-9e149bfd5d9a	10	2020-04-23 01:29:49.416	2020-04-23 01:29:49.416	e969a6eb-2819-445f-a3f5-1aad40ad75b4	af07c63d-4c96-40ad-83e5-a9e06ab64fb6	3e9de746-7184-4bd2-9e26-489aa1b37c98
a29f2186-5043-4dc8-bda9-aa4148ead6ad	10	2020-04-23 01:29:49.44	2020-04-23 01:29:49.44	7867249a-657a-489a-9203-1754ed8885cc	cf38beb1-58af-43c3-be69-0706a0806df8	3e9de746-7184-4bd2-9e26-489aa1b37c98
7b307308-7212-467c-96ef-d6efd8e5f496	2	2020-04-23 01:29:49.445	2020-04-23 01:29:49.445	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	3e9de746-7184-4bd2-9e26-489aa1b37c98
aab9aa01-9876-4680-ae37-7709a7eb40af	3	2020-04-23 01:29:49.45	2020-04-23 01:29:49.45	94ec86da-f955-4e3d-b0ba-932b3044abdb	0c8e249f-bc3a-4b7c-ab30-bebc1b95d0d0	3e9de746-7184-4bd2-9e26-489aa1b37c98
6f8d81b4-599f-4a92-8659-1c3b7dfe7959	1	2020-04-23 01:29:49.456	2020-04-23 01:29:49.456	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	3e9de746-7184-4bd2-9e26-489aa1b37c98
77f91bfe-0042-4b79-afaa-a3c27eaabd51	2	2020-04-23 01:29:49.463	2020-04-23 01:29:49.463	ec300240-d516-40d4-b9b3-8a23d8f4e951	5641fe2c-a6d2-4434-9d0b-15a1c99bbb22	3e9de746-7184-4bd2-9e26-489aa1b37c98
a760386c-e4f7-4182-8106-18f7e4dc18c2	2	2020-04-23 01:29:49.529	2020-04-23 01:29:49.529	c81159f4-42bb-48b1-8338-592df3b43eff	19dc1942-b79f-447b-9004-29f0a299ac6a	3e9de746-7184-4bd2-9e26-489aa1b37c98
801487a5-1ab0-4647-8378-e3559c12466d	1	2020-04-23 01:29:49.534	2020-04-23 01:29:49.534	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	3e9de746-7184-4bd2-9e26-489aa1b37c98
32908533-9950-40f5-8e69-07f7e51feb27	2	2020-04-23 01:29:49.539	2020-04-23 01:29:49.539	a19f05bd-8172-4994-b991-fc717b0e46f2	1836784b-ed08-44b7-a898-8cf3f5119fe4	3e9de746-7184-4bd2-9e26-489aa1b37c98
26d978ac-01f5-4543-af2f-9bfffcb3dea6	1	2020-04-23 01:29:49.543	2020-04-23 01:29:49.543	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	2d8b22af-1b06-4728-830a-2fb0726b85ca	3e9de746-7184-4bd2-9e26-489aa1b37c98
cb57ecab-0209-4052-b076-91676bcb27dc	6	2020-04-23 19:18:19.214	2020-04-23 19:18:19.214	e969a6eb-2819-445f-a3f5-1aad40ad75b4	f24e1de4-824b-4eec-aac0-5dade4d3c2b9	55b2c1aa-a96b-4a07-8b94-55ab95263d23
b81cf52a-b244-4935-a0ec-d6982282c96f	4	2020-04-23 19:18:19.244	2020-04-23 19:18:19.244	7867249a-657a-489a-9203-1754ed8885cc	e6379225-7cd4-48e9-9d3b-7fee086dd006	55b2c1aa-a96b-4a07-8b94-55ab95263d23
6486b000-1c1b-4353-bea4-3d58a39a9b25	2	2020-04-23 19:18:19.254	2020-04-23 19:18:19.254	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	55b2c1aa-a96b-4a07-8b94-55ab95263d23
39893c02-0a30-4a2c-a147-605112774fb5	2	2020-04-23 19:18:19.259	2020-04-23 19:18:19.259	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	55b2c1aa-a96b-4a07-8b94-55ab95263d23
2065c5dd-66b2-4bd3-a6d1-c6d5f5666c18	1	2020-04-23 19:18:19.262	2020-04-23 19:18:19.262	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	55b2c1aa-a96b-4a07-8b94-55ab95263d23
be3ca1f5-9e81-48d8-82f4-43ea506bbe8c	2	2020-04-23 19:18:19.267	2020-04-23 19:18:19.267	ec300240-d516-40d4-b9b3-8a23d8f4e951	5641fe2c-a6d2-4434-9d0b-15a1c99bbb22	55b2c1aa-a96b-4a07-8b94-55ab95263d23
2cfaeb7b-d504-4a43-bc26-6cdf96efe90d	1	2020-04-23 19:18:19.273	2020-04-23 19:18:19.273	c81159f4-42bb-48b1-8338-592df3b43eff	f6319753-11fe-4e28-8ed4-6195a6b9bbb7	55b2c1aa-a96b-4a07-8b94-55ab95263d23
8d16d973-ff7c-46ef-acb0-fb41bb154cf7	3	2020-04-23 19:18:19.281	2020-04-23 19:18:19.281	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	55b2c1aa-a96b-4a07-8b94-55ab95263d23
605e91a2-2985-4d13-8060-155494e707e9	1	2020-04-23 19:18:19.285	2020-04-23 19:18:19.285	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	55b2c1aa-a96b-4a07-8b94-55ab95263d23
23dbbc36-4bdc-46bf-a34e-a503b3ad00c4	1	2020-04-23 19:18:19.291	2020-04-23 19:18:19.291	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	55b2c1aa-a96b-4a07-8b94-55ab95263d23
\.


--
-- Data for Name: project_sector; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_sector (id, "projectSectorName") FROM stdin;
1faa3d3f-49af-448d-a2c6-4f0aa5238ddf	Industrial Equipment & Tools
5afee492-cea2-4360-8e6f-e66c17baaaf5	Components & Supplies
30371b0e-bb09-40e1-95ee-7d97550021af	Construction, Transportation & Facility Equipment & Supplies
fc25a9e1-b6e7-4abc-a81b-15d1b822da25	Medical, Laboratory & Test Equipment & Supplies & Pharmaceuticals
688d56a7-037d-4c78-a4cd-23a38d8487ac	Food, Cleaning & Service Industry Equipment & Supplies
15b3f630-3c1f-4402-8e08-6591f3d8ba13	Business, Communication & Technology Equipment & Supplies
d1636622-a025-4736-969f-8e5536f6512e	Defense, Security & Safety Equipment & Supplies
a4bfb227-663b-4074-ae36-ab5af4c4f3d5	Personal, Domestic & Consumer Equipment & Supplies
1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	Services
82fc095a-4811-493a-937a-6800dc758596	Other
\.


--
-- Data for Name: rfx_phase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rfx_phase (id, "rfxPhaseName") FROM stdin;
828e8637-1699-4dc1-805a-b4333270d4f0	Planning
e75d7fca-0b1c-4047-99a9-52af3c21cb3a	Drafting
a5ee8ab6-ab63-461c-a736-6d4cc7b7ed84	Posted
7a66f09f-9252-4768-8434-324d8d23dd88	Evaluation
5a488660-8969-4a58-8d47-85a9bb03c3e0	Award
e02b3a0a-9b8a-474c-9b77-a98ba428283a	Closed Out
d2f57675-d7e6-4859-8a12-677dc1f743e9	Suspended
c669592d-87ee-428e-848b-4a685ef641fe	Cancelled
f72575d2-c72e-46e5-a1b0-222ad9b2c245	Completed
\.


--
-- Data for Name: rfx_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rfx_type (id, "rfxTypeName") FROM stdin;
4a726944-a454-4eda-aab9-ebb5db9744ac	BVNP (Best Value Negotiated Process)
ab5ce0bd-6802-4167-bb9d-cede13a59433	Call to Market Against Pre-Qualification Lists - Services
4b017274-099d-481b-9383-d0bc0d7c2cfa	CFP (Call for Proposals)
9f502ebb-dda7-4f12-8bb7-ac8cc5946ac6	F NRFP (Feedback NRFP)
d2530e3a-5611-4d75-be45-9242e0dfc2ea	ITQ (Invitation to quote)
de731a51-8634-4e1e-8d6d-44d8cd6712bf	ITQS (Invitation to quote for Services)
7b3ac6e6-b424-4a27-8c2f-d9e179fcd6a5	ITT (Invitation to Tender)
b670ba9c-4bcd-4e60-ac22-352a8a1e003e	JSNRFP (Joint Solution NRFP)
0707b804-fd2d-4b4a-9a67-a639e1cf6907	NOI (Notice of Intent)
1715e865-c294-44e7-a0d8-37a4950f720b	RCSA (Request for Corporate Supply Arrangement)
0e8e7c7b-18be-49f3-868c-861e2f337746	RFEI (Request for Expression of Interest)
bf33dc34-2731-4970-abdd-690bf17b490f	RFI (Request for Information)
6095c8e0-5569-4263-b835-ac75c13d7d26	RFP (Request for Proposals)
2c173fd3-1cc4-465a-80f8-4072c41713d3	RFQ (Request for Qualifications)
caa352ac-224c-4684-b3c2-3169dcf6c784	RMSA (Request for Master Services Agreement)
cdf59ca5-4849-4e42-89c3-0682dc37ff04	RNRFP (Refinement NRFP)
5e6e73db-9d39-4301-90e3-4018bb954d9d	RRNRFP (Rank and Run NRFP)
1e5def8d-c2b2-4231-a602-09a80967d2dc	RSO (Request for Standing Offer)
87c75946-9cc9-4df1-bcf0-647293ddb468	SRFP (Short Form Request for Proposals)
\.


--
-- Data for Name: risk_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.risk_answers (id, answer, score, order_id, "questionId") FROM stdin;
4ddd151e-751c-43e3-9f07-794b1003de70	Potentially	2	2	2d4fd180-ef23-4134-8014-be2ec8ed1ec5
cb3d0fec-11c3-467e-a688-0307910225f7	Yes	3	3	2d4fd180-ef23-4134-8014-be2ec8ed1ec5
2d8b22af-1b06-4728-830a-2fb0726b85ca	No	1	1	2d4fd180-ef23-4134-8014-be2ec8ed1ec5
cf38beb1-58af-43c3-be69-0706a0806df8	Five or more contracts	10	5	7867249a-657a-489a-9203-1754ed8885cc
2cc39349-373b-4aa6-9046-9bd23fa24610	One contract	2	1	7867249a-657a-489a-9203-1754ed8885cc
e6379225-7cd4-48e9-9d3b-7fee086dd006	Two contracts	4	2	7867249a-657a-489a-9203-1754ed8885cc
88ea130f-75dd-4dc1-a12d-4f0d6c4e81e5	Three contracts	6	3	7867249a-657a-489a-9203-1754ed8885cc
07b9cbd0-719b-4f07-8713-ff220267239c	Four contracts	8	4	7867249a-657a-489a-9203-1754ed8885cc
1836784b-ed08-44b7-a898-8cf3f5119fe4	Potentially	2	2	a19f05bd-8172-4994-b991-fc717b0e46f2
f45d442e-ab56-4067-ab93-86ee3fa0d595	Yes	3	3	a19f05bd-8172-4994-b991-fc717b0e46f2
848bd7de-d59d-4175-8851-04c5c104ab9a	No	1	1	a19f05bd-8172-4994-b991-fc717b0e46f2
af07c63d-4c96-40ad-83e5-a9e06ab64fb6	over $10 million	10	5	e969a6eb-2819-445f-a3f5-1aad40ad75b4
78500ca2-c957-4999-96a2-360e5ec78f45	>50k	2	1	e969a6eb-2819-445f-a3f5-1aad40ad75b4
41a02614-dae7-4c48-b1d6-b4c241e2d62f	>250k	4	2	e969a6eb-2819-445f-a3f5-1aad40ad75b4
f24e1de4-824b-4eec-aac0-5dade4d3c2b9	500k-1 million	6	3	e969a6eb-2819-445f-a3f5-1aad40ad75b4
23a93640-3a41-44b9-9f9a-71ee45f7bffb	$1-10 million	8	4	e969a6eb-2819-445f-a3f5-1aad40ad75b4
9c5029ec-f3c0-4a28-be70-433f1a1122cb	No opportunity for innovation	1	1	ec300240-d516-40d4-b9b3-8a23d8f4e951
5641fe2c-a6d2-4434-9d0b-15a1c99bbb22	Potential opportunity	2	2	ec300240-d516-40d4-b9b3-8a23d8f4e951
6c175262-5a0e-4120-b1ac-1fd3d65943ba	Some opportunity	3	3	ec300240-d516-40d4-b9b3-8a23d8f4e951
e047e857-e7d8-468e-8380-d2990f3bc384	Definite opportunity for innovation	4	4	ec300240-d516-40d4-b9b3-8a23d8f4e951
c581d97e-a8de-4456-b124-2b988262a81f	Yes or Not Required	1	1	183b80f2-4688-41fd-ae1c-5a6e7f777c3f
b36e7eff-a464-4417-89b8-0a11ce629fe7	Partially	2	2	183b80f2-4688-41fd-ae1c-5a6e7f777c3f
c21977d3-6311-447b-aea5-0fb7d725326a	No	3	3	183b80f2-4688-41fd-ae1c-5a6e7f777c3f
d0abe350-e32f-427d-b6cc-b22ad1fc9893	In over 24 months	5	5	94ec86da-f955-4e3d-b0ba-932b3044abdb
464f4657-85c0-47b3-8a09-4097d0df174f	In under 1 month	1	1	94ec86da-f955-4e3d-b0ba-932b3044abdb
df250e69-b749-46b8-9aaa-97fca80ce0b0	In 2-6 months	2	2	94ec86da-f955-4e3d-b0ba-932b3044abdb
0c8e249f-bc3a-4b7c-ab30-bebc1b95d0d0	In 7-12 months	3	3	94ec86da-f955-4e3d-b0ba-932b3044abdb
576e0081-9202-47c0-b888-686dd29f820a	In 12-24 months	4	4	94ec86da-f955-4e3d-b0ba-932b3044abdb
beeb71d9-b976-483d-a00b-070d5b648f92	The project involves only one Ministry or Entity.	1	1	1f71e8bc-5b88-40c3-ab99-553368ebf685
ff3978b8-3025-4e2e-aac3-7873b6cc74d9	The project involves two other Ministries or Entities.	2	2	1f71e8bc-5b88-40c3-ab99-553368ebf685
0eeae774-9273-4fa1-bcf4-a0072bf69821	The project involves three other Ministries or Entities.	3	3	1f71e8bc-5b88-40c3-ab99-553368ebf685
7e5e6063-6e37-415e-9367-b2f9ab1c7f5f	The project involves at least four other Ministries or Entities.	4	4	1f71e8bc-5b88-40c3-ab99-553368ebf685
77cb51a1-66e4-4f5e-a2ce-5b8e6600753c	Yes	4	4	c81159f4-42bb-48b1-8338-592df3b43eff
f6319753-11fe-4e28-8ed4-6195a6b9bbb7	No	1	1	c81159f4-42bb-48b1-8338-592df3b43eff
19dc1942-b79f-447b-9004-29f0a299ac6a	Limited	2	2	c81159f4-42bb-48b1-8338-592df3b43eff
087c00f6-9541-413b-b300-a8f3f6e5bd69	Some	3	3	c81159f4-42bb-48b1-8338-592df3b43eff
7748816d-ab15-448d-a4b7-a14476d247d1	The project is a critical priority: all resources necessary will be allocated to it.	1	1	a08e56db-b334-4270-affc-a8f6e2c0fd0a
917b957a-4614-4421-bb32-25f317028005	The project is a normal priority: resources may be shared with a project of equal or higher priority.	3	2	a08e56db-b334-4270-affc-a8f6e2c0fd0a
cd589aa2-f653-4121-abb0-746c54b42a1b	The project is a not a priority: resources may be diverted to a project of equal or higher priority.	5	3	a08e56db-b334-4270-affc-a8f6e2c0fd0a
efe7a811-e2b2-4136-ac76-ad5754236d5c	No	1	1	e11046b5-dfcf-4343-aff8-651670cc783f
c94f6e3a-f9d0-4347-9786-46c439664e99	Yes	3	2	e11046b5-dfcf-4343-aff8-651670cc783f
23815f9c-c74e-4ea6-bade-0da084a3833e	 No, the project is not susceptible.	2	1	ef0491c5-4715-4f97-a314-21c26164a5d2
8bb16bd3-3102-4c3c-9285-53f86a2aee6c	Yes, the project is moderately susceptible; time delays will have minor effects on the schedule.	6	2	ef0491c5-4715-4f97-a314-21c26164a5d2
a7cecc23-7b00-4497-911d-3dffb14498aa	Yes, the project is highly susceptible; time delays will have major effects on the schedule.	10	3	ef0491c5-4715-4f97-a314-21c26164a5d2
169b59d2-c2ba-4e70-90f2-bead560abd6e	No	1	1	7f7cb3f0-7668-438d-97bc-db053ed2e767
bbb4fc0f-a7e8-453e-a9e7-5c0ded9f0f19	Yes	3	2	7f7cb3f0-7668-438d-97bc-db053ed2e767
98a38c05-c026-4c6c-b8d3-bcd0f213b2fe	Directed (sole-source, NOI).	2	1	4b667ac6-0015-46ce-bb49-4b19a8d3c3b3
46a73ee2-4dc5-49dc-a647-23d16fc2cdd9	A standing offer call-up or Supply Arrangement	4	2	4b667ac6-0015-46ce-bb49-4b19a8d3c3b3
147aefa0-34c5-4777-809e-dfcfec232759	A public tender (request for quotation, invitation to tender, request for proposal).	6	3	4b667ac6-0015-46ce-bb49-4b19a8d3c3b3
444707f4-2de0-4e70-a81b-dad881f023f2	Use of new procurement tools (but have been approved by LSB/PSB)	8	4	4b667ac6-0015-46ce-bb49-4b19a8d3c3b3
c28e4b9d-8f45-489e-83af-72c288f4b8d4	Complex process (NRFP, JSRFP, etc...).	10	5	4b667ac6-0015-46ce-bb49-4b19a8d3c3b3
e40d11ff-4c86-4088-bf4c-41af9350afb4	None of the statements are true.	0	1	ee895822-a724-4fe7-9792-4f1f61c7dd95
db3d0033-406f-4e86-91f5-4a974649d806	One of the statements is true.	2	2	ee895822-a724-4fe7-9792-4f1f61c7dd95
09a308f8-3972-4623-865c-37740a21a57e	Two of the statements are true.	4	3	ee895822-a724-4fe7-9792-4f1f61c7dd95
b15d201c-ba31-4bd4-b30a-cd50cfdf4182	Three of the statements are true.	6	4	ee895822-a724-4fe7-9792-4f1f61c7dd95
02b626dd-00f0-4f36-b786-649fa5c69f75	Four of the statements are true.	8	5	ee895822-a724-4fe7-9792-4f1f61c7dd95
9d8f6078-99c6-480f-bb31-c7240121c42d	All Five of the statements are true.	10	6	ee895822-a724-4fe7-9792-4f1f61c7dd95
6e87e312-d7be-4e53-bcf7-c88fb3418a2e	There are qualified suppliers in the market willing to work with the BC Gov and are capable of providing these services	1	1	2cf75e3a-fba2-4202-84f3-f025c47c7f19
a0cf0ff6-68b1-45ee-aabc-d64a8a7459b1	There is a limited number of qualified suppliers in the market or some suppliers are reluctant to work with the BC Gov	3	2	2cf75e3a-fba2-4202-84f3-f025c47c7f19
0e053577-cd27-4523-98ab-a6d9717cf5f8	It is estimated that only one supplier or there are no qualified suppliers that can meet the requirements.	5	3	2cf75e3a-fba2-4202-84f3-f025c47c7f19
cc7e4067-8ede-4e29-bc97-b2403c5ab720	All three criteria are met.	1	1	1c0b9190-ccf9-4239-9209-11d737933a8b
5eef2187-0221-480c-9465-615f9b82fb6b	Two of the three criteria are met.	2	2	1c0b9190-ccf9-4239-9209-11d737933a8b
0b7cff89-3545-4263-baab-a7c08236cb6b	One of the three criteria is met.	3	3	1c0b9190-ccf9-4239-9209-11d737933a8b
e2c212ae-e0ae-4bc2-91fc-5732c195559d	None of the three criteria are met.	4	4	1c0b9190-ccf9-4239-9209-11d737933a8b
e114025b-21c1-44ed-abb6-d5688ec573ec	1	1	1	396d3b41-ac62-48a6-b311-9d06b2d889a5
010e233b-fcc6-45aa-a2c9-8d2c46665e4d	2-5	2	2	396d3b41-ac62-48a6-b311-9d06b2d889a5
1dc52fbd-7f9b-422c-b4f5-53d32e13b431	6-11	3	3	396d3b41-ac62-48a6-b311-9d06b2d889a5
5dd68b4e-ad62-4f36-af5e-bcc7c39c2bcb	12-20	4	4	396d3b41-ac62-48a6-b311-9d06b2d889a5
710fcba6-2467-408e-847b-59d2dac4aa57	20	5	5	396d3b41-ac62-48a6-b311-9d06b2d889a5
d2caec47-98ac-4fdc-bf35-26c33fba33c1	Yes	1	1	af58b76a-bd24-4d98-8db1-8adb2650ed83
6bd6dbd9-7b56-44ab-a4ce-a54dfd3019ad	No	3	2	af58b76a-bd24-4d98-8db1-8adb2650ed83
c63862fb-45a1-4553-bc2d-00a596295fd2	The project fully complies with all applicable policies. Alternatively, the project is not subject to any of these policies.	1	1	ba44a355-b2dc-4c86-b9d0-5a0a68fb55bc
6e423de0-3f4b-4bd2-8b63-b646c0d4e8ba	There are some challenges associated with policy requirements, but the project team is adequately equipped to address these.	2	2	ba44a355-b2dc-4c86-b9d0-5a0a68fb55bc
49c74b7a-5d7a-4efa-86a6-f7c1d6db0f50	There are some challenges associated with policy requirements and there is a lack of confidence that policy requirements can be met on schedule and within the budget.	3	3	ba44a355-b2dc-4c86-b9d0-5a0a68fb55bc
\.


--
-- Data for Name: risk_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.risk_questions (id, question, category, "riskLevel", "questionNo", "is_PSB", "isStrategicContact") FROM stdin;
ee895822-a724-4fe7-9792-4f1f61c7dd95	Are there unique complex variables within this procurement project? Such as: <ul><li>The services currently reside outside of government with a vendor</li><li>There may require a transition from one vendor to another</li><li>There are a small number of individual requirements to define</li><li>There is a potential labour impact to the procurement</li><li>Other high impact unique feature not listed</li></ul>	2	1	7	t	f
2cf75e3a-fba2-4202-84f3-f025c47c7f19	What is the supplier capability and willingness?	2	2	8	t	f
1c0b9190-ccf9-4239-9209-11d737933a8b	Consider the following criteria regarding knowledge and experience:<ul><li>The project will use a proven approach</li><li>This type of project has been done before in the BC Gov</li><li>The project will use resources that have been applied to this type of project before</li></ul>	2	2	9	t	f
a08e56db-b334-4270-affc-a8f6e2c0fd0a	What level of priority is the project to the owning Ministry?	3	2	1	f	f
e11046b5-dfcf-4343-aff8-651670cc783f	Does the organization anticipate a shortage of available internal personnel with appropriate skills during a significant period of the project? (i.e. SME's, PM's, Change Management, etc.)	3	2	2	f	f
396d3b41-ac62-48a6-b311-9d06b2d889a5	How many total people (part-time or full-time on the project, including BC Gov employees and individual contractors) are required to complete this procurement project at its peak activity?	3	2	3	t	f
af58b76a-bd24-4d98-8db1-8adb2650ed83	Has the assigned lead from the project team worked on a project of this size and complexity before?	3	2	4	t	f
e969a6eb-2819-445f-a3f5-1aad40ad75b4	What is the estimated Total Contract Value of this procurement project?	1	1	1	f	f
183b80f2-4688-41fd-ae1c-5a6e7f777c3f	Does this procurement project have a documented project plan with clearly identified Roles & Responsibilities?	1	2	3	f	f
ef0491c5-4715-4f97-a314-21c26164a5d2	Is the project susceptible to time delays? Time delays can have a number of causes, such as the following:<ul><li>Crosses Election periods</li><li>Key timelines happen around End of Fiscal</li><li>Complex Governance Requirements</li><li>Known Capacity Issues</li><li>Timelines are compressed or unattainable</li><li>Involves emerging technologies</li></ul>	1	1	4	t	t
a19f05bd-8172-4994-b991-fc717b0e46f2	Are there any unique socio-economic considerations that must be taken into account?	4	2	1	f	f
7867249a-657a-489a-9203-1754ed8885cc	How many separate contracts are estimated as a result this procurement project?	1	1	2	f	f
94ec86da-f955-4e3d-b0ba-932b3044abdb	When is the expected date of the contract execution or start date?	2	2	1	f	f
1f71e8bc-5b88-40c3-ab99-553368ebf685	How many Ministries or BPS Entities are directly involved in the procurement project?	2	2	2	f	f
ec300240-d516-40d4-b9b3-8a23d8f4e951	Will the resulting contract offer government an opportunity for innovation or modernization?	2	2	3	f	f
c81159f4-42bb-48b1-8338-592df3b43eff	Will the services being procured be public facing?	2	2	4	f	f
7f7cb3f0-7668-438d-97bc-db053ed2e767	Will the procurement result in a contract that is one of a larger bundle of contracts supporting a strategic initiative? (i.e. requires an integrator)	2	2	5	t	t
4b667ac6-0015-46ce-bb49-4b19a8d3c3b3	What is the anticipated procurement approach?	2	1	6	t	t
2d4fd180-ef23-4134-8014-be2ec8ed1ec5	Will there be high public interest in the project?	4	2	2	f	f
ba44a355-b2dc-4c86-b9d0-5a0a68fb55bc	Are there unique challenges to ensure that this project complies with relevant Treasury Board policy requirements, such as those regarding security, GBA+, privacy, and management of government information?	4	2	3	t	f
\.


--
-- Data for Name: timesheet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.timesheet (id, "startDate", "endDate", "userId", "dateCreated", "dateModified", "createdUserId", "modifiedUserId", "hoursAccured", "batchEntryComments", "projectRfxId", "projectId", "mouId") FROM stdin;
d741ca8d-82c8-4bed-81c0-07fed809ab99	2020-04-20	2020-04-26	3e9a3591-d6b2-4b46-a426-5e0872553673	2020-04-23 18:28:35.045	2020-04-23 18:28:35.133	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	2	\N	\N	2d2796cc-4950-4811-abf9-cebd2d9d7f01	2
\.


--
-- Data for Name: timesheet_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.timesheet_entry (id, "hoursBillable", "commentsBillable", "hoursUnBillable", "commentsUnBillable", "expenseCategory", "expenseAmount", "expenseComment", "revenueAmount", "revenueComment", "entryDate", "dateCreated", "dateModified", "timesheetId") FROM stdin;
2e4807cd-1afa-4044-a349-fd81186ffc30	1	Meeting - kick off	0			0		0		2020-04-20	2020-04-23 18:28:35.061	2020-04-23 18:28:35.061	d741ca8d-82c8-4bed-81c0-07fed809ab99
b95dbd54-cbec-43e1-830c-c9e2c13be619	0		0			0		0		2020-04-21	2020-04-23 18:28:35.065	2020-04-23 18:28:35.065	d741ca8d-82c8-4bed-81c0-07fed809ab99
03655fce-a995-4f84-a5d3-bf68fef9214b	0		0			0		0		2020-04-22	2020-04-23 18:28:35.069	2020-04-23 18:28:35.069	d741ca8d-82c8-4bed-81c0-07fed809ab99
d7360999-a89a-4b17-8387-2bc3ce21c4ca	1	Reviewing draft	0			0		0		2020-04-23	2020-04-23 18:28:35.075	2020-04-23 18:28:35.075	d741ca8d-82c8-4bed-81c0-07fed809ab99
1b339798-3695-4c76-a548-9e1dfef218e2	0		0			0		0		2020-04-24	2020-04-23 18:28:35.078	2020-04-23 18:28:35.078	d741ca8d-82c8-4bed-81c0-07fed809ab99
a4d8180f-29d5-4d93-b567-59c935f6d28f	0		0			0		0		2020-04-25	2020-04-23 18:28:35.087	2020-04-23 18:28:35.087	d741ca8d-82c8-4bed-81c0-07fed809ab99
dfd9c9ee-08bc-40b4-8683-2a232e62eb06	0		0			0		0		2020-04-26	2020-04-23 18:28:35.104	2020-04-23 18:28:35.104	d741ca8d-82c8-4bed-81c0-07fed809ab99
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, "referenceId", role, "contactId") FROM stdin;
13669c48-73ee-492e-b1b5-6a168f213d8a	2235259b-0de4-444a-9f02-977cc43b090a	PSB_Admin	a344759c-34c4-4f86-a866-ebdbda1542c8
c246f349-bb5e-4309-861b-706bc6b232c1	c6763223-4022-4e8f-aaae-e98070617bc1	PSB_User	23b536a6-d4af-4f5f-89e2-8a32fd56df2f
cf959cee-2dd8-4a55-97b7-278f0c6740eb	f4b82539-2501-4417-9641-62b4999e1069	PSB_Admin	6ab675ef-1a35-47af-876b-66930b60ea44
fb50980d-45d9-4a50-92c6-1251f573fe6f	2bcc6355-8930-4c81-a282-0f4578f6799a	PSB_Admin	8707dc87-dc37-499c-8b45-95f9ced0697e
60b73394-cdfd-4aba-b557-80fcc8cc9ad6	7ff3c1e9-739b-4e02-aa87-e0d35806ba8b	PSB_Intake_User	52a3c168-0668-4032-9ec9-026ec0c466cb
b9a782bd-39b5-4697-9a4a-9b62737876e2	6211541f-f70d-47d0-9a79-d268685774b5	PSB_Admin	ea6879e9-0a31-4a8b-bea3-405490ea2018
ff341b3b-6c79-421c-951a-0e199f8693d8	b2528999-401e-49b3-bdd0-28c5a835f9e2	PSB_Intake_User	1f2d62d4-10ec-4d69-a99b-f380652e7340
f6b65221-f597-488b-aaa8-bed90aacfaf8	a6e27536-6305-4570-9beb-cc01b1d87e3f	PSB_Admin	09842e3d-ecd7-4735-95cd-507804f9bd37
228e25cb-a091-4c40-9c60-751c784d8852	ff7b3237-c436-461c-bd6a-751c6994eca8	PSB_User	b344cac4-c500-4f3e-9b26-51a49deba756
871a6a46-86f3-4a9c-80aa-518800eed1b6	0c2254e6-4447-43cb-9ce3-498a0ff1d80e	PSB_User	176e34c7-281b-4212-883c-840bfa02def5
3e9a3591-d6b2-4b46-a426-5e0872553673	ce5fe02b-f94c-441c-86ab-6793fc63608f	PSB_Admin	e45fae38-c5de-44b9-9240-7323d310c1f0
5a86fbb4-7707-43b7-88ce-ad77599652ef	a88b4840-5a26-49d0-9454-5ec1bf4da41c	PSB_User	f3ae9b70-5a2c-49c5-bcb2-44283a5aeca3
4877de59-f45e-4970-9deb-cc60e00a8297	5d55a8e8-f083-48b9-afca-31efd2eedb40	PSB_Admin	f584063c-c046-43b6-a13f-ed601e10c079
366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	bf1ce2fd-16fb-4802-8f83-6bd846792726	PSB_Admin	4643b61c-c9cc-4e42-b341-caa8eb4f5ba5
8b436459-b4c6-424b-ad53-ebd55d2e5483	f5d9001c-0219-42fd-8ae9-261ee956efbf	PSB_User	0517039e-6ab3-4343-838f-6d5d9f272ff6
a2127b12-c103-4722-89e3-cbcc8a544245	f4304ffd-8917-49fb-9b21-749d53bcd672	PSB_User	d9276c4d-48bf-4d5d-84f4-6b46fd267e9e
4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ea0882b3-4400-43ed-9cb8-c398d0dffc4d	PSB_User	d0d7d1c5-e037-403d-837c-13c13a07ecfa
2e473e15-454c-4304-96cd-bcf3e5b6e751	ff696268-c440-4dd1-afce-5c3937b97446	PSB_Admin	88368389-6c97-49d4-a97b-7b24dcbb8c38
\.


--
-- Name: mou_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mou_id_seq', 20, true);


--
-- Name: finance_export PK_0d92e1c2af6fd27691bb2e93482; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.finance_export
    ADD CONSTRAINT "PK_0d92e1c2af6fd27691bb2e93482" PRIMARY KEY (id);


--
-- Name: project_risk_analysis PK_0e56d4c967a9a38be3b9edb60ff; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_risk_analysis
    ADD CONSTRAINT "PK_0e56d4c967a9a38be3b9edb60ff" PRIMARY KEY (id);


--
-- Name: project_contacts PK_236cbd14225fcc9fd2d4f150492; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_contacts
    ADD CONSTRAINT "PK_236cbd14225fcc9fd2d4f150492" PRIMARY KEY (id);


--
-- Name: contact PK_2cbbe00f59ab6b3bb5b8d19f989; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT "PK_2cbbe00f59ab6b3bb5b8d19f989" PRIMARY KEY (id);


--
-- Name: project_intake_category PK_2ceebb2f922a894c2daeba97008; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_intake_category
    ADD CONSTRAINT "PK_2ceebb2f922a894c2daeba97008" PRIMARY KEY (id);


--
-- Name: mou PK_2ee8f4a0d31d4dc65247aaa1173; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mou
    ADD CONSTRAINT "PK_2ee8f4a0d31d4dc65247aaa1173" PRIMARY KEY (id);


--
-- Name: rfx_phase PK_3ce9fd57f525975b6d8216c565b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rfx_phase
    ADD CONSTRAINT "PK_3ce9fd57f525975b6d8216c565b" PRIMARY KEY (id);


--
-- Name: rfx_type PK_3e4bfdbaed8d086579d2ff55de8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rfx_type
    ADD CONSTRAINT "PK_3e4bfdbaed8d086579d2ff55de8" PRIMARY KEY (id);


--
-- Name: project_rfx PK_4a2325c0a3919d2765ad97e1575; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_rfx
    ADD CONSTRAINT "PK_4a2325c0a3919d2765ad97e1575" PRIMARY KEY (id);


--
-- Name: project PK_4d68b1358bb5b766d3e78f32f57; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT "PK_4d68b1358bb5b766d3e78f32f57" PRIMARY KEY (id);


--
-- Name: timesheet PK_53c30fa094ae81f166955fb1036; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timesheet
    ADD CONSTRAINT "PK_53c30fa094ae81f166955fb1036" PRIMARY KEY (id);


--
-- Name: project_sector PK_57e9c578e718fcaa8aa908b69b5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_sector
    ADD CONSTRAINT "PK_57e9c578e718fcaa8aa908b69b5" PRIMARY KEY (id);


--
-- Name: procurement_log PK_5ba06c78d1561e2dfedd4bc229b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurement_log
    ADD CONSTRAINT "PK_5ba06c78d1561e2dfedd4bc229b" PRIMARY KEY (id);


--
-- Name: project_intake_contacts PK_705008d4b49f08938edbaf699be; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_intake_contacts
    ADD CONSTRAINT "PK_705008d4b49f08938edbaf699be" PRIMARY KEY (id);


--
-- Name: project_note PK_787a6583b216ce6998c59d324df; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_note
    ADD CONSTRAINT "PK_787a6583b216ce6998c59d324df" PRIMARY KEY (id);


--
-- Name: project_intake PK_8b344c6fb83bbd1d82703c35ddd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_intake
    ADD CONSTRAINT "PK_8b344c6fb83bbd1d82703c35ddd" PRIMARY KEY (id);


--
-- Name: ministry PK_9279166bcd571de7497c6c667a4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ministry
    ADD CONSTRAINT "PK_9279166bcd571de7497c6c667a4" PRIMARY KEY (id);


--
-- Name: client PK_96da49381769303a6515a8785c7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT "PK_96da49381769303a6515a8785c7" PRIMARY KEY (id);


--
-- Name: project_intake_services PK_a20ca2559216afcf851239d7200; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_intake_services
    ADD CONSTRAINT "PK_a20ca2559216afcf851239d7200" PRIMARY KEY (id);


--
-- Name: risk_answers PK_aae9faa57a4133cd358b2d57484; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.risk_answers
    ADD CONSTRAINT "PK_aae9faa57a4133cd358b2d57484" PRIMARY KEY (id);


--
-- Name: user PK_cace4a159ff9f2512dd42373760; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id);


--
-- Name: timesheet_entry PK_d15eefb424abaf5b3e40ee84fc2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timesheet_entry
    ADD CONSTRAINT "PK_d15eefb424abaf5b3e40ee84fc2" PRIMARY KEY (id);


--
-- Name: finance_export_detail PK_e0e73995e6f111440acb1a765d3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.finance_export_detail
    ADD CONSTRAINT "PK_e0e73995e6f111440acb1a765d3" PRIMARY KEY (id);


--
-- Name: risk_questions PK_e97452ff4414803038748911f28; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.risk_questions
    ADD CONSTRAINT "PK_e97452ff4414803038748911f28" PRIMARY KEY (id);


--
-- Name: project FK_015b0718e972ed49dc58408c7ed; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT "FK_015b0718e972ed49dc58408c7ed" FOREIGN KEY ("mouId") REFERENCES public.mou(id);


--
-- Name: project_risk_analysis FK_0f9e3a4e7f09441c8362e26cb5a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_risk_analysis
    ADD CONSTRAINT "FK_0f9e3a4e7f09441c8362e26cb5a" FOREIGN KEY ("intakeId") REFERENCES public.project_intake(id) ON DELETE CASCADE;


--
-- Name: timesheet FK_161ab9490795d0fad5e6102e6d5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timesheet
    ADD CONSTRAINT "FK_161ab9490795d0fad5e6102e6d5" FOREIGN KEY ("mouId") REFERENCES public.mou(id);


--
-- Name: project_intake_contacts FK_1e4bd5793a5e22fa67b7917d92f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_intake_contacts
    ADD CONSTRAINT "FK_1e4bd5793a5e22fa67b7917d92f" FOREIGN KEY ("contactId") REFERENCES public.contact(id);


--
-- Name: client FK_3549926944d21fb6555607755c2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT "FK_3549926944d21fb6555607755c2" FOREIGN KEY ("ministryId") REFERENCES public.ministry(id);


--
-- Name: project_rfx FK_37f9d7945ed8349c0ff66dcb0f9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_rfx
    ADD CONSTRAINT "FK_37f9d7945ed8349c0ff66dcb0f9" FOREIGN KEY ("rfxTypeId") REFERENCES public.rfx_type(id);


--
-- Name: project_intake FK_3ae09619eec7c0f89b4ea61fb6a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_intake
    ADD CONSTRAINT "FK_3ae09619eec7c0f89b4ea61fb6a" FOREIGN KEY ("projectSectorId") REFERENCES public.project_sector(id);


--
-- Name: project_intake_contacts FK_4a4225da3fe11f3d28dd49e8c9d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_intake_contacts
    ADD CONSTRAINT "FK_4a4225da3fe11f3d28dd49e8c9d" FOREIGN KEY ("projectIntakeId") REFERENCES public.project_intake(id) ON DELETE CASCADE;


--
-- Name: project_note FK_4cfb550c87eabbbba4dc29f2206; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_note
    ADD CONSTRAINT "FK_4cfb550c87eabbbba4dc29f2206" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: user FK_6530f8ceb93f81306e5396384e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_6530f8ceb93f81306e5396384e8" FOREIGN KEY ("contactId") REFERENCES public.contact(id);


--
-- Name: timesheet FK_689d5a0fd3a37c30aab320afd8e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timesheet
    ADD CONSTRAINT "FK_689d5a0fd3a37c30aab320afd8e" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: timesheet_entry FK_7186ca70899ada550eaa3d3a87e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timesheet_entry
    ADD CONSTRAINT "FK_7186ca70899ada550eaa3d3a87e" FOREIGN KEY ("timesheetId") REFERENCES public.timesheet(id);


--
-- Name: project FK_816f608a9acf4a4314c9e1e9c66; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT "FK_816f608a9acf4a4314c9e1e9c66" FOREIGN KEY ("clientId") REFERENCES public.client(id);


--
-- Name: project FK_82c4cbf26e020f89e2bc48408b0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT "FK_82c4cbf26e020f89e2bc48408b0" FOREIGN KEY ("projectSectorId") REFERENCES public.project_sector(id);


--
-- Name: project_rfx FK_899c52d7541e2463b7ebd45c1a8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_rfx
    ADD CONSTRAINT "FK_899c52d7541e2463b7ebd45c1a8" FOREIGN KEY ("projectId") REFERENCES public.project(id);


--
-- Name: project_intake FK_a65cf76321439c77291154ba268; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_intake
    ADD CONSTRAINT "FK_a65cf76321439c77291154ba268" FOREIGN KEY ("clientId") REFERENCES public.client(id);


--
-- Name: timesheet FK_ac58894ff3ba9e26707b7528ecd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timesheet
    ADD CONSTRAINT "FK_ac58894ff3ba9e26707b7528ecd" FOREIGN KEY ("projectId") REFERENCES public.project(id);


--
-- Name: timesheet FK_b9f850b4317c75c35e41352f37e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timesheet
    ADD CONSTRAINT "FK_b9f850b4317c75c35e41352f37e" FOREIGN KEY ("projectRfxId") REFERENCES public.project_rfx(id);


--
-- Name: risk_answers FK_be4bf934acdbd2638c29581d5ad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.risk_answers
    ADD CONSTRAINT "FK_be4bf934acdbd2638c29581d5ad" FOREIGN KEY ("questionId") REFERENCES public.risk_questions(id);


--
-- Name: project_risk_analysis FK_c69ab3c35f5af8199bf3d3ba9d3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_risk_analysis
    ADD CONSTRAINT "FK_c69ab3c35f5af8199bf3d3ba9d3" FOREIGN KEY ("questionId") REFERENCES public.risk_questions(id);


--
-- Name: project_risk_analysis FK_d8b3ef0cf2a1648227b1a67ea68; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_risk_analysis
    ADD CONSTRAINT "FK_d8b3ef0cf2a1648227b1a67ea68" FOREIGN KEY ("answerId") REFERENCES public.risk_answers(id);


--
-- Name: project_rfx FK_e430e93c72264192fa1513bcb1e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_rfx
    ADD CONSTRAINT "FK_e430e93c72264192fa1513bcb1e" FOREIGN KEY ("rfxPhaseId") REFERENCES public.rfx_phase(id);


--
-- Name: project_contacts FK_f2bcd595eadd56fe9154293498f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_contacts
    ADD CONSTRAINT "FK_f2bcd595eadd56fe9154293498f" FOREIGN KEY ("projectId") REFERENCES public.project(id);


--
-- Name: project_intake FK_f6f78ac927456aa60e34ce3ebbe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_intake
    ADD CONSTRAINT "FK_f6f78ac927456aa60e34ce3ebbe" FOREIGN KEY ("mouId") REFERENCES public.mou(id);


--
-- Name: project_contacts FK_fca0f0f1821f96b43ca534d8d85; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_contacts
    ADD CONSTRAINT "FK_fca0f0f1821f96b43ca534d8d85" FOREIGN KEY ("contactId") REFERENCES public.contact(id);


--
-- Name: finance_export_detail FK_ff297ca3ec8c094f2a1e426bc82; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.finance_export_detail
    ADD CONSTRAINT "FK_ff297ca3ec8c094f2a1e426bc82" FOREIGN KEY ("financeExportId") REFERENCES public.finance_export(id);


--
-- PostgreSQL database dump complete
--

