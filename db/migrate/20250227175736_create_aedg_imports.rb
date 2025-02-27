class CreateAedgImports < ActiveRecord::Migration[7.1]
  def change
    create_table :aedg_imports do |t|
      t.integer :aedg_id
      t.references :importable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
