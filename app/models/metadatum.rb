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
                      tsvector_column: "tsvector_data"
                    },
                    tsearch: {
                      dictionary: "english",
                      tsvector_column: "tsvector_data"
                    },
                    trigram: {

                    }
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

  def publicationDate
  end

  def related
  end

  def self.import_metadata(path)
    Rails.logger.debug "Importing metadata from #{path}..."
    Dir.glob("#{path}/*.json").each do |file|
      begin
        data = JSON.parse(File.read(file))
        find_or_initialize_by(name: data['name']).tap do |metadata|
          metadata.filename = File.basename(file)
          metadata.data = data
          metadata.published = true

          Rails.logger.debug "Imported metadata for #{metadata.name}"
          metadata.data['resources'].each do |resource|
            dataset = Dataset.import_resource(resource)
            metadata.keyword_list.add(dataset.keyword_list)
            metadata.topic_list.add(dataset.topic_list)
            metadata.format_list.add(dataset.format)
            metadata.datasets << dataset
          end

          metadata.save!
        end
      rescue StandardError => e
        Rails.logger.debug "Error processing metadata file #{file}: #{e.message}"
      end
    end
  end
end
