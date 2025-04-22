class CreateCommunityGrids < ActiveRecord::Migration[7.1]
  def change
    create_table :community_grids do |t|
      t.string :community_fips_code, null: false
      t.references :grid, foreign_key: true

      t.integer :connection_year
      t.integer :termination_year

      t.timestamps
    end

    add_index :community_grids, %i[community_fips_code grid_id connection_year], unique: true
    add_foreign_key :community_grids, :communities, column: :community_fips_code, primary_key: :fips_code
  end
end
