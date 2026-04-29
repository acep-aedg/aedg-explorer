class AddSlugToBoroughs < ActiveRecord::Migration[8.0]
  def change
    add_column :boroughs, :slug, :string
    add_index :boroughs, :slug, unique: true
  end
end
