class Metadatum < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_full_text,
                  against: [:name],
                  associated_against: {
                    keywords: [:name],
                    topics: [:name],
                    formats: [:name]
                  },
                  using: {
                    dmetaphone: {
                      tsvector_column: 'tsvector_data'
                    },
                    tsearch: {
                      dictionary: 'english',
                      tsvector_column: 'tsvector_data'
                    },
                    trigram: {}
                  }

  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_taggable_on :keywords
  acts_as_taggable_on :topics
  acts_as_taggable_on :formats

  validates :name, presence: true, uniqueness: true
  validates :filename, presence: true
  validates :data, presence: true

  store_accessor :data, :title, :description, :resources

  has_many :datasets, dependent: :destroy

  default_scope { where(published: true) }

  scope :highlighted, -> { where(highlighted: true) }

  # Temp method until we implement finding related datasets
  def related
    []
  end

  def self.import_metadata(path)
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
