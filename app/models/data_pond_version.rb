class DataPondVersion < ApplicationRecord
  validates :current_version, presence: true

  scope :latest, -> { order(created_at: :desc).first }
end
