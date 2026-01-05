class ElectricRate < ApplicationRecord
  include ElectricRateAttributes
  belongs_to :reporting_entity, optional: true

  scope :most_recent, -> { order(year: :desc).limit(1) }

  def self.latest_residential
    where.not(residential_rate: nil).order(year: :desc).first
  end

  def self.latest_commercial
    where.not(commercial_rate: nil).order(year: :desc).first
  end

  def self.latest_industrial
    where.not(industrial_rate: nil).order(year: :desc).first
  end

  validates :year, presence: true
end
