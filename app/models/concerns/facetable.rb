module Facetable
  extend ActiveSupport::Concern

  class_methods do
    def filter_by_params(params, search_key, alpha_key, sort_col = :name)
      results = reorder(sort_col => :asc)
      
      if params[search_key].present?
        results = results.where("#{table_name}.#{sort_col} ILIKE ?", "%#{params[search_key]}%")
      end

      if params[alpha_key].present?
        results = results.where("#{table_name}.#{sort_col} ILIKE ?", "#{params[alpha_key]}%")
      end

      results
    end
  end
end