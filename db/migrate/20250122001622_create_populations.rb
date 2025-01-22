class CreatePopulations < ActiveRecord::Migration[7.1]
  def change
    create_table :populations do |t|
      t.string :fips_code
      t.integer :population

      t.timestamps
    end
    
    add_foreign_key :populations, :communities, column: :fips_code, primary_key: :fips_code
    add_index :populations, :fips_code, unique: true
  end
end
