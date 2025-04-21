class RenameCommunityIdToCommunityFipsCodeInCommunityLegislativeDistricts < ActiveRecord::Migration[7.1]
  def up
    add_column :communities_legislative_districts, :community_fips_code, :string

    # repopulate the community_fips_code column
    if CommunitiesLegislativeDistrict.exists?
      say_with_time "Repopulating community_fips_code from community_id..." do
        CommunitiesLegislativeDistrict.reset_column_information

        CommunitiesLegislativeDistrict.find_each do |cld|
          community = Community.find_by(id: cld.community_id)
          cld.update_column(:community_fips_code, community&.fips_code)
        end
      end
    end

    add_foreign_key :communities_legislative_districts, :communities,
                    column: :community_fips_code,
                    primary_key: :fips_code

    remove_foreign_key :communities_legislative_districts, :community if foreign_key_exists?(:communities_legislative_districts, :community)
    remove_index :communities_legislative_districts, :community_id if index_exists?(:communities_legislative_districts, :community_id)
    remove_column :communities_legislative_districts, :community_id if column_exists?(:communities_legislative_districts, :community_id)
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'This migration cannot be reverted because it destroys sensitive data.'
  end
end
