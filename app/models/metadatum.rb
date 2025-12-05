class Metadatum < ApplicationRecord
  include MetadatumImport
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

  has_one :dataset, dependent: :destroy

  default_scope { where(published: true) }

  scope :highlighted, -> { where(highlighted: true) }

  # Temp method until we implement finding related datasets
  def related
    []
  end

  def citation
    author = data.dig('resources', 0, 'context', 'publisher').presence || 'Unknown Author'
    title = data['title'].presence&.titleize || 'Untitled Dataset'
    publication_date = data.dig('resources', 0, 'publicationDate')
    publication_year = Date.parse(publication_date).year if publication_date.present?
    version = 'v3.0'
    access_date = Time.zone.today.strftime('%B %-d, %Y')
    base_url = 'https://akenergygateway.alaska.edu'
    path = Rails.application.routes.url_helpers.metadatum_path(self)
    dataset_url = "#{base_url}#{path}"
    # Format the citation chicago style
    "#{author}. *#{title}*. Version #{version}. Alaska Energy Data Gateway, #{publication_year}. #{dataset_url}. Accessed #{access_date}."
  end

  # Returns a hash that is cleaned of empty values and sorted for readability
  def cleaned_data
    # 1. Reject keys with blank values
    clean = data.reject { |_, v| v.blank? }

    # 2. Define which keys should appear at the top
    top_keys = %w[name title description]

    # 3. Sort the hash
    clean.sort_by { |k, _| top_keys.index(k) || 999 }.to_h
  end
end
