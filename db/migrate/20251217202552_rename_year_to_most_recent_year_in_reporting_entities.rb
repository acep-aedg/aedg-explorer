class RenameYearToMostRecentYearInReportingEntities < ActiveRecord::Migration[8.0]
  def change
    rename_column :reporting_entities, :year, :most_recent_year
  end
end
