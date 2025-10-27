# app/controllers/searches_controller.rb
class SearchesController < ApplicationController
  def show
    @query = params[:q].to_s.strip
    @communities = Community.search(@query).limit(10)
  end

  def advanced
    @query  = params[:q].to_s.strip

    @grid_ids   = Array(params[:grid_ids]).reject(&:blank?)
    @boroughs   = Array(params[:borough_fips_codes]).reject(&:blank?)
    @corps      = Array(params[:regional_corporation_fips_codes]).reject(&:blank?)
    @senate_ids = Array(params[:senate_district_ids]).reject(&:blank?)
    @house_ids  = Array(params[:house_district_ids]).reject(&:blank?)

    @all_grids  = Grid.order(:name).select(:id, :name)
    @all_boros  = Borough.order(:name).select(:fips_code, :name)
    @all_corps  = RegionalCorporation.order(:name).select(:fips_code, :name)

    # Load full rows so we can build a label from whatever columns exist
    @all_senate = SenateDistrict.order(:id) # no .select(:id, :name)
    @all_house  = HouseDistrict.order(:id)  # no .select(:id, :name)

    scope = Community.includes(:borough, :regional_corporation, :grids)

    if @query.present?
      if ActiveRecord::Base.connection.adapter_name.downcase.include?("postgres")
        scope = scope.where("communities.name ILIKE ?", "%#{@query}%")
      else
        scope = scope.where("LOWER(communities.name) LIKE ?", "%#{@query.downcase}%")
      end
    end

    scope = scope.where(borough_fips_code: @boroughs) if @boroughs.any?
    scope = scope.where(regional_corporation_fips_code: @corps) if @corps.any?

    scope = scope.joins(:grids).where(grids: { id: @grid_ids }) if @grid_ids.any?
    scope = scope.joins(:senate_districts).where(senate_districts: { id: @senate_ids }) if @senate_ids.any?
    scope = scope.joins(:house_districts).where(house_districts: { id: @house_ids }) if @house_ids.any?

    @communities = scope.distinct.order(:name)
  end
end
