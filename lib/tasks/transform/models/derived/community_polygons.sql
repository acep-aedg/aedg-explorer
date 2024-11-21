{{ config(materialized='table') }}

WITH polys AS (
    SELECT 
        REGEXP_REPLACE(NAME, 'CDP|city|and|borough|municipality', '') AS name, -- quick clean, drop community type from name
        STATE AS state,
        PLACE AS place,
        FIPS AS fips,
        TOTALPOP AS total_population,
        WHITE AS white,
        BLACK AS black,
        NATIVE AS native,
        ASIAN AS asian,
        PACISLAND AS pacific_islander,
        OTHER AS other,
        TWO_PLUS AS two_plus,
        HISPANIC AS hispanic,
        NATALNCOMB AS native_indian_combo,
        GRPQTRS AS group_quarters,
        HOUSEUNITS AS housing_units,
        VACANT AS vacant_housing_units,
        OCCUPIED AS occupied_housing_units,
        wkb_geometry AS geometry

    FROM {{ source('dol', 'places2020') }}
),

joined AS (
    SELECT 
        a.total_population,
        a.fips,
        b.intertie_id,
        a.geometry
    FROM polys a
    LEFT JOIN  {{ ref('lookup_fips_interties') }} b USING (fips)
)

SELECT *
FROM joined
