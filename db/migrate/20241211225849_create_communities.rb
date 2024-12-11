class CreateCommunities < ActiveRecord::Migration[7.1]
  def change
    create_table :communities, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :name
      t.integer :incorporation_id
      t.string :incorporation
      t.decimal :latitude
      t.decimal :longitude
      t.string :global_uuid

      t.timestamps
    end
  end
end
