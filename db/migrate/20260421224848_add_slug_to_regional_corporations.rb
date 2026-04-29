class AddSlugToRegionalCorporations < ActiveRecord::Migration[8.0]
  def change
    add_column :regional_corporations, :slug, :string
    add_index :regional_corporations, :slug, unique: true
  end
end
