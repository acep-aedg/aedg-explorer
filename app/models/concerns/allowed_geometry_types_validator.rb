class AllowedGeometryTypesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return record.errors.add(attribute, "can't be blank") if value.blank?

    return record.errors.add(attribute, "is not a valid geometry object") unless value.respond_to?(:geometry_type)

    allowed_types = options[:in] || []
    type_name = value.geometry_type.type_name

    record.errors.add(attribute, "must be one of #{allowed_types.join(', ')}") unless allowed_types.include?(type_name)
  end
end
