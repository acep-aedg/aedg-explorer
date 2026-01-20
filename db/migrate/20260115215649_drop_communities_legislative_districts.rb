class DropCommunitiesLegislativeDistricts < ActiveRecord::Migration[8.0]
  def change
    drop_table :communities_legislative_districts do |t|
      t.integer :election_region
      t.references :house_district, null: false, foreign_key: true
      t.references :senate_district, null: false, foreign_key: true
      t.string  :community_fips_code

      t.timestamps
      t.index :community_fips_code
    end
  end
end
