class GroupedSummariesController < ApplicationController
  layout :determine_layout
  before_action :set_parent, except: %i[index]
  before_action :set_parents

  def index
    @search_params = search_params
    @query = @search_params[:q]
    @parents = @parents.search(@query) if @query.present?
    @parents = @parents.starts_with(@search_params[:letter]) if @search_params[:letter].present?
    @active_letters = @parents.first_letters
  end

  def show
    redirect_to polymorphic_path([:general, @parent]), status: :see_other
  end

  def general; end
  def power_generation; end
  def electric_rates_sales; end

  private

  # Implemented by subclasses
  def set_parent; end

  # Implemented by subclasses
  def set_parents; end

  def determine_layout
    action_name == "index" ? "application" : "grouped_summaries"
  end

  def search_params
    params.permit(:q, :letter, :page, :per_page)
  end

  helper_method :default_map_layer

  def default_map_layer
    "community-locations"
  end
end
