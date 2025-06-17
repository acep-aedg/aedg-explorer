class AddSchoolDistrictsToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :school_districts, :integer, array: true, default: []
  end
end
