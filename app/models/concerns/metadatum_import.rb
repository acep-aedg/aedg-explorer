module MetadatumImport
  extend ActiveSupport::Concern

  included do
    def import_attributes!(file, data)
      raise "Duplicate metadata name found for different import files, #{filename} != #{File.basename(file)}" if filename.present? && filename != File.basename(file)

      self.filename = File.basename(file)
      self.data = data
      self.published = true

      self.data['resources'].each do |resource|
        dataset = Dataset.import_resource(resource)
        keyword_list.add(dataset.keyword_list)
        topic_list.add(dataset.topic_list)
        format_list.add(dataset.format)
        datasets << dataset
      end

      save!
    end
  end

  class_methods do
    def import_metadata(path)
      errors = []

      Rails.logger.info "Importing metadata from #{path}..."
      Dir.glob("#{path}/*.json").each do |file|
        data = JSON.parse(File.read(file))
        find_or_initialize_by(name: data['name']).tap do |metadata|
          metadata.import_attributes!(file, data)
          Rails.logger.info "Imported metadata for #{metadata.name}"
        end
      rescue StandardError => e
        errors << "Error processing metadata file #{file}: #{e.message}"
      end

      errors
    end
  end
end
