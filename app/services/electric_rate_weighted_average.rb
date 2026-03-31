class ElectricRateWeightedAverage
  RATE_TO_SALES_MAP = {
    residential_rate: :residential_sales_mwh,
    residential_rate_sub: :residential_sales_mwh,
    commercial_rate: :commercial_sales_mwh,
    industrial_rate: :industrial_sales_mwh,
    transportation_rate: :transportation_sales_mwh,
    community_rate: :community_sales_mwh,
    other_rate: :other_sales_mwh,
    total_rate: :total_sales_mwh
  }.freeze

  def self.call(records, year, rate_field)
    new(records, year, rate_field).calculate
  end

  def initialize(records, year, rate_field)
    @records = records
    @year = year.to_i
    @rate_field = rate_field.to_sym
    @sales_field = RATE_TO_SALES_MAP[@rate_field]
  end

  def calculate
    return fallback_average if @sales_field.nil?

    weighted_sum = 0.0
    total_weight = 0.0

    @records.each do |rate_record|
      rate_val = rate_record.public_send(@rate_field).to_f

      # Find sales for the matching year
      sales_rec = rate_record.reporting_entity&.yearly_sales&.find { |s| s.year == @year }
      weight = sales_rec&.public_send(@sales_field).to_f

      if weight.positive?
        weighted_sum += (rate_val * weight)
        total_weight += weight
      end
    end
    return fallback_average if total_weight.zero?

    (weighted_sum / total_weight).round(4).nonzero?
  end

  private

  def fallback_average
    values = @records.map { |r| r.public_send(@rate_field)&.to_f }.compact
    return nil if values.empty?

    (values.sum / values.size.to_f).round(4).nonzero?
  end
end
