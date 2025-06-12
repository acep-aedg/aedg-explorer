class AddVillageCorporationToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :village_corporation, :string
  end
end
