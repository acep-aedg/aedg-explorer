class CreateYearlyGenerations < ActiveRecord::Migration[7.1]
  def change
    create_table :yearly_generations do |t|
      t.integer :grid_id
      t.integer :net_generation_mwh
      t.string :fuel_type
      t.integer :year

      t.timestamps
    end
    add_index :yearly_generations, :year
    add_foreign_key :yearly_generations, :grids
  end
end
