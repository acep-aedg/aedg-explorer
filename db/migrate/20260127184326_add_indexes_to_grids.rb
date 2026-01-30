class AddIndexesToGrids < ActiveRecord::Migration[8.0]
  def change
    add_index :plants, :grid_id
    add_index :community_grids, [:grid_id, :community_fips_code], name: 'idx_comm_grids_on_grid_and_fips'
  end
end
