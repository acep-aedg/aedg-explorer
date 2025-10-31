class DataPondVersion < ApplicationRecord
  validates :current_version, presence: true

  def self.latest
    order(created_at: :desc).first
  end
end
