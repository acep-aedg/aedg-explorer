class UpdateCommunitiesTable < ActiveRecord::Migration[7.1]
  def change
    add_column :communities, :regional_corporation_fips_code, :string
    add_column :communities, :borough_fips_code, :string
    add_column :communities, :grid_id, :integer
    add_column :communities, :dcra_code, :uuid
    add_column :communities, :pce_eligible, :boolean
    add_column :communities, :pce_active, :boolean

    change_column :communities, :ansi_code, :string

    remove_column :communities, :global_id, :uuid
    remove_column :communities, :community_id, :uuid
  end
end
