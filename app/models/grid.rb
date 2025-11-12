class Grid < ApplicationRecord
  include GridAttributes
  include ImportFinders
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  validates :name, presence: true, uniqueness: true
  has_one :aedg_import, as: :importable
  has_many :community_grids
  has_many :communities, through: :community_grids
  has_many :reporting_entities
  has_many :plants
  has_many :service_area_geoms, through: :plants
  has_many :service_areas, through: :service_area_geoms
  has_many :capacities, through: :plants
  has_many :yearly_generations, through: :plants
  has_many :monthly_generations, through: :plants

  scope :active, -> { joins(:community_grids).merge(CommunityGrid.active).distinct }

  def slug_candidates
    [
      :name
    ]
  end

  # --- Communities Section ---
  def show_communities_section?
    @show_communities_section ||= communities&.exists?
  end

  # --- Electricity Section ---
  def show_electricity_section?
    @show_electricity_section ||= show_production? || show_capacity? || show_utilities?
  end

  def show_utilities?
    @show_utilities ||= show_service_area_geoms?
  end

  def show_utility_map_layers?
    @show_utility_map_layers ||= show_service_area_geoms?
  end

  def show_service_area_geoms?
    @show_service_area_geoms ||= service_area_geoms&.exists?
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
  
  def show_plants?
    @show_plants ||= plants&.exists?
  end

  def utility_names(exclude: nil)
    query = reporting_entities
    query = query.where.not(name: exclude) if exclude.present?
    query.distinct.pluck(:name)
  end
end
