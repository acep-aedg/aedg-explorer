class CreateCommunitiesSenateDistricts < ActiveRecord::Migration[8.0]
  def change
    create_table :communities_senate_districts do |t|
      t.string :community_fips_code
      t.string :senate_district_district

      t.timestamps
    end
  end
end
