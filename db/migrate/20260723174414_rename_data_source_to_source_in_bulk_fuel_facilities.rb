class RenameDataSourceToSourceInBulkFuelFacilities < ActiveRecord::Migration[8.0]
  def change
    rename_column :bulk_fuel_facilities, :data_source, :source
  end
end
