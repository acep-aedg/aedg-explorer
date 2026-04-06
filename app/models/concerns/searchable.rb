module Searchable
  extend ActiveSupport::Concern

  included do
    scope :starts_with, ->(letter) { where("name ILIKE ?", "#{letter}%") if letter.present? }
  end

  class_methods do
    def search_related(query)
      where("name ILIKE ?", "%#{query}%")
    end
  end
end
