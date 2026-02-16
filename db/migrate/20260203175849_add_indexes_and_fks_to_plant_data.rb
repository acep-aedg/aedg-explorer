class AddIndexesAndFksToPlantData < ActiveRecord::Migration[8.0]
  def up
    # Delete the duplicated plant 97
    execute "DELETE FROM plants WHERE pce_reporting_id = '332620'"
    add_index :plants, :aea_plant_id, unique: true

    add_index :capacities, :aea_plant_id
    add_index :yearly_generations, :aea_plant_id
    add_index :monthly_generations, :aea_plant_id

    add_foreign_key :capacities, :plants, column: :aea_plant_id, primary_key: :aea_plant_id
    add_foreign_key :yearly_generations, :plants, column: :aea_plant_id, primary_key: :aea_plant_id
    add_foreign_key :monthly_generations, :plants, column: :aea_plant_id, primary_key: :aea_plant_id
  end

  def down
    remove_foreign_key :monthly_generations, :plants, column: :aea_plant_id
    remove_foreign_key :yearly_generations, :plants, column: :aea_plant_id
    remove_foreign_key :capacities, :plants, column: :aea_plant_id

    remove_index :monthly_generations, :aea_plant_id
    remove_index :yearly_generations, :aea_plant_id
    remove_index :capacities, :aea_plant_id

    remove_index :plants, :aea_plant_id
  end
end
