module Charts
  extend ActiveSupport::Concern

  private

  # ---- Capacity (yearly) ----
  def capacity_yearly_for(owner, year)
    Rails.cache.fetch(['charts', owner.cache_key_with_version, owner.capacities.cache_key_with_version, year], expires_in: 12.hours) do
      { year: year, data: Capacity.dataset_by_fuel_for(owner, year) }
    end
  end

  # ---- Production (monthly) ----
  def production_monthly_for(owner)
    Rails.cache.fetch(['charts', owner.cache_key_with_version, owner.monthly_generations.cache_key_with_version], expires_in: 12.hours) do
      MonthlyGeneration.series_by_year(owner)
    end
  end

  # ---- Production (yearly) ----
  def production_yearly_for(owner, year)
    Rails.cache.fetch(['charts', owner.cache_key_with_version, owner.yearly_generations.cache_key_with_version, year], expires_in: 12.hours) do
      { year: year, data: YearlyGeneration.dataset_by_fuel_for(owner, year) }
    end
  end
end
