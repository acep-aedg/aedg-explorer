#json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
json.labels @grouped.keys.map(&:to_s)

json.datasets @active_fields do |field|
  data = @grouped.map do |_year, records|
    val = records.first&.public_send(field)&.to_f
    val&.nonzero?
  end

  next if data.all?(&:nil?)

  base_color = ChartsHelper.sector_color(field)

  json.label           field.to_s.gsub("_rate", "").titleize
  json.data            data
  json.borderColor     base_color
  json.backgroundColor base_color.to_opaque(0.7)

end
  #end
