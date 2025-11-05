# locals: community:, sale:, key:, res_attr:, com_attr:
json.cache! ['charts', community.cache_key_with_version, sale.cache_key_with_version, key], expires_in: 12.hours do
  json.merge!({
                'Residential' => sale[res_attr],
                'Commercial' => sale[com_attr]
              })
end
