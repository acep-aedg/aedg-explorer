module Searchable
  extend ActiveSupport::Concern

  included do
    class_attribute :searchable_column, default: :name

    scope :starts_with, ->(letter) { where("#{searchable_column} ILIKE ?", "#{letter}%") if letter.present? }
  end

  class_methods do
    def search_related(query)
      where("#{searchable_column} ILIKE ?", "%#{query}%")
    end
  end
end
