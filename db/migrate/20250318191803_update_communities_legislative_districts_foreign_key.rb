class UpdateCommunitiesLegislativeDistrictsForeignKey < ActiveRecord::Migration[7.1]
  def change
    remove_column :communities_legislative_districts, :community_fips_code
    remove_column :communities_legislative_districts, :house_district

    add_reference :communities_legislative_districts, :community, foreign_key: true
    add_reference :communities_legislative_districts, :house_district, foreign_key: true, null: false
  end
end
