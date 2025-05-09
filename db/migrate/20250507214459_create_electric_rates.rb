class CreateElectricRates < ActiveRecord::Migration[8.0]
  def change
    create_table :electric_rates do |t|
      t.references :reporting_entity, null: false, foreign_key: true
      t.integer :year
      t.decimal :residential_rate
      t.decimal :commercial_rate
      t.decimal :industrial_rate
      t.timestamps
    end
  end
end
