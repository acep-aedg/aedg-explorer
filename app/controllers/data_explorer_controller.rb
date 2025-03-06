class DataExplorerController < ApplicationController
  def index
    @communities_count = Community.count
  end
end
