module ChartHelpers
  extend ActiveSupport::Concern

  def generate_monthly_chart_data(community)
    grouped_data = community.grid.monthly_generations.group(:year, :month).sum(:net_generation_mwh)
    numeric_months = community.grid.monthly_generations.pluck(:month).uniq.sort
    labels = numeric_months.map { |month| Date::ABBR_MONTHNAMES[month] }

    dataset = {
      label: "Total Net Generation (MWh)",
      data: numeric_months.map { |month| grouped_data.select { |(_, m), _| m == month }.values.sum }
    }

    options = { responsive: true, maintainAspectRatio: false }

    { labels: labels, datasets: [dataset], options: options }
  end
end