class RemoveReportingEntityFromCommunities < ActiveRecord::Migration[8.0]
  def change
    remove_reference :communities, :reporting_entity, foreign_key: true
  end
end
