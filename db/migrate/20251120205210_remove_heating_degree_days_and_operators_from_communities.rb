class RemoveHeatingDegreeDaysAndOperatorsFromCommunities < ActiveRecord::Migration[8.0]
  def up
    change_table :communities, bulk: true do |t|
      t.remove :heating_degree_days
      t.remove :operators
    end
  end

  def down
    change_table :communities, bulk: true do |t|
      t.integer :heating_degree_days
      t.string  :operators, array: true, default: []
    end
  end
end
