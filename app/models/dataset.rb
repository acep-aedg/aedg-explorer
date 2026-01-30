require "zip"
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
                 :format, :schema, :sources, :licenses

  has_one_attached :archive

  def self.import_resource(json)
    Rails.logger.debug { "Resource: #{json['name']}" }
    find_or_initialize_by(name: json["name"]).tap do |dataset|
      dataset.data = json
      dataset.keyword_list.add(json["keywords"])
      dataset.topic_list.add(json["topics"])
    end
  end

  def attach_directory_as_zip(directory_path)
    return unless Dir.exist?(directory_path)

    compressed_stream = Zip::OutputStream.write_buffer do |zio|
      Dir.glob(File.join(directory_path, "**", "*")).each do |disk_file_path|
        next if File.directory?(disk_file_path)

        zip_entry_name = Pathname.new(disk_file_path).relative_path_from(Pathname.new(directory_path)).to_s

        zio.put_next_entry(zip_entry_name)
        zio.write File.read(disk_file_path)
      end
    end

    compressed_stream.rewind

    archive.attach(
      io: compressed_stream,
      filename: "#{name}.zip",
      content_type: "application/zip"
    )
  end

  def filename
    [name, format.downcase].join(".")
  end
end
