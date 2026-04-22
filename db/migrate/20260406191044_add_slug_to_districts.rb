class AddSlugToDistricts < ActiveRecord::Migration[8.0]
  def change
    add_column :house_districts, :slug, :string
    add_index :house_districts, :slug, unique: true
    
    add_column :senate_districts, :slug, :string
    add_index :senate_districts, :slug, unique: true
  end
end
