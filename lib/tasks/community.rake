require "net/http"
require_relative "community_helpers"

namespace :community do
  desc "Check all community tabs"
  task check_all: :environment do
    Rake::Task["community:check_general"].invoke
    Rake::Task["community:check_power_generation"].invoke
    Rake::Task["community:check_electric_rates_sales"].invoke
    Rake::Task["community:check_fuel"].invoke
    Rake::Task["community:check_demographics"].invoke
    Rake::Task["community:check_income"].invoke
  end

  desc "Check General tab (allows redirects)"
  task check_general: :environment do
    CommunityHelpers.run_check(:general_community_url, %w[200 303])
  end

  desc "Check Power Generation"
  task check_power_generation: :environment do
    CommunityHelpers.run_check(:power_generation_community_url)
  end

  desc "Check Electric Rates Sales"
  task check_electric_rates_sales: :environment do
    CommunityHelpers.run_check(:electric_rates_sales_community_url)
  end

  desc "Check Fuel"
  task check_fuel: :environment do
    CommunityHelpers.run_check(:fuel_community_url)
  end

  desc "Check Demographics"
  task check_demographics: :environment do
    CommunityHelpers.run_check(:demographics_community_url)
  end

  desc "Check Income"
  task check_income: :environment do
    CommunityHelpers.run_check(:income_community_url)
  end
end
