class AedgImport < ApplicationRecord
  belongs_to :importable, polymorphic: true
  validates :aedg_id, unique_aedg_import: true
end
