class UniqueAedgImportValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless AedgImport.exists?(aedg_id: value, importable_type: record.importable_type)
    
    record.errors.add(attribute, "is already assigned to #{record.importable_type} with aedg_id: #{value}")
  end
end