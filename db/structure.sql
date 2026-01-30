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
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


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
-- Name: bulk_fuel_facilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bulk_fuel_facilities (
    id bigint NOT NULL,
    dcra_code uuid,
    tank_farm_id integer,
    uscg_id character varying,
    aea_id character varying,
    community_fips_code character varying,
    name character varying,
    number_of_tanks integer,
    total_capacity integer,
    gasoline_capacity integer,
    diesel_capacity integer,
    av_gas_capacity integer,
    jet_fuel_capacity integer,
    other_fuel_capacity integer,
    barge_delivery boolean,
    plane_delivery boolean,
    road_delivery boolean,
    inspected_by_uscg boolean,
    fuel_supplier character varying,
    recommendations_by_aea character varying,
    distance_to_barge_mooring character varying,
    tank_farm_evaluation_id integer,
    data_source character varying,
    report character varying,
    location public.geometry,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: bulk_fuel_facilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bulk_fuel_facilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bulk_fuel_facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bulk_fuel_facilities_id_seq OWNED BY public.bulk_fuel_facilities.id;


--
-- Name: capacities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.capacities (
    id bigint NOT NULL,
    capacity_mw double precision,
    year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    fuel_type_code character varying,
    fuel_type_name character varying,
    aea_plant_id integer,
    eia_plant_id integer
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
    village_corporation character varying,
    tsvector_data tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, COALESCE((name)::text, ''::text))) STORED
);


