require "net/http"
require_relative "view_checker"

namespace :grid do
  desc "Check all grid tabs"
  task check_all: :environment do
    Rake::Task["grid:check_general"].invoke
    Rake::Task["grid:check_power_generation"].invoke
  end

  desc "Check General tab (allows redirects)"
  task check_general: :environment do
    ViewChecker.run_check(Grid.all, :general_grid_url)
  end

  desc "Check Power Generation"
  task check_power_generation: :environment do
    ViewChecker.run_check(Grid.all, :power_generation_grid_url, %w[200 303])
  end
end
