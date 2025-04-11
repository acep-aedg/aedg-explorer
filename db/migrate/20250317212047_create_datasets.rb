class CreateDatasets < ActiveRecord::Migration[7.1]
  def change
    create_table :datasets do |t|
      t.string :name
      t.string :slug
      t.jsonb :data
      t.references :metadatum, null: false, foreign_key: true

      t.timestamps
    end
  end
end
