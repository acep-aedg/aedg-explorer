require_relative 'import_delete_helpers'

namespace :delete do
  desc "Delete all records from the MonthlyGeneration table"
  task monthly_generations: :environment do
    ImportDeleteHelpers.delete_records(MonthlyGeneration)
  end
end