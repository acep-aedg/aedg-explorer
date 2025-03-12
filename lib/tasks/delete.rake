require_relative 'delete_helpers'

namespace :delete do
  desc "Clear monthly generation data"
  task monthly_generations: :environment do
    DeleteHelpers.delete_records(MonthlyGeneration)
  end

  desc "Clear employment data"
  task employments: :environment do
    DeleteHelpers.delete_records(Employment)
  end

  desc "Clear capacity data"
  task capacitys: :environment do
    DeleteHelpers.delete_records(Capacity)
  end
end
