class AddDistrictForeignKeys < ActiveRecord::Migration[8.0]
  def up
    add_index :communities_house_districts, :community_fips_code
    add_foreign_key :communities_house_districts, :communities,
                    column: :community_fips_code,
                    primary_key: :fips_code,
                    on_delete: :cascade

    add_index :communities_house_districts, :house_district_district
    add_foreign_key :communities_house_districts, :house_districts,
                    column: :house_district_district,
                    primary_key: :district,
                    on_delete: :cascade

    add_index :communities_senate_districts, :community_fips_code
    add_foreign_key :communities_senate_districts, :communities,
                    column: :community_fips_code,
                    primary_key: :fips_code,
                    on_delete: :cascade

    add_index :communities_senate_districts, :senate_district_district
    add_foreign_key :communities_senate_districts, :senate_districts,
                    column: :senate_district_district,
                    primary_key: :district,
                    on_delete: :cascade

    add_index :communities_school_districts, :community_fips_code
    add_foreign_key :communities_school_districts, :communities,
                    column: :community_fips_code,
                    primary_key: :fips_code,
                    on_delete: :cascade

    add_index :communities_school_districts, :school_district_district
    add_foreign_key :communities_school_districts, :school_districts,
                    column: :school_district_district,
                    primary_key: :district,
                    on_delete: :cascade
  end

  def down
    remove_foreign_key :communities_house_districts, :house_districts, column: :house_district_district
    remove_index :communities_house_districts, :house_district_district

    remove_foreign_key :communities_house_districts, :communities, column: :community_fips_code
    remove_index :communities_house_districts, :community_fips_code

    remove_foreign_key :communities_senate_districts, :senate_districts, column: :senate_district_district
    remove_index :communities_senate_districts, :senate_district_district

    remove_foreign_key :communities_senate_districts, :communities, column: :community_fips_code
    remove_index :communities_senate_districts, :community_fips_code

    remove_foreign_key :communities_school_districts, :school_districts, column: :school_district_district
    remove_index :communities_school_districts, :school_district_district

    remove_foreign_key :communities_school_districts, :communities, column: :community_fips_code
    remove_index :communities_school_districts, :community_fips_code
  end
end
