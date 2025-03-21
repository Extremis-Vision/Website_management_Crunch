--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10 (Debian 15.10-1.pgdg120+1)
-- Dumped by pg_dump version 15.10 (Debian 15.10-1.pgdg120+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: commande; Type: TABLE; Schema: public; Owner: testuser
--

CREATE TABLE public.commande (
    id_commande integer NOT NULL,
    date_hour timestamp without time zone NOT NULL,
    id_groupe integer NOT NULL
);


ALTER TABLE public.commande OWNER TO testuser;

--
-- Name: commande_id_commande_seq; Type: SEQUENCE; Schema: public; Owner: testuser
--

CREATE SEQUENCE public.commande_id_commande_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commande_id_commande_seq OWNER TO testuser;

--
-- Name: commande_id_commande_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testuser
--

ALTER SEQUENCE public.commande_id_commande_seq OWNED BY public.commande.id_commande;


--
-- Name: groupe; Type: TABLE; Schema: public; Owner: testuser
--

CREATE TABLE public.groupe (
    id_groupe integer NOT NULL,
    "table" character varying(100) NOT NULL,
    "Nom" character varying(100) NOT NULL,
    "Prenom" character varying(100) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.groupe OWNER TO testuser;

--
-- Name: groupe_id_groupe_seq; Type: SEQUENCE; Schema: public; Owner: testuser
--

CREATE SEQUENCE public.groupe_id_groupe_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groupe_id_groupe_seq OWNER TO testuser;

--
-- Name: groupe_id_groupe_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testuser
--

ALTER SEQUENCE public.groupe_id_groupe_seq OWNED BY public.groupe.id_groupe;


--
-- Name: items; Type: TABLE; Schema: public; Owner: testuser
--

CREATE TABLE public.items (
    id_cart integer NOT NULL,
    id_commande integer NOT NULL,
    status character varying(100) NOT NULL,
    nom character varying(100) NOT NULL,
    technique character varying(100),
    nombre integer NOT NULL
);


ALTER TABLE public.items OWNER TO testuser;

--
-- Name: items_id_cart_seq; Type: SEQUENCE; Schema: public; Owner: testuser
--

CREATE SEQUENCE public.items_id_cart_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_id_cart_seq OWNER TO testuser;

--
-- Name: items_id_cart_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testuser
--

ALTER SEQUENCE public.items_id_cart_seq OWNED BY public.items.id_cart;


--
-- Name: users; Type: TABLE; Schema: public; Owner: testuser
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(80) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO testuser;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: testuser
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO testuser;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testuser
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: commande id_commande; Type: DEFAULT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.commande ALTER COLUMN id_commande SET DEFAULT nextval('public.commande_id_commande_seq'::regclass);


--
-- Name: groupe id_groupe; Type: DEFAULT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.groupe ALTER COLUMN id_groupe SET DEFAULT nextval('public.groupe_id_groupe_seq'::regclass);


--
-- Name: items id_cart; Type: DEFAULT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.items ALTER COLUMN id_cart SET DEFAULT nextval('public.items_id_cart_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: commande; Type: TABLE DATA; Schema: public; Owner: testuser
--

COPY public.commande (id_commande, date_hour, id_groupe) FROM stdin;
1	2025-03-19 12:17:04.40364	1
2	2025-03-19 12:17:44.364032	2
3	2025-03-19 12:19:21.377791	3
4	2025-03-19 12:24:29.616168	4
5	2025-03-19 12:26:09.430363	5
6	2025-03-19 12:27:20.921355	6
7	2025-03-19 12:30:18.10864	1
8	2025-03-19 12:31:39.360687	8
9	2025-03-19 12:35:34.627425	7
10	2025-03-19 12:38:24.873801	9
11	2025-03-19 13:29:30.31031	10
12	2025-03-19 13:33:03.521828	11
13	2025-03-19 13:34:20.11148	7
14	2025-03-19 13:47:34.364535	12
15	2025-03-19 14:05:17.220838	10
16	2025-03-19 14:22:28.212606	13
17	2025-03-19 14:25:17.866365	1
18	2025-03-19 14:29:51.088988	14
19	2025-03-19 14:35:22.265439	15
20	2025-03-19 14:51:53.613508	16
21	2025-03-19 15:28:03.214404	17
22	2025-03-19 15:56:15.262546	18
23	2025-03-19 16:37:01.098636	19
24	2025-03-19 16:43:56.139844	20
25	2025-03-19 17:02:37.653208	11
26	2025-03-20 11:52:22.102023	21
27	2025-03-20 12:08:21.59946	22
28	2025-03-20 12:10:53.643119	23
29	2025-03-20 12:40:43.573913	21
30	2025-03-20 12:41:25.162116	25
31	2025-03-20 12:46:36.870926	24
32	2025-03-20 12:47:32.331905	24
33	2025-03-20 12:50:30.576927	24
34	2025-03-20 13:00:13.296592	27
35	2025-03-20 13:00:55.934796	21
36	2025-03-20 13:01:11.055072	28
37	2025-03-20 13:01:30.178907	30
38	2025-03-20 13:01:41.77615	29
39	2025-03-20 13:02:23.792695	31
40	2025-03-20 13:02:56.566366	32
41	2025-03-20 13:03:13.65728	33
42	2025-03-20 13:03:46.771482	34
43	2025-03-20 13:04:45.257768	35
44	2025-03-20 13:05:09.059265	36
45	2025-03-20 13:05:22.765842	30
46	2025-03-20 13:06:10.52439	21
47	2025-03-20 13:07:20.990276	37
48	2025-03-20 13:09:04.935281	41
49	2025-03-20 13:09:30.281796	39
50	2025-03-20 13:09:57.346507	40
51	2025-03-20 13:10:44.82559	44
52	2025-03-20 13:10:52.947648	42
53	2025-03-20 13:11:22.934681	43
54	2025-03-20 13:11:44.336172	21
55	2025-03-20 13:12:16.391975	46
56	2025-03-20 13:12:22.552368	47
57	2025-03-20 13:14:16.593399	21
58	2025-03-20 13:14:25.089457	50
59	2025-03-20 13:14:36.973038	45
60	2025-03-20 13:15:09.396197	49
61	2025-03-20 13:15:57.350673	48
62	2025-03-20 13:16:58.181952	52
63	2025-03-20 13:17:24.173011	51
64	2025-03-20 13:18:08.172281	53
65	2025-03-20 13:18:25.459206	55
66	2025-03-20 13:18:38.873814	21
67	2025-03-20 13:19:07.663837	57
68	2025-03-20 13:20:08.028956	28
69	2025-03-20 13:20:25.175942	58
70	2025-03-20 13:22:15.407696	21
71	2025-03-20 13:22:19.037946	52
72	2025-03-20 13:22:31.058254	61
73	2025-03-20 13:22:50.753365	59
74	2025-03-20 13:23:33.401195	62
75	2025-03-20 13:24:52.616879	64
76	2025-03-20 13:24:56.004572	21
77	2025-03-20 13:25:04.773001	67
78	2025-03-20 13:25:10.445244	63
79	2025-03-20 13:26:16.400453	21
80	2025-03-20 13:26:17.22504	65
81	2025-03-20 13:26:21.164798	58
82	2025-03-20 13:26:59.375471	69
83	2025-03-20 13:28:28.77148	71
84	2025-03-20 13:29:26.681044	21
85	2025-03-20 13:31:01.167977	73
86	2025-03-20 13:32:23.429784	72
87	2025-03-20 13:32:52.178455	74
88	2025-03-20 13:33:37.743677	21
89	2025-03-20 13:33:47.679859	76
90	2025-03-20 13:34:22.508493	75
91	2025-03-20 13:35:54.720394	78
92	2025-03-20 13:36:29.872034	58
93	2025-03-20 13:36:58.724522	80
94	2025-03-20 13:37:34.293401	79
95	2025-03-20 13:38:09.190085	82
96	2025-03-20 13:38:13.831462	21
97	2025-03-20 13:39:39.290371	83
98	2025-03-20 13:40:37.292059	84
99	2025-03-20 13:41:38.713788	86
100	2025-03-20 13:42:37.869392	87
101	2025-03-20 13:43:21.685782	88
102	2025-03-20 13:44:04.728889	85
103	2025-03-20 13:44:48.758027	21
104	2025-03-20 13:45:05.797085	56
105	2025-03-20 13:46:02.896553	89
106	2025-03-20 13:46:40.208426	91
107	2025-03-20 13:47:43.416775	90
108	2025-03-20 13:47:58.810913	81
109	2025-03-20 13:48:06.429953	94
110	2025-03-20 13:48:15.487662	93
111	2025-03-20 13:48:19.353308	92
112	2025-03-20 13:49:52.924943	95
113	2025-03-20 13:51:42.370872	96
114	2025-03-20 13:57:34.442879	97
115	2025-03-20 13:58:51.421803	28
116	2025-03-20 14:02:16.798211	98
117	2025-03-20 14:04:50.121398	99
118	2025-03-20 14:06:40.021724	21
119	2025-03-20 14:08:18.106916	21
120	2025-03-20 14:09:25.876448	70
121	2025-03-20 14:14:03.600964	102
122	2025-03-20 14:19:05.08999	103
123	2025-03-20 14:24:21.637663	105
124	2025-03-20 14:26:51.515007	107
125	2025-03-20 14:28:23.069291	106
126	2025-03-20 14:34:15.07922	108
127	2025-03-20 14:36:18.314527	109
128	2025-03-20 14:49:27.481294	111
129	2025-03-20 14:50:49.617386	112
130	2025-03-20 14:51:03.116909	110
131	2025-03-20 14:52:37.820418	113
132	2025-03-20 14:53:05.040477	21
133	2025-03-20 14:55:02.801369	115
134	2025-03-20 14:55:47.51138	116
135	2025-03-20 14:56:35.827078	114
136	2025-03-20 14:59:32.179344	117
137	2025-03-20 15:02:19.442906	118
138	2025-03-20 15:02:43.10142	119
139	2025-03-20 15:07:44.229634	120
140	2025-03-20 15:13:20.104193	121
141	2025-03-20 15:14:59.672136	122
142	2025-03-20 15:25:19.150017	123
143	2025-03-20 15:27:50.794413	124
144	2025-03-20 15:29:00.833497	10
145	2025-03-20 15:30:49.311673	125
146	2025-03-20 15:42:20.073513	126
147	2025-03-20 15:57:59.596032	127
148	2025-03-20 16:04:47.431734	129
149	2025-03-20 16:04:59.646681	128
150	2025-03-20 16:29:39.153725	21
151	2025-03-20 16:39:59.593517	130
152	2025-03-20 16:46:54.60251	131
153	2025-03-20 16:55:20.909977	132
\.


--
-- Data for Name: groupe; Type: TABLE DATA; Schema: public; Owner: testuser
--

COPY public.groupe (id_groupe, "table", "Nom", "Prenom", user_id) FROM stdin;
1	F10	Furon	Justin	1
2	Ludo Tech	Ludo Tech	Ludo Tech	1
3	Ludo Tech	Grégoire	Pierre	1
4	G02	Roelandt	Nicolas	1
5	A09	Leperff	Siméon	1
6	C03	Forget	Robin	1
7	B18	El Andaloussi	Nizar	1
8	B17	Perito	Maïssane	1
9	C22	Noël	Gauthier	1
10	G04	Pluchon	Konn	1
11	D14	Lomas	Kelsey	1
12	C25	Mokhbi	Mehdi	1
13	C04	Braizat	Paola	1
14	C18	Prignot	Matthis	1
15	C11	Bureau du 	Tanguy	1
17	a26	Fosset	Thibault	1
18	D17	Burgos	Flavio	1
19	C10	Poos	Kentin	1
20	C02	Julliere	Paul	1
21	Z12	BEDIER	Léane	2
22	Z13	LESNE	Samuel	2
23	Z15	BIDULE	Machin	2
24	A09	LE PERFF	Siméon	2
25	C28	CLANCHE	Raphaël	2
26	C11	JORDAN	Elouan	2
27	D14	Piton	Malo	2
28	D13	Chabannes	Manon	2
29	D14	SIGRIST	Luc	2
30	E13	CIRITCI	Kadir	2
31	D7	PARIS	Ceylan	2
32	C20	PEREIRA	Elise	2
33	C24	Galasso	Emilie	2
34	D14	TSOPFACK	Morele	2
35	C17	BECQUET	Maxime	2
36	D10	AMAMA	Firas	2
37	E28	QUANG	Nicolas	2
38	D7	Droxler	Bastien	2
39	E11	Gabriel	Bastien	2
40	B4	MUNCH	Raphael	2
41	C14	Rouleau monpiou	Niels	2
42	F07	Hannad	Nesrine	2
43	G04	GIRAULT	IRVIN	2
44	A16	Chaouache	Julien	2
45	C25	Wiber	Albane	2
46	D6	Lefaivre	Nathan	2
47	D06	RANDRIA	Thimothé	2
48	D01	DIAGNE	Abdoulkarim	2
49	A23	Wadel	Vincent	2
50	D06	Boni	Mattéo	2
51	C22	Le roux 	Violette	2
52	E05	GRACIA	Alban	2
53	B16	Grosjean	Camerone	1
54	C19	BIELDERMAN	Clément	2
55	C19	BIELDERMAN	Clément	2
56	E21	brun	hugo	2
57	G01	SANDT	Romain	2
58	B12	GAUDARD	Alix	2
59	D03	BOEUF	Laurette	2
60	F3	Robert	Maxence	2
61	G01	Jahhsin	Wang	2
62	A28	RAMILLON--EHRMANN	Simon	2
63	A17	SCHWARTZ	Jean Baptiste	2
64	F3	Guillot	Jules	2
65	B06	Bernard	Arthur	1
66	D6	Lecca	Léonie	2
67	E18	VAN LOOY	Sasha	2
68	E01	GASPARD	Théo	2
69	C16	REMAEL	Celestin	2
70	E28	alim	Raphael	2
71	D04	LE STRAT	Alexis	2
72	A25	PONCET	Flavie	2
73	B17	GODEFROY	Clément	2
74	F9	Zipper	Leonard	2
75	C23	CAUTENET	Manech	2
76	E05	BEN YOUNES	Nadhir	2
77	C22	Farion	Hippolyte	2
78	A25	BARAN ROUSSAS	Marjorie	2
79	A07	SALL	Siuleye	2
80	B18	Mesnier	Cacilia	2
81	E1	Chappuis	Melissa	2
82	C25	BARAT	Baptiste	2
83	D09	Colin	Benjamin	2
84	D11	ZHU	Alexis	2
85	C21	PETIT	Clémence	2
86	E10	GODEFROY	Thibaut	2
87	A11	LOVERA	Romain	2
88	E23	Reiffsteck	Guillaume	2
89	E09	DIEBOLT	Matthieu	2
90	A09	ELFAZOUAND	MOHARN	2
91	D15	FOUREL	Samuel	2
92	C13	BAHLER	Julien	2
93	B19	Bourhaine	Sam	2
94	A16	CHAOUACHE	Julien	2
95	E04	BILAL	Samir	2
96	E15	POTONNIER	Stéphan	2
97	A13	Clerget	Oscar	2
98	E28	Quang	Nicolas	1
99	C15	WIRTH	Théo	2
100	G02	MILENKOVIC	Alen	2
101	E14	Fernandez	Mateo	2
102	B05	GERMAIN	Amélie	2
103	A05	CLAD	Thibaut	2
104	B20	Bernard	Quentin	2
105	E02	BORD	Nathan	2
106	C08	Ameur	Rayane	2
107	G04	MOULAYEABDALA	MOULAYE abdelkarim	2
108	D12	Veschambre	Pierre louis	2
109	D05	DESPORTES	Jerome	2
110	E19	Gomez	Esteban	1
111	E13	DAULNY	Florian	2
112	B08	ZELLER	Mathieu	2
113	B14	GAUTIER	Arthur	2
114	D02	MORIN	Ilona	2
16	C24	Lacroix	Bastien	1
115	B06	THOMAS	Luigi	2
116	A22	METZGER	Valentin	2
117	E19	Girardot	Quentin	2
118	C02	Livet	Valentin	2
119	C16	JAEGLE	Marius	2
120	C06	Delhoume	Thomas	1
121	C04	SIDOUNI	Hajar	2
122	E19	Blonbou	Christophe 	1
123	C25	CHERAMAT	Mohammed	2
124	A19	FIRMAN	Emmy	2
125	E26	BINTI NORAZLAN	NURIN	2
126	G03	DAVE - JONHATHAN	SUAREZ	2
127	C10	FENIE	Anthony	2
128	C11	Bucher	Arthur	2
129	B02	CIFTCI	IZEL	2
130	C26	CHENIOUR	Mehdi	2
131	G02	VIGH	Adam	2
132	B20	MERLE	Mathieu	2
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: testuser
--

COPY public.items (id_cart, id_commande, status, nom, technique, nombre) FROM stdin;
3	1	A rendre	esp 32	None	1
4	1	A rendre	breadboard	None	1
5	3	A rendre	Pile AAA	None	2
6	5	A rendre	Arduino uno	None	1
7	5	A rendre	module ultra son	None	1
8	5	A rendre	câble	None	1
9	5	A rendre	câble usb arduino	None	1
10	5	A rendre	breadboard	None	1
11	6	A rendre	câble micro	None	1
12	6	A rendre	câble arduino	None	1
13	6	A rendre	esp 32	None	1
14	8	A rendre	RFID badge lecteur	None	1
15	8	A rendre	câble usb c	None	1
16	9	A rendre	Capteur CO2	TVOC/eCO2	1
17	9	A rendre	Breadboard	None	1
18	9	A rendre	ventilateur	12v mini	1
19	10	A rendre	Arduino uno	None	1
20	10	A rendre	ESP 32	feather	1
21	10	A rendre	module gps et antenne	None	1
22	10	A rendre	câble micro usb	None	1
23	10	A rendre	câble arduino	None	1
24	10	A rendre	Breadboard	None	1
25	10	A rendre	Led rouge	None	2
26	10	A rendre	Résistance	220 ohm	1
27	1	Rendu	câble micro usb	None	1
28	4	Rendu	LED RGB	None	1
29	4	Rendu	câble	None	1
30	4	Rendu	LED jaune	None	2
31	4	Rendu	arduino uno wifi	None	1
32	4	Rendu	bouton	None	2
33	4	Rendu	câble usb arduino	None	1
34	4	Rendu	buzzer	None	1
35	6	Rendu	arduino wifi	None	1
36	11	A rendre	Ecran rasberry pi	None	1
38	11	A rendre	carte SD	None	1
39	11	A rendre	cable micro usb	None	2
40	11	A rendre	Breadboard	None	1
41	11	A rendre	câble	None	1
42	9	Rendu	Rasberry pi W	None	1
43	9	Rendu	Pi camera v2	None	1
44	9	Rendu	câble micro usb	None	1
45	12	A rendre	arduino nano	None	1
46	12	A rendre	step moteur 5v drvier	None	1
47	12	A rendre	bouton	None	2
48	12	A rendre	câble micro usb	None	1
49	12	A rendre	câble	None	1
50	12	A rendre	breadboard	None	1
52	14	A rendre	arduino uno	None	1
53	14	A rendre	câble usb B	None	1
56	6	A rendre	Esp 32 cam	None	1
57	15	A rendre	alim 12 v	None	1
58	15	A rendre	alim 5v	None	1
59	15	A rendre	bouton 3 état	None	4
61	15	A rendre	digicode	None	1
62	15	A rendre	venntilateur 12v	None	2
63	15	A rendre	Dht  11 capteur	temperature et humidité	1
64	15	A rendre	photorésistance	None	5
65	15	A rendre	câble micro usb	None	1
66	16	A rendre	câble arduino uno	None	1
68	16	A rendre	câble	None	1
70	16	A rendre	capteur de pression	None	1
71	16	A rendre	breadboard	None	1
72	16	A rendre	Breadboard	None	2
73	18	A rendre	servo moteur sg 90	None	2
74	18	A rendre	led rouge	None	1
76	18	A rendre	arduino nano	None	1
77	18	A rendre	resistance	None	1
78	18	A rendre	câble micro usb	None	1
79	18	A rendre	câble	None	1
80	19	A rendre	Breadboard	None	1
81	19	A rendre	câble	None	1
82	19	A rendre	sonde de temperature	None	1
83	19	A rendre	arduino nano	None	1
84	19	A rendre	câble micro usb	None	1
86	20	A rendre	câble usb C	None	2
87	20	A rendre	relais	None	4
88	20	A rendre	alim 12 v	None	1
89	20	A rendre	câble	None	1
91	14	A rendre	capteur infra rouge	NaN	1
96	22	A rendre	arduino uno	None	1
97	22	A rendre	câble usb	None	1
98	22	A rendre	servo	None	2
99	22	A rendre	breadboard	None	1
100	22	A rendre	alim 6v	None	1
101	22	A rendre	accéléromètre	None	1
102	8	A rendre	badge rfid	None	1
103	5	A rendre	ultra son	None	1
104	23	A rendre	breadboard	None	1
105	23	A rendre	moteur dc	None	1
106	23	A rendre	module voltmètre	None	1
107	23	A rendre	module ampère	None	1
108	23	A rendre	esp 32	None	1
109	23	A rendre	câble usb c	None	1
110	23	A rendre	câble	None	1
111	24	A rendre	câble usb arduino uno	None	1
112	24	A rendre	arduino uno	None	1
114	12	A rendre	adapteur secteur 12v	None	1
115	12	A rendre	connecteur jack	None	1
92	14	Rendu	led infra rouge	NaN	1
37	11	A rendre	Rasberry pi 4	None	2
67	16	A rendre	arduino uno 	None	1
113	24	A rendre	actionneur vibrant	None	6
69	16	Rendu	capteur temperature dht 11	None	1
90	16	Rendu	alimentation 5v	None	1
95	21	Rendu	esp 32 type C	None	1
85	20	A rendre	esp 32 beetle	type C	1
2	1	Rendu	Arduino uno	None	1
94	14	Rendu	photoresistance	None	1
54	14	Rendu	câble micro usb b	None	1
51	14	Rendu	arduino nano	None	1
93	14	Rendu	led	None	1
55	14	Rendu	cable M F	None	16
75	18	A rendre	bouton	None	4
116	12	A rendre	TMC2208	None	1
117	4	A rendre	arduino uno	None	1
118	4	A rendre	microphone	None	1
119	4	A rendre	capteur ultra son	None	1
120	11	Rendu	Rasberry pi zero	None	2
121	13	Rendu	Camera IA	AC	1
122	4	A rendre	stepper moteur	None	1
123	4	A rendre	bouton	None	2
124	4	A rendre	câble	None	1
125	4	A rendre	câble arduino	None	1
126	25	A rendre	Bouton 2 états	None	1
127	8	A rendre	arduino uno	None	1
128	8	Rendu	esp 32 dev kit C	None	1
130	13	A rendre	M5 camera	None	1
232	63	Rendu	Ciseaux	\N	2
213	57	A rendre	Feutre	\N	1
219	15	A rendre	Capteur empreite digital M5	\N	1
60	15	Rendu	capteur d'empreinte digitale	None	1
150	24	A rendre	breadboard transparent	\N	1
170	11	A rendre	adaptateur secteur	\N	2
175	11	A rendre	adapateur secteur usb		2
176	11	A rendre	cable usb c		2
180	47	A rendre	Cutter	plaque	1
185	11	A rendre	Domino simple	\N	6
186	11	A rendre	Domino double vis	1 hs	2
203	53	A rendre	petit tournevis plat	\N	1
167	42	Rendu	Cutter	\N	1
162	39	Rendu	Plaque	\N	1
207	55	A rendre	Ciseaux	\N	1
161	39	Rendu	Cutter		1
227	9	A rendre	ESP 32	Feather	1
235	64	A rendre	adaptateur secteur 12v	alim + connecteur	1
236	64	A rendre	relais	\N	1
237	64	A rendre	arduino uno	\N	1
238	64	A rendre	câble usb b arduino	\N	1
239	64	A rendre	capteur dht11 température	\N	1
240	64	A rendre	ventilateur 12v	\N	1
253	70	A rendre	ciseau	\N	1
233	63	Rendu	Feutres	\N	1
254	71	Rendu	règle	\N	1
255	71	Rendu	cutter	\N	1
171	43	Rendu	cutter	\N	1
148	33	Rendu	règle	\N	1
147	32	Rendu	scotch	\N	1
149	30	Rendu	CISEAU	\N	1
143	30	Rendu	plaque	\N	1
142	30	Rendu	Cutter	\N	1
198	51	Rendu	Glue	\N	1
217	59	Rendu	Regle	\N	1
165	41	Rendu	Cutter	\N	1
252	70	Rendu	regle	\N	1
166	41	Rendu	Feutres	\N	1
208	55	Rendu	Scotch	\N	1
206	55	Rendu	Cutter	\N	1
241	65	Rendu	Cutter	\N	1
242	65	Rendu	Ciseaux	\N	1
152	34	Rendu	cutter	\N	1
154	34	Rendu	ciseaux	\N	1
153	34	Rendu	plaque	\N	1
228	62	Rendu	Cutter	\N	1
229	62	Rendu	règle	\N	1
210	56	Rendu	plaque	\N	1
190	49	Rendu	ciseaux	\N	1
192	49	Rendu	feutre	\N	1
191	49	Rendu	cutter	plaque	1
209	56	Rendu	cutter	\N	1
211	56	Rendu	règle	\N	1
196	50	Rendu	plaque	\N	1
212	56	Rendu	ciseaux	\N	1
159	38	Rendu	CISEAUX	\N	1
160	38	Rendu	cutter	\N	1
214	57	Rendu	Cutter	\N	2
215	58	Rendu	Cutter	\N	1
216	58	Rendu	plaque	\N	1
218	58	Rendu	règle	\N	1
129	22	A rendre	Connecteur jack	None	2
247	67	Rendu	compas	\N	1
246	67	Rendu	ciseaux	\N	1
245	67	Rendu	Cuter	\N	1
205	54	Rendu	ciseau	\N	1
146	32	Rendu	ciseaux	\N	1
144	31	Rendu	Cutter	\N	1
145	32	Rendu	plaque		2
204	54	Rendu	feutre	\N	1
181	47	Rendu	marqueur	\N	1
200	52	Rendu	plaque	\N	1
183	43	Rendu	pince plate	\N	1
182	43	Rendu	pince coupante	\N	1
173	43	Rendu	ciseaux	\N	1
172	43	Rendu	plaque	\N	1
184	43	Rendu	règle	\N	1
1	1	Rendu	Arduino nano	None	1
230	63	Rendu	Scotch	\N	1
231	63	Rendu	Cutter		2
179	46	Rendu	Ciseaux	\N	1
201	52	Rendu	ciseaux	\N	1
202	52	Rendu	règle	\N	1
199	52	Rendu	cutter		2
168	42	Rendu	Ciseau	\N	1
169	42	Rendu	plaque	\N	1
178	42	Rendu	REGLE	\N	1
157	37	Rendu	cutter	\N	1
177	45	Rendu	Stylo	\N	1
225	61	Rendu	Règle	grande	1
224	61	Rendu	Ciseaux	\N	1
226	61	Rendu	feutre	\N	1
187	48	Rendu	Cutter	\N	1
223	61	Rendu	Cutter		1
189	48	Rendu	Feutres	\N	1
188	48	Rendu	Ciseau		1
249	69	Rendu	Règles	\N	2
250	69	Rendu	Cutter	\N	2
197	50	Rendu	ciseau	\N	1
195	50	Rendu	equerre	\N	1
222	50	Rendu	Equerre	\N	1
194	50	Rendu	regle	\N	1
193	50	Rendu	cutter	\N	1
251	70	Rendu	cutter	\N	1
163	40	Rendu	CISEAUX	\N	1
164	40	Rendu	règle		1
174	44	Rendu	règle	grande	1
220	60	Rendu	regle	\N	1
279	80	Rendu	arduino uno	\N	1
280	80	Rendu	câble arduino uno	\N	1
287	80	Rendu	led rgb	\N	1
289	82	Rendu	Ciseaux	\N	1
284	80	Rendu	capteur rfid	\N	1
281	80	Rendu	rfid badge	\N	1
282	80	Rendu	rfid carte	\N	1
283	80	Rendu	breadboard	\N	1
286	80	Rendu	buzzer	\N	1
285	80	Rendu	resistance 220 ohm	\N	1
290	62	Rendu	Ciseaux	\N	1
276	63	Rendu	Compas	\N	1
271	76	Rendu	cutter	\N	1
272	77	Rendu	compas	\N	1
264	74	Rendu	ciseaux	\N	1
265	74	Rendu	cutter	\N	1
266	74	Rendu	règle		2
288	81	Rendu	ciseau	\N	1
256	72	Rendu	Cutter	\N	1
257	72	Rendu	Ciseaux	\N	1
258	72	Rendu	Ruller	\N	1
261	23	A rendre	leds	\N	3
262	23	A rendre	Ventilo 12V petits	\N	1
263	23	A rendre	Resistance	\N	3
278	79	A rendre	règle	\N	1
296	47	A rendre	ciseaux	\N	1
291	83	Rendu	règle	\N	1
305	86	A rendre	agrafeuse	\N	1
309	88	A rendre	equerre	\N	1
151	24	A rendre	breadboard longue		1
324	4	A rendre	breadboard	\N	1
327	96	A rendre	marqueur tableau	\N	1
319	72	Rendu	Pince coupante	\N	1
341	6	A rendre	antenne wifi	\N	1
332	97	Rendu	Feutre	\N	1
331	97	Rendu	Regle	\N	1
333	97	Rendu	Ciseaux	\N	1
330	97	Rendu	Cutter	\N	1
321	93	Rendu	Cutter		1
381	18	A rendre	resistance 10K	\N	1
343	59	Rendu	pince coupante	\N	1
352	104	Rendu	scotch brun	\N	1
391	116	A rendre	Breadboard	\N	1
392	116	A rendre	Arduino Uno	\N	1
393	116	A rendre	Boutons classiques	\N	2
394	116	A rendre	Capteur ultra son	MB1000	2
395	116	A rendre	Resistance 220	\N	1
396	116	A rendre	Resistance 100K	\N	1
397	116	A rendre	Capteur Température bleu	\N	1
295	84	Rendu	regle	\N	1
234	63	Rendu	Regle		2
328	96	Rendu	cutter	\N	1
310	89	Rendu	cutter	\N	1
385	47	Rendu	Equerre	\N	1
399	41	Rendu	Ciseaux	\N	1
403	119	A rendre	Cutter	\N	1
405	119	A rendre	Feutre	\N	1
353	105	Rendu	ciseaux	\N	1
368	105	Rendu	compas	\N	1
354	105	Rendu	agraffeuse	\N	1
313	90	Rendu	cutter	\N	2
340	90	Rendu	gros scotch	\N	1
329	90	Rendu	règle	\N	1
376	94	Rendu	Crayons	\N	2
323	94	Rendu	Ciseaux	\N	1
322	94	Rendu	Cutter	\N	1
299	85	Rendu	règle	grande	1
300	85	Rendu	cutter	\N	1
301	85	Rendu	ciseaux	\N	1
259	73	Rendu	cutter	\N	1
260	73	Rendu	ciseaux	\N	1
363	110	Rendu	Regle	\N	1
389	110	Rendu	equerre	\N	1
370	110	Rendu	Cutter	\N	1
362	110	Rendu	Feutre	\N	1
386	115	Rendu	ciseau	\N	1
387	115	Rendu	aggrafeuse		1
311	89	Rendu	règle	\N	1
312	89	Rendu	feutre	\N	1
371	89	Rendu	ciseau	\N	1
390	75	Rendu	Scotch	\N	1
268	75	Rendu	Cutter	\N	1
269	75	Rendu	Regle	\N	1
267	75	Rendu	Ciseaux	\N	1
383	114	Rendu	Cutter	\N	1
384	114	Rendu	plaque	\N	1
360	109	Rendu	ciseaux	\N	1
335	72	Rendu	gros scotch	\N	1
344	101	Rendu	Cutter	\N	1
345	101	Rendu	Feutre	\N	1
346	101	Rendu	Regle	\N	1
388	107	Rendu	ciseaux	\N	1
356	107	Rendu	cutter	\N	1
357	107	Rendu	règle	\N	1
358	108	Rendu	ciseau	\N	1
406	119	Rendu	Scotch	\N	1
273	78	Rendu	Cutter	\N	1
274	78	Rendu	Feutre	\N	1
275	78	Rendu	regle	grande	1
366	78	Rendu	scotch brun	\N	1
365	78	Rendu	ciseau	\N	1
294	84	Rendu	scotsch	\N	1
297	43	Rendu	Scotch	\N	1
314	43	Rendu	Cutter	\N	1
315	91	Rendu	cutter	\N	1
402	91	Rendu	Agrafeuse	\N	1
317	91	Rendu	règle	\N	1
325	95	Rendu	cutter	\N	1
326	95	Rendu	ciseaux	\N	1
334	95	Rendu	règle	\N	1
369	112	Rendu	ciseaux	\N	1
336	98	Rendu	Ciseaux	\N	1
338	98	Rendu	Pince multiprise	\N	1
364	111	Rendu	ciseaux	\N	1
355	106	Rendu	cutter	\N	1
382	106	Rendu	ciseau	\N	1
308	87	Rendu	Ciseaux	\N	1
307	87	Rendu	Regle	\N	1
337	63	Rendu	Regle	\N	1
377	113	Rendu	ciseau	\N	1
378	113	Rendu	règle	\N	1
380	113	Rendu	cutter	\N	1
408	113	Rendu	Raporteur	\N	1
270	75	Rendu	Feutre	\N	1
347	99	Rendu	cutter	\N	1
398	75	Rendu	cutter	\N	1
407	119	Rendu	Regle	\N	1
339	99	Rendu	ciseaux	\N	1
298	52	Rendu	Glue	\N	1
303	86	Rendu	cutter	\N	1
304	86	Rendu	feutre	\N	1
316	91	Rendu	ciseaux	\N	1
372	100	Rendu	règle	\N	1
342	100	Rendu	Cutter	\N	1
373	100	Rendu	ciseaux	\N	1
374	100	Rendu	feutre	\N	1
375	100	Rendu	cutter	\N	1
379	61	Rendu	marqueur noir	\N	1
320	92	Rendu	bobine ficelle	\N	1
292	60	Rendu	ciseaux	\N	1
293	84	Rendu	cutter	\N	1
404	119	Rendu	Ciseaux	\N	1
277	79	Rendu	cutter	\N	1
401	118	Rendu	cutter	\N	1
348	102	Rendu	ciseaux	\N	1
350	102	Rendu	règle	\N	1
349	102	Rendu	cutter		2
410	120	Rendu	scie a métaux	\N	1
411	120	Rendu	plache a découper	\N	1
419	110	Rendu	ciseaux	\N	1
430	123	Rendu	ciseau	\N	1
433	117	A rendre	règle	\N	1
409	120	Rendu	equerre	\N	1
425	98	Rendu	Regle	\N	1
421	122	Rendu	cutter	\N	1
424	122	Rendu	scotch	\N	1
423	122	Rendu	ciseaux	\N	1
422	122	Rendu	règle	\N	1
418	121	Rendu	règle	\N	1
400	117	Rendu	cutter		2
417	121	Rendu	cutter	\N	1
412	1	A rendre	resistance 220 ohm	\N	1
413	1	A rendre	led jaune	\N	1
416	12	A rendre	Cable micro B / nano	\N	1
302	85	Rendu	crayon de papier	\N	1
415	58	Rendu	Scotch	\N	1
452	99	A rendre	Agrafeuse	\N	1
420	51	Rendu	Compas	\N	1
426	109	Rendu	pince coupante	\N	1
431	124	Rendu	cutter	\N	1
461	130	A rendre	cable arduino uno	\N	1
462	130	A rendre	arduino uno	\N	1
463	130	A rendre	tmc 2208	\N	1
464	130	A rendre	breaboard	\N	1
465	130	A rendre	alimentation 12V	adaptative	1
466	130	A rendre	cable	\N	1
359	108	Rendu	colle violette	\N	1
427	112	Rendu	Clef alene	\N	1
428	112	Rendu	Clef de 10	\N	1
450	112	Rendu	Clef de 13	\N	1
448	120	Rendu	Tournevis	\N	1
449	120	Rendu	Ciseaux	\N	1
429	112	Rendu	Tournevis cruci	\N	2
477	135	A rendre	Cutter	\N	1
480	14	A rendre	infra rouge emeteur	\N	1
492	20	A rendre	breadboard	\N	1
493	20	A rendre	led	\N	6
499	1	A rendre	Cable usb b	\N	1
504	20	A rendre	ESP Petit petit	\N	2
505	20	A rendre	Cabler usb C	\N	1
546	110	Rendu	Cutter	\N	1
506	141	A rendre	ultrason	\N	1
507	141	A rendre	arduino uno /esp32	\N	1
508	141	A rendre	micro usb	\N	1
509	141	A rendre	bouton	\N	1
510	141	A rendre	breadboard	\N	1
511	141	A rendre	cable	\N	1
512	141	A rendre	ecran lcd mini esp	\N	1
532	122	Rendu	Règle	\N	1
519	98	A rendre	feutre tableau	\N	1
476	134	Rendu	cutter	\N	2
531	122	Rendu	Ciseaux	\N	1
478	134	Rendu	ciseaux	\N	1
533	87	Rendu	Ciseaux	\N	1
539	87	Rendu	Agrafeuse	\N	1
488	137	Rendu	Plaque	\N	1
306	87	Rendu	Cutter	\N	1
517	20	A rendre	Resistance	220ohm	6
522	144	A rendre	led	\N	3
523	144	A rendre	resistance	220 ohm	3
538	86	Rendu	Scotch	\N	1
502	140	Rendu	cutter	\N	1
514	140	Rendu	Règle	\N	1
503	140	Rendu	ciseaux	\N	1
457	128	Rendu	plaque	\N	1
524	98	Rendu	Pince coupante	\N	1
541	146	A rendre	Cutter	\N	1
542	146	A rendre	règle	\N	1
543	146	A rendre	Ciseaux	\N	1
544	146	A rendre	marqueur	\N	2
545	146	A rendre	Raporteur	\N	1
491	113	Rendu	COLLE	\N	1
535	137	Rendu	Cutter	\N	1
536	137	Rendu	plaque	\N	1
515	142	Rendu	Cutter	\N	1
516	142	Rendu	Ciseaux	\N	1
481	40	Rendu	Set clé allen	\N	1
500	121	Rendu	ciseaux	\N	1
501	117	Rendu	Double face	\N	1
432	18	Rendu	alimentation 9v	\N	1
467	30	Rendu	cutter		1
547	110	Rendu	Scotch	\N	1
548	110	Rendu	règle	\N	1
441	126	Rendu	Cutter	\N	1
442	126	Rendu	Ciseaux	\N	1
444	126	Rendu	Regle	\N	1
445	126	Rendu	Feutre	\N	1
489	138	Rendu	cutter	\N	1
540	53	Rendu	scotch double face	\N	1
482	128	Rendu	compas	\N	1
454	128	Rendu	cutter	\N	1
455	128	Rendu	ciseaux	\N	1
490	128	Rendu	Ciseaux	\N	1
456	128	Rendu	Regle		2
468	131	Rendu	plaque	\N	1
469	131	Rendu	cutter	\N	1
470	131	Rendu	règle	\N	1
513	131	Rendu	ciseaux	\N	1
498	1	Rendu	ESP 32 Firebeetle v1	\N	1
438	125	Rendu	Regle	\N	1
440	125	Rendu	Compas	\N	1
436	125	Rendu	Scotch	\N	1
439	125	Rendu	Feutre	\N	1
437	125	Rendu	Agraffe	\N	1
434	125	Rendu	Cutter		2
458	129	Rendu	plaque	\N	1
459	129	Rendu	cutter	\N	1
414	61	Rendu	ciseaux	\N	1
460	129	Rendu	ciseau	\N	1
472	129	Rendu	règle	\N	1
473	133	Rendu	cutter	\N	1
474	133	Rendu	règle	grande	1
475	133	Rendu	plaque	\N	1
479	14	Rendu	infra rouge reciever	\N	1
518	98	Rendu	cutter	\N	1
537	74	Rendu	boite feutre	\N	1
485	136	Rendu	Feutre	\N	1
486	136	Rendu	Scotch	\N	1
487	136	Rendu	Equerre	\N	1
530	122	Rendu	Cutter	\N	1
483	136	Rendu	Cutter		2
484	136	Rendu	Regle		2
446	127	Rendu	cutter	\N	1
447	127	Rendu	scotch	\N	1
520	143	Rendu	plaque	\N	1
526	145	Rendu	Cutter	\N	1
528	145	Rendu	ciseaux	\N	1
527	145	Rendu	plaque	\N	1
529	145	Rendu	feutre	\N	2
451	60	Rendu	Compas	\N	1
521	60	Rendu	Pince	\N	1
494	139	Rendu	arduino uno	micro usb	1
525	139	Rendu	Bouton	\N	1
497	139	Rendu	câble micro usb b	\N	1
496	139	Rendu	vibreur	\N	1
495	139	Rendu	breadboard	\N	1
556	18	A rendre	Alimentation	5V	1
552	138	Rendu	Ciseaux	\N	1
551	37	Rendu	Scotch	\N	1
564	148	A rendre	ciseaux	\N	1
565	148	A rendre	aggrafeuse	\N	1
560	147	Rendu	ciseaux	\N	1
562	100	Rendu	scotch marron	\N	1
557	133	Rendu	Cutter	\N	1
549	98	Rendu	Pince plate	\N	1
534	19	Rendu	Resistance	1M	10
558	5	A rendre	Jauge de contrainte	\N	1
559	5	A rendre	Controlleur	HX711	1
561	11	A rendre	Buzzer	\N	1
443	126	Rendu	Scotch	\N	1
158	37	Rendu	plaque	\N	1
569	130	A rendre	alimentation reglabe 12 VOLTTT	\N	1
563	147	Rendu	cutter	\N	1
435	125	Rendu	Ciseaux		2
550	87	Rendu	cutter	\N	1
318	14	A rendre	Resistance 4K7	\N	3
553	39	Rendu	Cutter	\N	1
554	39	Rendu	Ciseaux	\N	1
555	39	Rendu	plaque	\N	1
573	39	Rendu	Regle	\N	1
578	115	Rendu	agrafeuse	\N	1
579	115	Rendu	ciseaux	\N	1
574	136	Rendu	Tournevis	\N	1
591	61	Rendu	Ciseaux	\N	1
587	61	Rendu	cutter	\N	2
601	40	Rendu	Cutter	\N	1
602	143	Rendu	paquet feutre	\N	1
575	90	Rendu	Cutter		2
576	90	Rendu	plaque	\N	1
577	90	Rendu	règle	\N	1
581	90	Rendu	Ciseaux	\N	1
582	90	Rendu	crayon	\N	1
453	40	Rendu	Scotch	\N	1
604	114	Rendu	Ciseaux	\N	1
603	152	Rendu	cutter	\N	1
566	149	Rendu	Cutter	\N	1
567	149	Rendu	pince coupante	\N	1
568	149	Rendu	plaque	\N	1
570	149	Rendu	Ciseaux	\N	1
571	149	Rendu	Feutres	\N	1
572	149	Rendu	Regle	\N	1
605	153	Rendu	Cutter	\N	1
607	74	Rendu	Feutre	\N	1
580	43	Rendu	Ciseaux	\N	1
588	43	Rendu	Cutter	\N	1
589	43	Rendu	Plaque	\N	1
590	43	Rendu	règle	\N	1
608	131	Rendu	ciseaux	\N	1
609	20	A rendre	Octo machinn 4X		1
598	151	Rendu	plaque	\N	2
597	151	Rendu	règle	\N	2
599	151	Rendu	cutter	\N	2
600	151	Rendu	ciseaux	\N	1
606	74	Rendu	ciseaux	\N	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: testuser
--

COPY public.users (id, username, password) FROM stdin;
1	CrunchlabUTBM2025	sha256$VTi0szMxRKosloHS$f009fa66cbb2e2b3f7e7f2947ec83a0d3b804570c126d1579a7a24f9f187e550
2	CrunchlabUTBM2025dirty	sha256$qA89SH48ST4JoP0s$a08052aaf5e2fef9882ab5c08fdd044954248ada511e0ef0733a5dc86d23bf0f
\.


--
-- Name: commande_id_commande_seq; Type: SEQUENCE SET; Schema: public; Owner: testuser
--

SELECT pg_catalog.setval('public.commande_id_commande_seq', 153, true);


--
-- Name: groupe_id_groupe_seq; Type: SEQUENCE SET; Schema: public; Owner: testuser
--

SELECT pg_catalog.setval('public.groupe_id_groupe_seq', 132, true);


--
-- Name: items_id_cart_seq; Type: SEQUENCE SET; Schema: public; Owner: testuser
--

SELECT pg_catalog.setval('public.items_id_cart_seq', 609, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testuser
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: commande commande_pkey; Type: CONSTRAINT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.commande
    ADD CONSTRAINT commande_pkey PRIMARY KEY (id_commande);


--
-- Name: groupe groupe_pkey; Type: CONSTRAINT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.groupe
    ADD CONSTRAINT groupe_pkey PRIMARY KEY (id_groupe);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id_cart);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: commande commande_id_groupe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.commande
    ADD CONSTRAINT commande_id_groupe_fkey FOREIGN KEY (id_groupe) REFERENCES public.groupe(id_groupe);


--
-- Name: groupe groupe_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.groupe
    ADD CONSTRAINT groupe_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: items items_id_commande_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testuser
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_id_commande_fkey FOREIGN KEY (id_commande) REFERENCES public.commande(id_commande);


--
-- PostgreSQL database dump complete
--

