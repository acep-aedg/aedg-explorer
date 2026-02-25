module DeleteHelpers
  def self.delete_records(model)
    Rails.logger.info "Deleting all records from the #{model.name} table..."

    deleted = model.destroy_all.size
    Rails.logger.info "Deleted #{deleted} records from #{model.name}"
  rescue StandardError => e
    Rails.logger.error "ERROR: Deletion failed - #{e.message}"
  end
end
