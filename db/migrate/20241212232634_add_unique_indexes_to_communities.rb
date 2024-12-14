class AddUniqueIndexesToCommunities < ActiveRecord::Migration[7.1]
  def change
    add_index :communities, :global_id, unique: true
    add_index :communities, :community_id, unique: true
    add_index :communities, :fips_code, unique: true
    add_index :communities, :ansi_code, unique: true
  end
end
