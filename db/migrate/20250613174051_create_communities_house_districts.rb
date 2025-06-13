class CreateCommunitiesHouseDistricts < ActiveRecord::Migration[8.0]
  def change
    create_table :communities_house_districts do |t|
      t.string :community_fips_code
      t.string :house_district_district

      t.timestamps
    end
  end
end
