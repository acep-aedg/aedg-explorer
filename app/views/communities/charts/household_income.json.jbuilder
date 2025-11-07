# app/views/communities/charts/household_income.json.jbuilder
json.array! @stacked_data do |series|
  json.name series[:name]
  json.data series[:data]
end
