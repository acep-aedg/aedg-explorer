class Grid < ApplicationRecord
  include GridAttributes
  include ImportFinders
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  has_one :aedg_import, as: :importable
  has_many :community_grids
  has_many :communities, through: :community_grids
  has_many :yearly_generations
  has_many :monthly_generations
  has_many :capacities
  has_many :reporting_entities
  validates :name, presence: true, uniqueness: true

  def slug_candidates
    [
      :name
    ]
  end

  def active?
    community_grids.active.exists?
  end

  def inactive_year
    community_grids.inactive.maximum(:termination_year)
  end

  # --- Electricity Section ---
  def show_electricity_section?
    @show_electricity_section ||= show_production? || show_capacity?
  end

  def show_capacity?
    @show_capacity ||= capacities&.exists?
  end

  def show_production?
    @show_production ||= show_monthly_generation? || show_yearly_generation?
  end

  def show_yearly_generation?
    @show_yearly_generation ||= yearly_generations&.exists?
  end

  def show_monthly_generation?
    @show_monthly_generation ||= monthly_generations&.exists?
  end

  def utility_names(exclude: nil)
    query = reporting_entities
    query = query.where.not(name: exclude) if exclude.present?
    query.distinct.pluck(:name)
  end
end
