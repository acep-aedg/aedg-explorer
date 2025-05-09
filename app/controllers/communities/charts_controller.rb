class Communities::ChartsController < ApplicationController
  include Communities::ChartsHelper
  before_action :set_community

  def production_monthly
    grouped_data = @community.grid.monthly_generations.grouped_net_generation_by_year_month

    dataset = grouped_data.keys.map(&:first).uniq.sort.map do |year|
      monthly_data = (1..12).map do |month|
        [Date::ABBR_MONTHNAMES[month], grouped_data.fetch([year, month], 0)]
      end.to_h
      { name: year.to_s, data: monthly_data }
    end

    render json: dataset
  end

  def production_yearly
    grouped_data = @community.grid.yearly_generations.grouped_net_generation_by_year
    dataset = grouped_data.map { |year, value| [year.to_s, value] }
    render json: dataset
  end

  def capacity_yearly
    latest_year = @community.grid.capacities.maximum(:year)

    # Get all matching records, not just the aggregate
    records = @community.grid.capacities.where(year: latest_year).select(:fuel_type_code, :fuel_type_name, :capacity_mw)
    grouped = records.group_by(&:fuel_type_code)

    dataset = grouped.map do |code, rows|
      name = rows.first.fuel_type_name
      label = name.present? ? "#{name} (#{code})" : code
      [label, rows.sum(&:capacity_mw)]
    end
    render json: dataset
  end

  def population_employment
    employments = @community.employments.sort_by(&:measurement_year)
    render json: employment_chart_data(employments)
  end

  def fuel_prices
    records = @community.fuel_prices.chronological
    render json: fuel_prices_chart_data(records)
  end

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end
