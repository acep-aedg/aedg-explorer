module DeleteHelpers
  def self.delete_records(model)
    puts "Deleting all records from the #{model.name} table..."

    deleted = model.destroy_all.size
    puts "Deleted #{deleted} records from #{model.name}"
  rescue StandardError => e
    puts "ERROR: Deletion failed - #{e.message}"
  end
end
