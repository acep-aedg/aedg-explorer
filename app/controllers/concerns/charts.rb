module Charts
  extend ActiveSupport::Concern

  private

  # ---- Capacity (yearly) ----
  def capacity_yearly_for(owner, year)
    { year: year, data: Capacity.dataset_by_fuel_for(owner, year) }
  end

  # ---- Production (monthly) ----
  def production_monthly_for(owner)
    MonthlyGeneration.series_by_year(owner)
  end

  # ---- Production (yearly) ----
  def production_yearly_for(owner, year)
    { year: year, data: YearlyGeneration.dataset_by_fuel_for(owner, year) }
  end
end
