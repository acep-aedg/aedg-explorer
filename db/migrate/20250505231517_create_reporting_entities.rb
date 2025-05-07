class CreateReportingEntities < ActiveRecord::Migration[8.0]
  def change
    create_table :reporting_entities do |t|
      t.string :utility_name
      t.integer :year
      t.references :grid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
