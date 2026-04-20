class ChangeHouseDistrictDistrictToInt < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key :communities_house_districts, :house_districts

    change_column :communities_house_districts, :house_district_district, "integer USING (house_district_district::integer)"
    change_column :house_districts, :district, "integer USING (district::integer)"

    add_foreign_key :communities_house_districts, :house_districts,
                    column: :house_district_district,
                    primary_key: :district
  end

  def down
    remove_foreign_key :communities_house_districts, :house_districts

    change_column :communities_house_districts, :house_district_district, :string
    change_column :house_districts, :district, :string

    add_foreign_key :communities_house_districts, :house_districts,
                    column: :house_district_district,
                    primary_key: :district
  end
end
