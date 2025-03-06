class CreateMonthlyGenerations < ActiveRecord::Migration[7.1]
  def change
    create_table :monthly_generations do |t|
      t.integer :grid_id
      t.decimal :net_generation_mwh
      t.string :fuel_type
      t.integer :year
      t.integer :month

      t.timestamps
    end
    add_foreign_key :monthly_generations, :grids
  end
end
