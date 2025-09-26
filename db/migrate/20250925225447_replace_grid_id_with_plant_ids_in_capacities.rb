class ReplaceGridIdWithPlantIdsInCapacities < ActiveRecord::Migration[8.0]
  def up
    remove_column :capacities, :grid_id
    change_table :capacities, bulk: true do |t|
      t.integer :aea_plant_id
      t.integer :eia_plant_id
    end
  end

  def down
    add_column :capacities, :grid_id, :integer
    change_table :capacities, bulk: true do |t|
      t.remove :aea_plant_id
      t.remove :eia_plant_id
    end
  end
end
