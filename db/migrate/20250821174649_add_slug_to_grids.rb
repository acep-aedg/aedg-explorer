class AddSlugToGrids < ActiveRecord::Migration[8.0]
  def change
    add_column :grids, :slug, :string
    add_index :grids, :slug, unique: true
  end
end
