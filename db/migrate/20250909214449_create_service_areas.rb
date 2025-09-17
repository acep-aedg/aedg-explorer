class CreateServiceAreas < ActiveRecord::Migration[8.0]
  def change
    create_table :service_areas do |t|
      t.integer :cpcn_id, null: false
      t.string  :name
      t.string  :certificate_url
      t.geometry :boundary
      t.timestamps
    end

    add_index :service_areas, :cpcn_id, unique: true
  end
end
