class CreateCommunities < ActiveRecord::Migration[7.1]
  def change
    create_table :communities do |t|
      t.integer :fips_code
      t.string :name
      t.decimal :latitude
      t.decimal :longitude
      t.integer :ansi_code
      t.uuid :community_id
      t.uuid :global_id

      t.timestamps
    end
  end
end
