class ChangePceReportingIdToBeStringInPlants < ActiveRecord::Migration[8.0]
  def up
    change_column :plants, :pce_reporting_id, :string, using: 'pce_reporting_id::varchar'
  end

  def down
    change_column :plants, :pce_reporting_id, :integer, using: 'pce_reporting_id::integer'
  end
end
