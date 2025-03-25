module Communities::ChartsHelper
  # structured for chartkick
  def employment_chart_data(employments)
    [
      {
        name: "Residents Employed",
        data: employments.map { |e| [e.measurement_year, e.residents_employed] }
      },
      {
        name: "Unemployment Insurance Claimants",
        data: employments.map { |e| [e.measurement_year, e.unemployment_insurance_claimants] }
      }
    ]
  end

  def yearly_generation_chart_data(generations)
    [
      {
        name: "Net Generation (MWh)",
        data: generations.transform_keys(&:to_s)
      }
    ]
  end
end
