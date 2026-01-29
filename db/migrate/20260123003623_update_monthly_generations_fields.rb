class UpdateMonthlyGenerationsFields < ActiveRecord::Migration[8.0]
  def up
      rename_column :monthly_generations, :net_generation_mwh, :generation_mwh
      change_table :monthly_generations, bulk: true do |t|
        t.string  :physical_unit_label
        t.decimal :pce_fuel_price
        t.decimal :quantity_consumed_in_physical_units_for_electric_generation
        t.decimal :quantity_consumed_for_electricity_mmbtu
        t.string  :source
      end
    end

    def down
      change_table :monthly_generations, bulk: true do |t|
        t.remove :physical_unit_label
        t.remove :pce_fuel_price
        t.remove :quantity_consumed_in_physical_units_for_electric_generation
        t.remove :quantity_consumed_for_electricity_mmbtu
        t.remove :source
      end
      rename_column :monthly_generations, :generation_mwh, :net_generation_mwh
    end
end
