class UpdateFuelTypeInMonthlyGenerations < ActiveRecord::Migration[8.0]
  def up
    add_column :monthly_generations, :fuel_type_code, :string
    add_column :monthly_generations, :fuel_type_name, :string

    execute 'UPDATE monthly_generations SET fuel_type_code = fuel_type;'

    remove_column :monthly_generations, :fuel_type
  end

  def down
    add_column :monthly_generations, :fuel_type, :string

    execute 'UPDATE monthly_generations SET fuel_type = fuel_type_code;'

    remove_column :monthly_generations, :fuel_type_code
    remove_column :monthly_generations, :fuel_type_name
  end
end
