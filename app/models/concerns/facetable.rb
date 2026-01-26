module Facetable
  extend ActiveSupport::Concern

  included do
    scope :facet_search, ->(term) { where("name ILIKE ?", "%#{term}%") }
    scope :facet_alpha,  ->(char) { where("name ILIKE ?", "#{char}%") }
  end

  class_methods do
    def filter_by_params(params, search_key, alpha_key, sort_col = :name)
      results = order(sort_col)

      results = results.facet_search(params[search_key]) if params[search_key].present?

      results = results.facet_alpha(params[alpha_key]) if params[alpha_key].present?

      results
    end
  end
end
