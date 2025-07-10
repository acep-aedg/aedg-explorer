class AddOperatorsToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :operators, :string, array: true, default: []
  end
end
