class CreatePopulations < ActiveRecord::Migration[7.1]
  def change
    create_table :populations do |t|
      t.string :community_fips_code, null: false
      t.integer :total_population, null: false

      t.timestamps
    end
    add_index :populations, :community_fips_code, unique: true
    add_foreign_key :populations, :communities, column: :community_fips_code, primary_key: :fips_code
  end
end
