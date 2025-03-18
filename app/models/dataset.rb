class Dataset < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
  validates :data, presence: true

  belongs_to :metadatum

  store_accessor :data, :title, :description, :resources, :topics, 
                        :path, :keywords, :publicationDate, :spatial, 
                        :format, :schema

end
