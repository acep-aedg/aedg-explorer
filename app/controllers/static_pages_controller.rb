class StaticPagesController < ApplicationController
  def home
    @communities = Community.all
    @query = params[:q].to_s.strip
    Rails.logger.debug "HOME QUERY PARAM => #{@query.inspect}"

    # Use LIKE for dev (SQLite) and ILIKE for Postgres
    adapter = ActiveRecord::Base.connection.adapter_name.downcase
    op = adapter.include?('postgres') ? 'ILIKE' : 'LIKE'

    @communities = if @query.present?
      Community.where("name #{op} ?", "%#{@query}%")
    else
      Community.none
    end
  end

  def about; end

  def user_guide
    @communities = Community.all
  end
end
