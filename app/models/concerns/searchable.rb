module Searchable
  extend ActiveSupport::Concern

  included do
    class_attribute :searchable_column, default: :name

    scope :starts_with, ->(letter) { where(arel_table[searchable_column].matches("#{letter}%")) if letter.present? }
  end

  class_methods do
    def search_related(query)
      where(arel_table[searchable_column].matches("%#{query}%"))
    end
  end
end
