# frozen_string_literal: true

module Charts
  extend ActiveSupport::Concern

  private

  # ---- Capacity (yearly) ----
  def capacity_yearly_for(owner)
    years = Capacity.available_years_for(owner)
    year  = params[:year].presence&.to_i || years.first

    records = Capacity.for_owner_and_year(owner, year)
    grouped = records.group_by(&:fuel_type_code)

    dataset = grouped.filter_map do |code, rows|
      capacities = rows.map(&:capacity_mw).compact
      next if capacities.empty?

      name  = rows.first.fuel_type_name
      label = name.present? ? "#{name} (#{code})" : code
      [label, capacities.sum]
    end

    render json: { year:, data: dataset.sort_by { |label, _| label } }
  end

  # ---- Production (monthly) ----
  def production_monthly_for(owner)
    grouped = owner.monthly_generations.grouped_net_generation_by_year_month
    years   = grouped.keys.map(&:first).uniq.sort

    dataset = years.map do |y|
      monthly = (1..12).map { |m|
        [Date::ABBR_MONTHNAMES[m], grouped.fetch([y, m], 0)]
      }.to_h
      { name: y.to_s, data: monthly }
    end

    render json: dataset
  end

  # ---- Production (yearly) ----
  def production_yearly_for(owner)
    years   = owner.yearly_generations.available_years
    year    = params[:year].presence&.to_i || years.first
    records = owner.yearly_generations.where(year: year)
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
end
