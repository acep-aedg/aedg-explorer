json.cache! [@community.cache_key_with_version], expires_in: 12.hours do
  raw_series = HouseholdIncome.stacked_income_series_for(@community.household_incomes)

  format_label = lambda do |raw_name|
    base  = raw_name.to_s.sub(/\Ae_household_inc_/, "")
    parts = base.split("_")

    if parts.length == 2 && parts.all? { |p| p.match?(/\A\d+\z/) }
      low  = number_with_delimiter(parts[0].to_i)
      high = number_with_delimiter(parts[1].to_i)
      "$#{low}–$#{high}"

    elsif parts.length == 2 && parts.first == "under" && parts.last.match?(/\A\d+\z/)
      amount = number_with_delimiter(parts.last.to_i)
      "< $#{amount}"

    elsif parts.length == 2 && parts.last == "plus" && parts.first.match?(/\A\d+\z/)
      amount = number_with_delimiter(parts.first.to_i)
      "$#{amount}+"

    else
      base.tr("_", " ").titleize
    end
  end

  json.array! raw_series do |series|
    json.name format_label.call(series[:name])
    json.data series[:data]
  end
end
