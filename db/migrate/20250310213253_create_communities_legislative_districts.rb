class CreateCommunitiesLegislativeDistricts < ActiveRecord::Migration[7.1]
  def change
    create_table :communities_legislative_districts do |t|
      t.string :community_fips_code
      t.integer :house_district
      t.string :senate_district
      t.integer :election_region

      t.timestamps
    end
  end
end
