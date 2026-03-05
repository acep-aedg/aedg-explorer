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

    # find available starting characters
    def available_letters_for(column_name)
      # Security: quote_column_name makes the column name safe from injection
      safe_col = connection.quote_column_name(column_name.to_s)
      
      where.not(column_name => nil)
        .reorder(nil)
        .pluck(Arel.sql("DISTINCT UPPER(LEFT(#{safe_col}::text, 1))"))
        .sort
    end
  end
end
