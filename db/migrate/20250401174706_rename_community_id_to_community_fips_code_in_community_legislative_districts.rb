class RenameCommunityIdToCommunityFipsCodeInCommunityLegislativeDistricts < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :communities_legislative_districts, :communities

    rename_column :communities_legislative_districts, :community_id, :community_fips_code

    change_column :communities_legislative_districts, :community_fips_code, :string

    add_foreign_key :communities_legislative_districts, :communities,
                    column: :community_fips_code,
                    primary_key: :fips_code
  end
end
