module Grids
  class ChartsController < ApplicationController
    before_action :set_grid

    def production_monthly
      grouped_data = @grid.monthly_generations.grouped_net_generation_by_year_month

      dataset = grouped_data.keys.map(&:first).uniq.sort.map do |year|
        monthly_data = (1..12).map do |month|
          [Date::ABBR_MONTHNAMES[month], grouped_data.fetch([year, month], 0)]
        end.to_h
        { name: year.to_s, data: monthly_data }
      end

      render json: dataset
    end

    def production_yearly
      years   = @grid.yearly_generations.available_years
      year    = params[:year].presence&.to_i || years.first
      records = @grid.yearly_generations.where(year: year)
      grouped = records.group_by(&:fuel_type_code)

      dataset = grouped.map do |code, rows|
        name  = rows.first.fuel_type_name
        label = name.present? ? "#{name} (#{code})" : code
        [label, rows.sum(&:net_generation_mwh)]
      end

      render json: {
        year: year,
        data: dataset.sort_by { |label, _| label }
      }
    end

    def capacity_yearly
      years = Capacity.available_years_for(@grid)
      year  = params[:year].presence&.to_i || years.first

      records = Capacity.for_owner_and_year(@grid, year)
      grouped = records.group_by(&:fuel_type_code)

      dataset = grouped.map do |code, rows|
        name  = rows.first.fuel_type_name
        label = name.present? ? "#{name} (#{code})" : code
        [label, rows.sum(&:capacity_mw)]
      end

      render json: {
        year: year,
        data: dataset.sort_by { |label, _| label }
      }
    end

    private

    def set_grid
      @grid = Grid.friendly.find(params[:grid_id])
    end
  end
end
