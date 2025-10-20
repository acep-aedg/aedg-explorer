module Charts
  extend ActiveSupport::Concern

  private

  # ---- Capacity (yearly) ----
  def capacity_yearly_for(owner)
    year = params[:year].presence&.to_i || Capacity.available_years_for(owner).first
    data = Capacity.dataset_by_fuel_for(owner, year)
    render json: { year:, data: data }
  end

  # ---- Production (monthly) ----
  def production_monthly_for(owner)
    render json: MonthlyGeneration.series_by_year(owner)
  end

  # ---- Production (yearly) ----
  def production_yearly_for(owner)
    year = params[:year].presence&.to_i || YearlyGeneration.available_years_for(owner).first
    data = YearlyGeneration.dataset_by_fuel_for(owner, year)
    render json: { year:, data: data }
  end
end
