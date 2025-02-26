class CreateTransportations < ActiveRecord::Migration[7.1]
  def change
    create_table :transportations do |t|
      t.string :community_fips_code, null: false
      t.boolean :airport
      t.boolean :harbor_dock
      t.boolean :state_ferry
      t.boolean :cargo_barge
      t.boolean :road_connection
      t.boolean :coastal
      t.boolean :road_or_ferry
      t.string :description
      t.date :as_of_date

      t.timestamps
    end
    add_index :transportations, :community_fips_code
    add_index :transportations, :as_of_date
    add_foreign_key :transportations, :communities, column: :community_fips_code, primary_key: :fips_code
  end
end
