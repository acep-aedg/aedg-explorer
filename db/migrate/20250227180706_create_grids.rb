class CreateGrids < ActiveRecord::Migration[7.1]
  def change
    create_table :grids do |t|
      t.string :name

      t.timestamps
    end
  end
end
