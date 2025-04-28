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

  has_many :datasets, dependent: :destroy

  default_scope { where(published: true) }

  scope :highlighted, -> { where(highlighted: true) }

  # Temp method until we implement finding related datasets
  def related
    []
  end
end
