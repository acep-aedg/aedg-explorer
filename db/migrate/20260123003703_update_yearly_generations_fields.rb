class UpdateYearlyGenerationsFields < ActiveRecord::Migration[8.0]
  def up
    rename_column :yearly_generations, :net_generation_mwh, :generation_mwh

    change_table :yearly_generations, bulk: true do |t|
      t.string  :physical_unit_label
      t.decimal :avg_pce_fuel_price
      t.decimal :quantity_consumed_in_physical_units_for_electric_generation
      t.decimal :quantity_consumed_for_electricity_mmbtu
      t.string  :source
    end
  end

  def down
    change_table :yearly_generations, bulk: true do |t|
      t.remove :physical_unit_label
      t.remove :avg_pce_fuel_price
      t.remove :quantity_consumed_in_physical_units_for_electric_generation
      t.remove :quantity_consumed_for_electricity_mmbtu
      t.remove :source
    end
    
    rename_column :yearly_generations, :generation_mwh, :net_generation_mwh
  end
end
