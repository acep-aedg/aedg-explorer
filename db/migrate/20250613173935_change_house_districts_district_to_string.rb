class ChangeHouseDistrictsDistrictToString < ActiveRecord::Migration[8.0]
  def up
    change_column :house_districts, :district, :string
  end

  def down
    change_column :house_districts, :district, :integer
  end
end
