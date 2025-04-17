class Dataset < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_taggable_on :keywords
  acts_as_taggable_on :topics

  validates :name, presence: true, uniqueness: true
  validates :data, presence: true

  belongs_to :metadatum

  store_accessor :data, :title, :description, :resources,  
                        :path, :publicationDate, :spatial, 
                        :format, :schema

  def self.import_resource(json)
    Rails.logger.debug "Resource: #{json['name']}"
    find_or_initialize_by(name: json['name']).tap do |dataset|
      dataset.data = json
      dataset.keyword_list.add(json['keywords'])
      dataset.topic_list.add(json['topics'])
    end
  end

  def filename 
    [name, format.downcase].join('.')
  end
end
