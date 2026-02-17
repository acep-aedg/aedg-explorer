module Facetable
  extend ActiveSupport::Concern

  class_methods do
    def filter_by_params(params, search_key, alpha_key, sort_col)
      # arel_table works on the class level to safely reference columns
      column = arel_table[sort_col]
      query = reorder(sort_col => :asc)

      query = query.where(column.matches("%#{params[search_key]}%")) if params[search_key].present?

      query = query.where(column.matches("#{params[alpha_key]}%")) if params[alpha_key].present?

      query
    end
  end
end
