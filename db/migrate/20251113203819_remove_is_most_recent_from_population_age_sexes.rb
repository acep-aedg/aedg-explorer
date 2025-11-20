class RemoveIsMostRecentFromPopulationAgeSexes < ActiveRecord::Migration[8.0]
  def change
    remove_index :population_age_sexes, :is_most_recent
    remove_column :population_age_sexes, :is_most_recent, :boolean
  end
end
