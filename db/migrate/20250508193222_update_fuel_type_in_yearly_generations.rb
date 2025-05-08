class UpdateFuelTypeInYearlyGenerations < ActiveRecord::Migration[8.0]
  def up
    change_table :yearly_generations, bulk: true do |t|
      t.string :fuel_type_code
      t.string :fuel_type_name
    end

    execute 'UPDATE yearly_generations SET fuel_type_code = fuel_type;'

    remove_column :yearly_generations, :fuel_type
  end

  def down
    add_column :yearly_generations, :fuel_type, :string

    execute 'UPDATE yearly_generations SET fuel_type = fuel_type_code;'

    change_table :yearly_generations, bulk: true do |t|
      t.remove :fuel_type_code
      t.remove :fuel_type_name
    end
  end
end
