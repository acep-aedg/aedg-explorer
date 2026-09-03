class CreateMonthlyElectricRates < ActiveRecord::Migration[8.0]
  def change
    create_table :monthly_electric_rates do |t|
      t.references :reporting_entity, null: false, foreign_key: true
      t.integer :year, null: false
      t.integer :month, null: false
      t.decimal :residential_rate
      t.decimal :residential_rate_subsidized
      t.decimal :commercial_rate
      t.decimal :industrial_rate
      t.decimal :transportation_rate
      t.decimal :community_rate
      t.decimal :other_rate
      t.decimal :total_rate
      t.string :source
      t.timestamps
    end
  end
end
