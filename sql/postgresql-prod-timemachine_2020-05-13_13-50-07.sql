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
    "hourlyRate" integer,
    "revenueRate" integer
);


ALTER TABLE public.contact OWNER TO postgres;

--
-- Name: finance_export; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.finance_export (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "documentNo" text NOT NULL,
    "totalAmount" double precision,
    "projectId" uuid,
    "dateCreated" timestamp without time zone,
    "createdUserId" uuid,
    "exportData" json NOT NULL,
    "documentPath" text,
    "monthStartDate" date
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
    "is_PSB" boolean,
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
    "mouId" integer,
    is_locked boolean,
    "amountBilled" double precision
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
    "timesheetId" uuid,
    "revenueHours" double precision
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
a61cb016-8904-4fa6-9e78-98741fad9df8	\N	\N	\N	\N	\N	PSB		563 Superior St		Victoria			111111	2020-04-29 22:54:04.946	2020-04-29 22:54:04.946	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
67c8fc33-db70-4d84-a971-9476d35ce67b	128	7124B	30146	6001	7100000	IM/IT Investment Governance and Business Strategy		PO Box 9364 Stn Prov Govt		Victoria			V8W9M3	2020-04-22 17:19:28.156	2020-04-22 17:27:30.503	f	\N	2d1d2bef-f635-4e6c-98ae-ad643066b867
bd036bdb-8c83-45bd-979a-13763c5d592b	067	32p01	35102	3104	3200000	Asset Investment Recovery		.		.			.	2020-04-22 17:07:58.242	2020-04-22 18:13:08.875	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
f10093b5-a868-4db5-a23c-775070e3a30b	128	71602	30660	6300	7100000	Habitat and Wildlife		PO BOX 9391	PO BOX 9391 STN PROV GOV'T	Victoria			V8W9M3	2020-04-24 15:52:18.769	2020-04-24 16:50:56.85	f	\N	9c7bfdf2-abea-4874-af40-4a6c30d3f38e
20720905-a3ae-4bf9-a139-c9526b11fd99	010	15704	11761	6397	15MODDI	BCCS		Burnaby		Burnaby			V8x 3z2	2020-04-24 18:26:01.346	2020-04-24 18:26:01.346	f	\N	0b983c7e-cce9-442f-bd3a-8e8e3afb12fb
9c539e7c-de5a-49eb-92e7-c28b8c9838ff	112	32683	20052	6101	3200000	Workplace Technology Solutions		4000 Seymour Place 		Victoria 			V8X 4S7	2020-04-22 18:28:30.526	2020-04-22 19:10:12.457	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
68027b50-b39c-41bc-a299-2fb459855c87	\N	\N	\N	\N	\N	PSB		563 Superior St		Victoria 			111111	2020-05-05 23:25:18.324	2020-05-05 23:25:18.324	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
90c9c475-cf6d-429f-a8a5-7da8e3b58db1	105	15163	10740	6912	1500000	BC Sheriffs Service		6th Floor, 850 Burdett Avenue		Victoria			V8W 9J7	2020-04-22 18:22:19.532	2020-04-22 20:23:44.265	f	\N	a068619a-3cde-4530-ba60-c76ebf105ee4
26d63cf2-b2f4-41ea-810d-64e67fc969ce	128	71602	30660	6300	7100000	Wildlife and Habitat		.		Victoria			.	2020-04-22 20:41:07.765	2020-04-22 20:41:07.765	f	\N	9c7bfdf2-abea-4874-af40-4a6c30d3f38e
2f0f69cc-06cd-448f-b325-c0f63edbb856	067	32p01	35018	6101	3200000	DCV		724 Vanalman Ave		Victoria			V8Z 3B5	2020-04-22 21:16:30.587	2020-04-22 21:19:35.77	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
e217c260-02cc-4ffc-aedd-9257c055519e	048	29008	30533	6001	2900000	Climate Action Secretariate		.		.			.	2020-04-22 21:27:41.233	2020-04-22 21:35:08.641	f	\N	2d1d2bef-f635-4e6c-98ae-ad643066b867
fd54eb6c-3aaa-47be-9c65-678a8c6a3aa8	067	32p01	20434	6501	3200000	Protocol		.		.			.	2020-04-22 21:47:22.919	2020-04-22 21:49:10.163	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
441d079e-79a2-4bee-9bed-5599631761d1	067	32p01	35102	6101	3200000	Asset investment recovery		.		.			.	2020-04-22 21:54:03.55	2020-04-22 21:55:22.803	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
a14b3e69-8422-4069-a20f-84b2db82a7f5	067	32p01	35046	6101	3200000	BC Mail Plus		1150 McKenzie Ave		Victoria			v8W 9V7	2020-04-22 21:59:58.354	2020-04-22 22:01:06.461	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
5d499cd7-3ae6-45e4-9fb2-688745dc1757	105	15301	11000	6397	15CEDIS	BC Prosecution Services		PO Box 9276 Stn. Prov. Govt.  		Victoria, BC 			V8W 9J7	2020-04-23 23:10:57.961	2020-04-24 18:30:51.919	f	\N	a068619a-3cde-4530-ba60-c76ebf105ee4
eff4b409-bda6-4a50-aaf9-7c1e4c310173	112	32346	20001	6101	3200000	Hosting Services Re-Procurement Project Branch		4000 Seymour Place		Victoria			V8X 4S7	2020-05-01 21:55:52.544	2020-05-01 21:58:18.999	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
cef833f6-8425-45e2-849d-e70a580bc417	112	32336	34809	6598	3200000	ICT		4000 Seymour Place, 		Victoria			V8X4S7	2020-04-24 18:23:15.926	2020-04-24 18:45:52.503	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
f09638be-14dc-4463-bcdd-7ec4e4b4d3e0	\N	\N	\N	\N	\N	PSB		563 Superior St		Victoria			aaaaaa	2020-05-05 23:28:42.481	2020-05-05 23:28:42.481	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
bbe38f61-7286-4eff-8b85-7e5537a6e056						TI Corp		1100-401 W Georgia		Vancouver			V6E3P3	2020-04-27 16:44:41.195	2020-04-27 16:44:41.195	f	\N	6cd580b7-6d9a-492b-96b3-43a0cffd1e5a
ae577ef5-ff64-47c0-8350-779fb8ec7fa1	\N	\N	\N	\N	\N	PSB		563 Superior St		Victoria			1	2020-05-05 23:31:52.041	2020-05-05 23:31:52.041	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
5fe63915-6979-47b9-a701-cad9d87f5de2	112	32791	20052	6101	3200000	Information Security Branch		4000 Seymour Place		Victoria			V8X 4S7	2020-05-01 22:16:22.93	2020-05-01 22:18:21.9	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
ebff8e7a-322e-4879-983c-88cba8b50e5e	128	71479	42000	6001	71WBW00	BC Wildfire Services		Jutland 		Victoria			V2N 6R7	2020-04-23 01:29:49.314	2020-05-01 01:33:45.736	f	\N	9c7bfdf2-abea-4874-af40-4a6c30d3f38e
6f5521be-ca24-4c99-a308-da66eee67993	048	296B2	31200	6910	2950442	BC Parks		Ministry of Environment and Climate Change Strategy	BC Parks 525 Superior St, Victoria, BC	Victoria			V8V 1T7 	2020-04-23 19:18:19.021	2020-04-29 18:46:06.451	f	\N	2d1d2bef-f635-4e6c-98ae-ad643066b867
f3175941-89af-4409-881c-6d560d1f2739	\N	\N	\N	\N	\N	PSB		563 Superior St		Victoria			a	2020-05-05 23:35:04.585	2020-05-05 23:35:04.585	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
1f71980e-7616-4412-a11b-1347ce43f37f	111	11111	11111	1111	1111111	TI Corp		Suite 1750 – 401 West Georgia 		Vancouver  			V6B 5A1	2020-04-22 17:20:34.531	2020-04-29 22:36:56.99	f	\N	6cd580b7-6d9a-492b-96b3-43a0cffd1e5a
afd9d57c-cd78-4986-93d5-1a06d8000c36	109	11225	18110	6001	1100000	Post Secondary Programs		835 Humboldt St, 		Victoria			V8W9B5	2020-04-29 22:44:18.485	2020-04-29 22:44:18.485	f	\N	785d6467-90f2-4e07-a102-59ced3d9fd51
fae0508c-a5e6-4610-9bcf-6f0b500f76ce	128	7124B	30146	6001	7100000	Information Innovation and Technology Division 		2975 Jutland Road		Victoria			V8W9M1 	2020-04-28 21:06:25.049	2020-05-04 15:28:06.795	f	\N	2d1d2bef-f635-4e6c-98ae-ad643066b867
cbb802a9-2480-4bd6-862e-6484d611bce2	112	32686	20029	6101	3200342	OCIO, NCCS		4000 Seymour Pl		Victoria			V8X 4S8	2020-04-28 16:42:37.692	2020-05-05 17:21:04.886	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
fe331179-3f09-4db0-b85d-53e6086fc8ed	\N	\N	\N	\N	\N	Procurement Services Branch		563 Superior St		Victoria			V8V 0C5	2020-05-01 05:07:03.276	2020-05-01 05:22:46.496	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
b3a6e117-436e-4fda-ae24-956516473a80	\N	\N	\N	\N	\N	Procurement Services Division		563 Superior St		Victoria			V8V 0C5	2020-04-30 23:22:08.883	2020-05-01 05:23:52.06	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
5bf36e16-5dca-42ca-b381-2600fbde5002	128	71901	31218	8598	7100000	Rural Development Rural Policy and Program Branch		2975 Jutland		Victoria			V8W9M1	2020-04-29 21:05:06.768	2020-05-01 10:07:16.238	f	\N	9c7bfdf2-abea-4874-af40-4a6c30d3f38e
a587ddb4-9574-44ef-9c51-7612f99eb5b7	031	46T03	50223	6001	4600000	Health Assistance		PO Box 9058 Stn Prov Govt		Victoria			V8W 9E2	2020-05-05 18:14:16.849	2020-05-05 18:14:16.849	f	\N	d4975e8a-d359-4e29-9b4a-8b0211dc5e7d
e5176800-b29b-4cf4-bbcf-a2c2774e00b6	022	32348	34420	6502	3200000	GCPE		617 Government St		Victoria			V8W 9V1	2020-04-30 21:30:58.86	2020-05-01 21:28:23.559	f	\N	4ec3bf77-1da6-4b86-b830-7e590e9b8924
5a9c55de-0566-41ba-b28f-eacabe351135	068	2941r	47234	6071	2913203	Environmental Sustainability & Strategy Policy Div		PO Box 9335 Stn Pov Govt		Victoria			V8w9m1	2020-04-22 22:14:14.503	2020-05-05 19:54:07.459	f	\N	bbb34129-f7c2-4b17-ab63-218f920fbd04
95bfabe1-898a-428f-b865-cff52ca883a3	\N	\N	\N	\N	\N	PSB		563 Superior St		Victoria			111111	2020-05-05 22:15:34.555	2020-05-05 22:15:34.555	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
4626e83d-0c05-4a4c-a54c-5113bb33bcd4	\N	\N	\N	\N	\N	.		675 Belleville Street		Victoria			V8W 8W2	2020-05-06 16:22:56.758	2020-05-06 16:25:03.897	t	Royal BC Museum	\N
347e946b-7a5e-45ae-8942-083237fdd31f	112	32m06	25004	8585	3200000	WDS		4000 Seymour Place		Victoria			.	2020-05-06 16:37:41.982	2020-05-06 16:45:57.85	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
b796d999-023a-4ad5-a02a-80bcc0330900	\N	\N	\N	\N	\N	Distribution Centre Victoria		536 Superior St		Victoria 			111111	2020-05-06 23:27:08.694	2020-05-06 23:27:08.694	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
39536cc1-45fc-4274-9e0d-26a78d743f23	022	32193	34272	6398	3231183	Consumer Taxation Programs Branch		2 - 940 Blanshard Street		Victoria			V8W 3E6	2020-05-07 13:02:47.635	2020-05-07 13:02:47.635	f	\N	4ec3bf77-1da6-4b86-b830-7e590e9b8924
3bda62ba-b1ce-4610-a1e5-38b0546eb06b	\N	\N	\N	\N	\N	PSB		563 Superior Street		Victoria			.	2020-05-07 16:28:50.489	2020-05-07 16:28:50.489	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
6e995550-e598-4e6b-88b9-30f6e6f013a7	\N	\N	\N	\N	\N	PSB		563 Superior Street		victoria			.	2020-05-07 16:32:06.848	2020-05-07 16:32:06.848	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
4840b860-dca8-4806-83e0-c9bd415909f9	\N	\N	\N	\N	\N	PSB		563 Superior Street		Victoria			.	2020-05-07 16:35:37.429	2020-05-07 16:35:37.429	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
5284d7f4-0e5f-4222-8509-f153ee4fb563	\N	\N	\N	\N	\N	PSB		563 Superior Street		Victoria			.	2020-05-07 16:38:41.836	2020-05-07 16:38:41.836	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
2f60f58b-2834-4678-872a-69eb305ed8d5	\N	\N	\N	\N	\N	PSB		563 Superior Street		Victoria			.	2020-05-07 16:41:25.648	2020-05-07 16:41:25.648	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
d17fbefd-fd59-46f2-85b5-1a5bde73b813	\N	\N	\N	\N	\N	.		.		.			.	2020-05-07 17:49:50.072	2020-05-07 17:49:50.072	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
04c55139-fdc0-477c-9832-67cabc8cd639	\N	\N	\N	\N	\N	PSB		.		.			.	2020-05-07 20:40:26.014	2020-05-07 20:40:26.014	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
e10e3798-494b-4442-844c-aee16e398602	\N	\N	\N	\N	\N	PSB		.		.			.	2020-05-07 20:48:10.083	2020-05-07 20:48:10.083	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
86afd08b-6e98-4377-83fd-de9e35a361d2	\N	\N	\N	\N	\N	PSB		.		.			.	2020-05-07 20:53:15.148	2020-05-07 20:53:15.148	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
6600441d-112e-44e6-b082-2fb450d6ed58	\N	\N	\N	\N	\N	PSB		.		.			.	2020-05-07 20:55:41.097	2020-05-07 20:55:41.097	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
8ffa6cb3-0d66-4e60-b0b7-41afa899981c	\N	\N	\N	\N	\N	PSB		.		.			.	2020-05-07 21:00:25.441	2020-05-07 21:00:25.441	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
2f5c2ec9-3337-4ae1-a199-6fee0b25c457	\N	\N	\N	\N	\N	OCIO		.		.			.	2020-05-11 17:35:15.154	2020-05-11 17:35:15.154	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
f62f21ca-4f27-4c07-a26c-9301b20c3990	NA1	NA123	NA123	NA12	NA12345	Procurement and Supply Division		563 Superior St		Victoria			V8V 0C5	2020-05-12 22:51:36.534	2020-05-12 22:54:22.197	f	\N	3c626277-3298-4bed-ae08-ceca3039362f
2ddbe0a3-cac2-4a27-af39-feadff5df1c4	010	15668	11610	6001	1500000	Public Safety & Policing Branch		405-815 Hornby Street 		Vancouver 			V6Z 2E6	2020-05-13 19:20:37.389	2020-05-13 19:20:37.389	f	\N	0b983c7e-cce9-442f-bd3a-8e8e3afb12fb
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact (id, "contactType", "fullName", "orgName", "orgPosition", email, "phoneNumber", "addressLine1", "addressLine2", city, province, country, "postalCode", "roleName", "dateCreated", "dateModified", "hourlyRate", "revenueRate") FROM stdin;
8707dc87-dc37-499c-8b45-95f9ced0697e	user	Adam Coard	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 21:19:56.237	2020-04-21 21:19:56.237	\N	\N
3d968515-bdbc-457f-bfc9-a350ff99527b	clientlead	Varous	WDS	.	jerry.gauthier@gov.bc.ca	2501111111							\N	2020-04-22 16:57:58.616	2020-04-22 16:57:58.616	\N	\N
846bfd99-259e-4f09-b97f-861f413d134a	clientsponsor	Sunny Daliwal	WDS	ADM	jerry.gauthier@gov.bc.ca	2501111111							\N	2020-04-22 16:57:58.631	2020-04-22 16:57:58.631	\N	\N
c42a2098-4559-4e9a-867c-4d865d961610	clientfinance												\N	2020-04-22 16:57:58.634	2020-04-22 16:57:58.634	\N	\N
ea526c93-bfe2-4b46-b337-1d10bb59a4a9	clientlead	Jacoba Corrigal	Information, Innovation and Technology Division	Senior Procurement/Contract Specialist	jacoba.corrigal@gov.bc.ca	7786983112							\N	2020-04-22 17:19:28.215	2020-04-22 17:19:28.215	\N	\N
ff35de9f-9b3b-4c4f-8bf8-1d72a550485f	clientsponsor	Jacoba Corrigal	Information, Innovation and Technology Division	Senior Procurement/Contract Specialist	jacoba.corrigal@gov.bc.ca	7786983112							\N	2020-04-22 17:19:28.222	2020-04-22 17:19:28.222	\N	\N
69e14066-dfe5-48d5-93c7-243fba7b85b3	clientfinance												\N	2020-04-22 17:19:28.291	2020-04-22 17:19:28.291	\N	\N
a3a9928e-561d-4b71-9744-398d98692366	clientlead	Melissa Strain	BC Sheriffs Service	Manager	Melissa.Strain@gov.bc.ca	2505896861							\N	2020-04-22 18:22:19.709	2020-04-22 18:22:19.709	\N	\N
76849d01-3fee-4204-88df-3d026c3de8c8	clientsponsor	Ross McKenna	BC Sheriffs Service	Director of Provincial Programs	Ross.McKenna@gov.bc.ca	6046605583							\N	2020-04-22 18:22:19.723	2020-04-22 18:22:19.723	\N	\N
53393e30-7a21-40d8-89c3-91f1c65aab6f	clientfinance												\N	2020-04-22 18:22:19.728	2020-04-22 18:22:19.728	\N	\N
e45fae38-c5de-44b9-9240-7323d310c1f0	user	Arlin Friesen	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 17:10:39.019	2020-04-22 18:23:39.222	120	\N
176e34c7-281b-4212-883c-840bfa02def5	user	Bryn Johns	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 16:58:52.68	2020-04-22 18:23:42.678	100	\N
23b536a6-d4af-4f5f-89e2-8a32fd56df2f	user	Gajanan Pujar	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 21:19:16.076	2020-04-22 18:23:45.125	100	\N
f3ae9b70-5a2c-49c5-bcb2-44283a5aeca3	user	Gord Rogers	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 17:59:57.822	2020-04-22 18:23:47.34	100	\N
b344cac4-c500-4f3e-9b26-51a49deba756	user	James Ragan	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 16:13:28.353	2020-04-22 18:23:49.658	100	\N
09842e3d-ecd7-4735-95cd-507804f9bd37	user	Jason George	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 16:11:51.57	2020-04-22 18:23:51.732	120	\N
52a3c168-0668-4032-9ec9-026ec0c466cb	user	Kathy Jack	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 22:20:37.986	2020-04-22 18:23:53.921	100	\N
4643b61c-c9cc-4e42-b341-caa8eb4f5ba5	user	Michael Mulder	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 18:09:37.761	2020-04-22 18:23:56.219	120	\N
ea6879e9-0a31-4a8b-bea3-405490ea2018	user	Michelle McKinnon	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 15:58:30.873	2020-04-22 18:23:58.122	120	\N
1f2d62d4-10ec-4d69-a99b-f380652e7340	user	Ruth-Ann Webster	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 16:04:03.74	2020-04-22 18:24:00.221	100	\N
f584063c-c046-43b6-a13f-ed601e10c079	user	Sandeep Sahota	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-22 18:04:55.659	2020-04-22 18:24:02.118	120	\N
6ab675ef-1a35-47af-876b-66930b60ea44	user	Tracy Harris	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 21:19:50.094	2020-04-22 18:24:08.778	120	\N
d6cfc8af-0a67-4095-8d99-057228d16f1e	clientlead	Stu Hackett	Ministry of Citizens' Services	Executive Director	Stuart.Hackett@gov.bc.ca	2505142779							\N	2020-04-22 18:28:30.621	2020-04-22 18:28:30.621	\N	\N
46afe217-22b8-48b6-8142-508512f80018	clientsponsor	Bobbi Sadler	Ministry of Citizens' Services	Assistant Deputy Minister	bobbi.sadler@gov.bc.ca	2508865062							\N	2020-04-22 18:28:30.634	2020-04-22 18:28:30.634	\N	\N
b6808d7a-97b6-4ec4-b3f9-16555d46f1ed	clientfinance												\N	2020-04-22 18:28:30.64	2020-04-22 18:28:30.64	\N	\N
bab69975-a938-4d52-97d2-6c378d346b9e	clientlead	Mark McKamey	FLNROD - Habitat and Wildlife Branch	Senior Policy Analyst	Mark.McKamey@gov.bc.ca	7789742742							\N	2020-04-22 20:41:07.793	2020-04-22 20:41:07.793	\N	\N
0bf18159-89ab-4593-a5c2-defbe6dc51ee	clientsponsor	.	FLNROD - Habitat and Wildlife Branch	.	Mark.McKamey@gov.bc.ca	7789742742							\N	2020-04-22 20:41:07.799	2020-04-22 20:41:07.799	\N	\N
015ab727-e4f2-4402-aaf8-cbc30827a949	clientfinance												\N	2020-04-22 20:41:07.854	2020-04-22 20:41:07.854	\N	\N
8e76b806-ced5-474e-a51b-239cd43a2cfe	clientlead	Darryl Hansen	AIR	Operations Manger	Darryl.hansen@gov.bc.ca	7786989912							\N	2020-04-22 17:07:58.263	2020-04-22 20:56:01.379	\N	\N
a85184f1-c079-40e3-b3b1-d0be77abf233	clientsponsor	Greg Lamb	AIR, DCV	Assistant Director	greg.lamb@gov.bc.ca	7786989851							\N	2020-04-22 17:07:58.27	2020-04-22 20:56:01.393	\N	\N
b793367b-c15e-4376-8f3b-4a34605e7400	clientfinance												\N	2020-04-22 17:07:58.275	2020-04-22 20:56:01.404	\N	\N
1fec9b37-843d-4fe0-ab25-86728a0a0fae	clientlead	Cory Bate	DCV	Operations Manager	cory.bate@gov.bc.ca	2509524462							\N	2020-04-22 21:16:30.929	2020-04-22 21:16:30.929	\N	\N
b9f14763-733a-491d-8764-88475d17ecbc	clientsponsor	.	.	.	no.one@gov.bc.ca	2501111111							\N	2020-04-22 21:16:30.963	2020-04-22 21:16:30.963	\N	\N
634418ee-7e13-474b-b702-88a309dc1103	clientfinance												\N	2020-04-22 21:16:30.975	2020-04-22 21:16:30.975	\N	\N
0ff81989-e9d2-4a1d-baee-b6d10d22ae39	clientlead	Kim Tiffin	.	.	kim.tiffin@gov.bc.ca	7789743919							\N	2020-04-22 21:27:41.253	2020-04-22 21:27:41.253	\N	\N
b8b46117-65cb-4591-9604-495422427320	clientsponsor	Kim Tiffin	CAS	manager	kim.tiffin@gov.bc.ca	7789743919							\N	2020-04-22 21:27:41.26	2020-04-22 21:27:41.26	\N	\N
71d1d3d1-24a0-434f-ba55-06eab2a76b66	clientfinance												\N	2020-04-22 21:27:41.264	2020-04-22 21:27:41.264	\N	\N
0cdc5dad-cffd-4663-9903-00590eaa71be	clientlead	Jacquie Driesen	Citizens Services	Administrator	jacquie.driesen@gov.bc.ca	2503656183							\N	2020-04-22 21:47:22.935	2020-04-22 21:47:22.935	\N	\N
499b37a4-b05a-4d6d-8161-c58266a25155	clientsponsor	Jacquie Driesen	Citizens' services	Administrator	jacquie.driesen@gov.bc.ca	2503656183							\N	2020-04-22 21:47:22.94	2020-04-22 21:47:22.94	\N	\N
9cfc5a3c-919d-4307-b9e3-54f0f850bdf8	clientfinance												\N	2020-04-22 21:47:22.943	2020-04-22 21:47:22.943	\N	\N
0e7cb963-26b7-4d32-a9c5-054b2f0aff68	clientlead	Darryl Hansen	.	.	darryl.hansen@gov.bc.ca	7786989912							\N	2020-04-22 21:54:03.574	2020-04-22 21:54:03.574	\N	\N
59c4d2e0-99a3-462e-afbf-6b815fc18500	clientsponsor	Darryl Hansen	.	.	darryl.hansen@gov.bc.ca	2501111111							\N	2020-04-22 21:54:03.583	2020-04-22 21:54:03.583	\N	\N
a3bbc881-2635-413b-b393-87c830f0c11c	clientfinance												\N	2020-04-22 21:54:03.587	2020-04-22 21:54:03.587	\N	\N
f36adf1c-6dc1-4769-9a46-19dd0a6b75cf	clientlead	Sean Johnson	.	.	sean.johnson@gov.bc.ca	2509525130							\N	2020-04-22 21:59:58.375	2020-04-22 21:59:58.375	\N	\N
b8b2bf6f-c50c-4774-bd4d-2045d1a2bc64	clientsponsor	Sean Johnson	.	.	sean.johnson@gov.bc.ca	2509525130							\N	2020-04-22 21:59:58.389	2020-04-22 21:59:58.389	\N	\N
72ebbd26-e4a2-495e-abda-5413f2c92e83	clientfinance												\N	2020-04-22 21:59:58.393	2020-04-22 21:59:58.393	\N	\N
d95bc8be-deb9-4bbe-a12a-1eb964497872	clientlead	Joyce Austin	.	.	joyce.austin@gov.bc.ca	2501111111							\N	2020-04-22 22:14:14.525	2020-04-22 22:14:14.525	\N	\N
467b9a1f-6e80-4390-82bc-b7ab1a5f460a	clientsponsor	Joyce Austin	.	.	joyce.austin@gov.bc.ca	2501111111							\N	2020-04-22 22:14:14.531	2020-04-22 22:14:14.531	\N	\N
008d9c46-9f4a-4582-91f0-6c08cbf2459b	clientfinance												\N	2020-04-22 22:14:14.535	2020-04-22 22:14:14.535	\N	\N
13ed96d7-f082-4745-81e9-31b4d895c0bf	clientlead	Neil Arreza	BCWS	Procurement Lead	neil.arreza@gov.bc.ca	7789745716							\N	2020-04-23 01:29:49.347	2020-04-23 01:29:49.347	\N	\N
4c3d402f-f970-4e21-8120-e7411ae8d9d5	clientsponsor	Diane Ross	BCWS	Director, Finance	diane.ross@gov.bc.ca	7789745725							\N	2020-04-23 01:29:49.352	2020-04-23 01:29:49.352	\N	\N
5e6d47db-ee28-4416-9283-f1d2ab641747	clientfinance	Diane Ross											\N	2020-04-23 01:29:49.356	2020-04-23 01:29:49.356	\N	\N
d9276c4d-48bf-4d5d-84f4-6b46fd267e9e	user	Collin Lord	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 23:01:15.068	2020-04-23 18:30:23.743	100	\N
23e3cd97-345a-40bf-b698-02fce7b0c1e5	clientlead	Elyse Guzek	BC Parks Regional Operations	Student Ranger Program Coordinator	Elyse.Guzek@gov.bc.ca	7786981599							\N	2020-04-23 19:18:19.087	2020-04-23 19:18:19.087	\N	\N
81ca2106-9562-49f3-9224-99c4dd54e827	clientlead	Geoff Rice	Finance and Management Services Department	Project Manager	Geoff.Rice@gov.bc.ca	6132030840							\N	2020-04-22 17:20:34.565	2020-04-29 22:37:06.579	\N	\N
077dd07e-5d01-4268-973f-94ed86a37121	clientsponsor	Dave Stewart	Finance and Management Services Department	CFO	dave.stewart@ticorp.ca	7789745414							\N	2020-04-22 17:20:34.571	2020-04-29 22:37:06.78	\N	\N
23c5ca18-cee6-4b87-bb4a-66460aee5ca4	clientfinance	Sharon Cowden	MOTI 	Manager, Finance and Administrative Services	Sharon.Cowden@gov.bc.ca	7789745377							\N	2020-04-22 17:20:34.576	2020-04-29 22:37:06.787	\N	\N
d0d7d1c5-e037-403d-837c-13c13a07ecfa	user	Jerry Gauthier	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-23 18:41:38.519	2020-05-12 23:05:30.974	100	\N
0517039e-6ab3-4343-838f-6d5d9f272ff6	user	Prince Varghese	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-23 16:30:30.816	2020-05-12 23:05:52.661	100	\N
a344759c-34c4-4f86-a866-ebdbda1542c8	user	Zachary Woodward	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-21 21:19:00.731	2020-05-12 23:06:01.299	\N	\N
73d93e32-6d7e-4552-b4a1-6a8225a20a69	clientsponsor	Bob Austad	BC Parks and Conservation Officer Service Division	Executive Director, Regional Operations Branch, BC Parks	Bob.Austad@gov.bc.ca	7786984281							\N	2020-04-23 19:18:19.102	2020-04-23 19:18:19.102	\N	\N
99a23a1b-4a2b-4ade-a5ae-fec518edb751	clientfinance												\N	2020-04-23 19:18:19.131	2020-04-23 19:18:19.131	\N	\N
c26ca145-4876-4bff-b8d1-fdf877f1f3b8	clientlead	Michelle Clough	BC Prosecution Service	CDS Project Director	Michelle.Clough@gov.bc.ca	7786988294							\N	2020-04-23 23:10:58.336	2020-04-23 23:10:58.336	\N	\N
979e8055-f884-439b-9741-2687c0ea7700	clientsponsor	Michelle Clough	BC Prosecution Service	CDS Project Director	Michelle.Clough@gov.bc.ca	7786988294							\N	2020-04-23 23:10:58.347	2020-04-23 23:10:58.347	\N	\N
2a3ab891-3ef7-4488-96d8-8b00238c2519	clientfinance												\N	2020-04-23 23:10:58.351	2020-04-23 23:10:58.351	\N	\N
55024d8a-7a6f-4249-82ed-114180db41c8	clientlead	Mark McKamey	FLNROD	Senior Policy Analyst	Mark.McKamey@gov.bc.ca	7789742742							\N	2020-04-24 15:52:19.158	2020-04-24 15:52:19.158	\N	\N
6f3fae5d-9967-4018-bb2d-f5a01a8c177e	clientsponsor	Jennifer Psyllakis	FLNROD	Director	Jennifer.Psyllakis@gov.bc.ca	2503875657							\N	2020-04-24 15:52:19.28	2020-04-24 15:52:19.28	\N	\N
d4ae139e-82d9-4ccc-ad0f-09b026e68432	clientfinance												\N	2020-04-24 15:52:19.285	2020-04-24 15:52:19.285	\N	\N
edf89f50-7b4d-4b2d-b03e-b0518d4aad25	clientlead	Luis Sanchez	ICT	Senior Telecom Specialist	luis.sanchez@gov.bc.ca	2508807886							\N	2020-04-24 18:23:16.945	2020-04-24 18:23:16.945	\N	\N
3c0c2dda-c68f-432f-baa0-d6329900224e	clientsponsor	Roman Mateyko	ICT	Executive Director	roman.mateyko@gov.bc.ca	2508807886							\N	2020-04-24 18:23:16.99	2020-04-24 18:23:16.99	\N	\N
ce611836-b270-471a-9738-711bcc991874	clientfinance	Heidi Klotz			heidi.klotz@gov.bc.ca								\N	2020-04-24 18:23:17.004	2020-04-24 18:23:17.004	\N	\N
8697899d-37a2-4ce0-a6c6-43d87b42ee15	clientlead	Tej Sidu	BCCS	Director, Policy/Research/Systems	tej.sidhu@gov.bc.ca	6043986100							\N	2020-04-24 18:26:01.371	2020-04-24 18:26:01.371	\N	\N
473a88a9-5cae-4067-9c92-3e25c2fded84	clientsponsor	other	BCCS	other	tej.sidhu@gov.bc.ca	6043986100							\N	2020-04-24 18:26:01.378	2020-04-24 18:26:01.378	\N	\N
0ce13432-f9c5-4615-95e0-a799e98f4dc0	clientfinance												\N	2020-04-24 18:26:01.382	2020-04-24 18:26:01.382	\N	\N
8a8edd83-281f-449f-9d91-9dc57cf943e4	clientlead	Geoff Rice	TI Corp - Finance And Management Services Department	Project Manager	Geoff.Rice@gov.bc.ca	6132030840							\N	2020-04-27 16:44:41.572	2020-04-27 16:44:41.572	\N	\N
c128ae1a-d76c-4be7-8e3c-a6fc4a59c64d	clientsponsor	Dave Stewart	TI Corp - Finance And Management Services Department	CFO	dave.stewart@ticorp.ca	7789745414							\N	2020-04-27 16:44:41.583	2020-04-27 16:44:41.583	\N	\N
8d5ecfaf-17e5-4fd7-8ceb-72daa3a24ed3	clientfinance	Pending											\N	2020-04-27 16:44:41.592	2020-04-27 16:44:41.592	\N	\N
86dcc5bb-6335-49b1-8118-6ea5c7f4f2b7	clientlead	Dan Flynn	OCIO - Technology solutions	Service Manager	Dan.Flynn@gov.bc.ca	2509529467							\N	2020-04-28 16:42:37.818	2020-04-28 16:42:37.818	\N	\N
dc8342dc-3552-428c-9083-fe209e3e4c87	clientsponsor	Ka Yee Miwa	OCIO - Technology solutions	Director, Business Management	KaYee.Miwa@gov.bc.ca	2509527726							\N	2020-04-28 16:42:37.829	2020-04-28 16:42:37.829	\N	\N
4b2e71fc-1cd4-48e1-9424-9ba1f28acff6	clientfinance												\N	2020-04-28 16:42:37.851	2020-04-28 16:42:37.851	\N	\N
c57b3f29-c665-43e7-9054-9fd3b4d6128e	clientlead	Jacoba Corrigal	Ministry of Environment and Climate Change Strategy	Senior Procurement/Contract Specialist	jacoba.corrigal@gov.bc.ca	7786983112							\N	2020-04-28 21:06:25.114	2020-04-28 21:06:25.114	\N	\N
39ca60d8-b95c-493d-abf6-756c67407a01	clientsponsor	Pete Provan	Ministry of Environment and Climate Change Strategy	Director, Procurement and Contract Management IM/IT Investment Governance and Business Strategy Branch Information, Innovation and Technology Division Natural Resource Ministries	pete.provan@gov.bc.ca	2505164115							\N	2020-04-28 21:06:25.123	2020-04-28 21:06:25.123	\N	\N
8fed6ee8-6b61-4aa6-82f7-8e66f11d9687	clientfinance	Jacoba Corrigal	Ministry of Environment and Climate Change Strategy	Senior Procurement/Contract Management Specialist	jacoba.corrigal@gov.bc.ca	7786983114							\N	2020-04-28 21:06:25.129	2020-04-28 21:06:25.129	\N	\N
14d59b3d-e896-41fe-bb4e-def146e8328c	clientlead	Matthew Scott Moncrieff	Ministry of Forests, Lands, Natural Resource Operations and Rural Development 	Program Manager, Rural Development Rural Policy and Program Branch	matthew.scottmoncrieff@gov.bc.ca	7789744492							\N	2020-04-29 21:05:06.813	2020-04-29 21:05:06.813	\N	\N
dd4d7b59-9a28-4884-aac5-e298d4fcf436	clientsponsor	Lori Henderson	Ministry of Forests, Lands, Natural Resource Operations and Rural Development 	Director, Rural Policy & Programs branch, FLNRORD	Lori.henderson@gov.bc.ca	7786797825							\N	2020-04-29 21:05:06.824	2020-04-29 21:05:06.824	\N	\N
249d38e4-475b-4b73-ab2c-082ce3d6d0f9	clientfinance	Matthew Scott Moncrieff	Ministry of Forests, Lands, Natural Resource Operations and Rural Development 	Program Manager, Rural Development Rural Policy and Program Branch	matthew.scottmoncrieff@gov.bc.ca	7789744492							\N	2020-04-29 21:05:06.831	2020-04-29 21:05:06.831	\N	\N
df50547e-64fb-426a-b553-a07af4cbdb57	clientlead	Elietha Bocskei	Ministry of Advanced Education, Skills and Training	Senior Policy Analyst	elietha.bocskei@gov.bc.ca	7786989769							\N	2020-04-29 22:44:18.533	2020-04-29 22:44:18.533	\N	\N
082a91da-834a-4289-8399-7ff126ad5f3a	clientsponsor	Michelle Beattie	Ministry of Advanced Education, Skills and Training	Executive Administrative Assistant for Post Secondary Policy and Program.	michelle.beattie@gov.bc.ca	7786989895							\N	2020-04-29 22:44:18.562	2020-04-29 22:44:18.562	\N	\N
f9848017-5433-489b-85b4-f3c60ddb2904	clientfinance	Elietha Bocskei	Ministry of Advanced Education, Skills and Training	Senior Policy Analyst	elietha.bocskei@gov.bc.ca	7786989769							\N	2020-04-29 22:44:18.566	2020-04-29 22:44:18.566	\N	\N
8ae0de39-6fe2-4b12-bdec-a876bc97836e	clientlead	Bryn Johns	PSB	Specialist	bryn.johns@gov.bc.ca	1111111111							\N	2020-04-29 22:54:05.561	2020-04-29 22:54:05.561	\N	\N
66ae3016-d501-4c49-a2d9-c7b0636905c6	clientsponsor	n/a	n/a	n/a	a@b.ca	1111111111							\N	2020-04-29 22:54:05.586	2020-04-29 22:54:05.586	\N	\N
dff168bd-74f0-4256-846b-8c2502143aae	clientfinance												\N	2020-04-29 22:54:05.592	2020-04-29 22:54:05.592	\N	\N
209e4fd9-f155-47c6-b773-c609327f8462	user	Nadeem Javeri	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-30 18:38:45.357	2020-04-30 18:38:45.357	\N	\N
484e4339-b341-4b56-aadc-70e2dc87f73a	clientlead	Dawn Stewart	GCPE	Manager, Strategic Communications	dawn.stewart@gov.bc.ca	2503568595							\N	2020-04-30 21:30:58.911	2020-04-30 21:30:58.911	\N	\N
b07dffcd-e67a-4f5e-90ba-435031a5c172	clientsponsor	Kathryn LeSueur	GCPE	Director, Marketing and Advertising	kathryn.lesueur@gov.bc.ca	7786988674							\N	2020-04-30 21:30:58.952	2020-04-30 21:30:58.952	\N	\N
2a35708f-1a90-4a32-95f1-ac36c1054591	clientfinance												\N	2020-04-30 21:30:58.972	2020-04-30 21:30:58.972	\N	\N
60a263b2-7766-4844-ae0f-c930a5a894dc	clientlead	Tracy Harris	Procurement Services Branch	Senior Director	tracy.harris@gov.bc.ca	2502139506							\N	2020-04-30 23:22:09.004	2020-04-30 23:22:09.004	\N	\N
01107e5d-5ff0-494e-9035-5c670c92fd5e	clientsponsor	Robert O'Neill	Procurement Services Branch	Executive Director	Robert.ONeill@gov.bc.ca	2502178470							\N	2020-04-30 23:22:09.042	2020-04-30 23:22:09.042	\N	\N
9c837a27-19cb-4dd8-8a6b-6b16ed469f23	clientfinance												\N	2020-04-30 23:22:09.05	2020-04-30 23:22:09.05	\N	\N
1e1b0e2a-9540-4725-a535-59270aae0b8e	clientlead	Tracy Harris	Procurement Services Branch	Senior Director - Procurement	Tracy.harris@gov.bc.ca	2502139506							\N	2020-05-01 05:07:03.326	2020-05-01 05:07:03.326	\N	\N
a55896e5-83a8-4fd4-9edd-dc85526fac1f	clientsponsor	Robert O'Neill	Procurement Services Branch	Executive Director 	Robert.ONeill@gov.bc.ca	2502178470							\N	2020-05-01 05:07:03.34	2020-05-01 05:07:03.34	\N	\N
4608169b-db13-487a-a4ff-e862420aa1a1	clientfinance												\N	2020-05-01 05:07:03.345	2020-05-01 05:07:03.345	\N	\N
67726f2e-e5e1-4f88-8468-4c49339d5f20	user	Candace McIntosh	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-24 18:04:40.367	2020-05-12 23:05:14.719	120	\N
8ad10ad8-910c-4ab3-9a2e-5163fffd500a	user	David Summers	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-24 18:03:26.954	2020-05-12 23:05:22.385	120	\N
fe44dc3c-0b4a-49f8-9fa1-7d64d8ce5af2	user	Ruth Lau Siemers	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-23 22:53:06.232	2020-05-12 23:05:53.777	100	\N
6cccbbc4-54d6-4949-a968-0a7b01ad97bf	user	Susan Rivet	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-24 18:06:36.123	2020-05-12 23:05:56.325	120	\N
b38c0700-bb0a-4187-98ce-5bd24499690c	user	Laura Muise	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-24 17:59:31.102	2020-05-12 23:06:08.521	100	\N
88368389-6c97-49d4-a97b-7b24dcbb8c38	user	Kiah Sethi	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-23 20:28:37.741	2020-05-12 23:06:10.711	120	\N
462ca0fb-952a-4fe4-88cf-74dc5160c020	user	Ben Rosche	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-05-01 20:14:30.128	2020-05-01 20:14:30.128	\N	\N
fb6513eb-fff0-4fe6-905b-d59805b0350d	user	Ben Rosche	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-05-01 20:14:30.214	2020-05-01 20:14:30.214	\N	\N
03a64e94-6d66-495c-89dd-86a076d35f51	clientlead	Jody Elson	Hosting Services Re-Procurement Project Branch	Executive Director	jody.elson@gov.bc.ca	7786982478							\N	2020-05-01 21:55:52.568	2020-05-01 21:55:52.568	\N	\N
9e2f63c4-9fa6-47be-8653-79dd8e910ae4	clientsponsor	Jody Elson	Hosting Services Re-Procurement Project Branch	Executive Director	jody.elson@gov.bc.ca	7786982478							\N	2020-05-01 21:55:52.594	2020-05-01 21:55:52.594	\N	\N
112f1a0c-6d14-4b94-8969-2881f555094b	clientfinance												\N	2020-05-01 21:55:52.62	2020-05-01 21:55:52.62	\N	\N
edf71bd2-cfa8-4b54-8920-cd9e676964e4	clientlead	Jesse Piccin	OCIO Technology Solutions, Information Security Branch	Acting Director	jesse.piccin@gov.bc.ca	2502081599							\N	2020-05-01 22:16:23.02	2020-05-01 22:16:23.02	\N	\N
03e3bb26-b351-4764-9306-c730c4021b4d	clientsponsor	Jesse Piccin	OCIO Technology Solutions, Information Security Branch	Acting Director	jesse.piccin@gov.bc.ca	2502081599							\N	2020-05-01 22:16:23.031	2020-05-01 22:16:23.031	\N	\N
1df1ff83-ef73-4a34-9417-a5e3bcb30ee0	clientfinance												\N	2020-05-01 22:16:23.036	2020-05-01 22:16:23.036	\N	\N
b2b89293-3366-43e1-a5a7-a4c545ac307b	user	Cassandra Fletcher	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-05-04 17:36:54.301	2020-05-04 17:36:54.301	\N	\N
1c96d744-fd6d-4b85-8a65-d2689dcb1d20	user	Carolyn Van Somer	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-05-04 17:38:35.118	2020-05-04 17:38:35.118	\N	\N
5c8dee5e-8d2c-42f2-afe5-39033fb605b1	clientlead	Rita karajaoja	SDPR	Acting Supervisor	Rita.Karajaoja@gov.bc.ca	2509805656							\N	2020-05-05 18:14:16.881	2020-05-05 18:14:16.881	\N	\N
dab6710d-eb26-428f-9728-fa1dfa8b0071	clientsponsor	Jordana Fratianni	SDPR	Manager, Service Delivery	Jordana.Fratianni@gov.bc.ca	7786220117							\N	2020-05-05 18:14:16.889	2020-05-05 18:14:16.889	\N	\N
6d7cf5cc-900a-46a1-849b-c21420c43237	clientfinance												\N	2020-05-05 18:14:16.892	2020-05-05 18:14:16.892	\N	\N
2032e970-371b-4f41-93cd-ced37d132571	clientlead	Bryn Johns	PSB	Procurement	bryn.johns@gov.bc.ca	1111111111							\N	2020-05-05 22:15:34.653	2020-05-05 22:15:34.653	\N	\N
6a0f5f62-c649-4715-9508-e2898f76c559	clientsponsor	n/a	1	1	a@b.ca	1111111111							\N	2020-05-05 22:15:34.66	2020-05-05 22:15:34.66	\N	\N
91ef4fab-c7d3-4c29-8a09-3ed56951a8ba	clientfinance												\N	2020-05-05 22:15:34.667	2020-05-05 22:15:34.667	\N	\N
0921d339-26d9-421c-8089-40fbed21047f	clientlead	Bryn Johns	PSB	Procurement	bryn.johns@gov.bc.ca	1111111111							\N	2020-05-05 23:25:18.363	2020-05-05 23:25:18.363	\N	\N
1c6865b7-485f-4cdf-bb03-111eceb70d7b	clientsponsor	n/a	n/a	n/a	a@b.ca	1111111111							\N	2020-05-05 23:25:18.388	2020-05-05 23:25:18.388	\N	\N
218ed232-8da5-4624-b3bf-4a1d54376c09	clientfinance												\N	2020-05-05 23:25:18.396	2020-05-05 23:25:18.396	\N	\N
f1735c92-9ff4-4989-81a9-7a30956b5f8c	clientlead	Bryn Johns	PSB	Procurement	bryn.johns@gov.bc.ca	1111111111							\N	2020-05-05 23:28:42.511	2020-05-05 23:28:42.511	\N	\N
5aed62f7-c4dc-42c5-9c6e-da09f6d1f113	clientsponsor	n/a	n/a	n/a	a@b.ca	1111111111							\N	2020-05-05 23:28:42.52	2020-05-05 23:28:42.52	\N	\N
4c58cd4b-832a-47e7-b51e-55424f6a997b	clientfinance												\N	2020-05-05 23:28:42.524	2020-05-05 23:28:42.524	\N	\N
210eb957-fe3a-4256-9072-d877cf56be1a	clientlead	Bryn Johns	PSB	Procurement	Bryn.Johns@gov.bc.ca	1111111111							\N	2020-05-05 23:31:52.076	2020-05-05 23:31:52.076	\N	\N
d66b6700-d699-422b-92df-2ed60f32b7e6	clientsponsor	n/a	n/a	n/a	a@b.ca	1111111111							\N	2020-05-05 23:31:52.086	2020-05-05 23:31:52.086	\N	\N
8f7ce9cf-97ad-49ca-96fa-4c93560ddae1	clientfinance												\N	2020-05-05 23:31:52.091	2020-05-05 23:31:52.091	\N	\N
f5d6df4f-a6fc-460e-a509-28b80c751454	clientlead	Bryn Johns	PSB	Procurement	Bryn.Johns@gov.bc.ca	1111111111							\N	2020-05-05 23:35:04.615	2020-05-05 23:35:04.615	\N	\N
39d60e9f-f8d1-4d03-ad0b-2f8d9a497472	clientsponsor	n/a	n/a	n/a	a@b.ca	1111111111							\N	2020-05-05 23:35:04.622	2020-05-05 23:35:04.622	\N	\N
3d0c7d5f-4a52-4d6c-bbe6-ab9f11dd3c72	clientfinance												\N	2020-05-05 23:35:04.628	2020-05-05 23:35:04.628	\N	\N
80858d85-6e6e-4fd2-bb03-32df56e4dc9d	clientlead	Melissa Sands	.	.	msands@royalbcmuseum.bc.ca	7786798580							\N	2020-05-06 16:22:56.785	2020-05-06 16:22:56.785	\N	\N
e52186c4-b70a-4591-8515-b2525d63c4e5	clientsponsor	Melissa Sands	.	.	msands@royalbcmuseum.bc.ca	7786798580							\N	2020-05-06 16:22:56.796	2020-05-06 16:22:56.796	\N	\N
f63d648a-2f5c-4328-8cd1-cffd75a59505	clientfinance												\N	2020-05-06 16:22:56.829	2020-05-06 16:22:56.829	\N	\N
e5e75305-8c09-4f96-b7b0-26b6d4b8eb48	clientlead	Bronwyn Phillips	WDS	.	bronwyn.phillips@gov.bc.ca	2509528403							\N	2020-05-06 16:37:42.065	2020-05-06 16:37:42.065	\N	\N
e328beb1-fe7c-4a02-92ce-fdfc7c21e93e	clientsponsor	Sunny Dhaliwal	.	ADM	sunny.shaliwal@gov.bc.ca	7786985807							\N	2020-05-06 16:37:42.075	2020-05-06 16:37:42.075	\N	\N
f5ed2282-aa00-4f9e-9a80-197a4360fa58	clientfinance												\N	2020-05-06 16:37:42.079	2020-05-06 16:37:42.079	\N	\N
4e2bcd30-9e38-4688-bc77-215689e2df9e	clientlead	Greg Lamb	DCV	Asst. Director	Greg.Lamb@gov.bc.ca	1111111111							\N	2020-05-06 23:27:08.716	2020-05-06 23:27:08.716	\N	\N
e04ae49a-a1f2-4ae0-829c-c70b0e288931	clientsponsor	Dawson Brenner	Supply Services	Executive Director	Dawson.Brenner@gov.bc.ca	1111111111							\N	2020-05-06 23:27:08.724	2020-05-06 23:27:08.724	\N	\N
4b47df33-9695-4350-a190-1ec9b9d835b0	clientfinance												\N	2020-05-06 23:27:08.73	2020-05-06 23:27:08.73	\N	\N
35ff61f5-a2cb-44ed-9a5e-063262cc38e8	clientlead	Chris Carmack	Ministry of Finance	Contract Manager 	christopher.carmack@gov.bc.ca	2508867709							\N	2020-05-07 13:02:47.729	2020-05-07 13:02:47.729	\N	\N
3d7f343c-f906-421c-bd45-536427f70c79	clientsponsor	Michelle Lee	Ministry of Finance	Executive Director Revenue Division	Michelle.Lee@gov.bc.ca	7786989609							\N	2020-05-07 13:02:47.737	2020-05-07 13:02:47.737	\N	\N
0b7b8774-215d-415b-afa9-f1443f8f3042	clientfinance												\N	2020-05-07 13:02:47.741	2020-05-07 13:02:47.741	\N	\N
9b0f638a-ed37-43a6-83ea-ff7de2626a45	clientlead	Jerry Gauthier	PSB	Procurement Specialist	jerry.gauthier@gov.bc.ca	2503877333							\N	2020-05-07 16:28:50.515	2020-05-07 16:28:50.515	\N	\N
a82598e3-a49b-4133-9cd9-71ab7c554d81	clientsponsor	.	.	.	jerry.gauthier@gov.bc.ca	1111111111							\N	2020-05-07 16:28:50.522	2020-05-07 16:28:50.522	\N	\N
eecb615e-4f55-4bc7-9b0e-0edb95a6e8e5	clientfinance												\N	2020-05-07 16:28:50.528	2020-05-07 16:28:50.528	\N	\N
c68f0392-0612-4d13-a844-5c1c19c4f030	clientlead	Jerry Gauthier	PSB	Procurement Specialist	jerry.gautheir@gov.bc.ca	2503877333							\N	2020-05-07 16:32:06.874	2020-05-07 16:32:06.874	\N	\N
f4907d38-8815-47fb-8ae7-c42c41f308a4	clientsponsor	.	.	.	jerry.gauthier@gov.bc.ca	1111111111							\N	2020-05-07 16:32:06.879	2020-05-07 16:32:06.879	\N	\N
35d62799-8bef-4cb7-b176-3458804e9f5a	clientfinance												\N	2020-05-07 16:32:06.884	2020-05-07 16:32:06.884	\N	\N
74d3b3a5-3014-4a2e-bb61-e7caabaece61	clientlead	Jerry Gauthier	PSB	Procurement Specialist	jerry.gauthier@gov.bc.ca	2503877333							\N	2020-05-07 16:35:37.449	2020-05-07 16:35:37.449	\N	\N
cfc2374b-8101-4079-988b-0324dbbebe47	clientsponsor	.	.	.	jerry.gauthier@gov.bc.ca	1111111111							\N	2020-05-07 16:35:37.455	2020-05-07 16:35:37.455	\N	\N
eac172de-aa74-4050-9d6d-9d849deef1d7	clientfinance												\N	2020-05-07 16:35:37.46	2020-05-07 16:35:37.46	\N	\N
511759fd-4baf-4fd3-b79c-43a838c93028	clientlead	Jerry Gauthier	PSB	Procurement Specialist	jerry.gauthier@gov.bc.ca	2503877333							\N	2020-05-07 16:38:41.861	2020-05-07 16:38:41.861	\N	\N
830ab0b2-779a-4f06-b1bc-e792e025aebb	clientsponsor	.	.	.	jerry.gauthier@gov.bc.ca	1111111111							\N	2020-05-07 16:38:41.868	2020-05-07 16:38:41.868	\N	\N
d3aaafd6-8837-43ee-b2a4-27a7f66d8eca	clientfinance												\N	2020-05-07 16:38:41.872	2020-05-07 16:38:41.872	\N	\N
4808fcea-b59c-45f0-9b6c-c64504c4b6b4	clientlead	Jerry Gauthier	PSB	Procurement Specialist	jerry.gauthier@gov.bc.ca	2503877333							\N	2020-05-07 16:41:25.673	2020-05-07 16:41:25.673	\N	\N
a589814a-1164-47af-8870-7c51fa75a70d	clientsponsor	.	.	.	jerry.gauthier@gov.bc.ca	1111111111							\N	2020-05-07 16:41:25.693	2020-05-07 16:41:25.693	\N	\N
a981f164-44d0-4cee-81d0-f63f8a2cc66f	clientfinance												\N	2020-05-07 16:41:25.697	2020-05-07 16:41:25.697	\N	\N
c0fcaa1d-aabd-479c-ae31-1682735bd113	clientlead	Steven Riden	.	.	steven.radin@gov.bc.ca	1111111111							\N	2020-05-07 17:49:50.103	2020-05-07 17:49:50.103	\N	\N
790abdc2-71bd-4924-ae10-d170e1401b7a	clientsponsor	.	.	.	a@bc.de	1111111111							\N	2020-05-07 17:49:50.116	2020-05-07 17:49:50.116	\N	\N
9bb88b2c-a1e0-4ab1-a761-89d60632916f	clientfinance												\N	2020-05-07 17:49:50.121	2020-05-07 17:49:50.121	\N	\N
21ed117d-3701-478a-9c6f-72a18c43fd47	clientlead	Michael Swift	OCIO	.	michael.swift@gov.bc.ca	1111111111							\N	2020-05-07 20:40:26.038	2020-05-07 20:40:26.038	\N	\N
f56d4bed-c184-427f-a0ca-876e9f05effb	clientsponsor	.	.	.	a@bc.de	1111111111							\N	2020-05-07 20:40:26.045	2020-05-07 20:40:26.045	\N	\N
1e5a6295-e46d-4e6d-85fb-35e77c04a2c8	clientfinance												\N	2020-05-07 20:40:26.049	2020-05-07 20:40:26.049	\N	\N
7f185e90-69b4-409d-b4d5-a93cd28051f6	clientlead	Thea Ardiel	MCF	.	thea.ardiel@gov.bc.ca	1111111111							\N	2020-05-07 20:48:10.11	2020-05-07 20:48:10.11	\N	\N
2d5f1afd-0a74-495e-b380-a20a1abb8c82	clientsponsor	.	.	.	a@b.cd	1111111111							\N	2020-05-07 20:48:10.117	2020-05-07 20:48:10.117	\N	\N
c6e77528-19ba-4abf-bb48-83d42fa717ba	clientfinance												\N	2020-05-07 20:48:10.122	2020-05-07 20:48:10.122	\N	\N
7166ee0b-745e-4256-b552-4efadbb3c83e	clientcontact	Tom Jackson	FLNR	.	tom.jackson@gov.bc.ca	1111111111							.	2020-05-07 20:48:10.126	2020-05-07 20:48:10.126	\N	\N
569d24ef-1cc6-43d5-89d6-c71a81604748	clientcontact	Tom Jackson	FLNR	.	tom.jackson@gov.bc.ca	1111111111							.	2020-05-07 20:48:10.13	2020-05-07 20:48:10.13	\N	\N
3f30c632-8551-435c-9189-5edbadb5ca2b	clientlead	.	.	.	a@b.cd	1111111111							\N	2020-05-07 20:53:15.17	2020-05-07 20:53:15.17	\N	\N
84013463-5677-4365-8c67-c31b57c12824	clientsponsor	.	.	.	a@b.cd	1111111111							\N	2020-05-07 20:53:15.177	2020-05-07 20:53:15.177	\N	\N
f7a97cd6-d162-4e2f-9e32-7455b7035499	clientfinance												\N	2020-05-07 20:53:15.183	2020-05-07 20:53:15.183	\N	\N
3c5507e7-8fa9-439b-abb5-482ee749605f	clientlead	.	.	.	a@b.cd	1111111111							\N	2020-05-07 20:55:41.132	2020-05-07 20:55:41.132	\N	\N
e0978ebd-f166-419a-8155-2203c56a023e	clientsponsor	.	.	.	a@b.cd	1111111111							\N	2020-05-07 20:55:41.138	2020-05-07 20:55:41.138	\N	\N
8ab02188-799d-42b6-ad0a-3a24ba1f81c3	clientfinance												\N	2020-05-07 20:55:41.142	2020-05-07 20:55:41.142	\N	\N
16424a71-9a8c-4d6a-837a-72ea7bbe9408	clientlead	.	.	.	a@b.cd	1111111111							\N	2020-05-07 21:00:25.465	2020-05-07 21:00:25.465	\N	\N
167cec82-cf24-40c1-a02c-a7a7ce1a25e6	clientsponsor	.	.	.	a@b.cd	1111111111							\N	2020-05-07 21:00:25.473	2020-05-07 21:00:25.473	\N	\N
8aa6c5a4-fac7-4d68-8058-213a12022207	clientfinance												\N	2020-05-07 21:00:25.479	2020-05-07 21:00:25.479	\N	\N
56085c96-a2ee-4205-a2e1-c27fd0928f3b	clientlead	Lisa Perkins	OCIO	Director, Project and Business Services	lisa.perkins@gov.bc.ca	2504159269							\N	2020-05-11 17:35:15.229	2020-05-11 17:35:15.229	\N	\N
8e416f64-b080-4203-a8d2-158eac069a11	clientsponsor	.	.	.	a@bc.de	1111111111							\N	2020-05-11 17:35:15.24	2020-05-11 17:35:15.24	\N	\N
ddad2acd-1cec-4bc8-b541-7a24b92cc14e	clientfinance												\N	2020-05-11 17:35:15.245	2020-05-11 17:35:15.245	\N	\N
5616b3d9-d971-4dd2-a9f8-3e6cb5fdd565	clientlead	Tracy Harris	PSB	Sr. Director	Tracy.harris@gov.bc.ca	1111111111							\N	2020-05-12 22:51:36.588	2020-05-12 22:51:36.588	\N	\N
ecbc9cbd-1241-4a80-9558-f643f1884a88	clientsponsor	Nadeem Javeri	PSB	Sr. Director	Nadeem.Javeri@gov.bc.ca	2222222222							\N	2020-05-12 22:51:36.598	2020-05-12 22:51:36.598	\N	\N
1a112b38-b8b2-4c5a-a200-f3dbacd77888	clientfinance	Zachary Woodward	PSB	Sr. Director	Zachary.Woodward@gov.bc.ca	3333333333							\N	2020-05-12 22:51:36.602	2020-05-12 22:51:36.602	\N	\N
5c9e2d49-6b25-44c3-88ab-0286f0347805	user	Ben Rosche	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-05-01 20:14:30.119	2020-05-12 23:05:06.033	100	\N
8a03f761-d645-4744-913b-1ca4b65c2713	user	Bobby Kapoor	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-24 18:06:32.734	2020-05-12 23:05:12.478	120	\N
09776d13-f896-423e-94f6-903a5c9af8be	user	Jeannette Caissie	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-04-28 14:36:32.937	2020-05-12 23:05:30.974	10	\N
32ecf1ef-0ee2-4cb4-a6ea-a2018abcaa1c	user	Karen Flood	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-05-04 16:20:16.274	2020-05-12 23:05:33.228	100	\N
c1dc29fc-0203-42d5-bc5c-15ac9b615379	user	Angio Ledesma	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-05-13 17:52:21.914	2020-05-13 17:52:21.914	\N	\N
43e90d9b-06c0-4983-9e30-1728ef37045f	clientlead	Danielle Duplissie	MPSSG	Project Director	Danielle.Duplissie@gov.bc.ca	7785723392							\N	2020-05-13 19:20:37.414	2020-05-13 19:20:37.414	\N	\N
fe6d4649-a45e-46ab-90e2-fc5f0eec36b2	clientsponsor	Jim MacAulay  	MPSSG	Executive Director	Jim.MacAulay@gov.bc.ca	7786988324							\N	2020-05-13 19:20:37.422	2020-05-13 19:20:37.422	\N	\N
c92313df-58de-49ab-97be-aeebad9072d8	clientfinance	Jim MacAulay  	MPSSG	Executive Director	Jim.MacAulay@gov.bc.ca	7786988324							\N	2020-05-13 19:20:37.425	2020-05-13 19:20:37.425	\N	\N
\.


--
-- Data for Name: finance_export; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.finance_export (id, "documentNo", "totalAmount", "projectId", "dateCreated", "createdUserId", "exportData", "documentPath", "monthStartDate") FROM stdin;
8a1de486-8b95-4c35-bf6f-969c72588177	92a2dbbb-bf06-420e-b6f0-9e1cf7f7d0d7	1370	4053e10e-3d25-4697-9be6-d4bd5f149981	2020-05-05 16:01:37.63	bc8957ee-bb1c-4578-8d23-bd9c36b19588	"{\\"projectId\\":\\"4053e10e-3d25-4697-9be6-d4bd5f149981\\",\\"contact\\":\\"Jacoba Corrigal\\",\\"projectName\\":\\"First Nation Consultation Applications Support \\",\\"responsibilityCenter\\":\\"7124B\\",\\"clientNo\\":\\"128\\",\\"stob\\":\\"6001\\",\\"projectCode\\":\\"7100000\\",\\"serviceCenter\\":\\"30146\\",\\"documentPath\\":\\"Apr - 2020 - 1 Project.pdf\\",\\"documentNo\\":\\"92a2dbbb-bf06-420e-b6f0-9e1cf7f7d0d7\\",\\"lineDesc\\":\\"92a2dbbb-bf06-420e-b6f0-9e1cf7f7d0d7\\",\\"createdUserId\\":\\"bc8957ee-bb1c-4578-8d23-bd9c36b19588\\",\\"details\\":[{\\"entryDate\\":\\"2020-04-15\\",\\"description\\":\\"Follow up with the client on status of projects. \\",\\"hours\\":0.25,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":25},{\\"entryDate\\":\\"2020-04-29\\",\\"description\\":\\"Post contract award notice on BC Bid for BC Geological Branch Survey and follow up project status.\\",\\"hours\\":1,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":100},{\\"entryDate\\":\\"2020-04-07\\",\\"description\\":\\"Prepared project status update for leadership team.\\",\\"hours\\":1.7,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":170},{\\"entryDate\\":\\"2020-04-08\\",\\"description\\":\\"Scheduled debriefing meeting with Salus System Limited\\",\\"hours\\":0.5,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":50},{\\"entryDate\\":\\"2020-04-09\\",\\"description\\":\\"Reviewed Sierra' s proposal and prepared debriefing script for LSB approval.\\",\\"hours\\":3,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":300},{\\"entryDate\\":\\"2020-04-20\\",\\"description\\":\\"Reviewed materials for debriefing \\",\\"hours\\":1,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":100},{\\"entryDate\\":\\"2020-04-21\\",\\"description\\":\\"Debriefing meeting with client held to confirm roles, responsibilities and expectation.\\",\\"hours\\":0.5,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":50},{\\"entryDate\\":\\"2020-04-22\\",\\"description\\":\\"Debriefing meeting preparation followed by debriefing meeting with the vendor. \\",\\"hours\\":1.75,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":175},{\\"entryDate\\":\\"2020-04-23\\",\\"description\\":\\"Reviewed First Nation Consultation Application Support RFP and provided feedback to client.\\",\\"hours\\":3,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":300},{\\"entryDate\\":\\"2020-04-24\\",\\"description\\":\\"Provided biweekly updates for leadership team and attended meeting.\\",\\"hours\\":1,\\"type\\":\\"Time\\",\\"user\\":\\"a2127b12-c103-4722-89e3-cbcc8a544245\\",\\"resource\\":\\"Collin Lord\\",\\"rate\\":100,\\"amount\\":100}],\\"fees\\":1370,\\"expenses\\":0,\\"totalAmount\\":1370,\\"dateCreated\\":\\"2020-05-05T16:01:37.630Z\\"}"	Apr - 2020 - 1 Project.pdf	2020-04-01
61ebf26f-708e-443f-9e4e-e333219364f6	d8df24ef-8d97-4912-89b1-5636cbd72b86	1020	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	2020-05-05 16:06:16.436	bc8957ee-bb1c-4578-8d23-bd9c36b19588	"{\\"projectId\\":\\"be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e\\",\\"contact\\":\\"\\",\\"projectName\\":\\"Resources for ADMS\\",\\"responsibilityCenter\\":\\"32791\\",\\"clientNo\\":\\"112\\",\\"stob\\":\\"6101\\",\\"projectCode\\":\\"3200000\\",\\"serviceCenter\\":\\"20052\\",\\"documentPath\\":\\"Apr - 2020 - 1 Project.pdf\\",\\"documentNo\\":\\"d8df24ef-8d97-4912-89b1-5636cbd72b86\\",\\"lineDesc\\":\\"d8df24ef-8d97-4912-89b1-5636cbd72b86\\",\\"createdUserId\\":\\"bc8957ee-bb1c-4578-8d23-bd9c36b19588\\",\\"details\\":[{\\"entryDate\\":\\"2020-04-06\\",\\"description\\":\\"B24 consensus meeting. Communications re minimum scores and qualification. Call with IF.\\",\\"hours\\":1,\\"type\\":\\"Time\\",\\"user\\":\\"f6b65221-f597-488b-aaa8-bed90aacfaf8\\",\\"resource\\":\\"Jason George\\",\\"rate\\":120,\\"amount\\":120},{\\"entryDate\\":\\"2020-04-17\\",\\"description\\":\\"Draft notifications for RFP. Consensus review meeting.\\",\\"hours\\":2.5,\\"type\\":\\"Time\\",\\"user\\":\\"f6b65221-f597-488b-aaa8-bed90aacfaf8\\",\\"resource\\":\\"Jason George\\",\\"rate\\":120,\\"amount\\":300},{\\"entryDate\\":\\"2020-04-20\\",\\"description\\":\\"Finalize and send notifications for RFP.\\",\\"hours\\":2,\\"type\\":\\"Time\\",\\"user\\":\\"f6b65221-f597-488b-aaa8-bed90aacfaf8\\",\\"resource\\":\\"Jason George\\",\\"rate\\":120,\\"amount\\":240},{\\"entryDate\\":\\"2020-04-21\\",\\"description\\":\\"Communications and review documentation re reference checks.\\",\\"hours\\":0.5,\\"type\\":\\"Time\\",\\"user\\":\\"f6b65221-f597-488b-aaa8-bed90aacfaf8\\",\\"resource\\":\\"Jason George\\",\\"rate\\":120,\\"amount\\":60},{\\"entryDate\\":\\"2020-04-22\\",\\"description\\":\\"Communications with vendors on debriefs.\\",\\"hours\\":0.5,\\"type\\":\\"Time\\",\\"user\\":\\"f6b65221-f597-488b-aaa8-bed90aacfaf8\\",\\"resource\\":\\"Jason George\\",\\"rate\\":120,\\"amount\\":60},{\\"entryDate\\":\\"2020-04-24\\",\\"description\\":\\"Customize debrief script and guidance and provide.\\",\\"hours\\":2,\\"type\\":\\"Time\\",\\"user\\":\\"f6b65221-f597-488b-aaa8-bed90aacfaf8\\",\\"resource\\":\\"Jason George\\",\\"rate\\":120,\\"amount\\":240}],\\"fees\\":1020,\\"expenses\\":0,\\"totalAmount\\":1020,\\"dateCreated\\":\\"2020-05-05T16:06:16.436Z\\"}"	Apr - 2020 - 1 Project.pdf	2020-04-01
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
8	MM2018WTSPP
9	JRAG-2019
10	GR-208-2
11	GR-209-2
12	GR-212-1
13	GR-213-1
14	GR-214-1
18	JDG-232
19	MMC-BCWS 2019/20
22	RL - 201 - DEMS
27	SRFWEPM-2019
29	CM-206
30	JR-202
31	SRMSMFLNR - 2020
32	TH_2019_GCPEAdPlacement
33	Internal Operations
34	JG-2019-MPS
35	JG-2019-OSNRFP
36	SW-207-1
38	JDG-235
39	PSB1101
40	BC Bid
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
3e06c426-422c-4bf0-923f-94e0aed5c43b	Soft Body Armour		\N	2020-08-31	500000	15000	228e25cb-a091-4c40-9c60-751c784d8852	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a		2020-04-22 18:30:28.894	2020-04-22 20:23:44.255	3e9a3591-d6b2-4b46-a426-5e0872553673	228e25cb-a091-4c40-9c60-751c784d8852	\N	t	\N	2020-04-01	There is a contract currently in place with an incumbent supplier. The contract term has ended and BC Sheriff's Service requires a new contract to secure a supply of soft body armor. NOTE: The contract has already expired.	No supply of soft body armor to BC Sheriff's Service employees.	Contracting with a supplier who delivers products in a timely manner with strong service supports. 	f	\N	90c9c475-cf6d-429f-a8a5-7da8e3b58db1	d1636622-a025-4736-969f-8e5536f6512e	9
3401c829-c6f5-4cef-86e6-ad39d8c54aee	Workplace Development Services		\N	2021-12-30	1	0	\N	\N		2020-04-22 16:58:09.523	2020-04-22 21:09:24.055	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	t	f	\N	\N	\N	Services not provided	services are provided	f	\N	7d78cd6c-d7e1-45ac-b987-d98ac879c9e9	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
05bee9b0-882a-4ed6-8bf8-1d0fdb01117b	BC Parks Uniforms and Jackets Procurement		\N	2020-12-31	500000	16898	8b436459-b4c6-424b-ad53-ebd55d2e5483	2d99034e-ba45-4768-87e1-e76c1a72d5eb		2020-04-24 18:28:19.972	2020-04-29 18:46:06.43	2d99034e-ba45-4768-87e1-e76c1a72d5eb	8b436459-b4c6-424b-ad53-ebd55d2e5483	\N	f	\N	\N	\N	None identified for this project.	Continued supply of Uniforms and Jackets for BC Parks without any interruptions.	f	\N	6f5521be-ca24-4c99-a308-da66eee67993	5afee492-cea2-4360-8e6f-e66c17baaaf5	30
c76b3ba0-bd37-4ff2-b659-67ebb8a768e8	Advisory and Procurement Services		\N	2021-12-30	1	2575.90000000000009	5a86fbb4-7707-43b7-88ce-ad77599652ef	\N		2020-04-22 21:16:50.703	2020-04-22 21:19:35.759	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	services not provided	services are provided	f	\N	2f0f69cc-06cd-448f-b325-c0f63edbb856	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	10
2c933486-0a9b-40de-adc9-eaa9319a16f2	Workplace Technology Services Procurement Project		\N	2022-09-30	300000000	205091	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	228e25cb-a091-4c40-9c60-751c784d8852		2020-04-22 18:30:38.738	2020-04-22 19:10:12.425	3e9a3591-d6b2-4b46-a426-5e0872553673	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	\N	t	\N	2022-09-29	WTSPP is the procurement of device services (computer hardware, deployment & decommissioning, service desk, field services and managed workplace technology services). Current term expires September 30, 2020. Approval obtained, and negotiations underway to extend this term for 24 months plus six months, plus six months (the two 6 month possible extensions are built in to allow for transition).	Ceasing of services and services continuity with risk of another direct award to extend and maintain service. 	Contract(s) are executed and best value is obtained from the marketplace. 	f	\N	9c539e7c-de5a-49eb-92e7-c28b8c9838ff	15b3f630-3c1f-4402-8e08-6591f3d8ba13	8
a0a72451-9577-4ab4-bec9-f1a236243805	AIR Victoria Moving Services		\N	2021-12-30	1	3325	5a86fbb4-7707-43b7-88ce-ad77599652ef	\N		2020-04-22 21:54:10.184	2020-04-22 21:55:22.788	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	Services not provided	services are provided	f	\N	441d079e-79a2-4bee-9bed-5599631761d1	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	13
92e963f3-70a4-4f95-b6e0-b86c062aba6d	Ongoing Contract work		\N	2021-12-30	1	4450	5a86fbb4-7707-43b7-88ce-ad77599652ef	\N		2020-04-22 22:00:06.933	2020-04-22 22:01:06.44	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	services not provided	services are provided	f	\N	a14b3e69-8422-4069-a20f-84b2db82a7f5	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	14
d930683b-68e0-44f5-a31d-398815e32909	AIR Warehousing Services		\N	2021-12-30	1	8000	5a86fbb4-7707-43b7-88ce-ad77599652ef	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-04-22 17:08:04.53	2020-04-22 18:13:08.863	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	Services are not provided	Services are provided	f	\N	bd036bdb-8c83-45bd-979a-13763c5d592b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	1
4c70dd71-1938-4a01-a86b-ced42b12c11e	Procurement and Contracting Advisory Services		\N	2020-12-31	1000000	24882.2999999999993	f6b65221-f597-488b-aaa8-bed90aacfaf8	c246f349-bb5e-4309-861b-706bc6b232c1		2020-04-22 17:19:47.549	2020-04-29 18:41:11.626	f6b65221-f597-488b-aaa8-bed90aacfaf8	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	f	\N	\N	\N	Various risks to ongoing and planned procurement of information systems support for several "dirt" ministries.	Timely and sufficient support of ongoing and planned procurements.	f	\N	67c8fc33-db70-4d84-a971-9476d35ce67b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	3
6680eec1-85c6-446c-86ef-677db7908c1a	Renewable Energy Studies		\N	2021-12-30	1	503	5a86fbb4-7707-43b7-88ce-ad77599652ef	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-04-22 21:27:49.046	2020-04-22 21:35:08.628	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	Services not provided	services are provided	f	\N	e217c260-02cc-4ffc-aedd-9257c055519e	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	11
99543d57-26fd-4ba4-8f31-668bab5f7773	Procurement and Contract Advisory		\N	2021-12-30	1	2809	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-04-22 22:14:21.816	2020-05-05 19:54:07.426	ff341b3b-6c79-421c-951a-0e199f8693d8	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	\N	f	\N	\N	\N	Services not provided	services are provided	f	\N	5a9c55de-0566-41ba-b28f-eacabe351135	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	18
80f44db4-8489-4144-bd99-25734ee64bae	Picture Framing CSA		\N	2021-12-30	1	23900	5a86fbb4-7707-43b7-88ce-ad77599652ef	\N		2020-04-22 21:47:31.407	2020-04-22 21:49:10.147	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	Services not provided	services are provided	f	\N	fd54eb6c-3aaa-47be-9c65-678a8c6a3aa8	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	12
0da1c7d6-5b71-4232-8c20-ed2e52d08091	Environmental Project Management and Implementation Services		\N	2020-12-31	20000000	30000	228e25cb-a091-4c40-9c60-751c784d8852	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a		2020-04-24 16:47:56.843	2020-04-24 16:50:56.844	3e9a3591-d6b2-4b46-a426-5e0872553673	228e25cb-a091-4c40-9c60-751c784d8852	\N	t	\N	2020-06-30	Current contract has been in place since 2014. Set to expire on June 30 2020, however the client is looking into a direct award to extend to accommodate a new procurement.	Lack of service delivery.	Strong service provider. Continuity of services. Cost savings.	f	\N	f10093b5-a868-4db5-a23c-775070e3a30b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	27
8959e597-c09f-46b6-a515-b3ce076a9a94	DEMS RFP		\N	2020-09-01	1500000	45000	3778745c-f1c5-4013-ae07-75bd4798ea32	\N		2020-04-23 23:11:22.04	2020-04-24 18:30:51.86	3778745c-f1c5-4013-ae07-75bd4798ea32	3778745c-f1c5-4013-ae07-75bd4798ea32	\N	f	\N	\N	\N	Non completion of the Comprehensive Disclosure Solution (CDS), a technology project being delivered by the BC Prosecution Service within the Ministry of Attorney General. As part of the project plan, we are intending to issue a Digital Evidence Management System (DEMS) RFP for software and implementation.	The overall vision of the DEMS and CDS projects is to create a system to manage documentation across the lifecycle of evidence and disclosure. This new system would ensure faster case processing, significant reduction in transfer delays and other tangible benefits.	f	\N	5d499cd7-3ae6-45e4-9fb2-688745dc1757	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	22
02c89fe1-3496-46f1-b833-db0fe0d08e12	Soft Body Armour		\N	2020-08-31	500000	0	\N	\N		2020-04-22 18:30:28.894	2020-04-24 17:00:14.43	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	t	t	\N	2020-04-01	There is a contract currently in place with an incumbent supplier. The contract term has ended and BC Sheriff's Service requires a new contract to secure a supply of soft body armor. NOTE: The contract has already expired.	No supply of soft body armor to BC Sheriff's Service employees.	Contracting with a supplier who delivers products in a timely manner with strong service supports. 	f	\N	90c9c475-cf6d-429f-a8a5-7da8e3b58db1	d1636622-a025-4736-969f-8e5536f6512e	\N
0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	BCWS 2020 Procurements-Various		\N	2020-07-31	8	5853	b9a782bd-39b5-4697-9a4a-9b62737876e2	c246f349-bb5e-4309-861b-706bc6b232c1		2020-04-23 01:30:15.484	2020-05-01 01:33:45.695	b9a782bd-39b5-4697-9a4a-9b62737876e2	b9a782bd-39b5-4697-9a4a-9b62737876e2	\N	f	\N	\N	\N	don't have contracts in place for 2020 fire season	Contracts in place by April 30, 2020	f	\N	ebff8e7a-322e-4879-983c-88cba8b50e5e	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	19
f9211d4d-6e4c-4c16-8ff1-e11533648789	BC Parks Uniforms and Jackets Procurement		\N	2020-12-31	500000	0	\N	\N		2020-04-24 18:28:19.764	2020-04-27 20:05:42.015	2d99034e-ba45-4768-87e1-e76c1a72d5eb	\N	t	f	\N	\N	\N	None identified for this project.	Continued supply of Uniforms and Jackets for BC Parks without any interruptions.	f	\N	6f5521be-ca24-4c99-a308-da66eee67993	5afee492-cea2-4360-8e6f-e66c17baaaf5	\N
2d2796cc-4950-4811-abf9-cebd2d9d7f01	TI Corp SMS		\N	2020-08-31	450000	15000	3e9a3591-d6b2-4b46-a426-5e0872553673	13669c48-73ee-492e-b1b5-6a168f213d8a		2020-04-22 17:20:49.655	2020-04-29 22:36:56.971	3e9a3591-d6b2-4b46-a426-5e0872553673	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	f	\N	\N	\N	Continue to manage communication via excel spreadsheets\nPotential of missing key communication to stakeholders	Completed SMS that will assist with the communication for the three major TI Corp projects	f	\N	1f71980e-7616-4412-a11b-1347ce43f37f	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	2
7705fd59-37b6-4d8b-8f8d-fb1329569f8a	BC Bid Project		\N	2020-12-31	1	0	\N	\N		2020-05-12 22:51:51.51	2020-05-12 22:54:22.181	13669c48-73ee-492e-b1b5-6a168f213d8a	13669c48-73ee-492e-b1b5-6a168f213d8a	\N	f	\N	\N	\N	This is an administrative project to account for staff time supporting the launch of BC Bid 2.0	This is an administrative project to account for staff time supporting the launch of BC Bid 2.0	t	\N	f62f21ca-4f27-4c07-a26c-9301b20c3990	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	40
c78ac814-41f2-47df-adbd-ad4e8a7108d7	24/7 Mental Health Counselling and Referral Service for Post Secondary Students		\N	2020-05-29	4	0	a2127b12-c103-4722-89e3-cbcc8a544245	\N		2020-04-30 18:39:10.4	2020-04-30 18:39:18.923	13669c48-73ee-492e-b1b5-6a168f213d8a	\N	\N	f	\N	\N	\N	Contract was awarded, lessons learned exercise outstanding.	Easy access to counselling support for post secondary students in BC.	f	\N	afd9d57c-cd78-4986-93d5-1a06d8000c36	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
cf7c4e65-b95a-4fea-aa49-96acb87290b2	Telecom Expense Management System		\N	2020-07-31	1000000	5285	2d99034e-ba45-4768-87e1-e76c1a72d5eb	8b436459-b4c6-424b-ad53-ebd55d2e5483		2020-04-24 18:27:36.602	2020-04-24 18:45:52.489	2d99034e-ba45-4768-87e1-e76c1a72d5eb	2d99034e-ba45-4768-87e1-e76c1a72d5eb	\N	f	\N	\N	\N	This SaaS needs to be running smoothly prior to re-procurement of the telecommunications deal if multiple suppliers are desired. 	A solution that can be used amongst all Ministries and BPS. Cost savings and efficiencies. 	f	\N	cef833f6-8425-45e2-849d-e70a580bc417	15b3f630-3c1f-4402-8e08-6591f3d8ba13	29
b9c3488f-9a6f-4822-8f96-091df3aeebd1	Stakeholder Management System		\N	2020-08-31	450000	0	\N	13669c48-73ee-492e-b1b5-6a168f213d8a		2020-04-27 16:45:52.172	2020-04-27 16:46:19.788	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	\N	f	\N	\N	\N	Continue to manage communication via excel spreadsheets\nPotential of missing key communication to stakeholders`	Completed SMS that will assist with the communication for the three major TI Corp projects	f	\N	bbe38f61-7286-4eff-8b85-7e5537a6e056	15b3f630-3c1f-4402-8e08-6591f3d8ba13	\N
09adba45-2dc0-4cf9-9fff-d6349df6909a	Coroners Case Management System		\N	2020-06-01	3000000	0	915dbc07-9e45-4ec8-ac12-7586fb9ba033	\N		2020-04-29 18:38:18.424	2020-04-29 18:38:56.505	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	\N	f	\N	\N	\N	inefficient intake of Coroner cases, management, and data analysis	effective end to end Coroner Case management	f	\N	20720905-a3ae-4bf9-a139-c9526b11fd99	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
3ac87f98-0849-4f89-924d-cc6f3a84ce01	Network Equipment and Associated Goods		\N	2020-09-30	6000000	0	8880f74e-e2e5-4646-bd80-b285d653d0c2	\N		2020-04-30 18:41:15.546	2020-05-05 17:13:24.684	13669c48-73ee-492e-b1b5-6a168f213d8a	\N	t	t	\N	2020-04-28	Was previously a CSA but now is a MSA	OCIO would need to consistently use ITQ's for purchasing of Network Equipment for the Province.	One VAR supplying Network equipment for the Province.  This is significant infrastructure and is a critical service built on this equipment.	f	\N	cbb802a9-2480-4bd6-862e-6484d611bce2	15b3f630-3c1f-4402-8e08-6591f3d8ba13	\N
417d98d1-cdfd-4431-987e-859ffc9257f2	Fish, Wildlife and Ecosystems Project Management and Implementation		\N	2020-08-31	20000000	0	\N	\N		2020-04-30 18:44:59.442	2020-04-30 18:44:59.442	057ce701-b6ab-4e56-a352-acf238b6b814	\N	\N	t	\N	2020-06-30	Expires June 30, 2020	Critical environmental services not being completed	A service provider with strong project management and implementation practices	f	\N	26d63cf2-b2f4-41ea-810d-64e67fc969ce	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
a9ef1e50-f0e3-4d64-a1df-c1187bf34b2f	Network Equipment and Associated Goods		\N	2020-09-30	6000000	36500	8880f74e-e2e5-4646-bd80-b285d653d0c2	871a6a46-86f3-4a9c-80aa-518800eed1b6		2020-04-30 18:42:30.389	2020-05-05 17:21:04.796	057ce701-b6ab-4e56-a352-acf238b6b814	8880f74e-e2e5-4646-bd80-b285d653d0c2	\N	t	\N	2020-04-28	Was previously a CSA but now is a MSA	OCIO would need to consistently use ITQ's for purchasing of Network Equipment for the Province.	One VAR supplying Network equipment for the Province.  This is significant infrastructure and is a critical service built on this equipment.	f	\N	cbb802a9-2480-4bd6-862e-6484d611bce2	15b3f630-3c1f-4402-8e08-6591f3d8ba13	36
fa38f829-2342-4781-a9af-89e078a42dd9	Advertisment Placement Services		\N	2020-09-30	10000000	15000	228e25cb-a091-4c40-9c60-751c784d8852	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a		2020-04-30 21:33:57.712	2020-05-01 21:28:23.545	13669c48-73ee-492e-b1b5-6a168f213d8a	228e25cb-a091-4c40-9c60-751c784d8852	\N	t	\N	2020-05-31	Contract split into two (Traditional and Digital Media). This procurement will follow a similar approach.	Province suffering in advertising planning and buying.	A trusted service provider that the Province can work with collaboratively. 	f	\N	e5176800-b29b-4cf4-bbcf-a2c2774e00b6	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	32
ca002197-8b36-4395-a9b0-4ad50b6223f6	LED Street Light Luminaires CSA		\N	2020-05-31	1	0	871a6a46-86f3-4a9c-80aa-518800eed1b6	8880f74e-e2e5-4646-bd80-b285d653d0c2		2020-04-30 18:40:02.019	2020-05-07 17:41:06.452	057ce701-b6ab-4e56-a352-acf238b6b814	\N	\N	f	\N	\N	\N	CSA	CSA	f	\N	a61cb016-8904-4fa6-9e78-98741fad9df8	30371b0e-bb09-40e1-95ee-7d97550021af	\N
b0245539-30d8-486e-bd3a-857d283fec62	Administration		\N	2025-12-31	1	0	\N	\N		2020-05-01 05:07:38.785	2020-05-01 05:22:46.481	13669c48-73ee-492e-b1b5-6a168f213d8a	13669c48-73ee-492e-b1b5-6a168f213d8a	\N	f	\N	\N	\N	This is for internal Administration tasks. 	This is for internal Administration tasks. 	t	\N	fe331179-3f09-4db0-b85d-53e6086fc8ed	82fc095a-4811-493a-937a-6800dc758596	33
ea6c0de6-9305-476e-8afa-3647b2f9b472	Ad-Hoc Advice		\N	2025-12-31	1	0	\N	\N		2020-04-30 23:22:52.802	2020-05-01 05:23:52.048	13669c48-73ee-492e-b1b5-6a168f213d8a	13669c48-73ee-492e-b1b5-6a168f213d8a	\N	f	\N	\N	\N	Internal Administrative Project, for the entry of project support around Ad-Hoc Advice.	This is an all staff project that may have varying levels of support depending on the individual and their role.	t	\N	b3a6e117-436e-4fda-ae24-956516473a80	82fc095a-4811-493a-937a-6800dc758596	33
4053e10e-3d25-4697-9be6-d4bd5f149981	First Nation Consultation Applications Support 		\N	2020-06-24	2	24882	a2127b12-c103-4722-89e3-cbcc8a544245	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a		2020-04-29 18:37:29.857	2020-05-04 15:28:06.669	3e9a3591-d6b2-4b46-a426-5e0872553673	a2127b12-c103-4722-89e3-cbcc8a544245	\N	t	\N	2020-06-30	Three Applications have been developed to simplify practices in consultation processes for provincial government staff and ultimately First Nations. The Applications are currently in various stages of development and implementation and include:\n•\tPIP – In Production, being implemented\n•\tARTS – In Production\n•\tFNCS – Being migrated to Production at present \n\n	Extension of the existing contract with the incumbent to facilitate service continuity until a competitive process is completed.	\nThe establishment of relationships with Indigenous peoples and communities through reconciliation of the Province’s interests with those of Indigenous communities, including consulting First Nations on proposed activities that may impact their interest.\nThe deliverables will bring together consultation information, maps, processes, and systems across government into a unified solution.\n	f	\N	fae0508c-a5e6-4610-9bcf-6f0b500f76ce	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	3
e27823b2-ee5a-40ee-bd78-1111c18a6fb7	NOI for Grant Management Software		\N	2020-05-14	130	650	a2127b12-c103-4722-89e3-cbcc8a544245	\N		2020-04-30 18:40:07.402	2020-05-01 10:07:16.189	13669c48-73ee-492e-b1b5-6a168f213d8a	a2127b12-c103-4722-89e3-cbcc8a544245	\N	t	\N	2020-06-20	There are two key functions of the grant management software: \n1)\tAdministration of the Application Funding Process:\n•\tWhile the Rural Dividend Program (RDP) is currently suspended, the software continues to be used to distribute economic development funding; for example, the Community Grants that were distributed in March 2020 (these grants funded projects that have up to a 3-year duration for completion, so minimally, an online system will be needed for monitoring and reporting); and  \n2)\tOversight of Previously Funded Projects:\n•\tThe software will continue to be used to support the oversight and monitoring of previously funded RDP and Community Grant projects. \n\n	May have to go to the market to undertake a competitive procurement process as soon as possible. Service continuity may be impacted. 	The availability of a contractor to provide maintenance and enhancement support if and when required.	f	\N	5bf36e16-5dca-42ca-b381-2600fbde5002	15b3f630-3c1f-4402-8e08-6591f3d8ba13	31
632f3cbc-9e1b-40f7-9c83-4355a638f1f5	Ministry of Finance Tobacco & Fuel Tax 		\N	2020-10-31	20000	0	60b73394-cdfd-4aba-b557-80fcc8cc9ad6	3778745c-f1c5-4013-ae07-75bd4798ea32		2020-05-07 18:48:07.757	2020-05-07 18:49:04.944	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	This project is to update a paper based system that has been in existence for many years.  It can continue to operate as is indefinitely if this procurement were to fail. 	To replace a paper based system with a real time validation system that interacts with the current tax system.	f	\N	39536cc1-45fc-4274-9e0d-26a78d743f23	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
12b59b16-e92d-471d-b872-e793e0813979	Managed Print Services		\N	2021-09-30	42000000	207360	f6b65221-f597-488b-aaa8-bed90aacfaf8	c246f349-bb5e-4309-861b-706bc6b232c1		2020-05-01 21:56:11.038	2020-05-01 21:58:18.991	f6b65221-f597-488b-aaa8-bed90aacfaf8	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	t	\N	2021-09-30	Part of hosting contract, added on by contract amendment.	Impact to print and imaging services in Province.	Transition services, gained efficiency (not necessarily cost), improve transparency.	f	\N	eff4b409-bda6-4a50-aaf9-7c1e4c310173	15b3f630-3c1f-4402-8e08-6591f3d8ba13	34
28695bb2-07d6-42e4-9194-51c361f6f686	Entrust CSA amendment		\N	2020-05-15	1	0	057ce701-b6ab-4e56-a352-acf238b6b814	\N		2020-05-07 18:46:13.222	2020-05-07 18:47:22.984	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	.	.	f	\N	d17fbefd-fd59-46f2-85b5-1a5bde73b813	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	Resources for ADMS		\N	2020-05-31	6100000	3846	f6b65221-f597-488b-aaa8-bed90aacfaf8	c246f349-bb5e-4309-861b-706bc6b232c1		2020-05-01 22:16:30.713	2020-05-01 22:18:21.863	f6b65221-f597-488b-aaa8-bed90aacfaf8	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	f	\N	\N	\N	Gap in services for ADMS.	Successful transition, services provided.	f	\N	5fe63915-6979-47b9-a701-cad9d87f5de2	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	35
c38d894c-4754-4722-b6c6-a289bc3f2a94	Workplace Development Services		\N	2021-12-30	1	100000	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-05-06 16:37:51.563	2020-05-07 19:42:19.14	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	various	various	f	\N	347e946b-7a5e-45ae-8942-083237fdd31f	30371b0e-bb09-40e1-95ee-7d97550021af	39
089d4afa-b82c-4312-9570-95987f609d58	Royal BC Museum		\N	2021-12-30	1	42179	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-05-06 16:23:12.134	2020-05-06 16:25:03.883	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	f	\N	\N	\N	various	various	f	\N	4626e83d-0c05-4a4c-a54c-5113bb33bcd4	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	38
62f61778-f0bd-4de1-890a-8cd685dcd354	Audio Visual Goods and Services CSA		\N	2021-12-30	1	0	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-05-07 16:42:01.642	2020-05-07 17:39:23.861	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	.	.	f	\N	3bda62ba-b1ce-4610-a1e5-38b0546eb06b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
d8d8c60f-9eac-4bd5-bc84-f4c574930a7f	IM/IT Security Services		\N	2021-12-30	1	0	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-05-07 16:41:53.48	2020-05-07 17:39:32.149	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	.	.	f	\N	6e995550-e598-4e6b-88b9-30f6e6f013a7	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
22e03b6f-53be-44ac-bcba-42d807c9a985	Playground Equipment CSA		\N	2021-12-30	1	0	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-05-07 16:41:49.06	2020-05-07 17:39:40.15	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	.	.	f	\N	4840b860-dca8-4806-83e0-c9bd415909f9	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
59cbef91-ffef-4b8b-825f-5a59ce8a7201	Uninterruptible Power Supplies CSA		\N	2021-12-30	1	0	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-05-07 16:41:45.346	2020-05-07 17:39:51.791	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	.	.	f	\N	5284d7f4-0e5f-4222-8509-f153ee4fb563	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
802cc104-4978-4e15-8038-8e80488e6116	Pipe-Open Bottom Culvert/HDPE/Galvanized Steep Pipe, Pipe Arches CSA		\N	2021-12-30	1	0	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5	ff341b3b-6c79-421c-951a-0e199f8693d8		2020-05-07 16:41:40.15	2020-05-07 17:40:06.642	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	.	.	f	\N	2f60f58b-2834-4678-872a-69eb305ed8d5	82fc095a-4811-493a-937a-6800dc758596	\N
6b40a6a0-2154-4188-9b4f-867d438efead	Executive Coaching CSA		\N	2020-05-31	1	0	871a6a46-86f3-4a9c-80aa-518800eed1b6	8880f74e-e2e5-4646-bd80-b285d653d0c2		2020-05-07 17:37:04.436	2020-05-07 17:37:54.344	057ce701-b6ab-4e56-a352-acf238b6b814	\N	\N	f	\N	\N	\N	n/a	n/a	f	\N	68027b50-b39c-41bc-a299-2fb459855c87	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
303960cf-e68e-47b8-b3c5-b23e74dfdabc	Document Destruction (Shredding) CSA		\N	2020-05-31	1	0	871a6a46-86f3-4a9c-80aa-518800eed1b6	8880f74e-e2e5-4646-bd80-b285d653d0c2		2020-05-07 17:34:04.246	2020-05-07 17:38:05.744	057ce701-b6ab-4e56-a352-acf238b6b814	\N	\N	f	\N	\N	\N	n/a	n/a	f	\N	f09638be-14dc-4463-bcdd-7ec4e4b4d3e0	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
a922a216-d92c-4c17-a3f4-cb168919cc54	Airfare Discount Programs		\N	2020-05-31	1	0	871a6a46-86f3-4a9c-80aa-518800eed1b6	8880f74e-e2e5-4646-bd80-b285d653d0c2		2020-05-07 17:33:56.425	2020-05-07 17:38:15.528	057ce701-b6ab-4e56-a352-acf238b6b814	\N	\N	f	\N	\N	\N	n/a	n/a	f	\N	ae577ef5-ff64-47c0-8350-779fb8ec7fa1	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
0c5955f7-b433-4ff0-b44f-456492abebc8	OS NRFP program related (Bryn's time)		\N	2020-05-31	1	0	871a6a46-86f3-4a9c-80aa-518800eed1b6	8880f74e-e2e5-4646-bd80-b285d653d0c2		2020-05-07 17:33:23.085	2020-05-07 17:38:28.033	057ce701-b6ab-4e56-a352-acf238b6b814	\N	\N	f	\N	\N	\N	n/a	n/a	f	\N	f3175941-89af-4409-881c-6d560d1f2739	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
29ff1b94-baf1-44dd-866a-7c4795f66982	Flextrack Vendor Management System		\N	2020-05-31	1	0	871a6a46-86f3-4a9c-80aa-518800eed1b6	8880f74e-e2e5-4646-bd80-b285d653d0c2		2020-05-07 17:32:57.154	2020-05-07 17:38:39.503	057ce701-b6ab-4e56-a352-acf238b6b814	\N	\N	f	\N	\N	\N	n/a	n/a	f	\N	95bfabe1-898a-428f-b865-cff52ca883a3	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
7d12d0b0-370f-42cf-9b35-7c65489b736a	Office Supplies & Associated Services RFP		\N	2020-09-30	24000000	0	871a6a46-86f3-4a9c-80aa-518800eed1b6	8880f74e-e2e5-4646-bd80-b285d653d0c2		2020-05-07 17:31:37.385	2020-05-07 17:38:53.143	057ce701-b6ab-4e56-a352-acf238b6b814	\N	\N	t	\N	2020-12-31	MSA set up and used all 3 one-year extension years.	Government having to pay higher retail prices for office supplies, lack of control of spend by commodity and value, higher delivery costs, no contracts with numerous suppliers	MSA in place with favourable pricing and ordering and delivery service up and running to except orders as of January 2, 2021,	f	\N	b796d999-023a-4ad5-a02a-80bcc0330900	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
3fb37573-577e-4be1-b720-d8a5c8a57cf0	Positive Airway Pressure Devices		\N	2022-12-31	320000	0	8880f74e-e2e5-4646-bd80-b285d653d0c2	871a6a46-86f3-4a9c-80aa-518800eed1b6		2020-05-05 20:31:12.261	2020-05-07 17:40:34.145	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	These Standing Offers are to meet the medically essential needs of eligible Clients from SDPR purchases for CPAP devices.	Standing Offers for the purchases of CPAP 	f	\N	a587ddb4-9574-44ef-9c51-7612f99eb5b7	fc25a9e1-b6e7-4abc-a81b-15d1b822da25	\N
4cae427d-0ea7-4919-8d2f-518e28ee7519	Anti-malware (software licences) CSA		\N	2022-04-01	1	0	ff341b3b-6c79-421c-951a-0e199f8693d8	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5		2020-05-07 20:56:05.748	2020-05-07 20:56:45.835	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	.	.	f	\N	04c55139-fdc0-477c-9832-67cabc8cd639	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
89f445e4-64a0-44be-877d-024891a0d2c2	Employee Safety Monitoring Services CSA		\N	2021-12-31	1	0	ff341b3b-6c79-421c-951a-0e199f8693d8	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5		2020-05-07 20:56:12.232	2020-05-07 20:57:05.946	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	no safety provided to employees	employees working alone, in isolation or settings that may be deemed unsafe are set up with the Services to ensure employees are safe	f	\N	e10e3798-494b-4442-844c-aee16e398602	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
89b02e76-d8f3-469e-88b7-1cd79304c9a5	Facilitation Services CSA		\N	2022-03-31	1	0	ff341b3b-6c79-421c-951a-0e199f8693d8	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5		2020-05-07 20:56:15.93	2020-05-07 20:57:35.288	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	office will have to complete their own solicitations 	facilitator is a neutral third party to facilitate various types of meetings, communications etc. 	f	\N	86afd08b-6e98-4377-83fd-de9e35a361d2	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
e3733822-0bde-4665-96fd-4238ca1713fa	Furniture CSA		\N	2022-01-14	1	0	ff341b3b-6c79-421c-951a-0e199f8693d8	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5		2020-05-07 20:56:20.564	2020-05-07 20:57:55.181	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	.	.	f	\N	6600441d-112e-44e6-b082-2fb450d6ed58	82fc095a-4811-493a-937a-6800dc758596	\N
6c7eea3c-dbc0-4b55-9cff-30f0402dc78f	Translation and Interpretation Services		\N	2023-10-01	1	0	ff341b3b-6c79-421c-951a-0e199f8693d8	4a0ca59e-f151-4b05-9279-6f2a3ef0a0e5		2020-05-07 21:00:34.384	2020-05-07 21:00:50.55	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	\N	f	\N	\N	\N	.	.	f	\N	8ffa6cb3-0d66-4e60-b0b7-41afa899981c	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
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
9f13d1db-fb28-413a-b80f-22fc954d6719	f9211d4d-6e4c-4c16-8ff1-e11533648789	99a23a1b-4a2b-4ade-a5ae-fec518edb751
4a089a8b-bf3a-437b-baab-c87ccf4ad532	e27823b2-ee5a-40ee-bd78-1111c18a6fb7	249d38e4-475b-4b73-ab2c-082ce3d6d0f9
60d688fe-0af1-43f4-a224-6b07aaab0aa4	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	03e3bb26-b351-4764-9306-c730c4021b4d
2f0b5cc3-9b58-4b5b-8bb1-52f4f0aac863	7d12d0b0-370f-42cf-9b35-7c65489b736a	e04ae49a-a1f2-4ae0-829c-c70b0e288931
7a1c7650-4a52-46fc-8a8f-890355bc8b8a	4cae427d-0ea7-4919-8d2f-518e28ee7519	1e5a6295-e46d-4e6d-85fb-35e77c04a2c8
6d915da5-4325-4e33-89ee-c42919a5b99f	89b02e76-d8f3-469e-88b7-1cd79304c9a5	84013463-5677-4365-8c67-c31b57c12824
638f936c-4e8d-4df8-95c4-b54e549d10c5	d930683b-68e0-44f5-a31d-398815e32909	b793367b-c15e-4376-8f3b-4a34605e7400
202fc1ac-268e-4b1e-9f9e-25e60d772ccc	80f44db4-8489-4144-bd99-25734ee64bae	499b37a4-b05a-4d6d-8161-c58266a25155
ef2c7bdb-07e8-473c-a10d-9d05193d4d55	f9211d4d-6e4c-4c16-8ff1-e11533648789	23e3cd97-345a-40bf-b698-02fce7b0c1e5
555bd519-f072-4aa2-83e8-e22c136bc235	3ac87f98-0849-4f89-924d-cc6f3a84ce01	dc8342dc-3552-428c-9083-fe209e3e4c87
b0e2d741-bc83-4846-b99c-1e72a10745e3	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	1df1ff83-ef73-4a34-9417-a5e3bcb30ee0
248a5fd4-a63e-400e-80c6-5365ca9e53f3	29ff1b94-baf1-44dd-866a-7c4795f66982	6a0f5f62-c649-4715-9508-e2898f76c559
e1750a7c-c5ed-49de-a764-3bb4e06f1244	4cae427d-0ea7-4919-8d2f-518e28ee7519	21ed117d-3701-478a-9c6f-72a18c43fd47
0d095c45-1b46-4cc9-81f2-385785e1aa57	89f445e4-64a0-44be-877d-024891a0d2c2	7f185e90-69b4-409d-b4d5-a93cd28051f6
955e6716-ba99-4aaa-946a-bf8824337921	d930683b-68e0-44f5-a31d-398815e32909	8e76b806-ced5-474e-a51b-239cd43a2cfe
79f41721-5e99-47de-a031-07ea475f0bba	a0a72451-9577-4ab4-bec9-f1a236243805	0e7cb963-26b7-4d32-a9c5-054b2f0aff68
952f8f8c-ba73-4691-801a-80ea10d60ef2	f9211d4d-6e4c-4c16-8ff1-e11533648789	73d93e32-6d7e-4552-b4a1-6a8225a20a69
b36958b7-5f94-4d94-923a-4546d09b7c4e	3ac87f98-0849-4f89-924d-cc6f3a84ce01	4b2e71fc-1cd4-48e1-9424-9ba1f28acff6
bea7edb2-f873-43e9-9de3-47628e6128ba	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	edf71bd2-cfa8-4b54-8920-cd9e676964e4
40e665d8-82e7-4316-98c4-034ce65a91bf	29ff1b94-baf1-44dd-866a-7c4795f66982	2032e970-371b-4f41-93cd-ced37d132571
3c75d854-4fbe-4864-83f1-2e4e9db78e00	89f445e4-64a0-44be-877d-024891a0d2c2	c6e77528-19ba-4abf-bb48-83d42fa717ba
dc60653e-0bf9-4400-a133-78308fa3b6eb	89b02e76-d8f3-469e-88b7-1cd79304c9a5	f7a97cd6-d162-4e2f-9e32-7455b7035499
4ef70cce-db24-4d37-bba4-a0be1e3ced7f	4c70dd71-1938-4a01-a86b-ced42b12c11e	ff35de9f-9b3b-4c4f-8bf8-1d72a550485f
2f0e212c-b88d-4eb5-88a4-a590ebc9ac61	4c70dd71-1938-4a01-a86b-ced42b12c11e	69e14066-dfe5-48d5-93c7-243fba7b85b3
b39da071-31e3-4bc2-99f5-6f753614d0c9	a0a72451-9577-4ab4-bec9-f1a236243805	a3bbc881-2635-413b-b393-87c830f0c11c
97848834-3242-40c6-8b7d-86abf38088f0	05bee9b0-882a-4ed6-8bf8-1d0fdb01117b	73d93e32-6d7e-4552-b4a1-6a8225a20a69
6fe33fc3-c2be-45dc-be62-ffce79047c81	3ac87f98-0849-4f89-924d-cc6f3a84ce01	86dcc5bb-6335-49b1-8118-6ea5c7f4f2b7
1afe2722-b734-40b6-adb9-7d969be60eb7	3fb37573-577e-4be1-b720-d8a5c8a57cf0	5c8dee5e-8d2c-42f2-afe5-39033fb605b1
103b5838-bf31-48b6-81a7-a3731d967890	29ff1b94-baf1-44dd-866a-7c4795f66982	91ef4fab-c7d3-4c29-8a09-3ed56951a8ba
ce19c3d3-d9b8-401e-a9bc-5421cbb84205	89f445e4-64a0-44be-877d-024891a0d2c2	7166ee0b-745e-4256-b552-4efadbb3c83e
d9bd390b-7a43-4289-ab65-dc14194b03ae	89b02e76-d8f3-469e-88b7-1cd79304c9a5	3f30c632-8551-435c-9189-5edbadb5ca2b
bf6cbfb2-07a0-4fd3-acb6-dff7333a24dc	4c70dd71-1938-4a01-a86b-ced42b12c11e	ea526c93-bfe2-4b46-b337-1d10bb59a4a9
a3b1fa2f-b070-48bf-9705-4de82b9bca5c	a0a72451-9577-4ab4-bec9-f1a236243805	59c4d2e0-99a3-462e-afbf-6b815fc18500
df798aca-66ff-4f53-a736-69a4ba85260c	05bee9b0-882a-4ed6-8bf8-1d0fdb01117b	23e3cd97-345a-40bf-b698-02fce7b0c1e5
eeb9ac97-2664-4663-8c32-59bba28358d3	a9ef1e50-f0e3-4d64-a1df-c1187bf34b2f	dc8342dc-3552-428c-9083-fe209e3e4c87
29459174-91ac-4594-ad69-a72048cb815c	3fb37573-577e-4be1-b720-d8a5c8a57cf0	dab6710d-eb26-428f-9728-fa1dfa8b0071
5f28de5e-0e19-4bd4-a4ab-cfc9264c7430	0c5955f7-b433-4ff0-b44f-456492abebc8	39d60e9f-f8d1-4d03-ad0b-2f8d9a497472
bcaabc7b-9ee0-428b-9d39-4dfe2cec397a	89f445e4-64a0-44be-877d-024891a0d2c2	569d24ef-1cc6-43d5-89d6-c71a81604748
5efa288f-f963-47d6-a4c9-3269ddc1f616	2d2796cc-4950-4811-abf9-cebd2d9d7f01	81ca2106-9562-49f3-9224-99c4dd54e827
ba219d8e-a127-4bd4-91fb-60ce7ac543ba	92e963f3-70a4-4f95-b6e0-b86c062aba6d	f36adf1c-6dc1-4769-9a46-19dd0a6b75cf
f32c17aa-dd86-4d3b-bb1e-1e9c3f627dd2	92e963f3-70a4-4f95-b6e0-b86c062aba6d	b8b2bf6f-c50c-4774-bd4d-2045d1a2bc64
6cf34138-6101-4e00-bfe3-49093c07d9f2	05bee9b0-882a-4ed6-8bf8-1d0fdb01117b	99a23a1b-4a2b-4ade-a5ae-fec518edb751
4edd3326-ba7f-4981-b4e2-ad44e0c36aaf	a9ef1e50-f0e3-4d64-a1df-c1187bf34b2f	86dcc5bb-6335-49b1-8118-6ea5c7f4f2b7
a5c69abf-3160-48d1-b020-785db2e2f02c	3fb37573-577e-4be1-b720-d8a5c8a57cf0	6d7cf5cc-900a-46a1-849b-c21420c43237
c7bcadb1-7e87-4c03-8e29-e4adcb55d362	0c5955f7-b433-4ff0-b44f-456492abebc8	3d0c7d5f-4a52-4d6c-bbe6-ab9f11dd3c72
540bd1fa-9388-44ce-b04a-84e733c1ee17	e3733822-0bde-4665-96fd-4238ca1713fa	3c5507e7-8fa9-439b-abb5-482ee749605f
fe514f6e-2007-4bf3-bfc0-c6adf8d4dd4e	2d2796cc-4950-4811-abf9-cebd2d9d7f01	23c5ca18-cee6-4b87-bb4a-66460aee5ca4
bf8e0c38-7ec4-4114-a623-b54cafbe37dc	92e963f3-70a4-4f95-b6e0-b86c062aba6d	72ebbd26-e4a2-495e-abda-5413f2c92e83
239718b5-9ef3-4efe-885c-c3ba4cb60d13	b9c3488f-9a6f-4822-8f96-091df3aeebd1	c128ae1a-d76c-4be7-8e3c-a6fc4a59c64d
67e243bf-2710-4944-8cf5-70697abb8cec	b9c3488f-9a6f-4822-8f96-091df3aeebd1	8d5ecfaf-17e5-4fd7-8ceb-72daa3a24ed3
9ec4d4ea-8a79-4259-a947-7af924d17fc2	a9ef1e50-f0e3-4d64-a1df-c1187bf34b2f	4b2e71fc-1cd4-48e1-9424-9ba1f28acff6
7a458da3-0934-4292-97d6-cf07c0a049d0	089d4afa-b82c-4312-9570-95987f609d58	f63d648a-2f5c-4328-8cd1-cffd75a59505
85264533-b117-4936-84cd-981f7b159118	0c5955f7-b433-4ff0-b44f-456492abebc8	f5d6df4f-a6fc-460e-a509-28b80c751454
dda98781-dc1f-4c8f-bc4b-e00e0ea61150	e3733822-0bde-4665-96fd-4238ca1713fa	e0978ebd-f166-419a-8155-2203c56a023e
f9a6a3bd-0d10-47bd-8c42-5578e434998e	2d2796cc-4950-4811-abf9-cebd2d9d7f01	077dd07e-5d01-4268-973f-94ed86a37121
3f1b85f5-0fb6-4e02-9817-f61913c51711	99543d57-26fd-4ba4-8f31-668bab5f7773	467b9a1f-6e80-4390-82bc-b7ab1a5f460a
f2f27c33-ee17-48a6-8c75-8899882bd81b	99543d57-26fd-4ba4-8f31-668bab5f7773	008d9c46-9f4a-4582-91f0-6c08cbf2459b
a12d5f4f-d3c2-4c40-a9ec-6e9245b16498	b9c3488f-9a6f-4822-8f96-091df3aeebd1	8a8edd83-281f-449f-9d91-9dc57cf943e4
3f831cb1-bcf1-4b6b-95e6-a0d0cbbc07b9	417d98d1-cdfd-4431-987e-859ffc9257f2	0bf18159-89ab-4593-a5c2-defbe6dc51ee
3fc2d382-a466-4880-8b7a-956e06a202af	089d4afa-b82c-4312-9570-95987f609d58	e52186c4-b70a-4591-8515-b2525d63c4e5
29c59fdf-8fa6-4673-bc95-9435e97c215f	a922a216-d92c-4c17-a3f4-cb168919cc54	d66b6700-d699-422b-92df-2ed60f32b7e6
946416d6-7e19-48db-8406-543e461b7299	303960cf-e68e-47b8-b3c5-b23e74dfdabc	5aed62f7-c4dc-42c5-9c6e-da09f6d1f113
7ed3e004-573d-474e-b1b2-1dd0306c6128	e3733822-0bde-4665-96fd-4238ca1713fa	8ab02188-799d-42b6-ad0a-3a24ba1f81c3
ac94a811-4722-46b4-b14f-135b268884ee	3e06c426-422c-4bf0-923f-94e0aed5c43b	a3a9928e-561d-4b71-9744-398d98692366
5bd8e1f7-e717-41e5-acee-1952160a3031	99543d57-26fd-4ba4-8f31-668bab5f7773	d95bc8be-deb9-4bbe-a12a-1eb964497872
76319cc6-7b05-4fa0-9280-1e2a9cc13f0e	4053e10e-3d25-4697-9be6-d4bd5f149981	c57b3f29-c665-43e7-9054-9fd3b4d6128e
83418047-8161-4512-aa5a-4c099ad27ed1	417d98d1-cdfd-4431-987e-859ffc9257f2	bab69975-a938-4d52-97d2-6c378d346b9e
0cbd5fe5-c530-4f50-a15a-5f73be5d71cc	089d4afa-b82c-4312-9570-95987f609d58	80858d85-6e6e-4fd2-bb03-32df56e4dc9d
4f167c41-0400-462d-b39a-034b926c47a7	a922a216-d92c-4c17-a3f4-cb168919cc54	210eb957-fe3a-4256-9072-d877cf56be1a
b85115e1-efff-4676-8e67-e25da9bb8e60	303960cf-e68e-47b8-b3c5-b23e74dfdabc	f1735c92-9ff4-4989-81a9-7a30956b5f8c
f7f2466f-42a5-4731-9047-f7cf7b417359	6c7eea3c-dbc0-4b55-9cff-30f0402dc78f	8aa6c5a4-fac7-4d68-8058-213a12022207
1206d59a-b8db-4196-b671-825be5d563a7	02c89fe1-3496-46f1-b833-db0fe0d08e12	a3a9928e-561d-4b71-9744-398d98692366
973ab06b-c03b-4f51-8eb9-1437916e5375	2c933486-0a9b-40de-adc9-eaa9319a16f2	46afe217-22b8-48b6-8142-508512f80018
284c12c9-a40b-44c4-9d77-3ca0841d0db4	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	4c3d402f-f970-4e21-8120-e7411ae8d9d5
ae328cc5-772c-46aa-8f21-cd39c17918d3	4053e10e-3d25-4697-9be6-d4bd5f149981	8fed6ee8-6b61-4aa6-82f7-8e66f11d9687
5c8cfed9-d6c9-4bbf-8a18-c1c61991be14	417d98d1-cdfd-4431-987e-859ffc9257f2	015ab727-e4f2-4402-aaf8-cbc30827a949
3972f2cf-9fe2-43c0-a2db-499acc1f4ea0	c38d894c-4754-4722-b6c6-a289bc3f2a94	e328beb1-fe7c-4a02-92ce-fdfc7c21e93e
dec69365-43ef-40de-b4c6-de8734e1c0aa	c38d894c-4754-4722-b6c6-a289bc3f2a94	f5ed2282-aa00-4f9e-9a80-197a4360fa58
19ac8243-afac-496d-ada8-75f1158c6787	a922a216-d92c-4c17-a3f4-cb168919cc54	8f7ce9cf-97ad-49ca-96fa-4c93560ddae1
d3373be2-870f-4785-b17f-f5fe0cb9f087	6c7eea3c-dbc0-4b55-9cff-30f0402dc78f	16424a71-9a8c-4d6a-837a-72ea7bbe9408
76e335cf-fd17-4b7a-98fb-1d4dcac60fc1	02c89fe1-3496-46f1-b833-db0fe0d08e12	76849d01-3fee-4204-88df-3d026c3de8c8
9d4fc99f-cb8f-4d50-a154-4d16ab6ba1e5	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	13ed96d7-f082-4745-81e9-31b4d895c0bf
6e8fa1cf-693f-4f2c-b622-a08e74d763aa	4053e10e-3d25-4697-9be6-d4bd5f149981	39ca60d8-b95c-493d-abf6-756c67407a01
3c6f106a-92ba-42e2-8ca9-6db03dad7fbe	fa38f829-2342-4781-a9af-89e078a42dd9	484e4339-b341-4b56-aadc-70e2dc87f73a
2470f3e6-2bac-4784-8ce2-b072f37c2080	c38d894c-4754-4722-b6c6-a289bc3f2a94	e5e75305-8c09-4f96-b7b0-26b6d4b8eb48
0fb341a8-e077-4e52-907e-8bbe389733c5	303960cf-e68e-47b8-b3c5-b23e74dfdabc	4c58cd4b-832a-47e7-b51e-55424f6a997b
332459f3-4566-49a6-9e27-e61e3d90b94c	6c7eea3c-dbc0-4b55-9cff-30f0402dc78f	167cec82-cf24-40c1-a02c-a7a7ce1a25e6
8f68af5c-dea9-49f0-97a4-917323d3ccb8	02c89fe1-3496-46f1-b833-db0fe0d08e12	53393e30-7a21-40d8-89c3-91f1c65aab6f
99a5f613-bfcb-4ae6-8e57-3bd2fe967a51	2c933486-0a9b-40de-adc9-eaa9319a16f2	d6cfc8af-0a67-4095-8d99-057228d16f1e
88661065-792e-4cae-ba27-1e17805cdd59	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	5e6d47db-ee28-4416-9283-f1d2ab641747
ea99dba8-cfe4-4abd-83ca-72609820fadc	09adba45-2dc0-4cf9-9fff-d6349df6909a	8697899d-37a2-4ce0-a6c6-43d87b42ee15
9eb45b2e-0b96-43a4-ac49-c9f37d815bd3	fa38f829-2342-4781-a9af-89e078a42dd9	b07dffcd-e67a-4f5e-90ba-435031a5c172
0bbb4468-10f8-4e44-b9e2-ac53cc23da6d	802cc104-4978-4e15-8038-8e80488e6116	a589814a-1164-47af-8870-7c51fa75a70d
52e3e353-c30c-4343-acd3-220e642061ca	59cbef91-ffef-4b8b-825f-5a59ce8a7201	511759fd-4baf-4fd3-b79c-43a838c93028
f990a0d7-303a-44e0-bdd6-709661c09e20	22e03b6f-53be-44ac-bcba-42d807c9a985	cfc2374b-8101-4079-988b-0324dbbebe47
524c45ce-6f94-48d0-bffa-b3f000668903	6b40a6a0-2154-4188-9b4f-867d438efead	218ed232-8da5-4624-b3bf-4a1d54376c09
417df031-aa14-47f6-aa4d-be0d3e388cf2	7705fd59-37b6-4d8b-8f8d-fb1329569f8a	ecbc9cbd-1241-4a80-9558-f643f1884a88
373e0387-a2af-480e-8d61-5a796b424186	3e06c426-422c-4bf0-923f-94e0aed5c43b	53393e30-7a21-40d8-89c3-91f1c65aab6f
6e9a37e9-9c12-4024-ae8d-8b5676280556	8959e597-c09f-46b6-a515-b3ce076a9a94	2a3ab891-3ef7-4488-96d8-8b00238c2519
ec6a76c6-80ef-497e-8f8c-2ffa29ece13c	09adba45-2dc0-4cf9-9fff-d6349df6909a	0ce13432-f9c5-4615-95e0-a799e98f4dc0
f7600cf5-4ddb-4bfd-b6ea-2ff2bf736d49	fa38f829-2342-4781-a9af-89e078a42dd9	2a35708f-1a90-4a32-95f1-ac36c1054591
46d0bb8a-c48d-4758-8f73-51ea99b0fea0	802cc104-4978-4e15-8038-8e80488e6116	4808fcea-b59c-45f0-9b6c-c64504c4b6b4
825e95de-2176-452d-9830-320f6e644b48	59cbef91-ffef-4b8b-825f-5a59ce8a7201	830ab0b2-779a-4f06-b1bc-e792e025aebb
321d776e-c7ca-4945-a5cc-2e45b8a9bcae	22e03b6f-53be-44ac-bcba-42d807c9a985	eac172de-aa74-4050-9d6d-9d849deef1d7
4e3e9cdd-38a0-4618-9c9d-f4223bbd5f10	6b40a6a0-2154-4188-9b4f-867d438efead	0921d339-26d9-421c-8089-40fbed21047f
4a3b968d-266f-41d4-a88c-1717e6de66f3	7705fd59-37b6-4d8b-8f8d-fb1329569f8a	1a112b38-b8b2-4c5a-a200-f3dbacd77888
670ebeaf-efa7-4ea3-afd1-435d133c120a	3e06c426-422c-4bf0-923f-94e0aed5c43b	76849d01-3fee-4204-88df-3d026c3de8c8
baf045ed-6925-49fe-b3d5-32c7d22bbb13	8959e597-c09f-46b6-a515-b3ce076a9a94	979e8055-f884-439b-9741-2687c0ea7700
f41dcd1a-ec11-4e46-93b0-d7ab89db3403	09adba45-2dc0-4cf9-9fff-d6349df6909a	473a88a9-5cae-4067-9c92-3e25c2fded84
9b89dadc-108b-4fe7-95d5-fd2f188d0e60	ea6c0de6-9305-476e-8afa-3647b2f9b472	9c837a27-19cb-4dd8-8a6b-6b16ed469f23
c8bdeb4c-24f1-43ef-a5a7-78e1f055f783	802cc104-4978-4e15-8038-8e80488e6116	a981f164-44d0-4cee-81d0-f63f8a2cc66f
78ad3b11-7633-400c-b484-73a6189b2da9	6b40a6a0-2154-4188-9b4f-867d438efead	1c6865b7-485f-4cdf-bb03-111eceb70d7b
a6d611ce-779f-4bec-b7a5-3447ff57a74d	7705fd59-37b6-4d8b-8f8d-fb1329569f8a	5616b3d9-d971-4dd2-a9f8-3e6cb5fdd565
4639b96f-b75d-424b-88f0-2690ef68038f	2c933486-0a9b-40de-adc9-eaa9319a16f2	b6808d7a-97b6-4ec4-b3f9-16555d46f1ed
86e0e370-bc86-4454-9e6d-125cb5bc09f6	8959e597-c09f-46b6-a515-b3ce076a9a94	c26ca145-4876-4bff-b8d1-fdf877f1f3b8
cde13135-2e3f-4cc6-88a0-17607b91763f	c78ac814-41f2-47df-adbd-ad4e8a7108d7	f9848017-5433-489b-85b4-f3c60ddb2904
2370da1d-f895-4dda-a23d-41a3f20aef2d	ea6c0de6-9305-476e-8afa-3647b2f9b472	01107e5d-5ff0-494e-9035-5c670c92fd5e
7d1baba4-364a-4885-9891-1a2cca445400	59cbef91-ffef-4b8b-825f-5a59ce8a7201	d3aaafd6-8837-43ee-b2a4-27a7f66d8eca
5b8278d3-7baf-48a2-93c7-87e897b3900b	22e03b6f-53be-44ac-bcba-42d807c9a985	74d3b3a5-3014-4a2e-bb61-e7caabaece61
b24f6d26-3123-4d18-8387-05e3704ecb98	28695bb2-07d6-42e4-9194-51c361f6f686	c0fcaa1d-aabd-479c-ae31-1682735bd113
948869a4-b29e-4681-a1da-929056eaa195	c76b3ba0-bd37-4ff2-b659-67ebb8a768e8	1fec9b37-843d-4fe0-ab25-86728a0a0fae
e5d806ba-e2fd-40ac-a38b-a636844f88af	0da1c7d6-5b71-4232-8c20-ed2e52d08091	6f3fae5d-9967-4018-bb2d-f5a01a8c177e
ad3d41ab-7adc-4fe1-8d75-35effb13a820	c78ac814-41f2-47df-adbd-ad4e8a7108d7	df50547e-64fb-426a-b553-a07af4cbdb57
f69f29f1-1659-413d-b744-c0e88c00c24f	c78ac814-41f2-47df-adbd-ad4e8a7108d7	082a91da-834a-4289-8399-7ff126ad5f3a
a8f96587-94c3-48bc-a47e-3f64806b8883	ea6c0de6-9305-476e-8afa-3647b2f9b472	60a263b2-7766-4844-ae0f-c930a5a894dc
3a6fd9a2-a139-4369-988f-8c223bfb8fa0	d8d8c60f-9eac-4bd5-bc84-f4c574930a7f	f4907d38-8815-47fb-8ae7-c42c41f308a4
4827de67-2c3b-4c0f-9d44-83385153ebb6	62f61778-f0bd-4de1-890a-8cd685dcd354	a82598e3-a49b-4133-9cd9-71ab7c554d81
83d3065b-d836-496a-919c-a97786479fa6	28695bb2-07d6-42e4-9194-51c361f6f686	9bb88b2c-a1e0-4ab1-a761-89d60632916f
8e95c1f0-45cd-4f39-8ed8-5105ec36dd8d	c76b3ba0-bd37-4ff2-b659-67ebb8a768e8	b9f14763-733a-491d-8764-88475d17ecbc
a27c932d-fd24-41d9-99f3-629c67e847a7	0da1c7d6-5b71-4232-8c20-ed2e52d08091	55024d8a-7a6f-4249-82ed-114180db41c8
56fc90fe-9c11-4179-bfd1-bacd38e87ace	ca002197-8b36-4395-a9b0-4ad50b6223f6	dff168bd-74f0-4256-846b-8c2502143aae
33c7621e-5323-42da-8fae-94c7556b73d1	b0245539-30d8-486e-bd3a-857d283fec62	1e1b0e2a-9540-4725-a535-59270aae0b8e
1b42d949-3386-4da0-900a-c0d154377b3b	d8d8c60f-9eac-4bd5-bc84-f4c574930a7f	c68f0392-0612-4d13-a844-5c1c19c4f030
d482c268-d252-4677-b011-229074a5607f	62f61778-f0bd-4de1-890a-8cd685dcd354	9b0f638a-ed37-43a6-83ea-ff7de2626a45
d01a2f2e-f8a9-4393-85a3-6e030f44cbaa	28695bb2-07d6-42e4-9194-51c361f6f686	790abdc2-71bd-4924-ae10-d170e1401b7a
3b81e84a-2639-467b-962e-6d972aa82f8b	c76b3ba0-bd37-4ff2-b659-67ebb8a768e8	634418ee-7e13-474b-b702-88a309dc1103
c4ef32df-996d-436d-a6c3-9679c78ea479	0da1c7d6-5b71-4232-8c20-ed2e52d08091	d4ae139e-82d9-4ccc-ad0f-09b026e68432
53bc2f7d-49eb-48a2-aff3-d03e8204527f	ca002197-8b36-4395-a9b0-4ad50b6223f6	66ae3016-d501-4c49-a2d9-c7b0636905c6
66141729-d9b9-4359-aab7-3196ba495fbd	b0245539-30d8-486e-bd3a-857d283fec62	a55896e5-83a8-4fd4-9edd-dc85526fac1f
84b97216-0b9a-4816-b4f1-69f7e3119e73	b0245539-30d8-486e-bd3a-857d283fec62	4608169b-db13-487a-a4ff-e862420aa1a1
83127543-cea0-4162-aef4-e37ea135467d	d8d8c60f-9eac-4bd5-bc84-f4c574930a7f	35d62799-8bef-4cb7-b176-3458804e9f5a
d0bdc16b-3cac-4901-9aa0-426a19e54fb1	632f3cbc-9e1b-40f7-9c83-4355a638f1f5	3d7f343c-f906-421c-bd45-536427f70c79
16e8781e-d107-49ea-94f0-1dea719ca7ed	6680eec1-85c6-446c-86ef-677db7908c1a	b8b46117-65cb-4591-9604-495422427320
ebaf6ebc-0b10-4d9d-b877-f0c4816094c0	cf7c4e65-b95a-4fea-aa49-96acb87290b2	edf89f50-7b4d-4b2d-b03e-b0518d4aad25
d5a3b6d9-d1e3-49ce-9b7a-318aa5e4b165	ca002197-8b36-4395-a9b0-4ad50b6223f6	8ae0de39-6fe2-4b12-bdec-a876bc97836e
ef548a1f-89c0-43ad-a258-f65e10e503a1	12b59b16-e92d-471d-b872-e793e0813979	03a64e94-6d66-495c-89dd-86a076d35f51
617addba-7490-4307-a8a0-67c4172dbaee	62f61778-f0bd-4de1-890a-8cd685dcd354	eecb615e-4f55-4bc7-9b0e-0edb95a6e8e5
0eca9fe1-ddfb-48f8-b823-bdb31aac697a	632f3cbc-9e1b-40f7-9c83-4355a638f1f5	0b7b8774-215d-415b-afa9-f1443f8f3042
6a910a4f-b88c-494c-9aba-faecbed7dc7a	6680eec1-85c6-446c-86ef-677db7908c1a	0ff81989-e9d2-4a1d-baee-b6d10d22ae39
803870ad-f00d-4cb1-933b-74280939ea51	cf7c4e65-b95a-4fea-aa49-96acb87290b2	3c0c2dda-c68f-432f-baa0-d6329900224e
3da66eb3-67bf-4b0c-a7c1-eecb1afb899a	e27823b2-ee5a-40ee-bd78-1111c18a6fb7	dd4d7b59-9a28-4884-aac5-e298d4fcf436
650f7b8d-4cc2-44f8-9b40-b06861a09669	12b59b16-e92d-471d-b872-e793e0813979	9e2f63c4-9fa6-47be-8653-79dd8e910ae4
f2ff3154-c0b9-42ce-8151-eb9cf08ffdea	7d12d0b0-370f-42cf-9b35-7c65489b736a	4e2bcd30-9e38-4688-bc77-215689e2df9e
2536dfab-5f09-4a56-9745-9b03ccac500a	632f3cbc-9e1b-40f7-9c83-4355a638f1f5	35ff61f5-a2cb-44ed-9a5e-063262cc38e8
339844d4-72ae-46b9-8994-bb22b0f12547	6680eec1-85c6-446c-86ef-677db7908c1a	71d1d3d1-24a0-434f-ba55-06eab2a76b66
ee86a50a-6c35-44ad-a124-43f7f6b11add	cf7c4e65-b95a-4fea-aa49-96acb87290b2	ce611836-b270-471a-9738-711bcc991874
4437163c-0108-46a5-889a-fb77b3dc7252	e27823b2-ee5a-40ee-bd78-1111c18a6fb7	14d59b3d-e896-41fe-bb4e-def146e8328c
58b87908-e7ab-4559-8469-fb7b5a2e01cf	12b59b16-e92d-471d-b872-e793e0813979	112f1a0c-6d14-4b94-8969-2881f555094b
a66f0a8f-a71d-4f8c-8872-910e3c48a09d	7d12d0b0-370f-42cf-9b35-7c65489b736a	4b47df33-9695-4350-a190-1ec9b9d835b0
804fd4da-2fcb-4ac7-8b01-ceef473ff608	4cae427d-0ea7-4919-8d2f-518e28ee7519	f56d4bed-c184-427f-a0ca-876e9f05effb
acdc8688-300c-4d4f-be93-8d29e913f5a5	89f445e4-64a0-44be-877d-024891a0d2c2	2d5f1afd-0a74-495e-b380-a20a1abb8c82
0ccc0c0b-f8bc-4357-aeeb-9c3d7efd27a9	3401c829-c6f5-4cef-86e6-ad39d8c54aee	846bfd99-259e-4f09-b97f-861f413d134a
\.


--
-- Data for Name: project_intake; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_intake (id, "projectName", "commodityCode", "estimatedCompletionDate", "estimatedContractValue", "mouAmount", description, status, "projectId", "createdUserId", "approverUserId", "riskScore", "psbRiskScore", "IntakeriskScore", "isSPOEngagement", "intakeRiskLevel", "dateCreated", "dateModified", "isReprocurement", "isMinistry", "dateOfReprocurement", "serviceId", "categoryId", "previousContractBackground", "projectFailImpact", "projectSuccess", "otherProjectSectorName", "clientId", "projectSectorId", "mouId") FROM stdin;
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
07253129-ca19-4b15-bf1f-26621640e30b	DEMS RFP		2020-09-01	1500000	0		approved	8959e597-c09f-46b6-a515-b3ce076a9a94	3778745c-f1c5-4013-ae07-75bd4798ea32	3778745c-f1c5-4013-ae07-75bd4798ea32	48.1499999999999986	0	48.1499999999999986	f	2	2020-04-23 23:10:58.289	2020-04-23 23:11:22.055	f	\N	\N	\N	\N	\N	Non completion of the Comprehensive Disclosure Solution (CDS), a technology project being delivered by the BC Prosecution Service within the Ministry of Attorney General. As part of the project plan, we are intending to issue a Digital Evidence Management System (DEMS) RFP for software and implementation.	The overall vision of the DEMS and CDS projects is to create a system to manage documentation across the lifecycle of evidence and disclosure. This new system would ensure faster case processing, significant reduction in transfer delays and other tangible benefits.	\N	5d499cd7-3ae6-45e4-9fb2-688745dc1757	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
3ecd81b6-e034-4c6f-b56e-3b76718bb111	Environmental Project Management and Implementation Services		2020-12-31	20000000	0		approved	0da1c7d6-5b71-4232-8c20-ed2e52d08091	228e25cb-a091-4c40-9c60-751c784d8852	3e9a3591-d6b2-4b46-a426-5e0872553673	51.8500000000000014	0	51.8500000000000014	f	1	2020-04-24 15:52:18.974	2020-04-24 16:47:56.879	t	\N	2020-06-30	\N	\N	Current contract has been in place since 2014. Set to expire on June 30 2020, however the client is looking into a direct award to extend to accommodate a new procurement.	Lack of service delivery.	Strong service provider. Continuity of services. Cost savings.	\N	f10093b5-a868-4db5-a23c-775070e3a30b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
f79cb383-2dc6-498b-be7a-4d3718beb589	Coroners Case Management System		2020-06-01	3000000	0		approved	09adba45-2dc0-4cf9-9fff-d6349df6909a	915dbc07-9e45-4ec8-ac12-7586fb9ba033	3e9a3591-d6b2-4b46-a426-5e0872553673	48.1499999999999986	0	48.1499999999999986	f	2	2020-04-24 18:26:01.361	2020-04-29 18:38:18.45	f	\N	\N	\N	\N	\N	inefficient intake of Coroner cases, management, and data analysis	effective end to end Coroner Case management	\N	20720905-a3ae-4bf9-a139-c9526b11fd99	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
55b2c1aa-a96b-4a07-8b94-55ab95263d23	BC Parks Uniforms and Jackets Procurement		2020-12-31	500000	0		approved	05bee9b0-882a-4ed6-8bf8-1d0fdb01117b	8b436459-b4c6-424b-ad53-ebd55d2e5483	2d99034e-ba45-4768-87e1-e76c1a72d5eb	42.5900000000000034	0	42.5900000000000034	f	2	2020-04-23 19:18:19.062	2020-04-24 18:28:20.089	f	\N	\N	\N	\N	\N	None identified for this project.	Continued supply of Uniforms and Jackets for BC Parks without any interruptions.	\N	6f5521be-ca24-4c99-a308-da66eee67993	5afee492-cea2-4360-8e6f-e66c17baaaf5	\N
f691ca03-7a57-4cd4-98a1-e6385b293322	Fish, Wildlife and Ecosystems Project Management and Implementation		2020-08-31	20000000	0		approved	417d98d1-cdfd-4431-987e-859ffc9257f2	228e25cb-a091-4c40-9c60-751c784d8852	057ce701-b6ab-4e56-a352-acf238b6b814	51.8500000000000014	0	51.8500000000000014	f	1	2020-04-22 20:41:07.782	2020-04-30 18:44:59.51	t	\N	2020-06-30	\N	\N	Expires June 30, 2020	Critical environmental services not being completed	A service provider with strong project management and implementation practices	\N	26d63cf2-b2f4-41ea-810d-64e67fc969ce	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
285f5e53-1d3d-4cf7-b897-c00f62097942	OS NRFP program related (Bryn's time)		2020-05-31	1	0		approved	0c5955f7-b433-4ff0-b44f-456492abebc8	871a6a46-86f3-4a9c-80aa-518800eed1b6	057ce701-b6ab-4e56-a352-acf238b6b814	14.8100000000000005	0	14.8100000000000005	f	3	2020-05-05 23:35:04.6	2020-05-07 17:33:23.103	f	\N	\N	\N	\N	\N	n/a	n/a	\N	f3175941-89af-4409-881c-6d560d1f2739	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
e9a4511e-7aee-4553-a32b-62d05e785e32	Telecom Expense Management System		2020-07-31	1000000	0		approved	cf7c4e65-b95a-4fea-aa49-96acb87290b2	2d99034e-ba45-4768-87e1-e76c1a72d5eb	2d99034e-ba45-4768-87e1-e76c1a72d5eb	66.6700000000000017	0	66.6700000000000017	f	1	2020-04-24 18:23:16.183	2020-04-24 18:27:36.618	f	\N	\N	\N	\N	\N	This SaaS needs to be running smoothly prior to re-procurement of the telecommunications deal if multiple suppliers are desired. 	A solution that can be used amongst all Ministries and BPS. Cost savings and efficiencies. 	\N	cef833f6-8425-45e2-849d-e70a580bc417	15b3f630-3c1f-4402-8e08-6591f3d8ba13	\N
ff40e311-b93d-47ef-9a2a-a70d1b927eb4	Stakeholder Management System		2020-08-31	450000	0		approved	b9c3488f-9a6f-4822-8f96-091df3aeebd1	3e9a3591-d6b2-4b46-a426-5e0872553673	3e9a3591-d6b2-4b46-a426-5e0872553673	42.5900000000000034	0	42.5900000000000034	f	2	2020-04-27 16:44:41.329	2020-04-27 16:45:53.122	f	\N	\N	\N	\N	\N	Continue to manage communication via excel spreadsheets\nPotential of missing key communication to stakeholders`	Completed SMS that will assist with the communication for the three major TI Corp projects	\N	bbe38f61-7286-4eff-8b85-7e5537a6e056	15b3f630-3c1f-4402-8e08-6591f3d8ba13	\N
704ee0c5-8e82-4109-bd34-38ed50f0b2d2	First Nation Consultation Applications Support 		2020-06-24	2	0		approved	4053e10e-3d25-4697-9be6-d4bd5f149981	a2127b12-c103-4722-89e3-cbcc8a544245	3e9a3591-d6b2-4b46-a426-5e0872553673	48.1499999999999986	0	48.1499999999999986	f	2	2020-04-28 21:06:25.063	2020-04-29 18:37:29.93	t	\N	2020-06-30	\N	\N	Three Applications have been developed to simplify practices in consultation processes for provincial government staff and ultimately First Nations. The Applications are currently in various stages of development and implementation and include:\n•\tPIP – In Production, being implemented\n•\tARTS – In Production\n•\tFNCS – Being migrated to Production at present \n\n	Extension of the existing contract with the incumbent to facilitate service continuity until a competitive process is completed.	\nThe establishment of relationships with Indigenous peoples and communities through reconciliation of the Province’s interests with those of Indigenous communities, including consulting First Nations on proposed activities that may impact their interest.\nThe deliverables will bring together consultation information, maps, processes, and systems across government into a unified solution.\n	\N	fae0508c-a5e6-4610-9bcf-6f0b500f76ce	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
d5675fa2-6a90-4c52-9ab7-d11054de7a10	24/7 Mental Health Counselling and Referral Service for Post Secondary Students		2020-05-29	4	0		approved	c78ac814-41f2-47df-adbd-ad4e8a7108d7	a2127b12-c103-4722-89e3-cbcc8a544245	13669c48-73ee-492e-b1b5-6a168f213d8a	35.1899999999999977	0	35.1899999999999977	f	2	2020-04-29 22:44:18.51	2020-04-30 18:39:10.51	f	\N	\N	\N	\N	\N	Contract was awarded, lessons learned exercise outstanding.	Easy access to counselling support for post secondary students in BC.	\N	afd9d57c-cd78-4986-93d5-1a06d8000c36	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
affe076b-2165-4065-9f95-b6861abb8cb0	LED Street Light Luminaires CSA		2020-05-31	1	0		approved	ca002197-8b36-4395-a9b0-4ad50b6223f6	871a6a46-86f3-4a9c-80aa-518800eed1b6	057ce701-b6ab-4e56-a352-acf238b6b814	42.5900000000000034	0	42.5900000000000034	f	2	2020-04-29 22:54:05.092	2020-04-30 18:40:02.205	f	\N	\N	\N	\N	\N	CSA	CSA	\N	a61cb016-8904-4fa6-9e78-98741fad9df8	30371b0e-bb09-40e1-95ee-7d97550021af	\N
c54a4ff6-f393-4297-a21d-213a039c7bd4	NOI for Grant Management Software		2020-05-14	130	0		approved	e27823b2-ee5a-40ee-bd78-1111c18a6fb7	a2127b12-c103-4722-89e3-cbcc8a544245	13669c48-73ee-492e-b1b5-6a168f213d8a	27.7800000000000011	0	27.7800000000000011	f	2	2020-04-29 21:05:06.79	2020-04-30 18:40:07.477	t	\N	2020-06-20	\N	\N	There are two key functions of the grant management software: \n1)\tAdministration of the Application Funding Process:\n•\tWhile the Rural Dividend Program (RDP) is currently suspended, the software continues to be used to distribute economic development funding; for example, the Community Grants that were distributed in March 2020 (these grants funded projects that have up to a 3-year duration for completion, so minimally, an online system will be needed for monitoring and reporting); and  \n2)\tOversight of Previously Funded Projects:\n•\tThe software will continue to be used to support the oversight and monitoring of previously funded RDP and Community Grant projects. \n\n	May have to go to the market to undertake a competitive procurement process as soon as possible. Service continuity may be impacted. 	The availability of a contractor to provide maintenance and enhancement support if and when required.	\N	5bf36e16-5dca-42ca-b381-2600fbde5002	15b3f630-3c1f-4402-8e08-6591f3d8ba13	\N
f431d4e5-67c0-4b55-b187-94728f2aea6f	Network Equipment and Associated Goods		2020-09-30	6000000	0		approved	a9ef1e50-f0e3-4d64-a1df-c1187bf34b2f	8880f74e-e2e5-4646-bd80-b285d653d0c2	057ce701-b6ab-4e56-a352-acf238b6b814	35.1899999999999977	0	35.1899999999999977	f	2	2020-04-28 16:42:37.74	2020-04-30 18:42:30.436	t	\N	2020-04-28	\N	\N	Was previously a CSA but now is a MSA	OCIO would need to consistently use ITQ's for purchasing of Network Equipment for the Province.	One VAR supplying Network equipment for the Province.  This is significant infrastructure and is a critical service built on this equipment.	\N	cbb802a9-2480-4bd6-862e-6484d611bce2	15b3f630-3c1f-4402-8e08-6591f3d8ba13	\N
1d7131e7-228d-40df-b290-815ca8ba4c18	Advertisment Placement Services		2020-09-30	10000000	0		approved	fa38f829-2342-4781-a9af-89e078a42dd9	228e25cb-a091-4c40-9c60-751c784d8852	13669c48-73ee-492e-b1b5-6a168f213d8a	59.259999999999998	0	59.259999999999998	f	1	2020-04-30 21:30:58.886	2020-04-30 21:33:57.748	t	\N	2020-05-31	\N	\N	Contract split into two (Traditional and Digital Media). This procurement will follow a similar approach.	Province suffering in advertising planning and buying.	A trusted service provider that the Province can work with collaboratively. 	\N	e5176800-b29b-4cf4-bbcf-a2c2774e00b6	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
cf5c3801-5663-4730-8a44-662f15b514a3	Ad-Hoc Advice		2025-12-31	1	0		approved	ea6c0de6-9305-476e-8afa-3647b2f9b472	13669c48-73ee-492e-b1b5-6a168f213d8a	13669c48-73ee-492e-b1b5-6a168f213d8a	18.5199999999999996	0	18.5199999999999996	f	3	2020-04-30 23:22:08.937	2020-04-30 23:22:52.96	f	\N	\N	\N	\N	\N	Internal Administrative Project, for the entry of project support around Ad-Hoc Advice.	This is an all staff project that may have varying levels of support depending on the individual and their role.	PSD Operations Support	b3a6e117-436e-4fda-ae24-956516473a80	82fc095a-4811-493a-937a-6800dc758596	\N
c44d5914-ebdf-4b3a-9dc8-64cc6332ba53	Administration		2025-12-31	1	0		approved	b0245539-30d8-486e-bd3a-857d283fec62	13669c48-73ee-492e-b1b5-6a168f213d8a	13669c48-73ee-492e-b1b5-6a168f213d8a	18.5199999999999996	0	18.5199999999999996	f	3	2020-05-01 05:07:03.301	2020-05-01 05:07:38.826	f	\N	\N	\N	\N	\N	This is for internal Administration tasks. 	This is for internal Administration tasks. 	Internal Operations	fe331179-3f09-4db0-b85d-53e6086fc8ed	82fc095a-4811-493a-937a-6800dc758596	\N
705ec2bd-907b-4700-9a19-084a4cc922ad	Managed Print Services		2021-09-30	42000000	0		approved	12b59b16-e92d-471d-b872-e793e0813979	f6b65221-f597-488b-aaa8-bed90aacfaf8	f6b65221-f597-488b-aaa8-bed90aacfaf8	57.4099999999999966	0	57.4099999999999966	f	1	2020-05-01 21:55:52.557	2020-05-01 21:56:11.068	t	\N	2021-09-30	\N	\N	Part of hosting contract, added on by contract amendment.	Impact to print and imaging services in Province.	Transition services, gained efficiency (not necessarily cost), improve transparency.	\N	eff4b409-bda6-4a50-aaf9-7c1e4c310173	15b3f630-3c1f-4402-8e08-6591f3d8ba13	\N
016ece27-6cde-4dd1-953c-0ad105f01f5c	Resources for ADMS		2020-05-31	6100000	0		approved	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	f6b65221-f597-488b-aaa8-bed90aacfaf8	f6b65221-f597-488b-aaa8-bed90aacfaf8	40.740000000000002	0	40.740000000000002	f	2	2020-05-01 22:16:22.948	2020-05-01 22:16:30.774	f	\N	\N	\N	\N	\N	Gap in services for ADMS.	Successful transition, services provided.	\N	5fe63915-6979-47b9-a701-cad9d87f5de2	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
03ab8cf6-135c-446d-a31b-dbb094f0493d	Positive Airway Pressure Devices		2022-12-31	320000	0		approved	3fb37573-577e-4be1-b720-d8a5c8a57cf0	8880f74e-e2e5-4646-bd80-b285d653d0c2	ff341b3b-6c79-421c-951a-0e199f8693d8	40.740000000000002	0	40.740000000000002	f	2	2020-05-05 18:14:16.866	2020-05-05 20:31:12.315	f	\N	\N	\N	\N	\N	These Standing Offers are to meet the medically essential needs of eligible Clients from SDPR purchases for CPAP devices.	Standing Offers for the purchases of CPAP 	\N	a587ddb4-9574-44ef-9c51-7612f99eb5b7	fc25a9e1-b6e7-4abc-a81b-15d1b822da25	\N
4be8b057-9b2c-45e4-9a6f-f59a51861125	Airfare Discount Programs		2020-05-31	1	0		approved	a922a216-d92c-4c17-a3f4-cb168919cc54	871a6a46-86f3-4a9c-80aa-518800eed1b6	057ce701-b6ab-4e56-a352-acf238b6b814	14.8100000000000005	0	14.8100000000000005	f	3	2020-05-05 23:31:52.062	2020-05-07 17:33:56.534	f	\N	\N	\N	\N	\N	n/a	n/a	\N	ae577ef5-ff64-47c0-8350-779fb8ec7fa1	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
884724c3-7e16-4f23-bde6-370e847ef1c6	Document Destruction (Shredding) CSA		2020-05-31	1	0		approved	303960cf-e68e-47b8-b3c5-b23e74dfdabc	871a6a46-86f3-4a9c-80aa-518800eed1b6	057ce701-b6ab-4e56-a352-acf238b6b814	14.8100000000000005	0	14.8100000000000005	f	3	2020-05-05 23:28:42.496	2020-05-07 17:34:04.268	f	\N	\N	\N	\N	\N	n/a	n/a	\N	f09638be-14dc-4463-bcdd-7ec4e4b4d3e0	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
630a6b57-db84-4727-ac48-e4ea6b987cdb	Executive Coaching CSA		2020-05-31	1	0		approved	6b40a6a0-2154-4188-9b4f-867d438efead	871a6a46-86f3-4a9c-80aa-518800eed1b6	057ce701-b6ab-4e56-a352-acf238b6b814	14.8100000000000005	0	14.8100000000000005	f	3	2020-05-05 23:25:18.345	2020-05-07 17:37:04.452	f	\N	\N	\N	\N	\N	n/a	n/a	\N	68027b50-b39c-41bc-a299-2fb459855c87	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
19f54630-ea65-461e-9f72-f16495176ab4	Royal BC Museum		2021-12-30	1	0		approved	089d4afa-b82c-4312-9570-95987f609d58	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-06 16:22:56.776	2020-05-06 16:23:12.236	f	\N	\N	\N	\N	\N	various	various	\N	4626e83d-0c05-4a4c-a54c-5113bb33bcd4	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
c89b50aa-2bf6-45bc-97e7-afffe1cd6b86	Workplace Development Services		2021-12-30	1	0		approved	c38d894c-4754-4722-b6c6-a289bc3f2a94	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-06 16:37:42.002	2020-05-06 16:37:51.857	f	\N	\N	\N	\N	\N	various	various	\N	347e946b-7a5e-45ae-8942-083237fdd31f	30371b0e-bb09-40e1-95ee-7d97550021af	\N
8f24dbd7-a071-434f-90e9-fccff528dcdb	Pipe-Open Bottom Culvert/HDPE/Galvanized Steep Pipe, Pipe Arches CSA		2021-12-30	1	0		approved	802cc104-4978-4e15-8038-8e80488e6116	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 16:41:25.661	2020-05-07 16:41:40.175	f	\N	\N	\N	\N	\N	.	.	Goods	2f60f58b-2834-4678-872a-69eb305ed8d5	82fc095a-4811-493a-937a-6800dc758596	\N
aeffed60-8beb-4087-a716-db4287dfd985	Uninterruptible Power Supplies CSA		2021-12-30	1	0		approved	59cbef91-ffef-4b8b-825f-5a59ce8a7201	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 16:38:41.851	2020-05-07 16:41:45.365	f	\N	\N	\N	\N	\N	.	.	\N	5284d7f4-0e5f-4222-8509-f153ee4fb563	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
b5e1eeb3-edcd-4e15-9b0a-468571d00542	Playground Equipment CSA		2021-12-30	1	0		approved	22e03b6f-53be-44ac-bcba-42d807c9a985	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 16:35:37.439	2020-05-07 16:41:49.071	f	\N	\N	\N	\N	\N	.	.	\N	4840b860-dca8-4806-83e0-c9bd415909f9	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
4961d5c5-83a4-4fb8-88ba-e12b79c9b242	IM/IT Security Services		2021-12-30	1	0		approved	d8d8c60f-9eac-4bd5-bc84-f4c574930a7f	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 16:32:06.858	2020-05-07 16:41:53.5	f	\N	\N	\N	\N	\N	.	.	\N	6e995550-e598-4e6b-88b9-30f6e6f013a7	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
1d3cb39b-9aa1-469a-a322-b3674cf0a821	Audio Visual Goods and Services CSA		2021-12-30	1	0		approved	62f61778-f0bd-4de1-890a-8cd685dcd354	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 16:28:50.504	2020-05-07 16:42:01.662	f	\N	\N	\N	\N	\N	.	.	\N	3bda62ba-b1ce-4610-a1e5-38b0546eb06b	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
7130c6d3-16f1-4e69-b7e1-4348485b3b48	Office Supplies & Associated Services RFP		2020-09-30	24000000	0		approved	7d12d0b0-370f-42cf-9b35-7c65489b736a	871a6a46-86f3-4a9c-80aa-518800eed1b6	057ce701-b6ab-4e56-a352-acf238b6b814	48.1499999999999986	0	48.1499999999999986	f	2	2020-05-06 23:27:08.707	2020-05-07 17:31:37.409	t	\N	2020-12-31	\N	\N	MSA set up and used all 3 one-year extension years.	Government having to pay higher retail prices for office supplies, lack of control of spend by commodity and value, higher delivery costs, no contracts with numerous suppliers	MSA in place with favourable pricing and ordering and delivery service up and running to except orders as of January 2, 2021,	\N	b796d999-023a-4ad5-a02a-80bcc0330900	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
29c52b2f-986d-4f33-88f7-18856c3ae7f1	Flextrack Vendor Management System		2020-05-31	1	0		approved	29ff1b94-baf1-44dd-866a-7c4795f66982	871a6a46-86f3-4a9c-80aa-518800eed1b6	057ce701-b6ab-4e56-a352-acf238b6b814	14.8100000000000005	0	14.8100000000000005	f	3	2020-05-05 22:15:34.638	2020-05-07 17:32:57.175	f	\N	\N	\N	\N	\N	n/a	n/a	\N	95bfabe1-898a-428f-b865-cff52ca883a3	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
01891079-4486-46c0-8709-386330a2b67a	Entrust CSA amendment		2020-05-15	1	0		approved	28695bb2-07d6-42e4-9194-51c361f6f686	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 17:49:50.087	2020-05-07 18:46:13.253	f	\N	\N	\N	\N	\N	.	.	\N	d17fbefd-fd59-46f2-85b5-1a5bde73b813	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
c89127bc-2f55-40e8-bfc9-228c4b928ae0	Ministry of Finance Tobacco & Fuel Tax 		2020-10-31	20000	0		approved	632f3cbc-9e1b-40f7-9c83-4355a638f1f5	60b73394-cdfd-4aba-b557-80fcc8cc9ad6	ff341b3b-6c79-421c-951a-0e199f8693d8	51.8500000000000014	0	51.8500000000000014	f	1	2020-05-07 13:02:47.648	2020-05-07 18:48:07.779	f	\N	\N	\N	\N	\N	This project is to update a paper based system that has been in existence for many years.  It can continue to operate as is indefinitely if this procurement were to fail. 	To replace a paper based system with a real time validation system that interacts with the current tax system.	\N	39536cc1-45fc-4274-9e0d-26a78d743f23	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
02167e34-a699-4df0-a915-ed7e708a5af7	Anti-malware (software licences) CSA		2022-04-01	1	0		approved	4cae427d-0ea7-4919-8d2f-518e28ee7519	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 20:40:26.025	2020-05-07 20:56:05.771	f	\N	\N	\N	\N	\N	.	.	\N	04c55139-fdc0-477c-9832-67cabc8cd639	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
45ffc5e0-8a71-454f-bb39-471cd4a77d37	Employee Safety Monitoring Services CSA		2021-12-31	1	0		approved	89f445e4-64a0-44be-877d-024891a0d2c2	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 20:48:10.096	2020-05-07 20:56:12.251	f	\N	\N	\N	\N	\N	no safety provided to employees	employees working alone, in isolation or settings that may be deemed unsafe are set up with the Services to ensure employees are safe	\N	e10e3798-494b-4442-844c-aee16e398602	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
a53cffeb-ff03-47a0-be54-1762c5a0d7e3	Facilitation Services CSA		2022-03-31	1	0		approved	89b02e76-d8f3-469e-88b7-1cd79304c9a5	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 20:53:15.16	2020-05-07 20:56:15.947	f	\N	\N	\N	\N	\N	office will have to complete their own solicitations 	facilitator is a neutral third party to facilitate various types of meetings, communications etc. 	\N	86afd08b-6e98-4377-83fd-de9e35a361d2	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
d6b0479a-3a40-43f4-b5cd-d6c540ac7c07	Furniture CSA		2022-01-14	1	0		approved	e3733822-0bde-4665-96fd-4238ca1713fa	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 20:55:41.122	2020-05-07 20:56:20.589	f	\N	\N	\N	\N	\N	.	.	Good	6600441d-112e-44e6-b082-2fb450d6ed58	82fc095a-4811-493a-937a-6800dc758596	\N
05186cba-8a1f-4a12-a968-a8d790372aa9	Translation and Interpretation Services		2023-10-01	1	0		approved	6c7eea3c-dbc0-4b55-9cff-30f0402dc78f	ff341b3b-6c79-421c-951a-0e199f8693d8	ff341b3b-6c79-421c-951a-0e199f8693d8	0	0	0	f	3	2020-05-07 21:00:25.453	2020-05-07 21:00:34.408	f	\N	\N	\N	\N	\N	.	.	\N	8ffa6cb3-0d66-4e60-b0b7-41afa899981c	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
cafd0dfc-c45a-435f-8e90-b4df8d876647	BC Bid Project		2020-12-31	1	0		approved	7705fd59-37b6-4d8b-8f8d-fb1329569f8a	13669c48-73ee-492e-b1b5-6a168f213d8a	13669c48-73ee-492e-b1b5-6a168f213d8a	12.9600000000000009	0	12.9600000000000009	f	3	2020-05-12 22:51:36.571	2020-05-12 22:51:51.552	f	\N	\N	\N	\N	\N	This is an administrative project to account for staff time supporting the launch of BC Bid 2.0	This is an administrative project to account for staff time supporting the launch of BC Bid 2.0	\N	f62f21ca-4f27-4c07-a26c-9301b20c3990	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
ff924716-cecf-468f-91b2-ae0e10b8c394	RFQ - Org.Dev't, Design, Eval & Research,Policy Consultants 		2020-07-03	500000	0		submitted	\N	8ce3254e-5447-4fd0-816e-d3c2455a753a	\N	62.9600000000000009	0	62.9600000000000009	f	1	2020-05-13 19:20:37.405	2020-05-13 19:20:37.405	t	\N	2020-06-30	\N	\N	List of qualified pool of consultants in the above-mentioned service areas. 	Possible service interruptions, delays in deliverables of projects.	Meeting project objectives and delivery of services which may be critical to policing and public safety.	\N	2ddbe0a3-cac2-4a27-af39-feadff5df1c4	1d6f2f24-f52a-4b0f-97ef-73eca5493aa2	\N
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
54a4d67d-7225-4f3d-91b5-ce0e6e733436	07253129-ca19-4b15-bf1f-26621640e30b	c26ca145-4876-4bff-b8d1-fdf877f1f3b8
6185b4df-bd57-4387-83a6-64d1f307ca2d	07253129-ca19-4b15-bf1f-26621640e30b	979e8055-f884-439b-9741-2687c0ea7700
7d23bc31-3553-4b5e-ad45-a0136f176c17	07253129-ca19-4b15-bf1f-26621640e30b	2a3ab891-3ef7-4488-96d8-8b00238c2519
773c432c-bf91-4cd7-8000-41245942fd58	3ecd81b6-e034-4c6f-b56e-3b76718bb111	55024d8a-7a6f-4249-82ed-114180db41c8
bcad14d3-a311-4851-b7a4-a5d1f793a167	3ecd81b6-e034-4c6f-b56e-3b76718bb111	6f3fae5d-9967-4018-bb2d-f5a01a8c177e
ffde3498-56e6-4ac4-9b13-2bcce68bf9b5	3ecd81b6-e034-4c6f-b56e-3b76718bb111	d4ae139e-82d9-4ccc-ad0f-09b026e68432
bb07b3f2-d260-4bd0-8d45-fab4bb058679	e9a4511e-7aee-4553-a32b-62d05e785e32	edf89f50-7b4d-4b2d-b03e-b0518d4aad25
68f88430-acdd-499d-a348-d0aa88aff703	e9a4511e-7aee-4553-a32b-62d05e785e32	3c0c2dda-c68f-432f-baa0-d6329900224e
fa47e192-1ff6-4530-8833-5a3412ebefbe	e9a4511e-7aee-4553-a32b-62d05e785e32	ce611836-b270-471a-9738-711bcc991874
9669a339-b720-42b3-8d0c-75c04124b2a1	f79cb383-2dc6-498b-be7a-4d3718beb589	8697899d-37a2-4ce0-a6c6-43d87b42ee15
b16b37e9-fe25-46d1-b64a-5e780b377661	f79cb383-2dc6-498b-be7a-4d3718beb589	473a88a9-5cae-4067-9c92-3e25c2fded84
85ac8469-9018-4c26-90df-6769899acc25	f79cb383-2dc6-498b-be7a-4d3718beb589	0ce13432-f9c5-4615-95e0-a799e98f4dc0
50ce3723-5720-409d-8e60-a6e351df8939	ff40e311-b93d-47ef-9a2a-a70d1b927eb4	8a8edd83-281f-449f-9d91-9dc57cf943e4
3a3e9772-2a17-4653-a1f8-cd15f6dcb30e	ff40e311-b93d-47ef-9a2a-a70d1b927eb4	c128ae1a-d76c-4be7-8e3c-a6fc4a59c64d
90cdbb3e-95e8-4c21-9869-a243ecf64009	ff40e311-b93d-47ef-9a2a-a70d1b927eb4	8d5ecfaf-17e5-4fd7-8ceb-72daa3a24ed3
73c9cc66-e775-4e69-8908-cd172fd936db	f431d4e5-67c0-4b55-b187-94728f2aea6f	86dcc5bb-6335-49b1-8118-6ea5c7f4f2b7
eae0d38b-4839-4bee-9966-e4816d1c4221	f431d4e5-67c0-4b55-b187-94728f2aea6f	dc8342dc-3552-428c-9083-fe209e3e4c87
90d5857b-1d3e-45ac-970c-3df06ba88e46	f431d4e5-67c0-4b55-b187-94728f2aea6f	4b2e71fc-1cd4-48e1-9424-9ba1f28acff6
0daefa94-1ef9-4c33-81f8-36ddb823a494	704ee0c5-8e82-4109-bd34-38ed50f0b2d2	c57b3f29-c665-43e7-9054-9fd3b4d6128e
ae92592d-926d-4046-9cc1-94b97d1a19b4	704ee0c5-8e82-4109-bd34-38ed50f0b2d2	39ca60d8-b95c-493d-abf6-756c67407a01
b462efdb-603a-4181-8a5b-7e937d3cbf37	704ee0c5-8e82-4109-bd34-38ed50f0b2d2	8fed6ee8-6b61-4aa6-82f7-8e66f11d9687
4e1f93f9-0bc0-4b9c-a51a-a71031715b48	c54a4ff6-f393-4297-a21d-213a039c7bd4	14d59b3d-e896-41fe-bb4e-def146e8328c
e840acb1-b6a0-476a-9e3a-3ca916db73b8	c54a4ff6-f393-4297-a21d-213a039c7bd4	dd4d7b59-9a28-4884-aac5-e298d4fcf436
208f5cd2-380a-4488-867c-6be7a4894ac8	c54a4ff6-f393-4297-a21d-213a039c7bd4	249d38e4-475b-4b73-ab2c-082ce3d6d0f9
10b1c0aa-c108-4915-ba2d-bcc295e73a63	d5675fa2-6a90-4c52-9ab7-d11054de7a10	df50547e-64fb-426a-b553-a07af4cbdb57
3fd72793-0187-4417-8ea8-49b06779b317	d5675fa2-6a90-4c52-9ab7-d11054de7a10	082a91da-834a-4289-8399-7ff126ad5f3a
663be90b-8ce2-4d0a-8a64-896b214027b4	d5675fa2-6a90-4c52-9ab7-d11054de7a10	f9848017-5433-489b-85b4-f3c60ddb2904
dbc2c2b7-5081-45ad-8c45-7e17a5c02e8a	affe076b-2165-4065-9f95-b6861abb8cb0	8ae0de39-6fe2-4b12-bdec-a876bc97836e
29124dd8-343f-4029-9479-7e547cf06563	affe076b-2165-4065-9f95-b6861abb8cb0	66ae3016-d501-4c49-a2d9-c7b0636905c6
f147e509-8ece-48b9-8360-85ec09c74d57	affe076b-2165-4065-9f95-b6861abb8cb0	dff168bd-74f0-4256-846b-8c2502143aae
8a8a826c-2a03-48ba-bfe4-ef810d48d1a6	1d7131e7-228d-40df-b290-815ca8ba4c18	484e4339-b341-4b56-aadc-70e2dc87f73a
af056d21-85c9-44c9-af62-f944a4b5d45b	1d7131e7-228d-40df-b290-815ca8ba4c18	b07dffcd-e67a-4f5e-90ba-435031a5c172
45856d7b-2adc-4000-a058-b38e3fc06d09	1d7131e7-228d-40df-b290-815ca8ba4c18	2a35708f-1a90-4a32-95f1-ac36c1054591
fa3751b2-c56b-46af-9951-23e059848fe2	cf5c3801-5663-4730-8a44-662f15b514a3	60a263b2-7766-4844-ae0f-c930a5a894dc
f5994294-7989-42a2-8228-af976d024cb8	cf5c3801-5663-4730-8a44-662f15b514a3	01107e5d-5ff0-494e-9035-5c670c92fd5e
e4b417b3-6570-40f9-bdbe-63e4957328ca	cf5c3801-5663-4730-8a44-662f15b514a3	9c837a27-19cb-4dd8-8a6b-6b16ed469f23
89885944-bbf3-4406-9e1a-cc17e35cee7c	c44d5914-ebdf-4b3a-9dc8-64cc6332ba53	1e1b0e2a-9540-4725-a535-59270aae0b8e
debf4f9b-88d5-441d-96e6-01b676501a95	c44d5914-ebdf-4b3a-9dc8-64cc6332ba53	a55896e5-83a8-4fd4-9edd-dc85526fac1f
cba80f58-29de-451e-90ac-04f678ca3d67	c44d5914-ebdf-4b3a-9dc8-64cc6332ba53	4608169b-db13-487a-a4ff-e862420aa1a1
b17d8bb8-42b8-41e3-903c-a1b21429a89b	705ec2bd-907b-4700-9a19-084a4cc922ad	03a64e94-6d66-495c-89dd-86a076d35f51
3e16c0db-c0da-42ac-80d5-6219bfd90fb4	705ec2bd-907b-4700-9a19-084a4cc922ad	9e2f63c4-9fa6-47be-8653-79dd8e910ae4
70a64dad-01e8-45a3-a715-9abfbf8534c3	705ec2bd-907b-4700-9a19-084a4cc922ad	112f1a0c-6d14-4b94-8969-2881f555094b
e229330f-7182-4c8e-b080-b2884da0b95b	016ece27-6cde-4dd1-953c-0ad105f01f5c	edf71bd2-cfa8-4b54-8920-cd9e676964e4
a83c39e7-1d35-4a61-90ae-31d9dc21e043	016ece27-6cde-4dd1-953c-0ad105f01f5c	03e3bb26-b351-4764-9306-c730c4021b4d
7d16494d-51dc-49dd-893a-da4f83f27f40	016ece27-6cde-4dd1-953c-0ad105f01f5c	1df1ff83-ef73-4a34-9417-a5e3bcb30ee0
daff2ecf-82ad-4e48-baa6-d44a74fbb6db	03ab8cf6-135c-446d-a31b-dbb094f0493d	5c8dee5e-8d2c-42f2-afe5-39033fb605b1
78f9e1a9-d6a9-4d4b-b061-146cb65aab79	03ab8cf6-135c-446d-a31b-dbb094f0493d	dab6710d-eb26-428f-9728-fa1dfa8b0071
dd80422f-7b49-4107-ae85-428450051b38	03ab8cf6-135c-446d-a31b-dbb094f0493d	6d7cf5cc-900a-46a1-849b-c21420c43237
7cc873eb-d729-437e-8319-5065c245ece9	29c52b2f-986d-4f33-88f7-18856c3ae7f1	2032e970-371b-4f41-93cd-ced37d132571
977ef64c-11b2-4f37-b903-48862fc8d050	29c52b2f-986d-4f33-88f7-18856c3ae7f1	6a0f5f62-c649-4715-9508-e2898f76c559
1b86d196-51ec-41f2-a974-7f6430da73e6	29c52b2f-986d-4f33-88f7-18856c3ae7f1	91ef4fab-c7d3-4c29-8a09-3ed56951a8ba
06e27ebd-1ffe-4100-b12c-ebb75d34e6a6	630a6b57-db84-4727-ac48-e4ea6b987cdb	0921d339-26d9-421c-8089-40fbed21047f
70d74681-7b46-4813-96ac-8af049137cac	630a6b57-db84-4727-ac48-e4ea6b987cdb	1c6865b7-485f-4cdf-bb03-111eceb70d7b
ece05bb5-e261-4f1d-8894-7951461924cc	630a6b57-db84-4727-ac48-e4ea6b987cdb	218ed232-8da5-4624-b3bf-4a1d54376c09
7b932e5e-1a8a-49db-bd4f-8812021d27ef	884724c3-7e16-4f23-bde6-370e847ef1c6	f1735c92-9ff4-4989-81a9-7a30956b5f8c
30eb3de5-4f64-468f-b5d1-22ed17fbd394	884724c3-7e16-4f23-bde6-370e847ef1c6	5aed62f7-c4dc-42c5-9c6e-da09f6d1f113
ae17055b-63b2-4533-9551-a4af2650a06c	884724c3-7e16-4f23-bde6-370e847ef1c6	4c58cd4b-832a-47e7-b51e-55424f6a997b
478183ca-c7b3-4e14-a7e6-7c868f285c59	4be8b057-9b2c-45e4-9a6f-f59a51861125	210eb957-fe3a-4256-9072-d877cf56be1a
82f6cca4-456c-4099-a430-d65c550251a4	4be8b057-9b2c-45e4-9a6f-f59a51861125	d66b6700-d699-422b-92df-2ed60f32b7e6
ad7d63f4-d931-4620-aee8-db12d0b6aa21	4be8b057-9b2c-45e4-9a6f-f59a51861125	8f7ce9cf-97ad-49ca-96fa-4c93560ddae1
fa1e3e5e-0ded-4655-8b60-8a1e789ff6fb	285f5e53-1d3d-4cf7-b897-c00f62097942	f5d6df4f-a6fc-460e-a509-28b80c751454
b4342868-61ba-4f57-badd-8ab1abe2385e	285f5e53-1d3d-4cf7-b897-c00f62097942	39d60e9f-f8d1-4d03-ad0b-2f8d9a497472
c21c88fd-8a96-42aa-a301-6f0a521e77a3	285f5e53-1d3d-4cf7-b897-c00f62097942	3d0c7d5f-4a52-4d6c-bbe6-ab9f11dd3c72
11724fc1-290d-4a2d-adf2-abdf12cc8de5	19f54630-ea65-461e-9f72-f16495176ab4	80858d85-6e6e-4fd2-bb03-32df56e4dc9d
65e12da2-b4d0-447c-89e7-4e7be0e7498b	19f54630-ea65-461e-9f72-f16495176ab4	e52186c4-b70a-4591-8515-b2525d63c4e5
45b80aef-7240-4550-b7b6-a4898b0a759f	19f54630-ea65-461e-9f72-f16495176ab4	f63d648a-2f5c-4328-8cd1-cffd75a59505
61e4ce02-7621-4981-8e36-ddc286940c78	c89b50aa-2bf6-45bc-97e7-afffe1cd6b86	e5e75305-8c09-4f96-b7b0-26b6d4b8eb48
d5577266-134d-46d8-9f61-66869d9980d9	c89b50aa-2bf6-45bc-97e7-afffe1cd6b86	e328beb1-fe7c-4a02-92ce-fdfc7c21e93e
85a5e5c0-885b-4000-8e0a-b2e0965b7721	c89b50aa-2bf6-45bc-97e7-afffe1cd6b86	f5ed2282-aa00-4f9e-9a80-197a4360fa58
922c1db3-0b55-4632-b0fa-6d5f9479f530	7130c6d3-16f1-4e69-b7e1-4348485b3b48	4e2bcd30-9e38-4688-bc77-215689e2df9e
a6c0b52e-3839-4f19-9882-c04cb7a60ab7	7130c6d3-16f1-4e69-b7e1-4348485b3b48	e04ae49a-a1f2-4ae0-829c-c70b0e288931
96f9d66f-9130-413e-970c-07afd336364a	7130c6d3-16f1-4e69-b7e1-4348485b3b48	4b47df33-9695-4350-a190-1ec9b9d835b0
2cf160a7-6aa4-439b-a6a6-7a6301d1e21c	c89127bc-2f55-40e8-bfc9-228c4b928ae0	35ff61f5-a2cb-44ed-9a5e-063262cc38e8
1928d96f-4920-4ba1-8606-27e549786ed1	c89127bc-2f55-40e8-bfc9-228c4b928ae0	3d7f343c-f906-421c-bd45-536427f70c79
926a5361-d832-4fd7-855e-f19b069df2b2	c89127bc-2f55-40e8-bfc9-228c4b928ae0	0b7b8774-215d-415b-afa9-f1443f8f3042
0004eeed-8828-4cb6-b82f-3ddc399f0d64	1d3cb39b-9aa1-469a-a322-b3674cf0a821	9b0f638a-ed37-43a6-83ea-ff7de2626a45
4d3b3af8-d11e-477f-b137-c5191e688f51	1d3cb39b-9aa1-469a-a322-b3674cf0a821	a82598e3-a49b-4133-9cd9-71ab7c554d81
1a1d75e6-de68-4c39-84bd-dbd22f858349	1d3cb39b-9aa1-469a-a322-b3674cf0a821	eecb615e-4f55-4bc7-9b0e-0edb95a6e8e5
729fc2b1-d19a-40c5-a57f-6dda24584813	4961d5c5-83a4-4fb8-88ba-e12b79c9b242	c68f0392-0612-4d13-a844-5c1c19c4f030
07b96792-08ba-4ec1-ae3e-466ef944de77	4961d5c5-83a4-4fb8-88ba-e12b79c9b242	f4907d38-8815-47fb-8ae7-c42c41f308a4
6509e687-ac75-4519-8550-fa54e56c3b29	4961d5c5-83a4-4fb8-88ba-e12b79c9b242	35d62799-8bef-4cb7-b176-3458804e9f5a
96991680-afcd-4e18-96f0-91e0bb76fe43	b5e1eeb3-edcd-4e15-9b0a-468571d00542	74d3b3a5-3014-4a2e-bb61-e7caabaece61
a6b31b6d-6d0a-444f-8a23-e5528b26333e	b5e1eeb3-edcd-4e15-9b0a-468571d00542	cfc2374b-8101-4079-988b-0324dbbebe47
1e4f0f5e-3380-453d-b36e-5a86c9af4fa5	b5e1eeb3-edcd-4e15-9b0a-468571d00542	eac172de-aa74-4050-9d6d-9d849deef1d7
9e0de94e-9603-4eef-833f-fbd1f3b3ee76	aeffed60-8beb-4087-a716-db4287dfd985	511759fd-4baf-4fd3-b79c-43a838c93028
f70658a6-5070-4579-9c22-1d95dd9c519f	aeffed60-8beb-4087-a716-db4287dfd985	830ab0b2-779a-4f06-b1bc-e792e025aebb
b2bd9390-aba0-4e94-acb2-30d666000787	aeffed60-8beb-4087-a716-db4287dfd985	d3aaafd6-8837-43ee-b2a4-27a7f66d8eca
39a2ad17-3b79-4d0d-8a14-7d56e5176aa6	8f24dbd7-a071-434f-90e9-fccff528dcdb	4808fcea-b59c-45f0-9b6c-c64504c4b6b4
b5217dff-b485-463b-aded-116a8aae1212	8f24dbd7-a071-434f-90e9-fccff528dcdb	a589814a-1164-47af-8870-7c51fa75a70d
c371d61a-3cac-4710-9ef6-b313031ddd62	8f24dbd7-a071-434f-90e9-fccff528dcdb	a981f164-44d0-4cee-81d0-f63f8a2cc66f
166f9d80-3827-4afd-a1dc-e7e36962091d	01891079-4486-46c0-8709-386330a2b67a	c0fcaa1d-aabd-479c-ae31-1682735bd113
93f16abf-a3d9-48c3-aff2-0e8d2aceef2f	01891079-4486-46c0-8709-386330a2b67a	790abdc2-71bd-4924-ae10-d170e1401b7a
383b39f3-a97f-4425-9496-ed7294af135f	01891079-4486-46c0-8709-386330a2b67a	9bb88b2c-a1e0-4ab1-a761-89d60632916f
805dfced-4c17-4850-a7ac-19b1bd152c72	02167e34-a699-4df0-a915-ed7e708a5af7	21ed117d-3701-478a-9c6f-72a18c43fd47
42179bdc-1a70-422a-bb26-ccd49428ce8f	02167e34-a699-4df0-a915-ed7e708a5af7	f56d4bed-c184-427f-a0ca-876e9f05effb
b6c60c33-6e6b-41ea-aaa8-0cac91d410d6	02167e34-a699-4df0-a915-ed7e708a5af7	1e5a6295-e46d-4e6d-85fb-35e77c04a2c8
436b896f-87ba-428c-a3ef-f2f96bcb9b44	45ffc5e0-8a71-454f-bb39-471cd4a77d37	7f185e90-69b4-409d-b4d5-a93cd28051f6
a56e26c2-c41c-4925-a847-73bbce7c7711	45ffc5e0-8a71-454f-bb39-471cd4a77d37	2d5f1afd-0a74-495e-b380-a20a1abb8c82
aebc80fa-ac01-4588-89ef-056bc251d420	45ffc5e0-8a71-454f-bb39-471cd4a77d37	c6e77528-19ba-4abf-bb48-83d42fa717ba
e67dd01d-d008-436c-a73b-4352e188a03f	45ffc5e0-8a71-454f-bb39-471cd4a77d37	7166ee0b-745e-4256-b552-4efadbb3c83e
33c20df2-1730-4a49-ad36-c1784a22bee8	45ffc5e0-8a71-454f-bb39-471cd4a77d37	569d24ef-1cc6-43d5-89d6-c71a81604748
3753b0f9-97eb-4cee-acff-c9165761dd8a	a53cffeb-ff03-47a0-be54-1762c5a0d7e3	3f30c632-8551-435c-9189-5edbadb5ca2b
69d2f173-0c8c-4fd7-ad00-34d54c08b92d	a53cffeb-ff03-47a0-be54-1762c5a0d7e3	84013463-5677-4365-8c67-c31b57c12824
47c85272-c6e3-4b02-9c9b-b0e5ecf0cbf5	a53cffeb-ff03-47a0-be54-1762c5a0d7e3	f7a97cd6-d162-4e2f-9e32-7455b7035499
41a9087a-3e48-44c8-8e45-42f7f6daf5bf	d6b0479a-3a40-43f4-b5cd-d6c540ac7c07	3c5507e7-8fa9-439b-abb5-482ee749605f
85ac6650-e4ba-4d1d-a2c8-2fcd8909ead3	d6b0479a-3a40-43f4-b5cd-d6c540ac7c07	e0978ebd-f166-419a-8155-2203c56a023e
f2c492db-f8f3-4857-b307-cc0fdc591281	d6b0479a-3a40-43f4-b5cd-d6c540ac7c07	8ab02188-799d-42b6-ad0a-3a24ba1f81c3
746ff65b-d8b5-46c1-af88-beb36ede924b	05186cba-8a1f-4a12-a968-a8d790372aa9	16424a71-9a8c-4d6a-837a-72ea7bbe9408
c6eba212-f354-4b3f-9157-f42f665a9a87	05186cba-8a1f-4a12-a968-a8d790372aa9	167cec82-cf24-40c1-a02c-a7a7ce1a25e6
713db7a2-211f-4dbb-be83-ada9cde9e2e8	05186cba-8a1f-4a12-a968-a8d790372aa9	8aa6c5a4-fac7-4d68-8058-213a12022207
27962536-fb9d-4de7-8fdf-73989eec334d	cafd0dfc-c45a-435f-8e90-b4df8d876647	5616b3d9-d971-4dd2-a9f8-3e6cb5fdd565
2fbb910c-26d1-4b6d-9a81-b41f2af68fef	cafd0dfc-c45a-435f-8e90-b4df8d876647	ecbc9cbd-1241-4a80-9558-f643f1884a88
10633cf1-90ba-41cf-a907-7cedf5aac4b0	cafd0dfc-c45a-435f-8e90-b4df8d876647	1a112b38-b8b2-4c5a-a200-f3dbacd77888
40d73606-32aa-4f23-9e7a-b1d9a32446bb	ff924716-cecf-468f-91b2-ae0e10b8c394	43e90d9b-06c0-4983-9e30-1728ef37045f
32ec641c-f99d-4763-a130-385e153a4877	ff924716-cecf-468f-91b2-ae0e10b8c394	fe6d4649-a45e-46ab-90e2-fc5f0eec36b2
b4ed0cbb-8a4c-46e5-bacd-c597c9d5740a	ff924716-cecf-468f-91b2-ae0e10b8c394	c92313df-58de-49ab-97be-aeebad9072d8
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
bb8dff51-ac8d-433a-9023-d9d61d549911	On-003483 Taxonomic analysis-Reissue	JDG-232-5 Summary	unknown	unknown	2020-04-23 19:51:40.425	2020-05-05 19:53:44.359	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	e02b3a0a-9b8a-474c-9b77-a98ba428283a
21868485-7af3-48c1-bc8d-1a146e052b0d	Vehicle Storage	require numerous places around the province in order to keep vehicles secured.	unknown yet	unknown yet	2020-04-22 17:24:17.735	2020-04-22 17:26:01.744	d930683b-68e0-44f5-a31d-398815e32909	1e5def8d-c2b2-4231-a602-09a80967d2dc	828e8637-1699-4dc1-805a-b4333270d4f0
348cdfae-a503-4b68-9cc2-e06a7e34cac0	ON-003440 Taxonomic Analysis	JDG-232-4 Summary	unknown	unknown	2020-04-23 19:50:01.354	2020-05-05 19:53:49.325	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	e02b3a0a-9b8a-474c-9b77-a98ba428283a
4562f639-7012-4b1c-ab3d-a740c8dea828	TI Corp SMS	SaaS to manage the communication for TI Corps three major projects	Draft RFP	Review RFP	2020-04-22 17:34:21.463	2020-04-22 17:34:21.463	2d2796cc-4950-4811-abf9-cebd2d9d7f01	6095c8e0-5569-4263-b835-ac75c13d7d26	828e8637-1699-4dc1-805a-b4333270d4f0
95f6585d-d840-49e3-95db-5d4d1b86ab40	EnWQS	Information system for Water Quality System.	Draft documents, lead procurement.	Review provided documents only.	2020-04-22 17:22:59.255	2020-04-22 17:47:02.245	4c70dd71-1938-4a01-a86b-ced42b12c11e	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
fb408cd3-05dd-4977-a1e7-47cee6034c09	Workplace Technology Services Procurement Project	Project team is presently evaluating options for bundling of the services which could result in one, two, or three separate procurement projects. The summary and details, as well as the solicitation vehicles are to be determined. 	Planning:\nperform needs assessment, develop business\ncase, perform risk assessment;\nassist with development of terms of reference\ndocumentation for ministry approval;\nContracts:\ncontract negotiations; \nreview and comment on contract;\ndraft contract documents;	Lead procurement functions, including:\nidentify and develop procurement strategy; \nresearch, edit, create, review, comment and\nprovide input into solicitation documents;\nchair vendor/proponent meetings; \nrespond to vendor/proponent inquiries, in\nconsultation with Ministry staff;\ncreate, edit, review and provide input into the\nevaluation plan and booklets;\nprovide advice during evaluations; \nevaluate submissions (only when necessary);\nchair evaluation consensus meetings; Lead Support\nreview and provide input into scoring overviews\nand synopsis of evaluation notes;\nnotify proponents of evaluation results/short-listed\nresults;\ncreate, review and provide input into the\npresentation plan and booklet;\nchair short-listed presentation meeting(s); Lead Support\npost and close solicitation; Lead Support\nassist with preparation of briefing\nassist with preparation of briefing notes and\nsummary of the procurement process;\nparticipate in proponent debriefings;\nprovide support/advice for any vendor conflict\nresolution and/or vendor complaint processes;	2020-04-22 19:01:58.32	2020-04-22 19:07:55.365	2c933486-0a9b-40de-adc9-eaa9319a16f2	4a726944-a454-4eda-aab9-ebb5db9744ac	828e8637-1699-4dc1-805a-b4333270d4f0
dd22c4d9-bc44-4dcd-93de-d148a26e686c	Soft Body Armor	Procurement of soft body armor on an if, when and as needed basis.	Supporting the drafting and they will be handling the finalized document once complete (posting of the document onwards)	Supporting the RMSA drafting process and providing ad-hoc advice as needed. 	2020-04-22 20:23:09.089	2020-04-22 20:23:09.089	3e06c426-422c-4bf0-923f-94e0aed5c43b	caa352ac-224c-4684-b3c2-3169dcf6c784	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
defede2e-0492-468f-9da8-af187cfc8f22	Energy Study and Related Services	suppliers to provide Renewable Energy Study, Strategic Energy Management Plan or Energy Efficiency Feasibility Study.	unknown\n	management of CSAs	2020-04-22 21:34:11.782	2020-04-22 21:34:11.782	6680eec1-85c6-446c-86ef-677db7908c1a	1715e865-c294-44e7-a0d8-37a4950f720b	5a488660-8969-4a58-8d47-85a9bb03c3e0
b97b7001-a476-4982-943b-20719316a8e3	Danger Tree Assessor Faller	Provision of Qualified Fallers and Danger Tree Assessor Fallers by Fire Centre throughout the Province	scope and contract development, evaluation	RSA drafting, consensus, meeting facilitation	2020-04-23 23:13:28.899	2020-04-23 23:13:28.899	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	1e5def8d-c2b2-4231-a602-09a80967d2dc	a5ee8ab6-ab63-461c-a736-6d4cc7b7ed84
faaba30d-8d67-4c48-9bd4-e03a79b8d98d	Security Services for Wildfire Suppression	Security services for wildfire crew camps throughout BC	scope and contract development	drafting, meeting facilitation, consensus	2020-04-23 23:13:31.566	2020-04-23 23:13:31.566	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	1e5def8d-c2b2-4231-a602-09a80967d2dc	7a66f09f-9252-4768-8434-324d8d23dd88
baf90f14-12e6-4e90-8543-e27d40cff5ab	First Aid Services	First Aid by Fire Centre 	contract and scope development, evaluation	Drafting, facilitation of meetings, consensus	2020-04-23 23:13:33.649	2020-04-23 23:13:33.649	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	1e5def8d-c2b2-4231-a602-09a80967d2dc	5a488660-8969-4a58-8d47-85a9bb03c3e0
ba8e4f8a-4208-45cc-a17d-4b84bd9cf80b	Type III Fire Crew Services	Type III Fire Crews bid per Business Location	evaluation, scope, contract development	drafting, meeting facilitation, 	2020-04-23 23:13:36.72	2020-04-23 23:13:36.72	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	1e5def8d-c2b2-4231-a602-09a80967d2dc	7a66f09f-9252-4768-8434-324d8d23dd88
3ff077b0-440b-481e-a234-cb89deabb169	ON-003427 Taxonomic Macroinvertebrates	JDG-232-3 summary	unknown	unknown	2020-04-23 19:47:46.377	2020-05-05 19:53:52.724	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	e02b3a0a-9b8a-474c-9b77-a98ba428283a
d2b11e76-6892-4e49-b147-bdb5fa02b57c	ON-003423 Gravimetric Analysis	 JDG-232-2 summary	unknown	unknown	2020-04-22 22:23:51.192	2020-05-05 19:53:54.936	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	e02b3a0a-9b8a-474c-9b77-a98ba428283a
50c157bb-1ee4-40f5-9f01-d2758195757a	ON-003267 Analysis of Environmental Samples	JDG-232-1 summary	unknown	unknown	2020-04-22 22:21:08.43	2020-05-05 19:53:58.174	99543d57-26fd-4ba4-8f31-668bab5f7773	6095c8e0-5569-4263-b835-ac75c13d7d26	e02b3a0a-9b8a-474c-9b77-a98ba428283a
2562b9d4-a530-43bc-8228-8ede8ecbfb0b	Type II Fire Crew Services	20 standing arrangements for Type II Crews	Scope development; contract development with contract legal	drafting; meetings	2020-04-23 23:13:39.316	2020-04-23 23:13:39.316	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	1e5def8d-c2b2-4231-a602-09a80967d2dc	e02b3a0a-9b8a-474c-9b77-a98ba428283a
bc1b974d-e73c-4992-8a57-b9eaeed7b66e	Falling Coordinator and Danger Tree Specialist	provision of supervisory roles for wildfire suppression throughout the Province	contract and scope development, evaluation	consensus, debriefs, RSA drafting, meeting facilitation	2020-04-23 23:15:07.984	2020-04-23 23:15:07.984	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	1e5def8d-c2b2-4231-a602-09a80967d2dc	a5ee8ab6-ab63-461c-a736-6d4cc7b7ed84
68c0f938-d8b3-42f3-ac41-36df507026a8	Structure Protection Crew/Unit Services	Provision of structure protection crews and units for wildfire suppression throughout the province	contract and scope development	Debriefs, consensus, RSA drafting, meeting facilitation	2020-04-23 23:16:26.026	2020-04-23 23:16:26.026	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	1e5def8d-c2b2-4231-a602-09a80967d2dc	5a488660-8969-4a58-8d47-85a9bb03c3e0
2070cfee-6664-4874-896d-cf32704395f1	Environmental Project Management and Implementation Services	Environmental Project Management and Implementation Services	Proving SME input. Handle posting of document onwards.	Support with drafting.	2020-04-24 16:50:51.176	2020-04-24 16:50:51.176	0da1c7d6-5b71-4232-8c20-ed2e52d08091	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
07b6b768-88c2-4ea5-863e-d808926230b5	DEMS RFP	The Ministry of the Attorney General (AG), is committed to upholding public safety and administering justice, by conducting fair and effective prosecutions and appeals. A criminal investigation involves the collection of ‘evidence’ or information and data; over the last few years, the quantity of this information has been growing exponentially. Furthermore, a significant and growing amount of the information is in an electronic form, that is, digital evidence. The law in Canada requires that any information that may be relevant to a criminal case be ‘disclosed’ to the accused. As a response to the large growth in the amount of digital evidence collected during criminal cases, the BC justice sector has been working together to develop a digital evidence and disclosure management solution (DEMS) to be used across the Province. \n\nThe Attorney General is seeking proposals from vendors to implement a digital evidence and disclosure management solution across the Province of British Columbia. 	Draft requirements	Run RFP process	2020-04-23 23:17:58.459	2020-04-24 18:30:30.746	8959e597-c09f-46b6-a515-b3ce076a9a94	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
80c4322d-8f5f-4fc7-b81e-b8052137c6b3	ON-003048	This Negotiated Request for Proposals (“NRFP”) invites prospective Proponents to submit Proposals to make available an existing commercially available, off-premise, supplier-hosted in Canada, Telecom Expense Management (“TEM”) as-a-service solution on an as, if and when requested basis.  However, Proponents should offer services in all three of the following separate modules, each with the option to be self or fully managed: Module 1 - Invoice Presentation and Reporting; Module 2 - Managed Mobility Services; and Module 3 - Fixed and Wireline Management Services.  Service Categories within Modules 2 and 3 may include, but are not limited to, sourcing management, ordering and provision management, invoice management, inventory management, usage management, dispute management and reporting.  \n\nAs Ministry responsible for acquiring and managing contracts for telecommunications services other than mobile wireless services for all of the government of British Columbia, the Ministry on behalf of the Province has an immediate need for Module 1 services and a future potential need for Module 3 services.  Potential Province subscribers to Module 2 services are any ministries, agencies, boards, commissions or other bodies that are part of the government of British Columbia that choose, in their sole and absolute discretion, to procure such services from the successful Proponent for their respective needs.  All 3 Modules should also be available to any broader public sector entity or other user on the Province’s Corporate Supply Arrangement User List as the Province may update from time to time, which would procure in the entity’s own name, should it choose in its sole and absolute discretion to procure any such services from  the successful Proponent.\nFurther details as to the scope of this opportunity and the requirements can be found in this NRFP.\n	Drafting	Requirements gathering assistance, drafting, posting, etc. 	2020-04-24 18:41:19.631	2020-04-24 18:41:19.631	cf7c4e65-b95a-4fea-aa49-96acb87290b2	5e6e73db-9d39-4301-90e3-4018bb954d9d	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
5650bf16-7d4c-48e2-855f-461cff085b45	Supply of Uniform Jackets for BC Parks Park Rangers	TBD	Draft and Review RFP	Draft, review and post RFP.	2020-04-27 19:15:45.047	2020-04-27 19:15:45.047	f9211d4d-6e4c-4c16-8ff1-e11533648789	6095c8e0-5569-4263-b835-ac75c13d7d26	828e8637-1699-4dc1-805a-b4333270d4f0
5910e3f0-7527-4ee1-b9ab-536363655ab0	Supply of Pants, Shorts and Jackets for BC PARKS Park Rangers	BC Parks within the Ministry of Environment and Climate Change Strategy is requesting information from interested parties for the supply of Uniform Jackets (hardshell and softshell products), Pants and Shorts for Park rangers, in Men's and Women's Style, over a multiyear supply arrangement.	Draft and review RFI	Draft, review and post RFI	2020-04-27 20:36:19.23	2020-04-29 16:18:10.352	05bee9b0-882a-4ed6-8bf8-1d0fdb01117b	bf33dc34-2731-4970-abdd-690bf17b490f	a5ee8ab6-ab63-461c-a736-6d4cc7b7ed84
3924cb48-83dc-4c1d-b405-fecd2fb84c00	Supply of Pants, Shorts and Jackets for BC PARKS Park Rangers	BC Parks within the Ministry of Environment and Climate Change Strategy is requesting information from interested parties for the supply of Uniform Jackets (hardshell and softshell products), Pants and Shorts for Park rangers, in Men's and Women's Style, over a multiyear supply arrangement.	Draft and review RFP	Draft, review and post RFP	2020-04-29 16:21:43.623	2020-04-29 16:21:43.623	05bee9b0-882a-4ed6-8bf8-1d0fdb01117b	6095c8e0-5569-4263-b835-ac75c13d7d26	828e8637-1699-4dc1-805a-b4333270d4f0
7e781913-bea0-4e31-b452-9f608c2c1b71	Traditional Media Planning and Buying	The first of two RFPs (the second being Digital Media Planning and Buying)	Evaluation chair and debriefs.	Support drafting, vetting of proposals, drafting evaluation handbook, ad-hoc support. 	2020-04-30 21:38:42.159	2020-04-30 21:38:42.159	fa38f829-2342-4781-a9af-89e078a42dd9	6095c8e0-5569-4263-b835-ac75c13d7d26	5a488660-8969-4a58-8d47-85a9bb03c3e0
0c31bab9-fe84-433d-a096-4c6597ffde7b	Administration	This is for the recording of Administration Support	This is for the recording of Administration Support	This is for the recording of Administration Support	2020-05-01 05:22:43.536	2020-05-01 05:22:43.536	b0245539-30d8-486e-bd3a-857d283fec62	6095c8e0-5569-4263-b835-ac75c13d7d26	828e8637-1699-4dc1-805a-b4333270d4f0
6a882f44-2f94-4446-9e47-2db382285ed6	Ad-Hoc Advice	This is for records for Ad-Hoc Advice	This is for records for Ad-Hoc Advice	This is for records for Ad-Hoc Advice	2020-05-01 05:23:49.503	2020-05-01 05:23:49.503	ea6c0de6-9305-476e-8afa-3647b2f9b472	6095c8e0-5569-4263-b835-ac75c13d7d26	828e8637-1699-4dc1-805a-b4333270d4f0
37157ef3-fe9d-47c4-b419-572e94abfb67	Managed Print Services	Managed print services for Province.	Project management, documents, review, approvals.	Advisory.	2020-05-01 21:58:10.34	2020-05-01 21:58:10.34	12b59b16-e92d-471d-b872-e793e0813979	6095c8e0-5569-4263-b835-ac75c13d7d26	828e8637-1699-4dc1-805a-b4333270d4f0
d862a15b-c684-4318-8a0a-006f186dadab	Resources for ADMS	Business and technical resources for projects.	Project management, documents, evaluation, approvals.	Review documents, facilitate evaluation, advisory.	2020-05-01 22:18:18.63	2020-05-01 22:18:18.63	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	6095c8e0-5569-4263-b835-ac75c13d7d26	5a488660-8969-4a58-8d47-85a9bb03c3e0
d71e68f7-eeaf-488e-8949-bac4b2e224db	ON-003406 Quantity Surveyor	PSB1101-153 	.	.	2020-05-06 16:46:05.178	2020-05-06 16:46:05.178	c38d894c-4754-4722-b6c6-a289bc3f2a94	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
5383c247-b07e-4345-9136-79acaa499e5c	ON-003471 Prime Consultant	PSB1101-154	.	.	2020-05-06 16:47:06.737	2020-05-06 16:47:25.237	c38d894c-4754-4722-b6c6-a289bc3f2a94	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
17d86868-2e3e-42c0-ae4f-fe1044639743	ON-003472 Getechnical RFQ	PSB1101-155	.	.	2020-05-06 16:49:16.957	2020-05-06 16:49:16.957	c38d894c-4754-4722-b6c6-a289bc3f2a94	2c173fd3-1cc4-465a-80f8-4072c41713d3	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
e0dd8674-8987-4706-8dc0-0ab0ed28d844	ON-003449 Psychiatric Hospital	PSB1101-156	.	.	2020-05-06 16:50:45.348	2020-05-06 16:52:05.657	c38d894c-4754-4722-b6c6-a289bc3f2a94	2c173fd3-1cc4-465a-80f8-4072c41713d3	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
97fb07c6-0468-4989-b28d-0d6b8c88414e	ON-003474 Contracting Services	PSB1101-161 1810 Blanshard Street	.	.	2020-05-06 16:53:24.111	2020-05-06 16:53:24.111	c38d894c-4754-4722-b6c6-a289bc3f2a94	2c173fd3-1cc4-465a-80f8-4072c41713d3	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
9fef997d-04cc-40fd-98c6-4eaa15c1d11b	ON-003499 Government House	PSB1101-162	.	.	2020-05-06 16:54:10.912	2020-05-06 16:54:52.396	c38d894c-4754-4722-b6c6-a289bc3f2a94	2c173fd3-1cc4-465a-80f8-4072c41713d3	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
1610194d-3e1c-4ec3-a387-d7212da980f8	ON-003503 Camosun College Feasibility Study	PSB1101-163	.	.	2020-05-06 16:57:58.613	2020-05-06 16:57:58.613	c38d894c-4754-4722-b6c6-a289bc3f2a94	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
0039b709-3fe4-4800-9160-412766f2142b	ON-003502 Prime Consultant Duncan BC	PSB1101-164	.	.	2020-05-06 16:58:54.442	2020-05-06 16:58:54.442	c38d894c-4754-4722-b6c6-a289bc3f2a94	6095c8e0-5569-4263-b835-ac75c13d7d26	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
8cb1a1d4-9e60-40c1-a154-506ab99748f5	ON-0003505 1810 Blanshard Street	PSB1101-165	.	.	2020-05-06 19:32:32.392	2020-05-06 19:32:32.392	c38d894c-4754-4722-b6c6-a289bc3f2a94	7b3ac6e6-b424-4a27-8c2f-d9e179fcd6a5	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
64c94dec-e991-47f5-a57a-e34937771801	ON-003492 Government House	PSB1101-166	.	.	2020-05-06 19:33:27.31	2020-05-06 19:33:27.31	c38d894c-4754-4722-b6c6-a289bc3f2a94	7b3ac6e6-b424-4a27-8c2f-d9e179fcd6a5	e75d7fca-0b1c-4047-99a9-52af3c21cb3a
8d3fffb4-eb77-49f5-ada7-e84af21365ec	1	Supply and delivery of office supplies for all core government via online catalogue and online and telephone ordering	1	1	2020-05-07 20:27:28.694	2020-05-07 20:27:28.694	7d12d0b0-370f-42cf-9b35-7c65489b736a	6095c8e0-5569-4263-b835-ac75c13d7d26	828e8637-1699-4dc1-805a-b4333270d4f0
82f5a10c-db64-4dbd-b51d-38f9c6cf705c	LED Street Light Luminaires CSA	LED Street Light Luminaires CSA	n/a	manage	2020-05-07 21:30:23.774	2020-05-07 21:40:04.946	ca002197-8b36-4395-a9b0-4ad50b6223f6	1715e865-c294-44e7-a0d8-37a4950f720b	f72575d2-c72e-46e5-a1b0-222ad9b2c245
0b2cc1c5-7abd-45aa-9cd2-c60ffa9dc4f5	BC Bid Operational Support	This Project is for PSB staff to record their time and effort for BC Bid.	This Project is for PSB staff to record their time and effort for BC Bid.	This Project is for PSB staff to record their time and effort for BC Bid.	2020-05-12 22:54:10.325	2020-05-12 22:54:10.325	7705fd59-37b6-4d8b-8f8d-fb1329569f8a	6095c8e0-5569-4263-b835-ac75c13d7d26	f72575d2-c72e-46e5-a1b0-222ad9b2c245
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
1e0be7cf-6040-4156-b4d7-f4ea46a37335	8	2020-04-23 23:10:58.387	2020-04-23 23:10:58.387	e969a6eb-2819-445f-a3f5-1aad40ad75b4	23a93640-3a41-44b9-9f9a-71ee45f7bffb	07253129-ca19-4b15-bf1f-26621640e30b
24e86e04-e812-4e4f-b148-34b352ba49a0	2	2020-04-23 23:10:58.429	2020-04-23 23:10:58.429	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	07253129-ca19-4b15-bf1f-26621640e30b
84b118ca-7d3f-4a22-8d0d-74c22b66584f	1	2020-04-23 23:10:58.436	2020-04-23 23:10:58.436	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	07253129-ca19-4b15-bf1f-26621640e30b
f772c831-131b-423c-8f6e-4680d2106913	2	2020-04-23 23:10:58.44	2020-04-23 23:10:58.44	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	07253129-ca19-4b15-bf1f-26621640e30b
52894e85-b3d2-48e0-ac5b-d2bac7450313	1	2020-04-23 23:10:58.445	2020-04-23 23:10:58.445	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	07253129-ca19-4b15-bf1f-26621640e30b
672c577a-7370-4973-82ac-33d9281a67db	4	2020-04-23 23:10:58.45	2020-04-23 23:10:58.45	ec300240-d516-40d4-b9b3-8a23d8f4e951	e047e857-e7d8-468e-8380-d2990f3bc384	07253129-ca19-4b15-bf1f-26621640e30b
629c76ac-7cd0-4a7d-8a72-e879835f9746	3	2020-04-23 23:10:58.454	2020-04-23 23:10:58.454	c81159f4-42bb-48b1-8338-592df3b43eff	087c00f6-9541-413b-b300-a8f3f6e5bd69	07253129-ca19-4b15-bf1f-26621640e30b
421c3b31-2c1b-48c9-8420-c06e9e00b852	3	2020-04-23 23:10:58.457	2020-04-23 23:10:58.457	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	07253129-ca19-4b15-bf1f-26621640e30b
45db48b9-8dd0-4d89-b7f8-7ab020165fde	1	2020-04-23 23:10:58.461	2020-04-23 23:10:58.461	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	07253129-ca19-4b15-bf1f-26621640e30b
190abb03-fbdd-4d79-b7fd-db953ac80180	1	2020-04-23 23:10:58.465	2020-04-23 23:10:58.465	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	07253129-ca19-4b15-bf1f-26621640e30b
23175217-f951-4294-8f09-299906e77bcb	10	2020-04-24 15:52:19.339	2020-04-24 15:52:19.339	e969a6eb-2819-445f-a3f5-1aad40ad75b4	af07c63d-4c96-40ad-83e5-a9e06ab64fb6	3ecd81b6-e034-4c6f-b56e-3b76718bb111
fb640912-ff6d-48f5-88f3-d102f09d2c4c	4	2020-04-24 15:52:19.381	2020-04-24 15:52:19.381	7867249a-657a-489a-9203-1754ed8885cc	e6379225-7cd4-48e9-9d3b-7fee086dd006	3ecd81b6-e034-4c6f-b56e-3b76718bb111
a159533d-e1af-40d1-834f-863cc0d54b1e	2	2020-04-24 15:52:19.406	2020-04-24 15:52:19.406	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	3ecd81b6-e034-4c6f-b56e-3b76718bb111
c54b330b-386c-4b8e-bd5f-2380a5785813	2	2020-04-24 15:52:19.431	2020-04-24 15:52:19.431	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	3ecd81b6-e034-4c6f-b56e-3b76718bb111
b2420e19-a69c-4b53-8a69-11183f8521c7	2	2020-04-24 15:52:19.472	2020-04-24 15:52:19.472	1f71e8bc-5b88-40c3-ab99-553368ebf685	ff3978b8-3025-4e2e-aac3-7873b6cc74d9	3ecd81b6-e034-4c6f-b56e-3b76718bb111
a6a3577a-779c-4efe-98dc-d29f94ddb59b	2	2020-04-24 15:52:19.478	2020-04-24 15:52:19.478	ec300240-d516-40d4-b9b3-8a23d8f4e951	5641fe2c-a6d2-4434-9d0b-15a1c99bbb22	3ecd81b6-e034-4c6f-b56e-3b76718bb111
18ce9ef4-8604-4bca-86b8-d32485183348	2	2020-04-24 15:52:19.483	2020-04-24 15:52:19.483	c81159f4-42bb-48b1-8338-592df3b43eff	19dc1942-b79f-447b-9004-29f0a299ac6a	3ecd81b6-e034-4c6f-b56e-3b76718bb111
b31fbeb2-6eaa-47ef-b987-088c0250becc	1	2020-04-24 15:52:19.487	2020-04-24 15:52:19.487	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	3ecd81b6-e034-4c6f-b56e-3b76718bb111
139890fe-2b25-4286-97f5-f038ea60108d	2	2020-04-24 15:52:19.492	2020-04-24 15:52:19.492	a19f05bd-8172-4994-b991-fc717b0e46f2	1836784b-ed08-44b7-a898-8cf3f5119fe4	3ecd81b6-e034-4c6f-b56e-3b76718bb111
c9c5adb6-f28d-4042-ab0d-4dab4d807ceb	1	2020-04-24 15:52:19.496	2020-04-24 15:52:19.496	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	2d8b22af-1b06-4728-830a-2fb0726b85ca	3ecd81b6-e034-4c6f-b56e-3b76718bb111
0ee18abb-e45c-4984-a814-de4542486722	8	2020-04-24 18:23:17.077	2020-04-24 18:23:17.077	e969a6eb-2819-445f-a3f5-1aad40ad75b4	23a93640-3a41-44b9-9f9a-71ee45f7bffb	e9a4511e-7aee-4553-a32b-62d05e785e32
d981b0e3-6403-4fff-9727-648e3ce0174a	10	2020-04-24 18:23:17.104	2020-04-24 18:23:17.104	7867249a-657a-489a-9203-1754ed8885cc	cf38beb1-58af-43c3-be69-0706a0806df8	e9a4511e-7aee-4553-a32b-62d05e785e32
a8d29b35-2ba9-4505-bb97-4f0e387409f0	2	2020-04-24 18:23:17.109	2020-04-24 18:23:17.109	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	e9a4511e-7aee-4553-a32b-62d05e785e32
5bc479cb-07dc-4b57-a53b-adbc96dfb171	2	2020-04-24 18:23:17.113	2020-04-24 18:23:17.113	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	e9a4511e-7aee-4553-a32b-62d05e785e32
d402b795-6aff-4105-a0b6-4b8be36edf70	4	2020-04-24 18:23:17.12	2020-04-24 18:23:17.12	1f71e8bc-5b88-40c3-ab99-553368ebf685	7e5e6063-6e37-415e-9367-b2f9ab1c7f5f	e9a4511e-7aee-4553-a32b-62d05e785e32
05b5c550-148a-497e-a9f9-b1bc4d53f51e	4	2020-04-24 18:23:17.124	2020-04-24 18:23:17.124	ec300240-d516-40d4-b9b3-8a23d8f4e951	e047e857-e7d8-468e-8380-d2990f3bc384	e9a4511e-7aee-4553-a32b-62d05e785e32
9e58cd8b-26ae-495e-9026-743e958fbc03	2	2020-04-24 18:23:17.129	2020-04-24 18:23:17.129	c81159f4-42bb-48b1-8338-592df3b43eff	19dc1942-b79f-447b-9004-29f0a299ac6a	e9a4511e-7aee-4553-a32b-62d05e785e32
29263932-0a1b-4a74-b457-7fad861094b8	1	2020-04-24 18:23:17.133	2020-04-24 18:23:17.133	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	e9a4511e-7aee-4553-a32b-62d05e785e32
68edc978-3495-45b4-a43b-4e7a3c6d7a89	2	2020-04-24 18:23:17.137	2020-04-24 18:23:17.137	a19f05bd-8172-4994-b991-fc717b0e46f2	1836784b-ed08-44b7-a898-8cf3f5119fe4	e9a4511e-7aee-4553-a32b-62d05e785e32
b912d143-6a20-423d-9d9b-5529026012d8	1	2020-04-24 18:23:17.142	2020-04-24 18:23:17.142	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	2d8b22af-1b06-4728-830a-2fb0726b85ca	e9a4511e-7aee-4553-a32b-62d05e785e32
57234d92-6e2e-48cf-8978-bb28ffb3acdc	8	2020-04-24 18:26:01.403	2020-04-24 18:26:01.403	e969a6eb-2819-445f-a3f5-1aad40ad75b4	23a93640-3a41-44b9-9f9a-71ee45f7bffb	f79cb383-2dc6-498b-be7a-4d3718beb589
2fc4f58f-77ac-4de5-89f5-5d39a9588755	4	2020-04-24 18:26:01.478	2020-04-24 18:26:01.478	7867249a-657a-489a-9203-1754ed8885cc	e6379225-7cd4-48e9-9d3b-7fee086dd006	f79cb383-2dc6-498b-be7a-4d3718beb589
735d04c2-70f4-40e9-8f81-337aa5a7d9d3	1	2020-04-24 18:26:01.483	2020-04-24 18:26:01.483	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	f79cb383-2dc6-498b-be7a-4d3718beb589
6d34df62-d9d1-407b-94a7-fb9d5906715e	2	2020-04-24 18:26:01.487	2020-04-24 18:26:01.487	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	f79cb383-2dc6-498b-be7a-4d3718beb589
5413af6a-5ecc-4ed9-b712-a18591996f06	2	2020-04-24 18:26:01.49	2020-04-24 18:26:01.49	1f71e8bc-5b88-40c3-ab99-553368ebf685	ff3978b8-3025-4e2e-aac3-7873b6cc74d9	f79cb383-2dc6-498b-be7a-4d3718beb589
de54a287-b02a-4678-ac7d-996c687f7e20	4	2020-04-24 18:26:01.497	2020-04-24 18:26:01.497	ec300240-d516-40d4-b9b3-8a23d8f4e951	e047e857-e7d8-468e-8380-d2990f3bc384	f79cb383-2dc6-498b-be7a-4d3718beb589
f16ad4b8-b755-48f6-b04c-b53004c5e8e5	1	2020-04-24 18:26:01.501	2020-04-24 18:26:01.501	c81159f4-42bb-48b1-8338-592df3b43eff	f6319753-11fe-4e28-8ed4-6195a6b9bbb7	f79cb383-2dc6-498b-be7a-4d3718beb589
08a4204b-90b3-4688-9b66-b0feaaf2d088	1	2020-04-24 18:26:01.504	2020-04-24 18:26:01.504	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	f79cb383-2dc6-498b-be7a-4d3718beb589
86eec6f4-fdec-49a9-a291-7e1facfcaa00	1	2020-04-24 18:26:01.508	2020-04-24 18:26:01.508	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	f79cb383-2dc6-498b-be7a-4d3718beb589
5d8c7ea2-2cbc-480b-a642-2adb46db303b	4	2020-04-27 16:44:41.614	2020-04-27 16:44:41.614	e969a6eb-2819-445f-a3f5-1aad40ad75b4	41a02614-dae7-4c48-b1d6-b4c241e2d62f	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
9cf7ab6b-e850-41fd-84c2-160682cac9f6	2	2020-04-27 16:44:41.622	2020-04-27 16:44:41.622	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
b9a65872-360b-46ac-9b24-30dd3611c938	2	2020-04-27 16:44:41.63	2020-04-27 16:44:41.63	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
afff087d-d2f6-4527-a6b7-2843f402e556	2	2020-04-27 16:44:41.639	2020-04-27 16:44:41.639	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
55733bc2-e768-4254-9ded-4cb76a4f3ab5	1	2020-04-27 16:44:41.642	2020-04-27 16:44:41.642	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
19694a98-b215-4446-90e7-a4705bb31c0f	2	2020-04-27 16:44:41.647	2020-04-27 16:44:41.647	ec300240-d516-40d4-b9b3-8a23d8f4e951	5641fe2c-a6d2-4434-9d0b-15a1c99bbb22	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
59ef18e8-e6d7-41b1-b755-37e9ba8e7fd3	4	2020-04-27 16:44:41.65	2020-04-27 16:44:41.65	c81159f4-42bb-48b1-8338-592df3b43eff	77cb51a1-66e4-4f5e-a2ce-5b8e6600753c	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
159b9419-0e3a-44cf-9b79-2ed9d017a7b1	1	2020-04-27 16:44:41.654	2020-04-27 16:44:41.654	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
7d77e889-ca2c-4ef9-841f-595c2ee286ef	2	2020-04-27 16:44:41.658	2020-04-27 16:44:41.658	a19f05bd-8172-4994-b991-fc717b0e46f2	1836784b-ed08-44b7-a898-8cf3f5119fe4	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
4ace7db9-9d0f-4f48-9c8f-cfff52b59259	3	2020-04-27 16:44:41.661	2020-04-27 16:44:41.661	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	cb3d0fec-11c3-467e-a688-0307910225f7	ff40e311-b93d-47ef-9a2a-a70d1b927eb4
3f427bdb-b5ad-432b-98df-50da2a585eae	8	2020-04-28 16:42:37.887	2020-04-28 16:42:37.887	e969a6eb-2819-445f-a3f5-1aad40ad75b4	23a93640-3a41-44b9-9f9a-71ee45f7bffb	f431d4e5-67c0-4b55-b187-94728f2aea6f
86490c0f-1786-4c49-a070-2d5113a0811d	2	2020-04-28 16:42:37.905	2020-04-28 16:42:37.905	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	f431d4e5-67c0-4b55-b187-94728f2aea6f
a672d9a8-ae91-4f33-90e7-f52b8d85a472	1	2020-04-28 16:42:37.912	2020-04-28 16:42:37.912	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	f431d4e5-67c0-4b55-b187-94728f2aea6f
ee926ecd-b026-4a7e-a9b8-3e9cdac63a76	3	2020-04-28 16:42:37.918	2020-04-28 16:42:37.918	94ec86da-f955-4e3d-b0ba-932b3044abdb	0c8e249f-bc3a-4b7c-ab30-bebc1b95d0d0	f431d4e5-67c0-4b55-b187-94728f2aea6f
d840007a-92a0-4f55-b12e-a55649a0e622	1	2020-04-28 16:42:37.922	2020-04-28 16:42:37.922	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	f431d4e5-67c0-4b55-b187-94728f2aea6f
e0e2bf9a-d3a3-4e56-9eca-0ac3f67e5fb9	1	2020-04-28 16:42:37.929	2020-04-28 16:42:37.929	ec300240-d516-40d4-b9b3-8a23d8f4e951	9c5029ec-f3c0-4a28-be70-433f1a1122cb	f431d4e5-67c0-4b55-b187-94728f2aea6f
d25bc74c-0ff5-4385-9340-a30d6e8e7405	1	2020-04-28 16:42:37.934	2020-04-28 16:42:37.934	c81159f4-42bb-48b1-8338-592df3b43eff	f6319753-11fe-4e28-8ed4-6195a6b9bbb7	f431d4e5-67c0-4b55-b187-94728f2aea6f
c4ecea03-72ce-4787-9c51-04e4675430a9	1	2020-04-28 16:42:37.941	2020-04-28 16:42:37.941	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	f431d4e5-67c0-4b55-b187-94728f2aea6f
9f73db96-eaa3-4256-95dc-fe5db7764c92	1	2020-04-28 16:42:37.946	2020-04-28 16:42:37.946	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	f431d4e5-67c0-4b55-b187-94728f2aea6f
2711de4b-8e1e-46cd-8c7e-9355b021e9fb	8	2020-04-28 21:06:25.164	2020-04-28 21:06:25.164	e969a6eb-2819-445f-a3f5-1aad40ad75b4	23a93640-3a41-44b9-9f9a-71ee45f7bffb	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
7fe74800-701c-4485-8692-2cb391d6e4e8	2	2020-04-28 21:06:25.204	2020-04-28 21:06:25.204	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
f4019742-7ce5-4f7a-9506-5f4ee16d0304	1	2020-04-28 21:06:25.211	2020-04-28 21:06:25.211	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
ec719dbc-9120-4154-aaeb-cc627bbf0fcc	2	2020-04-28 21:06:25.215	2020-04-28 21:06:25.215	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
db565949-2cc2-4d8f-8d74-b64bb3ff546e	2	2020-04-28 21:06:25.248	2020-04-28 21:06:25.248	1f71e8bc-5b88-40c3-ab99-553368ebf685	ff3978b8-3025-4e2e-aac3-7873b6cc74d9	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
67c86afe-4138-4a71-98f2-9f0960a4e869	3	2020-04-28 21:06:25.253	2020-04-28 21:06:25.253	ec300240-d516-40d4-b9b3-8a23d8f4e951	6c175262-5a0e-4120-b1ac-1fd3d65943ba	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
3b204c84-969e-4800-9bcb-9597b9f9993a	3	2020-04-28 21:06:25.259	2020-04-28 21:06:25.259	c81159f4-42bb-48b1-8338-592df3b43eff	087c00f6-9541-413b-b300-a8f3f6e5bd69	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
27743cfa-f063-4f1c-aec2-93df9ab75dbb	1	2020-04-28 21:06:25.264	2020-04-28 21:06:25.264	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
6e72ad4e-88d1-4438-aa11-ff01e17e3e9f	2	2020-04-28 21:06:25.269	2020-04-28 21:06:25.269	a19f05bd-8172-4994-b991-fc717b0e46f2	1836784b-ed08-44b7-a898-8cf3f5119fe4	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
84e9ee3f-4147-4a27-9251-0ccef34756f7	2	2020-04-28 21:06:25.302	2020-04-28 21:06:25.302	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	4ddd151e-751c-43e3-9f07-794b1003de70	704ee0c5-8e82-4109-bd34-38ed50f0b2d2
a18bbdc2-6a27-47ee-8485-be25ad6b1a02	2	2020-04-29 21:05:06.865	2020-04-29 21:05:06.865	e969a6eb-2819-445f-a3f5-1aad40ad75b4	78500ca2-c957-4999-96a2-360e5ec78f45	c54a4ff6-f393-4297-a21d-213a039c7bd4
702a6160-f61d-4de6-8cf9-512019f4f2b7	2	2020-04-29 21:05:06.896	2020-04-29 21:05:06.896	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	c54a4ff6-f393-4297-a21d-213a039c7bd4
97de8cec-14ae-4ba5-8c21-a0d543db2472	1	2020-04-29 21:05:06.902	2020-04-29 21:05:06.902	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	c54a4ff6-f393-4297-a21d-213a039c7bd4
84205e1f-ad00-4723-b414-ef38ac2e4e63	1	2020-04-29 21:05:06.907	2020-04-29 21:05:06.907	ec300240-d516-40d4-b9b3-8a23d8f4e951	9c5029ec-f3c0-4a28-be70-433f1a1122cb	c54a4ff6-f393-4297-a21d-213a039c7bd4
4648fad6-0c82-49f2-b09a-12eecab8671d	3	2020-04-29 21:05:06.919	2020-04-29 21:05:06.919	c81159f4-42bb-48b1-8338-592df3b43eff	087c00f6-9541-413b-b300-a8f3f6e5bd69	c54a4ff6-f393-4297-a21d-213a039c7bd4
d530275f-54ff-4e0f-a18f-688d5ce7a0fb	1	2020-04-29 21:05:06.924	2020-04-29 21:05:06.924	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	c54a4ff6-f393-4297-a21d-213a039c7bd4
b219e524-cff2-49e8-8be9-1e9d43746392	3	2020-04-29 21:05:06.93	2020-04-29 21:05:06.93	a19f05bd-8172-4994-b991-fc717b0e46f2	f45d442e-ab56-4067-ab93-86ee3fa0d595	c54a4ff6-f393-4297-a21d-213a039c7bd4
0ded34cd-7e80-4429-9eea-a86d403001ac	2	2020-04-29 21:05:06.941	2020-04-29 21:05:06.941	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	4ddd151e-751c-43e3-9f07-794b1003de70	c54a4ff6-f393-4297-a21d-213a039c7bd4
8462c1ac-0aa7-4909-916b-69b5f315bcf7	8	2020-04-29 22:44:18.6	2020-04-29 22:44:18.6	e969a6eb-2819-445f-a3f5-1aad40ad75b4	23a93640-3a41-44b9-9f9a-71ee45f7bffb	d5675fa2-6a90-4c52-9ab7-d11054de7a10
0f00bf2d-78c5-4935-a0e1-f52fc6a6f178	2	2020-04-29 22:44:18.631	2020-04-29 22:44:18.631	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	d5675fa2-6a90-4c52-9ab7-d11054de7a10
5d6171c6-e718-493f-934c-80c4c540d2d7	1	2020-04-29 22:44:18.635	2020-04-29 22:44:18.635	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	d5675fa2-6a90-4c52-9ab7-d11054de7a10
05085bc4-194d-42f8-986c-31dabb6ce119	1	2020-04-29 22:44:18.641	2020-04-29 22:44:18.641	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	d5675fa2-6a90-4c52-9ab7-d11054de7a10
15c08890-435b-472e-8b46-1529944d0229	1	2020-04-29 22:44:18.645	2020-04-29 22:44:18.645	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	d5675fa2-6a90-4c52-9ab7-d11054de7a10
32bc68f5-bdee-4930-8ab7-1c284952be38	3	2020-04-29 22:44:18.649	2020-04-29 22:44:18.649	a19f05bd-8172-4994-b991-fc717b0e46f2	f45d442e-ab56-4067-ab93-86ee3fa0d595	d5675fa2-6a90-4c52-9ab7-d11054de7a10
ec37c04b-6ac2-444d-9651-486b33677409	3	2020-04-29 22:44:18.653	2020-04-29 22:44:18.653	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	cb3d0fec-11c3-467e-a688-0307910225f7	d5675fa2-6a90-4c52-9ab7-d11054de7a10
514165ce-8501-49aa-891c-22c13f31f6f5	4	2020-04-29 22:54:05.699	2020-04-29 22:54:05.699	e969a6eb-2819-445f-a3f5-1aad40ad75b4	41a02614-dae7-4c48-b1d6-b4c241e2d62f	affe076b-2165-4065-9f95-b6861abb8cb0
48165460-ce99-42c7-8f96-48e439cd91f6	10	2020-04-29 22:54:05.751	2020-04-29 22:54:05.751	7867249a-657a-489a-9203-1754ed8885cc	cf38beb1-58af-43c3-be69-0706a0806df8	affe076b-2165-4065-9f95-b6861abb8cb0
172e0dee-0329-4a9d-bf5b-6ca6a249a687	3	2020-04-29 22:54:05.757	2020-04-29 22:54:05.757	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c21977d3-6311-447b-aea5-0fb7d725326a	affe076b-2165-4065-9f95-b6861abb8cb0
6897ebd6-2167-41dc-9413-6b8041052be3	1	2020-04-29 22:54:05.762	2020-04-29 22:54:05.762	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	affe076b-2165-4065-9f95-b6861abb8cb0
47941d53-defd-44a8-b6b8-83539f233f6a	3	2020-04-29 22:54:05.766	2020-04-29 22:54:05.766	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	affe076b-2165-4065-9f95-b6861abb8cb0
186e77ec-e5b7-46fa-a123-389599eb564e	1	2020-04-29 22:54:05.77	2020-04-29 22:54:05.77	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	affe076b-2165-4065-9f95-b6861abb8cb0
5a792554-2ca8-48af-8d59-599ba08a497c	1	2020-04-29 22:54:05.797	2020-04-29 22:54:05.797	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	affe076b-2165-4065-9f95-b6861abb8cb0
34bafde4-995c-4db0-938d-fa65b7fc5038	10	2020-04-30 21:30:59.01	2020-04-30 21:30:59.01	e969a6eb-2819-445f-a3f5-1aad40ad75b4	af07c63d-4c96-40ad-83e5-a9e06ab64fb6	1d7131e7-228d-40df-b290-815ca8ba4c18
dc6106b0-c8cd-4239-bab2-17b2c233d5c0	4	2020-04-30 21:30:59.044	2020-04-30 21:30:59.044	7867249a-657a-489a-9203-1754ed8885cc	e6379225-7cd4-48e9-9d3b-7fee086dd006	1d7131e7-228d-40df-b290-815ca8ba4c18
d6846950-0e1d-4771-ac18-cecf30db6e79	2	2020-04-30 21:30:59.051	2020-04-30 21:30:59.051	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	1d7131e7-228d-40df-b290-815ca8ba4c18
a71fd60e-e007-450e-b927-60387a5ee8cc	2	2020-04-30 21:30:59.057	2020-04-30 21:30:59.057	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	1d7131e7-228d-40df-b290-815ca8ba4c18
ddccaa68-fb0b-4b0e-9331-4752336e0f25	1	2020-04-30 21:30:59.062	2020-04-30 21:30:59.062	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	1d7131e7-228d-40df-b290-815ca8ba4c18
a81831d3-ad35-47a1-add5-4cbef6bb86a4	4	2020-04-30 21:30:59.07	2020-04-30 21:30:59.07	ec300240-d516-40d4-b9b3-8a23d8f4e951	e047e857-e7d8-468e-8380-d2990f3bc384	1d7131e7-228d-40df-b290-815ca8ba4c18
8ea0884e-147c-44bc-8b4c-5eed27be9391	4	2020-04-30 21:30:59.088	2020-04-30 21:30:59.088	c81159f4-42bb-48b1-8338-592df3b43eff	77cb51a1-66e4-4f5e-a2ce-5b8e6600753c	1d7131e7-228d-40df-b290-815ca8ba4c18
058462da-0877-40e7-9aeb-1a11cdd55cb8	1	2020-04-30 21:30:59.093	2020-04-30 21:30:59.093	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	1d7131e7-228d-40df-b290-815ca8ba4c18
348d5a23-dade-47f9-9bdf-c1da65a7aa7c	2	2020-04-30 21:30:59.098	2020-04-30 21:30:59.098	a19f05bd-8172-4994-b991-fc717b0e46f2	1836784b-ed08-44b7-a898-8cf3f5119fe4	1d7131e7-228d-40df-b290-815ca8ba4c18
8ee2ffed-2c94-41c6-b99b-ca49c8b2f83c	2	2020-04-30 21:30:59.103	2020-04-30 21:30:59.103	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	4ddd151e-751c-43e3-9f07-794b1003de70	1d7131e7-228d-40df-b290-815ca8ba4c18
31f0c76b-5ae2-4bf2-8200-572c27913296	2	2020-04-30 23:22:09.15	2020-04-30 23:22:09.15	e969a6eb-2819-445f-a3f5-1aad40ad75b4	78500ca2-c957-4999-96a2-360e5ec78f45	cf5c3801-5663-4730-8a44-662f15b514a3
89b2c2e2-64c8-4593-b31e-ed1ee2f55583	1	2020-04-30 23:22:09.231	2020-04-30 23:22:09.231	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	cf5c3801-5663-4730-8a44-662f15b514a3
41a2958c-74ae-44a1-9193-302ccd0d8539	5	2020-04-30 23:22:09.238	2020-04-30 23:22:09.238	a08e56db-b334-4270-affc-a8f6e2c0fd0a	cd589aa2-f653-4121-abb0-746c54b42a1b	cf5c3801-5663-4730-8a44-662f15b514a3
18becf2d-153c-4a52-b8f0-572beb063a3d	1	2020-04-30 23:22:09.242	2020-04-30 23:22:09.242	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	cf5c3801-5663-4730-8a44-662f15b514a3
1a02fc74-00aa-4880-b045-24a8e9d851f6	1	2020-04-30 23:22:09.252	2020-04-30 23:22:09.252	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	cf5c3801-5663-4730-8a44-662f15b514a3
a032d67a-b3cb-4739-9ed4-d03c5bdd5afd	2	2020-05-01 05:07:03.39	2020-05-01 05:07:03.39	e969a6eb-2819-445f-a3f5-1aad40ad75b4	78500ca2-c957-4999-96a2-360e5ec78f45	c44d5914-ebdf-4b3a-9dc8-64cc6332ba53
9372a997-7f95-4e17-9290-7d3fb08343ea	1	2020-05-01 05:07:03.419	2020-05-01 05:07:03.419	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	c44d5914-ebdf-4b3a-9dc8-64cc6332ba53
e77838b0-1856-4823-a69f-1586bc5c6b12	5	2020-05-01 05:07:03.437	2020-05-01 05:07:03.437	a08e56db-b334-4270-affc-a8f6e2c0fd0a	cd589aa2-f653-4121-abb0-746c54b42a1b	c44d5914-ebdf-4b3a-9dc8-64cc6332ba53
e1941fa6-9238-4e18-ac71-8e281ba02791	1	2020-05-01 05:07:03.441	2020-05-01 05:07:03.441	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	c44d5914-ebdf-4b3a-9dc8-64cc6332ba53
86c0be75-b7c5-4b81-a7e9-89447c9194ad	1	2020-05-01 05:07:03.449	2020-05-01 05:07:03.449	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	c44d5914-ebdf-4b3a-9dc8-64cc6332ba53
88c20e85-2539-4b2e-8cbf-d6708dc6929b	10	2020-05-01 21:55:52.729	2020-05-01 21:55:52.729	e969a6eb-2819-445f-a3f5-1aad40ad75b4	af07c63d-4c96-40ad-83e5-a9e06ab64fb6	705ec2bd-907b-4700-9a19-084a4cc922ad
c6b7bd12-a3d1-44f0-b3d4-fc1a6deeb2fc	2	2020-05-01 21:55:52.856	2020-05-01 21:55:52.856	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	705ec2bd-907b-4700-9a19-084a4cc922ad
95e835f8-1fb8-467c-8ec6-ebf38dac43a9	2	2020-05-01 21:55:52.863	2020-05-01 21:55:52.863	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	b36e7eff-a464-4417-89b8-0a11ce629fe7	705ec2bd-907b-4700-9a19-084a4cc922ad
7ead1e87-bdb0-4f62-8751-1841c22f2b1a	4	2020-05-01 21:55:52.868	2020-05-01 21:55:52.868	94ec86da-f955-4e3d-b0ba-932b3044abdb	576e0081-9202-47c0-b888-686dd29f820a	705ec2bd-907b-4700-9a19-084a4cc922ad
5b3759e1-7518-41ea-969a-87b97b5a2338	4	2020-05-01 21:55:52.872	2020-05-01 21:55:52.872	1f71e8bc-5b88-40c3-ab99-553368ebf685	7e5e6063-6e37-415e-9367-b2f9ab1c7f5f	705ec2bd-907b-4700-9a19-084a4cc922ad
4b2ee163-42be-4a09-91b6-4c5dee0d8b37	2	2020-05-01 21:55:52.879	2020-05-01 21:55:52.879	ec300240-d516-40d4-b9b3-8a23d8f4e951	5641fe2c-a6d2-4434-9d0b-15a1c99bbb22	705ec2bd-907b-4700-9a19-084a4cc922ad
f88c4707-fa5a-4504-bca6-ab2bda6def5e	2	2020-05-01 21:55:52.883	2020-05-01 21:55:52.883	c81159f4-42bb-48b1-8338-592df3b43eff	19dc1942-b79f-447b-9004-29f0a299ac6a	705ec2bd-907b-4700-9a19-084a4cc922ad
a7587753-54c9-48fe-87c4-d558735dab1a	3	2020-05-01 21:55:52.888	2020-05-01 21:55:52.888	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	705ec2bd-907b-4700-9a19-084a4cc922ad
85557cff-486c-4513-ba94-c02a3daba75f	1	2020-05-01 21:55:52.891	2020-05-01 21:55:52.891	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	705ec2bd-907b-4700-9a19-084a4cc922ad
858f50b6-db53-400b-9385-fff75232cd90	1	2020-05-01 21:55:52.897	2020-05-01 21:55:52.897	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	705ec2bd-907b-4700-9a19-084a4cc922ad
f08598bf-946f-4a9f-8d9e-52f6b9396b4c	8	2020-05-01 22:16:23.062	2020-05-01 22:16:23.062	e969a6eb-2819-445f-a3f5-1aad40ad75b4	23a93640-3a41-44b9-9f9a-71ee45f7bffb	016ece27-6cde-4dd1-953c-0ad105f01f5c
85510ff4-5149-4a39-8f9b-54c30bd51482	2	2020-05-01 22:16:23.091	2020-05-01 22:16:23.091	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	016ece27-6cde-4dd1-953c-0ad105f01f5c
202373dd-5f49-4010-8108-421ebd5cb75b	1	2020-05-01 22:16:23.171	2020-05-01 22:16:23.171	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	016ece27-6cde-4dd1-953c-0ad105f01f5c
4043adb6-45a2-495b-93be-69251d0f9ea4	3	2020-05-01 22:16:23.181	2020-05-01 22:16:23.181	94ec86da-f955-4e3d-b0ba-932b3044abdb	0c8e249f-bc3a-4b7c-ab30-bebc1b95d0d0	016ece27-6cde-4dd1-953c-0ad105f01f5c
e6b91102-a011-4781-9a84-2d31ae646493	1	2020-05-01 22:16:23.189	2020-05-01 22:16:23.189	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	016ece27-6cde-4dd1-953c-0ad105f01f5c
264c9a63-b845-49a6-ac93-8da249e7eeee	1	2020-05-01 22:16:23.195	2020-05-01 22:16:23.195	ec300240-d516-40d4-b9b3-8a23d8f4e951	9c5029ec-f3c0-4a28-be70-433f1a1122cb	016ece27-6cde-4dd1-953c-0ad105f01f5c
8854f91d-0be8-4cba-8fa6-a6656e0165a7	1	2020-05-01 22:16:23.2	2020-05-01 22:16:23.2	c81159f4-42bb-48b1-8338-592df3b43eff	f6319753-11fe-4e28-8ed4-6195a6b9bbb7	016ece27-6cde-4dd1-953c-0ad105f01f5c
101ce90a-6fd2-4b02-9dd6-99d8fff2ff24	3	2020-05-01 22:16:23.206	2020-05-01 22:16:23.206	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	016ece27-6cde-4dd1-953c-0ad105f01f5c
acb9d5ce-43de-42e5-864f-2c3c18fb29b5	1	2020-05-01 22:16:23.21	2020-05-01 22:16:23.21	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	016ece27-6cde-4dd1-953c-0ad105f01f5c
205cb40a-bd46-4d1e-b58c-0500483099a8	1	2020-05-01 22:16:23.217	2020-05-01 22:16:23.217	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	016ece27-6cde-4dd1-953c-0ad105f01f5c
ed26f055-3a79-4715-a79d-d0df63b4e980	6	2020-05-05 18:14:16.918	2020-05-05 18:14:16.918	e969a6eb-2819-445f-a3f5-1aad40ad75b4	f24e1de4-824b-4eec-aac0-5dade4d3c2b9	03ab8cf6-135c-446d-a31b-dbb094f0493d
4432c865-09bb-4730-ac5f-25fc496728ab	10	2020-05-05 18:14:16.929	2020-05-05 18:14:16.929	7867249a-657a-489a-9203-1754ed8885cc	cf38beb1-58af-43c3-be69-0706a0806df8	03ab8cf6-135c-446d-a31b-dbb094f0493d
a3a77b11-1dc3-49ac-a180-8599017f6575	3	2020-05-05 18:14:16.936	2020-05-05 18:14:16.936	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c21977d3-6311-447b-aea5-0fb7d725326a	03ab8cf6-135c-446d-a31b-dbb094f0493d
4aa4b130-ae89-4638-98ee-d20bcd028d7b	1	2020-05-05 18:14:16.942	2020-05-05 18:14:16.942	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	03ab8cf6-135c-446d-a31b-dbb094f0493d
323bf4b0-d137-427c-840f-b4b70b5c771c	1	2020-05-05 18:14:16.947	2020-05-05 18:14:16.947	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	03ab8cf6-135c-446d-a31b-dbb094f0493d
a11447ad-8ec9-4d02-885a-99905bbb6791	1	2020-05-05 18:14:16.95	2020-05-05 18:14:16.951	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	03ab8cf6-135c-446d-a31b-dbb094f0493d
0852fca5-58e2-4dab-85e8-d506fdaf2be2	2	2020-05-05 22:15:34.724	2020-05-05 22:15:34.724	e969a6eb-2819-445f-a3f5-1aad40ad75b4	78500ca2-c957-4999-96a2-360e5ec78f45	29c52b2f-986d-4f33-88f7-18856c3ae7f1
f85c9a64-7335-4c12-8344-c251e5cef0c7	1	2020-05-05 22:15:34.741	2020-05-05 22:15:34.741	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	29c52b2f-986d-4f33-88f7-18856c3ae7f1
75a29326-1cdc-4486-ab88-c34117aa338b	3	2020-05-05 22:15:34.748	2020-05-05 22:15:34.748	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	29c52b2f-986d-4f33-88f7-18856c3ae7f1
f1af190c-6fee-42e2-b159-b0bade86b595	1	2020-05-05 22:15:34.766	2020-05-05 22:15:34.766	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	29c52b2f-986d-4f33-88f7-18856c3ae7f1
03e010d9-9566-4890-b0ba-37d7ac1597bb	1	2020-05-05 22:15:34.782	2020-05-05 22:15:34.782	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	29c52b2f-986d-4f33-88f7-18856c3ae7f1
3c405c19-b12f-47e3-87ce-68ba9f5d3818	2	2020-05-05 23:25:18.428	2020-05-05 23:25:18.428	e969a6eb-2819-445f-a3f5-1aad40ad75b4	78500ca2-c957-4999-96a2-360e5ec78f45	630a6b57-db84-4727-ac48-e4ea6b987cdb
769bbc00-86be-48a1-982d-8e47154a3d18	1	2020-05-05 23:25:18.446	2020-05-05 23:25:18.446	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	630a6b57-db84-4727-ac48-e4ea6b987cdb
d0f22cd7-a0d2-40a4-b49e-4cf9a702cace	3	2020-05-05 23:25:18.454	2020-05-05 23:25:18.454	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	630a6b57-db84-4727-ac48-e4ea6b987cdb
435c14f9-40ec-444a-88c3-8476027dae44	1	2020-05-05 23:25:18.461	2020-05-05 23:25:18.461	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	630a6b57-db84-4727-ac48-e4ea6b987cdb
5a153975-80b8-47dd-b75a-0e82424e972c	1	2020-05-05 23:25:18.469	2020-05-05 23:25:18.469	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	630a6b57-db84-4727-ac48-e4ea6b987cdb
010de6a1-836d-4d9b-a1f2-ef54a9d7e962	2	2020-05-05 23:28:42.552	2020-05-05 23:28:42.552	e969a6eb-2819-445f-a3f5-1aad40ad75b4	78500ca2-c957-4999-96a2-360e5ec78f45	884724c3-7e16-4f23-bde6-370e847ef1c6
9898c605-0e02-4108-b1b4-dbd0db08cec0	1	2020-05-05 23:28:42.564	2020-05-05 23:28:42.564	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	884724c3-7e16-4f23-bde6-370e847ef1c6
6983f8d1-0712-4a10-bafb-ddaafcd6c837	3	2020-05-05 23:28:42.576	2020-05-05 23:28:42.576	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	884724c3-7e16-4f23-bde6-370e847ef1c6
a3ad3eb4-2be2-4d56-abca-d7c07f9c0fe8	1	2020-05-05 23:28:42.581	2020-05-05 23:28:42.581	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	884724c3-7e16-4f23-bde6-370e847ef1c6
65b83aa3-0862-419f-9644-9c16a587b55c	1	2020-05-05 23:28:42.591	2020-05-05 23:28:42.591	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	884724c3-7e16-4f23-bde6-370e847ef1c6
12802ce1-92a4-4700-a040-75435840218a	2	2020-05-05 23:31:52.125	2020-05-05 23:31:52.125	e969a6eb-2819-445f-a3f5-1aad40ad75b4	78500ca2-c957-4999-96a2-360e5ec78f45	4be8b057-9b2c-45e4-9a6f-f59a51861125
f46b964c-91a9-4771-9674-79802f976a0d	1	2020-05-05 23:31:52.14	2020-05-05 23:31:52.14	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	4be8b057-9b2c-45e4-9a6f-f59a51861125
08822b65-b08d-40f2-a232-68b3e72ad1b3	3	2020-05-05 23:31:52.147	2020-05-05 23:31:52.147	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	4be8b057-9b2c-45e4-9a6f-f59a51861125
163553ea-9d9c-4911-8654-b8296f7bc1ca	1	2020-05-05 23:31:52.156	2020-05-05 23:31:52.156	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	4be8b057-9b2c-45e4-9a6f-f59a51861125
dbb02d6f-21ac-45c3-8686-cc50c1dc202c	1	2020-05-05 23:31:52.172	2020-05-05 23:31:52.172	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	4be8b057-9b2c-45e4-9a6f-f59a51861125
6501040b-b6f9-45fe-872d-d8e9237220e7	2	2020-05-05 23:35:04.661	2020-05-05 23:35:04.661	e969a6eb-2819-445f-a3f5-1aad40ad75b4	78500ca2-c957-4999-96a2-360e5ec78f45	285f5e53-1d3d-4cf7-b897-c00f62097942
04396736-472f-42ae-99eb-27ddcd08b52d	1	2020-05-05 23:35:04.695	2020-05-05 23:35:04.695	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	285f5e53-1d3d-4cf7-b897-c00f62097942
85092f43-731f-4d20-b513-2a4e10dc042f	3	2020-05-05 23:35:04.7	2020-05-05 23:35:04.7	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	285f5e53-1d3d-4cf7-b897-c00f62097942
9bacde4d-a65e-441e-9ad7-270ae8a392d9	1	2020-05-05 23:35:04.704	2020-05-05 23:35:04.704	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	285f5e53-1d3d-4cf7-b897-c00f62097942
8c6891b0-dec3-4fac-8757-2708f35f1273	1	2020-05-05 23:35:04.71	2020-05-05 23:35:04.71	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	285f5e53-1d3d-4cf7-b897-c00f62097942
1a5b6714-e26c-4c87-bb1c-fcb9eea4dec6	10	2020-05-06 23:27:08.753	2020-05-06 23:27:08.753	e969a6eb-2819-445f-a3f5-1aad40ad75b4	af07c63d-4c96-40ad-83e5-a9e06ab64fb6	7130c6d3-16f1-4e69-b7e1-4348485b3b48
a79dde08-5570-4726-9fb1-08aca0a0737c	2	2020-05-06 23:27:08.851	2020-05-06 23:27:08.851	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	7130c6d3-16f1-4e69-b7e1-4348485b3b48
91c50ba6-7bc2-41be-ac07-10596ebcc5a2	1	2020-05-06 23:27:08.857	2020-05-06 23:27:08.857	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	7130c6d3-16f1-4e69-b7e1-4348485b3b48
11388a97-0be0-475d-a76a-dc566e865309	2	2020-05-06 23:27:08.861	2020-05-06 23:27:08.861	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	7130c6d3-16f1-4e69-b7e1-4348485b3b48
433a12c6-4fc5-4b0f-a7ca-fb7bb5c5d85e	2	2020-05-06 23:27:08.866	2020-05-06 23:27:08.866	1f71e8bc-5b88-40c3-ab99-553368ebf685	ff3978b8-3025-4e2e-aac3-7873b6cc74d9	7130c6d3-16f1-4e69-b7e1-4348485b3b48
82e47ec8-5e70-4a8b-9e25-832fa28524a2	3	2020-05-06 23:27:08.869	2020-05-06 23:27:08.869	ec300240-d516-40d4-b9b3-8a23d8f4e951	6c175262-5a0e-4120-b1ac-1fd3d65943ba	7130c6d3-16f1-4e69-b7e1-4348485b3b48
ef97b8d0-374d-46d9-9100-2dfbf7d41aa9	1	2020-05-06 23:27:08.873	2020-05-06 23:27:08.873	c81159f4-42bb-48b1-8338-592df3b43eff	f6319753-11fe-4e28-8ed4-6195a6b9bbb7	7130c6d3-16f1-4e69-b7e1-4348485b3b48
dbec2118-4395-40b0-9a40-ef0b75e7349f	3	2020-05-06 23:27:08.879	2020-05-06 23:27:08.879	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	7130c6d3-16f1-4e69-b7e1-4348485b3b48
b88ed341-c1f3-423f-980e-e0f1d3d4cab2	1	2020-05-06 23:27:08.883	2020-05-06 23:27:08.883	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	7130c6d3-16f1-4e69-b7e1-4348485b3b48
29655d50-3b13-4a78-9556-cc7d31d9c028	1	2020-05-06 23:27:08.887	2020-05-06 23:27:08.887	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	7130c6d3-16f1-4e69-b7e1-4348485b3b48
8f44d068-e1a4-49cb-ad3a-da2517fb9a98	8	2020-05-07 13:02:47.763	2020-05-07 13:02:47.763	e969a6eb-2819-445f-a3f5-1aad40ad75b4	23a93640-3a41-44b9-9f9a-71ee45f7bffb	c89127bc-2f55-40e8-bfc9-228c4b928ae0
d660dd47-422e-451b-86d0-a9f8929f702c	2	2020-05-07 13:02:47.772	2020-05-07 13:02:47.772	7867249a-657a-489a-9203-1754ed8885cc	2cc39349-373b-4aa6-9046-9bd23fa24610	c89127bc-2f55-40e8-bfc9-228c4b928ae0
782f1f98-c726-43a6-94be-f2f02d4e0bfa	1	2020-05-07 13:02:47.781	2020-05-07 13:02:47.781	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	c89127bc-2f55-40e8-bfc9-228c4b928ae0
ad48152d-7026-459e-9a5f-36dc40be94fe	3	2020-05-07 13:02:47.785	2020-05-07 13:02:47.785	94ec86da-f955-4e3d-b0ba-932b3044abdb	0c8e249f-bc3a-4b7c-ab30-bebc1b95d0d0	c89127bc-2f55-40e8-bfc9-228c4b928ae0
db2ba742-1e7a-4944-acd1-507da93bb91d	1	2020-05-07 13:02:47.789	2020-05-07 13:02:47.789	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	c89127bc-2f55-40e8-bfc9-228c4b928ae0
0f1e0b4e-0bd5-4315-b032-00fb559cc355	4	2020-05-07 13:02:47.794	2020-05-07 13:02:47.794	ec300240-d516-40d4-b9b3-8a23d8f4e951	e047e857-e7d8-468e-8380-d2990f3bc384	c89127bc-2f55-40e8-bfc9-228c4b928ae0
871af457-5833-46dc-b592-a7acd5bca94e	4	2020-05-07 13:02:47.798	2020-05-07 13:02:47.798	c81159f4-42bb-48b1-8338-592df3b43eff	77cb51a1-66e4-4f5e-a2ce-5b8e6600753c	c89127bc-2f55-40e8-bfc9-228c4b928ae0
3faa9c43-27c6-4136-a997-bb576fe4ce74	3	2020-05-07 13:02:47.802	2020-05-07 13:02:47.802	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	c89127bc-2f55-40e8-bfc9-228c4b928ae0
9f7f95f8-2895-4c20-bc80-3ac1eb8837c8	1	2020-05-07 13:02:47.806	2020-05-07 13:02:47.806	e11046b5-dfcf-4343-aff8-651670cc783f	efe7a811-e2b2-4136-ac76-ad5754236d5c	c89127bc-2f55-40e8-bfc9-228c4b928ae0
ae4380e3-c821-4789-9d62-95cef81b7229	1	2020-05-07 13:02:47.813	2020-05-07 13:02:47.813	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	c89127bc-2f55-40e8-bfc9-228c4b928ae0
60a060d8-0247-4422-bb6e-807fb73784c6	2	2020-05-12 22:51:36.622	2020-05-12 22:51:36.622	e969a6eb-2819-445f-a3f5-1aad40ad75b4	78500ca2-c957-4999-96a2-360e5ec78f45	cafd0dfc-c45a-435f-8e90-b4df8d876647
94513782-a715-48bb-b9e5-f9b57c9cca92	1	2020-05-12 22:51:36.632	2020-05-12 22:51:36.632	94ec86da-f955-4e3d-b0ba-932b3044abdb	464f4657-85c0-47b3-8a09-4097d0df174f	cafd0dfc-c45a-435f-8e90-b4df8d876647
998d1c43-5304-4d66-9907-75b69d43c233	1	2020-05-12 22:51:36.638	2020-05-12 22:51:36.638	a08e56db-b334-4270-affc-a8f6e2c0fd0a	7748816d-ab15-448d-a4b7-a14476d247d1	cafd0dfc-c45a-435f-8e90-b4df8d876647
64d2e781-cc46-438d-849b-a9378676d64b	1	2020-05-12 22:51:36.642	2020-05-12 22:51:36.642	a19f05bd-8172-4994-b991-fc717b0e46f2	848bd7de-d59d-4175-8851-04c5c104ab9a	cafd0dfc-c45a-435f-8e90-b4df8d876647
d20670e2-efe6-4e0f-bdb0-920f3a9664e7	6	2020-05-13 19:20:37.492	2020-05-13 19:20:37.492	e969a6eb-2819-445f-a3f5-1aad40ad75b4	f24e1de4-824b-4eec-aac0-5dade4d3c2b9	ff924716-cecf-468f-91b2-ae0e10b8c394
897b397c-4119-4912-b6d8-e4b4729f1fb4	10	2020-05-13 19:20:37.53	2020-05-13 19:20:37.53	7867249a-657a-489a-9203-1754ed8885cc	cf38beb1-58af-43c3-be69-0706a0806df8	ff924716-cecf-468f-91b2-ae0e10b8c394
4506e0c4-879f-47cb-9f14-fbc329b274db	1	2020-05-13 19:20:37.535	2020-05-13 19:20:37.535	183b80f2-4688-41fd-ae1c-5a6e7f777c3f	c581d97e-a8de-4456-b124-2b988262a81f	ff924716-cecf-468f-91b2-ae0e10b8c394
e059d41b-a412-4d8a-bdd3-1738bd91f36c	2	2020-05-13 19:20:37.543	2020-05-13 19:20:37.543	94ec86da-f955-4e3d-b0ba-932b3044abdb	df250e69-b749-46b8-9aaa-97fca80ce0b0	ff924716-cecf-468f-91b2-ae0e10b8c394
0c889c2d-2570-4caf-bc54-dab9a4b56604	1	2020-05-13 19:20:37.547	2020-05-13 19:20:37.547	1f71e8bc-5b88-40c3-ab99-553368ebf685	beeb71d9-b976-483d-a00b-070d5b648f92	ff924716-cecf-468f-91b2-ae0e10b8c394
967a8a0f-b8c3-4206-ad0a-89f19b3191e5	3	2020-05-13 19:20:37.553	2020-05-13 19:20:37.553	ec300240-d516-40d4-b9b3-8a23d8f4e951	6c175262-5a0e-4120-b1ac-1fd3d65943ba	ff924716-cecf-468f-91b2-ae0e10b8c394
b0dfddc5-b9be-475e-a735-974b5a977323	1	2020-05-13 19:20:37.556	2020-05-13 19:20:37.556	c81159f4-42bb-48b1-8338-592df3b43eff	f6319753-11fe-4e28-8ed4-6195a6b9bbb7	ff924716-cecf-468f-91b2-ae0e10b8c394
384be0cf-4d0c-4f21-b337-7e9819242589	3	2020-05-13 19:20:37.562	2020-05-13 19:20:37.562	a08e56db-b334-4270-affc-a8f6e2c0fd0a	917b957a-4614-4421-bb32-25f317028005	ff924716-cecf-468f-91b2-ae0e10b8c394
ca498d7b-6244-4029-b457-afb08aeeaef0	3	2020-05-13 19:20:37.569	2020-05-13 19:20:37.569	e11046b5-dfcf-4343-aff8-651670cc783f	c94f6e3a-f9d0-4347-9786-46c439664e99	ff924716-cecf-468f-91b2-ae0e10b8c394
56d84d17-e324-4097-9272-232bb831a7dc	2	2020-05-13 19:20:37.572	2020-05-13 19:20:37.572	a19f05bd-8172-4994-b991-fc717b0e46f2	1836784b-ed08-44b7-a898-8cf3f5119fe4	ff924716-cecf-468f-91b2-ae0e10b8c394
a087daaa-1c02-4998-ba3b-4db6250f6165	2	2020-05-13 19:20:37.575	2020-05-13 19:20:37.575	2d4fd180-ef23-4134-8014-be2ec8ed1ec5	4ddd151e-751c-43e3-9f07-794b1003de70	ff924716-cecf-468f-91b2-ae0e10b8c394
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

COPY public.timesheet (id, "startDate", "endDate", "userId", "dateCreated", "dateModified", "createdUserId", "modifiedUserId", "hoursAccured", "batchEntryComments", "projectRfxId", "projectId", "mouId", is_locked, "amountBilled") FROM stdin;
445c1913-b9e0-433c-9fe2-3b02b45a0d42	2020-04-20	2020-04-26	c246f349-bb5e-4309-861b-706bc6b232c1	2020-04-29 18:34:53.132	2020-04-29 18:34:53.233	c246f349-bb5e-4309-861b-706bc6b232c1	\N	7	\N	\N	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	19	f	0
5fb14764-9895-47c1-8d62-9f5853847dee	2020-04-27	2020-05-03	c246f349-bb5e-4309-861b-706bc6b232c1	2020-04-29 18:37:30.237	2020-04-29 18:37:30.296	c246f349-bb5e-4309-861b-706bc6b232c1	\N	4	\N	\N	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	19	f	0
64084079-34e6-40b4-8707-bd418e77eb89	2020-04-13	2020-04-19	c246f349-bb5e-4309-861b-706bc6b232c1	2020-04-29 18:30:53.07	2020-04-29 18:42:08.436	c246f349-bb5e-4309-861b-706bc6b232c1	\N	1.5	\N	\N	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	19	f	0
d1efb866-8d5d-4eee-b59c-31ce6ab92139	2020-04-13	2020-04-19	c246f349-bb5e-4309-861b-706bc6b232c1	2020-04-29 18:42:08.446	2020-04-29 18:42:08.534	c246f349-bb5e-4309-861b-706bc6b232c1	\N	2.5	\N	\N	4c70dd71-1938-4a01-a86b-ced42b12c11e	3	f	0
6227430a-24fe-4190-90f6-53b107211e77	2020-04-20	2020-04-26	2d99034e-ba45-4768-87e1-e76c1a72d5eb	2020-04-24 18:47:41.812	2020-04-24 18:47:41.881	2d99034e-ba45-4768-87e1-e76c1a72d5eb	\N	2	\N	80c4322d-8f5f-4fc7-b81e-b8052137c6b3	cf7c4e65-b95a-4fea-aa49-96acb87290b2	29	\N	\N
03aaae5e-c740-4138-9387-e1d8aab1c733	2020-04-20	2020-04-26	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	2020-04-29 21:07:19.176	2020-04-29 21:09:02.777	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	\N	6.5	\N	\N	2c933486-0a9b-40de-adc9-eaa9319a16f2	8	f	0
be4444c9-57ba-4c6c-b498-2f7aafeb2ac1	2020-03-30	2020-04-05	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	2020-04-29 21:15:12.795	2020-04-29 21:15:13.211	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	\N	7.5	\N	fb408cd3-05dd-4977-a1e7-47cee6034c09	2c933486-0a9b-40de-adc9-eaa9319a16f2	8	f	0
b2df5ac6-085a-4002-970c-96e847d0d7a2	2020-04-20	2020-04-26	ff341b3b-6c79-421c-951a-0e199f8693d8	2020-04-28 19:55:43.894	2020-04-28 19:57:06.837	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	0.170000000000000012	\N	21868485-7af3-48c1-bc8d-1a146e052b0d	d930683b-68e0-44f5-a31d-398815e32909	1	f	0
4482453b-fa8b-4cd9-8370-6e4513971938	2020-04-06	2020-04-12	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	2020-04-29 21:17:25.038	2020-04-29 21:17:25.281	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	\N	12.5	\N	fb408cd3-05dd-4977-a1e7-47cee6034c09	2c933486-0a9b-40de-adc9-eaa9319a16f2	8	f	0
b80cb1d3-e9b6-40dc-b4ab-084281428995	2020-04-13	2020-04-19	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	2020-04-29 21:19:02.337	2020-04-29 21:19:02.647	366a7a26-cf43-4a4b-9d3a-2b6a5e541f6a	\N	8.5	\N	fb408cd3-05dd-4977-a1e7-47cee6034c09	2c933486-0a9b-40de-adc9-eaa9319a16f2	8	f	0
6f7c506a-46d9-4438-8630-ad4a9e52b0df	2020-03-30	2020-04-05	228e25cb-a091-4c40-9c60-751c784d8852	2020-04-29 17:32:37.352	2020-04-29 17:45:44.405	228e25cb-a091-4c40-9c60-751c784d8852	\N	1	\N	\N	0da1c7d6-5b71-4232-8c20-ed2e52d08091	27	f	0
31c9e3ff-9a78-4b78-a351-c94675ef21d5	2020-03-30	2020-04-05	228e25cb-a091-4c40-9c60-751c784d8852	2020-04-29 17:45:44.441	2020-04-29 17:45:45.185	228e25cb-a091-4c40-9c60-751c784d8852	\N	2	\N	\N	2c933486-0a9b-40de-adc9-eaa9319a16f2	8	f	0
f5d74c0a-60ec-41c9-ad17-df2d7df2b526	2020-04-27	2020-05-03	ff341b3b-6c79-421c-951a-0e199f8693d8	2020-04-30 16:59:55.926	2020-04-30 16:59:56.929	ff341b3b-6c79-421c-951a-0e199f8693d8	\N	0.330000000000000016	\N	defede2e-0492-468f-9da8-af187cfc8f22	6680eec1-85c6-446c-86ef-677db7908c1a	11	f	0
4dcc1e94-7236-45d2-ab45-3f85c63a6537	2020-04-06	2020-04-12	228e25cb-a091-4c40-9c60-751c784d8852	2020-04-29 17:33:33.23	2020-04-29 17:47:24.278	228e25cb-a091-4c40-9c60-751c784d8852	\N	5	\N	\N	0da1c7d6-5b71-4232-8c20-ed2e52d08091	27	f	0
11945bf3-4f55-47af-b59f-0701edb5f55a	2020-04-06	2020-04-12	228e25cb-a091-4c40-9c60-751c784d8852	2020-04-29 17:46:24.897	2020-04-29 17:47:24.42	228e25cb-a091-4c40-9c60-751c784d8852	\N	2.25	\N	\N	2c933486-0a9b-40de-adc9-eaa9319a16f2	8	f	0
5696663e-e173-497e-9e06-b27c7d0fa352	2020-04-13	2020-04-19	228e25cb-a091-4c40-9c60-751c784d8852	2020-04-29 17:48:51.592	2020-04-29 17:48:51.872	228e25cb-a091-4c40-9c60-751c784d8852	\N	2	\N	\N	2c933486-0a9b-40de-adc9-eaa9319a16f2	8	f	0
f6d73cca-001d-416e-8548-8315466c2c94	2020-04-27	2020-05-03	a2127b12-c103-4722-89e3-cbcc8a544245	2020-05-01 03:20:54.954	2020-05-01 03:20:55.191	a2127b12-c103-4722-89e3-cbcc8a544245	\N	1	\N	\N	4053e10e-3d25-4697-9be6-d4bd5f149981	3	t	125
7e6afcaf-520c-44b1-b59f-1afa2be95a4c	2020-04-27	2020-05-03	228e25cb-a091-4c40-9c60-751c784d8852	2020-04-29 17:52:57.942	2020-04-29 17:52:58.128	228e25cb-a091-4c40-9c60-751c784d8852	\N	2.5	\N	\N	2c933486-0a9b-40de-adc9-eaa9319a16f2	8	f	0
2baada75-1401-472a-94cf-fe02d2681265	2020-04-06	2020-04-12	c246f349-bb5e-4309-861b-706bc6b232c1	2020-04-29 18:28:41.635	2020-04-29 18:28:41.712	c246f349-bb5e-4309-861b-706bc6b232c1	\N	3	\N	\N	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	19	f	0
daf3ad36-0736-40d0-8501-047eb9fa48c0	2020-04-20	2020-04-26	228e25cb-a091-4c40-9c60-751c784d8852	2020-04-29 17:34:21.313	2020-04-30 21:40:19.505	228e25cb-a091-4c40-9c60-751c784d8852	\N	2.5	\N	\N	0da1c7d6-5b71-4232-8c20-ed2e52d08091	27	f	0
1a131666-6032-4172-b055-bfa2fd43f73a	2020-04-20	2020-04-26	228e25cb-a091-4c40-9c60-751c784d8852	2020-04-29 17:51:45.09	2020-04-30 21:40:19.992	228e25cb-a091-4c40-9c60-751c784d8852	\N	5.5	\N	\N	2c933486-0a9b-40de-adc9-eaa9319a16f2	8	f	0
0228d554-e45f-48ea-9015-ae16efd0b692	2020-04-20	2020-04-26	228e25cb-a091-4c40-9c60-751c784d8852	2020-04-30 21:40:20.125	2020-04-30 21:40:20.764	228e25cb-a091-4c40-9c60-751c784d8852	\N	2	\N	\N	fa38f829-2342-4781-a9af-89e078a42dd9	32	f	0
ea6d9eaf-1238-4e1a-8a11-37b7b5c083e9	2020-03-30	2020-04-05	a2127b12-c103-4722-89e3-cbcc8a544245	2020-05-01 02:21:49.089	2020-05-01 02:21:49.246	a2127b12-c103-4722-89e3-cbcc8a544245	\N	2	\N	\N	4053e10e-3d25-4697-9be6-d4bd5f149981	3	f	0
41ce4e7b-b85d-4d7f-85eb-d85d60c2f31c	2020-04-06	2020-04-12	b9a782bd-39b5-4697-9a4a-9b62737876e2	2020-05-01 02:22:41.19	2020-05-01 02:22:41.411	b9a782bd-39b5-4697-9a4a-9b62737876e2	\N	5	\N	bc1b974d-e73c-4992-8a57-b9eaeed7b66e	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	19	f	0
6b606130-bab4-4fb7-8f01-aabe1193e417	2020-04-13	2020-04-19	b9a782bd-39b5-4697-9a4a-9b62737876e2	2020-05-01 02:26:52.116	2020-05-01 02:26:52.605	b9a782bd-39b5-4697-9a4a-9b62737876e2	\N	5	\N	bc1b974d-e73c-4992-8a57-b9eaeed7b66e	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	19	f	0
8cd813cf-e881-4ae2-bb4e-6171bc9b0dd1	2020-04-20	2020-04-26	b9a782bd-39b5-4697-9a4a-9b62737876e2	2020-05-01 02:32:59.985	2020-05-01 02:33:00.952	b9a782bd-39b5-4697-9a4a-9b62737876e2	\N	7	\N	bc1b974d-e73c-4992-8a57-b9eaeed7b66e	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	19	f	0
42eb31dd-275f-4ee9-9733-79bafbdb0a2e	2020-04-27	2020-05-03	b9a782bd-39b5-4697-9a4a-9b62737876e2	2020-05-01 02:34:46.924	2020-05-01 02:34:47.25	b9a782bd-39b5-4697-9a4a-9b62737876e2	\N	2	\N	bc1b974d-e73c-4992-8a57-b9eaeed7b66e	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	19	f	0
65dbc4df-f87a-4546-b872-63133b12dba1	2020-04-20	2020-04-26	3778745c-f1c5-4013-ae07-75bd4798ea32	2020-05-01 20:53:42.667	2020-05-01 20:53:42.723	3778745c-f1c5-4013-ae07-75bd4798ea32	\N	2	\N	\N	8959e597-c09f-46b6-a515-b3ce076a9a94	22	f	0
892d22d5-911a-41fe-94a7-38cc69fdbdcf	2020-04-06	2020-04-12	a2127b12-c103-4722-89e3-cbcc8a544245	2020-05-01 02:46:36.781	2020-05-01 10:24:15.546	a2127b12-c103-4722-89e3-cbcc8a544245	\N	5.20000000000000018	\N	\N	4053e10e-3d25-4697-9be6-d4bd5f149981	3	t	645
6eb78c9f-7293-426e-9005-12bd5861ee06	2020-04-13	2020-04-19	3778745c-f1c5-4013-ae07-75bd4798ea32	2020-05-01 20:54:49.876	2020-05-01 20:54:49.94	3778745c-f1c5-4013-ae07-75bd4798ea32	\N	2.5	\N	\N	8959e597-c09f-46b6-a515-b3ce076a9a94	22	f	0
d99be05e-2bce-4dab-bc00-f67dec8f7ae6	2020-04-06	2020-04-12	3778745c-f1c5-4013-ae07-75bd4798ea32	2020-05-01 20:55:37.922	2020-05-01 20:55:37.976	3778745c-f1c5-4013-ae07-75bd4798ea32	\N	2	\N	\N	8959e597-c09f-46b6-a515-b3ce076a9a94	22	f	0
b251ed50-6279-43e4-8323-b9f887e29cd0	2020-04-20	2020-04-26	a2127b12-c103-4722-89e3-cbcc8a544245	2020-05-01 03:13:47.976	2020-05-01 10:40:39.617	a2127b12-c103-4722-89e3-cbcc8a544245	\N	7.25	\N	\N	4053e10e-3d25-4697-9be6-d4bd5f149981	3	t	1370
9aada634-18ec-404e-b941-b75a5481fd4e	2020-04-06	2020-04-12	a2127b12-c103-4722-89e3-cbcc8a544245	2020-05-01 10:24:15.557	2020-05-01 10:24:15.715	a2127b12-c103-4722-89e3-cbcc8a544245	\N	1.5	\N	\N	e27823b2-ee5a-40ee-bd78-1111c18a6fb7	31	f	0
2c77051a-6dc4-46b8-a2be-c7ccacf72253	2020-04-13	2020-04-19	f6b65221-f597-488b-aaa8-bed90aacfaf8	2020-05-01 22:23:25.287	2020-05-01 22:23:25.443	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	2.5	\N	d862a15b-c684-4318-8a0a-006f186dadab	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	35	t	420
7f76bf0d-6dd6-4fc2-900d-94aabda3f77a	2020-04-20	2020-04-26	a2127b12-c103-4722-89e3-cbcc8a544245	2020-05-01 10:40:39.626	2020-05-01 10:40:39.702	a2127b12-c103-4722-89e3-cbcc8a544245	\N	3	\N	\N	e27823b2-ee5a-40ee-bd78-1111c18a6fb7	31	f	0
a6034a7e-2a66-4a94-b1fd-3d389bafec53	2020-03-30	2020-04-05	b9a782bd-39b5-4697-9a4a-9b62737876e2	2020-05-01 02:18:52.427	2020-05-01 18:51:43.138	b9a782bd-39b5-4697-9a4a-9b62737876e2	\N	7.5	\N	ba8e4f8a-4208-45cc-a17d-4b84bd9cf80b	0ab8a2d6-1dc6-46c7-8deb-70b14f92662f	19	f	0
25d197fb-5529-47b6-a4cd-824aa765a37a	2020-04-27	2020-05-03	3778745c-f1c5-4013-ae07-75bd4798ea32	2020-05-01 20:51:08.228	2020-05-01 20:51:08.304	3778745c-f1c5-4013-ae07-75bd4798ea32	\N	3	\N	\N	8959e597-c09f-46b6-a515-b3ce076a9a94	22	f	0
e89f92e9-e765-4049-9f6f-a999c9dc3e02	2020-03-30	2020-04-05	3778745c-f1c5-4013-ae07-75bd4798ea32	2020-05-01 20:56:18.933	2020-05-01 20:56:18.988	3778745c-f1c5-4013-ae07-75bd4798ea32	\N	1.5	\N	\N	8959e597-c09f-46b6-a515-b3ce076a9a94	22	f	0
d0a90e80-fbca-4486-9417-c0dc068c0825	2020-04-27	2020-05-03	f6b65221-f597-488b-aaa8-bed90aacfaf8	2020-05-01 21:49:57.935	2020-05-01 21:49:58.041	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	0.5	\N	95f6585d-d840-49e3-95db-5d4d1b86ab40	4c70dd71-1938-4a01-a86b-ced42b12c11e	3	f	0
6b58746a-124d-4c8a-b9a1-fdb6c5f27374	2020-04-20	2020-04-26	f6b65221-f597-488b-aaa8-bed90aacfaf8	2020-05-01 22:24:28.635	2020-05-01 22:24:28.786	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	5	\N	d862a15b-c684-4318-8a0a-006f186dadab	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	35	t	1020
b88ccd27-1b78-4a22-954b-b93a7ac0e9ab	2020-04-20	2020-04-26	f6b65221-f597-488b-aaa8-bed90aacfaf8	2020-05-01 21:59:40.423	2020-05-01 22:24:28.606	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	0.5	\N	37157ef3-fe9d-47c4-b419-572e94abfb67	12b59b16-e92d-471d-b872-e793e0813979	34	f	0
50da1473-2d7a-4922-9f57-78a513930714	2020-03-30	2020-04-05	f6b65221-f597-488b-aaa8-bed90aacfaf8	2020-05-01 22:22:15.482	2020-05-01 22:22:15.631	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	1.5	\N	d862a15b-c684-4318-8a0a-006f186dadab	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	35	f	0
56c544ce-1713-431a-a7ac-49bb4bf0d32b	2020-04-13	2020-04-19	f6b65221-f597-488b-aaa8-bed90aacfaf8	2020-05-01 21:59:23.901	2020-05-01 22:23:25.278	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	1	\N	37157ef3-fe9d-47c4-b419-572e94abfb67	12b59b16-e92d-471d-b872-e793e0813979	34	f	0
0b6d5554-79bc-44e3-9616-e70fa33c8e7f	2020-04-20	2020-04-26	f6b65221-f597-488b-aaa8-bed90aacfaf8	2020-05-01 21:49:12.25	2020-05-01 22:24:28.421	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	5.5	\N	95f6585d-d840-49e3-95db-5d4d1b86ab40	4c70dd71-1938-4a01-a86b-ced42b12c11e	3	f	0
b2aadc11-14b0-4fe2-93a3-3caf5de177a8	2020-03-30	2020-04-05	3e9a3591-d6b2-4b46-a426-5e0872553673	2020-05-02 18:54:06.774	2020-05-02 18:54:06.86	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	6	\N	4562f639-7012-4b1c-ab3d-a740c8dea828	2d2796cc-4950-4811-abf9-cebd2d9d7f01	2	f	0
60155bee-49ed-42dc-8d93-d84c89cf72af	2020-04-06	2020-04-12	3e9a3591-d6b2-4b46-a426-5e0872553673	2020-05-02 18:56:22.837	2020-05-02 18:56:22.944	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	0.5	\N	4562f639-7012-4b1c-ab3d-a740c8dea828	2d2796cc-4950-4811-abf9-cebd2d9d7f01	2	f	0
bfa2f49b-0a7b-476c-8c69-e8fbb17b7e97	2020-04-13	2020-04-19	3e9a3591-d6b2-4b46-a426-5e0872553673	2020-05-02 18:58:39.844	2020-05-02 18:58:39.904	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	3	\N	4562f639-7012-4b1c-ab3d-a740c8dea828	2d2796cc-4950-4811-abf9-cebd2d9d7f01	2	f	0
1a18982b-3172-4ccc-b33c-38fad45d5444	2020-04-20	2020-04-26	3e9a3591-d6b2-4b46-a426-5e0872553673	2020-05-02 19:00:57.296	2020-05-02 19:00:57.399	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	4	\N	4562f639-7012-4b1c-ab3d-a740c8dea828	2d2796cc-4950-4811-abf9-cebd2d9d7f01	2	f	0
f9181b27-a207-49c9-a716-cc1814886088	2020-04-13	2020-04-19	a2127b12-c103-4722-89e3-cbcc8a544245	2020-05-01 02:53:18.648	2020-05-01 02:53:18.787	a2127b12-c103-4722-89e3-cbcc8a544245	\N	0.25	\N	\N	4053e10e-3d25-4697-9be6-d4bd5f149981	3	t	25
8fd2c50c-8510-4548-abea-7f7003368eab	2020-04-27	2020-05-03	3e9a3591-d6b2-4b46-a426-5e0872553673	2020-05-02 19:04:19.307	2020-05-02 19:04:19.388	3e9a3591-d6b2-4b46-a426-5e0872553673	\N	6	\N	4562f639-7012-4b1c-ab3d-a740c8dea828	2d2796cc-4950-4811-abf9-cebd2d9d7f01	2	f	0
397a2dd2-2985-48fe-b982-eed0f7c17764	2020-04-06	2020-04-12	f6b65221-f597-488b-aaa8-bed90aacfaf8	2020-05-01 22:22:59.331	2020-05-01 22:22:59.445	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	1	\N	d862a15b-c684-4318-8a0a-006f186dadab	be2b9ad7-8ce2-4c68-837f-c6c3dfa2398e	35	t	120
5d82bd4c-1f91-427f-9a2a-8c766b858891	2020-03-30	2020-04-05	8880f74e-e2e5-4646-bd80-b285d653d0c2	2020-05-05 17:26:21.989	2020-05-05 17:28:16.876	8880f74e-e2e5-4646-bd80-b285d653d0c2	\N	1	\N	\N	a9ef1e50-f0e3-4d64-a1df-c1187bf34b2f	36	f	0
4cef45e4-466a-4dab-975b-53d6bf99552b	2020-04-27	2020-05-03	8880f74e-e2e5-4646-bd80-b285d653d0c2	2020-05-05 17:32:46.999	2020-05-05 17:32:47.271	8880f74e-e2e5-4646-bd80-b285d653d0c2	\N	8.25	\N	\N	a9ef1e50-f0e3-4d64-a1df-c1187bf34b2f	36	f	0
9920c8f9-6193-476d-88c4-3ffa4f9b4a94	2020-05-04	2020-05-10	f6b65221-f597-488b-aaa8-bed90aacfaf8	2020-05-06 21:13:33.754	2020-05-06 21:13:33.867	f6b65221-f597-488b-aaa8-bed90aacfaf8	\N	2	\N	95f6585d-d840-49e3-95db-5d4d1b86ab40	4c70dd71-1938-4a01-a86b-ced42b12c11e	3	f	0
5d282e13-db8d-4fad-9ebd-73b56f80e0fd	2020-05-04	2020-05-10	8880f74e-e2e5-4646-bd80-b285d653d0c2	2020-05-07 18:19:14.068	2020-05-07 18:19:14.147	8880f74e-e2e5-4646-bd80-b285d653d0c2	\N	2	\N	\N	a9ef1e50-f0e3-4d64-a1df-c1187bf34b2f	36	f	0
6c72b31c-6ffd-4618-8c78-fad1531f6eb6	2020-05-04	2020-05-10	3778745c-f1c5-4013-ae07-75bd4798ea32	2020-05-08 17:15:14.004	2020-05-08 17:15:14.077	3778745c-f1c5-4013-ae07-75bd4798ea32	\N	5	\N	\N	8959e597-c09f-46b6-a515-b3ce076a9a94	22	f	0
db3e1c21-f328-40f4-bc90-6cbb5e676f08	2020-05-11	2020-05-17	13669c48-73ee-492e-b1b5-6a168f213d8a	2020-05-12 23:04:52.574	2020-05-12 23:04:52.632	13669c48-73ee-492e-b1b5-6a168f213d8a	\N	2	\N	0b2cc1c5-7abd-45aa-9cd2-c60ffa9dc4f5	7705fd59-37b6-4d8b-8f8d-fb1329569f8a	40	f	0
\.


--
-- Data for Name: timesheet_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.timesheet_entry (id, "hoursBillable", "commentsBillable", "hoursUnBillable", "commentsUnBillable", "expenseCategory", "expenseAmount", "expenseComment", "revenueAmount", "revenueComment", "entryDate", "dateCreated", "dateModified", "timesheetId", "revenueHours") FROM stdin;
883ff850-fd98-40f1-98e8-ffca337e8592	0		0			0		0		2020-04-20	2020-04-28 19:55:43.963	2020-04-28 19:57:06.78	b2df5ac6-085a-4002-970c-96e847d0d7a2	\N
d0a729eb-7c2e-4899-b5ed-8d81082084ac	0.170000000000000012	emails	0			0		0		2020-04-21	2020-04-28 19:55:43.971	2020-04-28 19:57:06.8	b2df5ac6-085a-4002-970c-96e847d0d7a2	\N
fce4fbc9-a87d-45a1-bb2c-be1d37d0ec4a	0		0			0		0		2020-04-22	2020-04-28 19:55:43.982	2020-04-28 19:57:06.806	b2df5ac6-085a-4002-970c-96e847d0d7a2	\N
467b5527-9f6d-4b50-8511-735f6ec29ade	0		0			0		0		2020-04-23	2020-04-28 19:55:43.988	2020-04-28 19:57:06.812	b2df5ac6-085a-4002-970c-96e847d0d7a2	\N
065f28ff-a9ff-4146-928d-3782b7833ce0	0		0			0		0		2020-04-24	2020-04-28 19:55:43.994	2020-04-28 19:57:06.819	b2df5ac6-085a-4002-970c-96e847d0d7a2	\N
9f41127d-5b42-4504-bd12-591e4f1b6b66	0		0			0		0		2020-04-25	2020-04-28 19:55:44.001	2020-04-28 19:57:06.825	b2df5ac6-085a-4002-970c-96e847d0d7a2	\N
e8c49089-e018-432a-ba1e-6befde9c5bb3	0		0			0		0		2020-04-26	2020-04-28 19:55:44.008	2020-04-28 19:57:06.831	b2df5ac6-085a-4002-970c-96e847d0d7a2	\N
bbe40f03-ec8e-401e-bb00-e769ed80b69a	0		0			0		0		2020-03-30	2020-04-29 17:32:37.376	2020-04-29 17:45:44.047	6f7c506a-46d9-4438-8630-ad4a9e52b0df	\N
eb41331c-4f73-45d4-bbfe-5e1dc0e93061	0		0			0		0		2020-03-31	2020-04-29 17:32:37.386	2020-04-29 17:45:44.068	6f7c506a-46d9-4438-8630-ad4a9e52b0df	\N
849630c3-de3f-48e5-bf5c-55e2359b23c7	0		0			0		0		2020-04-01	2020-04-29 17:32:37.393	2020-04-29 17:45:44.13	6f7c506a-46d9-4438-8630-ad4a9e52b0df	\N
eab93a03-52d2-4803-9d3b-a2883ee853d5	0		0			0		0		2020-04-02	2020-04-29 17:32:37.398	2020-04-29 17:45:44.169	6f7c506a-46d9-4438-8630-ad4a9e52b0df	\N
8801d942-69c6-44a6-9520-3f15563c51e5	1	Meeting w/ project team and legal	0			0		0		2020-04-03	2020-04-29 17:32:37.404	2020-04-29 17:45:44.207	6f7c506a-46d9-4438-8630-ad4a9e52b0df	\N
a4beb7ee-9abe-4c3a-9776-91bc07360317	0		0			0		0		2020-04-04	2020-04-29 17:32:37.411	2020-04-29 17:45:44.242	6f7c506a-46d9-4438-8630-ad4a9e52b0df	\N
d82c919c-faab-4999-b8a2-ffef29e6f1dc	0		0			0		0		2020-04-05	2020-04-29 17:32:37.415	2020-04-29 17:45:44.267	6f7c506a-46d9-4438-8630-ad4a9e52b0df	\N
b819243a-f55b-47a4-a476-c59778c54f8e	0		0			0		0		2020-04-06	2020-04-29 17:33:33.257	2020-04-29 17:47:24.152	4dcc1e94-7236-45d2-ab45-3f85c63a6537	\N
60928a81-d64f-47eb-a771-03b050309750	0		0			0		0		2020-04-07	2020-04-29 17:33:33.264	2020-04-29 17:47:24.205	4dcc1e94-7236-45d2-ab45-3f85c63a6537	\N
1efff4f6-efea-474e-a9fc-71ae15a14d55	5	RFP work - April 6, 7 and 8th	0			0		0		2020-04-08	2020-04-29 17:33:33.294	2020-04-29 17:47:24.23	4dcc1e94-7236-45d2-ab45-3f85c63a6537	\N
a209296a-8488-4d4e-9e8e-985c2e9bbfe9	0		0			0		0		2020-04-09	2020-04-29 17:33:33.326	2020-04-29 17:47:24.237	4dcc1e94-7236-45d2-ab45-3f85c63a6537	\N
a96fdca8-fde7-4013-9f4b-acc3a6dbddf8	0		0			0		0		2020-04-10	2020-04-29 17:33:33.343	2020-04-29 17:47:24.247	4dcc1e94-7236-45d2-ab45-3f85c63a6537	\N
906cc74c-f641-4319-b6de-afb035207c85	0		0			0		0		2020-04-11	2020-04-29 17:33:33.38	2020-04-29 17:47:24.258	4dcc1e94-7236-45d2-ab45-3f85c63a6537	\N
a570f2b2-420a-4848-a90f-bb47dad65bb8	0		0			0		0		2020-04-12	2020-04-29 17:33:33.389	2020-04-29 17:47:24.27	4dcc1e94-7236-45d2-ab45-3f85c63a6537	\N
b3f243ce-1779-4148-ba63-c27b37b663b8	0		0			0		0		2020-04-20	2020-04-24 18:47:41.843	2020-04-24 18:47:41.843	6227430a-24fe-4190-90f6-53b107211e77	\N
7dbae235-d43e-4f46-bccb-e745490a4f51	0		0			0		0		2020-04-21	2020-04-24 18:47:41.851	2020-04-24 18:47:41.851	6227430a-24fe-4190-90f6-53b107211e77	\N
fff4d431-9eba-4697-a370-ea21285c27eb	0		0			0		0		2020-04-22	2020-04-24 18:47:41.855	2020-04-24 18:47:41.855	6227430a-24fe-4190-90f6-53b107211e77	\N
331f1c31-51b2-436d-8100-3191022c7990	0		0			0		0		2020-04-23	2020-04-24 18:47:41.859	2020-04-24 18:47:41.859	6227430a-24fe-4190-90f6-53b107211e77	\N
690310f0-1d4c-4377-9eec-b5d55a6a33b8	2	Review feedback from legal, edits to document.	0			0		0		2020-04-24	2020-04-24 18:47:41.863	2020-04-24 18:47:41.863	6227430a-24fe-4190-90f6-53b107211e77	\N
56c79c16-9295-4c68-974d-a224a0d749f7	0		0			0		0		2020-04-25	2020-04-24 18:47:41.868	2020-04-24 18:47:41.868	6227430a-24fe-4190-90f6-53b107211e77	\N
90e6be17-4a46-4d37-8b92-53a8d3e96765	0		0			0		0		2020-04-26	2020-04-24 18:47:41.872	2020-04-24 18:47:41.872	6227430a-24fe-4190-90f6-53b107211e77	\N
62e377cc-3f89-4fb4-a5de-0892ff964387	0		0			0		0		2020-03-30	2020-04-29 17:45:44.716	2020-04-29 17:45:44.716	31c9e3ff-9a78-4b78-a351-c94675ef21d5	\N
689c72eb-bdd4-4430-bf6a-afc43805cca4	0		0			0		0		2020-03-31	2020-04-29 17:45:44.764	2020-04-29 17:45:44.764	31c9e3ff-9a78-4b78-a351-c94675ef21d5	\N
537bc87e-4927-4d23-8b51-80c6f18c8f7e	2	Government of Alberta WaaS session	0			0		0		2020-04-01	2020-04-29 17:45:44.774	2020-04-29 17:45:44.774	31c9e3ff-9a78-4b78-a351-c94675ef21d5	\N
0d973ae2-7a29-4f47-8880-ecbe48dbe806	0		0			0		0		2020-04-02	2020-04-29 17:45:44.912	2020-04-29 17:45:44.912	31c9e3ff-9a78-4b78-a351-c94675ef21d5	\N
ce661943-857b-48bc-afc1-c72941cfff4d	0		0			0		0		2020-04-03	2020-04-29 17:45:44.917	2020-04-29 17:45:44.917	31c9e3ff-9a78-4b78-a351-c94675ef21d5	\N
ce017e6f-5e53-4779-9438-0ac29a0580e2	0		0			0		0		2020-04-04	2020-04-29 17:45:45.085	2020-04-29 17:45:45.085	31c9e3ff-9a78-4b78-a351-c94675ef21d5	\N
c5381184-5f5e-4afc-82d6-c79b90f8f6bb	0		0			0		0		2020-04-05	2020-04-29 17:45:45.098	2020-04-29 17:45:45.098	31c9e3ff-9a78-4b78-a351-c94675ef21d5	\N
5649da94-1460-49e4-9862-457c11b5a0e5	0		0			0		0		2020-04-06	2020-04-29 17:46:24.92	2020-04-29 17:47:24.29	11945bf3-4f55-47af-b59f-0701edb5f55a	\N
8a46450a-84d5-4474-91b5-593e98516037	0.25	VICO Sprint Review	0			0		0		2020-04-07	2020-04-29 17:46:24.956	2020-04-29 17:47:24.317	11945bf3-4f55-47af-b59f-0701edb5f55a	\N
686d7451-6445-4634-9cba-b589bd1b774d	1	Risk Register Review Meeting with Ami and Michael	0			0		0		2020-04-08	2020-04-29 17:46:24.96	2020-04-29 17:47:24.359	11945bf3-4f55-47af-b59f-0701edb5f55a	\N
84c983db-142b-436d-9f8b-ff2e6844f55a	1	Risk Register Review Meeting with Ami and Michael	0			0		0		2020-04-09	2020-04-29 17:46:24.969	2020-04-29 17:47:24.377	11945bf3-4f55-47af-b59f-0701edb5f55a	\N
5926cf9d-ccbd-4bf9-8804-500b8aa99fa4	0		0			0		0		2020-04-10	2020-04-29 17:46:24.978	2020-04-29 17:47:24.386	11945bf3-4f55-47af-b59f-0701edb5f55a	\N
77c8a992-9b02-433e-9282-82572ed39100	0		0			0		0		2020-04-11	2020-04-29 17:46:24.988	2020-04-29 17:47:24.395	11945bf3-4f55-47af-b59f-0701edb5f55a	\N
f4bf6b71-974e-42b4-89cb-dde4d7910c18	0		0			0		0		2020-04-12	2020-04-29 17:46:24.999	2020-04-29 17:47:24.406	11945bf3-4f55-47af-b59f-0701edb5f55a	\N
bb94b911-e961-442f-99e8-fab279a0f43e	0		0			0		0		2020-04-13	2020-04-29 17:48:51.706	2020-04-29 17:48:51.706	5696663e-e173-497e-9e06-b27c7d0fa352	\N
2618bcea-dc86-4614-a4bd-2ffa2187559d	2	Risk Register Work - April 14th	0			0		0		2020-04-14	2020-04-29 17:48:51.729	2020-04-29 17:48:51.729	5696663e-e173-497e-9e06-b27c7d0fa352	\N
a3b2e56d-c6a3-463a-aa35-5def242e39d2	0		0			0		0		2020-04-15	2020-04-29 17:48:51.754	2020-04-29 17:48:51.754	5696663e-e173-497e-9e06-b27c7d0fa352	\N
d974a5dd-6b3d-43fe-a64f-5c87061099ad	0		0			0		0		2020-04-16	2020-04-29 17:48:51.835	2020-04-29 17:48:51.835	5696663e-e173-497e-9e06-b27c7d0fa352	\N
949ebed9-7195-43d7-9f18-0181c2eb1b1b	0		0			0		0		2020-04-17	2020-04-29 17:48:51.853	2020-04-29 17:48:51.853	5696663e-e173-497e-9e06-b27c7d0fa352	\N
e4a6d7bd-9e51-4708-9ae6-29929ad23f65	0		0			0		0		2020-04-18	2020-04-29 17:48:51.857	2020-04-29 17:48:51.857	5696663e-e173-497e-9e06-b27c7d0fa352	\N
2141dc5f-8873-496e-9e8c-b82c63529081	0		0			0		0		2020-04-19	2020-04-29 17:48:51.862	2020-04-29 17:48:51.862	5696663e-e173-497e-9e06-b27c7d0fa352	\N
907d100f-5349-4dbc-a28d-8aa2e9c1aae8	0		0			0		0		2020-04-22	2020-04-29 17:51:45.198	2020-04-30 21:40:19.706	1a131666-6032-4172-b055-bfa2fd43f73a	\N
8e67b366-65c8-4e7f-9908-04b04958a925	1	WTSPP Expanded Project Team Meeting	0			0		0		2020-04-23	2020-04-29 17:51:45.211	2020-04-30 21:40:19.746	1a131666-6032-4172-b055-bfa2fd43f73a	\N
7aa0f35e-51ea-4cce-be4e-12d086714be4	1.5	Risk Register Work	0			0		0		2020-04-24	2020-04-29 17:51:45.235	2020-04-30 21:40:19.812	1a131666-6032-4172-b055-bfa2fd43f73a	\N
e6db2f3f-1f4f-49a6-8752-e79bd57c77f2	0		0			0		0		2020-04-25	2020-04-29 17:51:45.241	2020-04-30 21:40:19.825	1a131666-6032-4172-b055-bfa2fd43f73a	\N
952e9252-737c-4004-b9b6-53ba6abd509c	0		0			0		0		2020-04-26	2020-04-29 17:51:45.247	2020-04-30 21:40:19.857	1a131666-6032-4172-b055-bfa2fd43f73a	\N
9875b7a0-1e7e-44eb-96dc-91cf8052ffb1	0		0			0		0		2020-04-27	2020-04-29 17:52:57.976	2020-04-29 17:52:57.976	7e6afcaf-520c-44b1-b59f-1afa2be95a4c	\N
dec816f3-3034-41c3-be71-42c99ef77535	0.5	Weekly Project Plan Activity and Status Update	0			0		0		2020-04-28	2020-04-29 17:52:58.013	2020-04-29 17:52:58.013	7e6afcaf-520c-44b1-b59f-1afa2be95a4c	\N
5d5e3251-e3d2-4982-bdd8-d485ffd3dbfe	2	CSA Meeting Preparation and Slide Deck Work - For all of April	0			0		0		2020-04-29	2020-04-29 17:52:58.053	2020-04-29 17:52:58.053	7e6afcaf-520c-44b1-b59f-1afa2be95a4c	\N
b16fb594-c9fb-4438-bdb9-8069f2870ad3	0		0			0		0		2020-04-30	2020-04-29 17:52:58.1	2020-04-29 17:52:58.1	7e6afcaf-520c-44b1-b59f-1afa2be95a4c	\N
15268f05-dcbe-43f2-99d3-ec2a899ad849	0		0			0		0		2020-05-01	2020-04-29 17:52:58.107	2020-04-29 17:52:58.107	7e6afcaf-520c-44b1-b59f-1afa2be95a4c	\N
2ae8f26d-17d7-45d6-b73d-3b26b31ee6fe	0		0			0		0		2020-05-02	2020-04-29 17:52:58.113	2020-04-29 17:52:58.113	7e6afcaf-520c-44b1-b59f-1afa2be95a4c	\N
bb065e9b-67c3-48d2-8d03-1a359ac1a46e	2.5	RFP Work - April 20	0			0		0		2020-04-20	2020-04-29 17:34:21.342	2020-04-30 21:40:18.769	daf3ad36-0736-40d0-8501-047eb9fa48c0	\N
c6cb3407-bbdd-40a1-bb07-a76f8a70f26a	0		0			0		0		2020-04-21	2020-04-29 17:34:21.397	2020-04-30 21:40:18.816	daf3ad36-0736-40d0-8501-047eb9fa48c0	\N
04abba11-1cd0-4b1d-b5b2-e08acca22f91	0		0			0		0		2020-04-22	2020-04-29 17:34:21.401	2020-04-30 21:40:18.854	daf3ad36-0736-40d0-8501-047eb9fa48c0	\N
7f1c48e6-f031-4e88-8f36-579957bf1d30	0		0			0		0		2020-04-23	2020-04-29 17:34:21.423	2020-04-30 21:40:18.922	daf3ad36-0736-40d0-8501-047eb9fa48c0	\N
bc5af2bc-ca43-4efc-93e9-be02e5f24a64	0		0			0		0		2020-04-24	2020-04-29 17:34:21.441	2020-04-30 21:40:18.945	daf3ad36-0736-40d0-8501-047eb9fa48c0	\N
f55ff2b8-f559-4d35-be49-7fbea21eab61	0		0			0		0		2020-04-25	2020-04-29 17:34:21.472	2020-04-30 21:40:19.02	daf3ad36-0736-40d0-8501-047eb9fa48c0	\N
5a8d4d87-84bc-4220-973a-de2b15c162cb	0		0			0		0		2020-04-26	2020-04-29 17:34:21.478	2020-04-30 21:40:19.463	daf3ad36-0736-40d0-8501-047eb9fa48c0	\N
d8323a3f-856a-4a38-a1d5-cd92782cde50	0		0			0		0		2020-04-20	2020-04-29 17:51:45.179	2020-04-30 21:40:19.599	1a131666-6032-4172-b055-bfa2fd43f73a	\N
120e52de-0276-4dc8-8a5b-4a78c1afbf81	3	Risk Register Work - April 21st (2.5) AND Project Handover Meeting (0.5)	0			0		0		2020-04-21	2020-04-29 17:51:45.191	2020-04-30 21:40:19.679	1a131666-6032-4172-b055-bfa2fd43f73a	\N
89193a46-0317-4ba0-9492-967991887496	0		0			0		0		2020-05-03	2020-04-29 17:52:58.119	2020-04-29 17:52:58.119	7e6afcaf-520c-44b1-b59f-1afa2be95a4c	\N
09b50eb9-fe9a-4a8b-bb59-44f265db2dd6	0		0			0		0		2020-04-06	2020-04-29 18:28:41.666	2020-04-29 18:28:41.666	2baada75-1401-472a-94cf-fe02d2681265	\N
05916e17-80eb-4476-831c-cb50911f377c	0		0			0		0		2020-04-07	2020-04-29 18:28:41.677	2020-04-29 18:28:41.677	2baada75-1401-472a-94cf-fe02d2681265	\N
bf80917f-ec1a-44b9-aef4-4f3085f3cdad	0		0			0		0		2020-04-08	2020-04-29 18:28:41.682	2020-04-29 18:28:41.682	2baada75-1401-472a-94cf-fe02d2681265	\N
56c9103d-4753-428b-afd3-524dab55141d	3	Completed Mandatory Evaluations for First Aid	0			0		0		2020-04-09	2020-04-29 18:28:41.687	2020-04-29 18:28:41.687	2baada75-1401-472a-94cf-fe02d2681265	\N
8499960d-42f2-4941-ba11-c06430dcbf29	0		0			0		0		2020-04-10	2020-04-29 18:28:41.693	2020-04-29 18:28:41.693	2baada75-1401-472a-94cf-fe02d2681265	\N
0af732ca-3174-48a6-a10e-c61c40e1e683	0		0			0		0		2020-04-11	2020-04-29 18:28:41.698	2020-04-29 18:28:41.698	2baada75-1401-472a-94cf-fe02d2681265	\N
e13293f6-496a-4a59-84b1-fb8b1f804fda	0		0			0		0		2020-04-12	2020-04-29 18:28:41.703	2020-04-29 18:28:41.703	2baada75-1401-472a-94cf-fe02d2681265	\N
85f5ea9c-1b05-4ce1-94d1-7e6f211baa7e	3	FA - Consensus	0			0		0		2020-04-20	2020-04-29 18:34:53.162	2020-04-29 18:34:53.162	445c1913-b9e0-433c-9fe2-3b02b45a0d42	\N
611c6e44-2598-4185-8faa-80b6f59d0a7e	2	Prepared Results and list of BLs	0			0		0		2020-04-21	2020-04-29 18:34:53.169	2020-04-29 18:34:53.169	445c1913-b9e0-433c-9fe2-3b02b45a0d42	\N
09e7cf10-dba5-45a1-a94c-b64911aa7747	0		0			0		0		2020-04-22	2020-04-29 18:34:53.173	2020-04-29 18:34:53.173	445c1913-b9e0-433c-9fe2-3b02b45a0d42	\N
06d8a627-cd12-4526-83e5-1e5dcff98774	2	Completed Mandatory evaluations for Security	0			0		0		2020-04-23	2020-04-29 18:34:53.178	2020-04-29 18:34:53.178	445c1913-b9e0-433c-9fe2-3b02b45a0d42	\N
2304bccb-9c1d-4253-991c-54114b6a1822	0		0			0		0		2020-04-24	2020-04-29 18:34:53.19	2020-04-29 18:34:53.19	445c1913-b9e0-433c-9fe2-3b02b45a0d42	\N
89c9301b-33ad-4e98-b8ac-93bff5207665	0		0			0		0		2020-04-25	2020-04-29 18:34:53.196	2020-04-29 18:34:53.196	445c1913-b9e0-433c-9fe2-3b02b45a0d42	\N
8ca30ba4-79e9-4c6f-a9a6-a71bda9aa006	0		0			0		0		2020-04-26	2020-04-29 18:34:53.224	2020-04-29 18:34:53.224	445c1913-b9e0-433c-9fe2-3b02b45a0d42	\N
8f4f3334-8305-4ff6-ab26-2448c4e8dc6f	2	Discussed unique identifier issue with FA team and worked on award letter	0			0		0		2020-04-27	2020-04-29 18:37:30.242	2020-04-29 18:37:30.242	5fb14764-9895-47c1-8d62-9f5853847dee	\N
64233599-ac5f-413e-86b7-a50a502443c9	1	Security Consensus and preparing Results	0			0		0		2020-04-28	2020-04-29 18:37:30.258	2020-04-29 18:37:30.258	5fb14764-9895-47c1-8d62-9f5853847dee	\N
ee0624c5-b87d-444c-ae6e-e4f80c321bf7	1	Ranked Contractors for FA	0			0		0		2020-04-29	2020-04-29 18:37:30.266	2020-04-29 18:37:30.266	5fb14764-9895-47c1-8d62-9f5853847dee	\N
b1dd585c-5299-4830-b4ce-51d5d5fdfaef	0		0			0		0		2020-04-30	2020-04-29 18:37:30.271	2020-04-29 18:37:30.271	5fb14764-9895-47c1-8d62-9f5853847dee	\N
ef8c2282-c861-4b63-9860-3abe68a8d972	0		0			0		0		2020-05-01	2020-04-29 18:37:30.277	2020-04-29 18:37:30.277	5fb14764-9895-47c1-8d62-9f5853847dee	\N
7165ba50-0407-4fc8-9996-703f623be3be	0		0			0		0		2020-05-02	2020-04-29 18:37:30.284	2020-04-29 18:37:30.284	5fb14764-9895-47c1-8d62-9f5853847dee	\N
939eb706-70cb-435f-b52e-7d4ce8259469	0		0			0		0		2020-05-03	2020-04-29 18:37:30.29	2020-04-29 18:37:30.29	5fb14764-9895-47c1-8d62-9f5853847dee	\N
06a4305f-15cf-44d4-b061-7b4107b32f8d	0		0			0		0		2020-04-13	2020-04-29 18:30:53.289	2020-04-29 18:42:08.363	64084079-34e6-40b4-8707-bd418e77eb89	\N
949537f2-ef07-4055-ae98-e2f0530aea05	0		0			0		0		2020-04-14	2020-04-29 18:30:53.335	2020-04-29 18:42:08.385	64084079-34e6-40b4-8707-bd418e77eb89	\N
b4297e77-dd66-457e-904d-e66dc146b2bd	1	Discussed non-compliant bids with LSB and Client	0			0		0		2020-04-15	2020-04-29 18:30:53.455	2020-04-29 18:42:08.393	64084079-34e6-40b4-8707-bd418e77eb89	\N
02b2b9bf-8bcf-4b78-a09b-53982183998e	0		0			0		0		2020-04-16	2020-04-29 18:30:53.499	2020-04-29 18:42:08.401	64084079-34e6-40b4-8707-bd418e77eb89	\N
dff8dac1-e46f-4cba-97c1-2e6ca1a46c49	0.5	Meeting with BCWS executives to discuss mandatory issues	0			0		0		2020-04-17	2020-04-29 18:30:53.528	2020-04-29 18:42:08.411	64084079-34e6-40b4-8707-bd418e77eb89	\N
bbb5b986-278e-474d-a7aa-eff5cce95d65	0		0			0		0		2020-04-18	2020-04-29 18:30:53.557	2020-04-29 18:42:08.419	64084079-34e6-40b4-8707-bd418e77eb89	\N
a18a42f6-657b-4d4c-9f10-169e889cdda7	0		0			0		0		2020-04-19	2020-04-29 18:30:53.694	2020-04-29 18:42:08.428	64084079-34e6-40b4-8707-bd418e77eb89	\N
283e2254-2b43-402e-8c98-31286c32e2ea	0		0			0		0		2020-04-13	2020-04-29 18:42:08.488	2020-04-29 18:42:08.488	d1efb866-8d5d-4eee-b59c-31ce6ab92139	\N
cc03c7f3-e5bd-4943-be96-a43c5a36d67d	0		0			0		0		2020-04-14	2020-04-29 18:42:08.496	2020-04-29 18:42:08.496	d1efb866-8d5d-4eee-b59c-31ce6ab92139	\N
448aed91-86fa-48bc-a3ce-b1f9c2f52528	0		0			0		0		2020-04-15	2020-04-29 18:42:08.505	2020-04-29 18:42:08.505	d1efb866-8d5d-4eee-b59c-31ce6ab92139	\N
f0368542-f100-49b8-be2a-24f7ac7f2e20	0		0			0		0		2020-04-16	2020-04-29 18:42:08.512	2020-04-29 18:42:08.512	d1efb866-8d5d-4eee-b59c-31ce6ab92139	\N
dc1dbd2f-fb95-4f0b-996c-a8cd737cf7b5	2.5	Reviewed EnWQS RFP and emailed comments to JG	0			0		0		2020-04-17	2020-04-29 18:42:08.516	2020-04-29 18:42:08.516	d1efb866-8d5d-4eee-b59c-31ce6ab92139	\N
63b98a29-3bde-4f15-9cf3-4f53bf2cb474	0		0			0		0		2020-04-18	2020-04-29 18:42:08.523	2020-04-29 18:42:08.523	d1efb866-8d5d-4eee-b59c-31ce6ab92139	\N
0bf2363f-5683-46dc-bc88-9cf48baf032a	0		0			0		0		2020-04-19	2020-04-29 18:42:08.527	2020-04-29 18:42:08.527	d1efb866-8d5d-4eee-b59c-31ce6ab92139	\N
d78114a7-aa3e-4e86-a9bd-a2e9997fa36d	4	WTSP Bundling Options Analysis & WTSPP: Decision Note Drafting	0			0		0		2020-04-20	2020-04-29 21:07:19.225	2020-04-29 21:09:02.738	03aaae5e-c740-4138-9387-e1d8aab1c733	\N
48ad8e0e-d068-4171-b7e6-b85cb392f131	0		0			0		0		2020-04-21	2020-04-29 21:07:19.232	2020-04-29 21:09:02.751	03aaae5e-c740-4138-9387-e1d8aab1c733	\N
19069c9a-006b-4ca2-b676-36d7b6fb40bb	0.5	Decision Note: Review and Discussion (w/Stu)	0			0		0		2020-04-22	2020-04-29 21:07:19.237	2020-04-29 21:09:02.761	03aaae5e-c740-4138-9387-e1d8aab1c733	\N
e385869c-4776-4db0-8126-c9f025969954	2	WTSP Bundling Options Analysis & WTSPP: Decision Note Drafting / edits	0			0		0		2020-04-23	2020-04-29 21:07:19.243	2020-04-29 21:09:02.769	03aaae5e-c740-4138-9387-e1d8aab1c733	\N
296a4396-2799-4925-91a7-661356c4bca3	2	WTSPP: Market Engagement Session Preparation 	0			0		0		2020-04-06	2020-04-29 21:17:25.175	2020-04-29 21:17:25.175	4482453b-fa8b-4cd9-8370-6e4513971938	\N
b5f5357b-36b5-41b4-b123-549f3613eed0	4	Marketplace engagement plan (Ami, Emily & James) & WTSP Bundling Options Analysis & WTSPP: Decision Note Drafting	0			0		0		2020-04-07	2020-04-29 21:17:25.186	2020-04-29 21:17:25.186	4482453b-fa8b-4cd9-8370-6e4513971938	\N
2ad7b868-34ec-44eb-9f0e-9fe830f756c2	3.5	WTSP Bundling Options Analysis & WTSPP: Decision Note Drafting	0			0		0		2020-04-08	2020-04-29 21:17:25.204	2020-04-29 21:17:25.204	4482453b-fa8b-4cd9-8370-6e4513971938	\N
a8f57d43-b9c3-4a2a-8742-20c6a8faa0ae	0		0			0		0		2020-04-21	2020-05-01 02:33:00.294	2020-05-01 02:33:00.294	8cd813cf-e881-4ae2-bb4e-6171bc9b0dd1	\N
8b77ae0c-f086-400b-add0-bed4d36ab78f	0		0			0		0		2020-03-30	2020-04-29 21:15:12.837	2020-04-29 21:15:12.837	be4444c9-57ba-4c6c-b498-2f7aafeb2ac1	\N
50a95a61-8e2b-43d7-b51f-61d7d01bb2c3	0		0			0		0		2020-03-31	2020-04-29 21:15:12.846	2020-04-29 21:15:12.846	be4444c9-57ba-4c6c-b498-2f7aafeb2ac1	\N
0eadb12c-9fbd-4d67-9db8-e93da89d2fc6	2	WTSP Bundling Options Analysis	0			0		0		2020-04-01	2020-04-29 21:15:12.852	2020-04-29 21:15:12.852	be4444c9-57ba-4c6c-b498-2f7aafeb2ac1	\N
e7e7f064-879a-4c33-84e2-d7d84dfd2cf7	2.5	Changes to SPO Summary note & WTSP Bundling Options Analysis	0			0		0		2020-04-02	2020-04-29 21:15:12.858	2020-04-29 21:15:12.858	be4444c9-57ba-4c6c-b498-2f7aafeb2ac1	\N
2cff93af-04db-4110-8f28-2388aa24d9a5	3	WTSPP (devices): Market Engagement Discussion w/procurement concierge & WTSP Bundling Options Analysis	0			0		0		2020-04-03	2020-04-29 21:15:12.928	2020-04-29 21:15:12.928	be4444c9-57ba-4c6c-b498-2f7aafeb2ac1	\N
23446d8a-9bbb-444d-93a5-254a1ae21dcb	0		0			0		0		2020-04-04	2020-04-29 21:15:12.969	2020-04-29 21:15:12.969	be4444c9-57ba-4c6c-b498-2f7aafeb2ac1	\N
4a6afe2e-9dc1-49f7-b45d-c5ce2a75adc8	0		0			0		0		2020-04-05	2020-04-29 21:15:13.015	2020-04-29 21:15:13.015	be4444c9-57ba-4c6c-b498-2f7aafeb2ac1	\N
1cd4038e-eeb6-4fe7-960d-e35f08c5a988	3	WTSPP: Decision Note Drafting & Marketplace engagement DN Review	0			0		0		2020-04-09	2020-04-29 21:17:25.22	2020-04-29 21:17:25.22	4482453b-fa8b-4cd9-8370-6e4513971938	\N
cedce120-63f7-465d-8b34-9b1c31f6266c	0		0			0		0		2020-04-10	2020-04-29 21:17:25.248	2020-04-29 21:17:25.248	4482453b-fa8b-4cd9-8370-6e4513971938	\N
cb820cad-7f23-4b11-8274-a875c43e7fc7	0		0			0		0		2020-04-11	2020-04-29 21:17:25.271	2020-04-29 21:17:25.271	4482453b-fa8b-4cd9-8370-6e4513971938	\N
a7cfe8bc-3094-4181-afaf-6334c98a6bd6	0		0			0		0		2020-04-12	2020-04-29 21:17:25.275	2020-04-29 21:17:25.275	4482453b-fa8b-4cd9-8370-6e4513971938	\N
81aaacd0-98f0-4db2-a03a-e5989b2ed939	0		0			0		0		2020-04-13	2020-04-29 21:19:02.404	2020-04-29 21:19:02.404	b80cb1d3-e9b6-40dc-b4ab-084281428995	\N
5c6b668d-a8df-49be-8ba6-365ce6fb50f7	0		0			0		0		2020-04-14	2020-04-29 21:19:02.466	2020-04-29 21:19:02.466	b80cb1d3-e9b6-40dc-b4ab-084281428995	\N
a0da9f5c-a9e7-439c-98aa-ebf89641d2a7	6	WTSP Bundling Options Analysis & Marketplace engagement DN Review (Ami/Emily) & WTSPP: Decision Note Drafting	0			0		0		2020-04-15	2020-04-29 21:19:02.472	2020-04-29 21:19:02.472	b80cb1d3-e9b6-40dc-b4ab-084281428995	\N
c4e68859-f764-4ba4-bbc2-5021cbc790dc	1	WTSP Bundling Options Analysis	0			0		0		2020-04-16	2020-04-29 21:19:02.476	2020-04-29 21:19:02.476	b80cb1d3-e9b6-40dc-b4ab-084281428995	\N
390c8b12-5a35-40f5-93ce-343a16b9c612	1.5	WTSP Bundling Options Analysis	0			0		0		2020-04-17	2020-04-29 21:19:02.483	2020-04-29 21:19:02.483	b80cb1d3-e9b6-40dc-b4ab-084281428995	\N
d91dd99f-5ef1-4d41-b7bf-aef0f90d1f94	0		0			0		0		2020-04-18	2020-04-29 21:19:02.487	2020-04-29 21:19:02.487	b80cb1d3-e9b6-40dc-b4ab-084281428995	\N
9b2d74fa-a05f-428d-a5b3-f5d621fa2678	0		0			0		0		2020-04-19	2020-04-29 21:19:02.513	2020-04-29 21:19:02.513	b80cb1d3-e9b6-40dc-b4ab-084281428995	\N
bb367ade-ae31-4d00-9992-297be160b237	0		0			0		0		2020-04-27	2020-04-30 16:59:56.505	2020-04-30 16:59:56.505	f5d74c0a-60ec-41c9-ad17-df2d7df2b526	\N
ea285112-d242-4d82-9305-2b1ff8285f7a	0		0			0		0		2020-04-28	2020-04-30 16:59:56.847	2020-04-30 16:59:56.847	f5d74c0a-60ec-41c9-ad17-df2d7df2b526	\N
abbc7b0d-5045-4688-a762-c7fbb247c370	0.330000000000000016	emails, addendum for AE	0			0		0		2020-04-29	2020-04-30 16:59:56.887	2020-04-30 16:59:56.887	f5d74c0a-60ec-41c9-ad17-df2d7df2b526	\N
4eddae7e-b9cb-4bbf-b37f-815501f4aef3	0		0			0		0		2020-04-30	2020-04-30 16:59:56.894	2020-04-30 16:59:56.894	f5d74c0a-60ec-41c9-ad17-df2d7df2b526	\N
cdf806cc-461a-4ea2-a5aa-11671ef9bc87	0		0			0		0		2020-05-01	2020-04-30 16:59:56.901	2020-04-30 16:59:56.901	f5d74c0a-60ec-41c9-ad17-df2d7df2b526	\N
e7b6746e-6c29-4c3a-a93d-be6d63dcbb65	0		0			0		0		2020-05-02	2020-04-30 16:59:56.911	2020-04-30 16:59:56.911	f5d74c0a-60ec-41c9-ad17-df2d7df2b526	\N
82b068b4-e61d-4c15-8bbc-b8dcb0c95bbf	0		0			0		0		2020-05-03	2020-04-30 16:59:56.919	2020-04-30 16:59:56.919	f5d74c0a-60ec-41c9-ad17-df2d7df2b526	\N
8918820e-ca22-44c2-96fb-6a417f199447	0		0			0		0		2020-04-20	2020-04-30 21:40:20.642	2020-04-30 21:40:20.642	0228d554-e45f-48ea-9015-ae16efd0b692	\N
8b23c428-c8fa-4811-a0e1-354a12422928	0		0			0		0		2020-04-21	2020-04-30 21:40:20.679	2020-04-30 21:40:20.679	0228d554-e45f-48ea-9015-ae16efd0b692	\N
224d06e8-899c-4598-a5b0-c62240ffc371	0		0			0		0		2020-04-22	2020-04-30 21:40:20.694	2020-04-30 21:40:20.694	0228d554-e45f-48ea-9015-ae16efd0b692	\N
d59afb89-7ed7-49ce-9a57-038dcc9e4518	0		0			0		0		2020-04-23	2020-04-30 21:40:20.701	2020-04-30 21:40:20.701	0228d554-e45f-48ea-9015-ae16efd0b692	\N
ce3701d2-9e11-4d79-b474-7810809a4b06	2	Work on draft notification letters and sending out	0			0		0		2020-04-24	2020-04-30 21:40:20.709	2020-04-30 21:40:20.709	0228d554-e45f-48ea-9015-ae16efd0b692	\N
b2da4a2d-02f6-4eb8-ae7a-c2abd71da446	0		0			0		0		2020-04-25	2020-04-30 21:40:20.743	2020-04-30 21:40:20.743	0228d554-e45f-48ea-9015-ae16efd0b692	\N
4fc48b6b-608b-40f8-a906-759ea563855c	0		0			0		0		2020-04-26	2020-04-30 21:40:20.754	2020-04-30 21:40:20.754	0228d554-e45f-48ea-9015-ae16efd0b692	\N
9da63699-19c4-41af-873c-7ca9a35465eb	0		0			0		0		2020-03-30	2020-05-01 02:21:49.184	2020-05-01 02:21:49.184	ea6d9eaf-1238-4e1a-8a11-37b7b5c083e9	\N
2ef76b71-92cf-44d0-95a8-ac85688df550	0		0			0		0		2020-03-31	2020-05-01 02:21:49.192	2020-05-01 02:21:49.192	ea6d9eaf-1238-4e1a-8a11-37b7b5c083e9	\N
667f2419-565f-4176-911b-1ce5d4393658	2	Review First Nation Consultation Application Support RFP	0			0		0		2020-04-01	2020-05-01 02:21:49.198	2020-05-01 02:21:49.198	ea6d9eaf-1238-4e1a-8a11-37b7b5c083e9	\N
a123975e-10d6-472e-958d-f6ad2c299bec	0		0			0		0		2020-04-02	2020-05-01 02:21:49.204	2020-05-01 02:21:49.204	ea6d9eaf-1238-4e1a-8a11-37b7b5c083e9	\N
82ad0710-7e09-4cb2-ad05-3d5b27c8e8ab	0		0			0		0		2020-04-03	2020-05-01 02:21:49.21	2020-05-01 02:21:49.21	ea6d9eaf-1238-4e1a-8a11-37b7b5c083e9	\N
bdcde727-c40f-4b02-8df4-7de4b2c54ab6	0		0			0		0		2020-04-04	2020-05-01 02:21:49.214	2020-05-01 02:21:49.214	ea6d9eaf-1238-4e1a-8a11-37b7b5c083e9	\N
50270e0b-f3dd-4c8b-bc26-23900873755b	0		0			0		0		2020-04-05	2020-05-01 02:21:49.237	2020-05-01 02:21:49.237	ea6d9eaf-1238-4e1a-8a11-37b7b5c083e9	\N
f864a55f-109b-4d20-845a-bf09e9f96e07	1	meeting with legal to discuss FCDTS scope and structure	0			0		0		2020-04-06	2020-05-01 02:22:41.223	2020-05-01 02:22:41.223	41ce4e7b-b85d-4d7f-85eb-d85d60c2f31c	\N
c89c7c56-0a16-40be-9008-37eb68e9bbbf	4	FCDTS drafting 	0			0		0		2020-04-07	2020-05-01 02:22:41.266	2020-05-01 02:22:41.266	41ce4e7b-b85d-4d7f-85eb-d85d60c2f31c	\N
44e3d57b-65a4-4e51-8bc0-0df0e0977770	0		0			0		0		2020-04-08	2020-05-01 02:22:41.373	2020-05-01 02:22:41.373	41ce4e7b-b85d-4d7f-85eb-d85d60c2f31c	\N
4ad6c481-c4cf-4b44-ab50-f55f9ad53e6a	0		0			0		0		2020-04-09	2020-05-01 02:22:41.379	2020-05-01 02:22:41.379	41ce4e7b-b85d-4d7f-85eb-d85d60c2f31c	\N
74893329-8e7e-43fa-8308-d5b0b3215541	0		0			0		0		2020-04-10	2020-05-01 02:22:41.384	2020-05-01 02:22:41.384	41ce4e7b-b85d-4d7f-85eb-d85d60c2f31c	\N
e0f22482-46d3-4d26-b2e9-28067b652dc3	0		0			0		0		2020-04-11	2020-05-01 02:22:41.396	2020-05-01 02:22:41.396	41ce4e7b-b85d-4d7f-85eb-d85d60c2f31c	\N
0281e02d-6c29-4fd0-9945-573b07f8dc48	0		0			0		0		2020-04-12	2020-05-01 02:22:41.402	2020-05-01 02:22:41.402	41ce4e7b-b85d-4d7f-85eb-d85d60c2f31c	\N
29bbb9c9-36ee-40f1-a9e1-bd496cbeea99	0		0			0		0		2020-04-13	2020-05-01 02:26:52.489	2020-05-01 02:26:52.489	6b606130-bab4-4fb7-8f01-aabe1193e417	\N
1abcff7a-20ce-4dc4-a180-5c8c87772a4f	0		0			0		0		2020-04-14	2020-05-01 02:26:52.512	2020-05-01 02:26:52.512	6b606130-bab4-4fb7-8f01-aabe1193e417	\N
cf0b4b10-46bb-447b-9478-a98bb6075bbc	4	RSA drafting and appendix forms creation	0			0		0		2020-04-15	2020-05-01 02:26:52.529	2020-05-01 02:26:52.529	6b606130-bab4-4fb7-8f01-aabe1193e417	\N
ad665381-3d3c-4f2e-9d24-170c1b519d04	0		0			0		0		2020-04-16	2020-05-01 02:26:52.555	2020-05-01 02:26:52.555	6b606130-bab4-4fb7-8f01-aabe1193e417	\N
107c2945-8e36-4a80-b6dc-455fd6d77758	1	meeting with legal for RSA/SA review	0			0		0		2020-04-17	2020-05-01 02:26:52.572	2020-05-01 02:26:52.572	6b606130-bab4-4fb7-8f01-aabe1193e417	\N
2fa33113-86c0-4122-b187-86eb5c14664e	0		0			0		0		2020-04-18	2020-05-01 02:26:52.591	2020-05-01 02:26:52.591	6b606130-bab4-4fb7-8f01-aabe1193e417	\N
9019af8b-896f-4139-a82d-2bd3adee255d	0		0			0		0		2020-04-19	2020-05-01 02:26:52.599	2020-05-01 02:26:52.599	6b606130-bab4-4fb7-8f01-aabe1193e417	\N
ee33c624-64b0-4a4d-9da9-9307e842b8f2	4	Reworking FCDTS draft from legal recommended revisions	0			0		0		2020-04-20	2020-05-01 02:33:00.286	2020-05-01 02:33:00.286	8cd813cf-e881-4ae2-bb4e-6171bc9b0dd1	\N
0bb70127-9806-457f-a7f0-c2ff1cbbb4ae	0		0			0		0		2020-04-04	2020-05-01 02:18:52.543	2020-05-01 18:51:43.118	a6034a7e-2a66-4a94-b1fd-3d389bafec53	\N
f7d81cc4-a5ca-4310-852f-3cb62193f7f2	0		0			0		0		2020-04-05	2020-05-01 02:18:52.549	2020-05-01 18:51:43.125	a6034a7e-2a66-4a94-b1fd-3d389bafec53	\N
2cb537a4-b513-4619-8583-e77d74632403	0		0			0		0		2020-03-31	2020-05-01 02:18:52.499	2020-05-01 18:51:43.083	a6034a7e-2a66-4a94-b1fd-3d389bafec53	\N
55d3be90-ba96-4c82-8536-5a33e8e72412	4	Drafting RSA with Chris and Tammy	0			0		0		2020-04-02	2020-05-01 02:18:52.529	2020-05-01 18:51:43.1	a6034a7e-2a66-4a94-b1fd-3d389bafec53	\N
da9ea259-8361-406a-907d-3516f9f9e423	3	Re-working RSA	0			0		0		2020-04-03	2020-05-01 02:18:52.538	2020-05-01 18:51:43.109	a6034a7e-2a66-4a94-b1fd-3d389bafec53	\N
7e6b302d-dfbe-49cd-a048-4d8929614cbf	3	1 hour meeting for final SA /RSA alignment; 2 hrs final prep and post	0			0		0		2020-04-22	2020-05-01 02:33:00.301	2020-05-01 02:33:00.301	8cd813cf-e881-4ae2-bb4e-6171bc9b0dd1	\N
d647f116-ab4d-41a9-aed0-fce45f5a56f0	0		0			0		0		2020-04-23	2020-05-01 02:33:00.306	2020-05-01 02:33:00.306	8cd813cf-e881-4ae2-bb4e-6171bc9b0dd1	\N
471e876d-2598-426b-aab4-892ecaf189f6	0		0			0		0		2020-04-24	2020-05-01 02:33:00.407	2020-05-01 02:33:00.407	8cd813cf-e881-4ae2-bb4e-6171bc9b0dd1	\N
0254c08d-0136-45a2-b0aa-0b30688789b8	0		0			0		0		2020-04-25	2020-05-01 02:33:00.884	2020-05-01 02:33:00.884	8cd813cf-e881-4ae2-bb4e-6171bc9b0dd1	\N
cddf031e-4661-481b-8043-52c1789b5a04	0		0			0		0		2020-04-26	2020-05-01 02:33:00.945	2020-05-01 02:33:00.945	8cd813cf-e881-4ae2-bb4e-6171bc9b0dd1	\N
67d37b59-31ab-4ab9-9654-28f78e301945	1	correspondence re: RSA respondent query	0			0		0		2020-04-27	2020-05-01 02:34:46.992	2020-05-01 02:34:46.992	42eb31dd-275f-4ee9-9733-79bafbdb0a2e	\N
b3324a2f-e50f-43e2-a59a-1d70ed1ef0e7	0		0			0		0		2020-04-28	2020-05-01 02:34:47.013	2020-05-01 02:34:47.013	42eb31dd-275f-4ee9-9733-79bafbdb0a2e	\N
9c1fd236-82df-404c-9bcf-e8315b4a2630	1	following up on education and drafting of addendum	0			0		0		2020-04-29	2020-05-01 02:34:47.02	2020-05-01 02:34:47.02	42eb31dd-275f-4ee9-9733-79bafbdb0a2e	\N
d118f384-552c-4073-8a57-8391b304d6af	0		0			0		0		2020-04-30	2020-05-01 02:34:47.075	2020-05-01 02:34:47.075	42eb31dd-275f-4ee9-9733-79bafbdb0a2e	\N
98fa01ca-5e0b-49c2-9689-cd8b24ebb32f	0		0			0		0		2020-05-01	2020-05-01 02:34:47.164	2020-05-01 02:34:47.164	42eb31dd-275f-4ee9-9733-79bafbdb0a2e	\N
599c552b-cf38-47e3-be83-f340f7d4fa0d	0		0			0		0		2020-05-02	2020-05-01 02:34:47.206	2020-05-01 02:34:47.206	42eb31dd-275f-4ee9-9733-79bafbdb0a2e	\N
0058904a-b824-44d4-a1e3-8cda2cda1570	0		0			0		0		2020-05-03	2020-05-01 02:34:47.228	2020-05-01 02:34:47.228	42eb31dd-275f-4ee9-9733-79bafbdb0a2e	\N
23d34c9f-999c-4c2f-aaba-8ec945a56752	0		0			0		0		2020-04-13	2020-05-01 02:53:18.717	2020-05-01 02:53:18.717	f9181b27-a207-49c9-a716-cc1814886088	\N
d1537d79-df34-4425-a93f-7f6b77eeba41	0		0			0		0		2020-04-14	2020-05-01 02:53:18.736	2020-05-01 02:53:18.736	f9181b27-a207-49c9-a716-cc1814886088	\N
c0dbea5e-d535-4e87-a377-a1a6aa98f853	0.25	Follow up with the client on status of projects. 	0			0		0		2020-04-15	2020-05-01 02:53:18.742	2020-05-01 02:53:18.742	f9181b27-a207-49c9-a716-cc1814886088	\N
01357bb5-5fc4-46cb-b356-647ef5b83237	0		0			0		0		2020-04-16	2020-05-01 02:53:18.753	2020-05-01 02:53:18.753	f9181b27-a207-49c9-a716-cc1814886088	\N
8a019e9d-f2af-41c6-a5cf-c4825dc834fc	0		0			0		0		2020-04-17	2020-05-01 02:53:18.76	2020-05-01 02:53:18.76	f9181b27-a207-49c9-a716-cc1814886088	\N
76b00797-13aa-4748-a88e-5fed512a413b	0		0			0		0		2020-04-18	2020-05-01 02:53:18.766	2020-05-01 02:53:18.766	f9181b27-a207-49c9-a716-cc1814886088	\N
4217a235-bae5-4cea-b813-57d889917964	0		0			0		0		2020-04-19	2020-05-01 02:53:18.775	2020-05-01 02:53:18.775	f9181b27-a207-49c9-a716-cc1814886088	\N
e0aa8645-0ffc-4e3a-bef3-f3ba8631df23	0		0			0		0		2020-04-27	2020-05-01 03:20:55.013	2020-05-01 03:20:55.013	f6d73cca-001d-416e-8548-8315466c2c94	\N
0d4fab18-dd0f-4a4d-8f6b-2ec0b28bd35a	0		0			0		0		2020-04-28	2020-05-01 03:20:55.02	2020-05-01 03:20:55.02	f6d73cca-001d-416e-8548-8315466c2c94	\N
d23922c9-77eb-4033-ac6d-580ac9289f20	1	Post contract award notice on BC Bid for BC Geological Branch Survey and follow up project status.	0			0		0		2020-04-29	2020-05-01 03:20:55.028	2020-05-01 03:20:55.028	f6d73cca-001d-416e-8548-8315466c2c94	\N
8ab0acac-7b3f-4558-a244-1aa286207664	0		0			0		0		2020-04-30	2020-05-01 03:20:55.033	2020-05-01 03:20:55.033	f6d73cca-001d-416e-8548-8315466c2c94	\N
87d4c1c7-45f5-40f1-8e02-337b4d702fc0	0		0			0		0		2020-05-01	2020-05-01 03:20:55.158	2020-05-01 03:20:55.158	f6d73cca-001d-416e-8548-8315466c2c94	\N
a50efc4c-1a8d-4dc4-91cc-b2dc0f11a1e9	0		0			0		0		2020-05-02	2020-05-01 03:20:55.164	2020-05-01 03:20:55.164	f6d73cca-001d-416e-8548-8315466c2c94	\N
41b937db-e170-4488-817b-27fa917a00a5	0		0			0		0		2020-05-03	2020-05-01 03:20:55.182	2020-05-01 03:20:55.182	f6d73cca-001d-416e-8548-8315466c2c94	\N
cf64d1be-86a2-456d-acc3-1da71354733f	0		0			0		0		2020-03-30	2020-05-01 02:18:52.491	2020-05-01 18:51:43.073	a6034a7e-2a66-4a94-b1fd-3d389bafec53	\N
8694da8e-5a16-470f-9d86-a0171746b381	0		0			0		0		2020-04-06	2020-05-01 02:46:36.802	2020-05-01 10:24:15.481	892d22d5-911a-41fe-94a7-38cc69fdbdcf	\N
72e081b0-bff8-47ba-a63e-5f5ddd518d56	1.69999999999999996	Prepared project status update for leadership team.	0			0		0		2020-04-07	2020-05-01 02:46:36.809	2020-05-01 10:24:15.497	892d22d5-911a-41fe-94a7-38cc69fdbdcf	\N
f9c97fc8-4b04-4aef-9291-526a3752e875	0.5	Scheduled debriefing meeting with Salus System Limited	0			0		0		2020-04-08	2020-05-01 02:46:36.815	2020-05-01 10:24:15.505	892d22d5-911a-41fe-94a7-38cc69fdbdcf	\N
3a69825b-4542-4850-bf75-7f2673c99c44	3	Reviewed Sierra' s proposal and prepared debriefing script for LSB approval.	0			0		0		2020-04-09	2020-05-01 02:46:36.819	2020-05-01 10:24:15.517	892d22d5-911a-41fe-94a7-38cc69fdbdcf	\N
676f062a-80d1-410e-8f00-8be098d3e845	0		0			0		0		2020-04-10	2020-05-01 02:46:36.824	2020-05-01 10:24:15.524	892d22d5-911a-41fe-94a7-38cc69fdbdcf	\N
3192c8fc-7280-4010-b275-625eea132907	0		0			0		0		2020-04-11	2020-05-01 02:46:36.827	2020-05-01 10:24:15.531	892d22d5-911a-41fe-94a7-38cc69fdbdcf	\N
0d3a7323-db86-4ffe-af6a-71bc26390e9b	0		0			0		0		2020-04-12	2020-05-01 02:46:36.834	2020-05-01 10:24:15.539	892d22d5-911a-41fe-94a7-38cc69fdbdcf	\N
624b8491-6d77-4c62-9d99-8cb32041da2d	0		0			0		0		2020-04-06	2020-05-01 10:24:15.575	2020-05-01 10:24:15.575	9aada634-18ec-404e-b941-b75a5481fd4e	\N
5edaea4b-d272-4fed-8883-aa22bc5cabc8	0.5	Reviewed email provided by client on the source of funding and attended Skype meeting.	0			0		0		2020-04-07	2020-05-01 10:24:15.582	2020-05-01 10:24:15.582	9aada634-18ec-404e-b941-b75a5481fd4e	\N
68435e6d-9251-496e-a18e-9ef675d2644c	0		0			0		0		2020-04-08	2020-05-01 10:24:15.591	2020-05-01 10:24:15.591	9aada634-18ec-404e-b941-b75a5481fd4e	\N
914a5d7a-3d4e-4f7b-846f-8c52725ae960	1	Made recommendation to client on the approach moving forward and next steps.	0			0		0		2020-04-09	2020-05-01 10:24:15.595	2020-05-01 10:24:15.595	9aada634-18ec-404e-b941-b75a5481fd4e	\N
0a6148ec-4b78-4d57-bbc0-843cdeabc8d5	0		0			0		0		2020-04-10	2020-05-01 10:24:15.694	2020-05-01 10:24:15.694	9aada634-18ec-404e-b941-b75a5481fd4e	\N
b0915489-248a-4f55-8ae6-c31ff8c82aab	0		0			0		0		2020-04-11	2020-05-01 10:24:15.699	2020-05-01 10:24:15.699	9aada634-18ec-404e-b941-b75a5481fd4e	\N
7532eb55-2a26-4e74-9208-d9ead9d79c61	0		0			0		0		2020-04-12	2020-05-01 10:24:15.705	2020-05-01 10:24:15.705	9aada634-18ec-404e-b941-b75a5481fd4e	\N
f7987568-3356-490a-b8b5-b3139581da77	1	Reviewed materials for debriefing 	0			0		0		2020-04-20	2020-05-01 03:13:48.006	2020-05-01 10:40:39.555	b251ed50-6279-43e4-8323-b9f887e29cd0	\N
dad04cdb-0d4c-4df6-91c8-fb47e56058bf	0.5	Debriefing meeting with client held to confirm roles, responsibilities and expectation.	0			0		0		2020-04-21	2020-05-01 03:13:48.021	2020-05-01 10:40:39.569	b251ed50-6279-43e4-8323-b9f887e29cd0	\N
a0023d11-0881-402e-a0df-a9f407061413	1.75	Debriefing meeting preparation followed by debriefing meeting with the vendor. 	0			0		0		2020-04-22	2020-05-01 03:13:48.027	2020-05-01 10:40:39.576	b251ed50-6279-43e4-8323-b9f887e29cd0	\N
43c9f156-3b4d-491e-bb6f-2f3d0eb0a604	3	Reviewed First Nation Consultation Application Support RFP and provided feedback to client.	0			0		0		2020-04-23	2020-05-01 03:13:48.034	2020-05-01 10:40:39.584	b251ed50-6279-43e4-8323-b9f887e29cd0	\N
2a2e682e-2ed5-460e-8851-538b58a53660	1	Provided biweekly updates for leadership team and attended meeting.	0			0		0		2020-04-24	2020-05-01 03:13:48.041	2020-05-01 10:40:39.591	b251ed50-6279-43e4-8323-b9f887e29cd0	\N
546d1a43-cf94-4bb8-a395-34d8c8581ac4	0		0			0		0		2020-04-25	2020-05-01 03:13:48.049	2020-05-01 10:40:39.602	b251ed50-6279-43e4-8323-b9f887e29cd0	\N
edd85410-5cf9-4f49-a1bc-08ece742e8ea	0		0			0		0		2020-04-26	2020-05-01 03:13:48.057	2020-05-01 10:40:39.609	b251ed50-6279-43e4-8323-b9f887e29cd0	\N
1cd8fe6b-dc31-4a38-bc6d-7decb3c2e29e	0.5	meeting with legal to discuss FCDTS pricing 	0			0		0		2020-04-01	2020-05-01 02:18:52.518	2020-05-01 18:51:43.093	a6034a7e-2a66-4a94-b1fd-3d389bafec53	\N
296af518-9470-454a-a016-c8120a491f61	0		0			0		0		2020-04-20	2020-05-01 10:40:39.644	2020-05-01 10:40:39.644	7f76bf0d-6dd6-4fc2-900d-94aabda3f77a	\N
e8efd0cb-394d-4748-bd7b-9cd323d026f0	0		0			0		0		2020-04-21	2020-05-01 10:40:39.657	2020-05-01 10:40:39.657	7f76bf0d-6dd6-4fc2-900d-94aabda3f77a	\N
18ae0859-db49-4fa6-aaad-1a34f8833686	1.5	Reviewed latest version of NOI and sent email seeking clarification. 	0			0		0		2020-04-22	2020-05-01 10:40:39.662	2020-05-01 10:40:39.662	7f76bf0d-6dd6-4fc2-900d-94aabda3f77a	\N
b1989665-e770-4e69-97a6-d723716ce55c	0.5	Revised NOI and sent final version for review and advice client on communicating with incumbent prior to issuing the NOI	0			0		0		2020-04-23	2020-05-01 10:40:39.669	2020-05-01 10:40:39.669	7f76bf0d-6dd6-4fc2-900d-94aabda3f77a	\N
a561d946-f6ad-453a-b714-cdf950323873	1	Finalized and posted NOI on BC Bid.	0			0		0		2020-04-24	2020-05-01 10:40:39.674	2020-05-01 10:40:39.674	7f76bf0d-6dd6-4fc2-900d-94aabda3f77a	\N
2cba8449-2da7-4943-97d4-0482c0b13b0a	0		0			0		0		2020-04-25	2020-05-01 10:40:39.69	2020-05-01 10:40:39.69	7f76bf0d-6dd6-4fc2-900d-94aabda3f77a	\N
7426df1e-6583-4a25-a9d6-0d5690806bb7	0		0			0		0		2020-04-26	2020-05-01 10:40:39.694	2020-05-01 10:40:39.694	7f76bf0d-6dd6-4fc2-900d-94aabda3f77a	\N
8ae1e74c-1f31-40c0-a486-3c749df4c37f	1	Call with LSB for process review	0			0		0		2020-04-27	2020-05-01 20:51:08.252	2020-05-01 20:51:08.252	25d197fb-5529-47b6-a4cd-824aa765a37a	\N
ee298eb9-4822-4179-ba99-26bbb60c76ff	0		0			0		0		2020-04-28	2020-05-01 20:51:08.259	2020-05-01 20:51:08.259	25d197fb-5529-47b6-a4cd-824aa765a37a	\N
d12f7104-b45a-4fb5-8047-66cb9e1a2f77	0		0			0		0		2020-04-29	2020-05-01 20:51:08.265	2020-05-01 20:51:08.265	25d197fb-5529-47b6-a4cd-824aa765a37a	\N
28f83a64-7012-4e95-8a64-7c769b8d3d85	1	Weekly call and review of Weight criteria	0			0		0		2020-04-30	2020-05-01 20:51:08.274	2020-05-01 20:51:08.274	25d197fb-5529-47b6-a4cd-824aa765a37a	\N
ddd55efc-7743-4901-a5b1-17e2b158e434	1	RFP weight criteria discussion with Zach	0			0		0		2020-05-01	2020-05-01 20:51:08.279	2020-05-01 20:51:08.279	25d197fb-5529-47b6-a4cd-824aa765a37a	\N
d4c12612-9372-4247-be62-77305fd34b1a	0		0			0		0		2020-05-02	2020-05-01 20:51:08.286	2020-05-01 20:51:08.286	25d197fb-5529-47b6-a4cd-824aa765a37a	\N
b150f1ff-ee6f-498f-bf38-4cd6be08fb4f	0		0			0		0		2020-05-03	2020-05-01 20:51:08.291	2020-05-01 20:51:08.291	25d197fb-5529-47b6-a4cd-824aa765a37a	\N
5ab686b0-e45e-490f-8618-280bc685fdb2	1	RFP Enviro Reqs	0			0		0		2020-04-20	2020-05-01 20:53:42.684	2020-05-01 20:53:42.684	65dbc4df-f87a-4546-b872-63133b12dba1	\N
d33d250d-2327-4217-b21d-7ceae7d449a1	0		0			0		0		2020-04-21	2020-05-01 20:53:42.689	2020-05-01 20:53:42.689	65dbc4df-f87a-4546-b872-63133b12dba1	\N
126abc4b-b4db-4442-9173-59184cf6d89c	0		0			0		0		2020-04-22	2020-05-01 20:53:42.694	2020-05-01 20:53:42.694	65dbc4df-f87a-4546-b872-63133b12dba1	\N
5079b23c-d305-4834-aae7-8b80e7c25dae	1	Weekly call and review	0			0		0		2020-04-23	2020-05-01 20:53:42.701	2020-05-01 20:53:42.701	65dbc4df-f87a-4546-b872-63133b12dba1	\N
da8c89a8-974c-44a0-b000-fd1a300842ce	0		0			0		0		2020-04-24	2020-05-01 20:53:42.707	2020-05-01 20:53:42.707	65dbc4df-f87a-4546-b872-63133b12dba1	\N
2b45e2dc-bbcd-41fe-af7d-b417587bbbb3	0		0			0		0		2020-04-25	2020-05-01 20:53:42.711	2020-05-01 20:53:42.711	65dbc4df-f87a-4546-b872-63133b12dba1	\N
9e6db54e-6ae9-4644-9130-64d535c3039e	0		0			0		0		2020-04-26	2020-05-01 20:53:42.715	2020-05-01 20:53:42.715	65dbc4df-f87a-4546-b872-63133b12dba1	\N
1c102104-2564-408c-b753-740b7eb26ecf	0		0			0		0		2020-04-13	2020-05-01 20:54:49.893	2020-05-01 20:54:49.893	6eb78c9f-7293-426e-9005-12bd5861ee06	\N
d90724f2-2dfd-4540-b6b6-9e7f19e9f596	1	VDR for DEMS RFP	0			0		0		2020-04-14	2020-05-01 20:54:49.9	2020-05-01 20:54:49.9	6eb78c9f-7293-426e-9005-12bd5861ee06	\N
f511cd79-2dc2-4f0c-9a19-eb797830a6c2	0		0			0		0		2020-04-15	2020-05-01 20:54:49.91	2020-05-01 20:54:49.91	6eb78c9f-7293-426e-9005-12bd5861ee06	\N
019f463c-d13b-46c1-b80b-e05f18938a7c	1.5	Weekly call and review	0			0		0		2020-04-16	2020-05-01 20:54:49.916	2020-05-01 20:54:49.916	6eb78c9f-7293-426e-9005-12bd5861ee06	\N
5c99918f-532c-46e6-914a-c7490c6e7914	0		0			0		0		2020-04-17	2020-05-01 20:54:49.92	2020-05-01 20:54:49.92	6eb78c9f-7293-426e-9005-12bd5861ee06	\N
8f608d4b-f55e-4e39-87ac-015e6fd4e1ed	0		0			0		0		2020-04-18	2020-05-01 20:54:49.925	2020-05-01 20:54:49.925	6eb78c9f-7293-426e-9005-12bd5861ee06	\N
79646b6d-fe88-4739-bfec-bbff0833c777	0		0			0		0		2020-04-19	2020-05-01 20:54:49.931	2020-05-01 20:54:49.931	6eb78c9f-7293-426e-9005-12bd5861ee06	\N
cae7f725-57f2-44b4-a426-0baf90b16f63	0		0			0		0		2020-04-06	2020-05-01 20:55:37.933	2020-05-01 20:55:37.933	d99be05e-2bce-4dab-bc00-f67dec8f7ae6	\N
e72e0b8d-44d5-4a43-8ef1-51e3400e398c	0		0			0		0		2020-04-07	2020-05-01 20:55:37.94	2020-05-01 20:55:37.94	d99be05e-2bce-4dab-bc00-f67dec8f7ae6	\N
fc5bd0b0-9cbc-435b-bb08-6fde30fcc854	0		0			0		0		2020-04-08	2020-05-01 20:55:37.946	2020-05-01 20:55:37.946	d99be05e-2bce-4dab-bc00-f67dec8f7ae6	\N
423e10ba-3e4b-4387-99fe-c870ea69c686	2	Weekly call and review	0			0		0		2020-04-09	2020-05-01 20:55:37.951	2020-05-01 20:55:37.951	d99be05e-2bce-4dab-bc00-f67dec8f7ae6	\N
b21d8297-f235-4277-bc08-ac1bec466cae	0		0			0		0		2020-04-10	2020-05-01 20:55:37.956	2020-05-01 20:55:37.956	d99be05e-2bce-4dab-bc00-f67dec8f7ae6	\N
b7406abd-e263-4d8c-8ced-2868d43c3ad3	0		0			0		0		2020-04-11	2020-05-01 20:55:37.961	2020-05-01 20:55:37.961	d99be05e-2bce-4dab-bc00-f67dec8f7ae6	\N
19fd0fd5-d0d3-452d-b1f3-097ce9e466d0	0		0			0		0		2020-04-12	2020-05-01 20:55:37.969	2020-05-01 20:55:37.969	d99be05e-2bce-4dab-bc00-f67dec8f7ae6	\N
eaa7ae3f-8170-4263-aab1-de3ba3037e3e	0		0			0		0		2020-03-30	2020-05-01 20:56:18.946	2020-05-01 20:56:18.946	e89f92e9-e765-4049-9f6f-a999c9dc3e02	\N
7aa8afa8-3546-4377-aee9-10116699da79	0		0			0		0		2020-03-31	2020-05-01 20:56:18.952	2020-05-01 20:56:18.952	e89f92e9-e765-4049-9f6f-a999c9dc3e02	\N
b72a98d8-2405-4bfa-a0e0-007863233ed0	0		0			0		0		2020-04-01	2020-05-01 20:56:18.956	2020-05-01 20:56:18.956	e89f92e9-e765-4049-9f6f-a999c9dc3e02	\N
592ab965-4ef2-4806-bd10-9d816ebc9d60	1.5	Weekly call and RFP review	0			0		0		2020-04-02	2020-05-01 20:56:18.962	2020-05-01 20:56:18.962	e89f92e9-e765-4049-9f6f-a999c9dc3e02	\N
02a1f806-4817-4ee3-843e-1f7eb8a8200d	0		0			0		0		2020-04-03	2020-05-01 20:56:18.968	2020-05-01 20:56:18.968	e89f92e9-e765-4049-9f6f-a999c9dc3e02	\N
23173d46-35cf-4c42-be6c-43b3c1512534	0		0			0		0		2020-04-04	2020-05-01 20:56:18.975	2020-05-01 20:56:18.975	e89f92e9-e765-4049-9f6f-a999c9dc3e02	\N
9e72908a-0aa7-40fc-8dba-f0f1a8cebc02	0		0			0		0		2020-04-05	2020-05-01 20:56:18.98	2020-05-01 20:56:18.98	e89f92e9-e765-4049-9f6f-a999c9dc3e02	\N
55fc460b-db6f-44f3-879d-636781706e56	0		0			0		0		2020-04-27	2020-05-01 21:49:57.953	2020-05-01 21:49:57.953	d0a90e80-fbca-4486-9417-c0dc068c0825	\N
3b33da82-1b35-4194-9548-4cd4d9ba0ca3	0		0			0		0		2020-04-28	2020-05-01 21:49:58.004	2020-05-01 21:49:58.004	d0a90e80-fbca-4486-9417-c0dc068c0825	\N
3c16400a-c17f-47a2-95e4-2bf86418a42f	0		0			0		0		2020-04-29	2020-05-01 21:49:58.011	2020-05-01 21:49:58.011	d0a90e80-fbca-4486-9417-c0dc068c0825	\N
c4314d83-021a-43f2-a12f-8dd66c24c007	0.5	Call with LSB-GI and BH on template. Communications and procurement counsel request.	0			0		0		2020-04-30	2020-05-01 21:49:58.017	2020-05-01 21:49:58.017	d0a90e80-fbca-4486-9417-c0dc068c0825	\N
e5b547f2-e3e6-4df4-a60b-6ac27470077e	0.5	Review tie-breaker recommendation, documentation, and discussion.	0			0		0		2020-04-22	2020-05-01 21:49:12.301	2020-05-01 22:24:28.333	0b6d5554-79bc-44e3-9616-e70fa33c8e7f	\N
18995c02-0170-4d2b-b42a-094931f1afd9	0		0			0		0		2020-04-23	2020-05-01 21:49:12.308	2020-05-01 22:24:28.354	0b6d5554-79bc-44e3-9616-e70fa33c8e7f	\N
fbd1b740-e431-4e00-8da0-3a7bf78657ea	0		0			0		0		2020-04-24	2020-05-01 21:49:12.314	2020-05-01 22:24:28.367	0b6d5554-79bc-44e3-9616-e70fa33c8e7f	\N
0ec96044-13f6-4c26-a152-1d1f3539feaa	0		0			0		0		2020-04-25	2020-05-01 21:49:12.323	2020-05-01 22:24:28.399	0b6d5554-79bc-44e3-9616-e70fa33c8e7f	\N
dff592d7-c5ae-4157-8b17-bd183de2ab4c	0		0			0		0		2020-04-26	2020-05-01 21:49:12.333	2020-05-01 22:24:28.406	0b6d5554-79bc-44e3-9616-e70fa33c8e7f	\N
7555b5a3-ba60-43b7-ac19-c71fca7af8dc	3	Complete initial review of V0.12 of RFP and provide to client.	0			0		0		2020-04-21	2020-05-01 21:49:12.287	2020-05-01 22:24:28.246	0b6d5554-79bc-44e3-9616-e70fa33c8e7f	\N
ef58ad74-1de4-4eb7-8dab-80df16603ec6	0		0			0		0		2020-05-01	2020-05-01 21:49:58.022	2020-05-01 21:49:58.022	d0a90e80-fbca-4486-9417-c0dc068c0825	\N
5a88aa90-2a68-4c30-837c-6dc9c5f0bcda	0		0			0		0		2020-05-02	2020-05-01 21:49:58.026	2020-05-01 21:49:58.026	d0a90e80-fbca-4486-9417-c0dc068c0825	\N
21826ed5-ecd4-4f6a-9614-7e816ae4c779	0		0			0		0		2020-05-03	2020-05-01 21:49:58.034	2020-05-01 21:49:58.034	d0a90e80-fbca-4486-9417-c0dc068c0825	\N
08dd4063-306f-44ef-b476-b693b2fa5abf	0		0			0		0		2020-03-30	2020-05-01 22:22:15.538	2020-05-01 22:22:15.538	50da1473-2d7a-4922-9f57-78a513930714	\N
531c8849-27dc-40fd-ad72-645a3c2a2fc3	0		0			0		0		2020-03-31	2020-05-01 22:22:15.55	2020-05-01 22:22:15.55	50da1473-2d7a-4922-9f57-78a513930714	\N
fa1016ff-6975-4b36-9471-2790c12b3dc5	1	Draft messaging for RFP.	0			0		0		2020-04-01	2020-05-01 22:22:15.57	2020-05-01 22:22:15.57	50da1473-2d7a-4922-9f57-78a513930714	\N
5887379d-250e-40f2-96dc-3b05a107572c	0		0			0		0		2020-04-02	2020-05-01 22:22:15.577	2020-05-01 22:22:15.577	50da1473-2d7a-4922-9f57-78a513930714	\N
81e42f4c-39f5-4047-982a-d484773d4c80	0.5	B24 consensus meeting.	0			0		0		2020-04-03	2020-05-01 22:22:15.613	2020-05-01 22:22:15.613	50da1473-2d7a-4922-9f57-78a513930714	\N
58513a0c-d5eb-4a1e-86a2-94c08895ad11	0		0			0		0		2020-04-04	2020-05-01 22:22:15.618	2020-05-01 22:22:15.618	50da1473-2d7a-4922-9f57-78a513930714	\N
feeedf10-782b-4917-b66d-49a457b0f4b1	0		0			0		0		2020-04-05	2020-05-01 22:22:15.623	2020-05-01 22:22:15.623	50da1473-2d7a-4922-9f57-78a513930714	\N
ac869f30-84f4-43b7-9238-3614b3ce7772	2	Review work by PSD-GP and supplement, draft recommendations doc. V0.12 of RFP.	0			0		0		2020-04-20	2020-05-01 21:49:12.273	2020-05-01 22:24:28.184	0b6d5554-79bc-44e3-9616-e70fa33c8e7f	\N
71ea3633-6717-44df-acbe-880529339f52	0		0			0		0		2020-04-20	2020-05-01 21:59:40.432	2020-05-01 22:24:28.433	b88ccd27-1b78-4a22-954b-b93a7ac0e9ab	\N
4571edae-e7e1-40d1-b29a-da68d82f7a95	0		0			0		0		2020-04-21	2020-05-01 21:59:40.438	2020-05-01 22:24:28.507	b88ccd27-1b78-4a22-954b-b93a7ac0e9ab	\N
1f3178a5-ecf4-4133-a98d-04ae3e11bf56	0		0			0		0		2020-04-22	2020-05-01 21:59:40.442	2020-05-01 22:24:28.513	b88ccd27-1b78-4a22-954b-b93a7ac0e9ab	\N
87ed6b02-32bd-4d92-978c-f6e7e397865c	0		0			0		0		2020-04-23	2020-05-01 21:59:40.447	2020-05-01 22:24:28.522	b88ccd27-1b78-4a22-954b-b93a7ac0e9ab	\N
e107a002-378d-401b-adcb-b7b460b9cac9	0.5	Update call with SPO-MB and EE.	0			0		0		2020-04-24	2020-05-01 21:59:40.453	2020-05-01 22:24:28.529	b88ccd27-1b78-4a22-954b-b93a7ac0e9ab	\N
40d916e7-fadd-403a-8666-6e0b7890dc33	0		0			0		0		2020-04-25	2020-05-01 21:59:40.459	2020-05-01 22:24:28.588	b88ccd27-1b78-4a22-954b-b93a7ac0e9ab	\N
95703279-955a-414e-8adf-bf49e9550880	1	B24 consensus meeting. Communications re minimum scores and qualification. Call with IF.	0			0		0		2020-04-06	2020-05-01 22:22:59.361	2020-05-01 22:22:59.361	397a2dd2-2985-48fe-b982-eed0f7c17764	\N
e907547b-d2b7-44f0-b616-397186b012dd	0		0			0		0		2020-04-07	2020-05-01 22:22:59.375	2020-05-01 22:22:59.375	397a2dd2-2985-48fe-b982-eed0f7c17764	\N
23f560dc-b11c-4f55-bb51-450111b3a217	0		0			0		0		2020-04-08	2020-05-01 22:22:59.384	2020-05-01 22:22:59.384	397a2dd2-2985-48fe-b982-eed0f7c17764	\N
a2265f7a-fdc0-4d32-bd3f-0c8a290eadc4	0		0			0		0		2020-04-09	2020-05-01 22:22:59.389	2020-05-01 22:22:59.389	397a2dd2-2985-48fe-b982-eed0f7c17764	\N
bc66ca52-5239-4979-877f-3f360c91eac3	0		0			0		0		2020-04-10	2020-05-01 22:22:59.394	2020-05-01 22:22:59.394	397a2dd2-2985-48fe-b982-eed0f7c17764	\N
992b3425-38fd-4c7b-82cb-e50f5bb7ff4c	0		0			0		0		2020-04-11	2020-05-01 22:22:59.401	2020-05-01 22:22:59.401	397a2dd2-2985-48fe-b982-eed0f7c17764	\N
c20b4df3-726e-4a31-9635-13ac3f9dd846	0		0			0		0		2020-04-12	2020-05-01 22:22:59.419	2020-05-01 22:22:59.419	397a2dd2-2985-48fe-b982-eed0f7c17764	\N
21066a32-ef20-4ca1-ac08-dffe14725a1b	0		0			0		0		2020-04-13	2020-05-01 21:59:23.919	2020-05-01 22:23:25.115	56c544ce-1713-431a-a7ac-49bb4bf0d32b	\N
28ca729d-21aa-480f-bf2a-c05ba7d757c0	0		0			0		0		2020-04-14	2020-05-01 21:59:23.924	2020-05-01 22:23:25.127	56c544ce-1713-431a-a7ac-49bb4bf0d32b	\N
2ada67f7-22b9-4175-96e7-903b6844c240	1	Project updates and communications, with SPO-MB.	0			0		0		2020-04-15	2020-05-01 21:59:23.934	2020-05-01 22:23:25.175	56c544ce-1713-431a-a7ac-49bb4bf0d32b	\N
f529a62b-5da9-4bcb-a229-2299de0ac9a9	0		0			0		0		2020-04-16	2020-05-01 21:59:23.94	2020-05-01 22:23:25.246	56c544ce-1713-431a-a7ac-49bb4bf0d32b	\N
efe8a69e-9261-4c8f-a21a-1be57a586029	0		0			0		0		2020-04-17	2020-05-01 21:59:23.945	2020-05-01 22:23:25.255	56c544ce-1713-431a-a7ac-49bb4bf0d32b	\N
8752c8b1-a0ad-43b7-ac30-545fc08aecf1	0		0			0		0		2020-04-18	2020-05-01 21:59:23.952	2020-05-01 22:23:25.262	56c544ce-1713-431a-a7ac-49bb4bf0d32b	\N
a4951e40-df8d-4d00-b971-780261e3c898	0		0			0		0		2020-04-19	2020-05-01 21:59:23.957	2020-05-01 22:23:25.272	56c544ce-1713-431a-a7ac-49bb4bf0d32b	\N
faf04b9f-4d9d-4f88-ad5c-2af690538bf7	0		0			0		0		2020-04-13	2020-05-01 22:23:25.406	2020-05-01 22:23:25.406	2c77051a-6dc4-46b8-a2be-c7ccacf72253	\N
7a448dee-6442-4d05-b48b-dd45604eb6b2	0		0			0		0		2020-04-14	2020-05-01 22:23:25.413	2020-05-01 22:23:25.413	2c77051a-6dc4-46b8-a2be-c7ccacf72253	\N
435cffba-13b5-4fc5-8574-4f71485ccd1a	0		0			0		0		2020-04-15	2020-05-01 22:23:25.417	2020-05-01 22:23:25.417	2c77051a-6dc4-46b8-a2be-c7ccacf72253	\N
1adf76b7-0bb4-467c-ab6d-71999b7e120b	0		0			0		0		2020-04-16	2020-05-01 22:23:25.425	2020-05-01 22:23:25.425	2c77051a-6dc4-46b8-a2be-c7ccacf72253	\N
5ce4b815-561a-4b8f-a2f8-b5ea9c3c8ab8	2.5	Draft notifications for RFP. Consensus review meeting.	0			0		0		2020-04-17	2020-05-01 22:23:25.429	2020-05-01 22:23:25.429	2c77051a-6dc4-46b8-a2be-c7ccacf72253	\N
ea9411ed-f901-4989-b8ba-721ab6849d18	0		0			0		0		2020-04-18	2020-05-01 22:23:25.433	2020-05-01 22:23:25.433	2c77051a-6dc4-46b8-a2be-c7ccacf72253	\N
40f0d0bc-85bb-4396-80bf-b18015791ba5	0		0			0		0		2020-04-19	2020-05-01 22:23:25.436	2020-05-01 22:23:25.436	2c77051a-6dc4-46b8-a2be-c7ccacf72253	\N
1de8590f-44d6-4916-a466-7950412303c7	0		0			0		0		2020-04-26	2020-05-01 21:59:40.465	2020-05-01 22:24:28.599	b88ccd27-1b78-4a22-954b-b93a7ac0e9ab	\N
04593b87-82de-4023-a498-d51e13b396ec	2	Finalize and send notifications for RFP.	0			0		0		2020-04-20	2020-05-01 22:24:28.692	2020-05-01 22:24:28.692	6b58746a-124d-4c8a-b9a1-fdb6c5f27374	\N
7195b4cd-b58c-41c7-bbf7-a947a3bb91ad	0.5	Communications and review documentation re reference checks.	0			0		0		2020-04-21	2020-05-01 22:24:28.728	2020-05-01 22:24:28.728	6b58746a-124d-4c8a-b9a1-fdb6c5f27374	\N
badc7ec4-e0c8-40ff-96c2-711900176c1c	0.5	Communications with vendors on debriefs.	0			0		0		2020-04-22	2020-05-01 22:24:28.733	2020-05-01 22:24:28.733	6b58746a-124d-4c8a-b9a1-fdb6c5f27374	\N
b8b86a68-072c-4509-bd7c-3e7059002cc0	0		0			0		0		2020-04-23	2020-05-01 22:24:28.738	2020-05-01 22:24:28.738	6b58746a-124d-4c8a-b9a1-fdb6c5f27374	\N
ac0e6f82-4dfa-491c-aa58-9e70de4002a4	2	Customize debrief script and guidance and provide.	0			0		0		2020-04-24	2020-05-01 22:24:28.743	2020-05-01 22:24:28.743	6b58746a-124d-4c8a-b9a1-fdb6c5f27374	\N
85a83974-b4e9-40f1-8c4f-b8ddce3af41d	0		0			0		0		2020-04-25	2020-05-01 22:24:28.747	2020-05-01 22:24:28.747	6b58746a-124d-4c8a-b9a1-fdb6c5f27374	\N
c914ea8c-d4c1-4e0e-b422-3a9adc5765e3	0		0			0		0		2020-04-26	2020-05-01 22:24:28.765	2020-05-01 22:24:28.765	6b58746a-124d-4c8a-b9a1-fdb6c5f27374	\N
3e394782-fb02-4bb3-9612-5541feea404c	0		0			0		0		2020-03-30	2020-05-02 18:54:06.796	2020-05-02 18:54:06.796	b2aadc11-14b0-4fe2-93a3-3caf5de177a8	\N
4b7a097f-e5e6-478d-b87c-fe14e553da5e	0		0			0		0		2020-03-31	2020-05-02 18:54:06.826	2020-05-02 18:54:06.826	b2aadc11-14b0-4fe2-93a3-3caf5de177a8	\N
aab2cedc-7420-414c-b39c-270b05c1be6a	6	Planning	0			0		0		2020-04-01	2020-05-02 18:54:06.83	2020-05-02 18:54:06.83	b2aadc11-14b0-4fe2-93a3-3caf5de177a8	\N
32aa8815-7733-499a-9340-cf403032d99a	0		0			0		0		2020-04-02	2020-05-02 18:54:06.836	2020-05-02 18:54:06.836	b2aadc11-14b0-4fe2-93a3-3caf5de177a8	\N
34eeae12-66d5-4324-bd63-afef5c1c4e1a	0		0			0		0		2020-04-03	2020-05-02 18:54:06.842	2020-05-02 18:54:06.842	b2aadc11-14b0-4fe2-93a3-3caf5de177a8	\N
b0435dbe-5530-4a08-8b77-e050b9dffc1c	0		0			0		0		2020-04-04	2020-05-02 18:54:06.846	2020-05-02 18:54:06.846	b2aadc11-14b0-4fe2-93a3-3caf5de177a8	\N
dc105078-796a-4ff5-bc27-b6cf4571b4d1	0		0			0		0		2020-04-05	2020-05-02 18:54:06.852	2020-05-02 18:54:06.852	b2aadc11-14b0-4fe2-93a3-3caf5de177a8	\N
7e5821a4-7d42-4b40-a11b-19cb55632d93	0		0			0		0		2020-04-06	2020-05-02 18:56:22.861	2020-05-02 18:56:22.861	60155bee-49ed-42dc-8d93-d84c89cf72af	\N
92647132-5f02-49df-a633-bca54b658272	0		0			0		0		2020-04-07	2020-05-02 18:56:22.883	2020-05-02 18:56:22.883	60155bee-49ed-42dc-8d93-d84c89cf72af	\N
e8203f73-5e3c-48fd-a043-84c4d550d5e8	0		0			0		0		2020-04-08	2020-05-02 18:56:22.917	2020-05-02 18:56:22.917	60155bee-49ed-42dc-8d93-d84c89cf72af	\N
ad926f43-6b68-4b0e-8132-17e341d8247d	0.5	Client Meeting 11:30-12 Geoff high level review	0			0		0		2020-04-09	2020-05-02 18:56:22.922	2020-05-02 18:56:22.922	60155bee-49ed-42dc-8d93-d84c89cf72af	\N
763f78d4-0fae-4e7b-b9d0-8abe9da4a65f	0		0			0		0		2020-04-10	2020-05-02 18:56:22.927	2020-05-02 18:56:22.927	60155bee-49ed-42dc-8d93-d84c89cf72af	\N
476550cc-4228-4d73-ab0f-16bc24f9dc0e	0		0			0		0		2020-04-11	2020-05-02 18:56:22.931	2020-05-02 18:56:22.931	60155bee-49ed-42dc-8d93-d84c89cf72af	\N
4f822f2b-53e4-4f08-a0ff-f4e3f44f539e	0		0			0		0		2020-04-12	2020-05-02 18:56:22.937	2020-05-02 18:56:22.937	60155bee-49ed-42dc-8d93-d84c89cf72af	\N
8d13e98f-79d2-4f67-b208-3dca995cd0c1	0		0			0		0		2020-04-13	2020-05-02 18:58:39.862	2020-05-02 18:58:39.862	bfa2f49b-0a7b-476c-8c69-e8fbb17b7e97	\N
cb5d3d0e-00ec-4ca9-9455-0cc4f48f5a4c	0		0			0		0		2020-04-14	2020-05-02 18:58:39.868	2020-05-02 18:58:39.868	bfa2f49b-0a7b-476c-8c69-e8fbb17b7e97	\N
71838a97-18b0-4ab9-b792-4a55dd81587a	2	Document Review - 1-3 Arlin review of RFP	0			0		0		2020-04-15	2020-05-02 18:58:39.873	2020-05-02 18:58:39.873	bfa2f49b-0a7b-476c-8c69-e8fbb17b7e97	\N
f12d1541-2226-4eb5-a9dd-c80d21200156	0		0			0		0		2020-04-16	2020-05-02 18:58:39.879	2020-05-02 18:58:39.879	bfa2f49b-0a7b-476c-8c69-e8fbb17b7e97	\N
cbe34628-88fa-4682-a368-82f08acee32a	1	PSB Meeting - 9:30-10:30 Ralph, Laura - touch base and review of draft RFP	0			0		0		2020-04-17	2020-05-02 18:58:39.883	2020-05-02 18:58:39.883	bfa2f49b-0a7b-476c-8c69-e8fbb17b7e97	\N
460a94f7-a61a-4d29-a1e6-ce6260050fb5	0		0			0		0		2020-04-18	2020-05-02 18:58:39.889	2020-05-02 18:58:39.889	bfa2f49b-0a7b-476c-8c69-e8fbb17b7e97	\N
89764d5b-f732-43e2-a1a3-f758caf4fb55	0		0			0		0		2020-04-19	2020-05-02 18:58:39.896	2020-05-02 18:58:39.896	bfa2f49b-0a7b-476c-8c69-e8fbb17b7e97	\N
fda29111-f5b6-43c7-823c-d5d3b2b5803a	1	Client Meeting - 1:30-2:30 Geoff, Allan, Ralph, Laura, Michelle - review of draft RFP	0			0		0		2020-04-20	2020-05-02 19:00:57.333	2020-05-02 19:00:57.333	1a18982b-3172-4ccc-b33c-38fad45d5444	\N
f598a5dd-3b97-498f-916d-b82b0cf6ef48	0		0			0		0		2020-04-21	2020-05-02 19:00:57.343	2020-05-02 19:00:57.343	1a18982b-3172-4ccc-b33c-38fad45d5444	\N
652053bd-4f9d-40aa-93d4-7f6a995cfd7c	3	PSB Meeting - 9:30-10:30 Ralph review and markup draft; 1-3 Drafted Implementation section  Meeting with Ralph 2-3 Appendix A – re-written Finalize changes to above and email Geoff	0			0		0		2020-04-22	2020-05-02 19:00:57.35	2020-05-02 19:00:57.35	1a18982b-3172-4ccc-b33c-38fad45d5444	\N
2aeadc2b-4683-41a0-ba4c-3f4471947c7b	0		0			0		0		2020-04-23	2020-05-02 19:00:57.37	2020-05-02 19:00:57.37	1a18982b-3172-4ccc-b33c-38fad45d5444	\N
dd26b0c8-1b40-426e-92e8-b389e2e55d3d	0		0			0		0		2020-04-24	2020-05-02 19:00:57.377	2020-05-02 19:00:57.377	1a18982b-3172-4ccc-b33c-38fad45d5444	\N
fc637ccf-02a0-4780-b660-3ebe9ce7cafc	0		0			0		0		2020-04-25	2020-05-02 19:00:57.382	2020-05-02 19:00:57.382	1a18982b-3172-4ccc-b33c-38fad45d5444	\N
9c8ad6c4-0195-4969-a085-bb55a1f876c5	0		0			0		0		2020-04-26	2020-05-02 19:00:57.391	2020-05-02 19:00:57.391	1a18982b-3172-4ccc-b33c-38fad45d5444	\N
f0f99560-f64c-4cac-94a9-a1def00db2eb	0		0			0		0		2020-04-27	2020-05-02 19:04:19.35	2020-05-02 19:04:19.35	8fd2c50c-8510-4548-abea-7f7003368eab	\N
e466a012-12cb-4d48-ae0f-56b95c6e39cd	3.5	10-11:30 Ralph, Laura Reviewed the RFP prior to meeting Geoff and Allan; Client Meeting 11:30-1:30 Geoff, Ralph, Laura - review of RFP	0			0		0		2020-04-28	2020-05-02 19:04:19.358	2020-05-02 19:04:19.358	8fd2c50c-8510-4548-abea-7f7003368eab	\N
22d214eb-f921-4335-a864-773dba806f97	0.5	LSB - 10-10:30 - draft legal engagement document and submit to LSB	0			0		0		2020-04-29	2020-05-02 19:04:19.362	2020-05-02 19:04:19.362	8fd2c50c-8510-4548-abea-7f7003368eab	\N
e93a3a93-7bd9-4632-8c10-face2a71d244	2	PSB - 1-3 Draft Section 5.1 for RFP	0			0		0		2020-04-30	2020-05-02 19:04:19.366	2020-05-02 19:04:19.366	8fd2c50c-8510-4548-abea-7f7003368eab	\N
1ab22678-25ee-4c4c-9afd-3b784cd3289b	0		0			0		0		2020-05-01	2020-05-02 19:04:19.375	2020-05-02 19:04:19.375	8fd2c50c-8510-4548-abea-7f7003368eab	\N
8be926d9-4656-47cc-a631-61b9debd21e2	0		0			0		0		2020-05-02	2020-05-02 19:04:19.379	2020-05-02 19:04:19.379	8fd2c50c-8510-4548-abea-7f7003368eab	\N
fc3478ab-48a5-418d-948e-a4a8b39426e4	0		0			0		0		2020-05-03	2020-05-02 19:04:19.383	2020-05-02 19:04:19.383	8fd2c50c-8510-4548-abea-7f7003368eab	\N
5eb8743d-bfe4-4118-8ea0-48ca5b72efc6	0		0			0		0		2020-03-30	2020-05-05 17:26:22.041	2020-05-05 17:28:16.795	5d82bd4c-1f91-427f-9a2a-8c766b858891	\N
db245710-dd95-47d7-bf4c-798ea940d3f6	0		0			0		0		2020-03-31	2020-05-05 17:26:22.048	2020-05-05 17:28:16.824	5d82bd4c-1f91-427f-9a2a-8c766b858891	\N
9b7dbe85-abf8-4357-87b8-14500c0cbd09	1	Session with LSB, drafting RFP	0			0		0		2020-04-01	2020-05-05 17:26:22.056	2020-05-05 17:28:16.83	5d82bd4c-1f91-427f-9a2a-8c766b858891	\N
0b81728b-5a2b-4524-9773-3532a73561cb	0		0			0		0		2020-04-02	2020-05-05 17:26:22.08	2020-05-05 17:28:16.838	5d82bd4c-1f91-427f-9a2a-8c766b858891	\N
68ad91fd-209a-4b74-bfe0-6830e81c1a7e	0		0			0		0		2020-04-03	2020-05-05 17:26:22.111	2020-05-05 17:28:16.844	5d82bd4c-1f91-427f-9a2a-8c766b858891	\N
f41f0997-cff5-4b65-bf1c-6c35fe6efff3	0		0			0		0		2020-04-04	2020-05-05 17:26:22.117	2020-05-05 17:28:16.853	5d82bd4c-1f91-427f-9a2a-8c766b858891	\N
7d761add-e686-4ae3-9600-a21d56ab9c30	0		0			0		0		2020-04-05	2020-05-05 17:26:22.123	2020-05-05 17:28:16.869	5d82bd4c-1f91-427f-9a2a-8c766b858891	\N
dc7451a2-6f16-48f5-88ef-0dc1b2b46cd8	2.75	Meeting with LSB, drafting session	0			0		0		2020-04-27	2020-05-05 17:32:47.139	2020-05-05 17:32:47.139	4cef45e4-466a-4dab-975b-53d6bf99552b	\N
e17c07db-dfa2-4a26-b5c9-311a5825dffc	2	Drafting RFP	0			0		0		2020-04-28	2020-05-05 17:32:47.158	2020-05-05 17:32:47.158	4cef45e4-466a-4dab-975b-53d6bf99552b	\N
c21981c0-0041-46bc-8ff1-6d4732386035	0		0			0		0		2020-04-29	2020-05-05 17:32:47.167	2020-05-05 17:32:47.167	4cef45e4-466a-4dab-975b-53d6bf99552b	\N
37aeb72f-8426-4d9f-982d-7cd01412b1af	3.5	Meeting with LSB, drafting session	0			0		0		2020-04-30	2020-05-05 17:32:47.191	2020-05-05 17:32:47.191	4cef45e4-466a-4dab-975b-53d6bf99552b	\N
c4a2ab7e-0f5d-4458-b325-2a12cdbd200f	0		0			0		0		2020-05-01	2020-05-05 17:32:47.251	2020-05-05 17:32:47.251	4cef45e4-466a-4dab-975b-53d6bf99552b	\N
5f342edb-9207-4aae-a566-372672d9bedc	0		0			0		0		2020-05-02	2020-05-05 17:32:47.257	2020-05-05 17:32:47.257	4cef45e4-466a-4dab-975b-53d6bf99552b	\N
a7e50568-a2ad-4bd1-a6b5-e2f57ac529c7	0		0			0		0		2020-05-03	2020-05-05 17:32:47.262	2020-05-05 17:32:47.262	4cef45e4-466a-4dab-975b-53d6bf99552b	\N
b85fd9b9-7ba6-463a-a011-6ac1e543f482	0		0			0		0		2020-05-04	2020-05-06 21:13:33.794	2020-05-06 21:13:33.794	9920c8f9-6193-476d-88c4-3ffa4f9b4a94	\N
c711d869-dce3-47a4-b597-f12e38bb9623	2	Review v0.13 of RFP, coordinate with LSB for procurement legal review.	0			0		0		2020-05-05	2020-05-06 21:13:33.824	2020-05-06 21:13:33.824	9920c8f9-6193-476d-88c4-3ffa4f9b4a94	\N
a61a3f3d-691c-434c-9d1d-41d6803e510d	0		0			0		0		2020-05-06	2020-05-06 21:13:33.832	2020-05-06 21:13:33.832	9920c8f9-6193-476d-88c4-3ffa4f9b4a94	\N
ca1668fe-436f-4bee-8325-79cc4f2b717a	0		0			0		0		2020-05-07	2020-05-06 21:13:33.839	2020-05-06 21:13:33.839	9920c8f9-6193-476d-88c4-3ffa4f9b4a94	\N
05c517b5-b237-4505-97bb-7b4027e53992	0		0			0		0		2020-05-08	2020-05-06 21:13:33.847	2020-05-06 21:13:33.847	9920c8f9-6193-476d-88c4-3ffa4f9b4a94	\N
ab805abd-06bf-4adb-9753-b8fee34f9e39	0		0			0		0		2020-05-09	2020-05-06 21:13:33.852	2020-05-06 21:13:33.852	9920c8f9-6193-476d-88c4-3ffa4f9b4a94	\N
707ed648-4a4a-47a3-8a8b-506e1bb6bab4	0		0			0		0		2020-05-10	2020-05-06 21:13:33.859	2020-05-06 21:13:33.859	9920c8f9-6193-476d-88c4-3ffa4f9b4a94	\N
e5b00203-91ef-47e8-9ccc-f4a8b08bb007	0		0			0		0		2020-05-04	2020-05-07 18:19:14.105	2020-05-07 18:19:14.105	5d282e13-db8d-4fad-9ebd-73b56f80e0fd	\N
ce6a6963-0bbf-4602-b55c-3f4a156773cf	0		0			0		0		2020-05-05	2020-05-07 18:19:14.115	2020-05-07 18:19:14.115	5d282e13-db8d-4fad-9ebd-73b56f80e0fd	\N
aaeeef46-6729-420d-8180-59ca538b97a4	0		0			0		0		2020-05-06	2020-05-07 18:19:14.12	2020-05-07 18:19:14.12	5d282e13-db8d-4fad-9ebd-73b56f80e0fd	\N
3abfe062-889d-46ee-93ef-ea94b94adaae	2	drafting with LSB	0			0		0		2020-05-07	2020-05-07 18:19:14.125	2020-05-07 18:19:14.125	5d282e13-db8d-4fad-9ebd-73b56f80e0fd	\N
ec3a1c55-9bbf-46c0-a309-10f720e2767c	0		0			0		0		2020-05-08	2020-05-07 18:19:14.13	2020-05-07 18:19:14.13	5d282e13-db8d-4fad-9ebd-73b56f80e0fd	\N
7b21e9f2-cdb7-4a8a-807c-6644d01b2295	0		0			0		0		2020-05-09	2020-05-07 18:19:14.137	2020-05-07 18:19:14.137	5d282e13-db8d-4fad-9ebd-73b56f80e0fd	\N
99dab39a-c231-41ca-99a3-bc27467c75aa	0		0			0		0		2020-05-10	2020-05-07 18:19:14.141	2020-05-07 18:19:14.141	5d282e13-db8d-4fad-9ebd-73b56f80e0fd	\N
1f3e43d5-6d26-4b78-9d8c-1980ebc185ff	0		0			0		0		2020-05-04	2020-05-08 17:15:14.035	2020-05-08 17:15:14.035	6c72b31c-6ffd-4618-8c78-fad1531f6eb6	\N
283d5030-e81f-4576-a83a-04ef4899d9cc	1	RFP weight and mandatories discussion	0			0		0		2020-05-05	2020-05-08 17:15:14.044	2020-05-08 17:15:14.044	6c72b31c-6ffd-4618-8c78-fad1531f6eb6	\N
e9dc92f5-efe7-44d1-903c-4c80ef1082a7	2	RFP draft review 	0			0		0		2020-05-06	2020-05-08 17:15:14.049	2020-05-08 17:15:14.049	6c72b31c-6ffd-4618-8c78-fad1531f6eb6	\N
b1167a3e-441b-4002-8433-451e496e320d	1.5	weekly call and review	0			0		0		2020-05-07	2020-05-08 17:15:14.053	2020-05-08 17:15:14.053	6c72b31c-6ffd-4618-8c78-fad1531f6eb6	\N
04787e48-7db0-49af-b286-7abc02e23594	0.5	RFP leadership discussion	0			0		0		2020-05-08	2020-05-08 17:15:14.061	2020-05-08 17:15:14.061	6c72b31c-6ffd-4618-8c78-fad1531f6eb6	\N
f99d2893-d354-4baa-baa0-e3460d0afd02	0		0			0		0		2020-05-09	2020-05-08 17:15:14.066	2020-05-08 17:15:14.066	6c72b31c-6ffd-4618-8c78-fad1531f6eb6	\N
c0f32a1a-f080-4d5e-a000-c694f8c8abcd	0		0			0		0		2020-05-10	2020-05-08 17:15:14.07	2020-05-08 17:15:14.07	6c72b31c-6ffd-4618-8c78-fad1531f6eb6	\N
458f9fe5-06c7-4b81-b039-0f36df428ed2	0		0			0		\N		2020-05-11	2020-05-12 23:04:52.595	2020-05-12 23:04:52.595	db3e1c21-f328-40f4-bc90-6cbb5e676f08	0
09a17fca-8699-48f5-801d-3173b8e82cf0	2	Staffing and BIA Discussions 	0			0		\N		2020-05-12	2020-05-12 23:04:52.602	2020-05-12 23:04:52.602	db3e1c21-f328-40f4-bc90-6cbb5e676f08	0
d0c95984-f8d6-4cb5-921a-78f5de344038	0		0			0		\N		2020-05-13	2020-05-12 23:04:52.609	2020-05-12 23:04:52.609	db3e1c21-f328-40f4-bc90-6cbb5e676f08	0
ec78b1e1-1c98-47bf-801a-ca1d443a7301	0		0			0		\N		2020-05-14	2020-05-12 23:04:52.612	2020-05-12 23:04:52.612	db3e1c21-f328-40f4-bc90-6cbb5e676f08	0
710d3399-6f89-428e-8d37-371511a69019	0		0			0		\N		2020-05-15	2020-05-12 23:04:52.616	2020-05-12 23:04:52.616	db3e1c21-f328-40f4-bc90-6cbb5e676f08	0
a773f621-e4fd-40a2-9a71-e7bfd3b66629	0		0			0		\N		2020-05-16	2020-05-12 23:04:52.621	2020-05-12 23:04:52.621	db3e1c21-f328-40f4-bc90-6cbb5e676f08	0
05d6e8e8-61a4-438e-85fb-bc9d4b770464	0		0			0		\N		2020-05-17	2020-05-12 23:04:52.625	2020-05-12 23:04:52.625	db3e1c21-f328-40f4-bc90-6cbb5e676f08	0
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
3778745c-f1c5-4013-ae07-75bd4798ea32	e7e121ec-a1b0-420d-bc43-1b9fdb71134a	PSB_Admin	fe44dc3c-0b4a-49f8-9fa1-7d64d8ce5af2
915dbc07-9e45-4ec8-ac12-7586fb9ba033	0b35bfd0-8ac5-4773-be79-976fe96efa1b	PSB_User	b38c0700-bb0a-4187-98ce-5bd24499690c
ed2b45dd-7d4a-4285-ba11-5c8b96e69f9e	9e3fba08-1384-4491-ac48-d55738f65271	PSB_Admin	8ad10ad8-910c-4ab3-9a2e-5163fffd500a
2d99034e-ba45-4768-87e1-e76c1a72d5eb	b99fe2ec-fafc-4ec4-bf42-55fdcb5e85aa	PSB_Admin	67726f2e-e5e1-4f88-8468-4c49339d5f20
de668528-47dd-4cd1-ad15-a6b792432674	b07feaec-9939-4449-b4b3-eeb376cef39e	PSB_Admin	8a03f761-d645-4744-913b-1ca4b65c2713
84585edf-d868-4955-8a6e-1004d5275d70	39831bda-d8c6-4c26-b928-7f00dfe93045	PSB_Admin	6cccbbc4-54d6-4949-a968-0a7b01ad97bf
8880f74e-e2e5-4646-bd80-b285d653d0c2	6cfc509a-a77b-49d3-8d80-5490cdb5ea21	PSB_User	09776d13-f896-423e-94f6-903a5c9af8be
057ce701-b6ab-4e56-a352-acf238b6b814	e5424cab-85ca-46f0-9da9-4b4d417bebca	PSB_Admin	209e4fd9-f155-47c6-b773-c609327f8462
5e31b9fb-4850-4c47-8563-3960b7ea9515	591f6a53-904f-49c0-b0be-eb7f8bd6e8fa	PSB_User	5c9e2d49-6b25-44c3-88ab-0286f0347805
b7348fbc-8fee-4e06-9554-4ea0010b88f3	591f6a53-904f-49c0-b0be-eb7f8bd6e8fa	PSB_User	fb6513eb-fff0-4fe6-905b-d59805b0350d
8772c7cd-4206-48e7-8b24-3cb2142bfcbf	591f6a53-904f-49c0-b0be-eb7f8bd6e8fa	PSB_User	462ca0fb-952a-4fe4-88cf-74dc5160c020
1a9a67d9-7d08-4d5b-ac67-82a044a1abfd	dc0dbe50-d889-498c-b23b-f9c6476cbf81	PSB_User	b2b89293-3366-43e1-a5a7-a4c545ac307b
bc8957ee-bb1c-4578-8d23-bd9c36b19588	e7f5156d-7d1d-4529-8171-b72357d7d149	PSB_Admin	1c96d744-fd6d-4b85-8a65-d2689dcb1d20
e680f91f-04d9-4dfb-b2d2-47ae485afb0d	64a0be35-0845-456d-af7e-eb1ff8e2e6e3	PSB_User	32ecf1ef-0ee2-4cb4-a6ea-a2018abcaa1c
8ce3254e-5447-4fd0-816e-d3c2455a753a	0ef6622e-a749-465e-88d1-701977220db3	PSB_User	c1dc29fc-0203-42d5-bc5c-15ac9b615379
\.


--
-- Name: mou_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mou_id_seq', 40, true);


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

