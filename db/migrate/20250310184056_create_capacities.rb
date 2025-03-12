class CreateCapacities < ActiveRecord::Migration[7.1]
  def change
    create_table :capacities do |t|
      t.integer :grid_id
      t.float :capacity_mw
      t.string :fuel_type
      t.integer :year

      t.timestamps
    end
  end
end
