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
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: pg_search_dmetaphone(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.pg_search_dmetaphone(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ') $_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: aedg_imports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aedg_imports (
    id bigint NOT NULL,
    aedg_id integer,
    importable_type character varying NOT NULL,
    importable_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: aedg_imports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.aedg_imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aedg_imports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.aedg_imports_id_seq OWNED BY public.aedg_imports.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: boroughs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boroughs (
    id bigint NOT NULL,
    fips_code character varying NOT NULL,
    name character varying NOT NULL,
    is_census_area boolean,
    boundary public.geography(Geometry,4326),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: boroughs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.boroughs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boroughs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.boroughs_id_seq OWNED BY public.boroughs.id;


--
-- Name: capacities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.capacities (
    id bigint NOT NULL,
    grid_id integer,
    capacity_mw double precision,
    fuel_type character varying,
    year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: capacities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.capacities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: capacities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.capacities_id_seq OWNED BY public.capacities.id;


--
-- Name: communities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities (
    id bigint NOT NULL,
    fips_code character varying,
    name character varying,
    latitude numeric,
    longitude numeric,
    ansi_code character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    regional_corporation_fips_code character varying,
    borough_fips_code character varying,
    dcra_code uuid,
    pce_eligible boolean,
    pce_active boolean,
    location public.geography(Point,4326),
    gnis_code character varying,
    puma_code character varying,
    subsistence boolean,
    economic_region character varying,
    reporting_entity_id bigint
);


--
-- Name: communities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.communities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.communities_id_seq OWNED BY public.communities.id;


--
-- Name: communities_legislative_districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities_legislative_districts (
    id bigint NOT NULL,
    election_region integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    house_district_id bigint NOT NULL,
    senate_district_id bigint NOT NULL,
    community_fips_code character varying
);


--
-- Name: communities_legislative_districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.communities_legislative_districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communities_legislative_districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.communities_legislative_districts_id_seq OWNED BY public.communities_legislative_districts.id;


--
-- Name: community_grids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_grids (
    id bigint NOT NULL,
    community_fips_code character varying NOT NULL,
    grid_id bigint,
    connection_year integer,
    termination_year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: community_grids_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.community_grids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_grids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.community_grids_id_seq OWNED BY public.community_grids.id;


--
-- Name: datasets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.datasets (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    data jsonb,
    metadatum_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.datasets_id_seq OWNED BY public.datasets.id;


--
-- Name: employments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employments (
    id bigint NOT NULL,
    community_fips_code character varying,
    residents_employed integer,
    unemployment_insurance_claimants integer,
    measurement_year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying
);


--
-- Name: employments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employments_id_seq OWNED BY public.employments.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendly_id_slugs (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp(6) without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friendly_id_slugs_id_seq OWNED BY public.friendly_id_slugs.id;


--
-- Name: fuel_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fuel_prices (
    id bigint NOT NULL,
    community_fips_code character varying,
    price numeric,
    fuel_type character varying,
    price_type character varying,
    source character varying,
    reporting_season character varying,
    reporting_year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: fuel_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fuel_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fuel_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fuel_prices_id_seq OWNED BY public.fuel_prices.id;


--
-- Name: grids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grids (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: grids_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.grids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.grids_id_seq OWNED BY public.grids.id;


--
-- Name: house_districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.house_districts (
    id bigint NOT NULL,
    district integer NOT NULL,
    name character varying,
    as_of_date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    boundary public.geometry(Geometry,4326)
);


--
-- Name: house_districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.house_districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: house_districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.house_districts_id_seq OWNED BY public.house_districts.id;


--
-- Name: metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metadata (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    filename character varying,
    highlighted boolean DEFAULT false,
    published boolean DEFAULT false,
    data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tsvector_data tsvector GENERATED ALWAYS AS (jsonb_to_tsvector('english'::regconfig, data, '["string", "numeric"]'::jsonb)) STORED
);


--
-- Name: metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metadata_id_seq OWNED BY public.metadata.id;


--
-- Name: monthly_generations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monthly_generations (
    id bigint NOT NULL,
    grid_id integer,
    net_generation_mwh numeric,
    fuel_type character varying,
    year integer,
    month integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: monthly_generations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.monthly_generations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monthly_generations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.monthly_generations_id_seq OWNED BY public.monthly_generations.id;


--
-- Name: population_age_sexes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.population_age_sexes (
    id bigint NOT NULL,
    community_fips_code character varying NOT NULL,
    start_year integer,
    end_year integer,
    is_most_recent boolean,
    geo_src character varying,
    e_pop_age_total integer,
    m_pop_age_total integer,
    e_pop_age_under_5 integer,
    m_pop_age_under_5 integer,
    e_pop_age_5_9 integer,
    m_pop_age_5_9 integer,
    e_pop_age_10_14 integer,
    m_pop_age_10_14 integer,
    e_pop_age_15_19 integer,
    m_pop_age_15_19 integer,
    e_pop_age_20_24 integer,
    m_pop_age_20_24 integer,
    e_pop_age_25_34 integer,
    m_pop_age_25_34 integer,
    e_pop_age_35_44 integer,
    m_pop_age_35_44 integer,
    e_pop_age_45_54 integer,
    m_pop_age_45_54 integer,
    e_pop_age_55_59 integer,
    m_pop_age_55_59 integer,
    e_pop_age_60_64 integer,
    m_pop_age_60_64 integer,
    e_pop_age_65_74 integer,
    m_pop_age_65_74 integer,
    e_pop_age_75_84 integer,
    m_pop_age_75_84 integer,
    e_pop_age_85_plus integer,
    m_pop_age_85_plus integer,
    e_pop_age_median_age integer,
    m_pop_age_median_age integer,
    e_pop_age_under_18 integer,
    m_pop_age_under_18 integer,
    e_pop_age_18_plus integer,
    m_pop_age_18_plus integer,
    e_pop_age_21_plus integer,
    m_pop_age_21_plus integer,
    e_pop_age_62_plus integer,
    m_pop_age_62_plus integer,
    e_pop_age_65_plus integer,
    m_pop_age_65_plus integer,
    e_pop_total integer,
    m_pop_total integer,
    e_pop_male integer,
    m_pop_male integer,
    e_pop_female integer,
    m_pop_female integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: population_age_sexes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.population_age_sexes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: population_age_sexes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.population_age_sexes_id_seq OWNED BY public.population_age_sexes.id;


--
-- Name: populations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.populations (
    id bigint NOT NULL,
    community_fips_code character varying NOT NULL,
    total_population integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    year integer
);


--
-- Name: populations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.populations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: populations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.populations_id_seq OWNED BY public.populations.id;


--
-- Name: regional_corporations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regional_corporations (
    id bigint NOT NULL,
    fips_code character varying NOT NULL,
    name character varying NOT NULL,
    boundary public.geography(Geometry,4326),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    land_area bigint,
    water_area bigint
);


--
-- Name: regional_corporations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regional_corporations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regional_corporations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regional_corporations_id_seq OWNED BY public.regional_corporations.id;


--
-- Name: reporting_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reporting_entities (
    id bigint NOT NULL,
    utility_name character varying,
    year integer,
    grid_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: reporting_entities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reporting_entities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reporting_entities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reporting_entities_id_seq OWNED BY public.reporting_entities.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: senate_districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.senate_districts (
    id bigint NOT NULL,
    district character varying NOT NULL,
    as_of_date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    boundary public.geometry(Geometry,4326)
);


--
-- Name: senate_districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.senate_districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: senate_districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.senate_districts_id_seq OWNED BY public.senate_districts.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id bigint NOT NULL,
    tag_id bigint,
    taggable_type character varying,
    taggable_id bigint,
    tagger_type character varying,
    tagger_id bigint,
    context character varying(128),
    created_at timestamp without time zone,
    tenant character varying(128)
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: transportations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transportations (
    id bigint NOT NULL,
    community_fips_code character varying NOT NULL,
    airport boolean,
    harbor_dock boolean,
    state_ferry boolean,
    cargo_barge boolean,
    road_connection boolean,
    coastal boolean,
    road_or_ferry boolean,
    description character varying,
    as_of_date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: transportations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transportations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transportations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transportations_id_seq OWNED BY public.transportations.id;


--
-- Name: yearly_generations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.yearly_generations (
    id bigint NOT NULL,
    grid_id integer,
    net_generation_mwh integer,
    fuel_type character varying,
    year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: yearly_generations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.yearly_generations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: yearly_generations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.yearly_generations_id_seq OWNED BY public.yearly_generations.id;


--
-- Name: aedg_imports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aedg_imports ALTER COLUMN id SET DEFAULT nextval('public.aedg_imports_id_seq'::regclass);


--
-- Name: boroughs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boroughs ALTER COLUMN id SET DEFAULT nextval('public.boroughs_id_seq'::regclass);


--
-- Name: capacities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.capacities ALTER COLUMN id SET DEFAULT nextval('public.capacities_id_seq'::regclass);


--
-- Name: communities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities ALTER COLUMN id SET DEFAULT nextval('public.communities_id_seq'::regclass);


--
-- Name: communities_legislative_districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_legislative_districts ALTER COLUMN id SET DEFAULT nextval('public.communities_legislative_districts_id_seq'::regclass);


--
-- Name: community_grids id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_grids ALTER COLUMN id SET DEFAULT nextval('public.community_grids_id_seq'::regclass);


--
-- Name: datasets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets ALTER COLUMN id SET DEFAULT nextval('public.datasets_id_seq'::regclass);


--
-- Name: employments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employments ALTER COLUMN id SET DEFAULT nextval('public.employments_id_seq'::regclass);


--
-- Name: friendly_id_slugs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('public.friendly_id_slugs_id_seq'::regclass);


--
-- Name: fuel_prices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fuel_prices ALTER COLUMN id SET DEFAULT nextval('public.fuel_prices_id_seq'::regclass);


--
-- Name: grids id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grids ALTER COLUMN id SET DEFAULT nextval('public.grids_id_seq'::regclass);


--
-- Name: house_districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.house_districts ALTER COLUMN id SET DEFAULT nextval('public.house_districts_id_seq'::regclass);


--
-- Name: metadata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadata ALTER COLUMN id SET DEFAULT nextval('public.metadata_id_seq'::regclass);


--
-- Name: monthly_generations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_generations ALTER COLUMN id SET DEFAULT nextval('public.monthly_generations_id_seq'::regclass);


--
-- Name: population_age_sexes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.population_age_sexes ALTER COLUMN id SET DEFAULT nextval('public.population_age_sexes_id_seq'::regclass);


--
-- Name: populations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.populations ALTER COLUMN id SET DEFAULT nextval('public.populations_id_seq'::regclass);


--
-- Name: regional_corporations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_corporations ALTER COLUMN id SET DEFAULT nextval('public.regional_corporations_id_seq'::regclass);


--
-- Name: reporting_entities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporting_entities ALTER COLUMN id SET DEFAULT nextval('public.reporting_entities_id_seq'::regclass);


--
-- Name: senate_districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.senate_districts ALTER COLUMN id SET DEFAULT nextval('public.senate_districts_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: transportations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transportations ALTER COLUMN id SET DEFAULT nextval('public.transportations_id_seq'::regclass);


--
-- Name: yearly_generations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yearly_generations ALTER COLUMN id SET DEFAULT nextval('public.yearly_generations_id_seq'::regclass);


--
-- Name: aedg_imports aedg_imports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aedg_imports
    ADD CONSTRAINT aedg_imports_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: boroughs boroughs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boroughs
    ADD CONSTRAINT boroughs_pkey PRIMARY KEY (id);


--
-- Name: capacities capacities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.capacities
    ADD CONSTRAINT capacities_pkey PRIMARY KEY (id);


--
-- Name: communities_legislative_districts communities_legislative_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_legislative_districts
    ADD CONSTRAINT communities_legislative_districts_pkey PRIMARY KEY (id);


--
-- Name: communities communities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (id);


--
-- Name: community_grids community_grids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_grids
    ADD CONSTRAINT community_grids_pkey PRIMARY KEY (id);


--
-- Name: datasets datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: employments employments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employments
    ADD CONSTRAINT employments_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: fuel_prices fuel_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fuel_prices
    ADD CONSTRAINT fuel_prices_pkey PRIMARY KEY (id);


--
-- Name: grids grids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grids
    ADD CONSTRAINT grids_pkey PRIMARY KEY (id);


--
-- Name: house_districts house_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.house_districts
    ADD CONSTRAINT house_districts_pkey PRIMARY KEY (id);


--
-- Name: metadata metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadata
    ADD CONSTRAINT metadata_pkey PRIMARY KEY (id);


--
-- Name: monthly_generations monthly_generations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_generations
    ADD CONSTRAINT monthly_generations_pkey PRIMARY KEY (id);


--
-- Name: population_age_sexes population_age_sexes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.population_age_sexes
    ADD CONSTRAINT population_age_sexes_pkey PRIMARY KEY (id);


--
-- Name: populations populations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.populations
    ADD CONSTRAINT populations_pkey PRIMARY KEY (id);


--
-- Name: regional_corporations regional_corporations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regional_corporations
    ADD CONSTRAINT regional_corporations_pkey PRIMARY KEY (id);


--
-- Name: reporting_entities reporting_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporting_entities
    ADD CONSTRAINT reporting_entities_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: senate_districts senate_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.senate_districts
    ADD CONSTRAINT senate_districts_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: transportations transportations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transportations
    ADD CONSTRAINT transportations_pkey PRIMARY KEY (id);


--
-- Name: yearly_generations yearly_generations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yearly_generations
    ADD CONSTRAINT yearly_generations_pkey PRIMARY KEY (id);


--
-- Name: idx_on_community_fips_code_grid_id_connection_year_dab7f92833; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_community_fips_code_grid_id_connection_year_dab7f92833 ON public.community_grids USING btree (community_fips_code, grid_id, connection_year);


--
-- Name: index_aedg_imports_on_importable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_aedg_imports_on_importable ON public.aedg_imports USING btree (importable_type, importable_id);


--
-- Name: index_boroughs_on_boundary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boroughs_on_boundary ON public.boroughs USING gist (boundary);


--
-- Name: index_boroughs_on_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_boroughs_on_fips_code ON public.boroughs USING btree (fips_code);


--
-- Name: index_communities_legislative_districts_on_house_district_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_legislative_districts_on_house_district_id ON public.communities_legislative_districts USING btree (house_district_id);


--
-- Name: index_communities_legislative_districts_on_senate_district_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_legislative_districts_on_senate_district_id ON public.communities_legislative_districts USING btree (senate_district_id);


--
-- Name: index_communities_on_ansi_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_communities_on_ansi_code ON public.communities USING btree (ansi_code);


--
-- Name: index_communities_on_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_communities_on_fips_code ON public.communities USING btree (fips_code);


--
-- Name: index_communities_on_gnis_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_communities_on_gnis_code ON public.communities USING btree (gnis_code);


--
-- Name: index_communities_on_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_on_location ON public.communities USING gist (location);


--
-- Name: index_communities_on_reporting_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_on_reporting_entity_id ON public.communities USING btree (reporting_entity_id);


--
-- Name: index_communities_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_communities_on_slug ON public.communities USING btree (slug);


--
-- Name: index_community_grids_on_grid_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_community_grids_on_grid_id ON public.community_grids USING btree (grid_id);


--
-- Name: index_datasets_on_metadatum_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_datasets_on_metadatum_id ON public.datasets USING btree (metadatum_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON public.friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON public.friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_type_and_sluggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type_and_sluggable_id ON public.friendly_id_slugs USING btree (sluggable_type, sluggable_id);


--
-- Name: index_fuel_prices_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fuel_prices_on_community_fips_code ON public.fuel_prices USING btree (community_fips_code);


--
-- Name: index_grids_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grids_on_name ON public.grids USING btree (name);


--
-- Name: index_house_districts_on_boundary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_house_districts_on_boundary ON public.house_districts USING gist (boundary);


--
-- Name: index_house_districts_on_district; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_house_districts_on_district ON public.house_districts USING btree (district);


--
-- Name: index_population_age_sexes_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_population_age_sexes_on_community_fips_code ON public.population_age_sexes USING btree (community_fips_code);


--
-- Name: index_population_age_sexes_on_is_most_recent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_population_age_sexes_on_is_most_recent ON public.population_age_sexes USING btree (is_most_recent);


--
-- Name: index_populations_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_populations_on_community_fips_code ON public.populations USING btree (community_fips_code);


--
-- Name: index_regional_corporations_on_boundary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regional_corporations_on_boundary ON public.regional_corporations USING gist (boundary);


--
-- Name: index_regional_corporations_on_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_regional_corporations_on_fips_code ON public.regional_corporations USING btree (fips_code);


--
-- Name: index_reporting_entities_on_grid_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reporting_entities_on_grid_id ON public.reporting_entities USING btree (grid_id);


--
-- Name: index_senate_districts_on_boundary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_senate_districts_on_boundary ON public.senate_districts USING gist (boundary);


--
-- Name: index_senate_districts_on_district; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_senate_districts_on_district ON public.senate_districts USING btree (district);


--
-- Name: index_taggings_on_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_context ON public.taggings USING btree (context);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id ON public.taggings USING btree (taggable_id);


--
-- Name: index_taggings_on_taggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_type ON public.taggings USING btree (taggable_type);


--
-- Name: index_taggings_on_taggable_type_and_taggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_type_and_taggable_id ON public.taggings USING btree (taggable_type, taggable_id);


--
-- Name: index_taggings_on_tagger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id ON public.taggings USING btree (tagger_id);


--
-- Name: index_taggings_on_tagger_id_and_tagger_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id_and_tagger_type ON public.taggings USING btree (tagger_id, tagger_type);


--
-- Name: index_taggings_on_tagger_type_and_tagger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_type_and_tagger_id ON public.taggings USING btree (tagger_type, tagger_id);


--
-- Name: index_taggings_on_tenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tenant ON public.taggings USING btree (tenant);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_transportations_on_as_of_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transportations_on_as_of_date ON public.transportations USING btree (as_of_date);


--
-- Name: index_transportations_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transportations_on_community_fips_code ON public.transportations USING btree (community_fips_code);


--
-- Name: index_yearly_generations_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_yearly_generations_on_year ON public.yearly_generations USING btree (year);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taggings_idy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggings_idy ON public.taggings USING btree (taggable_id, taggable_type, tagger_id, context);


--
-- Name: taggings_taggable_context_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggings_taggable_context_idx ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: communities fk_rails_01284b70f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_01284b70f6 FOREIGN KEY (borough_fips_code) REFERENCES public.boroughs(fips_code);


--
-- Name: datasets fk_rails_21906160cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT fk_rails_21906160cf FOREIGN KEY (metadatum_id) REFERENCES public.metadata(id);


--
-- Name: yearly_generations fk_rails_26662eb773; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yearly_generations
    ADD CONSTRAINT fk_rails_26662eb773 FOREIGN KEY (grid_id) REFERENCES public.grids(id);


--
-- Name: population_age_sexes fk_rails_3da0e0a743; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.population_age_sexes
    ADD CONSTRAINT fk_rails_3da0e0a743 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: populations fk_rails_42627e1837; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.populations
    ADD CONSTRAINT fk_rails_42627e1837 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: monthly_generations fk_rails_44979977d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_generations
    ADD CONSTRAINT fk_rails_44979977d4 FOREIGN KEY (grid_id) REFERENCES public.grids(id);


--
-- Name: community_grids fk_rails_51105f953f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_grids
    ADD CONSTRAINT fk_rails_51105f953f FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: fuel_prices fk_rails_5a86c9fa5a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fuel_prices
    ADD CONSTRAINT fk_rails_5a86c9fa5a FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: communities_legislative_districts fk_rails_62b26fb9e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_legislative_districts
    ADD CONSTRAINT fk_rails_62b26fb9e7 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: community_grids fk_rails_7d3a74461c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_grids
    ADD CONSTRAINT fk_rails_7d3a74461c FOREIGN KEY (grid_id) REFERENCES public.grids(id);


--
-- Name: taggings fk_rails_9fcd2e236b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT fk_rails_9fcd2e236b FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: transportations fk_rails_af73741a29; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transportations
    ADD CONSTRAINT fk_rails_af73741a29 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: communities_legislative_districts fk_rails_b3e1d61bb2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_legislative_districts
    ADD CONSTRAINT fk_rails_b3e1d61bb2 FOREIGN KEY (house_district_id) REFERENCES public.house_districts(id);


--
-- Name: communities_legislative_districts fk_rails_b629a56790; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_legislative_districts
    ADD CONSTRAINT fk_rails_b629a56790 FOREIGN KEY (senate_district_id) REFERENCES public.senate_districts(id);


--
-- Name: reporting_entities fk_rails_ba49904843; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporting_entities
    ADD CONSTRAINT fk_rails_ba49904843 FOREIGN KEY (grid_id) REFERENCES public.grids(id);


--
-- Name: communities fk_rails_d9078d9620; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_d9078d9620 FOREIGN KEY (regional_corporation_fips_code) REFERENCES public.regional_corporations(fips_code);


--
-- Name: communities fk_rails_ed1b8d8a4f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_ed1b8d8a4f FOREIGN KEY (reporting_entity_id) REFERENCES public.reporting_entities(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250507174304'),
('20250505231517'),
('20250424230514'),
('20250422213740'),
('20250422211727'),
('20250421165405'),
('20250417191731'),
('20250417191730'),
('20250417191729'),
('20250416200301'),
('20250401174706'),
('20250325164313'),
('20250324164648'),
('20250324164610'),
('20250318233551'),
('20250318230000'),
('20250318191803'),
('20250318190213'),
('20250318164646'),
('20250318164645'),
('20250318164644'),
('20250318164643'),
('20250318164642'),
('20250318164641'),
('20250318164640'),
('20250317212047'),
('20250317205224'),
('20250311020617'),
('20250310213253'),
('20250310184056'),
('20250307204744'),
('20250307180251'),
('20250307021227'),
('20250307004610'),
('20250306171439'),
('20250301004910'),
('20250228030224'),
('20250227222522'),
('20250227180706'),
('20250227175736'),
('20250225231138'),
('20250225210351'),
('20250225002413'),
('20250219000527'),
('20250218231818'),
('20250217232124'),
('20250217225415'),
('20241224004341'),
('20241213183907'),
('20241212232634'),
('20241212215118'),
('20241212215109'),
('20241212214531');

