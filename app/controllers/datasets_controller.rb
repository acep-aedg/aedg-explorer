class DatasetsController < ApplicationController

  def index
  end

  def show
  end

  def explore
    @communities_count = Community.count
  end

end
