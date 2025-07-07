class CreateCommunitiesSchoolDistricts < ActiveRecord::Migration[8.0]
  def change
    create_table :communities_school_districts do |t|
      t.string :community_fips_code
      t.integer :school_district_district

      t.timestamps
    end
  end
end
