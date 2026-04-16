module Searchable
  extend ActiveSupport::Concern

  included do
    scope :starts_with, ->(letter) { where("name ilike ?", "#{letter}%") if letter.present? }

    include PgSearch::Model

    pg_search_scope :search,
                    against: :name,
                    using: {
                      tsearch: {
                        prefix: true
                      },
                      trigram: {
                        word_similarity: true
                      }
                    }
  end
end
