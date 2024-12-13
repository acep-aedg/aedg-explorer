class ChangeFipsCodeToStringInCommunities < ActiveRecord::Migration[7.1]
  def change
    change_column :communities, :fips_code, :string
  end
end
