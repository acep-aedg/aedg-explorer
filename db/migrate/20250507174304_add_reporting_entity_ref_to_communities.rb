class AddReportingEntityRefToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_reference :communities, :reporting_entity, foreign_key: true
  end
end
