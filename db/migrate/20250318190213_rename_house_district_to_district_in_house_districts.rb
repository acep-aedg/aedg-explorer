class RenameHouseDistrictToDistrictInHouseDistricts < ActiveRecord::Migration[7.1]
  def change
    rename_column :house_districts, :house_district, :district
  end
end
