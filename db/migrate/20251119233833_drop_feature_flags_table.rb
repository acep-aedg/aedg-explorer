class DropFeatureFlagsTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :feature_flags
  end

  def down
    create_table :feature_flags do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.timestamps
    end

    add_index :feature_flags, :name, unique: true
  end
end
