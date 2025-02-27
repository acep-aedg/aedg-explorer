class AedgImport < ApplicationRecord
  belongs_to :importable, polymorphic: true
end
