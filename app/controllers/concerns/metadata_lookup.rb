module MetadataLookup
  extend ActiveSupport::Concern

  included do
    helper_method :get_related_metadata
  end

  def get_related_metadata(slug)
    @related_metadata ||= {}
    @related_metadata[slug] ||= Metadatum.find_by(slug: slug)
  end
end
