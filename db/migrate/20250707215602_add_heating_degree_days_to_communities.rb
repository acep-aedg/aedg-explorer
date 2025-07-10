class AddHeatingDegreeDaysToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :heating_degree_days, :int
  end
end
