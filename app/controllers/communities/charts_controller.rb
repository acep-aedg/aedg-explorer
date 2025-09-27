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
    latest_year = YearlyGeneration.latest_year_for(@community.grid)
    records = YearlyGeneration.for_grid_and_year(@community.grid, latest_year)
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
    years   = @community.capacities.available_years
    year    = params[:year].presence&.to_i || years.first
    records = @community.capacities.where(year: year)
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

  def population_employment
    employments = @community.employments.sort_by(&:measurement_year)
    render json: employment_chart_data(employments)
  end

  def average_sales_rates
    sales = @community.reporting_entity.sales.order(year: :asc)
    dataset = sales.map do |sale|
      values = {
        'Residential' => sale.residential_rate,
        'Commercial' => sale.commercial_rate,
        'Total' => sale.total_rate
      }.transform_values { |v| v&.to_f&.round(2) }

      { name: sale.year.to_s, data: values }
    end

    render json: dataset
  end

  def revenue_by_customer_type
    sale = @community.reporting_entity.latest_sale
    return render json: {} unless sale

    render json: {
      'Residential' => sale.residential_revenue,
      'Commercial' => sale.commercial_revenue
    }
  end

  def customers_by_customer_type
    sale = @community.reporting_entity.latest_sale
    return render json: {} unless sale

    render json: {
      'Residential' => sale.residential_customers,
      'Commercial' => sale.commercial_customers
    }
  end

  def sales_by_customer_type
    sale = @community.reporting_entity.latest_sale
    return render json: {} unless sale

    render json: {
      'Residential' => sale.residential_sales,
      'Commercial' => sale.commercial_sales
    }
  end

  # Figure out if we can utilize this method from CommunitiesController instead of duplicating it here
  private

  def set_community
    @community = Community.friendly.find(params[:community_id])
  end
end
