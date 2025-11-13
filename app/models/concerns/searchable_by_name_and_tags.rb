module SearchableByNameAndTags
  extend ActiveSupport::Concern

  included do
    include PgSearch::Model

    # Detect installed extensions (safe even during boot/rake)
    extensions = begin
      ActiveRecord::Base.connection.extensions
    rescue StandardError
      []
    end

    has_unaccent = extensions.include?('unaccent')
    has_trgm     = extensions.include?('pg_trgm')
    has_fuzzy    = extensions.include?('fuzzystrmatch') # dmetaphone()

    # Base config (always available)
    using_cfg = {
      tsearch: {
        dictionary: 'english',
        prefix: true,
        any_word: true
      }
    }
    using_cfg[:trigram]    = {} if has_trgm
    using_cfg[:dmetaphone] = {} if has_fuzzy

    # If this model's table has a precomputed vector, use it (metadatum)
    if column_names.include?('tsvector_data')
      using_cfg[:tsearch][:tsvector_column] = 'tsvector_data'
      if has_fuzzy
        using_cfg[:dmetaphone]                 ||= {}
        using_cfg[:dmetaphone][:tsvector_column] = 'tsvector_data'
      end
    end

    scope_options = {
      against: [:name],
      using: using_cfg
    }
    scope_options[:ignoring] = :accents if has_unaccent

    pg_search_scope(:search_text_fts, **scope_options)
  end
end
