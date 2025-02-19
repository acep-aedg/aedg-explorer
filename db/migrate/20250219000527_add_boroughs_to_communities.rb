class AddBoroughsToCommunities < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :communities, :boroughs, column: :borough_fips_code, primary_key: :fips_code
  end
end
