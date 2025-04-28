class Metadatum < ApplicationRecord
  include MetadatumAttributes
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
end