--
-- Name: communities_house_districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities_house_districts (
    id bigint NOT NULL,
    community_fips_code character varying,
    house_district_district character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: communities_house_districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.communities_house_districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communities_house_districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.communities_house_districts_id_seq OWNED BY public.communities_house_districts.id;


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
-- Name: communities_reporting_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities_reporting_entities (
    id bigint NOT NULL,
    community_fips_code character varying NOT NULL,
    reporting_entity_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: communities_reporting_entities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.communities_reporting_entities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communities_reporting_entities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.communities_reporting_entities_id_seq OWNED BY public.communities_reporting_entities.id;


--
-- Name: communities_school_districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities_school_districts (
    id bigint NOT NULL,
    community_fips_code character varying,
    school_district_district integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: communities_school_districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.communities_school_districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communities_school_districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.communities_school_districts_id_seq OWNED BY public.communities_school_districts.id;


--
-- Name: communities_senate_districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities_senate_districts (
    id bigint NOT NULL,
    community_fips_code character varying,
    senate_district_district character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: communities_senate_districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.communities_senate_districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communities_senate_districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.communities_senate_districts_id_seq OWNED BY public.communities_senate_districts.id;


--
-- Name: communities_service_area_geoms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities_service_area_geoms (
    id bigint NOT NULL,
    community_fips_code character varying NOT NULL,
    service_area_geom_aedg_id character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: communities_service_area_geoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.communities_service_area_geoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communities_service_area_geoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.communities_service_area_geoms_id_seq OWNED BY public.communities_service_area_geoms.id;


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
-- Name: data_pond_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_pond_versions (
    id bigint NOT NULL,
    current_version character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: data_pond_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_pond_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_pond_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_pond_versions_id_seq OWNED BY public.data_pond_versions.id;


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
-- Name: electric_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.electric_rates (
    id bigint NOT NULL,
    reporting_entity_id bigint NOT NULL,
    year integer,
    residential_rate numeric,
    commercial_rate numeric,
    industrial_rate numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: electric_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.electric_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: electric_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.electric_rates_id_seq OWNED BY public.electric_rates.id;


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
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying
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
-- Name: heating_degree_days; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heating_degree_days (
    id bigint NOT NULL,
    community_fips_code character varying,
    year integer,
    month integer,
    heating_degree_days integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: heating_degree_days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heating_degree_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heating_degree_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heating_degree_days_id_seq OWNED BY public.heating_degree_days.id;


--
-- Name: house_districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.house_districts (
    id bigint NOT NULL,
    district character varying NOT NULL,
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
-- Name: household_incomes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.household_incomes (
    id bigint NOT NULL,
    community_fips_code character varying,
    e_households_total integer,
    e_household_median_income integer,
    e_household_inc_under_10000 integer,
    e_household_inc_10000_14999 integer,
    e_household_inc_15000_24999 integer,
    e_household_inc_25000_34999 integer,
    e_household_inc_35000_49999 integer,
    e_household_inc_50000_74999 integer,
    e_household_inc_75000_99999 integer,
    e_household_inc_100000_149999 integer,
    e_household_inc_150000_199999 integer,
    e_household_inc_200000_plus integer,
    start_year integer,
    end_year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: household_incomes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.household_incomes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: household_incomes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.household_incomes_id_seq OWNED BY public.household_incomes.id;


--
-- Name: income_poverties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.income_poverties (
    id bigint NOT NULL,
    community_fips_code character varying,
    e_per_capita_income integer,
    m_per_capita_income integer,
    e_pop_below_poverty integer,
    m_pop_below_poverty integer,
    e_pop_of_poverty_det integer,
    m_pop_of_poverty_det integer,
    start_year integer,
    end_year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: income_poverties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.income_poverties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: income_poverties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.income_poverties_id_seq OWNED BY public.income_poverties.id;


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
    generation_mwh numeric,
    year integer,
    month integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    fuel_type_code character varying,
    fuel_type_name character varying,
    aea_plant_id integer,
    eia_plant_id integer,
    physical_unit_label character varying,
    pce_fuel_price numeric,
    quantity_consumed_in_physical_units_for_electric_generation numeric,
    quantity_consumed_for_electricity_mmbtu numeric,
    source character varying
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
-- Name: plants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plants (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    aea_plant_id integer,
    eia_plant_ids integer[] DEFAULT '{}'::integer[],
    name character varying,
    aea_operator_id integer,
    eia_operator_id integer,
    grid_id integer,
    service_area_geom_aedg_id character varying,
    combined_heat_power boolean,
    grid_primary_voltage_kv numeric,
    grid_primary_voltage_2_kv numeric,
    phases character varying,
    notes character varying,
    location public.geometry,
    pce_reporting_id integer
);


--
-- Name: plants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plants_id_seq OWNED BY public.plants.id;


--
-- Name: population_age_sexes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.population_age_sexes (
    id bigint NOT NULL,
    community_fips_code character varying NOT NULL,
    start_year integer,
    end_year integer,
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
    name character varying,
    most_recent_year integer,
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
-- Name: sales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales (
    id bigint NOT NULL,
    reporting_entity_id bigint NOT NULL,
    year integer,
    residential_revenue integer,
    residential_sales integer,
    residential_customers integer,
    commercial_revenue integer,
    commercial_sales integer,
    commercial_customers integer,
    total_revenue integer,
    total_sales integer,
    total_customers integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: school_districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.school_districts (
    id bigint NOT NULL,
    district integer NOT NULL,
    name character varying,
    district_type character varying,
    is_active boolean,
    notes character varying,
    boundary public.geometry,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: school_districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.school_districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: school_districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.school_districts_id_seq OWNED BY public.school_districts.id;


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
-- Name: service_area_geoms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_area_geoms (
    id bigint NOT NULL,
    aedg_id character varying NOT NULL,
    service_area_cpcn_id integer NOT NULL,
    boundary public.geometry,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: service_area_geoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_area_geoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_area_geoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_area_geoms_id_seq OWNED BY public.service_area_geoms.id;


--
-- Name: service_areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_areas (
    id bigint NOT NULL,
    cpcn_id integer NOT NULL,
    name character varying,
    certificate_url character varying,
    boundary public.geometry,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: service_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_areas_id_seq OWNED BY public.service_areas.id;


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
    generation_mwh integer,
    year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    fuel_type_code character varying,
    fuel_type_name character varying,
    aea_plant_id integer,
    eia_plant_id integer,
    physical_unit_label character varying,
    avg_pce_fuel_price numeric,
    quantity_consumed_in_physical_units_for_electric_generation numeric,
    quantity_consumed_for_electricity_mmbtu numeric,
    source character varying
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
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: aedg_imports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aedg_imports ALTER COLUMN id SET DEFAULT nextval('public.aedg_imports_id_seq'::regclass);


--
-- Name: boroughs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boroughs ALTER COLUMN id SET DEFAULT nextval('public.boroughs_id_seq'::regclass);


--
-- Name: bulk_fuel_facilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_fuel_facilities ALTER COLUMN id SET DEFAULT nextval('public.bulk_fuel_facilities_id_seq'::regclass);


--
-- Name: capacities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.capacities ALTER COLUMN id SET DEFAULT nextval('public.capacities_id_seq'::regclass);


--
-- Name: communities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities ALTER COLUMN id SET DEFAULT nextval('public.communities_id_seq'::regclass);


--
-- Name: communities_house_districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_house_districts ALTER COLUMN id SET DEFAULT nextval('public.communities_house_districts_id_seq'::regclass);


--
-- Name: communities_reporting_entities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_reporting_entities ALTER COLUMN id SET DEFAULT nextval('public.communities_reporting_entities_id_seq'::regclass);


--
-- Name: communities_school_districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_school_districts ALTER COLUMN id SET DEFAULT nextval('public.communities_school_districts_id_seq'::regclass);


--
-- Name: communities_senate_districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_senate_districts ALTER COLUMN id SET DEFAULT nextval('public.communities_senate_districts_id_seq'::regclass);


--
-- Name: communities_service_area_geoms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_service_area_geoms ALTER COLUMN id SET DEFAULT nextval('public.communities_service_area_geoms_id_seq'::regclass);


--
-- Name: community_grids id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_grids ALTER COLUMN id SET DEFAULT nextval('public.community_grids_id_seq'::regclass);


--
-- Name: data_pond_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_pond_versions ALTER COLUMN id SET DEFAULT nextval('public.data_pond_versions_id_seq'::regclass);


--
-- Name: datasets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets ALTER COLUMN id SET DEFAULT nextval('public.datasets_id_seq'::regclass);


--
-- Name: electric_rates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.electric_rates ALTER COLUMN id SET DEFAULT nextval('public.electric_rates_id_seq'::regclass);


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
-- Name: heating_degree_days id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heating_degree_days ALTER COLUMN id SET DEFAULT nextval('public.heating_degree_days_id_seq'::regclass);


--
-- Name: house_districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.house_districts ALTER COLUMN id SET DEFAULT nextval('public.house_districts_id_seq'::regclass);


--
-- Name: household_incomes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.household_incomes ALTER COLUMN id SET DEFAULT nextval('public.household_incomes_id_seq'::regclass);


--
-- Name: income_poverties id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.income_poverties ALTER COLUMN id SET DEFAULT nextval('public.income_poverties_id_seq'::regclass);


--
-- Name: metadata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadata ALTER COLUMN id SET DEFAULT nextval('public.metadata_id_seq'::regclass);


--
-- Name: monthly_generations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_generations ALTER COLUMN id SET DEFAULT nextval('public.monthly_generations_id_seq'::regclass);


--
-- Name: plants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plants ALTER COLUMN id SET DEFAULT nextval('public.plants_id_seq'::regclass);


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
-- Name: sales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- Name: school_districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_districts ALTER COLUMN id SET DEFAULT nextval('public.school_districts_id_seq'::regclass);


--
-- Name: senate_districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.senate_districts ALTER COLUMN id SET DEFAULT nextval('public.senate_districts_id_seq'::regclass);


--
-- Name: service_area_geoms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_area_geoms ALTER COLUMN id SET DEFAULT nextval('public.service_area_geoms_id_seq'::regclass);


--
-- Name: service_areas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_areas ALTER COLUMN id SET DEFAULT nextval('public.service_areas_id_seq'::regclass);


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
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


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
-- Name: bulk_fuel_facilities bulk_fuel_facilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_fuel_facilities
    ADD CONSTRAINT bulk_fuel_facilities_pkey PRIMARY KEY (id);


--
-- Name: capacities capacities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.capacities
    ADD CONSTRAINT capacities_pkey PRIMARY KEY (id);


--
-- Name: communities_house_districts communities_house_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_house_districts
    ADD CONSTRAINT communities_house_districts_pkey PRIMARY KEY (id);


--
-- Name: communities communities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (id);


--
-- Name: communities_reporting_entities communities_reporting_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_reporting_entities
    ADD CONSTRAINT communities_reporting_entities_pkey PRIMARY KEY (id);


--
-- Name: communities_school_districts communities_school_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_school_districts
    ADD CONSTRAINT communities_school_districts_pkey PRIMARY KEY (id);


--
-- Name: communities_senate_districts communities_senate_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_senate_districts
    ADD CONSTRAINT communities_senate_districts_pkey PRIMARY KEY (id);


--
-- Name: communities_service_area_geoms communities_service_area_geoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_service_area_geoms
    ADD CONSTRAINT communities_service_area_geoms_pkey PRIMARY KEY (id);


--
-- Name: community_grids community_grids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_grids
    ADD CONSTRAINT community_grids_pkey PRIMARY KEY (id);


--
-- Name: data_pond_versions data_pond_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_pond_versions
    ADD CONSTRAINT data_pond_versions_pkey PRIMARY KEY (id);


--
-- Name: datasets datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: electric_rates electric_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.electric_rates
    ADD CONSTRAINT electric_rates_pkey PRIMARY KEY (id);


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
-- Name: heating_degree_days heating_degree_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heating_degree_days
    ADD CONSTRAINT heating_degree_days_pkey PRIMARY KEY (id);


--
-- Name: house_districts house_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.house_districts
    ADD CONSTRAINT house_districts_pkey PRIMARY KEY (id);


--
-- Name: household_incomes household_incomes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.household_incomes
    ADD CONSTRAINT household_incomes_pkey PRIMARY KEY (id);


--
-- Name: income_poverties income_poverties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.income_poverties
    ADD CONSTRAINT income_poverties_pkey PRIMARY KEY (id);


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
-- Name: plants plants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plants
    ADD CONSTRAINT plants_pkey PRIMARY KEY (id);


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
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: school_districts school_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_districts
    ADD CONSTRAINT school_districts_pkey PRIMARY KEY (id);


--
-- Name: senate_districts senate_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.senate_districts
    ADD CONSTRAINT senate_districts_pkey PRIMARY KEY (id);


--
-- Name: service_area_geoms service_area_geoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_area_geoms
    ADD CONSTRAINT service_area_geoms_pkey PRIMARY KEY (id);


--
-- Name: service_areas service_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_areas
    ADD CONSTRAINT service_areas_pkey PRIMARY KEY (id);


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
-- Name: idx_comm_grids_on_grid_and_fips; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comm_grids_on_grid_and_fips ON public.community_grids USING btree (grid_id, community_fips_code);


--
-- Name: idx_csag_on_aedg_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_csag_on_aedg_id ON public.communities_service_area_geoms USING btree (service_area_geom_aedg_id);


--
-- Name: idx_csag_on_fips; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_csag_on_fips ON public.communities_service_area_geoms USING btree (community_fips_code);


--
-- Name: idx_monthly_gen_composite; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_monthly_gen_composite ON public.monthly_generations USING btree (aea_plant_id, year, month);


--
-- Name: idx_on_community_fips_code_grid_id_connection_year_dab7f92833; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_community_fips_code_grid_id_connection_year_dab7f92833 ON public.community_grids USING btree (community_fips_code, grid_id, connection_year);


--
-- Name: idx_plants_on_sa_geom_aedg_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_plants_on_sa_geom_aedg_id ON public.plants USING btree (service_area_geom_aedg_id);


--
-- Name: idx_yearly_gen_on_aea_id_and_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_yearly_gen_on_aea_id_and_year ON public.yearly_generations USING btree (aea_plant_id, year);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


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
-- Name: index_communities_house_districts_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_house_districts_on_community_fips_code ON public.communities_house_districts USING btree (community_fips_code);


--
-- Name: index_communities_house_districts_on_house_district_district; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_house_districts_on_house_district_district ON public.communities_house_districts USING btree (house_district_district);


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
-- Name: index_communities_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_communities_on_slug ON public.communities USING btree (slug);


--
-- Name: index_communities_reporting_entities_on_reporting_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_reporting_entities_on_reporting_entity_id ON public.communities_reporting_entities USING btree (reporting_entity_id);


--
-- Name: index_communities_school_districts_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_school_districts_on_community_fips_code ON public.communities_school_districts USING btree (community_fips_code);


--
-- Name: index_communities_school_districts_on_school_district_district; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_school_districts_on_school_district_district ON public.communities_school_districts USING btree (school_district_district);


--
-- Name: index_communities_senate_districts_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_senate_districts_on_community_fips_code ON public.communities_senate_districts USING btree (community_fips_code);


--
-- Name: index_communities_senate_districts_on_senate_district_district; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_senate_districts_on_senate_district_district ON public.communities_senate_districts USING btree (senate_district_district);


--
-- Name: index_community_grids_on_grid_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_community_grids_on_grid_id ON public.community_grids USING btree (grid_id);


--
-- Name: index_data_pond_versions_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_pond_versions_on_created_at ON public.data_pond_versions USING btree (created_at);


--
-- Name: index_datasets_on_metadatum_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_datasets_on_metadatum_id ON public.datasets USING btree (metadatum_id);


--
-- Name: index_electric_rates_on_reporting_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_electric_rates_on_reporting_entity_id ON public.electric_rates USING btree (reporting_entity_id);


--
-- Name: index_employments_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employments_on_community_fips_code ON public.employments USING btree (community_fips_code);


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
-- Name: index_grids_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_grids_on_slug ON public.grids USING btree (slug);


--
-- Name: index_house_districts_on_boundary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_house_districts_on_boundary ON public.house_districts USING gist (boundary);


--
-- Name: index_house_districts_on_district; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_house_districts_on_district ON public.house_districts USING btree (district);


--
-- Name: index_household_incomes_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_household_incomes_on_community_fips_code ON public.household_incomes USING btree (community_fips_code);


--
-- Name: index_income_poverties_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_income_poverties_on_community_fips_code ON public.income_poverties USING btree (community_fips_code);


--
-- Name: index_plants_on_grid_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plants_on_grid_id ON public.plants USING btree (grid_id);


--
-- Name: index_population_age_sexes_on_community_fips_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_population_age_sexes_on_community_fips_code ON public.population_age_sexes USING btree (community_fips_code);


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
-- Name: index_sales_on_reporting_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sales_on_reporting_entity_id ON public.sales USING btree (reporting_entity_id);


--
-- Name: index_school_districts_on_boundary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_school_districts_on_boundary ON public.school_districts USING gist (boundary);


--
-- Name: index_school_districts_on_district; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_school_districts_on_district ON public.school_districts USING btree (district);


--
-- Name: index_school_districts_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_school_districts_on_name ON public.school_districts USING btree (name);


--
-- Name: index_senate_districts_on_boundary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_senate_districts_on_boundary ON public.senate_districts USING gist (boundary);


--
-- Name: index_senate_districts_on_district; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_senate_districts_on_district ON public.senate_districts USING btree (district);


--
-- Name: index_service_area_geoms_on_aedg_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_service_area_geoms_on_aedg_id ON public.service_area_geoms USING btree (aedg_id);


--
-- Name: index_service_area_geoms_on_service_area_cpcn_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_area_geoms_on_service_area_cpcn_id ON public.service_area_geoms USING btree (service_area_cpcn_id);


--
-- Name: index_service_areas_on_cpcn_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_service_areas_on_cpcn_id ON public.service_areas USING btree (cpcn_id);


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
-- Name: communities_reporting_entities fk_rails_03bd4313db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_reporting_entities
    ADD CONSTRAINT fk_rails_03bd4313db FOREIGN KEY (reporting_entity_id) REFERENCES public.reporting_entities(id);


--
-- Name: income_poverties fk_rails_0ce49ca0a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.income_poverties
    ADD CONSTRAINT fk_rails_0ce49ca0a4 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code) ON DELETE CASCADE;


--
-- Name: bulk_fuel_facilities fk_rails_12e76c4358; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_fuel_facilities
    ADD CONSTRAINT fk_rails_12e76c4358 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: communities_service_area_geoms fk_rails_20f8ef8e44; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_service_area_geoms
    ADD CONSTRAINT fk_rails_20f8ef8e44 FOREIGN KEY (service_area_geom_aedg_id) REFERENCES public.service_area_geoms(aedg_id);


--
-- Name: datasets fk_rails_21906160cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT fk_rails_21906160cf FOREIGN KEY (metadatum_id) REFERENCES public.metadata(id);


--
-- Name: service_area_geoms fk_rails_2c45461cbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_area_geoms
    ADD CONSTRAINT fk_rails_2c45461cbd FOREIGN KEY (service_area_cpcn_id) REFERENCES public.service_areas(cpcn_id);


--
-- Name: communities_school_districts fk_rails_2f18d3d586; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_school_districts
    ADD CONSTRAINT fk_rails_2f18d3d586 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code) ON DELETE CASCADE;


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
-- Name: communities_school_districts fk_rails_437791b944; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_school_districts
    ADD CONSTRAINT fk_rails_437791b944 FOREIGN KEY (school_district_district) REFERENCES public.school_districts(district) ON DELETE CASCADE;


--
-- Name: electric_rates fk_rails_45b5e43dbc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.electric_rates
    ADD CONSTRAINT fk_rails_45b5e43dbc FOREIGN KEY (reporting_entity_id) REFERENCES public.reporting_entities(id);


--
-- Name: plants fk_rails_49b512915b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plants
    ADD CONSTRAINT fk_rails_49b512915b FOREIGN KEY (grid_id) REFERENCES public.grids(id);


--
-- Name: communities_reporting_entities fk_rails_4f377e09ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_reporting_entities
    ADD CONSTRAINT fk_rails_4f377e09ec FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: community_grids fk_rails_51105f953f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_grids
    ADD CONSTRAINT fk_rails_51105f953f FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: heating_degree_days fk_rails_530993735a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heating_degree_days
    ADD CONSTRAINT fk_rails_530993735a FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: fuel_prices fk_rails_5a86c9fa5a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fuel_prices
    ADD CONSTRAINT fk_rails_5a86c9fa5a FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: community_grids fk_rails_7d3a74461c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_grids
    ADD CONSTRAINT fk_rails_7d3a74461c FOREIGN KEY (grid_id) REFERENCES public.grids(id);


--
-- Name: household_incomes fk_rails_86aa4bf24c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.household_incomes
    ADD CONSTRAINT fk_rails_86aa4bf24c FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code) ON DELETE CASCADE;


--
-- Name: plants fk_rails_8b58e48ec7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plants
    ADD CONSTRAINT fk_rails_8b58e48ec7 FOREIGN KEY (service_area_geom_aedg_id) REFERENCES public.service_area_geoms(aedg_id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: taggings fk_rails_9fcd2e236b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT fk_rails_9fcd2e236b FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: communities_senate_districts fk_rails_a1c3ae2d0e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_senate_districts
    ADD CONSTRAINT fk_rails_a1c3ae2d0e FOREIGN KEY (senate_district_district) REFERENCES public.senate_districts(district) ON DELETE CASCADE;


--
-- Name: communities_house_districts fk_rails_a83f81cd35; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_house_districts
    ADD CONSTRAINT fk_rails_a83f81cd35 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code) ON DELETE CASCADE;


--
-- Name: transportations fk_rails_af73741a29; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transportations
    ADD CONSTRAINT fk_rails_af73741a29 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: sales fk_rails_b5eeb5e842; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT fk_rails_b5eeb5e842 FOREIGN KEY (reporting_entity_id) REFERENCES public.reporting_entities(id);


--
-- Name: reporting_entities fk_rails_ba49904843; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporting_entities
    ADD CONSTRAINT fk_rails_ba49904843 FOREIGN KEY (grid_id) REFERENCES public.grids(id);


--
-- Name: employments fk_rails_c191440d7e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employments
    ADD CONSTRAINT fk_rails_c191440d7e FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code) ON DELETE CASCADE;


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: communities_service_area_geoms fk_rails_c737a4bd21; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_service_area_geoms
    ADD CONSTRAINT fk_rails_c737a4bd21 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code);


--
-- Name: communities fk_rails_d9078d9620; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_d9078d9620 FOREIGN KEY (regional_corporation_fips_code) REFERENCES public.regional_corporations(fips_code);


--
-- Name: communities_house_districts fk_rails_e19cffa2ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_house_districts
    ADD CONSTRAINT fk_rails_e19cffa2ca FOREIGN KEY (house_district_district) REFERENCES public.house_districts(district) ON DELETE CASCADE;


--
-- Name: communities_senate_districts fk_rails_fa42f1c180; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities_senate_districts
    ADD CONSTRAINT fk_rails_fa42f1c180 FOREIGN KEY (community_fips_code) REFERENCES public.communities(fips_code) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260127184326'),
('20260126194042'),
('20260123003703'),
('20260123003623'),
('20260121214810'),
('20260115215649'),
('20260115214036'),
('20260115205258'),
('20251217205218'),
('20251217202750'),
('20251217202552'),
('20251205180925'),
('20251120205210'),
('20251120200227'),
('20251119233833'),
('20251114225412'),
('20251113203819'),
('20251105235722'),
('20251105225408'),
('20251020233030'),
('20251020182536'),
('20251014162658'),
('20251013200021'),
('20250925225447'),
('20250911194508'),
('20250911181035'),
('20250911173625'),
('20250909214449'),
('20250821174649'),
('20250725001258'),
('20250707215602'),
('20250630224339'),
('20250623222721'),
('20250623222653'),
('20250613174051'),
('20250613173935'),
('20250613003333'),
('20250611215411'),
('20250509014050'),
('20250508195941'),
('20250508194355'),
('20250508193222'),
('20250507235806'),
('20250507214459'),
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

