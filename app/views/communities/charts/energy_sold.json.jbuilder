# app/views/communities/charts/energy_sold.json.jbuilder
json.cache! [@community.cache_key_with_version, @year], expires_in: 12.hours do
  if @sales.empty?
    json.array! []
  else
    has_breakdown = @sales.any? do |sale|
      sale.residential_sales.to_f.positive? || sale.commercial_sales.to_f.positive?
    end
  
    json.array! @sales do |sale|
      json.name sale.reporting_entity.name
  
      if has_breakdown
        json.data [
          ['Residential', sale.residential_sales.to_f],
          ['Commercial',  sale.commercial_sales.to_f]
        ]
      else
        json.data [
          ['Total', sale.total_sales.to_f]
        ]
      end
    end
  end
end