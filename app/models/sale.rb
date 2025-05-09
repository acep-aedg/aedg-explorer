class Sale < ApplicationRecord
  include SaleAttributes
  belongs_to :reporting_entity
end
