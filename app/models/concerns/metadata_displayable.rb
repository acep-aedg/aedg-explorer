module MetadataDisplayable
  extend ActiveSupport::Concern

  def description?
    description&.present?
  end

  def publication_date?
    publicationDate&.present?
  end

  def topic_list?
    topic_list&.any?
  end

  def keywords?
    keywords&.any?
  end

  def format?
    format&.present?
  end

  def licenses?
    licenses&.any?
  end

  def contributors?
    contributors&.any?
  end

  def sources?
    sources&.any?
  end
end
