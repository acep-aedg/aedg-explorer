class CreateDataPondVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :data_pond_versions do |t|
      t.string :current_version

      t.timestamps
    end

    add_index :data_pond_versions, :created_at
  end
end
