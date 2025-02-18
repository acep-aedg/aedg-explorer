class AddLocationToCommunities < ActiveRecord::Migration[7.1]
  def change
    add_column :communities, :location, :st_point, geographic: true
    add_index :communities, :location, using: :gist
  end
end
