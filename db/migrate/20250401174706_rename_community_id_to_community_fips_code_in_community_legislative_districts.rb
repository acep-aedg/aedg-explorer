class RenameCommunityIdToCommunityFipsCodeInCommunityLegislativeDistricts < ActiveRecord::Migration[7.1]
  def change
    rename_column :communities_legislative_districts, :community_id, :community_fips_code
    remove_foreign_key :communities_legislative_districts, :communities

    change_column :communities_legislative_districts, :community_fips_code, :string
    add_foreign_key :communities_legislative_districts, :communities, column: :community_fips_code, primary_key: :fips_code
  end
end
