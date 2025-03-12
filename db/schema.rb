# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_03_10_213253) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "aedg_imports", force: :cascade do |t|
    t.integer "aedg_id"
    t.string "importable_type", null: false
    t.bigint "importable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["importable_type", "importable_id"], name: "index_aedg_imports_on_importable"
  end

  create_table "boroughs", force: :cascade do |t|
    t.string "fips_code", null: false
    t.string "name", null: false
    t.boolean "is_census_area"
    t.geography "boundary", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boundary"], name: "index_boroughs_on_boundary", using: :gist
    t.index ["fips_code"], name: "index_boroughs_on_fips_code", unique: true
  end

  create_table "communities", force: :cascade do |t|
    t.string "fips_code"
    t.string "name"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "ansi_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "regional_corporation_fips_code"
    t.string "borough_fips_code"
    t.integer "grid_id"
    t.uuid "dcra_code"
    t.boolean "pce_eligible"
    t.boolean "pce_active"
    t.geography "location", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.index ["ansi_code"], name: "index_communities_on_ansi_code", unique: true
    t.index ["fips_code"], name: "index_communities_on_fips_code", unique: true
    t.index ["location"], name: "index_communities_on_location", using: :gist
    t.index ["slug"], name: "index_communities_on_slug", unique: true
  end

  create_table "communities_legislative_districts", force: :cascade do |t|
    t.string "community_fips_code"
    t.integer "house_district"
    t.string "senate_district"
    t.integer "election_region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employments", force: :cascade do |t|
    t.string "community_fips_code"
    t.integer "residents_employed"
    t.integer "unemployment_insurance_claimants"
    t.integer "measurement_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "grids", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_grids_on_name"
  end

  create_table "monthly_generations", force: :cascade do |t|
    t.integer "grid_id"
    t.decimal "net_generation_mwh"
    t.string "fuel_type"
    t.integer "year"
    t.integer "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "population_age_sexes", force: :cascade do |t|
    t.string "community_fips_code", null: false
    t.integer "start_year"
    t.integer "end_year"
    t.boolean "is_most_recent"
    t.string "geo_src"
    t.integer "e_pop_age_total"
    t.integer "m_pop_age_total"
    t.integer "e_pop_age_under_5"
    t.integer "m_pop_age_under_5"
    t.integer "e_pop_age_5_9"
    t.integer "m_pop_age_5_9"
    t.integer "e_pop_age_10_14"
    t.integer "m_pop_age_10_14"
    t.integer "e_pop_age_15_19"
    t.integer "m_pop_age_15_19"
    t.integer "e_pop_age_20_24"
    t.integer "m_pop_age_20_24"
    t.integer "e_pop_age_25_34"
    t.integer "m_pop_age_25_34"
    t.integer "e_pop_age_35_44"
    t.integer "m_pop_age_35_44"
    t.integer "e_pop_age_45_54"
    t.integer "m_pop_age_45_54"
    t.integer "e_pop_age_55_59"
    t.integer "m_pop_age_55_59"
    t.integer "e_pop_age_60_64"
    t.integer "m_pop_age_60_64"
    t.integer "e_pop_age_65_74"
    t.integer "m_pop_age_65_74"
    t.integer "e_pop_age_75_84"
    t.integer "m_pop_age_75_84"
    t.integer "e_pop_age_85_plus"
    t.integer "m_pop_age_85_plus"
    t.integer "e_pop_age_median_age"
    t.integer "m_pop_age_median_age"
    t.integer "e_pop_age_under_18"
    t.integer "m_pop_age_under_18"
    t.integer "e_pop_age_18_plus"
    t.integer "m_pop_age_18_plus"
    t.integer "e_pop_age_21_plus"
    t.integer "m_pop_age_21_plus"
    t.integer "e_pop_age_62_plus"
    t.integer "m_pop_age_62_plus"
    t.integer "e_pop_age_65_plus"
    t.integer "m_pop_age_65_plus"
    t.integer "e_pop_total"
    t.integer "m_pop_total"
    t.integer "e_pop_male"
    t.integer "m_pop_male"
    t.integer "e_pop_female"
    t.integer "m_pop_female"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_fips_code"], name: "index_population_age_sexes_on_community_fips_code"
    t.index ["is_most_recent"], name: "index_population_age_sexes_on_is_most_recent"
  end

  create_table "populations", force: :cascade do |t|
    t.string "community_fips_code", null: false
    t.integer "total_population", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["community_fips_code"], name: "index_populations_on_community_fips_code", unique: true
  end

  create_table "regional_corporations", force: :cascade do |t|
    t.string "fips_code", null: false
    t.string "name", null: false
    t.geography "boundary", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "land_area"
    t.bigint "water_area"
    t.index ["boundary"], name: "index_regional_corporations_on_boundary", using: :gist
    t.index ["fips_code"], name: "index_regional_corporations_on_fips_code", unique: true
  end

  create_table "transportations", force: :cascade do |t|
    t.string "community_fips_code", null: false
    t.boolean "airport"
    t.boolean "harbor_dock"
    t.boolean "state_ferry"
    t.boolean "cargo_barge"
    t.boolean "road_connection"
    t.boolean "coastal"
    t.boolean "road_or_ferry"
    t.string "description"
    t.date "as_of_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["as_of_date"], name: "index_transportations_on_as_of_date"
    t.index ["community_fips_code"], name: "index_transportations_on_community_fips_code"
  end

  create_table "yearly_generations", force: :cascade do |t|
    t.integer "grid_id"
    t.integer "net_generation_mwh"
    t.string "fuel_type"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year"], name: "index_yearly_generations_on_year"
  end

  add_foreign_key "communities", "boroughs", column: "borough_fips_code", primary_key: "fips_code"
  add_foreign_key "communities", "grids"
  add_foreign_key "communities", "regional_corporations", column: "regional_corporation_fips_code", primary_key: "fips_code"
  add_foreign_key "monthly_generations", "grids"
  add_foreign_key "population_age_sexes", "communities", column: "community_fips_code", primary_key: "fips_code"
  add_foreign_key "populations", "communities", column: "community_fips_code", primary_key: "fips_code"
  add_foreign_key "transportations", "communities", column: "community_fips_code", primary_key: "fips_code"
  add_foreign_key "yearly_generations", "grids"
end
