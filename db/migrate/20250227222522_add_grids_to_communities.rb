class AddGridsToCommunities < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :communities, :grids
    add_index :grids, :name
  end
end
