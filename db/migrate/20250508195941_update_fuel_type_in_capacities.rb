class UpdateFuelTypeInCapacities < ActiveRecord::Migration[8.0]
  def up
    add_column :capacities, :fuel_type_code, :string
    add_column :capacities, :fuel_type_name, :string

    execute 'UPDATE capacities SET fuel_type_code = fuel_type;'

    remove_column :capacities, :fuel_type
  end

  def down
    add_column :capacities, :fuel_type, :string

    execute 'UPDATE capacities SET fuel_type = fuel_type_code;'

    remove_column :capacities, :fuel_type_code
    remove_column :capacities, :fuel_type_name
  end
end
