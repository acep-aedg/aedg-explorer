class UpdatePlantsFields < ActiveRecord::Migration[8.0]
  def up
    change_table :plants, bulk: true do |t|
      t.rename :primary_voltage, :grid_primary_voltage_kv
      t.rename :primary_voltage2, :grid_primary_voltage_2_kv
      t.integer :pce_reporting_id
      t.remove :eia_reporting, :pce_reporting, :status
    end
  end

  def down
    change_table :plants, bulk: true do |t|
      t.rename :grid_primary_voltage_kv, :primary_voltage
      t.rename :grid_primary_voltage_2_kv, :primary_voltage2
      t.remove :pce_reporting_id
      t.boolean :eia_reporting
      t.boolean :pce_reporting
      t.string  :status
    end
  end
end
