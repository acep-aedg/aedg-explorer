module MetadatumAttributes
  extend ActiveSupport::Concern

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
