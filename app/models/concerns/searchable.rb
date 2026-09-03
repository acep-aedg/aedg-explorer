module Searchable
  extend ActiveSupport::Concern

  included do
    scope :starts_with, ->(letter) { where("name ilike ?", "#{letter}%") if letter.present? }
    scope :name_results, -> { pluck(:name) }

    include PgSearch::Model

    pg_search_scope :search,
                    against: :name,
                    associated_against: {
                      communities: :name
                    },
                    using: {
                      tsearch: {
                        prefix: true
                      },
                      trigram: {
                        word_similarity: true
                      }
                    }
  end

  class_methods do
    def first_letters
      name_results.map { |n| n[0].upcase }.uniq.sort
    end
  end
end
