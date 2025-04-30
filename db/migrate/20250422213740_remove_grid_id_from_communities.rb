class RemoveGridIdFromCommunities < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :communities, :grids
    remove_column :communities, :grid_id, :integer
  end
end
