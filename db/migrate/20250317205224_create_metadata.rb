class CreateMetadata < ActiveRecord::Migration[7.1]
  def change
    create_table :metadata do |t|
      t.string :name
      t.string :slug
      t.string :filename
      t.boolean :highlighted, default: false
      t.boolean :published, default: false
      t.jsonb :data

      t.timestamps
    end
  end
end
