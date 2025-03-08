class AddLandAndWaterAreaToRegionalCorporations < ActiveRecord::Migration[7.1]
  def change
    add_column :regional_corporations, :land_area, :bigint
    add_column :regional_corporations, :water_area, :bigint
  end
end
