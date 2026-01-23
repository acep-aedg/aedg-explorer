# app/controllers/shared/base_summaries_controller.rb
module Shared
  class BaseSummariesController < ApplicationController
    def capacity
      years = Capacity.available_years_for(owner)
      year  = params[:year].presence&.to_i || years.first
      stats = Capacity.capacity_stats_for(owner, year)
      render partial: "shared/capacity_summary", locals: { stats: stats }
    end

    def monthly_generation
      years = MonthlyGeneration.available_years_for(owner)
      year  = params[:year].presence&.to_i || years.first
      stats = MonthlyGeneration.generation_stats_for(owner, year)
      render partial: "shared/monthly_generation_summary", locals: { stats: stats }
    end

    private

    # child controllers must implement:
    def owner = raise NotImplementedError
  end
end
