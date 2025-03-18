class Metadatum < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
 
  validates :name, presence: true, uniqueness: true
  validates :filename, presence: true
  validates :data, presence: true

  store_accessor :data, :title, :description, :resources

  has_many :datasets, dependent: :destroy
  
  default_scope { where(published: true) }

  def keywords
    datasets.map(&:keywords).flatten.uniq
  end

  def topics
    datasets.map(&:topics).flatten.uniq
  end

  def publicationDate 
    
  end

  def related

  end

  def self.import_metadata(path)
    puts "Importing metadata from #{path}..."
    Dir.glob("#{path}/*.json").each do |file|
      begin
        data = JSON.parse(File.read(file))
        Metadatum.find_or_create_by(name: data['name']) do |metadata|
          metadata.filename = File.basename(file)
          metadata.data = data
          metadata.published = true 

          puts "Imported metadata for #{metadata.name}"
          metadata.data['resources'].each do |resource|
            puts "Resource: #{resource['name']}"
            metadata.datasets.find_or_initialize_by(name: resource['name']) do |dataset|
              dataset.data = resource
            end
          end

          metadata.save!
        end
      rescue StandardError => e
        puts "Error processing metadata file #{file}: #{e.message}"
      end
    end
  end
end
