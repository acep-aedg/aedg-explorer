class CreateFeatureFlags < ActiveRecord::Migration[8.0]
  def change
    create_table :feature_flags do |t|
      t.string :name, null: false
      t.string :state, null: false, default: 'disabled'

      t.timestamps
    end

    add_index :feature_flags, :name, unique: true
  end
end
