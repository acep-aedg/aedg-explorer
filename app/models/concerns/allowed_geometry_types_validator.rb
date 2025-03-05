class AllowedGeometryTypesValidator < ActiveModel::EachValidator 
  def validate_each(record, attribute, value)
    return if options[:in].include?(value.geometry_type.type_name)

    record.errors.add(attribute, "must be one of #{options[:in].join(', ')}")
  end
end
