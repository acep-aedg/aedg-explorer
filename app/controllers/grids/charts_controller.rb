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
      latest_year = YearlyGeneration.latest_year_for(@grid)
      records = YearlyGeneration.for_grid_and_year(@grid, latest_year)
      grouped = records.group_by(&:fuel_type_code)
      dataset = grouped.map do |code, rows|
        name = rows.first.fuel_type_name
        label = name.present? ? "#{name} (#{code})" : code
        [label, rows.sum(&:net_generation_mwh)]
      end

      dataset = dataset.sort_by { |label, _| label }
      render json: dataset
    end

    def capacity_yearly
      latest_year = Capacity.latest_year_for(@grid)
      records = Capacity.for_grid_and_year(@grid, latest_year)
      grouped = records.group_by(&:fuel_type_code)

      dataset = grouped.map do |code, rows|
        name = rows.first.fuel_type_name
        label = name.present? ? "#{name} (#{code})" : code
        [label, rows.sum(&:capacity_mw)]
      end

      dataset = dataset.sort_by { |label, _| label }
      render json: dataset
    end

    private

    def set_grid
      @grid = Grid.find(params[:grid_id])
    end
  end
end
