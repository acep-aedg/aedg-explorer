class AddGnisCodeAndOtherFieldsToCommunities < ActiveRecord::Migration[7.1]
  def change
    add_column :communities, :gnis_code, :string
    add_index :communities, :gnis_code, unique: true
    add_column :communities, :puma_code, :string
    add_column :communities, :subsistence, :boolean
    add_column :communities, :economic_region, :string
  end
end
